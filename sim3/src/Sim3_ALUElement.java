/**
 * Sim3_ALUElement.java
 * <p></p>
 * This class is a simulator for the ALU element. It is a part of the ALU
 * simulator.
 * <p></p>
 * Author: Matthew Song
 */
public class Sim3_ALUElement {

    // Instance variables
    private final Sim3_MUX_8by1 mux;       // mux
    private final Sim2_FullAdder adder;    // adder
    private final AND and;                // and
    private final OR or;                  // or
    private final XOR xor;                // xor
    // Inputs
    public RussWire[] aluOp;        // aluOp wires
    public RussWire bInvert;        // bInvert wire
    public RussWire a;              // a wire
    public RussWire b;              // b wire
    public RussWire carryIn;        // carryIn wire
    // Outputs
    public RussWire less;           // less wire
    public RussWire result;         // result wire
    public RussWire addResult;      // addResult wire
    public RussWire carryOut;       // carryOut wire

    /**
     * Constructor for Sim3_ALUElement
     */
    public Sim3_ALUElement() {

        // Initialize the wires
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
        for (int i = 0; i < 8; i++) {
            mux.in[i] = new RussWire();
        }
        adder = new Sim2_FullAdder();
        and = new AND();
        or = new OR();
        xor = new XOR();
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

        // bInvert


        // 0 = AND
        and.a.set(a.get());
        and.b.set(b.get() && !bInvert.get() || !b.get() && bInvert.get());
        and.execute();
        mux.in[0].set(and.out.get());

        // 1 = OR
        or.a.set(a.get());
        or.b.set(b.get() && !bInvert.get() || !b.get() && bInvert.get());
        or.execute();
        mux.in[1].set(or.out.get());

        // 2 = ADD

        adder.a.set(a.get());
        adder.b.set(b.get() && !bInvert.get() || !b.get() && bInvert.get());
        adder.carryIn.set(carryIn.get());
        adder.execute();
        carryOut.set(adder.carryOut.get());
        addResult.set(adder.sum.get());
        mux.in[2].set(addResult.get());

        // 3 = LESS
        // LESS will be set in the next pass

        // 4 = XOR
        xor.a.set(a.get());
        xor.b.set(b.get() && !bInvert.get() || !b.get() && bInvert.get());
        xor.execute();
        mux.in[4].set(xor.out.get());

        // 5, 6, 7
        for (int i = 5; i < 8; i++) {
            mux.in[i].set(false);
        }
    }

    /**
     * When this function is called, all of the inputs will be valid (including less),
     * and you must generate the result output.
     */
    public void execute_pass2() {

        mux.in[3].set(less.get());
        mux.execute();
        result = mux.out;
    }
}
