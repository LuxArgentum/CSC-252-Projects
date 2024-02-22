public class NOT {
    // inputs
    public RussWire in;
    // outputs
    public RussWire out;

    public NOT() {
        // the constructor for an object has to create all of the
        // Logic.RussWire objects to represent the inputs and outputs
        // of the object.
        in = new RussWire();
        out = new RussWire();
    }

    public void execute() {
        out.set(!in.get());
    }
}

