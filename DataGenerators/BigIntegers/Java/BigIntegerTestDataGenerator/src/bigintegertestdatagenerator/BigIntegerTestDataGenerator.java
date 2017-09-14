/*****************************************************************************/
/* File:       BigIntegerTestDataGenerator.java                              */
/* Function:   Generates result tables for a set of big integers and the     */
/*             math operations on them, as include files for the             */
/*             BigIntegerDevelopmentTests.dpr program.                       */
/* Language:   Java 8                                                        */
/* Author:     Rudy Velthuis                                                 */
/* Copyright:  (c) 2017 Rudy Velthuis                                        */
/* Notes:      - The freely available NetBeans IDE (V8.1) was used           */
/*               to compile and run this project.                            */
/*               http://www.netbeans.org                                     */
/*             - See http://rvelthuis.de/programs/bigintegers.html           */
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
/*****************************************************************************/

package bigintegertestdatagenerator;

import java.math.BigInteger;
import java.math.BigDecimal;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Scanner;
import java.util.Random;

public class BigIntegerTestDataGenerator 
{

    final static int DEFAULT_STRING_WIDTH = 40;

    public enum TestResultInfo
    {
        Ok,
        DivideByZero,
        ArgumentNull,
        ArgumentRange,
        Format,
        Overflow
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
    
