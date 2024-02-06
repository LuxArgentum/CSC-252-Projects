public class Sim2_AdderX {

    public RussWire[] a, b;           // inputs
    public RussWire[] sum;            // outputs
    public RussWire carryOut, overflow;            // output

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
    }

    public void execute() {
        return;
    }
}
