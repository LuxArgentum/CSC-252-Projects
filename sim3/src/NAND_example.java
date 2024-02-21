public class NAND_example {
    // inputs
    public RussWire a, b;
    // outputs
    public RussWire out;
    // internal components
    public AND and;
    public NOT not;

    public NAND_example() {
        a = new RussWire();
        b = new RussWire();

        out = new RussWire();

        and = new AND();
        not = new NOT();
    }

    void execute() {
        // copy our inputs to the inputs of the Logic.AND gate
        and.a.set(a.get());
        and.b.set(b.get());

        // make the Logic.AND gate calculate the result
        and.execute();

        // copy the output from the Logic.AND gate to the input of
        // the Logic.NOT gate
        not.in.set(and.out.get());

        // execute the Logic.NOT gate
        not.execute();

        // copy the output bit
        out.set(not.out.get());
    }
}

