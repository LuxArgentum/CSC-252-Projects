/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical half adder.
 */
public class Sim2_HalfAdder {
    public RussWire a, b;           // inputs
    public RussWire sum, carry;     // outputs

    /**
     * Constructor for Sim2_HalfAdder.
     * Initializes the inputs and outputs.
     */
    public Sim2_HalfAdder() {
        a = new RussWire();
        b = new RussWire();
        sum = new RussWire();
        carry = new RussWire();
    }

    public void execute() {
        // sum = a XOR b
        sum.set(a.get() && !b.get() || !a.get() && b.get());
        // carry = a AND b
        carry.set(a.get() && b.get());
    }
}
