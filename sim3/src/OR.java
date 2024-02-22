public class OR {
    // inputs
    public RussWire a, b;
    // outputs
    public RussWire out;

    public OR() {
        a = new RussWire();
        b = new RussWire();
        out = new RussWire();
    }

    public void execute() {
        boolean a_val = a.get();
        boolean b_val = b.get();
        out.set(a_val | b_val);
    }
}

