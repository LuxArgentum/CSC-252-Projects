import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class Sim3_ALUTest {

    @Test
    void testAND() {
        Sim3_ALU alu = new Sim3_ALU(2);
        alu.a[0].set(false);
        alu.a[1].set(false);
        alu.b[0].set(false);
        alu.b[1].set(false);
        alu.aluOp[0].set(false);
        alu.aluOp[1].set(false);
        alu.aluOp[2].set(false);
        alu.bNegate.set(false);
        alu.execute();
        assert (!alu.result[0].get());
        assert (!alu.result[1].get());
    }

    @Test
    void testOR() {
        Sim3_ALU alu = new Sim3_ALU(2);
        alu.a[0].set(true);
        alu.a[1].set(false);
        alu.b[0].set(false);
        alu.b[1].set(true);
        alu.aluOp[0].set(true);
        alu.aluOp[1].set(false);
        alu.aluOp[2].set(false);
        alu.bNegate.set(false);
        alu.execute();
        Assertions.assertTrue(alu.result[0].get());
        Assertions.assertTrue(alu.result[1].get());
    }

    @Test
    void testADD() {
        Sim3_ALU alu = new Sim3_ALU(2);
        alu.a[0].set(true);
        alu.a[1].set(false);
        alu.b[0].set(true);
        alu.b[1].set(false);
        alu.aluOp[0].set(false);
        alu.aluOp[1].set(true);
        alu.aluOp[2].set(false);
        alu.bNegate.set(false);
        alu.execute();
        Assertions.assertFalse(alu.result[0].get());
        Assertions.assertTrue(alu.result[1].get());
    }

    @Test
    void testLESS() {
        Sim3_ALU alu = new Sim3_ALU(2);
        alu.a[0].set(false);
        alu.a[1].set(true);
        alu.b[0].set(true);
        alu.b[1].set(false);
        alu.aluOp[0].set(true);
        alu.aluOp[1].set(true);
        alu.aluOp[2].set(false);
        alu.bNegate.set(false);
        alu.execute();
        Assertions.assertTrue(alu.result[0].get());
        Assertions.assertFalse(alu.result[1].get());
    }

    @Test
    void testXOR() {
        Sim3_ALU alu = new Sim3_ALU(2);
        alu.a[0].set(true);
        alu.a[1].set(false);
        alu.b[0].set(true);
        alu.b[1].set(false);
        alu.aluOp[0].set(false);
        alu.aluOp[1].set(false);
        alu.aluOp[2].set(true);
        alu.bNegate.set(false);
        alu.execute();
        Assertions.assertFalse(alu.result[0].get());
        Assertions.assertFalse(alu.result[1].get());
    }

    @Test
    void testNegate() {
        Sim3_ALU alu = new Sim3_ALU(4);
        alu.aluOp[0].set(false);
        alu.aluOp[1].set(true);
        alu.aluOp[2].set(false);
        alu.bNegate.set(true);

        alu.a[0].set(true);
        alu.a[1].set(false);
        alu.a[2].set(false);
        alu.a[3].set(false);
        alu.b[0].set(true);
        alu.b[1].set(true);
        alu.b[2].set(true);
        alu.b[3].set(true);

        alu.execute();

        assert (!alu.result[0].get());
        assert (alu.result[1].get());
        assert (!alu.result[2].get());
        assert (!alu.result[3].get());
    }

    @Test
    void check() {
        Sim3_MUX_8by1 mux = new Sim3_MUX_8by1();
        Sim3_ALUElement elem = new Sim3_ALUElement();
        Sim3_ALU alu = new Sim3_ALU(4);

        /* we just just check the various fields - just to see
         * if they exist.  This is *Logic.NOT* a logical test of any
         * of the functionality!
         */

        mux.control[0].set(false);
        mux.control[1].set(false);
        mux.control[2].set(true);
        mux.in[0].set(false);
        mux.in[1].set(false);
        mux.in[2].set(false);
        mux.in[3].set(false);
        mux.in[4].set(true);
        mux.in[5].set(false);
        mux.in[6].set(false);
        mux.in[7].set(false);
        mux.execute();
        System.out.printf("MUX: control=4 in={0,0,0,0,1,0,0,0} -> %s\n", mux.out.get());
        assert (mux.out.get());

        elem.aluOp[0].set(true);
        elem.aluOp[1].set(false);
        elem.aluOp[2].set(false);
        elem.bInvert.set(false);
        elem.a.set(true);
        elem.b.set(true);
        elem.carryIn.set(true);
        elem.less.set(true);
        elem.execute_pass1();
        elem.execute_pass2();
        System.out.printf("ALU Element: aluOp=1 bInvert=%s : a=%s b=%s carryIn=%s less=%s -> result=%s addResult=%s carryOut=%s\n", elem.bInvert.get(), elem.a.get(), elem.b.get(), elem.carryIn.get(), elem.less.get(), elem.result.get(), elem.addResult.get(), elem.carryOut.get());

        Assertions.assertTrue(elem.aluOp[0].get());
        Assertions.assertFalse(elem.aluOp[1].get());
        Assertions.assertFalse(elem.aluOp[2].get());
        Assertions.assertFalse(elem.bInvert.get());

        Assertions.assertTrue(elem.a.get());
        Assertions.assertTrue(elem.b.get());
        Assertions.assertTrue(elem.carryIn.get());
        Assertions.assertTrue(elem.less.get());
        Assertions.assertTrue(elem.result.get());
        Assertions.assertTrue(elem.addResult.get());
        Assertions.assertTrue(elem.carryOut.get());

        alu.aluOp[0].set(false);
        alu.aluOp[1].set(true);
        alu.aluOp[2].set(false);
        alu.bNegate.set(true);

        alu.a[0].set(true);
        alu.a[1].set(false);
        alu.a[2].set(false);
        alu.a[3].set(true);

        alu.b[0].set(true);
        alu.b[1].set(true);
        alu.b[2].set(true);
        alu.b[3].set(true);

        alu.execute();

        System.out.printf("ALU: aluOp=2 bNegate=1 : a=9 b=15 : result={[0]:%s,[1]:%s,[2]:%s,[3]:%s}\n", alu.result[0].get(), alu.result[1].get(), alu.result[2].get(), alu.result[3].get());

        assert (!alu.aluOp[0].get());
        assert (alu.aluOp[1].get());
        assert (!alu.aluOp[2].get());
        assert (alu.bNegate.get());
        assert (!alu.result[0].get());
        assert (alu.result[1].get());
        assert (!alu.result[2].get());
        assert (alu.result[3].get());
    }
}