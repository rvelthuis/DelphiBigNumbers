package factorialspeedtest;

import java.math.BigInteger;

public class FactorialSpeedTest
{
    static BigInteger factorial(int n)
    {
        BigInteger result = BigInteger.valueOf(n);
        while (n > 1)
        {
            n--;
            result = result.multiply(BigInteger.valueOf(n));
        }
        return result;
    }

    public static void main(String[] args)
    {
        long t = System.nanoTime();
        BigInteger b = factorial(200*1000);
        long t2 = System.nanoTime();
        System.out.println((t2-t) / 1e9);
        String s = b.toString();
        System.out.println(s.length());
        System.out.println(s);
    }
 
}
