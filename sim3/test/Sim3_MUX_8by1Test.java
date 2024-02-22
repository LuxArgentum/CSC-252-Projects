import org.junit.jupiter.api.Assertions;

class Sim3_MUX_8by1Test {

    @org.junit.jupiter.api.Test
    void testMUX_0() {
        Sim3_MUX_8by1 mux = new Sim3_MUX_8by1();
        mux.control[0].set(false);
        mux.control[1].set(false);
        mux.control[2].set(false);
        for (int i = 0; i < 8; i++) {
            mux.in[i].set(i == 0);
        }
        mux.execute();
        Assertions.assertTrue(mux.out.get());
    }

    @org.junit.jupiter.api.Test
    void testMUX_1() {
        Sim3_MUX_8by1 mux = new Sim3_MUX_8by1();
        mux.control[0].set(false);
        mux.control[1].set(false);
        mux.control[2].set(true);
        for (int i = 0; i < 8; i++) {
            mux.in[i].set(i == 1);
        }
        mux.execute();
        Assertions.assertTrue(mux.out.get());
    }
}