/**
 * Sim3_ALU.java
 * <p></p>
 * This class is a simulator for the ALU. It is a part of the ALU
 * simulator.
 * <p></p>
 * Author: Matthew Song
 */
public class Sim3_ALU {

    // Instance variables
    private final int length;                 // the number of bits in the input and output wires
    private final Sim3_ALUElement[] element;  // the ALU elements
    // Inputs
    public RussWire[] a;                // a wires
    public RussWire[] b;                // b wires
    public RussWire[] aluOp;            // aluOp wires
    public RussWire bNegate;            // bNegate wire
    // Outputs
    public RussWire[] result;           // result wires


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
     * This method is called to simulate the behavior of the ALU.
     */
    public void execute() {

        // Setting carryIn for the first element
        // If bNegate is true, then carryIn is true
        // Otherwise, carryIn is false
        element[0].carryIn.set(bNegate.get());

        // Execute the ALU elements for pass 1
        for (int i = 1; i < length; i++) {
            element[i - 1].aluOp[0].set(aluOp[0].get());
            element[i - 1].aluOp[1].set(aluOp[1].get());
            element[i - 1].aluOp[2].set(aluOp[2].get());
            element[i - 1].bInvert.set(bNegate.get());
            element[i - 1].a.set(a[i - 1].get());
            element[i - 1].b.set(b[i - 1].get());
            element[i - 1].execute_pass1();
            element[i].carryIn.set(element[i - 1].carryOut.get());
        }

        // Execute the last ALU element for pass 1
        element[length - 1].aluOp[0].set(aluOp[0].get());
        element[length - 1].aluOp[1].set(aluOp[1].get());
        element[length - 1].aluOp[2].set(aluOp[2].get());
        element[length - 1].bInvert.set(bNegate.get());
        element[length - 1].a.set(a[length - 1].get());
        element[length - 1].b.set(b[length - 1].get());
        element[length - 1].execute_pass1();

        // Set the less wire for the first element
        element[0].less.set(element[length - 1].addResult.get());

        // Execute the first ALU element for pass 2
        element[0].execute_pass2();
        result[0].set(element[0].result.get());

        // Execute the rest of the ALU elements for pass 2
        for (int i = 1; i < length; i++) {
            element[i].less.set(false);
            element[i].execute_pass2();
            result[i].set(element[i].result.get());
        }
    }
}