module testbench;

/* verilator lint_off UNUSEDSIGNAL */

reg rst, clk;
wire [17:10] dh;
wire [8:1] dl;
wire csx;
wire dcx;
wire wrx;
wire rdx;
wire rsx;

ili9341 display(
    .dh(dh),
    .dl(dl),
    .csx(csx),
    .dcx(dcx),
    .wrx(wrx),
    .rdx(rdx),
    .rsx(rsx),
    .rst(rst),
    .clk(clk)
);

initial begin
    while(1) begin
        clk = !clk;
        #1;
    end
end

initial begin
    $dumpfile("trace.vcd");
    $dumpvars();

    rst = 1;
    #10;
    rst = 0;
    #1000;
    rst = 1;

    #10000;
    
    $finish();
end

endmodule
