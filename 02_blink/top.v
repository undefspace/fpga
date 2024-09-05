// I feel like this module is quite self-explanatory.
module top(
    input xtal,
    output led
);

clkdiv #(.DIVIDER(10_000_000)) my_div (.clk_in(xtal), .clk_out(led));

endmodule
