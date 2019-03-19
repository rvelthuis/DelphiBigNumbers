/*                                                                           */
/* File:       BigRationalTestDataGenerator.java                             */
/* Function:   Generates result tables for a set of big rationals and the    */
/*             math operations on them, as an include file for the           */
/*             BigRationalTest.dpr program, called BigRationalTestData.inc.  */
/* Language:   Java 8                                                        */
/* Author:     Rudy Velthuis                                                 */
/* Copyright:  (c) 2017 Rudy Velthuis                                        */
/* Notes:      - The freely available NetBeans IDE (V8.1) was used           */
/*               to compile and run this project.                            */
/*               http://www.netbeans.org                                     */
/*             - BigFraction is part of the org.apache.commons.math          */
/*               project.                                                    */             
/*               http://commons.apache.org/proper/commons-math/              */
/*                                                                           */
/* License:    Redistribution and use in source and binary forms, with or    */
/*             without modification, are permitted provided that the         */
/*             following conditions are met:                                 */
/*                                                                           */
/*             * Redistributions of source code must retain the above        */
/*               copyright notice, this list of conditions and the following */
/*               disclaimer.                                                 */
/*             * Redistributions in binary form must reproduce the above     */
/*               copyright notice, this list of conditions and the following */
/*               disclaimer in the documentation and/or other materials      */
/*               provided with the distribution.                             */
/*                                                                           */
/* Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS"     */
/*             AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT     */
/*             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND     */
/*             FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO        */
/*             EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE     */
/*             FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,     */
/*             OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,      */
/*             PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     */
/*             DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    */
/*             AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT   */
/*             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)        */
/*             ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF   */
/*             ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                    */
/*                                                                           */

package bigrationaltestdatagenerator;

import java.io.*;
import java.math.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Scanner;
import org.apache.commons.math3.exception.*;
import org.apache.commons.math3.fraction.*;

/*
    Note: Originally, I used BigRational.java from http://introcs.cs.princeton.edu/java/92symbolic/BigRational.java.html
          Now, I use the Apache Commons Math BigFraction type. The output is slightly different:
          Princeton: (new BigRational(123, 322)).toString() --> "123/322"
          Apache:    (new BigFraction(123, 322)).toString() --> "123 / 322"       
*/


public class BigRationalTestDataGenerator
{
    final static int DEFAULT_STRING_WIDTH = 64;

    final static MathContext CONTEXT = new MathContext(64, RoundingMode.HALF_EVEN);
    
    public static enum TestResultInfo
    {
        Ok,
        DivideByZero,
        ArgumentNull,
        ArgumentRange,
        Format,
        Overflow,
        Underflow,
        ReverseRound
    }

    public static class TestResult
    {

        public TestResultInfo info;
        public String val;

        public TestResult()
        {
            info = TestResultInfo.Ok;
            val = "";
        }
    }
    
    public static class ScaleAndUnscaledValue
    {
        public long scale;
        public String val;
        
        public ScaleAndUnscaledValue()
        {
            scale = 0;
            val = "0";
        }
    }
    
    public static void main(String[] args)
    {
        // TODO: Add bad results (exceptions) too, and set result info accordingly.

        try
        {
            File outfile = new File("..\\..\\..\\Tests\\BigRationals\\BigRationalTestData.inc");
            BufferedWriter bw = new BufferedWriter(new FileWriter(outfile));
            writeln("Writing file " + outfile.getCanonicalPath());
            writeln();
            try
            {
                writeDate(bw);
                writeTypes(bw);
                checkArguments();
                writeTestData(bw);
                generateCtorResults(bw);
                generateDoubleCtorResults(bw);
                generateBigDecimalCtorResults(bw);
                generateAddResults(bw);
                generateSubtractResults(bw);
                generateMultiplyResults(bw);
                generateDivideResults(bw);
                generateIntDivideResults(bw);
                generateRemainderResults(bw);
                generateNegateResults(bw);
                generateReciprocalResults(bw);
                generateFloatValueResults(bw);
                generateDoubleValueResults(bw);
//                generateBigDecimalValueResults(bw);
            }
            finally
            {
                bw.close();
            }
        }
        catch (IOException e)
        {
            writeln("Error " + e.getClass().getName() + ": " + e.getMessage());
        }

        writeln();
    }

