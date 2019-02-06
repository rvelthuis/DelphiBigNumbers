/*                                                                           */
/* File:       BigIntegerTestGenerator.cs                                    */
/* Function:   Generates result tables for a set of big integers and the     */
/*             math operations on them, as an include file for the           */
/*             BigIntegerTest.dpr program, called BigIntegerTestData.inc.    */
/* Language:   C# 4.0 or above                                               */
/* Author:     Rudy Velthuis                                                 */
/* Copyright:  (c) 2015 Rudy Velthuis                                        */
/* Notes:      Can be compiled with the freely available Microsoft C#        */
/*             Express IDE.                                                  */
/*             See http://rvelthuis.de/programs/bigintegers.html             */
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


using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;
using System.Globalization;

namespace TestBigIntegers
{
    class ResultGenerator
    {
        const int DefaultStringWidth = 40;

        public enum TestResultInfo
        {
            Ok,
            DivideByZero,
            ArgumentNull,
            ArgumentRange,
            Format,
            Overflow
        }

        public struct TestResult
        {
            public TestResultInfo info;
            public string val;
        }

        static void Main(string[] args)
        {
            DoubleConverter.SpecialValues[0] = "Infinity";      // "+INF";
            DoubleConverter.SpecialValues[1] = "NegInfinity";   // "-INF";
            DoubleConverter.SpecialValues[2] = "NaN";           // "NAN";

            using (StreamWriter sw = NewWriter("BigIntegerTestResults.inc.inc"))
            {
                WriteDate(sw);
                WriteTypes(sw);
                WriteData(sw);
            }

            using (StreamWriter sw = NewWriter("BigIntegerArithmeticResults.inc.inc"))
            {
                GenerateAddResults(sw);
                GenerateSubtractResults(sw);
                GenerateMultiplyResults(sw);
                GenerateDivisionResults(sw);
                GenerateModulusResults(sw);
            }

            using (StreamWriter sw = NewWriter("BigIntegerBitwiseResults.inc.inc"))
            {
                GenerateBitwiseAndResults(sw);
                GenerateBitwiseOrResults(sw);
                GenerateBitwiseXorResults(sw);
                GenerateNegationResults(sw);
                GenerateLogicalNotResults(sw);
                GenerateLeftShiftResults(sw);
                GenerateRightShiftResults(sw);
            }

            using (StreamWriter sw = NewWriter("BigIntegerMathResults.inc.inc"))
            {
                GenerateLnResults(sw);
                GeneratePowerResults(sw);
                GenerateModPowResults(sw);
                GenerateComparisonResults(sw);
                GenerateGCDResults(sw);
                GenerateMinResults(sw);
                GenerateMaxResults(sw);
            }

            using (StreamWriter sw = NewWriter("BigIntegerConvertResults.inc.inc"))
            {
                GenerateByteArrayResults(sw);
                GenerateHexResults(sw);
                GenerateAsIntegerResults(sw);
                GenerateAsCardinalResults(sw);
                GenerateAsInt64Results(sw);
                GenerateAsUInt64Results(sw);
                GenerateFromDoubleResults(sw);
                GenerateDoubleResults(sw);
            }

            Console.WriteLine();
            Console.Write("Press any key...");
            Console.ReadKey();
        }


        static StreamWriter NewWriter(string fileName)
        {
            return new StreamWriter("..\\..\\..\\..\\..\\..\\Tests\\BigIntegers\\" + fileName);
        }


        static string[] SplitString(string s, int width)
        {
            List<string> results = new List<string>();

            if (s == null || s.Length == 0)
                return new String[] { "" };

            while (s.Length > 0)
            {
                results.Add(s.Substring(0, s.Length > width ? width : s.Length));
                s = s.Substring(s.Length > width ? width : s.Length);
            }
            return results.ToArray<string>();
        }

