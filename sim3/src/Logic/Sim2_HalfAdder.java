package Logic;

/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical half adder.
 */
public class Sim2_HalfAdder implements PhysicalComponentSimulator {
    public RussWire a, b;           // inputs
    public RussWire sum, carry;     // outputs
    private final XOR xor;                // xor gate
    private final AND and;                // and gate

    /**
     * Constructor for Sim2_HalfAdder.
     * Initializes the inputs and outputs.
     */
    public Sim2_HalfAdder() {
        a = new RussWire();
        b = new RussWire();
        sum = new RussWire();
        carry = new RussWire();
        xor = new XOR();
        and = new AND();
    }

    @Override
    public void execute() {
        // sum = a XOR b
        xor.a = a;
        xor.b = b;
        xor.execute();
        sum.set(xor.out.get());
        // carry = a AND b
        and.a = a;
        and.b = b;
        and.execute();
        carry.set(and.out.get());
    }
}
