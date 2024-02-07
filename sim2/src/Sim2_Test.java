import org.junit.jupiter.api.Test;


class Sim2_Test {

    @Test
    void adderXNormal() {
        Sim2_AdderX adderNormal = new Sim2_AdderX(4);
        adderNormal.a[3].set(false);
        adderNormal.a[2].set(true);
        adderNormal.a[1].set(true);
        adderNormal.a[0].set(false);
        adderNormal.b[3].set(true);
        adderNormal.b[2].set(true);
        adderNormal.b[1].set(true);
        adderNormal.b[0].set(false);
        adderNormal.execute();
        System.out.println("Expected: AdderNormal(4): a=0110 b=1110 -> sum=0100 : true false");
        System.out.printf("Actual: AdderNormal(4): a=0110 b=1110 -> sum=%d%d%d%d : %s %s\n",
                adderNormal.sum[3].get() ? 1 : 0,
                adderNormal.sum[2].get() ? 1 : 0,
                adderNormal.sum[1].get() ? 1 : 0,
                adderNormal.sum[0].get() ? 1 : 0,
                adderNormal.carryOut.get(),
                adderNormal.overflow.get());
        assert (!adderNormal.sum[3].get());
        assert (adderNormal.sum[2].get());
        assert (!adderNormal.sum[1].get());
        assert (!adderNormal.sum[0].get());
        assert (adderNormal.carryOut.get());
        assert (!adderNormal.overflow.get());
    }

    @Test
    void adderXOverflow() {
        Sim2_AdderX adderOverflow = new Sim2_AdderX(4);
        adderOverflow.a[3].set(false);
        adderOverflow.a[2].set(true);
        adderOverflow.a[1].set(true);
        adderOverflow.a[0].set(true);
        adderOverflow.b[3].set(false);
        adderOverflow.b[2].set(false);
        adderOverflow.b[1].set(false);
        adderOverflow.b[0].set(true);
        adderOverflow.execute();
        System.out.println("Expected: AdderOverflow(4): a=0111 b=0001 -> sum=1000 : false true");
        System.out.printf("Actual: AdderOverflow(4): a=0111 b=0001 -> sum=%d%d%d%d : %s %s\n",
                adderOverflow.sum[3].get() ? 1 : 0,
                adderOverflow.sum[2].get() ? 1 : 0,
                adderOverflow.sum[1].get() ? 1 : 0,
                adderOverflow.sum[0].get() ? 1 : 0,
                adderOverflow.carryOut.get(),
                adderOverflow.overflow.get());
        assert (adderOverflow.sum[3].get());
        assert (!adderOverflow.sum[2].get());
        assert (!adderOverflow.sum[1].get());
        assert (!adderOverflow.sum[0].get());
        assert (!adderOverflow.carryOut.get());
        assert (adderOverflow.overflow.get());
    }

    @Test
    void adderXAddBiggerNegative() {
        Sim2_AdderX adderBiggerNegative = new Sim2_AdderX(4);
        adderBiggerNegative.a[3].set(false);
        adderBiggerNegative.a[2].set(false);
        adderBiggerNegative.a[1].set(false);
        adderBiggerNegative.a[0].set(true);
        adderBiggerNegative.b[3].set(true);
        adderBiggerNegative.b[2].set(false);
        adderBiggerNegative.b[1].set(false);
        adderBiggerNegative.b[0].set(false);
        adderBiggerNegative.execute();
        System.out.println("Expected: AdderBiggerNeg(4): a=0001 b=1000 -> sum=1001 : false false");
        System.out.printf("Actual: AdderBiggerNeg(4): a=0001 b=1000 -> sum=%d%d%d%d : %s %s\n",
                adderBiggerNegative.sum[3].get() ? 1 : 0,
                adderBiggerNegative.sum[2].get() ? 1 : 0,
                adderBiggerNegative.sum[1].get() ? 1 : 0,
                adderBiggerNegative.sum[0].get() ? 1 : 0,
                adderBiggerNegative.carryOut.get(),
                adderBiggerNegative.overflow.get());
        assert (adderBiggerNegative.sum[3].get());
        assert (!adderBiggerNegative.sum[2].get());
        assert (!adderBiggerNegative.sum[1].get());
        assert (adderBiggerNegative.sum[0].get());
        assert (!adderBiggerNegative.carryOut.get());
        assert (!adderBiggerNegative.overflow.get());
    }

    @Test
    void twoBitAdder() {
        // 2-bit adder
        Sim2_AdderX twoBitAdder = new Sim2_AdderX(2);
        twoBitAdder.a[1].set(false);
        twoBitAdder.a[0].set(true);
        twoBitAdder.b[1].set(false);
        twoBitAdder.b[0].set(false);
        twoBitAdder.execute();
        System.out.println("Expected: twoBitAdder(2): a=01 b=00 -> sum=01 : false false");
        System.out.printf("Actual: twoBitAdder(2): a=01 b=00 -> sum=%d%d : %s %s\n",
                twoBitAdder.sum[1].get() ? 1 : 0,
                twoBitAdder.sum[0].get() ? 1 : 0,
                twoBitAdder.carryOut.get(),
                twoBitAdder.overflow.get());
        assert (!twoBitAdder.sum[1].get());
        assert (twoBitAdder.sum[0].get());
        assert (!twoBitAdder.carryOut.get());
        assert (!twoBitAdder.overflow.get());
    }

