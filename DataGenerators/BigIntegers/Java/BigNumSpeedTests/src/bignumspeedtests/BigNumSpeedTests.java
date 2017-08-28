package bignumspeedtests;
import java.math.BigInteger;

public class BigNumSpeedTests
{
    static final int CITERATIONS = 30 * 1000 * 1000;
    
    public static int countDigits(BigInteger b)
    {
        double factor = Math.log(2) / Math.log(10);
        int digitCount = (int) (factor * b.bitLength()) + 1;
        if (BigInteger.TEN.pow(digitCount - 1).compareTo(b) > 0)
        {
            return digitCount - 1;
        }
        else
        {
            return digitCount;
        }
    }

    public static void test3()
    {
        BigInteger bigMax = BigInteger.TEN.pow(900);
        BigInteger t = BigInteger.ZERO;
        for (int i = 0; i < CITERATIONS; i++)
        {
            t = t.add(bigMax);
        }
        System.out.println("Value:            " + t);
        System.out.println("Number of digits: " + countDigits(t));
        System.out.println("Real digits:      " + t.toString().length());
    }

    public static void main(String[] args)
    {
        for (int i = 0; i < 3; i++)
        {
            System.out.format("BigInteger, %g iterations:\n", CITERATIONS + 0.0);
            long startTime = System.nanoTime();
            test3();
            long endTime = System.nanoTime();
            System.out.format("%8.3f s\n", (endTime - startTime) / 1e9);
            System.out.println();
        }
    }

}
