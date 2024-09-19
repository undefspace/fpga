package MyCounter;

export IfcMyCounter(..);
export mkMyCounter;

interface IfcMyCounter#(type size);
    method Action increment();
    method Action decrement();
    method UInt#(size) read();
endinterface

module mkMyCounter#(UInt#(size) init)(IfcMyCounter#(size));
    Reg#(UInt#(size)) register <- mkReg(init);

    method Action increment();
        register <= register + 1;
    endmethod

    method Action decrement();
        register <= register - 1;
    endmethod

    method read();
        return register;
    endmethod
endmodule

endpackage
