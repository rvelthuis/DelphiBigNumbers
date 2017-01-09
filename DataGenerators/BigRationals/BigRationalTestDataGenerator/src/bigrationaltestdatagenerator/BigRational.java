
/******************************************************************************
 *  Compilation:  javac BigRational.java
 *  Execution:    java BigRational
 *
 *  Immutable ADT for arbitrarily large Rational numbers. 
 * 
 *  Invariants
 *  ----------
 *   -  gcd(num, den) = 1, i.e., rational number is in reduced form
 *   -  den >= 1, i.e., the denominator is always a positive integer
 *   -  0/1 is the unique representation of zero
 *
 *  % java BigRational
 *  5/6
 *  1
 *  1/120000000
 *  1073741789/12
 *  1
 *  841/961
 *  -1/3
 *  0
 *  true
 *  Exception in thread "main" java.lang.ArithmeticException: Denominator is zero
 *
 * NOTE by Rudy Velthuis: 
 *   slightly modified (changed e.g. plus() to add(), etc.) for my tests
 ******************************************************************************/
package bigrationaltestdatagenerator;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;

public class BigRational implements Comparable<BigRational> 
{

    public final static BigRational ZERO = new BigRational(0);
    public final static BigRational ONETENTH = new BigRational(1, 10);
    public final static BigRational ONE = new BigRational(1);

    private BigInteger num;   // the numerator
    private BigInteger den;   // the denominator


    // create and initialize a new BigRational object
    public BigRational(int numerator, int denominator) {
        this(new BigInteger("" + numerator), new BigInteger("" + denominator));
    }

    // create and initialize a new BigRational object
    public BigRational(int numerator) {
        this(numerator, 1);
    }

    // create and initialize a new BigRational object from a string, e.g., "-343/1273"
    public BigRational(String s) {
        String[] tokens = s.split("/");
        if (tokens.length == 2)
            init(new BigInteger(tokens[0]), new BigInteger(tokens[1]));
        else if (tokens.length == 1)
            init(new BigInteger(tokens[0]), BigInteger.ONE);
        else
            throw new IllegalArgumentException("For input string: \"" + s + "\"");
    }

    // create and initialize a new BigRational object
    public BigRational(BigInteger numerator, BigInteger denominator) {
        init(numerator, denominator);
    }

    private void init(BigInteger numerator, BigInteger denominator) {

        // deal with x / 0
        if (denominator.equals(BigInteger.ZERO)) {
           throw new ArithmeticException("Denominator is zero");
        }

        // reduce fraction
        BigInteger g = numerator.gcd(denominator);
        num = numerator.divide(g);
        den = denominator.divide(g);

        // to ensure invariant that denominator is positive
        if (den.compareTo(BigInteger.ZERO) < 0) {
            den = den.negate();
            num = num.negate();
        }
    }

    // return string representation of (this)
    public String toString() { 
        if (den.equals(BigInteger.ONE)) return num + "";
        else                            return num + "/" + den;
    }

    // return { -1, 0, + 1 } if a < b, a = b, or a > b
    public int compareTo(BigRational b) {
        BigRational a = this;
        return a.num.multiply(b.den).compareTo(a.den.multiply(b.num));
    }

    // is this BigRational negative, zero, or positive?
    public boolean isZero()     { return compareTo(ZERO) == 0; }
    public boolean isPositive() { return compareTo(ZERO)  > 0; }
    public boolean isNegative() { return compareTo(ZERO)  < 0; }

    // is this Rational object equal to y?
    public boolean equals(Object y) {
        if (y == this) return true;
        if (y == null) return false;  
        if (y.getClass() != this.getClass()) return false;
        BigRational b = (BigRational) y;
        return compareTo(b) == 0;
    }
        
    // hashCode consistent with equals() and compareTo()
    public int hashCode() {
        return this.toString().hashCode();
    }
    

    // return a * b
    public BigRational multiply(BigRational b) {
        BigRational a = this;
        return new BigRational(a.num.multiply(b.num), a.den.multiply(b.den));
    }

    // return a + b
    public BigRational add(BigRational b) {
        BigRational a = this;
        BigInteger numerator   = a.num.multiply(b.den).add(b.num.multiply(a.den));
        BigInteger denominator = a.den.multiply(b.den);
        return new BigRational(numerator, denominator);
    }

    // return -a
    public BigRational negate() {
        return new BigRational(num.negate(), den);
    }

    // return a - b
    public BigRational subtract(BigRational b) {
        BigRational a = this;
        return a.add(b.negate());
    }

    // return 1 / a
    public BigRational reciprocal() {
        return new BigRational(den, num);
    }

    // return a / b
    public BigRational divide(BigRational b) {
        BigRational a = this;
        return a.multiply(b.reciprocal());
    }

    // return double reprentation (within given precision)
    public double doubleValue() {
        int SCALE = 32;        // number of digits after the decimal place
        BigDecimal numerator   = new BigDecimal(num);
        BigDecimal denominator = new BigDecimal(den);
        BigDecimal quotient    = numerator.divide(denominator, SCALE, RoundingMode.HALF_EVEN);
        return quotient.doubleValue();
    }


//    // test client
//    public static void main(String[] args) {
//        BigRational x, y, z;
//
//        // 1/2 + 1/3 = 5/6
//        x = new BigRational(1, 2);
//        y = new BigRational(1, 3);
//        z = x.plus(y);
//        StdOut.println(z);
//
//        // 8/9 + 1/9 = 1
//        x = new BigRational(8, 9);
//        y = new BigRational(1, 9);
//        z = x.plus(y);
//        StdOut.println(z);
//
//        // 1/200000000 + 1/300000000 = 1/120000000
//        x = new BigRational(1, 200000000);
//        y = new BigRational(1, 300000000);
//        z = x.plus(y);
//        StdOut.println(z);
//
//        // 1073741789/20 + 1073741789/30 = 1073741789/12
//        x = new BigRational(1073741789, 20);
//        y = new BigRational(1073741789, 30);
//        z = x.plus(y);
//        StdOut.println(z);
//
//        //  4/17 * 17/4 = 1
//        x = new BigRational(4, 17);
//        y = new BigRational(17, 4);
//        z = x.times(y);
//        StdOut.println(z);
//
//        // 3037141/3247033 * 3037547/3246599 = 841/961 
//        x = new BigRational(3037141, 3247033);
//        y = new BigRational(3037547, 3246599);
//        z = x.times(y);
//        StdOut.println(z);
//
//        // 1/6 - -4/-8 = -1/3
//        x = new BigRational( 1,  6);
//        y = new BigRational(-4, -8);
//        z = x.minus(y);
//        StdOut.println(z);
//
//        // 0
//        x = new BigRational(0,  5);
//        StdOut.println(x);
//        StdOut.println(x.plus(x).compareTo(x) == 0);
//        /// StdOut.println(x.reciprocal());   // divide-by-zero
//
//        // -1/200000000 + 1/300000000 = 1/120000000
//        x = new BigRational(-1, 200000000);
//        y = new BigRational(1, 300000000);
//        z = x.plus(y);
//        StdOut.println(z);
//
//    }

}