    static String convertRoundingMode(RoundingMode r)
    {
        switch (r)
        {
            case DOWN:
                return "rmDown";
            case UP:
                return "rmUp";
            case FLOOR:
                return "rmFloor";
            case CEILING:
                return "rmCeiling";
            case HALF_UP:
                return "rmNearestUp";
            case HALF_DOWN:
                return "rmNearestDown";
            case UNNECESSARY:
                return "rmUnnecessary";
            default:
                return "rmNearestEven";
        }
    }

    static void writeln(BufferedWriter bw, String s) throws IOException
    {
        bw.write(s + "\n");
    }

    static void writeln(BufferedWriter bw) throws IOException
    {
        writeln(bw, "");
    }

    static void writeln(String s)
    {
        System.out.println(s);
    }

    static void writeln()
    {
        System.out.println();
    }

    static void writeln(BufferedWriter bw, String format, Object... args) throws IOException
    {
        String s = String.format(Locale.ROOT, format, args);
        writeln(bw, s);
    }

    static void writeln(String format, Object... args)
    {
        String s = String.format(Locale.ROOT, format, args);
        writeln(s);
    }

    // Yes, this is a kludge.
    static void readln()
    {
        try
        {
            Scanner s = new Scanner(System.in);
            s.nextLine();
        }
        catch (Exception e)
        {
            // Ignore it! 
        }
    }

    static void pause(String s)
    {
        System.out.print(s);
        readln();
    }

    static void pause()
    {
        pause("Press return...");
    }
    
    // BigFraction returns a string in the form "100 / 17" instead of the 
    // expected "100/17". The following function modifies this.
    static String trimmedToString(BigFraction b)
    {
        return b.toString().replaceFirst(" / ", "/");
    }

    static void writeDate(BufferedWriter bw) throws IOException
    {
        DateFormat df = new SimpleDateFormat("dd MMM, yyyy, HH:mm:ss");
        Date today = Calendar.getInstance().getTime();
        String reportDate = df.format(today);

        writeln(bw, "//");
        writeln(bw, "// Test data for Velthuis.BigRationals.BigRational type, generated " + reportDate + ".");
        writeln(bw, "//");
        writeln(bw, "// Do not modify the generated data in this file. Modify the data in the generator.");
        writeln(bw, "// The generator is in BigRationalTestDataGenerator.java, below the Test directory.");
        writeln(bw, "//");
        writeln(bw, "// The generator was written in Java, using NetBeans 8.2.");
        writeln(bw, "//");
        writeln(bw);

        writeln("You'll see a long list of errors. This is expected. The generated errors are");
        writeln("registered and stored in the result arrays generated by this program");
        writeln();
        writeln();
    }

    static void writeTypes(BufferedWriter bw) throws IOException
    {
        writeln(bw, "type");
        writeln(bw, "  TTestResultInfo =");
        writeln(bw, "  (");
        TestResultInfo[] values = TestResultInfo.values();
        for (TestResultInfo tri: values)
        {
            writeln(bw, "    tri" + tri + (tri != values[values.length - 1] ? "," : ""));
        }
        writeln(bw, "  );");
        writeln(bw);
        writeln(bw, "  TTestResult = record");
        writeln(bw, "    Info: TTestResultInfo;");
        writeln(bw, "    Val: string;");
        writeln(bw, "  end;");
        writeln(bw);
        writeln(bw, "  TAdditionalData = record");
        writeln(bw, "    Numerator: string;");
        writeln(bw, "    Denominator: string;");
        writeln(bw, "  end;");
        writeln(bw);
    }

