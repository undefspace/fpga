module top(
    input xtal,
    input [1:0] btn,
    output led
);

reg [31:0] divider = 10_000_000;
clkdiv my_div (.divider(divider), .clk_in(xtal), .clk_out(led));

always @(negedge (btn[0] & btn[1])) begin
    if(~btn[0])
        divider <= divider + 1_000_000;
    else if(~btn[1])
        divider <= divider - 1_000_000;
end

endmodule
