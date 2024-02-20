import Logic.PhysicalComponentSimulator;
import Logic.RussWire;

/**
 * Sim3_MUX_8by1.java
 * <p></p>
 * This class is a simulator for the 8-to-1 multiplexer. It is a part of the ALU
 * simulator.
 * <p></p>
 * Author: Matthew Song
 */
public class Sim3_MUX_8by1 {

    public RussWire[] control;      // The control wires are used to select one of the input lines.
    public RussWire[] in;           // The input lines.
    public RussWire out;            // The output line
    private boolean a;
    private boolean b;
    private boolean c;


    /**
     * The constructor initializes the control, in, and out wires.
     */
    public Sim3_MUX_8by1() {
        control = new RussWire[3];
        for (int i = 0; i < 3; i++) {
            control[i] = new RussWire();
        }
        in = new RussWire[8];
        out = new RussWire();
    }


    /**
     * This method is called to simulate the behavior of the multiplexer.
     * It selects one of the input lines based on the state of the control lines and forward that input to the output.
     */
    public void execute() {

        // TODO: Get the value of the control lines and use that to select the correct input line.
        // How do I do it without using if-else statements?
        // Sum of products
        a = control[0].get();
        b = control[1].get();
        c = control[2].get();

        out.set((!a & !b & !c & in[0].get()) | (!a & !b & c & in[1].get()) | (!a & b & !c & in[2].get()) |
                (!a & b & c & in[3].get()) | (a & !b & !c & in[4].get()) | (a & !b & c & in[5].get()) |
                (a & b & !c & in[6].get()) | (a & b & c & in[7].get()));
    }
}
