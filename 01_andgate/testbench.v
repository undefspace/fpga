// Non-synthesizable module that lets us test our synthesizable `andgate` module.
// Goes though the 4 possible input combinations and records the trace to a VCD file
module testbench;

// A register functions like a variable. It's a logic circuit that:
//   - stores one more bits together,
//   - always outputs the stored bits,
//   - remembers a new value (provided at the input) when its clock input transitions from 0 to 1
//     (this transition is also called the rising edge)
reg a, b;

// A wire is just that: a wire, or a named signal with no memory
// This wire is not connected to any input, but it's still saved to the trace file
/* verilator lint_off UNUSEDSIGNAL */
wire q;

// Creates an instance of the `andgate` module called `my_andgate`. Its `a` input is connected to
// the output of our `a` register, likewise for `b`, and its `q` output is connected to our
// `q` wire.
andgate my_andgate(.a(a), .b(b), .q(q));

// `initial` blocks are executed when the simulation starts
initial begin
    // capture all signals
    $dumpfile("trace.vcd");
    $dumpvars();

    // go through all 4 combinations of two 1-bit values of `a` and `b`
    // when we change those values, `q` is also "recalculated" (for an explanation for why this is
    // not the correct term, look into `andgate.v`)
    a = 0; b = 0;   // Assign `a` and `b`
                    // I previously stated that our registers have a clock input that needs to be
                    // triggered in order for the register to remember the new value. While this is
                    // what's happening in the real world, Verilog abstracts this away for us by
                    // automatically figuring out what signal functions as the clock for any
                    // particular assignment. Here we're in non-synthesizable simulation code, and
                    // all this doesn't _really_ matter. You can think of this particular
                    // assignment as a normal variable assignment in sequential code.
    #5              // Wait 5 simulated picoseconds
    {a, b} = 2'b01; // `2'b01` is a 2-bit wide binary literal
                    // {a, b} is a concatenation (or deconcatenation) of signals
                    // In this case, it splits a 2-bit signal into two one-bit signals.
                    // This is a bit more expressive than what i did previously
    #5
    {a, b} = 2'b10;
    #5
    {a, b} = 2'b11;
    #5
    $finish();      // stop simulation
end

endmodule
