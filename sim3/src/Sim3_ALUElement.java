import Logic.*;

/**
 * Sim3_ALUElement.java
 * <p></p>
 * This class is a simulator for the ALU element. It is a part of the ALU
 * simulator.
 * <p></p>
 * Author: Matthew Song
 */
public class Sim3_ALUElement {

    public RussWire[] aluOp;        // aluOp wires
    public RussWire bInvert;        // bInvert wire
    public RussWire a;              // a wire
    public RussWire b;              // b wire
    public RussWire carryIn;        // carryIn wire
    public RussWire less;           // less wire
    public RussWire result;         // result wire
    public RussWire addResult;      // addResult wire
    public RussWire carryOut;       // carryOut wire
    public Sim3_MUX_8by1 mux;       // mux
    public Sim2_FullAdder adder;    // adder
    private AND and;                // and
    private OR or;                  // or
    private XOR xor;                // xor

    /**
     * Constructor for Sim3_ALUElement
     */
    public Sim3_ALUElement() {

        aluOp = new RussWire[3];
        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire();
        }
        bInvert = new RussWire();
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();
        less = new RussWire();
        result = new RussWire();
        addResult = new RussWire();
        carryOut = new RussWire();
        mux = new Sim3_MUX_8by1();
        adder = new Sim2_FullAdder();
    }

    /**
     * When this is called, all the inputs to the element will be set except
     * for less. Your code must run the adder (including, of course, handling the
     * bInvert input), and must set the addResult and carryOut outputs. It must
     * not set the result output yet - because, at this point in time, the value of the
     * less input might not be known.
     */
    public void execute_pass1() {

        // aluOp
        mux.control[0].set(aluOp[0].get());
        mux.control[1].set(aluOp[1].get());
        mux.control[2].set(aluOp[2].get());

        // 0 = AND
        and.a.set(a.get());
        and.b.set(b.get());
        and.execute();
        mux.in[0].set(and.out.get());

        // 1 = OR
        or.a.set(a.get());
        or.b.set(b.get());
        or.execute();
        mux.in[1].set(or.out.get());

        // 2 = ADD

        adder.a = a;
        adder.b = b;
        adder.carryIn = carryIn;
        adder.execute();
        carryOut.set(adder.carryOut.get());
        addResult.set(adder.sum.get());
        mux.in[2].set(addResult.get());

        // 3 = LESS
        // LESS will be set in the next pass

        // 4 = XOR
        xor.a.set(a.get());
        xor.b.set(b.get());
        xor.execute();
        mux.in[4].set(xor.out.get());
    }

    /**
     * When this function is called, all of the inputs will be valid (including less),
     * and you must generate the result output.
     */
    public void execute_pass2() {

        // TODO: Depending on the value of mux, select the correct output
        // Now that LESS is set, figure out what to return
        mux.in[3].set(less.get());
        mux.execute();
        result = mux.out;
    }
}
