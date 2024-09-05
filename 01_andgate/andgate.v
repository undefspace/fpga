// To other modules, a module is a black box with an unspecified logic circuit inside.
// The box has well-defined named `input`s, `output`s and `inout`s (bidireectional signals).
module andgate(
    input a,
    input b,
    output q
);

// `assign` is essentially a continous assignment. If any of the signals that the expression
// depends on change, the output is recalculated.
// What I just described above is a nice sequential exmplanation for what's actually going on.
// In the real world, this would synthesize into an AND gate which has no notion of time
// or "(re-)calculation" based on any events. It's just signals propagating though wires,
// transistors and other basic electronic compopnents.
assign q = a & b;

endmodule