        static void WriteDate(TextWriter tw)
        {
            DateTime dt = DateTime.Now;

            tw.WriteLine("// {0,-95} //", "");
            tw.WriteLine("// {0,-95} //", String.Format("Test data for BigIntegers.pas, generated {0}", dt));
            tw.WriteLine("// {0,-95} //", "");
            tw.WriteLine("// {0,-95} //", "Do not modify the generated data in this file.  Modify the data in the generator source file.");
            tw.WriteLine("// {0,-95} //", "The source file for the generator is BigIntegerTestGenerator.cs, in the Test subdirectory.");
            tw.WriteLine("// {0,-95} //", "");
            tw.WriteLine("// {0,-95} //", "The generator was written in C#, using Microsoft Visual C# 2010 Express");
            tw.WriteLine("// {0,-95} //", "");
            tw.WriteLine();

            Console.WriteLine("Test data generator for BigIntegers.pas");
            Console.WriteLine("---------------------------------------");
            Console.WriteLine();
            Console.WriteLine("This program generates the include file BigIntegerTestResults.inc,");
            Console.WriteLine("which is used by the test programs for BigIntegers.pas");
            Console.WriteLine();
            Console.WriteLine("You'll see a list of errors. This is expected. The generated errors are");
            Console.WriteLine("registered and written to the test data include file generated by this program");
            Console.WriteLine();
            Console.Write("Press any key...");
            Console.ReadKey();
            Console.WriteLine();
        }

        static void WriteTypes(TextWriter tw)
        {
            TestResultInfo[] infos = (TestResultInfo[])Enum.GetValues(typeof(TestResultInfo));
            tw.WriteLine("type");
            tw.WriteLine("  TTestResultInfo =");
            tw.WriteLine("  (");
            foreach (TestResultInfo info in infos)
                tw.WriteLine("    tri{0}{1}", info, info != infos[infos.Length - 1] ? "," : " ");
            tw.WriteLine("  );");
            tw.WriteLine();
            tw.WriteLine("  TTestResult = record");
            tw.WriteLine("    info: TTestResultInfo;");
            tw.WriteLine("    val: string;");
            tw.WriteLine("  end;");
            tw.WriteLine();
            tw.WriteLine("  TComparisonResult = (crGreater, crGreaterEqual, crEqual, crLessEqual, crLess, crNotEqual);");
            tw.WriteLine();
        }

