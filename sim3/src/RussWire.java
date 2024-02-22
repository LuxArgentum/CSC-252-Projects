public class RussWire {
    /* This exists to support the clockTick() functionality above; when
     * a clock tick happens, we forget all of the values on all of the
     * Logic.RussWire objects.  It's a global list of all Logic.RussWire's that were
     * ever created.
     *
     * This global list, of course, means that it is IMPOSSIBLE to garbage
     * collect any Logic.RussWire after it's been created.  This might be a
     * problem in a more "official" system, but it's perfectly ok in 252
     * Simulation projects, because in that case, the students are
     * supposed to create these objects *ONCE* (when the various parts are
     * created), and then never create anything again later.
     */
    static RussWire globalList = null;
    RussWire next;
    private boolean isSet;
    private boolean val;


    public RussWire() {
        this.isSet = false;

        this.next = RussWire.globalList;
        RussWire.globalList = this;
    }

    public static void clockTick() {
        RussWire cur = globalList;
        while (cur != null) {
            cur.isSet = false;
            cur = cur.next;
        }
    }

    public void set(boolean val) {
        if (this.isSet)
            throw new IllegalArgumentException("A Logic.RussWire was set multiple times.");

        this.val = val;
        this.isSet = true;
    }

    public boolean get() {
        if (!this.isSet)
            throw new IllegalArgumentException("A Logic.RussWire was read before it had been set.");
        return this.val;
    }

    public String toString() {
        if (!this.isSet)
            throw new IllegalArgumentException("A Logic.RussWire was read before it had been set.");

        if (this.get())
            return "true";
        else
            return "false";
    }
}
