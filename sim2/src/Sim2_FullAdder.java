/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical full adder.
 */
public class Sim2_FullAdder {

    public RussWire a, b, carryIn;      // inputs
    public RussWire sum, carryOut;      // outputs
    private Sim2_HalfAdder halfAdder1, halfAdder2; // half adders

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
    }

    public void execute() {
        halfAdder1.a = a;
        halfAdder1.b = b;
        halfAdder1.execute();

        halfAdder2.a = halfAdder1.sum;
        halfAdder2.b = carryIn;
        halfAdder2.execute();

        sum.set(halfAdder2.sum.get());
        carryOut.set(halfAdder1.carry.get() || halfAdder2.carry.get());

        // sum = (!a & !b & c) or (!a & b & !c) or (a & !b & !c) or (a & b & c)
//        sum.set((!a.get() && !b.get() && carryIn.get()) || (!a.get() && b.get() && !carryIn.get()) || (a.get() && !b.get() && !carryIn.get()) || (a.get() && b.get() && carryIn.get()));
        // carryOut = (!a & b & c) or (a & !b & c) or (a & b & !c) or (a & b & c)
//        carryOut.set((!a.get() && b.get() && carryIn.get()) || (a.get() && !b.get() && carryIn.get()) || (a.get() && b.get() && !carryIn.get()) || (a.get() && b.get() && carryIn.get()));
    }
}