        static void WriteData(TextWriter tw)
        {
            int count = testData.Length;
            int shiftCount = bitShifts.Length;

            tw.WriteLine("const");
            tw.WriteLine("  TestCount   = {0};", count);
            tw.WriteLine("  ShiftCount  = {0};", bitShifts.Length);
            tw.WriteLine("  DoubleCount = {0};", doubles.Length);
            tw.WriteLine();

            // Arguments array
            tw.WriteLine("  Arguments: array[0..TestCount - 1] of string =");
            tw.WriteLine("  (");
            for (int i = 0; i < count; ++i)
            {
                bool isLast = (i == count - 1);
                string[] parts = SplitString(testData[i], DefaultStringWidth);

                for (int j = 0; j < parts.Length; j++)
                {
                    string s = parts[j];
                    tw.Write("    {0,-43}", "'" + s + ((i < count - 1) && (j == parts.Length - 1) ? "'," : "' "));
                    if (j < parts.Length - 1)
                        tw.WriteLine("+ ");
                    else
                        tw.WriteLine("     // {1}", i < count - 1 ? "," : " ", i);
                }
            }       
            tw.WriteLine("  );");
            tw.WriteLine();

            // BitShifts array
            tw.WriteLine("  BitShifts: array[0..ShiftCount - 1] of Integer =");
            tw.Write("  (");
            for (int i = 0; i < shiftCount; ++i)
            {
                if ((i % 8) == 0)
                {
                    tw.WriteLine();
                    tw.Write("    ");
                }
                tw.Write("{0,4}{1}", bitShifts[i], (i < shiftCount - 1) ? "," : " ");
            }
            //if (shiftCount % 8 != 0)
                tw.WriteLine();
            tw.WriteLine("  );");

            // Doubles array
            tw.WriteLine();
            tw.WriteLine("  Doubles: array[0..DoubleCount - 1] of Double =");
            tw.WriteLine("  (");
            for (int i = 0; i < doubles.Length; i++)
            {
                tw.WriteLine("    {0}{1}", doubles[i].ToString(CultureInfo.InvariantCulture), i == (doubles.Length - 1) ? "" : ",");
            }
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void FormatResult(TextWriter tw, TestResult result, bool isLast, string comment)
        {
            string info = String.Format("tri{0};", result.info);
            string[] values = SplitString(result.val, DefaultStringWidth);

            for (int k = 0; k < values.Count(); k++)
            {
                if (k == 0)
                    tw.Write("    (info: {0,-17} val: '{1}'", info, values[k]);
                else
                    tw.Write("{0,34}'{1}'", ' ', values[k]);
                if (k < values.Count() - 1)
                    tw.WriteLine(" + ");
                else
                {
                    string lineEnd = ")" + (isLast ? "" : ",");
                    tw.WriteLine(lineEnd + new String(' ', 44 - lineEnd.Length - values[k].Length) + "// {0}", comment);
                }
            }
        }

        static void WriteMonadicResults(TextWriter tw, string ArrayName, TestResult[] results, int count, string prefix, string suffix)
        {
            tw.WriteLine("  {0}: array[0.. TestCount - 1] of TTestResult =", ArrayName);
            tw.WriteLine("  (");

            for (int i = 0; i < count; ++i)
                FormatResult(tw, results[i], (i == count - 1), String.Format("{0}Arguments[{1}]{2}", prefix, i, suffix));
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteDyadicResults(TextWriter tw, string ArrayName, TestResult[] results, int count, string op)
        {
            // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
            // There may be a better way to achieve this, but hey, it works.

            tw.WriteLine("  {0}: array[0..TestCount * TestCount - 1] of TTestResult =", ArrayName);
            tw.WriteLine("  (");
            int n = 0;
            for (int i = 0; i < count; ++i)
                for (int j = 0; j < count; ++j, ++n)
                    FormatResult(tw, results[n], (i == count - 1 && j == count - 1), String.Format("{3,4}: Arguments[{0}] {1} Arguments[{2}]", i, op, j, n));
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteDyadicResults(TextWriter tw, string ArrayName, TestResult[] results, int count, string op, string counter, string origin)
        {
            // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
            // There may be a better way to achieve this, but hey, it works.

            tw.WriteLine("  {0}: array[0..{1} * {1} - 1] of TTestResult =", ArrayName, counter);
            tw.WriteLine("  (");
            int n = 0;
            for (int i = 0; i < count; ++i)
                for (int j = 0; j < count; ++j, ++n)
                    FormatResult(tw, results[n], (i == count - 1 && j == count - 1), String.Format("{3}[{0}] {1} {3}[{2}]", i, op, j, origin));
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteShiftResults(TextWriter tw, string ArrayName, TestResult[] results, int count, int shiftCount, string op)
        {
            // This routine goes out of its way to nicely indent and format the strings into 40 character portions.
            // There may be a better way to achieve this, but hey, it works.

            int high = results.Length - 1;

            tw.WriteLine("  {0}: array[0..TestCount * ShiftCount - 1] of TTestResult =", ArrayName);
            tw.WriteLine("  (");
            int n = 0;
            for (int i = 0; i < count; ++i)
                for (int j = 0; j < shiftCount; ++j, ++n)
                    FormatResult(tw, results[n], (n == high), String.Format("Arguments[{0}] {1} {2}", i, op, bitShifts[j]));
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void GenerateAddResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 + d2;

                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "AddResults", results, count, "+");
        }

        static void GenerateSubtractResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 - d2;

                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "SubtractResults", results, count, "-");
        }

        static void GenerateMultiplyResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 * d2;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "MultiplyResults", results, count, "*");
        }

        static void GenerateDivisionResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    try
                    {
                        d3 = d1 / d2;
                        tr.val = d3.ToString();
                    }
                    catch (DivideByZeroException e)
                    {
                        tr.info = TestResultInfo.DivideByZero;
                        tr.val = e.Message;
                        Console.WriteLine("{0,2},{1,2} -- Division error: {2}", i, j, e.Message);
                    }

