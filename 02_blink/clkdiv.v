// Divides the input clock by a constant amount
// A clock is a signal that goes up and down at a specific and steady rate.
module clkdiv#(
    // Parameters can be thought of as "const generics". They only exist at synthesis time.
    parameter DIVIDER = 2
)(
    input clk_in,
    // An "output reg" is syntactic sugar for something like the following:
    //
    //     module my_mod(output my_out);
    //         reg my_reg;
    //         assign my_out = my_reg;
    //     endmodule
    output reg clk_out
);

// A `localparam` is essentially a const value calculated at synthesis time
localparam RELOAD = (DIVIDER / 2) - 1;

// A 32-bit register which is initialized to `RELOAD`.
// Initialization occurs when the simulation starts, or (in the real world) when power is applied.
reg [31:0] counter = RELOAD;

// This "code" "runs" at the positive edge of `clk_in` (when it transitions from 0 to 1)
always @(posedge clk_in) begin
    if(counter == 0) begin
        // A <= is a non-blocking assignment. The following two lines "execute" simulateneously:
        clk_out <= ~clk_out; // toggle output
        counter <= RELOAD;   // re-initialize counter
    end else begin
        counter <= counter - 1; // count down
    end
end

// As you can see, Verilog allows us to think in terms of procedures, i.e. "code" getting
// "executed" when an "event" "happens". In the real world this is of course still just electrical
// impulses traveling though wires and transistors. The above could be implemented with a
// multiplexer functioning as the if statement, and the clock input of D-flip-flop, or DFF
// functioning the transition-sensitive part (as expressed by `always @`).

endmodule
