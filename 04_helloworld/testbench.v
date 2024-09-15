module testbench();

reg clk, start;
/* verilator lint_off UNUSEDSIGNAL */
wire tx, idle;

wire [7:0] address;
reg [111:0] message = "Hello, World!\0";
wire [7:0] data;
assign data = message[(12 - address) * 8 +: 8];

uart_tx my_uart(
    .address(address),
    .data(data),
    .clk(clk),
    .start(start),
    .tx(tx),
    .idle(idle)
);

initial begin
    clk = 0;
    forever #2 clk = ~clk;
end

initial begin
    $dumpfile("trace.vcd");
    $dumpvars();

    start = 0;

    #9;
    start = 1;
    #100;
    start = 0;

    #5000;
    $finish();
end

endmodule
