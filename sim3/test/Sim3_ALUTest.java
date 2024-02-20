import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class Sim3_ALUTest {

    @Test
    void basicFunction() {
        Sim3_ALU alu = new Sim3_ALU(4);
        alu.a[0].set(false);
        alu.a[1].set(true);
        alu.a[2].set(false);
        alu.a[3].set(true);
        alu.b[0].set(true);
        alu.b[1].set(false);
        alu.b[2].set(true);
        alu.b[3].set(false);
        alu.aluOp[0].set(false);
        alu.aluOp[1].set(false);
        alu.aluOp[2].set(true);
        alu.bNegate.set(false);
        alu.execute();
        assertFalse(alu.result[0].get());
        assertTrue(alu.result[1].get());
        assertFalse(alu.result[2].get());
        assertTrue(alu.result[3].get());
    }
}