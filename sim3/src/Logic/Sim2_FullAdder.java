package Logic;

/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical full adder.
 */
public class Sim2_FullAdder implements PhysicalComponentSimulator {

    public RussWire a, b, carryIn;                  // inputs
    public RussWire sum, carryOut;                  // outputs
    private final Sim2_HalfAdder halfAdder1;
    private final Sim2_HalfAdder halfAdder2;  // half adders
    private final OR or;                                  // or gate

    /**
     * Constructor for Sim2_FullAdder.
     * Initializes the inputs and outputs.
     */
    public Sim2_FullAdder() {
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();
        sum = new RussWire();
        carryOut = new RussWire();
        halfAdder1 = new Sim2_HalfAdder();
        halfAdder2 = new Sim2_HalfAdder();
        or = new OR();
    }

    @Override
    public void execute() {
        halfAdder1.a = a;
        halfAdder1.b = b;
        halfAdder1.execute();

        halfAdder2.a = halfAdder1.sum;
        halfAdder2.b = carryIn;
        halfAdder2.execute();

        sum.set(halfAdder2.sum.get());
        or.a = halfAdder1.carry;
        or.b = halfAdder2.carry;
        or.execute();
        carryOut.set(or.out.get());
    }
}
