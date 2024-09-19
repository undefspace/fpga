package Top;

import MyCounter::*;

interface IfcTop;
    (* always_ready, result="LEDS" *)
    method Bit#(6) leds;
endinterface

module mkTop((* port="BTNS" *) Bit#(2) btns, IfcTop top);
    IfcMyCounter#(6) counter <- mkMyCounter(0);
    Reg#(Bit#(2)) prev_btns <- mkReg(pack(2'b11));

    rule incr (btns[0] == 0 && prev_btns == 2'b11);
        counter.increment();
    endrule

    rule decr (btns[1] == 0 && prev_btns == 2'b11);
        counter.decrement();
    endrule

    rule upd (btns != prev_btns);
        prev_btns <= btns;
    endrule

    method leds;
        return ~pack(counter.read());
    endmethod
endmodule

endpackage
