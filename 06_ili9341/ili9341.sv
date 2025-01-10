module ili9341(
    inout wire [17:10] dh,
    inout wire [8:1] dl,
    output reg csx,
    output reg dcx,
    output wire wrx,
    output wire rdx,
    output wire rsx,

    input slow_clk, // 2.7 kHz MAX
    input fast_clk, // 27 MHz working fine
    input rst
);

/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off WIDTHTRUNC */

enum {
    clk_sel_slow,
    clk_sel_fast
} clk_sel = clk_sel_fast;
wire clk;
assign clk = (clk_sel == clk_sel_slow) ? slow_clk : fast_clk;

reg [15:0] dout;
wire [15:0] din;
reg out;

assign dh = out ? dout[15:8] : 8'hzz;
assign dl = out ? dout[7:0] : 8'hzz;
assign din = {dh, dl};

// `define INIT_SEQ_LEN 128
`define INIT_SEQ_LEN 93
reg [7:0] INIT_SEQ [(`INIT_SEQ_LEN - 1) : 0] = '{
    // 8'hEF, 8'd3, 8'h03, 8'h80, 8'h02,
    // 8'hCF, 8'd3, 8'h00, 8'hC1, 8'h30,
    // 8'hED, 8'd4, 8'h64, 8'h03, 8'h12, 8'h81,
    // 8'hE8, 8'd3, 8'h85, 8'h00, 8'h78,
    // 8'hCB, 8'd5, 8'h39, 8'h2C, 8'h00, 8'h34, 8'h02,
    // 8'hF7, 8'd1, 8'h20,
    // 8'hEA, 8'd2, 8'h00, 8'h00,
    8'hC0, 8'd1, 8'h23,                     // Power control VRH[5:0]
    8'hC1, 8'd1, 8'h10,                     // Power control SAP[2:0];BT[3:0]
    8'hC5, 8'd2, 8'h3e, 8'h28,              // VCM control
    8'hC7, 8'd1, 8'h86,                     // VCM control2
    8'h37, 8'd1, 8'h00,                     // Vertical scroll zero
    8'h3A, 8'd1, 8'h55,                     // Pixel Format: 16 bits
    8'hB1, 8'd2, 8'h00, 8'h18,              // Frame Rate Control
    8'hB6, 8'd3, 8'h08, 8'h82, 8'h27,       // Display Function Control
    8'hF2, 8'd1, 8'h00,                     // 3Gamma Function Disable
    8'h26, 8'd1, 8'h01,                     // Gamma curve selected
    8'hE0, 8'd15, 8'h0F, 8'h31, 8'h2B, 8'h0C, 8'h0E, 8'h08, 8'h4E, 8'hF1, 8'h37, 8'h07, 8'h10, 8'h03, 8'h0E, 8'h09, 8'h00, // Set + Gamma
    8'hE1, 8'd15, 8'h00, 8'h0E, 8'h14, 8'h03, 8'h11, 8'h07, 8'h31, 8'hC1, 8'h48, 8'h08, 8'h0F, 8'h0C, 8'h31, 8'h36, 8'h0F, // Set - Gamma
    8'h11, 8'd0,                            // Exit Sleep
    8'h29, 8'd0,                            // Display on
    8'h2A, 8'd4, 8'd0, 8'd0, 8'd0, 8'd239,  // CASET Columns 0-239
    8'h2B, 8'd4, 8'd0, 8'd0, 8'h01, 8'h3F,  // PASET Rows 0-319
    8'h36, 8'd1, 8'h48,                     // MADCTL Memory Access Control
    8'h2C, 8'd0                             // RAMWR Memory Write
};

enum {
    // initialization sequence
    state_reset = 0,
    state_cmd,
    state_datalen,
    state_data,
    // image
    state_image,
    state_idle
} state = state_reset;

`define HARD_RESET_CYCLES 3000 // (I missed you)
reg [15:0] timer = `HARD_RESET_CYCLES;
reg [7:0] cmd_pointer = 0;
reg [7:0] cmd = 0;
reg [7:0] cmd_params = 0;

wire [7:0] init_cmd;
assign init_cmd = INIT_SEQ[`INIT_SEQ_LEN - 1 - cmd_pointer];

assign rsx = state != state_reset;

enum {
    clk_to_nowhere,
    clk_to_rdx,
    clk_to_wrx
} clk_out = clk_to_nowhere;

assign wrx = (clk_out == clk_to_wrx) ? !clk : 1;
assign rdx = (clk_out == clk_to_rdx) ? !clk : 1;

reg [8:0] x_pos = 0;
reg [8:0] y_pos = 0;

always @(posedge clk) begin
    if(!rst) begin
        out <= 0;
        state <= state_reset;
        timer <= `HARD_RESET_CYCLES;
        cmd_pointer <= 0;
        cmd <= 0;
        cmd_params <= 0;
        clk_out <= clk_to_nowhere;
    end else begin
        case(state)
            state_reset: begin
                clk_sel <= clk_sel_fast;
                x_pos <= 0;
                y_pos <= 0;
                out <= 0;
                csx <= 1;
                timer <= timer - 1;
                if(timer == 0)
                    state <= state_cmd;
            end
            state_cmd: begin
                clk_sel <= clk_sel_slow;
                csx <= 1;
                out <= 0;
                clk_out <= clk_to_nowhere;
                if(cmd_pointer >= `INIT_SEQ_LEN) begin
                    state <= state_image;
                end else begin
                    cmd <= init_cmd;
                    cmd_pointer <= cmd_pointer + 1;
                    state <= state_datalen;
                end
            end
            state_datalen: begin
                dcx <= 0;
                dout <= {8'h00, cmd};
                csx <= 0;
                out <= 1;
                clk_out <= clk_to_wrx;
                cmd_params <= init_cmd;
                cmd_pointer <= cmd_pointer + 1;
                if(init_cmd > 0)
                    state <= state_data;
                else
                    state <= state_cmd;
            end
            state_data: begin
                dcx <= 1;
                dout <= {8'h00, init_cmd};
                cmd_pointer <= cmd_pointer + 1;
                if(cmd_params == 1) begin
                    state <= state_cmd;
                end else begin
                    cmd_params <= cmd_params - 1;
                end
            end
            state_image: begin
                clk_sel <= clk_sel_fast;
                csx <= 0;
                dcx <= 1;
                out <= 1;
                clk_out <= clk_to_wrx;

                dout <= {x_pos[5:1], y_pos[5:0], timer[6:2]};
                // dout <= 16'b10000_000000_00000;
                // if((x_pos < 10) && (y_pos < 10))
                //     dout <= 16'b11111_000000_00000;
                // else if((x_pos > 229) && (y_pos < 10))
                //     dout <= 16'b00000_111111_00000;
                // else if((x_pos < 10) && (y_pos > 309))
                //     dout <= 16'b00000_111111_11111;
                // else if((x_pos > 229) && (y_pos > 309))
                //     dout <= 16'b11111_000000_11111;
                // else
                //     dout <= 16'd0;

                if(x_pos == 239) begin
                    x_pos <= 0;
                    if(y_pos == 319) begin
                        if(timer >= 1000)
                            timer <= 0;
                        else
                            timer <= timer + 1;
                        y_pos <= 0;
                    end else
                        y_pos <= y_pos + 1;
                end else begin
                    x_pos <= x_pos + 1;
                end
            end
            state_idle: begin
                csx <= 1;
                out <= 0;
                clk_out <= clk_to_nowhere;
            end
        endcase
    end
end

endmodule
