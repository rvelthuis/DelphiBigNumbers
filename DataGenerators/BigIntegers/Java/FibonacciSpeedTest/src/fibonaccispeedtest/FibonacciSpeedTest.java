package fibonaccispeedtest;

import java.math.BigInteger;

public class FibonacciSpeedTest
{
    public static BigInteger fib(int n)
    {
        BigInteger prevprev = BigInteger.ZERO;
        BigInteger prev = BigInteger.ONE;
        BigInteger now = BigInteger.ZERO;
        for (; n >= 2; n--)
        {
            now = prevprev.add(prev);
            prevprev = prev;
            prev = now;
        }
        return now;
    }

    public static void main(String[] args)
    {
        long t = System.nanoTime();
        BigInteger f = fib(1000000);
        long t2 = System.nanoTime();
        System.out.println((t2-t) / 1e9);
        // System.out.println(f);
    }
    
}