    static void writeTestData(BufferedWriter bw) throws IOException
    {
        int count = CTOR_TESTDATA.length;

        writeln(bw, "const");
        writeln(bw, "  CtorTestDataCount = %d;", count);
        writeln(bw, "  CtorTestData: array[0..CtorTestDataCount - 1] of string =");
        writeln(bw, "  (");
        for (int i = 0; i < count; ++i)
        {
            writeln(bw, formatString(CTOR_TESTDATA[i], i == count - 1, String.format("%d", i)));
        }
        writeln(bw);
        writeln(bw, "    // Add additional values below");
        writeln(bw, "  );");
        writeln(bw);
        
        count = DOUBLEDATA.length;
        
        writeln(bw, "  DoubleCount = %d;", count);
        writeln(bw, "  DoubleData: array[0..DoubleCount - 1] of Double =");
        writeln(bw, "  (");
        for (int i = 0; i < count; ++i)
        {
            writeln(bw, "    %-85s // %d",
                    String.format(Locale.getDefault(), "%.40g%s", DOUBLEDATA[i], ((i < count - 1) ? "," : "")), i);
        }
        writeln(bw, "  );");
        writeln(bw);
        
        count = ARGUMENTS.length;
        writeln(bw, "  ArgumentCount = %d;", count);
        writeln(bw, "  Arguments: array[0..ArgumentCount - 1] of string =");
        writeln(bw, "  (");
        for (int i = 0; i < count; i++)
        {
            writeln(bw, formatString(ARGUMENTS[i], i == count - 1, String.format("%d", i)));
        }
        writeln(bw, "  );");
        writeln(bw);
        
        count = BIGDECIMALDATA.length;
        writeln(bw, "  BigDecimalDataCount = %d;", count);
        writeln(bw, "  BigDecimalData: array[0..BigDecimalDataCount - 1] of string =");
        writeln(bw, "  (");
        for (int i = 0; i < count; i++)
        {
            writeln(bw, formatString(BIGDECIMALDATA[i], i == count - 1, String.format("%d", i)));
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void generateCtorResults(BufferedWriter bw) throws IOException
    {
        int count = CTOR_TESTDATA.length;
        int n = 0;
        
        writeln(bw, "  CtorResultCount = %d;", count * count);
        writeln(bw, "  CtorResults: array[0..CtorResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
             BigInteger x = new BigInteger(CTOR_TESTDATA[i]);
             for (int j = 0; j < count; j++)
             {
                 BigInteger y = new BigInteger(CTOR_TESTDATA[j]);
                 TestResult res = new TestResult();
                 
                 try
                 {
                     BigFraction r = new BigFraction(x, y);
                     res.info = TestResultInfo.Ok;
                     res.val = trimmedToString(r);
                 }
                 catch (ZeroException a)
                 {
                     res.info = TestResultInfo.DivideByZero;
                     res.val = "Division by zero";
                 }
                 
                 formatResult(bw, res, (i == count - 1 && j == i), String.format("(%2d,%2d) %4d: %s/%s", i, j, n, x, y));
                 n++;
             }
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void generateDoubleCtorResults(BufferedWriter bw) throws IOException
    {
        int count = DOUBLEDATA.length;
        int n = 0;
        
        writeln(bw, "  DoubleCtorResultCount = %d;", count);
        writeln(bw, "  DoubleCtorResults: array[0..DoubleCtorResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
             TestResult res = new TestResult();
             try
             {
                 BigFraction r = new BigFraction(DOUBLEDATA[i]);
                 res.info = TestResultInfo.Ok;
                 res.val = trimmedToString(r);
             }
             catch (ZeroException a)
             {
                 res.info = TestResultInfo.DivideByZero;
                 res.val = "Invalid argument";
             }

             formatResult(bw, res, (i == count - 1), String.format(Locale.ROOT, "(%2d) %4d: BigRational.Create(%.20g)", i, n, DOUBLEDATA[i]));
             n++;
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void generateBigDecimalCtorResults(BufferedWriter bw) throws IOException
    {
        int count = BIGDECIMALDATA.length;
        
        writeln(bw, "  BigDecimalCtorResultCount = %d;", count);
        writeln(bw, "  BigDecimalCtorResults: array[0..BigDecimalCtorResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
             TestResult res = new TestResult();
             try
             {
                 BigDecimal d = new BigDecimal(BIGDECIMALDATA[i]);
                 BigInteger num = d.unscaledValue();
                 BigInteger denom = BigInteger.ONE;
                 int scale = d.scale();
                 
                 if (scale > 0)
                 {
                     denom = BigInteger.TEN.pow(scale);
                 } 
                 else if (scale < 0)
                 {
                     num = num.multiply(BigInteger.TEN.pow(-scale));
                 }
                 
                 BigFraction r = new BigFraction(num, denom);
                 res.info = TestResultInfo.Ok;
                 res.val = trimmedToString(r);
             }
             catch (Exception a)
             {
                 res.info = TestResultInfo.DivideByZero;
                 res.val = "Invalid argument";
             }

             formatResult(bw, res, (i == count - 1), String.format(Locale.ROOT, "(%2d): BigRational.Create(BigDecimal('%s'))", i, BIGDECIMALDATA[i]));
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static String spaces(int n)
    {
        return n == 0 ? "" : String.format("%" + n + "s", "");
    }

    static String[] splitString(String s, int width)
    {
        {
            ArrayList<String> results = new ArrayList<>();

            if (s == null || s.length() == 0)
            {
                return new String[]
                {
                    ""
                };
            }

            while (s.length() > 0)
            {
                results.add(s.substring(0, s.length() > width ? width : s.length()));
                s = s.substring(s.length() > width ? width : s.length());
            }
            String res[] = new String[results.size()];
            return results.toArray(res);
        }
    }

    static void formatResult(BufferedWriter bw, TestResult result, boolean isLast, String comment) throws IOException
    {
        String info = String.format("tri%s;", result.info);
        String[] values = splitString(result.val, DEFAULT_STRING_WIDTH);

        for (int k = 0; k < values.length; k++)
        {
            if (k == 0)
            {
                bw.write(String.format("    (Info: %-17s Val: '%s'", info, values[k]));
            }
            else
            {
                bw.write(String.format("%34s'%s'", ' ', values[k]));
            }
            if (k < values.length - 1)
            {
                writeln(bw, " + ");
            }
            else
            {
                String lineEnd = ")" + (isLast ? "" : ",");
                writeln(bw, "" + lineEnd + spaces(DEFAULT_STRING_WIDTH + 4 - lineEnd.length() - values[k].length()) + "// %s", comment);
            }
        }
    }
    
    static void formatScaleUnscaledValue(BufferedWriter bw, int scale, BigInteger unscaledValue, boolean isLast, String comment) throws IOException
    {
        String[] values = splitString(unscaledValue.toString(), DEFAULT_STRING_WIDTH);

        for (int k = 0; k < values.length; k++)
        {
            if (k == 0)
            {
                bw.write(String.format("    (Scale: %4d; UnscaledValue: '%s'", scale, values[k]));
            }
            else
            {
                bw.write(String.format("%33s'%s'", ' ', values[k]));
            }
            if (k < values.length - 1)
            {
                writeln(bw, " + ");
            }
            else
            {
                String lineEnd = ")" + (isLast ? "" : ",");
                writeln(bw, "" + lineEnd + spaces(45 - lineEnd.length() - values[k].length()) + "// %s", comment);
            }
        }
    }
    
    static String formatString(String value, boolean isLast, String comment)
    {
        String[] values = splitString(value, DEFAULT_STRING_WIDTH);
        StringBuilder result = new StringBuilder();
        
        for (int k = 0; k < values.length; k++)
        {
           result.append(String.format("    '%s'", values[k]));
           if (k < values.length - 1)
               result.append(" + \n");
           else
           {
               String lineEnd = isLast ? "" : ",";
               result.append(lineEnd);
               result.append(spaces(DEFAULT_STRING_WIDTH + 4 - lineEnd.length() - values[k].length()));
               result.append("// ");
               result.append(comment);
           }
        }
        return result.toString();
    }
    
    static void writeMonadicResults(BufferedWriter bw, String arrayName, TestResult[] results, int count, String prefix, String suffix) throws IOException
    {
        writeln(bw, "  %s: array[0..ArgumentCount - 1] of TTestResult =", arrayName, count);
        writeln(bw, "  (");

        for (int i = 0; i < count; ++i)
            formatResult(bw, results[i], (i == count - 1), String.format("%s(%s)%s", prefix, ARGUMENTS[i], suffix));
        writeln(bw, "  );");
        writeln(bw);
    }

    static void writeDyadicResults(BufferedWriter bw, String ArrayName, TestResult[] results, int count, String op) throws IOException
    {
        // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
        // There may be a better way to achieve this, but hey, it works.

        writeln(bw, "  %s: array[0..ArgumentCount * ArgumentCount - 1] of TTestResult =", ArrayName);
        writeln(bw, "  (");
        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            for (int j = 0; j < count; ++j, ++n)
            {
                formatResult(bw, results[n], (i == count - 1 && j == count - 1), String.format("%4d: (%s) %s (%s)", n, ARGUMENTS[i], op, ARGUMENTS[j]));
            }
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    // Note: BigFraction, unlike the previously used BigRational, does not have 
    //       a constructor or method taking a string representation as
    //       argument. Hence the following method.
    static BigFraction fromString(String s)
    {
        String[] items = s.split("/");
        if (items.length > 1)
        {
            BigInteger num = new BigInteger(items[0].trim());
            BigInteger den = new BigInteger(items[1].trim());
            return new BigFraction(num, den);
        }
        else
        {
            BigInteger num = new BigInteger(items[0].trim());
            return new BigFraction(num);
        }
    }

    static void generateAddResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                tr.info = TestResultInfo.Ok;
                BigFraction d3 = d1.add(d2);

                tr.val = trimmedToString(d3);
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "AddResults", results, count, "+");
    }

    static void generateSubtractResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                tr.info = TestResultInfo.Ok;
                BigFraction d3 = d1.subtract(d2);

                tr.val = trimmedToString(d3);
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "SubtractResults", results, count, "-");
    }

    static void generateMultiplyResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                tr.info = TestResultInfo.Ok;
                BigFraction d3 = d1.multiply(d2);

                tr.val = trimmedToString(d3);
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "MultiplyResults", results, count, "*");
    }

    static void generateDivideResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                tr.info = TestResultInfo.Ok;

                try
                {
                    BigFraction d3 = d1.divide(d2);
                    tr.val = trimmedToString(d3);
                }
                catch (MathArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    writeln("(%2d,%2d) - Division error: %s -- %s / %s", i, j, e.getMessage(), trimmedToString(d1), trimmedToString(d2));
                }

                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "DivideResults", results, count, "/");
    }
    
    static BigInteger intDivide(BigFraction a, BigFraction b) throws MathArithmeticException
    {
        BigFraction quotient = a.divide(b);
        return quotient.getNumerator().divide(quotient.getDenominator());
    }
    
    static void generateIntDivideResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                try
                {
                    BigInteger d3 = intDivide(d1, d2);
                    tr.info = TestResultInfo.Ok;
                    tr.val = d3.toString();
                }
                catch (MathArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    writeln("(%2d,%2d) - Division error: %s -- %s div %s", i, j, e.getMessage(), trimmedToString(d1), trimmedToString(d2));
                }
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "IntDivideResults", results, count, "div");
        
    }
    
    static BigFraction remainder(BigFraction a, BigFraction b) throws MathArithmeticException
    {
        BigInteger quotient = intDivide(a, b);
        return a.subtract(b.multiply(quotient));
    }
    
    static void generateRemainderResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigFraction d2 = fromString(ARGUMENTS[j]);
                tr.info = TestResultInfo.Ok;

                try
                {
                    BigFraction d3 = remainder(d1, d2);
                    tr.val = trimmedToString(d3);
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    writeln("(%2d,%2d) - Division error: %s -- %s mod %s", i, j, e.getMessage(), trimmedToString(d1), trimmedToString(d2));
                }
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "RemainderResults", results, count, "mod");
    }
    
    static void generateNegateResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int n = 0;
        
        TestResult[] results = new TestResult[count];
        
        for (int i = 0; i < count; ++i)
        {
            TestResult result = new TestResult();
            
            BigFraction d1 = fromString(ARGUMENTS[i]);
            BigFraction d2 = d1.negate();
            result.info = TestResultInfo.Ok;
            result.val = trimmedToString(d2);
            
            results[i] = result;
        }
        
        writeMonadicResults(bw, "NegateResults", results, count, "-", "");
    }

    static void generateReciprocalResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int n = 0;
        
        TestResult[] results = new TestResult[count];
        
        for (int i = 0; i < count; ++i)
        {
            TestResult result = new TestResult();
            
            BigFraction d1 = fromString(ARGUMENTS[i]);
            try
            {
                BigFraction d2 = d1.reciprocal();
                result.info = TestResultInfo.Ok;
                result.val = trimmedToString(d2);
            }
            catch (ZeroException e)
            {
                result.info = TestResultInfo.DivideByZero;
                result.val = "Division by zero";
            }
            
            results[i] = result;
        }
        
        writeMonadicResults(bw, "ReciprocalResults", results, count, "1/", "");
    }

    static void generateDoubleValueResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int n = 0;
        
        writeln(bw, "  DoubleValueResults: array[0..ArgumentCount - 1] of UInt64 =");
        writeln(bw, "  (");

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            double d = d1.doubleValue();
            long raw = Double.doubleToRawLongBits(d);
            writeln(bw, "    $%016X%s    // %2d: %s --> %f", raw, (i < count - 1) ? "," : " ", i, ARGUMENTS[i], d);
        }
        
        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateFloatValueResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int n = 0;
        
        writeln(bw, "  SingleValueResults: array[0..ArgumentCount - 1] of UInt32 =");
        writeln(bw, "  (");

        for (int i = 0; i < count; ++i)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            float f = d1.floatValue();
            int raw = Float.floatToRawIntBits(f);
            writeln(bw, "    $%08X%s    // %2d: %s --> %f", raw, (i < count - 1) ? "," : " ", i, ARGUMENTS[i], f);
        }
        
        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateComparisons(BufferedWriter bw) throws IOException
    {
        String compData[] = COMPARISONDATA;
        int count = compData.length;
        int result;

        writeln(bw, "  CompCount = %d;", count);
        writeln(bw, "  CompArguments: array[0..CompCount - 1] of string =");
        writeln(bw, "  (");
        for (int i = 0; i < count; ++i)
            writeln(bw, "    %-36s // %d",
                "'" + compData[i] + ((i < count - 1) ? "'," : "' "), i);
        writeln(bw, "  );");
        writeln(bw);
        writeln(bw, "  CompResults: array[0..CompCount - 1, 0..CompCount - 1] of TValueSign =");
        writeln(bw, "  (");
        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            bw.write("    (");
            BigFraction d1 = fromString(compData[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                BigFraction d2 = fromString(compData[j]);
                result = d1.compareTo(d2);
                if (result < 0)
                    bw.write("-1");
                else if (result > 0)
                    bw.write(" 1");
                else
                    bw.write(" 0");
                if (j < count - 1)
                    bw.write(", ");
            }
            bw.write(")");
            if (i < count - 1)
                bw.write(",");
            else           
                bw.write(" ");        
            writeln(bw, " // %d", n);
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    public static void generateToStringResults(BufferedWriter bw) throws IOException
    {
        writeln(bw, "  ToStringResults: array[0..TestCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        int count = ARGUMENTS.length;
        
        for (int i = 0; i < count; i++)
        {
            BigFraction d1 = fromString(ARGUMENTS[i]);
            TestResult tr = new TestResult();
            tr.info = TestResultInfo.Ok;
            tr.val = trimmedToString(d1);
            
            formatResult(bw, tr, (i == count - 1), String.format("%s.ToString", ARGUMENTS[i]));
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void checkArguments()
    {
        int count = ARGUMENTS.length;
        
        for (int i = 0; i < count; i++)
        {
            BigFraction arg = fromString(ARGUMENTS[i]);
            if (!trimmedToString(arg).equalsIgnoreCase(ARGUMENTS[i]))
            {
                System.out.format("%d: %s --> %s\n", i, trimmedToString(arg), ARGUMENTS[i]);
            }
        }
    }

    private static final String[] CTOR_TESTDATA = new String[]
    {
        "1",
        "0",
        "-1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "1000",
        "-1000000",
        "31",
        "37",
        "1147",
        "59",
        "1829",
        "2183",
        "67673"

        // Add your own data below
    };
    
    private static final String[] ARGUMENTS = new String[]
    {
        "0",
        "1",
        "1/2",
        "-1/10",
        "1/100",
        "2/7",
        "-12345",
        "-345/679",
        "999999999999999/8888888888888",
        "100",
        "-10000000",
        "17",
        "1/17",
        "31/37",
        "1147/59",
        "67673"
    };
    
    private static final double[] DOUBLEDATA = new double[]
    {
        3.45845952089E-323, // Denormal!
        -6E+20,
        -1E+20,
        -3.51,
        -3.5,
        -3.49,
        -2.51,
        -2.5,
        -2.49,
        -2E-100,
        0,
        7E-08,
        0.0001,
        0.1,
        0.2,
        0.3,
        0.4,
        0.49999999999999,
        0.5,
        0.50000001,
        0.7,
        0.9,
        1,
        1.00000000000001,
        1.1,
        1.49999999999999,
        1.5,
        1.50000000000001,
        1.9999,
        2,
        2.49,
        2.5,
        2.51,
        3,
        3.49,
        3.5,
        3.51,
        4,
        4.1,
        4.2,
        4.4,
        4.5,
        4.6,
        4.9999,
        5,
        6,
        7,
        8,
        9,
        10,
        15,
        22,
        44,
        85,
        128,
        256,
        256.1,
        256.5,
        256.7,
        300,
        876.543210987654,
        645000,
        1000000.5,
        1000000.5,
        1000000.5,
        1048576.1,
        1048576.5,
        10000000000.,
        14900000000.,
        15000000000.,
        15100000000.,
        31415920000.,
        100000000000.,
        1000000000000.,
        10000000000000.,
        100000000000000.,
        1E+15,
        2E+15,
        4E+15,
        4.9E+15,
        8E+15,
        1E+16,
        2E+16,
        4E+16,
        5E+16,
        1E+17,
        1E+18,
        1E+19,
        1.23456789012346E+19,
        1E+20,
        100000000000001.0,
        100000000000002.0,
        100000000000004.0,
        100000000000008.0,
        100000000000016.0,
        100000000000032.0,
        100000000000064.0,
        100000000000128.0,
        100000000000256.0,
        100000000000512.0,
        1E+80
        
    };

    private static final String[] COMPARISONDATA = new String[]
    {
        "0",
        "1",
        "-1",
        "2",
        "10",
        "0.1",
        "0.11",
        "0.11000",
        "10.000",
        "-10.000",
        "-10",
        "79228162514264337593543950335",
        "-79228162514264337593543950335",
        "27703302467091960609331879.532",
        "-3203854.9559968181492513385018",
        "-3203854.9559968181492513385017",
        "-48466870444188873796420.0286",
        "-48466870444188873796420.0286000",
        
        // Add your own data below
    };
    
    private static final String[] BIGDECIMALDATA = new String[]
    {
        "0",
        "-0.00",
        "1",
        "-1.00",
        "2.0000",
        "10",
        "1e16",
        "1e-16",
        "0.1",
        "1.79e+308",
        "3.79e+308",
        "4.940656458412465443e-324",
        "8.0e-324",
        "1.23456e-326",
        "0.001",
        "2.71828182845904523536028747135266249775724709369995",
        "3.14159265358979323851280895940618620443274267017841339111328125",
        "79228162514264337593543950335",
        "-79228162514264337593543950335",
        "27703302467091960609331879.532",
        "-27703302467091960609331879.532",
        "-3203854.9559968181492513385018",
        "-48466870444188873796420.028868",
        "-545193693242804794.30331374676",
        "0.7629234053338741809892531431",
        "-400453059665371395972.33474452",
        "222851627785191714190050.61676",
        "14246043379204153213661335.584",
        "-421123.30446308691436596648186",
        "24463288738299545.200508898642",
        "-5323259153836385912697776.001",
        "102801066199805834724673169.19",
        "7081320760.3793287174700927968",
        "415752273939.77704245656837041",
        "-6389392489892.6362673670820462",
        "442346282742915.0596416330681",
        "-512833780867323.89020837443764",
        "608940580690915704.1450897514",
        "-42535053313319986966115.037787",
        "-7808274522591953107485.8812311",
        "1037807626804273037330059471.7",
        "-4997122966.448652425771563042",
        "3961408125713216879677197.5171",
        "3961408125713216879677197.5172",
        "990352031428304219919299.3793",
        "922337203685477.5811",
        "2305843009.213693953",
        "230584300.9213693952",
        "8.00",
        "2.00",
        "34359738.368",
        "85899345.92",
        "14757395258967.6412928",
        "36893488147419.103232",
        "2147483651",
        "536870913",
        "110",
        "10000",
        "1.234e+17",
        "1.234e+2",
        "3.0",
        "5.0000001",
        "7.000000",
        "-130.00000000000000000750000001"
    };
};

