import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

class Sim3_ALUElementTest {

    @Test
    void testElement_AND() {
        Sim3_ALUElement element = new Sim3_ALUElement();
        element.aluOp[0].set(false);
        element.aluOp[1].set(false);
        element.aluOp[2].set(false);
        element.a.set(true);
        element.b.set(true);
        element.carryIn.set(false);
        element.bInvert.set(false);
        element.less.set(false);
        element.execute_pass1();
        element.execute_pass2();
        Assertions.assertTrue(element.result.get());
    }

    @Test
    void testElement_OR() {
        Sim3_ALUElement element = new Sim3_ALUElement();
        element.aluOp[0].set(true);
        element.aluOp[1].set(false);
        element.aluOp[2].set(false);
        element.a.set(true);
        element.b.set(false);
        element.carryIn.set(false);
        element.bInvert.set(false);
        element.less.set(false);
        element.execute_pass1();
        element.execute_pass2();
        Assertions.assertTrue(element.result.get());
    }


    @Test
    void testElement_ADD() {
        Sim3_ALUElement element = new Sim3_ALUElement();
        element.aluOp[0].set(false);
        element.aluOp[1].set(true);
        element.aluOp[2].set(false);
        element.a.set(true);
        element.b.set(true);
        element.carryIn.set(false);
        element.bInvert.set(false);
        element.less.set(false);
        element.execute_pass1();
        element.execute_pass2();
        Assertions.assertFalse(element.result.get());
        Assertions.assertTrue(element.carryOut.get());
    }

    @Test
    void testElement_LESS() {
        Sim3_ALUElement element = new Sim3_ALUElement();
        element.aluOp[0].set(true);
        element.aluOp[1].set(true);
        element.aluOp[2].set(false);
        element.a.set(false);
        element.b.set(true);
        element.carryIn.set(false);
        element.bInvert.set(false);
        element.less.set(true);
        element.execute_pass1();
        element.execute_pass2();
        Assertions.assertTrue(element.result.get());
    }

    @Test
    void testElement_XOR() {
        Sim3_ALUElement element = new Sim3_ALUElement();
        element.aluOp[0].set(false);
        element.aluOp[1].set(false);
        element.aluOp[2].set(true);
        element.a.set(true);
        element.b.set(false);
        element.carryIn.set(false);
        element.bInvert.set(false);
        element.less.set(false);
        element.execute_pass1();
        element.execute_pass2();
        Assertions.assertTrue(element.result.get());
    }
}