    public static BufferedWriter newWriter(String fileName) throws IOException
    {
        File outFile = new File("..\\..\\..\\..\\Tests\\BigIntegers\\" + fileName);
        writeln("Writing file " + outFile.getCanonicalPath() + ".");
        writeln();
        BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));
        writeDate(bw, fileName);
        return bw;
    }
    
    public static void main(String[] args) 
    {
        BufferedWriter bw;
        
        writeln("Test data generator for Velthuis.BigIntegers.pas");
        writeln("------------------------------------------------");
        writeln();
        writeln("This program generates the include files");
        writeln();
        writeln("  BigIntegerTestResults.inc,");
        writeln("  BigIntegerArithmeticResults.inc");
        writeln("  BigIntegerBitwiseResults.inc");
        writeln("  BigIntegerMathResults.inc");
        writeln("  BigIntegerConvertResults.inc");
        writeln();
        writeln("which are used by the Delphi test programs for Velthuis.BigIntegers.pas.");
        writeln();
        writeln("You'll see a list of errors. This is expected. The generated errors are");
        writeln("registered and written to the test data include files generated by this program.");
        writeln();

        try
        {
            bw = newWriter("BigIntegerTestResults.inc");
            try
            {
                writeTypes(bw);
                writeData(bw);
            }
            finally
            {
                bw.close();
            }

            bw = newWriter("BigIntegerArithmeticResults.inc");
            try
            {
                generateAddResults(bw);
                generateSubtractResults(bw);
                generateMultiplyResults(bw);
                generateDivisionResults(bw);
                generateModulusResults(bw);
            }
            finally
            {
                bw.close();
            }

            bw = newWriter("BigIntegerBitwiseResults.inc");
            try
            {
                generateBitwiseAndResults(bw);
                generateBitwiseOrResults(bw);
                generateBitwiseXorResults(bw);
                generateNegationResults(bw);
                generateLogicalNotResults(bw);
                generateLeftShiftResults(bw);
                generateRightShiftResults(bw);
                generateSetBitResults(bw);
                generateClearBitResults(bw);
                generateFlipBitResults(bw);
            }
            finally
            {
                bw.close();
            }

            bw = newWriter("BigIntegerMathResults.inc");
            try
            {
                generateLnResults(bw);
                generatePowerResults(bw);
                generateModPowResults(bw);
                generateComparisonResults(bw);
                generateGCDResults(bw);
                generateInvModResults(bw);
                generateMinResults(bw);               
                generateMaxResults(bw);
                generateFactorialResults(bw);
            }
            finally
            {
                bw.close();
            }

            bw = newWriter("BigIntegerConvertResults.inc");
            try
            {
                generateTryParseResults(bw);
                generateByteArrayResults(bw);
                generateHexResults(bw);
                generateAsIntegerResults(bw);
                generateAsCardinalResults(bw);
                generateAsInt64Results(bw);
                generateAsUInt64Results(bw);
                generateFromDoubleResults(bw);
                generateDoubleResults(bw);
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

    }

    static void writeln(BufferedWriter bw, String s) throws IOException
    {
        bw.write(String.format("%s%n", s));
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
    
    static String formatString(String value, boolean isLast, String comment)
    {
        String[] values = splitString(value, DEFAULT_STRING_WIDTH);
        StringBuilder result = new StringBuilder();
        
        for (int k = 0; k < values.length; k++)
        {
           result.append(String.format("    '%s'", values[k]));
           if (k < values.length - 1)
               result.append(String.format(" + %n"));
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
    
    static void writeUnaryResults(BufferedWriter bw, String arrayName, TestResult[] results, int count, String prefix, String suffix) throws IOException
    {
        writeln(bw, "  %s: array[0..%d - 1] of TTestResult =", arrayName, count);
        writeln(bw, "  (");

        for (int i = 0; i < count; ++i)
            formatResult(bw, results[i], (i == count - 1), String.format("%sArguments[%d]%s", prefix, i, suffix));
        writeln(bw, "  );");
        writeln(bw);
    }

    static void writeBinaryResults(BufferedWriter bw, String ArrayName, TestResult[] results, int count, String op) throws IOException
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
                formatResult(bw, results[n], (i == count - 1 && j == count - 1), String.format("%4d: Arguments[%d] %s Arguments[%d]", n, i, op, j));
            }
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void writeShiftResults(BufferedWriter bw, String ArrayName, TestResult[] results, int count, int shiftCount, String op) throws IOException
    {
        // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
        // There may be a better way to achieve this, but hey, it works.

        int high = results.length - 1;

        writeln(bw, "  %s: array[0..ArgumentCount * ShiftCount - 1] of TTestResult =", ArrayName);
        writeln(bw, "  (");
        int n = 0;
        for (int i = 0; i < count; ++i)
            for (int j = 0; j < shiftCount; ++j, ++n)
                formatResult(bw, results[n], (n == high), String.format("Arguments[%d] %s %d", i, op, BITSHIFTS[j]));
        writeln(bw, "  );");
        writeln(bw);
    }

    static void writeDate(BufferedWriter bw, String fileName) throws IOException
    {
        DateFormat df = new SimpleDateFormat("dd MMM, yyyy, HH:mm:ss");
        Date today = Calendar.getInstance().getTime();
        String reportDate = df.format(today);

        writeln(bw, "// %-96s //", "");
        writeln(bw, "// %-96s //", "File: " + fileName);
        writeln(bw, "// %-96s //", "");
        writeln(bw, "// %-96s //", String.format("Test data for Velthuis.BigIntegers.pas, generated %s", reportDate));
        writeln(bw, "// %-96s //", "");
        writeln(bw, "// %-96s //", "Do not modify the generated data in this file.  Modify the data in the generator source file.");
        writeln(bw, "// %-96s //", "The source file for the generator is BigIntegerTestDataGenerator.java, in the Test subdirectory.");
        writeln(bw, "// %-96s //", "");
        writeln(bw, "// %-96s //", "The freely available NetBeans IDE (V8.1) was used to compile and run this project.");
        writeln(bw, "// %-96s //", "http://www.netbeans.org");
        writeln(bw, "// %-96s //", "");
        writeln(bw);
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
        writeln(bw, "  TComparisonResult = (crGreater, crGreaterEqual, crEqual, crLessEqual, crLess, crNotEqual);");
        writeln(bw);
    }


    static void writeData(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int shiftCount = BITSHIFTS.length;
        int doubleCount = DOUBLES.length;
        int bitCount = BITS.length;

        writeln(bw, "const");
        writeln(bw, "  ArgumentCount = %d;", count);
        writeln(bw, "  TestCount     = ArgumentCount;");
        writeln(bw, "  ShiftCount    = %d;", shiftCount);
        writeln(bw, "  DoubleCount   = %d;", doubleCount);
        writeln(bw, "  BitCount      = %d;", bitCount);
        writeln(bw);

        // Arguments array
        writeln(bw, "  Arguments: array[0..ArgumentCount - 1] of string =");
        writeln(bw, "  (");
        for (int i = 0; i < count; ++i)
        {
            boolean isLast = (i == count - 1);
            String[] parts = splitString(ARGUMENTS[i], DEFAULT_STRING_WIDTH);

            for (int j = 0; j < parts.length; j++)
            {
                String s = parts[j];
                bw.write(String.format("    %-" + DEFAULT_STRING_WIDTH + "s", "'" + s + ((i < count - 1) && (j == parts.length - 1) ? "'," : "' ")));
                if (j < parts.length - 1)
                    writeln(bw, "+ ");
                else
                    writeln(bw, "     // %d", i);
            }
        }       
        writeln(bw, "  );");
        writeln(bw);

        // BitShifts array
        writeln(bw, "  BitShifts: array[0..ShiftCount - 1] of Integer =");
        bw.write("  (");
        for (int i = 0; i < shiftCount; ++i)
        {
            if ((i % 8) == 0)
            {
                writeln(bw);
                bw.write("    ");
            }
            bw.write(String.format("%4d%s", BITSHIFTS[i], (i < shiftCount - 1) ? "," : " "));
        }
        writeln(bw);
        writeln(bw, "  );");

        // Doubles array
        writeln(bw);
        writeln(bw, "  Doubles: array[0..DoubleCount - 1] of Double =");
        writeln(bw, "  (");
        for (int i = 0; i < DOUBLES.length; i++)
        {
            writeln(bw, "    %-1.18g%s", DOUBLES[i], i == (DOUBLES.length - 1) ? "" : ",");
        }
        writeln(bw, "  );");
        writeln(bw);
        
        // Bits array
        writeln(bw);
        writeln(bw, "  Bits: array[0..BitCount - 1] of Integer =");
        writeln(bw, "  (");
        bw.write("    ");
        for (int i = 0; i < bitCount; i++)
        {
            bw.write(String.format("%d%s", BITS[i], i == (bitCount - 1) ? "" : ", "));
        }
        writeln(bw);
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void generateAddResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.add(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "AddResults", results, count, "+");
    }

    static void generateSubtractResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.subtract(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "SubtractResults", results, count, "-");
    }
    
    static void generateMultiplyResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.multiply(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "MultiplyResults", results, count, "*");
    }

    static void generateDivisionResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];
        TestResult tr;

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                BigInteger d3;

                tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                try
                {
                    d3 = d1.divide(d2);
                    tr.val = d3.toString();
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = e.getMessage();
                    writeln("(%02d,%02d) -- Division error: %s", i, j, e.getMessage());
                }

                // No need to do the reverse, right? e.g. d4 = d3 * d2 + d1 % d2, check if d4 = d1, and if not, reverseDivision
                // This could be useful for DivMod, but not for this routine.

                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "DivisionResults", results, count, "div");
    }

    static void generateModulusResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];
        TestResult tr;

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                BigInteger d3;

                tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                try
                {
                    d3 = d1.remainder(d2);
                    tr.val = d3.toString();
                }
                catch (ArithmeticException e)
                {
                    tr.info = TestResultInfo.DivideByZero;
                    tr.val = e.getMessage();
                    writeln("(%02d,%02d) -- Division error: %s", i, j, e.getMessage());
                }

                // No need to do the reverse, right? e.g. d4 = d3 * d2 + d1 % d2, check if d4 = d1, and if not, reverseDivision
                // This could be useful for DivMod, but not for this routine.

                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "ModulusResults", results, count, "mod");
    }

    static void generateBitwiseAndResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.and(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "BitwiseAndResults", results, count, "and");
    }

    static void generateBitwiseOrResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.or(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "BitwiseOrResults", results, count, "or");
    }

    static void generateBitwiseXorResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                // Test operation.
                BigInteger d2 = new BigInteger(data[j]);
                TestResult tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                BigInteger d3 = d1.xor(d2);

                tr.val = d3.toString();
                results[n] = tr;
            }
        }
        
        writeBinaryResults(bw, "BitwiseXorResults", results, count, "xor");
    }
    
    static void generateSetBitResults(BufferedWriter bw) throws IOException
    {
        String[] arguments = ARGUMENTS;
        int count = arguments.length;
        int[] bits = BITS;
        int bitCount = bits.length;
        int n = 0;
        
        writeln(bw, "  SetBitResultCount = %d;", count * bitCount);
        writeln(bw, "  SetBitResults: array[0.. SetBitResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
            BigInteger d1 = new BigInteger(arguments[i]);
            for (int j = 0; j < bitCount; j++, n++)
            {
                int bit = bits[j];
                TestResult tr = new TestResult();
                BigInteger d2 = d1.setBit(bit);
                tr.info = TestResultInfo.Ok;
                tr.val = d2.toString();
        
                formatResult(bw, tr, n == (count * bitCount - 1), String.format("Arguments[%d].SetBit(%d)", i, bit));
            }
        }
    
        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateClearBitResults(BufferedWriter bw) throws IOException
    {
        String[] arguments = ARGUMENTS;
        int count = arguments.length;
        int[] bits = BITS;
        int bitCount = bits.length;
        int n = 0;
        
        writeln(bw, "  ClearBitResultCount = %d;", count * bitCount);
        writeln(bw, "  ClearBitResults: array[0..ClearBitResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
            BigInteger d1 = new BigInteger(arguments[i]);
            for (int j = 0; j < bitCount; j++, n++)
            {
                int bit = bits[j];
                TestResult tr = new TestResult();
                BigInteger d2 = d1.clearBit(bit);
                tr.info = TestResultInfo.Ok;
                tr.val = d2.toString();
        
                formatResult(bw, tr, n == (count * bitCount - 1), String.format("Arguments[%d].ClearBit(%d)", i, bit));
            }
        }
    
        writeln(bw, "  );");
        writeln(bw);
    }
    
    static void generateFlipBitResults(BufferedWriter bw) throws IOException
    {
        
        String[] arguments = ARGUMENTS;
        int count = arguments.length;
        int[] bits = BITS;
        int bitCount = bits.length;
        int n = 0;
        
        writeln(bw, "  FlipBitResultCount = %d;", count * bitCount);
        writeln(bw, "  FlipBitResults: array[0..FlipBitResultCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
            BigInteger d1 = new BigInteger(arguments[i]);
            for (int j = 0; j < bitCount; j++, n++)
            {
                int bit = bits[j];
                TestResult tr = new TestResult();
                BigInteger d2 = d1.flipBit(bit);
                tr.info = TestResultInfo.Ok;
                tr.val = d2.toString();
        
                formatResult(bw, tr, n == (count * bitCount - 1), String.format("Arguments[%d].FlipBit(%d)", i, bit));
            }
        }
    
        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateNegationResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;

        TestResult[] results = new TestResult[count];
        TestResult tr;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            BigInteger d2 = d1.negate();
            tr = new TestResult();
            
            tr.info = TestResultInfo.Ok;
            tr.val = d2.toString();
            results[i] = tr;
        }

        writeUnaryResults(bw, "NegationResults", results, count, "Negate(", ")");
    }

    static void generateLogicalNotResults(BufferedWriter bw) throws IOException
    {
        String[] data = ARGUMENTS;
        int count = data.length;

        TestResult[] results = new TestResult[count];
        TestResult tr;

        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(data[i]);
            BigInteger d2 = d1.not();
            tr = new TestResult();
            tr.info = TestResultInfo.Ok;
            tr.val = d2.toString();
            results[i] = tr;
        }

        writeUnaryResults(bw, "LogicalNotResults", results, count, "not ", "");
    }

    static void generateLeftShiftResults(BufferedWriter tw) throws IOException
    {
        int count = ARGUMENTS.length;
        int shiftCount = BITSHIFTS.length;

        TestResult[] results = new TestResult[count * shiftCount];
        TestResult tr;

        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(ARGUMENTS[i]);
            for (int j = 0; j < shiftCount; ++j, n++)
            {
                int d2 = BITSHIFTS[j];
                BigInteger d3 = d1.shiftLeft(d2);
                tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                tr.val = d3.toString();
                results[n] = tr;
            }
        }

        writeShiftResults(tw, "LeftShiftResults", results, count, shiftCount, "shl");
    }

    static void generateRightShiftResults(BufferedWriter tw) throws IOException
    {
        int count = ARGUMENTS.length;
        int shiftCount = BITSHIFTS.length;

        TestResult[] results = new TestResult[count * shiftCount];
        TestResult tr;

        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(ARGUMENTS[i]);
            for (int j = 0; j < shiftCount; ++j, n++)
            {
                int d2 = BITSHIFTS[j];
                BigInteger d3 = d1.shiftRight(d2);
                tr = new TestResult();
                tr.info = TestResultInfo.Ok;
                tr.val = d3.toString();
                results[n] = tr;
            }
        }

        writeShiftResults(tw, "RightShiftResults", results, count, shiftCount, "shl");
    }

    static String toExactString(final double d)
    {
        if (Double.isNaN(d))
            return "NaN";
        if (Double.isInfinite(d))
            return d < 0 ? "NegInfinity" : "Infinity";
           
        BigDecimal dec = new BigDecimal(d);
        String result = dec.toPlainString();
        if (!result.contains("."))
            result = result + ".0";
        return result;
    }
    
    static void writeDoubleResults(BufferedWriter bw, String arrayName, double[] results, int count, String func) throws IOException
    {
        writeln(bw, "  %s: array[0..ArgumentCount - 1] of Double =", arrayName);
        writeln(bw, "  (");

        for (int i = 0; i < count; ++i)
        {
            double d = results[i];
            String result = toExactString(d);
            result = (i < count - 1) ? result + "," : result;
            writeln(bw, "    %-75s // %s(Arguments[%d])", result, func, i);
        }
        writeln(bw, "  );");
        writeln(bw);
    }
    
    // Unlike .NET's BigInteger, Java's BigInteger does not have a log() 
    // method. This emulates it (rather slowly, I admit):
    static double logarithm(final BigInteger value, final double baseValue)
    {
        if (value.signum() < 0 || baseValue == 1.0)
            return Double.NaN;
        if (value.signum() == 0)
            return Double.NEGATIVE_INFINITY;
        if (baseValue == Double.POSITIVE_INFINITY)
            return value.equals(BigInteger.ONE) ? 0.0 : Double.NaN;
        if (baseValue == 0.0 && !value.equals(BigInteger.ONE))
            return Double.NaN;
        if (value.equals(BigInteger.ONE))
            return 0.0;

        double c = 0, d = 0.5;
        final double log2 = 0.69314718055994529;

        byte[] byteArray = value.toByteArray();

        int bitlen = value.bitLength();
        int byteLength = byteArray.length;
        int index = 0;
        if (byteArray[0] == (byte)0)
            index++;
        int topbits = bitlen - 8 * (byteLength - 1); 
        if (topbits <= 0)
            topbits += 8;
        int indbit = (int)1 << (topbits - 1);

        for(; index < byteLength; ++index)
        {
            while (indbit != 0)
            {
                if ((byteArray[index] & indbit) != 0)
                    c += d;
                d *= 0.5;
                indbit >>= 1;
            }
            indbit = 128;
        }
        return (Math.log(c) + log2 * bitlen) / Math.log(baseValue);
    }
    
    static double log(final BigInteger value)
    {
        return logarithm(value, Math.exp(1));
    }
    
    static double log10(final BigInteger value)
    {
        return logarithm(value, 10.0);
    }
    
    static void generateLnResults(BufferedWriter bw) throws IOException
    { 
        int count = ARGUMENTS.length;
        double[] results = new double[count];

        for (int i = 0; i < count; ++i)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);
            results[i] = log(b1);
        }

        writeDoubleResults(bw, "LnResults", results, count, "Ln");

        BigInteger b = BigInteger.valueOf(1000).pow(1000);
        double d1 = log(b);
        double d2 = log10(b);
        double d3 = logarithm(b, 2.0);
        writeln(bw, "  Ln_1000_1000    = %s;", toExactString(d1));
        writeln(bw, "  Log10_1000_1000 = %s;", toExactString(d2));
        writeln(bw, "  Log2_1000_1000  = %s;", toExactString(d3));
        writeln(bw);
    }

    static void generatePowerResults(BufferedWriter bw) throws IOException
    {
        int count = BITSHIFTS.length;
        
        writeln(bw, "  PowerResultsCount = %d;", count * count);
        writeln(bw, "  PowerResults: array[0..PowerResultsCount - 1] of TTestResult =");
        writeln(bw, "  (");

        int n = 0;
        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = BigInteger.valueOf(BITSHIFTS[i]);
            for (int j = 0; j < count; ++j, ++n)
            {
                int d2 = BITSHIFTS[j];
                TestResult tr = new TestResult();
                tr.val = d1.pow(d2).toString();
                tr.info = TestResultInfo.Ok;
                formatResult(bw, tr, n == count * count - 1, String.format("(%d): %d ^ %d", n, BITSHIFTS[i], BITSHIFTS[j]));
            }
        }
        writeln(bw, "  );");
        writeln(bw);
    
    }
    
    static void generateModPowResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        int num = count / 5 + 1;
        int total = num * num * num;
        
        writeln(bw, "  ModPowResultsCount = %d;", total);
        writeln(bw, "  ModPowResults: array[0..ModPowResultsCount - 1] of TTestResult =");
        writeln(bw, "  (");

        int n = 0;
        // Starting at 2, 0, 1 resp. produces a few exceptions, as desired.
        for (int i = 2; i < count; i += 5)
        {
            BigInteger d1 = new BigInteger(ARGUMENTS[i]).abs();
            for (int j = 0; j < count; j += 5)
            {
                BigInteger d2 = new BigInteger(ARGUMENTS[j]).abs();
                for (int k = 1; k < count; k += 5, ++n)
                {
                    BigInteger d3 = new BigInteger(ARGUMENTS[k]).abs();
                    TestResult tr = new TestResult();
                    
                    try
                    {
                        BigInteger d4 = d1.modPow(d2, d3);
                        tr.val = d4.toString();
                        tr.info = TestResultInfo.Ok;
                    }
                    catch (Exception e)
                    {
                        writeln("(%d,%d,%d,%d): ModPow error: %s", i, j, k, n, e.getMessage());
                        tr.val = e.getMessage();
                        tr.info = TestResultInfo.DivideByZero;
                    }
                    
                    formatResult(bw, tr, n == total - 1, String.format("(%d): ModPow(Arguments[%d], Arguments[%d], Arguments[%d])", n, i, j, k));
                }
            }
        }
        writeln(bw, "  );");
        writeln(bw);
    
    }
    
    static String bool(boolean b)
    {
        return b ? "True" : "False";
    }
    
    static void generateComparisonResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        boolean[][] results = new boolean[count * count][6];

        writeln(bw, "  ComparisonResults: array[0..ArgumentCount * ArgumentCount - 1, TComparisonResult] of Boolean =");
        writeln(bw, "  (");

        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);

            for (int j = 0; j < count; j++, n++)
            {
                BigInteger b2 = new BigInteger(ARGUMENTS[j]);

                writeln(bw, "    (%5s, %5s, %5s, %5s, %5s, %5s)%s         // Arguments[%d] <-> Arguments[%d]", 
                        bool(b1.compareTo(b2) > 0), bool(b1.compareTo(b2) >= 0), bool(b1.compareTo(b2) == 0), 
                        bool(b1.compareTo(b2) <= 0), bool(b1.compareTo(b2) < 0), bool(b1.compareTo(b2) != 0), 
                        (n < count * count - 1) ? "," : " ", i, j); 
            }
        }
        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateGCDResults(BufferedWriter bw) throws IOException 
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);

            for (int j = 0; j < count; j++, n++)
            {
                BigInteger b2 = new BigInteger(ARGUMENTS[j]);

                BigInteger b3 = b1.gcd(b2);
                TestResult tr = new TestResult();
                tr.val = b3.toString();
                tr.info = TestResultInfo.Ok;
                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "GCDResults", results, count, "gcd");
    }
    
    static void generateInvModResults(BufferedWriter bw) throws IOException
    {
        
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);

            for (int j = 0; j < count; j++, n++)
            {
                BigInteger b2 = new BigInteger(ARGUMENTS[j]);

                TestResult tr = new TestResult();
                try
                {
                    BigInteger b3 = b1.abs().modInverse(b2.abs());
                    if (b3.signum() == 0)
                    {
                        tr.val = "Error: Zero result -- Java is wrong";
                        writeln("(%d,%d,%d): Zero result", i, j, n);
                        tr.info = TestResultInfo.ArgumentRange;
                    }
                    else
                    {
                        tr.val = b1.signum() < 0 ? "-" + b3.toString() : b3.toString();
                        tr.info = TestResultInfo.Ok;
                    }
                }
                catch (ArithmeticException e)
                {
                    tr.val = "Error: " + e.getMessage();
                    tr.info = TestResultInfo.ArgumentRange;
                    writeln("(%d,%d,%d): No modular inverse", i, j, n);
                }
                        
                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "InvModResults", results, count, "invMod");
    }

    static void generateMinResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);
            for (int j = 0; j < count; j++, n++)
            {
                BigInteger b2 = new BigInteger(ARGUMENTS[j]);
                BigInteger b3 = b1.min(b2);
                
                TestResult tr = new TestResult();

                tr.info = TestResultInfo.Ok;
                tr.val = b3.toString();
                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "MinResults", results, count, "min");
    }

    static void generateMaxResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count * count];

        int n = 0;
        for (int i = 0; i < count; i++)
        {
            BigInteger b1 = new BigInteger(ARGUMENTS[i]);
            for (int j = 0; j < count; j++, n++)
            {
                BigInteger b2 = new BigInteger(ARGUMENTS[j]);
                BigInteger b3 = b1.max(b2);

                TestResult tr = new TestResult();
                
                tr.info = TestResultInfo.Ok;
                tr.val = b3.toString();
                results[n] = tr;
            }
        }

        writeBinaryResults(bw, "MaxResults", results, count, "max");
    }
    
    static BigInteger factorial(int n)
    {
        BigInteger result = BigInteger.ONE;
        
        if (n < 2)
            return BigInteger.ONE;
        
        for (int i = 2; i <= n; i++)
        {
            result = result.multiply(BigInteger.valueOf(i));
        }
        
        return result;
    }
    
    static void generateFactorialResults(BufferedWriter bw) throws IOException
    {
        int count = BITSHIFTS.length;
        TestResult[] results = new TestResult[count];
        
        for (int i = 0; i < count; i++)
        {
            BigInteger b = factorial(BITSHIFTS[i]);
            
            TestResult tr = new TestResult();
            
            tr.info = TestResultInfo.Ok;
            tr.val = b.toString();
            results[i] = tr; 
        }
        
        writeUnaryResults(bw, "FactorialResults", results, count, "Factorial(", ")");
    }
    
    static String generateRandomStringForBase(int maxLength, int base, Random rand)
    {
        
        final String PARSECHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; 
        
        StringBuilder sb = new StringBuilder();
        int length = 2 + rand.nextInt(maxLength - 2);
        
        for (int i = 0; i < length; i++)
        {
            int r = rand.nextInt(base + 1);
            if (r >= PARSECHARS.length())
                r = PARSECHARS.length() - 1;
            sb.append(PARSECHARS.charAt(r));
        }
        
        return sb.toString();
    }
    
    static void generateTryParseResults(BufferedWriter bw) throws IOException
    {
        // Generate strings
        final int STRINGS = 90;
        Random rand = new Random(1234567);
        int errors = 0;

        writeln(bw, "type");
        writeln(bw, "  TTryParseResult = record");
        writeln(bw, "    Str: string;");
        writeln(bw, "    Str10: string;");
        writeln(bw, "    Base: Integer;");
        writeln(bw, "    Result: Boolean;");
        writeln(bw, "  end;");
        writeln(bw);
        
        writeln(bw, "const");
        writeln(bw, "  TryParseResults: array[0..%d] of TTryParseResult =", STRINGS - 1);
        writeln(bw, "  (");
        
        for (int i = 0; i < STRINGS; i++)
        {
            int base = BASES[rand.nextInt(BASES.length)];
            String s = generateRandomStringForBase(20, base, rand);
            String s10;
            boolean success = true;
            try
            {
                BigInteger b = new BigInteger(s, base);
                s10 = b.toString(10);
            }
            catch (NumberFormatException e) 
            {
                success = false;
                errors++;
                writeln("(%d): NumberFormatException %s, base = %d", i, e.getMessage(), base);
                s10 = "error";
            }
            
            writeln(bw, "    (Str: %-23s Str10: %-35s Base: %2d; Result: %s)%s", 
                String.format("'%s';", s), 
                String.format("'%s';", s10),
                base, success ? "True" : "False", i == STRINGS - 1 ? "" : ",");
        }
        writeln(bw, "  );");
        writeln("%d errors.", errors);
        writeln();
    }

    static void generateByteArrayResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            BigInteger b = new BigInteger(ARGUMENTS[i]);
            byte[] bArray = b.toByteArray();
            int bArrayLength = bArray.length;

            StringBuilder sb = new StringBuilder(bArrayLength * 2);
            
            // Reverse, because Java returns a big-endian array, and 
            // Velthuis.BigIntegers (just like .NET BigIntegers) are 
            // little-endian
            for (int j = bArrayLength - 1; j >= 0; j--)
                sb.append(String.format("%02X", bArray[j]));
            
            TestResult tr = new TestResult();

            tr.val = sb.toString();
            tr.info = TestResultInfo.Ok;
            results[i] = tr;
        }

        writeUnaryResults(bw, "ByteArrayResults", results, count, "", ".ToByteArray");
    }

    static void generateHexResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            // This could be so easy, if not .NET would add a "0" in front of some values and if
            // it displayed negative values as negative, just like in decimal mode.

            BigInteger b = new BigInteger(ARGUMENTS[i]);
            
            TestResult tr = new TestResult();
            String s = b.abs().toString(16).toUpperCase();
            if (s.length() > 1 && s.charAt(0) == '0')
                s = s.substring(1); // get rid of leading 0
            if (b.signum() < 0)
                s = "-" + s;        // if negative, show it
            
            tr.info = TestResultInfo.Ok;
            tr.val = s;
            results[i] = tr;
        }

        writeUnaryResults(bw, "HexResults", results, count, "", ".ToString(16)");
    }

    static void generateAsIntegerResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            BigInteger b = new BigInteger(ARGUMENTS[i]);
            TestResult tr = new TestResult();

            tr.info = TestResultInfo.Ok;
            try
            {
                int bi = b.intValueExact();
                tr.val = String.format("%d", bi);
            }
            catch (Exception e)
            {
                writeln("Error: %s (%s)", e.getMessage(), b);
                tr.info = TestResultInfo.Overflow;
                tr.val = "Overflow";
            }
            results[i] = tr;
        }

        writeUnaryResults(bw, "AsIntegerResults", results, count, "", ".AsInteger");
    }

    static void generateAsCardinalResults(BufferedWriter bw) throws IOException
    {
        
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            BigInteger b = new BigInteger(ARGUMENTS[i]);
            TestResult tr = new TestResult();

            tr.info = TestResultInfo.Ok;
            try
            {
                // Java has no uint32 types, so they must be faked.
                long blong = b.longValueExact();
                long bcard = blong & 0xFFFFFFFFL;
                if (blong < 0L || blong != bcard)
                {
                    writeln("Calculated overflow %s --> %X", b, bcard);
                    tr.val = "Overflow"; 
                    tr.info = TestResultInfo.Overflow;        
                }
                else
                {
                    tr.val = String.format("%d", bcard);
                }
            }
            catch (Exception e)
            {
                writeln("Error: %s (%s)", e.getMessage(), b);
                tr.info = TestResultInfo.Overflow;
                tr.val = "Overflow";
            }
            results[i] = tr;
        }

        writeUnaryResults(bw, "AsCardinalResults", results, count, "", ".AsCardinal");
    }
    
    static void generateAsInt64Results(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            BigInteger b = new BigInteger(ARGUMENTS[i]);
            TestResult tr = new TestResult();

            tr.info = TestResultInfo.Ok;
            try
            {
                long bi = b.longValueExact();
                tr.val = String.format("%d", bi);
            }
            catch (Exception e)
            {
                writeln("Error: %s (%s)", e.getMessage(), b);
                tr.info = TestResultInfo.Overflow;
                tr.val = "Overflow";
            }
            results[i] = tr;
        }

        writeUnaryResults(bw, "AsInt64Results", results, count, "", ".AsInt64");
    }

    static void generateAsUInt64Results(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        TestResult[] results = new TestResult[count];

        for (int i = 0; i < count; i++)
        {
            BigInteger b = new BigInteger(ARGUMENTS[i]);
            TestResult tr = new TestResult();

            tr.info = TestResultInfo.Ok;
            try
            {
                BigInteger bi = b.and(new BigInteger("0FFFFFFFFFFFFFFFF", 16));
                if (b.signum() < 0 || b.compareTo(bi) > 0)
                {
                    tr.val = "Overflow";
                    tr.info = TestResultInfo.Overflow;
                    writeln("AsUInt64: Calculated overflow %s --> %s", b.toString(16).toUpperCase(), bi.toString(16).toUpperCase());
                }   
                else
                {
                    tr.val = String.format("%s", bi);
                }
            }
            catch (Exception e)
            {
                writeln("Error: %s (%s)", e.getMessage(), b);
                tr.info = TestResultInfo.Overflow;
                tr.val = "Overflow";
            }
            results[i] = tr;
        }

        writeUnaryResults(bw, "AsUInt64Results", results, count, "", ".AsUInt64");
    }
    
    static void generateFromDoubleResults(BufferedWriter bw) throws IOException
    {
        int count = DOUBLES.length;
        TestResult[] results = new TestResult[count];

        writeln(bw);
        writeln(bw, "  CreateDoubleResults: array[0..DoubleCount - 1] of TTestResult =");
        writeln(bw, "  (");
        
        for (int i = 0; i < count; i++)
        {
            // In Java, there is no direct way to initialize from a double.
            // So we must use a detour: BigDecimal.
            
            double d = DOUBLES[i];
            TestResult tr = new TestResult();
            tr.info = TestResultInfo.Ok;
            
            BigDecimal dec = new BigDecimal(d);
            BigInteger b = dec.toBigInteger();
            tr.val = b.toString();
            
            formatResult(bw, tr, (i == count - 1), String.format("BigInteger.Create(%s)", toExactString(DOUBLES[i])));
        }

        writeln(bw, "  );");
        writeln(bw);
    }

    static void generateDoubleResults(BufferedWriter bw) throws IOException
    {
        int count = ARGUMENTS.length;
        double[] results = new double[count];
        
        for (int i = 0; i < count; ++i)
        {
            BigInteger d1 = new BigInteger(ARGUMENTS[i]);
            results[i] = d1.doubleValue();
        }

        writeDoubleResults(bw, "DoubleResults", results, count, "Double");
    }
    

    ///////////////////////////////////////////////////////////////////////////
    ///  Test data                                                          ///
    ///////////////////////////////////////////////////////////////////////////
    
    static String[] ARGUMENTS = new String[]
    {
        "-1585715829851573239739325670632039865384960", // -0x1234 00000000 00000000 00000000 00000000 
        "-18034965446809738563558854193883715207167",   //   -0x34 FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF  
        "-779879232593610263927748006161",
        "-82261793876695338192268955270",
        "-8840587743209014991486176890",
        "-499680576774082292410113726",
        "-7096499840976817344578600",
        "-74287305190053403856772",
        "-13416290973509623768074",
        "-8271324858169862655834",
        "-1673271581108184934182",
        "-100000",
        "-45808",
        "-10000",
        "-1000",
        "-100",
        "-56",
        "-10",
        "-7",
        "-2",
        "-1",
        "0",
        "1",
        "2",
        "7",
        "10",
        "100",
        "409",
        "818",
        "1000",
        "10000",
        "100000",
        "1000000",
        "4234575746049986044",
        "5387241703157997895",
        "9223372041149612032",
        "172872415652910937156",
        "977677435906606235647",                                                    // 0x34 FFFFFFFF FFFFFFFF 
        "1673271581108184934182",
        "8271324858169862655834",
        "13416290973509623768074",    
        "74287305190053403856772",
        "85961827383486510530560",
        "7096499840976817344578600",
        "499680576774082292410113726",
        "1243478184157339114435077574",
        "8840587743209014991486176890",
        "19807040619342712359383728129",
        "63733365657267277460012361609",
        "82261793876695338192268955270",
        "779879232593610263927748006161",
        "113110558780721284166510605813",
        "4847586039315419829807005894255429",
        "90612345123875509091827560007100099",
        "85070591730234615847396907784232501249",                                   // 0x3FFFFFFF FFFFFFFF 00000000 00000001
        "85070591730234615847396907784232501250",
        "680564693277057719623408366969033850880",
        "18034965446809738563558854193883715207167",                                // 0x34 FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF      
        "1585715829851573239739325670632039865384960",                              // 0x1234 00000000 00000000 00000000 00000000 
        "1234567890123456789012345678901234567890123456789012345678901234567890",   // 0x2D CAEC4C2D F4268937 664439BA 2F162FC2 D76998CB ACCFF196 CE3F0AD2

        // Add your own data after this.

        "343597383679999999999999999995663191310057982263970188796520233154296875",
        "3435973836799999999999999999956631913100579822639701887965202331542968750000000000000",
        "10000000000000",
        "1000000000000000000000000000000000000000000000000000000000"

    };

    static int[] BITSHIFTS = new int[]
    {
          1,   2,   3,   4,   5,   6,   7,   8,
          9,  10,  11,  12,  13,  14,  15,  20, 
         25,  30,  31,  32,  33,  35,  40,  50, 
         60,  70,  71,  72,  73,  74,  75,  90, 
        100, 110, 159, 160, 161, 162, 163, 164,
    };
    
    static int[] BITS = new int[]
    {
       1, 4, 10, 100, 1000
    };
    
    static int[] BASES = new int[]
    {
        2, 3, 8, 9, 10, 11, 16, 17, 36
    };

    static double[] DOUBLES = new double[]
    {
        -6.0E20,            
        -1.0E20,            
        -3.51,              
        -3.5,               
        -3.49,
        -2.51,              
        -2.5,               
        -2.49,              
        -2.0E-100,          
        0.0,
        7.0E-8,             
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
        1.0,                
        1.00000000000001,   
        1.1,                
        1.49999999999999,
        1.5,                
        1.50000000000001,   
        1.9999,             
        2.0,                
        2.49,
        2.5,                
        2.51,               
        3.0,                
        3.49,               
        3.5,
        3.51,               
        4.0,                
        4.1,                
        4.2,                
        4.4,
        4.5,                
        4.6,
        4.9999,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        10.0,
        15.0,
        22.0,
        44.0,
        85.0,
        128.0,
        256.0,
        256.1,
        256.5,
        256.7,
        300.0,
        876.543210987654,
        645000.0,
        1000000.49999999999999,
        1000000.5,
        1000000.50000000000001,
        1048576.1,
        1048576.5,
        10000000000.0,
        14900000000.0,
        15000000000.0,
        15100000000.0,
        31415920000.0,
        100000000000.0,
        1000000000000.0,
        10000000000000.0,
        100000000000000.0,
        1.0E15,
        2.0E15,
        4.0E15,
        4.9E15,
        8.0E15,
        1.0E16,
        2.0E16,
        4.0E16,
        5.0E16,
        1.0E17,
        1.0E18,
        1.0E19,
        1.23456789012346E19,
        1.0E20,
        1.0E14 + 1.0,
        1.0E14 + 2.0,
        1.0E14 + 4.0,
        1.0E14 + 8.0,
        1.0E14 + 16.0,
        1.0E14 + 32.0,
        1.0E14 + 64.0,
        1.0E14 + 128.0,
        1.0E14 + 256.0,
        1.0E14 + 512.0,
        1.0E80
    };

}










