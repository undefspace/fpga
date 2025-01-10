module top(
    inout wire [17:10] lcd_dh,
    inout wire [8:1] lcd_dl,
    output wire lcd_csx,
    output wire lcd_dcx,
    output wire lcd_wrx,
    output wire lcd_rdx,
    output wire lcd_rsx,
    output wire lcd_csx,

    input wire xtal,
    input wire rst
);

wire display_slow_clk, display_fast_clk;
clkdiv #(.DIVIDER(10000)) disp_slow_div (.clk_in(xtal), .clk_out(display_slow_clk));
clkdiv #(.DIVIDER(2)) disp_fast_div (.clk_in(xtal), .clk_out(display_fast_clk));

ili9341 display (
    .dh(lcd_dh),
    .dl(lcd_dl),
    .csx(lcd_csx),
    .dcx(lcd_dcx),
    .wrx(lcd_wrx),
    .rdx(lcd_rdx),
    .rsx(lcd_rsx),
    .slow_clk(display_slow_clk),
    .fast_clk(display_fast_clk),
    .rst(rst)
);

endmodule
