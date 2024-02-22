/**
 * Author: Matthew Song
 * <p>
 * Purpose: Simulates a physical adder with x bits.
 */
public class Sim2_AdderX implements PhysicalComponentSimulator {

    private final int x;
    private final Sim2_HalfAdder halfAdder;       // half adder
    private final Sim2_FullAdder[] fullAdder;     // full adder
    private final AND and1;                       // and gate
    private final AND and2;                       // and gate
    private final AND and3;                       // and gate
    private final AND and4;                       // and gate
    private final NOT not1;                        // not gate
    private final NOT not2;                       // not gate
    private final NOT not3;                       // not gate
    private final NOT not4;                       // not gate
    private final OR or;                          // or gate
    private final OR or2;                         // or gate
    public RussWire[] a, b;                 // inputs
    public RussWire[] sum;                  // output
    public RussWire carryOut, overflow;     // outputs
    private boolean matchingSign;           // overflow condition
    private boolean matchingSignSum;        // overflow condition

    /**
     * Constructor for Sim2_AdderX.
     * Initializes the inputs and outputs.
     *
     * @param x the number of bits in the adder
     */
    public Sim2_AdderX(int x) {
        this.x = x;
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
        fullAdder = new Sim2_FullAdder[x];
        for (int i = 0; i < x; i++) {
            fullAdder[i] = new Sim2_FullAdder();
        }
        and1 = new AND();
        and2 = new AND();
        and3 = new AND();
        and4 = new AND();
        not1 = new NOT();
        not2 = new NOT();
        not3 = new NOT();
        not4 = new NOT();
        or = new OR();
        or2 = new OR();
    }

    @Override
    public void execute() {
        halfAdder.a = a[0];
        halfAdder.b = b[0];
        halfAdder.execute();
        sum[0].set(halfAdder.sum.get());
        fullAdder[0].carryOut = halfAdder.carry;

        for (int i = 1; i < a.length; i++) {
            fullAdder[i].carryIn = fullAdder[i - 1].carryOut;
            fullAdder[i].a = a[i];
            fullAdder[i].b = b[i];
            fullAdder[i].execute();
            sum[i].set(fullAdder[i].sum.get());
        }

        carryOut.set(fullAdder[x - 1].carryOut.get());

        and1.a.set(fullAdder[x - 1].a.get());
        and1.b.set(fullAdder[x - 1].b.get());
        and1.execute();

        not1.in.set(fullAdder[x - 1].a.get());
        not1.execute();
        not2.in.set(fullAdder[x - 1].b.get());
        not2.execute();

        and2.a.set(not1.out.get());
        and2.b.set(not2.out.get());
        and2.execute();

        or.a.set(and1.out.get());
        or.b.set(and2.out.get());
        or.execute();

        matchingSign = or.out.get();

        and3.a.set(fullAdder[x - 1].a.get());
        and3.b.set(fullAdder[x - 1].sum.get());
        and3.execute();

        not3.in.set(fullAdder[x - 1].a.get());
        not3.execute();
        not4.in.set(fullAdder[x - 1].sum.get());
        not4.execute();

        and4.a.set(not3.out.get());
        and4.b.set(not4.out.get());
        and4.execute();

        or2.a.set(and3.out.get());
        or2.b.set(and4.out.get());
        or2.execute();

        matchingSignSum = or2.out.get();

        overflow.set(matchingSign && !matchingSignSum);
    }
}
