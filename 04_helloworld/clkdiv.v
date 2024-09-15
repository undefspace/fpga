// This is the clock divider from `02_blink`
module clkdiv#(
    parameter DIVIDER = 2
)(
    input clk_in,
    output reg clk_out
);

localparam RELOAD = (DIVIDER / 2) - 1;

reg [31:0] counter = RELOAD;

always @(posedge clk_in) begin
    if(counter == 0) begin
        clk_out <= ~clk_out;
        counter <= RELOAD;
    end else begin
        counter <= counter - 1;
    end
end

endmodule
