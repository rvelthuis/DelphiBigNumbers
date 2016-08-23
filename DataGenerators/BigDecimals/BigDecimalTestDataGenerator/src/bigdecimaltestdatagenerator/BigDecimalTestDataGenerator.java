/*                                                                           */
/* File:       BigDecimalTestDataGenerator.java                              */
/* Function:   Generates result tables for a set of big decimals and the     */
/*             math operations on them, as an include file for the           */
/*             BigIntegerTest.dpr program, called BigDecimalTestData.inc.    */
/* Language:   Java 8 (JDK 1.8)                                              */
/* Author:     Rudy Velthuis                                                 */
/* Copyright:  (c) 2016 Rudy Velthuis                                        */
/* Notes:      The freely available NetBeans IDE (V8.0.2) was used           */
/*             to compile and run this project.                              */
/*             http://www.netbeans.org                                       */
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

package bigdecimaltestdatagenerator;

import java.math.*;
import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;
import java.util.ArrayList;

public class BigDecimalTestDataGenerator
{

    final static int DEFAULT_STRING_WIDTH = 40;

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
        }
    }
    
    public static class ScaleAndUnscaledValue
    {
        public long scale;
        public String val;
        
        public ScaleAndUnscaledValue()
        {
        }
    }

    public static void main(String[] args)
    {
        // TODO: Add bad results (exceptions) too, and set result info accordingly.

        try
        {
            File outfile = new File("..\\..\\..\\Tests\\BigDecimals\\BigDecimalTestData.inc");
            BufferedWriter bw = new BufferedWriter(new FileWriter(outfile));
            println("Writing file " + outfile.getCanonicalPath());
            println();
            try
            {
                writeDate(bw);
                writeTypes(bw);
                writeData(bw);
                writeAdditionalData(bw);
                generateScaleAndUnscaledValues(bw);
                generateAddResults(bw);
                generateSubtractResults(bw);
                generateMultiplyResults(bw);
                generateDivideResults(bw);
                generateIntDivideResults(bw);
                generateRemainderResults(bw);
                generateFloatValueResults(bw);
                generateDoubleValueResults(bw);
                generateComparisons(bw);
                generateRoundResults(bw);
                generateRoundToResults(bw);
                generateRemoveTrailingZerosResults(bw);
                generateToStringResults(bw);
                generateToPlainStringResults(bw);
            }
            finally
            {
                bw.close();
            }
        }
        catch (IOException e)
        {
            println("Error " + e.getClass().getName() + ": " + e.getMessage());
        }

        println();
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

    static void println(BufferedWriter bw, String s) throws IOException
    {
        bw.write(s + "\n");
    }

    static void println(BufferedWriter bw) throws IOException
    {
        println(bw, "");
    }

    static void println(String s)
    {
        System.out.println(s);
    }

    static void println()
    {
        System.out.println();
    }

    static void println(BufferedWriter bw, String format, Object... args) throws IOException
    {
        String s = String.format(format, args);
        println(bw, s);
    }

    static void println(String format, Object... args)
    {
        String s = String.format(format, args);
        println(s);
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

    static void writeDate(BufferedWriter bw) throws IOException
    {
        DateFormat df = new SimpleDateFormat("dd MMM, yyyy, HH:mm:ss");
        Date today = Calendar.getInstance().getTime();
        String reportDate = df.format(today);

        println(bw);
        println(bw, "// Test data for Velthuis.BigDecimals.BigDecimal type, generated " + reportDate + ".");
        println(bw, "//");
        println(bw, "// Do not modify the generated data in this file. Modify the data in the generator.");
        println(bw, "// The generator is in BigDecimalTestDataGenerator.java, below the Test directory.");
        println(bw, "//");
        println(bw, "// The generator was written in Java, using NetBeans 8.0.2.");
        println(bw);

        println("You'll see a long list of errors. This is expected. The generated errors are");
        println("registered and stored in the result arrays generated by this program");
        println();
        println();
    }

    static void writeTypes(BufferedWriter bw) throws IOException
    {
        println(bw, "type");
        println(bw, "  TTestResultInfo =");
        println(bw, "  (");
        TestResultInfo[] values = TestResultInfo.values();
        for (TestResultInfo tri: values)
        {
            println(bw, "    tri" + tri + (tri != values[values.length - 1] ? "," : ""));
        }
        println(bw, "  );");
        println(bw);
        println(bw, "  TTestResult = record");
        println(bw, "    Info: TTestResultInfo;");
        println(bw, "    Val: string;");
        println(bw, "  end;");
        println(bw);
        println(bw, "  TAdditionalData = record");
        println(bw, "    Scale: Integer;");
        println(bw, "    Precision: Integer;");
        println(bw, "  end;");
        println(bw);
        println(bw, "  TScaleValuePair = record");
        println(bw, "    Scale: Int32;");
        println(bw, "    UnscaledValue: string;");
        println(bw, "  end;");
        println(bw);

        println(bw, "const");
        println(bw, "  CTestPrecision    = %d;", CONTEXT.getPrecision());
        println(bw, "  CTestRoundingMode = %s;",
                convertRoundingMode(CONTEXT.getRoundingMode()));
        println(bw);
    }

    static void writeData(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;

        println(bw, "const");
        println(bw, "  TestCount = %d;", count);
        println(bw, "  TestData: array[0..TestCount - 1] of string =");
        println(bw, "  (");
        for (int i = 0; i < count; ++i)
        {
            println(bw, "    %-36s // %d",
                    "'" + TESTDATA[i] + ((i < count - 1) ? "'," : "'"), i);
        }
        println(bw, "  );");
        println(bw);
        
        arguments = new BigDecimal[TESTDATA.length];    
        for (int i = 0; i < count; ++i)
        {
            try
            {
                arguments[i] = new BigDecimal(TESTDATA[i]);
            }
            catch(NumberFormatException e)
            {
                arguments[i] = new BigDecimal("-1.01010101");
            }
        }
    }
    
    static void writeAdditionalData(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        
        println(bw, "  AdditionalData: array[0..TestCount - 1] of TAdditionalData =");
        println(bw, "  (");
        for (int i = 0; i < count; ++i)
            println(bw, "    %-35s // %d", 
                    String.format("(Scale: %5d; Precision: %5d)", arguments[i].scale(), arguments[i].precision()) + 
                            ((i < count - 1) ? "," : " "), i);
        println(bw, "  );");
        println(bw);
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
                println(bw, " + ");
            }
            else
            {
                String lineEnd = ")" + (isLast ? "" : ",");
                println(bw, "" + lineEnd + spaces(44 - lineEnd.length() - values[k].length()) + "// %s", comment);
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
                println(bw, " + ");
            }
            else
            {
                String lineEnd = ")" + (isLast ? "" : ",");
                println(bw, "" + lineEnd + spaces(45 - lineEnd.length() - values[k].length()) + "// %s", comment);
            }
        }
    }
    
    static void writeMonadicResults(BufferedWriter bw, String arrayName, TestResult[] results, int count, String prefix, String suffix) throws IOException
    {
        println(bw, "  %s: array[0.. TestCount - 1] of TTestResult =", arrayName);
        println(bw, "  (");

        for (int i = 0; i < count; ++i)
            formatResult(bw, results[i], (i == count - 1), String.format("%sArguments[%d]%s", prefix, i, suffix));
        println(bw, "  );");
        println(bw);
    }

    static void writeDyadicResults(BufferedWriter bw, String ArrayName, TestResult[] results, int count, String op) throws IOException
    {
        // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
        // There may be a better way to achieve this, but hey, it works.

        println(bw, "  %s: array[0..TestCount * TestCount - 1] of TTestResult =", ArrayName);
        println(bw, "  (");
        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            for (int j = 0; j < count; ++j, ++n)
            {
                formatResult(bw, results[n], (i == count - 1 && j == count - 1), String.format("%4d: Arguments[%d] %s Arguments[%d]", n, i, op, j));
            }
        }
        println(bw, "  );");
        println(bw);
    }

    static void generateAddResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                tr.info = TestResultInfo.Ok;
                BigDecimal d3 = d1.add(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "AddResults", results, count, "+");
    }

    static void generateSubtractResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                tr.info = TestResultInfo.Ok;
                BigDecimal d3 = d1.subtract(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "SubtractResults", results, count, "-");
    }

    static void generateMultiplyResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                tr.info = TestResultInfo.Ok;
                BigDecimal d3 = d1.multiply(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "MultiplyResults", results, count, "*");
    }

    static void generateDivideResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                tr.info = TestResultInfo.Ok;

                try
                {
                    BigDecimal d3 = d1.divide(d2, CONTEXT);
                    tr.val = d3.toString();
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    println("(%2d,%2d) - Div error: %s\n", i, j, e.getMessage());
                }

                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "DivideResults", results, count, "/");
    }
    
    static void generateIntDivideResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                BigDecimal d3 = BigDecimal.valueOf(0);
                tr.info = TestResultInfo.Ok;

                try
                {
                    d3 = d1.divideToIntegralValue(d2);
                    tr.val = d3.toString();
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    println("(%2d,%2d) - Div error: %s\n", i, j, e.getMessage());
                }
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "IntDivideResults", results, count, "div");
        
    }
    
    static void generateRemainderResults(BufferedWriter bw) throws IOException
    {
        int count = TESTDATA.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                TestResult tr = new TestResult();
                BigDecimal d2 = arguments[j];
                BigDecimal d3 = BigDecimal.valueOf(0);
                tr.info = TestResultInfo.Ok;

                try
                {
                    d3 = d1.remainder(d2);
                    tr.val = d3.toString();
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = "Division by zero";
                    println("(%2d,%2d) - Div error: %s\n", i, j, e.getMessage());
                }

//                if (d3.compareTo(BigDecimal.ZERO) != 0)
//                {
//                    BigDecimal d4 = d3.multiply(d2);
//                    
//                    if (d1.compareTo(d4) != 0)
//                    {
//                        tr.info = TestResultInfo.ReverseRound;
//                        System.out.format("(%2d,%2d) - DivMult error: reverse rounding error\n", i, j);
//                    }
//                }
                results[n] = tr;
            }
        }
        writeDyadicResults(bw, "RemainderResults", results, count, "mod");
    }
    
    static void generateDoubleValueResults(BufferedWriter bw) throws IOException
    {
        int count = arguments.length;
        int n = 0;
        
        println(bw, "  DoubleValueResults: array[0..TestCount - 1] of UInt64 =");
        println(bw, "  (");

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            double d = d1.doubleValue();
            long raw = Double.doubleToRawLongBits(d);
            println(bw, "    $%016X%s    // %d", raw, (i < count - 1) ? "," : " ", i);
        }
        
        println(bw, "  );");
        println(bw);
    }

    static void generateFloatValueResults(BufferedWriter bw) throws IOException
    {
        int count = arguments.length;
        int n = 0;
        
        println(bw, "  SingleValueResults: array[0..TestCount - 1] of UInt32 =");
        println(bw, "  (");

        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            float f = d1.floatValue();
            int raw = Float.floatToRawIntBits(f);
            println(bw, "    $%08X%s    // %d", raw, (i < count - 1) ? "," : " ", i);
        }
        
        println(bw, "  );");
        println(bw);
    }
    
    static void generateRoundResults(BufferedWriter bw) throws IOException
    {
        RoundingMode vals[] = RoundingMode.values();
        int argCount = arguments.length;
        int valsCount = vals.length;
        int n = 0;
        
        println(bw, "  InvalidRoundValue = $BADC0FFEE;");
        println(bw, "  RoundValueResults: array[0..TestCount - 1, BigDecimal.RoundingMode] of UInt64 =");
        println(bw, "  (");

        for (int i = 0; i < argCount; ++i)
        {
            bw.write("    (");
            BigDecimal d1 = arguments[i];
            for (int j = 0; j < valsCount; ++j)
            {
                long result;
                try 
                {
                    BigDecimal d2 = d1.setScale(0, vals[j]);
                    result = d2.longValue();
                } 
                catch (ArithmeticException e) 
                {
                    // Can only happen if RoundingMode.UNNECESSARY was set
                    // and rounding was necessary after all.
                    result = 0xBADC0FFEEL;
                }
                bw.write(String.format("$%016X%s", result, j < valsCount - 1 ? ", " : ""));
            }
            println(bw, ")%s // %d", i < argCount - 1 ? "," : " ", i);
        }
        
        println(bw, "  );");
        println(bw);
    }
    
    static void generateRoundToResults(BufferedWriter bw) throws IOException
    {
        RoundingMode vals[] = RoundingMode.values();
        int argCount = arguments.length;
        int valsCount = vals.length;
        int scalesCount = SCALES.length;
        int totalCount = argCount * scalesCount * valsCount;
        
        int n = 0;

        println(bw, "  TestDigitCount = %d;", scalesCount);
        println(bw, "  TestDigits: array[0..TestDigitCount - 1] of Integer =");
        println(bw, "  (");
        bw.write("    ");
        for (int i = scalesCount - 1; i >= 0; --i)
            bw.write(String.format("%3d%s", -SCALES[i], (i > 0) ? ", " : ""));
        println(bw);
        println(bw, "  );");
        println(bw);
        
        println(bw, "  RoundToCount = %d;", totalCount);
        println(bw, "  RoundToResults: array[0.. RoundToCount - 1] of TTestResult =");
        println(bw, "  (");

        for (int i = 0; i < argCount; ++i)
        {
            BigDecimal a = arguments[i];
            for (int j = scalesCount - 1; j >= 0; --j)
                for (int k = 0; k < valsCount; ++k)
                {
                    TestResult tr = new TestResult();
                    try
                    {
                        tr.info = TestResultInfo.Ok;
                        tr.val = a.setScale(SCALES[j], vals[k]).toString();
                    }
                    catch(ArithmeticException e)
                    {
                        println("(%2d, %2d, %2d) - Rounding error: %s", i, j, k, e.getMessage());
                        tr.info = TestResultInfo.ReverseRound;
                        tr.val = e.getMessage();
                    }
                    n++;
                    formatResult(bw, tr, (n == totalCount), String.format("Arguments[%d].RoundTo(%d, %s)", i, -SCALES[j], convertRoundingMode(vals[k])));
                }
            
        }
        println(bw, "  );");
        println(bw);
    }
    
    static void generateComparisons(BufferedWriter bw) throws IOException
    {
        String compData[] = COMPARISONDATA;
        int count = compData.length;
        int result;

        println(bw, "  CompCount = %d;", count);
        println(bw, "  CompArguments: array[0..CompCount - 1] of string =");
        println(bw, "  (");
        for (int i = 0; i < count; ++i)
            println(bw, "    %-36s // %d",
                "'" + compData[i] + ((i < count - 1) ? "'," : "' "), i);
        println(bw, "  );");
        println(bw);
        println(bw, "  CompResults: array[0..CompCount - 1, 0..CompCount - 1] of TValueSign =");
        println(bw, "  (");
        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            bw.write("    (");
            BigDecimal d1 = new BigDecimal(compData[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                BigDecimal d2 = new BigDecimal(compData[j]);
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
            println(bw, " // %d", n);
        }
        println(bw, "  );");
        println(bw);
    }
    
    public static void generateScaleAndUnscaledValues(BufferedWriter bw) throws IOException
    {
        println(bw, "  ScalesAndUnscaledValues: array[0..TestCount - 1] of TScaleValuePair =");
        println(bw, "  (");
        
        int count = arguments.length;
        
        for (int i = 0; i < count; ++i)
        {
            BigDecimal d1 = arguments[i];
            formatScaleUnscaledValue(bw, d1.scale(), d1.unscaledValue(), (i == count - 1), String.format("Arguments[%d]", i));
        }
        
        println(bw, "  );");
        println(bw);
    }
    
    public static BigDecimal removeTrailingZeros(BigDecimal value, int preferredScale)
    {
        BigDecimal result;
        int sign = value.signum();
        BigInteger unscaled = value.unscaledValue().abs();
        int scale = value.scale();
        
        while (unscaled.compareTo(BigInteger.TEN) >= 0 && scale > preferredScale)
        {
             BigInteger[] quotRem = unscaled.divideAndRemainder(BigInteger.TEN);
             if (quotRem[1].signum() == 0)
             {
                 unscaled = quotRem[0];
                 scale--;        
             }
             else
                 break;
        }
        
        return new BigDecimal(unscaled.multiply(BigInteger.valueOf(sign)), scale);
    }
    
    public static void generateRemoveTrailingZerosResults(BufferedWriter bw) throws IOException
    {
        println(bw, "  RTZRCount = TestCount * TestDigitCount;");
        println(bw, "  RemoveTrailingZeroResults: array[0..RTZRCount - 1] of TTestResult =");   
        println(bw, "  (");
        
        int count = arguments.length;
        int scalesCount = SCALES.length;
        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigDecimal d1 = arguments[i];
            for (int j = scalesCount - 1; j >= 0; j--)
            {
                int preferred = -SCALES[j];
                BigDecimal d2 = removeTrailingZeros(d1, preferred);
                
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                tr.val = d2.toString();
                formatResult(bw, tr, (i == count - 1 && j == 0), 
                        String.format("Arguments[%d].RemoveTrailingZeros(%d)", i, preferred));
            }
        }
        
        println(bw, "  );");   
        println(bw, "");   
    }
    
    public static void generateToStringResults(BufferedWriter bw) throws IOException
    {
        println(bw, "  ToStringResults: array[0..TestCount - 1] of TTestResult =");
        println(bw, "  (");
        
        int count = arguments.length;
        
        for (int i = 0; i < count; i++)
        {
            BigDecimal d1 = arguments[i];
            TestResult tr = new TestResult();
            tr.info = TestResultInfo.Ok;
            tr.val = d1.toString();
            
            formatResult(bw, tr, (i == count - 1), String.format("Arguments[%d].ToString", i));
        }
        println(bw, "  );");
        println(bw);
    }

    public static void generateToPlainStringResults(BufferedWriter bw) throws IOException
    {
        println(bw, "  ToPlainStringResults: array[0..TestCount - 1] of TTestResult =");
        println(bw, "  (");
        
        int count = arguments.length;
        
        for (int i = 0; i < count; i++)
        {
            BigDecimal d1 = arguments[i];
            TestResult tr = new TestResult();
            tr.info = TestResultInfo.Ok;
            tr.val = d1.toPlainString();
            
            formatResult(bw, tr, (i == count - 1), String.format("Arguments[%d].ToPlainString", i));
        }
        println(bw, "  );");
        println(bw);
    }

    
    static BigDecimal[] arguments;

    static final int[] SCALES = { -5, -2, -1, 0, 1, 2, 4, 8, 20 };
    
    private static final String[] TESTDATA = new String[]
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
        "-130.00000000000000000750000001", 

        // Add your own data below
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

}
