import Logic.RussWire;

/**
 * Sim3_ALU.java
 * <p></p>
 * This class is a simulator for the ALU. It is a part of the ALU
 * simulator.
 * <p></p>
 * Author: Matthew Song
 */
public class Sim3_ALU {

    // Inputs
    public RussWire[] a;                // a wires
    public RussWire[] b;                // b wires
    public RussWire[] aluOp;            // aluOp wires
    public RussWire bNegate;            // bNegate wire

    // Outputs
    public RussWire[] result;           // result wires

    // Instance variables
    private int length;                 // the number of bits in the input and output wires
    private Sim3_ALUElement[] element;  // the ALU elements

    private RussWire carry;             // carry wire


    /**
     * Constructor for Sim3_ALU
     *
     * @param length the number of bits in the input and output wires
     */
    public Sim3_ALU(int length) {
        this.length = length;

        // Initialize the wires
        a = new RussWire[length];
        b = new RussWire[length];
        aluOp = new RussWire[3];
        bNegate = new RussWire();
        element = new Sim3_ALUElement[length];
        carry = new RussWire();
        result = new RussWire[length];

        // Initialize the inputs
        for (int j = 0; j < length; j++) {
            a[j] = new RussWire();
            b[j] = new RussWire();
        }

        // Initialize the aluOp wires
        for (int j = 0; j < 3; j++) {
            aluOp[j] = new RussWire();
        }

        // Initialize the ALU elements
        for (int j = 0; j < length; j++) {
            element[j] = new Sim3_ALUElement();
        }

        // Initialize the result wires
        for (int j = 0; j < length; j++) {
            result[j] = new RussWire();
        }
    }

    /**
     *
     */
    public void execute() {

        // TODO

        /*
        for (int i=0; i<X; i++) {

            ... feed the inputs into element[i] (except for LESS) ...

            ... call execute_pass1() on the element ...
        }

        ... copy the addResult output from the MSB to the LESS input of the LSB ...

        ... set the rest of the LESS inputs ...

        ... call execute_pass2() on every element, and copy to the result[] output ...
        */

        carry.set(false);

        for (int i = 0; i < length; i++) {
            element[i].aluOp[0].set(aluOp[0].get());
            element[i].aluOp[1].set(aluOp[1].get());
            element[i].aluOp[2].set(aluOp[2].get());
            element[i].bInvert.set(bNegate.get());
            element[i].a.set(a[i].get());
            element[i].b.set(b[i].get());
            element[i].carryIn.set(carry.get());
            element[i].execute_pass1();
            carry.set(element[i].carryOut.get());
        }

        element[0].less.set(element[length - 1].addResult.get());

        for (int i = 0; i < length; i++) {
            element[i].less.set(false);
            element[i].execute_pass2();
            result[i].set(element[i].result.get());
        }
    }
}