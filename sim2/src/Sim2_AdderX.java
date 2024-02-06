/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical adder with x bits.
 */
public class Sim2_AdderX {

    public RussWire[] a, b;                 // inputs
    public RussWire[] sum;                  // output
    public RussWire carryOut, overflow;     // outputs
    private Sim2_HalfAdder halfAdder;       // half adder
    private Sim2_FullAdder fullAdder;       // full adder

    /**
     * Constructor for Sim2_AdderX.
     * Initializes the inputs and outputs.
     *
     * @param x the number of bits in the adder
     */
    public Sim2_AdderX(int x) {
        a = new RussWire[x];
        b = new RussWire[x];
        sum = new RussWire[x];
        for (int i = 0; i < x; i++) {
            a[i] = new RussWire();
            b[i] = new RussWire();
            sum[i] = new RussWire();
        }
        carryOut = new RussWire();
        overflow = new RussWire();
        halfAdder = new Sim2_HalfAdder();
        fullAdder = new Sim2_FullAdder();
    }

    public void execute() {
        halfAdder.a = a[0];
        halfAdder.b = b[0];
        halfAdder.execute();
        sum[0].set(halfAdder.sum.get());
        fullAdder.carryIn = halfAdder.carry;

        for (int i = 1; i < a.length; i++) {
            fullAdder.a = a[i];
            fullAdder.b = b[i];
            fullAdder.execute();
            sum[i].set(fullAdder.sum.get());
            fullAdder.carryIn = fullAdder.carryOut;
        }

        carryOut.set(fullAdder.carryOut.get());
        overflow.set(fullAdder.carryOut.get());
    }
}
