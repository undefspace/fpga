module top(
    input xtal,
    input start,
    output tx,
    output idle
);

wire [7:0] address;
reg [119:0] message = "Hello, World!\n\0";
wire [7:0] data;
assign data = message[(14 - address) * 8 +: 8];

wire serial_ck;

clkdiv #(.DIVIDER(27_000_000 / 115200)) my_div (.clk_in(xtal), .clk_out(serial_ck));

uart_tx my_uart(
    .address(address),
    .data(data),
    .clk(serial_ck),
    .start(~start),
    .tx(tx),
    .idle(idle)
);

endmodule
