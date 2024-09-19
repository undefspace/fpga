import StmtFSM::*;
import MyCounter::*;

module mkTestbench();
    IfcMyCounter#(32) counter <- mkMyCounter(0);

    Stmt countsUp = (seq
        $dumpfile("trace.vcd");
        $dumpvars();
        $display("Hello, World!");
        counter.increment();
        counter.increment();
        counter.increment();
        $display("Counter is at", counter.read());
        counter.decrement();
        counter.decrement();
        counter.decrement();
        $display("Counter is at", counter.read());
        $finish(0);
    endseq);

    FSM test <- mkFSM(countsUp);

    Reg#(Bool) going <- mkReg(False);
    rule start(!going);
        going <= True;
        test.start();
    endrule
endmodule
