// This is like the clock divider from the previous example, but instead of the divider being a
// paramter, it's a signal, which effectively means that it can be changed at runtime.
module clkdiv(
    input [31:0] divider,
    input clk_in,
    output reg clk_out
);

reg [31:0] counter = 0;

always @(posedge clk_in) begin
    if(counter >= divider - 1) begin
        clk_out <= ~clk_out;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