                    // No need to do the reverse, right? e.g. d4 = d3 * d2 + d1 % d2, check if d4 = d1, and if not, reverseDivision
                    // This could be useful for DivMod, but not for this routine.

                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "DivisionResults", results, count, "div");
        }

        static void GenerateModulusResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    try
                    {
                        d3 = d1 % d2;
                        tr.val = d3.ToString();
                    }
                    catch (DivideByZeroException e)
                    {
                        tr.info = TestResultInfo.DivideByZero;
                        tr.val = e.Message;
                        Console.WriteLine("{0,2},{1,2} -- Modulus error: {2}", i, j, e.Message);
                    }

                    // No need to do the reverse, right? e.g. d4 = d3 * d2 + d1 % d2, check if d4 = d1, and if not, reverseDivision
                    // This could be useful for DivMod, but not for this routine.

                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "ModulusResults", results, count, "mod");
        }

        static void GenerateBitwiseAndResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 & d2;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "BitwiseAndResults", results, count, "and");
        }

        static void GenerateBitwiseOrResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 | d2;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "BitwiseOrResults", results, count, "or");
        }

        static void GenerateBitwiseXorResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    // Test operation.
                    BigInteger d2 = BigInteger.Parse(data[j]);
                    BigInteger d3 = 0;
                    BigInteger d4 = 0;
                    tr.info = TestResultInfo.Ok;
                    d3 = d1 ^ d2;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteDyadicResults(tw, "BitwiseXorResults", results, count, "xor");
        }

        static void GenerateNegationResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;

            TestResult[] results = new TestResult[count];
            TestResult tr;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                BigInteger d2 = -d1;
                tr.info = TestResultInfo.Ok;
                tr.val = d2.ToString();
                results[i] = tr;
            }

            WriteMonadicResults(tw, "NegationResults", results, count, "Negate(", ")");
        }

        static void GenerateLogicalNotResults(TextWriter tw)
        {
            string[] data = testData;
            int count = data.Length;

            TestResult[] results = new TestResult[count];
            TestResult tr;

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(data[i]);
                BigInteger d2 = ~d1;
                tr.info = TestResultInfo.Ok;
                tr.val = d2.ToString();
                results[i] = tr;
            }

            WriteMonadicResults(tw, "LogicalNotResults", results, count, "not ", "");
        }

        static void GenerateLeftShiftResults(TextWriter tw)
        {
            int count = testData.Length;
            int shiftCount = bitShifts.Length;

            TestResult[] results = new TestResult[count * shiftCount];
            TestResult tr;

            int n = 0;
            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(testData[i]);
                for (int j = 0; j < shiftCount; ++j, n++)
                {
                    int d2 = bitShifts[j];
                    BigInteger d3 = d1 << d2;
                    tr.info = TestResultInfo.Ok;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteShiftResults(tw, "LeftShiftResults", results, count, shiftCount, "shl");
        }

        static void GenerateRightShiftResults(TextWriter tw)
        {
            int count = testData.Length;
            int shiftCount = bitShifts.Length;

            TestResult[] results = new TestResult[count * shiftCount];
            TestResult tr;

            int n = 0;
            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(testData[i]);
                for (int j = 0; j < shiftCount; ++j, n++)
                {
                    int d2 = bitShifts[j];
                    BigInteger d3 = d1 >> d2;
                    tr.info = TestResultInfo.Ok;
                    tr.val = d3.ToString();
                    results[n] = tr;
                }
            }

            WriteShiftResults(tw, "RightShiftResults", results, count, shiftCount, "shr");
        }

        static void WriteDoubleResults(TextWriter tw, string arrayName, double[] results, int count, string func)
        {
            tw.WriteLine("  {0}: array[0.. TestCount - 1] of Double =", arrayName);
            tw.WriteLine("  (");

            for (int i = 0; i < count; ++i)
            {
                double d = results[i];
                string result = DoubleConverter.ToExactString(d);
                result = (i < count - 1) ? result + "," : result;
                tw.WriteLine("    {0,-76}// {1}(Arguments[{2}])", result, func, i);
            }
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void GenerateLnResults(TextWriter tw)
        {
            int count = testData.Length;
            double[] results = new double[count];

            for (int i = 0; i < count; ++i)
            {
                BigInteger b1 = BigInteger.Parse(testData[i]);
                results[i] = BigInteger.Log(b1);
            }

            WriteDoubleResults(tw, "LnResults", results, count, "Ln");

            BigInteger b = BigInteger.Pow(1000, 1000);
            double d1 = BigInteger.Log(b);
            double d2 = BigInteger.Log10(b);
            double d3 = BigInteger.Log(b, 2.0);
            tw.WriteLine("  Ln_1000_1000    = {0};", DoubleConverter.ToExactString(d1));
            tw.WriteLine("  Log10_1000_1000 = {0};", DoubleConverter.ToExactString(d2));
            tw.WriteLine("  Log2_1000_1000  = {0};", DoubleConverter.ToExactString(d3));
            tw.WriteLine();
        }

        static void GenerateDoubleResults(TextWriter tw)
        {
            int count = testData.Length;
            double[] results = new double[count];

            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = BigInteger.Parse(testData[i]);
                results[i] = (double)d1;
            }

            WriteDoubleResults(tw, "DoubleResults", results, count, "Double");
        }

        static void GeneratePowerResults(TextWriter tw)
        {
            int count = bitShifts.Length;
            TestResult[] results = new TestResult[count * count];

            int n = 0;
            for (int i = 0; i < count; ++i)
            {
                BigInteger d1 = new BigInteger(bitShifts[i]);
                for (int j = 0; j < count; ++j, ++n)
                {
                    int d2 = bitShifts[j];
                    results[n].val = BigInteger.Pow(d1, d2).ToString();
                    results[n].info = TestResultInfo.Ok;
                }
            }

            WriteDyadicResults(tw, "PowerResults", results, count, "^", "ShiftCount", "BitShifts");
        }

        static void GenerateComparisonResults(TextWriter tw)
        {
            int count = testData.Length;
            bool[,] results = new bool[count * count, 6];

            tw.WriteLine("  ComparisonResults: array[0..TestCount * TestCount - 1, TComparisonResult] of Boolean =");
            tw.WriteLine("  (");

            int n = 0;
            for (int i = 0; i < count; i++)
            {
                BigInteger b1 = BigInteger.Parse(testData[i]);

                for (int j = 0; j < count; j++, n++)
                {
                    BigInteger b2 = BigInteger.Parse(testData[j]);

                    tw.WriteLine("    ({0,5}, {1,5}, {2,5}, {3,5}, {4,5}, {5,5}){6}         // Arguments[{7}] <-> Arguments[{8}]", b1 > b2, b1 >= b2, b1 == b2, b1 <= b2, b1 < b2, b1 != b2, (n < count * count - 1) ? "," : " ", i, j); 
                }
            }
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void GenerateGCDResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count * count];

            int n = 0;
            for (int i = 0; i < count; i++)
            {
                BigInteger b1 = BigInteger.Parse(testData[i]);

                for (int j = 0; j < count; j++, n++)
                {
                    BigInteger b2 = BigInteger.Parse(testData[j]);

                    BigInteger b3 = BigInteger.GreatestCommonDivisor(b1, b2);
                    results[n].val = b3.ToString();
                    results[n].info = TestResultInfo.Ok;
                }
            }

            WriteDyadicResults(tw, "GCDResults", results, count, "gcd");
        }

        static void GenerateByteArrayResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = BigInteger.Parse(testData[i]);
                byte[] bArray = b.ToByteArray();
                int bArrayLength = bArray.Length;

                StringBuilder sb = new StringBuilder(bArray.Length);
                for (int j = 0; j < bArrayLength; j++)
                    sb.AppendFormat("{0:X2}", bArray[j]);

                results[i].val = sb.ToString();
                results[i].info = TestResultInfo.Ok;
            }

            WriteMonadicResults(tw, "ByteArrayResults", results, count, "", ".ToByteArray");
        }

        static void GenerateHexResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                // This could be so easy, if not .NET would add a "0" in front of some values and if
                // it displayed negative values as negative, just like in decimal mode.

                BigInteger b = BigInteger.Parse(testData[i]);
                results[i].info = TestResultInfo.Ok;
                string s = BigInteger.Abs(b).ToString("X");
                if (s.Length > 1 && s[0] == '0')
                    s = s.Substring(1); // get rid of leading 0
                if (b < 0)
                    s = "-" + s;        // if negative, show it
                results[i].val = s;
            }

            WriteMonadicResults(tw, "HexResults", results, count, "", ".ToString(16)");
        }

        static void GenerateAsIntegerResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = BigInteger.Parse(testData[i]);
                TestResult tr;

                tr.info = TestResultInfo.Ok;
                try
                {
                    int bi = (int)b;
                    tr.val = String.Format("{0}", bi);
                }
                catch (OverflowException e)
                {
                    Console.WriteLine("Error: {0} ({1})", e.Message, b);
                    tr.info = TestResultInfo.Overflow;
                    tr.val = "";
                }
                results[i] = tr;
            }

            WriteMonadicResults(tw, "AsIntegerResults", results, count, "", ".AsInteger");
        }

        static void GenerateAsCardinalResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = BigInteger.Parse(testData[i]);
                TestResult tr;

                tr.info = TestResultInfo.Ok;
                try
                {
                    UInt32 bi = (UInt32)b;
                    tr.val = bi.ToString();
                }
                catch (OverflowException e)
                {
                    Console.WriteLine("Error: {0} ({1})", e.Message, b);
                    tr.info = TestResultInfo.Overflow;
                    tr.val = "";
                }
                results[i] = tr;
            }

            WriteMonadicResults(tw, "AsCardinalResults", results, count, "", ".AsCardinal");
        }

        static void GenerateAsInt64Results(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = BigInteger.Parse(testData[i]);
                TestResult tr;

                tr.info = TestResultInfo.Ok;
                try
                {
                    Int64 bi = (Int64)b;
                    tr.val = bi.ToString();
                }
                catch (OverflowException e)
                {
                    Console.WriteLine("Error: {0} ({1})", e.Message, b);
                    tr.info = TestResultInfo.Overflow;
                    tr.val = "";
                }
                results[i] = tr;
            }

            WriteMonadicResults(tw, "AsInt64Results", results, count, "", ".AsInt64");
        }

        static void GenerateAsUInt64Results(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = BigInteger.Parse(testData[i]);
                TestResult tr;

                tr.info = TestResultInfo.Ok;
                try
                {
                    UInt64 bi = (UInt64)b;
                    tr.val = bi.ToString();
                }
                catch (OverflowException e)
                {
                    Console.WriteLine("Error: {0} ({1})", e.Message, b);
                    tr.info = TestResultInfo.Overflow;
                    tr.val = "";
                }
                results[i] = tr;
            }

            WriteMonadicResults(tw, "AsUInt64Results", results, count, "", ".AsUInt64");
        }

        static void GenerateMinResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count * count];

            int n = 0;
            for (int i = 0; i < count; i++)
            {
                BigInteger b1 = BigInteger.Parse(testData[i]);
                for (int j = 0; j < count; j++, n++)
                {
                    BigInteger b2 = BigInteger.Parse(testData[j]);
                    BigInteger b3 = BigInteger.Min(b1, b2);

                    results[n].info = TestResultInfo.Ok;
                    results[n].val = b3.ToString();
                }
            }

            WriteDyadicResults(tw, "MinResults", results, count, "min");
        }

        static void GenerateMaxResults(TextWriter tw)
        {
            int count = testData.Length;
            TestResult[] results = new TestResult[count * count];

            int n = 0;
            for (int i = 0; i < count; i++)
            {
                BigInteger b1 = BigInteger.Parse(testData[i]);
                for (int j = 0; j < count; j++, n++)
                {
                    BigInteger b2 = BigInteger.Parse(testData[j]);
                    BigInteger b3 = BigInteger.Max(b1, b2);

                    results[n].info = TestResultInfo.Ok;
                    results[n].val = b3.ToString();
                }
            }

            WriteDyadicResults(tw, "MaxResults", results, count, "min");
        }

        static void GenerateFromDoubleResults(TextWriter tw)
        {
            int count = doubles.Length;
            TestResult[] results = new TestResult[count];

            for (int i = 0; i < count; i++)
            {
                BigInteger b = new BigInteger(doubles[i]);

                results[i].info = TestResultInfo.Ok;
                results[i].val = b.ToString();
            }

            tw.WriteLine();
            tw.WriteLine("  {0}: array[0..DoubleCount - 1] of TTestResult =", "CreateDoubleResults");
            tw.WriteLine("  (");

            for (int i = 0; i < count; ++i)
                FormatResult(tw, results[i], (i == count - 1), String.Format("BigInteger.Create({0})", doubles[i].ToString(CultureInfo.InvariantCulture)));
            tw.WriteLine("  );");
            tw.WriteLine();

        }


        // Experimental, to get debug info:
        static BigInteger MyModPow(BigInteger abase, BigInteger exponent, BigInteger modulus)
        {
            if (modulus.IsOne)
                return BigInteger.Zero;

            BigInteger result = BigInteger.One;
            abase = abase % modulus;
            while (exponent > 0)
            {
                if (!exponent.IsEven)
                    result = (result * abase) % modulus;
                exponent >>= 1;
                abase = (abase * abase) % modulus;
            }
            return result;
        }


        static void GenerateModPowResults(TextWriter tw)
        {
            int count = testData.Length;
            int num = count / 5 + 1;
            int total = num * num * num;
        
            tw.WriteLine("  ModPowResultsCount = {0}; // using MyModPow()", total);
            tw.WriteLine("  ModPowResults: array[0..ModPowResultsCount - 1] of TTestResult =");
            tw.WriteLine("  (");

            int n = 0;
            // Starting at 2, 0, 1 resp. produces a few exceptions, as desired.
            for (int i = 2; i < count; i += 5)
            {
                BigInteger d1 = BigInteger.Abs(BigInteger.Parse(testData[i]));
                for (int j = 0; j < count; j += 5)
                {
                    BigInteger d2 = BigInteger.Abs(BigInteger.Parse(testData[j]));
                    for (int k = 1; k < count; k += 5, ++n)
                    {
                        BigInteger d3 = BigInteger.Abs(BigInteger.Parse(testData[k]));
                        TestResult tr;
                    
                        try
                        {
                            BigInteger d4 = MyModPow(d1, d2, d3);
                            tr.val = d4.ToString();
                            tr.info = TestResultInfo.Ok;
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("({0},{1},{2},{3}): ModPow error: %s", i, j, k, n, e.Message);
                            tr.val = e.Message;
                            tr.info = TestResultInfo.DivideByZero;
                        }
                    
                        FormatResult(tw, tr, n == total - 1, String.Format("({0}): ModPow(Arguments[{1}], Arguments[{2}], Arguments[{3}])", n, i, j, k));
                    }
                }
            }
            tw.WriteLine("  );");
            tw.WriteLine();
        }



        #region Data
        static string[] testData = new string[]
        {
            "-1585715829851573239739325670632039865384960",                             // -0x1234 00000000 00000000 00000000 00000000 
            "-18034965446809738563558854193883715207167",                               // -0x34 FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF  
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

            // Add your own data between this and the following comment

            "343597383679999999999999999995663191310057982263970188796520233154296875",
            "3435973836799999999999999999956631913100579822639701887965202331542968750000000000000",
            "10000000000000",
            "1000000000000000000000000000000000000000000000000000000000"

        };

        static int[] bitShifts = new int[]
        {
              1,   2,   3,   4,   5,   6,   7,   8,
              9,  10,  11,  12,  13,  14,  15,  20, 
             25,  30,  31,  32,  33,  35,  40,  50, 
             60,  70,  71,  72,  73,  74,  75,  90, 
            100, 110, 159, 160, 161, 162, 163, 164,
        };

        static double[] doubles = new double[]
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
        #endregion

    }
}