    @Test
    void zeroInputAdder() {
        // 3-bit adder w/ zero input
        Sim2_AdderX zeroInputAdder = new Sim2_AdderX(3);
        zeroInputAdder.a[2].set(false);
        zeroInputAdder.a[1].set(false);
        zeroInputAdder.a[0].set(false);
        zeroInputAdder.b[2].set(false);
        zeroInputAdder.b[1].set(false);
        zeroInputAdder.b[0].set(false);
        zeroInputAdder.execute();
        System.out.println("Expected: zeroInputAdder(3): a=000 b=000 -> sum=000 : false false");
        System.out.printf("Actual: zeroInputAdder(3): a=000 b=000 -> sum=%d%d%d : %s %s\n",
                zeroInputAdder.sum[2].get() ? 1 : 0,
                zeroInputAdder.sum[1].get() ? 1 : 0,
                zeroInputAdder.sum[0].get() ? 1 : 0,
                zeroInputAdder.carryOut.get(),
                zeroInputAdder.overflow.get());
        assert (!zeroInputAdder.sum[2].get());
        assert (!zeroInputAdder.sum[1].get());
        assert (!zeroInputAdder.sum[0].get());
        assert (!zeroInputAdder.carryOut.get());
        assert (!zeroInputAdder.overflow.get());
    }

    @Test
    void maxValueAdder() {
        // 4-bit adder w/ max value input
        Sim2_AdderX maxValueAdder = new Sim2_AdderX(4);
        maxValueAdder.a[3].set(true);
        maxValueAdder.a[2].set(true);
        maxValueAdder.a[1].set(true);
        maxValueAdder.a[0].set(true);
        maxValueAdder.b[3].set(true);
        maxValueAdder.b[2].set(true);
        maxValueAdder.b[1].set(true);
        maxValueAdder.b[0].set(true);
        maxValueAdder.execute();
        System.out.println("Expected: maxValueAdder(4): a=1111 b=1111 -> sum=1110 : true false");
        System.out.printf("Actual: maxValueAdder(4): a=1111 b=1111 -> sum=%d%d%d%d : %s %s\n",
                maxValueAdder.sum[3].get() ? 1 : 0,
                maxValueAdder.sum[2].get() ? 1 : 0,
                maxValueAdder.sum[1].get() ? 1 : 0,
                maxValueAdder.sum[0].get() ? 1 : 0,
                maxValueAdder.carryOut.get(),
                maxValueAdder.overflow.get());
        assert (maxValueAdder.sum[3].get());
        assert (maxValueAdder.sum[2].get());
        assert (maxValueAdder.sum[1].get());
        assert (!maxValueAdder.sum[0].get());
        assert (maxValueAdder.carryOut.get());
        assert (!maxValueAdder.overflow.get());
    }

    @Test
    void noOverNoCarry() {
        Sim2_AdderX adder1 = new Sim2_AdderX(4);
        adder1.a[3].set(false);
        adder1.a[2].set(false);
        adder1.a[1].set(true);
        adder1.a[0].set(false);
        adder1.b[3].set(false);
        adder1.b[2].set(false);
        adder1.b[1].set(true);
        adder1.b[0].set(true);
        adder1.execute();
        System.out.println("Expected: AdderX(4): a=0010 b=0011 -> sum=0101 : false false");
        System.out.printf("Actual: AdderX(4): a=0010 b=0011 -> sum=%d%d%d%d : %s %s\n",
                adder1.sum[3].get() ? 1 : 0,
                adder1.sum[2].get() ? 1 : 0,
                adder1.sum[1].get() ? 1 : 0,
                adder1.sum[0].get() ? 1 : 0,
                adder1.carryOut.get(),
                adder1.overflow.get());
        assert (!adder1.sum[3].get());
        assert (adder1.sum[2].get());
        assert (!adder1.sum[1].get());
        assert (adder1.sum[0].get());
        assert (!adder1.carryOut.get());
        assert (!adder1.overflow.get());
    }

    @Test
    void OverflowNoCarry() {
        Sim2_AdderX adder2 = new Sim2_AdderX(4);
        adder2.a[3].set(false);
        adder2.a[2].set(true);
        adder2.a[1].set(false);
        adder2.a[0].set(true);
        adder2.b[3].set(false);
        adder2.b[2].set(true);
        adder2.b[1].set(false);
        adder2.b[0].set(false);
        adder2.execute();
        System.out.println("Expected: AdderX(4): a=0101 b=0100 -> sum=1001 : false true");
        System.out.printf("Actual: AdderX(4): a=0101 b=1000 -> sum=%d%d%d%d : %s %s\n",
                adder2.sum[3].get() ? 1 : 0,
                adder2.sum[2].get() ? 1 : 0,
                adder2.sum[1].get() ? 1 : 0,
                adder2.sum[0].get() ? 1 : 0,
                adder2.carryOut.get(),
                adder2.overflow.get());
        assert (adder2.sum[3].get());
        assert (!adder2.sum[2].get());
        assert (!adder2.sum[1].get());
        assert (adder2.sum[0].get());
        assert (!adder2.carryOut.get());
        assert (adder2.overflow.get());
    }
}