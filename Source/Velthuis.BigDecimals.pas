{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.BigDecimals.pas                                      }
{ HFunction:  A multiple precision decimal implementation, based on the     }
{             BigInteger implementation in Velthuis.BigIntegers.pas.        }
{ Language:   Delphi version XE2 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2016,2017 Rudy Velthuis                                   }
{ ------------------------------------------------------------------------- }
{                                                                           }
{ License:    Redistribution and use in source and binary forms, with or    }
{             without modification, are permitted provided that the         }
{             following conditions are met:                                 }
{                                                                           }
{             * Redistributions of source code must retain the above        }
{               copyright notice, this list of conditions and the following }
{               disclaimer.                                                 }
{             * Redistributions in binary form must reproduce the above     }
{               copyright notice, this list of conditions and the following }
{               disclaimer in the documentation and/or other materials      }
{               provided with the distribution.                             }
{                                                                           }
{ Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS"     }
{             AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT     }
{             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND     }
{             FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO        }
{             EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE     }
{             FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,     }
{             OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,      }
{             PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     }
{             DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    }
{             AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT   }
{             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)        }
{             ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF   }
{             ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                    }
{                                                                           }
{---------------------------------------------------------------------------}

{---------------------------------------------------------------------------}
{                                                                           }
{ Notes:      The interface of BigDecimal is mainly the same as the Java    }
{             BigDecimal type. But because Java does not have operator      }
{             overloading, it uses methods for all the arithmetic           }
{             operations, so it is not a big problem to give these extra    }
{             MathContext parameters, e.g for division or conversions.      }
{             Division might result in a non-terminating expansion (e.g.    }
{             1 / 3 does not terminate, so there must be a given limit on   }
{             the number of digits. This generally requires rounding).      }
{                                                                           }
{             To be able to use overloaded operators, I decided to give     }
{             the class DefaultPrecision and DefaultRoundingMode            }
{             properties, to be used in any division or conversion that     }
{             requires these. Additionally, there are methods that take     }
{             Precision or RoundingMode parameters, which do not use the    }
{             defaults.                                                     }
{                                                                           }
{             The names of some of the methods and identifiers were chosen  }
{             to be more in line with BigInteger and with other Delphi      }
{             functions and constants.                                      }
{                                                                           }
{             The ToString and ToPlainString methods do follow the Java     }
{             interface, i.e. ToString produces scientific notation where   }
{             this makes sense while ToPlainString produces plain notation, }
{             even if this means that the string can get very long and      }
{             contains many zeroes. Both ToString and ToPlainString do not  }
{             use local format settings, but use the system invariant       }
{             format settings instead. This allows the output of these      }
{             methods to be used as valid input for Parse and TryParse (so  }
{             called roundtrip conversion).                                 }
{             If you want output based on FormatSettings, use my upcoming   }
{             NumberFormatter instead.                                      }
{                                                                           }
{             Based on the Java examples and on my Decimal types, I use a   }
{             Scale which is positive for fractions, even if a positive     }
{             exponent might make more sense.                               }
{                                                                           }
{             BigDecimals are immutable. This means that if a method        }
{             returns a value that differs from the value of the current    }
{             BigDecimal, a new BigDecimal is returned.                     }
{                                                                           }
{---------------------------------------------------------------------------}

unit Velthuis.BigDecimals;

(* TODO: BigDecimals are ssslllooowww. This piece of code, with CIterations = 5*1000*1000,

    SetLength(arr, CIterations);
    pi := '3.14159';
    for I := 0 to High(arr) do
      arr[I] := BigDecimal(I);
    for I := 0 to High(arr) do
      arr[I] := arr[I] * pi / (pi * BigDecimal(I) + BigDecimal.One);

  is 500 times(!) slower than the Double equivalent. That is extremely slow.
  Note that simplyfying this to do BigDecimal(I) * pi only once will only take away 1% of that.
  It is crucial to find out what makes this code so terribly slow.

  Note: probably BigInteger.DivMod is the slow part.

  Note: It might make sense to use a NativeInt to hold the FValue of small BigDecimals, instead
  of always BigIntegers.
  It might also make sense to make BigInteger.DivMod a lot faster for small values.
*)

interface

uses
  CompilerAndRTLVersions,
  System.SysUtils,
  System.Math,
  Velthuis.BigIntegers;

{$IF CompilerVersion >= CompilerVersionDelphi2010}   // Delphi 2010
  {$DEFINE HasClassConstructors}
{$IFEND}

{$IF CompilerVersion >= CompilerVersionDelphiXE}
  {$CODEALIGN 16}
  {$ALIGN 16}
{$IFEND}

{$IF CompilerVersion >= CompilerVersionDelphiXE3}
  {$LEGACYIFEND ON}
{$IFEND}

{$IF CompilerVersion < CompilerVersionDelphiXE8}
  {$IF (DEFINED(WIN32) or DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}
    {$DEFINE CPU32BITS}
  {$IFEND}
  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}
    {$DEFINE CPU64BITS}
  {$IFEND}
{$IFEND}

{$IF SizeOf(Extended) > SizeOf(Double)}
  {$DEFINE HasExtended}
{$IFEND}

{$DEFINE EXPERIMENTAL}


type
  // Note: where possible, existing exception types are used, e.g. EConvertError, EOverflow, EUnderflow,
  // EZeroDivide from System.SysUtils, etc.

  /// <summary>This exception is raised when on rounding, rmUnnecessary is specified, indicating that we
  /// "know" that rounding is not necessary, and the code determines that, to get the desired result, rounding is
  /// necessary after all.</summary>
  ERoundingNecessary = class(Exception);
  EIntPowerExponent = class(Exception);

  PBigDecimal = ^BigDecimal;

  /// <summary>BigDecimal is a multiple precision floating decimal point binary significand data type. It consists
  /// of a BigInteger and a scale, which is the negative decimal exponent.</summary>
  /// <remarks><para>BigDecimal "remembers" the precision with which it was initialized. So BigDecimal('1.79') and
  /// BigDecimal('1.790000') are distinct values, although they compare as equal.</para>
  /// <para>BigDecimals are immutable. This means that any function or operator that returns a different
  /// value returns a new BigDecimal.</para></remarks>
  BigDecimal = record

  public
    /// <summary>RoundingMode governs which rounding mode is used for certain operations, like division or
    /// conversion.</summary>
    /// <param name="rmUp">Rounds away from zero</param>
    /// <param name="rmDown">Rounds towards zero</param>
    /// <param name="rmCeiling">Rounds towards +infinity</param>
    /// <param name="rmFloor">Rounds towards -infinity</param>
    /// <param name="rmNearestUp">Rounds to nearest higher order digit and, on tie, away from zero</param>
    /// <param name="rmNearestDown">Rounds to nearest higher order digit and, on tie, towards zero</param>
    /// <param name="rmNearestEven">Rounds to nearest higher order digit and, on tie, to nearest even digit</param>
    /// <param name="rmUnnecessary">Assumes an exact result, and raises an exception if rounding is necessary</param>
    type
      RoundingMode =
      (
        rmUp,                   // Round away from zero
        rmDown,                 // Round towards zero
        rmCeiling,              // Round towards +infinity
        rmFloor,                // Round towards -infinity
        rmNearestUp,            // Round .5 away from 0
        rmNearestDown,          // Round .5 towards 0
        rmNearestEven,          // Round .5 towards the nearest even value
        rmUnnecessary           // Do not round, because operation has exact result
      );

    const
      /// <summary>Maximum value a BigDecimal's scale can have</summary>
      MaxScale = MaxInt div SizeOf(Velthuis.BigIntegers.TLimb);

      /// <summary>Minimum value a BigDecimal's scale can have</summary>
      MinScale = -MaxScale - 1;

{$IF defined(CPU32BITS)}
      IntPowerExponentThreshold = 128;
{$ELSE}
      IntPowerExponentThreshold = 256;
{$IFEND}

  private
    type
      // Error codes to be used when calling the private static BigDecimal.Error method.
      TErrorCode = (ecParse, ecDivByZero, ecConversion, ecOverflow, ecUnderflow, ecInvalidArg, ecRounding, ecExponent);

    var
      // The unscaled value of the BigDecimal.
      FValue: BigInteger;

      // The scale which is the power of ten by which the UnscaledValue must be divided to get the BigDecimal value.
      // So 1.79 is coded as FValue = 179 and FScale = 2, whereas 1.7900 is coded as FValue = 17900 and FScale = 4.
      FScale: Int32;

      // The precision is the number of digits in FValue. This is originally 0, and calculated when used the first time.
      // If this value is not 0, then the precision does not need to be calculated and this value can be used.
      FPrecision: Int32;

    class var
      // Default rounding mode. See above.
      FDefaultRoundingMode: RoundingMode;

      // Default precision (number of significant digits) used for e.g. division.
      FDefaultPrecision: Integer;

      // Set this to False if trailing zeroes should not be reduced to the preferred scale after a division.
      FReduceTrailingZeros: Boolean;

      // Default character used to indicate exponent in scientific notation output. Either 'E' or 'e'. Default 'e'.
      FExponentDelimiter: Char;

      // BigDecimal with value -1: unscaled value = -1, scale = 0.
      FMinusOne: BigDecimal;

      // BigDecimal with value 0: unscaled value = 0, scale = 0.
      FZero: BigDecimal;

      // BigDecimal with value 1: unscaled value = 1, scale = 0.
      FOne: BigDecimal;

      // BigDecimal with Value 2: unscaled value = 2, scale = 0.
      FTwo: BigDecimal;

      // BigDecimal with value 10: unscaled value = 10, scale = 0.
      FTen: BigDecimal;

      // BigDecimal with value 0.5: unscaled value = 5, scale = 1.
      FHalf: BigDecimal;

      // BigDecimal with value 0.1: unscaled value = 1, scale = 1.
      FOneTenth: BigDecimal;

{$IFDEF HasClassConstructors}
    class constructor InitClass;
{$ELSE}
    class procedure InitClass; static;
{$ENDIF}

    // Increments Quotient if its current value, the value of the remainder and the given rounding mode and sign require it.
    class procedure AdjustForRoundingMode(var Quotient: BigInteger; const Divisor, Remainder: BigInteger; Sign: Integer; Mode: RoundingMode); static;

    // Divides FValue by a power of ten to remove as many trailing zeros possible without altering its value,
    // i.e. it leaves other digits intact, and adjusts the scale accordingly.
    // Say we have 1.7932400000000 as value, i.e. [FValue=17932400000000, FScale=13], and the target scale
    // is 2, then the result is [179324, 5], which is as close to scale=2 as we can get without altering the value.
    class procedure InPlaceRemoveTrailingZeros(var Value: BigDecimal; TargetScale: Integer); static;

    // Converts the current BigDecimal to sign, significand and exponent for the given significand size in bits.
    // Can be used to convert to components for Single, Double and Extended.
    class procedure ConvertToFloatComponents(const Value: BigDecimal; SignificandSize: Integer;
      var Sign: Integer; var Exponent: Integer; var Significand: UInt64); static;

    // Converts the current sign, significand and exponent, extracted from a Single, Double or Extended,
    // into a BigDecimal.
    class procedure ConvertFromFloatComponents(Sign: TValueSign; Exponent: Integer; Significand: UInt64;
      var Result: BigDecimal); static;

    // Raises exceptions where the type depends on the error code and the message on the arguments.
    class procedure Error(ErrorCode: TErrorCode; ErrorInfo: array of const); static;

    // Gets a BigInteger of the given power of five, either from a prefilled array or using BigInteger.Pow.
    class function GetPowerOfFive(N: Integer): BigInteger; static;

    // Gets a BigInteger of the given power of ten, either from a prefilled array or using BigInteger.Pow.
    class function GetPowerOfTen(N: Integer): BigInteger; static;

    // Initialize or reset scale and precision to 0.
    procedure Init; inline;

    // Checks if the NewScale value is a valid scale value. If so, simply returns NewScale. Otherwise, raises
    // an appropriate exception.
    class function RangeCheckedScale(NewScale: Int32): Integer; static;

    // Only allows 'e' or 'E' as exponent delimiter for scientific notation output.
    class procedure SetExponentDelimiter(const Value: Char); static;


  public
    /// <summary>Creates a BigDecimal with given unscaled value and given scale.</summary>
    constructor Create(const UnscaledValue: BigInteger; Scale: Integer); overload;

  {$IFDEF HasExtended}
    /// <summary>Creates a BigDecimal with the same value as the given Extended parameter.</summary>
    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the parameter contains a NaN or infinity.</exception>
    constructor Create(const E: Extended); overload;
  {$ENDIF}

    /// <summary>Creates a BigDecimal with the same value as the given Double parameter.</summary>
    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the parameter contains a NaN or infinity.</exception>
    constructor Create(const D: Double); overload;

    /// <summary>Creates a BigDecimal with the same value as the given Single parameter.</summary>
    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the parameter contains a NaN or infinity.</exception>
    constructor Create(const S: Single); overload;

    /// <summary>Creates a BigDecimal with the value that results from parsing the given string parameter.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the string cannot be parsed to a valid BigDecimal.</exception>
    constructor Create(const S: string); overload;

    /// <summary>Creates a BigDecimal with the same value as the given BigInteger parameter.</summary>
    constructor Create(const UnscaledValue: BigInteger); overload;

    /// <summary>Creates a BigDecimal with the same value as the given unsigned 64 bit integer parameter.</summary>
    constructor Create(const U64: UInt64); overload;

    /// <summary>Creates a BigDecimal with the same value as the given signed 64 bit integer parameter.</summary>
    constructor Create(const I64: Int64); overload;

    /// <summary>Creates a BigDecimal with the same value as the given unsigned 32 bit integer parameter.</summary>
    constructor Create(U32: UInt32); overload;

    /// <summary>Creates a BigDecimal with the same value as the given signed 32 bit integer parameter.</summary>
    constructor Create(I32: Int32); overload;


    // -- Mathematical operators --

    /// <summary>Adds two BigDecimals. The new scale is Max(Left.Scale, Right.Scale).</summary>
    /// <param name="Left">The augend</param>
    /// <param name="Right">The addend</param>
    /// <returns><code>Result := Left + Right;</code></returns>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    class operator Add(const Left, Right: BigDecimal): BigDecimal;

    /// <summary>Subtracts two BigDecimals. The new scale is Max(Left.Scale, Right.Scale).</summary>
    /// <param name="Left">The minuend</param>
    /// <param name="Right">The subtrahend</param>
    /// <returns><code>Result := Left - Right;</code></returns>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    class operator Subtract(const Left, Right: BigDecimal): BigDecimal;

    /// <summary>Multiplies two BigDecimals. The new scale is Left.Scale + Right.Scale.</summary>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    /// <exception cref="EUnderflow">EUnderflow is raised if the result would become too small.</exception>
    class operator Multiply(const Left, Right: BigDecimal): BigDecimal;

    /// <summary><para>Divides two BigDecimals.</para>
    /// <para>Uses the default precision and rounding mode to obtain the result.</para>
    /// <para>The target scale is <c>Left.Scale - Right.Scale</c>. The result will approach this target scale as
    /// much as possible by removing any excessive trailing zeros.</para></summary>
    /// <param name="Left">The dividend (enumerator)</param>
    /// <param name="Right">The divisor (denominator)</param>
    /// <returns><code>Result := Left / Right;</code></returns>
    /// <exception cref="EZeroDivide">EZeroDivide is raised if the divisor is zero.</exception>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    /// <exception cref="EUnderflow">EUnderflow is raised if the result would become too small.</exception>
    class operator Divide(const Left, Right: BigDecimal): BigDecimal;

    /// <summary>Divides two BigDecimals to obtain an integral result.</summary>
    /// <param name="left">The dividend</param>
    /// <param name="Right">The divisor</param>
    /// <returns><code>Result := Left div Right;</code></returns>
    /// <exception cref="EZeroDivide">EZeroDivide is raised if the divisor is zero.</exception>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    /// <exception cref="EUnderflow">EUnderflow is raised if the result would become too small.</exception>
    class operator IntDivide(const Left, Right: BigDecimal): BigDecimal;

    /// <summary>Returns the remainder after Left is divided by right to an integral value.</summary>
    /// <param name="Left">The dividend</param>
    /// <param name="Right">The divisor</param>
    /// <returns><code>Result := Left - Right * (Left div Right);</code></returns>
    /// <exception cref="EZeroDivide">EZeroDivide is raised if the divisor is zero.</exception>
    /// <exception cref="EOverflow">EOverflow is raised if the result would become too big.</exception>
    /// <exception cref="EUnderflow">EUnderflow is raised if the result would become too small.</exception>
    class operator Modulus(const Left, Right: BigDecimal): BigDecimal;

    /// <summary>Negates the given BigDecimal.</summary>
    /// <returns><code>Result := -Value;</code></returns>
    class operator Negative(const Value: BigDecimal): BigDecimal;

    /// <summary>Called when a BigDecimal is preceded by a unary +. Currently a no-op.</summary>
    /// <returns><code>Result := +Value;</code></returns>
    class operator Positive(const Value: BigDecimal): BigDecimal;

    /// <summary>Rounds the given BigDecimal to an Int64.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the result is too large to fit in an Int64.</exception>
    class operator Round(const Value: BigDecimal): Int64;

    /// <summary>Truncates (ronds down towards 0) the given BigDecimal to an Int64.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the result is too large to fit in an Int64.</exception>
    class operator Trunc(const Value: BigDecimal): Int64;


    // -- Comparison operators --

    /// <summary>Returns True if Left is mathematically less than or equal to Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left &lt;= Right;</code></returns>
    class operator LessThanOrEqual(const Left, Right: BigDecimal): Boolean;

    /// <summary>Returns True if Left is mathematically less than Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left &lt; Right;</code></returns>
    class operator LessThan(const left, Right: BigDecimal): Boolean;

    /// <summary>Returns True if Left is mathematically greater than or equal to Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left &gt;= Right;</code></returns>
    class operator GreaterThanOrEqual(const Left, Right: BigDecimal): Boolean;

    /// <summary>Returns True if Left is mathematically greater than Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left &gt; Right;</code></returns>
    class operator GreaterThan(const Left, Right: BigDecimal): Boolean;

    /// <summary>Returns True if Left is mathematically equal to Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left = Right;</code></returns>
    class operator Equal(const left, Right: BigDecimal): Boolean;

    /// <summary>Returns True if Left is mathematically not equal to Right.</summary>
    /// <param name="Left">The first operand</param>
    /// <param name="Right">The second operand</param>
    /// <returns><code>Result := Left &lt;&gt; Right;</code></returns>
    class operator NotEqual(const Left, Right: BigDecimal): Boolean;


    // -- Implicit conversion operators --

  {$IFDEF HasExtended}
    /// <summary>Returns a BigDecimal with the exact value of the given Extended parameter.</summary>
    class operator Implicit(const E: Extended): BigDecimal;
  {$ENDIF}

    /// <summary>Returns a BigDecimal with the exact value of the given Double parameter.</summary>
    class operator Implicit(const D: Double): BigDecimal;

    /// <summary>Returns a BigDecimal with the exact value of the given Single parameter.</summary>
    class operator Implicit(const S: Single): BigDecimal;

    /// <summary>Returns a BigDecimal with the value parsed from the given string parameter.</summary>
    class operator Implicit(const S: string): BigDecimal;

    /// <summary>Returns a BigDecimal with the value of the given BigInteger parameter.</summary>
    class operator Implicit(const UnscaledValue: BigInteger): BigDecimal;

    /// <summary>Returns a BigDecimal with the value of the given unsigned 64 bit integer parameter.</summary>
    class operator Implicit(const U: UInt64): BigDecimal;

    /// <summary>Returns a BigDecimal with the value of the given signed 64 bit integer parameter.</summary>
    class operator Implicit(const I: Int64): BigDecimal;


    // -- Explicit conversion operators --

  {$IFDEF HasExtended}
    /// <summary>Returns an Extended with the best approximation of the given BigDecimal value.
    /// The conversion uses the default rounding mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    class operator Explicit(const Value: BigDecimal): Extended;
  {$ENDIF}

    /// <summary>Returns a Double with the best approximation of the given BigDecimal value.
    /// The conversion uses the default rounding mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    class operator Explicit(const Value: BigDecimal): Double;

    /// <summary>Returns a Single with the best approximation of the given BigDecimal value.
    /// The conversion uses the default rounding mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    class operator Explicit(const Value: BigDecimal): Single;

    /// <summary>Returns a string representation of the given BigDecimal value.</summary>
    class operator Explicit(const Value: BigDecimal): string;

    /// <summary>Returns a BigInteger with the rounded value of the given BigDecimal value.
    /// The conversion uses the rounding mode rmDown, i.e. it truncates.</summary>
    class operator Explicit(const Value: BigDecimal): BigInteger;

    /// <summary>Returns an unsigned 64 bit integer with the rounded value of the given BigDecimal value.
    /// The conversion uses the default rounding mode rmDown, i.e. it truncates.</summary>
    /// <remarks><para>If the value of the rounded down BigDecimal does not fit in an UInt64, only the low
    /// 64 bits of that value are used to form the result.</para>
    /// <para>This is analogue to</para>
    /// <code>    myByte := Byte(MyUInt64);</code>
    /// <para>Only the low 8 bits of myUInt64 are copied to the byte.</para></remarks>
    class operator Explicit(const Value: BigDecimal): UInt64;

    /// <summary>Returns a signed 64 bit integer with the rounded value of the given BigDecimal value.
    /// The conversion uses the default rounding mode rmDown, i.e. it truncates.</summary>
    /// <remarks><para>If the value of the rounded down BigDecimal does not fit in an Int64, only the low
    /// 64 bits of that value are used to form the result.</para>
    /// <para>This is analogue to</para>
    /// <code>    myByte := Byte(MyUInt64);</code>
    /// <para>Only the low 8 bits of myUInt64 are copied to the byte.</para></remarks>
    class operator Explicit(const Value: BigDecimal): Int64;


    // -- Mathematical functions --

    /// <summary>Returns the sum of the given parameters. The new scale is Max(Left.Scale, Right.Scale).</summary>
    class function Add(const Left, Right: BigDecimal): BigDecimal; overload; static;

    /// <summary>Returns the difference of the given parameters. The new scale is Max(Left.Scale, Right.Scale).</summary>
    class function Subtract(const Left, Right: BigDecimal): BigDecimal; overload; static;

    /// <summary>Returns the product ofthe given parameters. The new scale is Left.Scale + Right.Scale.</summary>
    class function Multiply(const Left, Right: BigDecimal): BigDecimal; overload; static;

    /// <summary><para>Returns the quotient of the given parameters. Left is the dividend, Right the divisor.</para>
    /// <para>Raises an exception if the value of Right is equal to 0.</para>
    /// <para>Uses the default rounding mode and precision.
    /// Raises an exception if the rounding mode is rmUnnecessary, but rounding turns out to be necessary.</para>
    /// <para>The preferred new scale is Left.Scale - Right.Scale. Removes any trailing zero digits to
    /// approach that preferred scale without altering the significant digits.</para></summary>
    class function Divide(const Left, Right: BigDecimal): BigDecimal; overload; static;

    /// <summary><para>Returns the quotient of the given parameters. Left is the dividend, Right the divisor.</para>
    /// <para>Raises an exception if the value of Right is equal to 0.</para>
    /// <para>Uses the given rounding mode and precision.
    /// Raises an exception if the rounding mode is rmUnnecessary, but rounding turns out to be necessary.</para>
    /// <para>The preferred new scale is Left.Scale - Right.Scale. Removes any trailing zero digits to
    /// approach that preferred scale without altering the significant digits.</para></summary>
    class function Divide(const Left, Right: BigDecimal; Precision: Integer; ARoundingMode: RoundingMode): BigDecimal; overload; static;

    /// <summary><para>Returns the quotient of the given parameters. Left is the dividend, Right the divisor.</para>
    /// <para>Raises an exception if the value of Right is equal to 0.</para>
    /// <para>Uses the given rounding mode and the default precision.
    /// Raises an exception if the rounding mode is rmUnnecessary, but rounding turns out to be necessary.</para>
    /// <para>The preferred new scale is Left.Scale - Right.Scale. Removes any trailing zero digits to
    /// approach that preferred scale without altering the significant digits.</para></summary>
    class function Divide(const Left, Right: BigDecimal; Precision: Integer): BigDecimal; overload; static;

    /// <summary><para>Returns the quotient of the given parameters. Left is the dividend, Right the divisor.</para>
    /// <para>Raises an exception if the value of Right is equal to 0.</para>
    /// <para>Uses the default rounding mode and the given precision.
    /// Raises an exception if the rounding mode is rmUnnecessary, but rounding turns out to be necessary.</para>
    /// <para>The preferred new scale is Left.Scale - Right.Scale. Removes any trailing zero digits to
    /// approach that preferred scale without altering the significant digits.</para></summary>
    class function Divide(const Left, Right: BigDecimal; ARoundingMode: RoundingMode): BigDecimal; overload; static;

    /// <summary>Returns the negated value of the given BigDecimal parameter.</summary>
    class function Negate(const Value: BigDecimal): BigDecimal; overload; static;

    /// <summary>Rounds the value of the given BigDecimal parameter to a signed 64 bit integer. Uses the default
    /// rounding mode for the conversion.</summary>
    class function Round(const Value: BigDecimal): Int64; overload; static;

    /// <summary>Rounds the value of the given BigDecimal parameter to a signed 64 bit integer. Uses the default
    /// rounding mode for the conversion.</summary>
    class function Round(const Value: BigDecimal; ARoundingMode: RoundingMode): Int64; overload; static;

    /// <summary><para>Returns the BigDecimal remainder after the division of the two parameters.</para>
    /// <para>Uses the default precision and rounding mode for the division.</para></summary>
    /// <returns><para>The result has the value of</para>
    /// <code>   Left - (Left / Right).Int * Right</code></returns>
    class function Remainder(const Left, Right: BigDecimal): BigDecimal; static;

    /// <summary>Returns the absolute (non-negative) value of the given BigDecimal.</summary>
    class function Abs(const Value: BigDecimal): BigDecimal; overload; static;

    /// <summary>Returns the square of the given BigDecimal.<summary>
    class function Sqr(const Value: BigDecimal): BigDecimal; overload; static;

    /// <summary>Returns the square root of the given BigDecimal, using the given precision.</summary>
    class function Sqrt(const Value: BigDecimal; Precision: Integer): BigDecimal; overload; static;

    /// <summary>Returns the square root of the given BigDecimal, using the default precision.</summary>
    class function Sqrt(const Value: BigDecimal): BigDecimal; overload; static;

    /// <summary>Returns the integer power of the given BigDecimal, in unlimited precision.</summary>
    class function IntPower(const Base: BigDecimal; Exponent: Integer): BigDecimal; overload; static;

    /// <summary>Returns the integer power of the given BigDecimal, in the given precision.</summary>
    class function IntPower(const Base: BigDecimal; Exponent, Precision: Integer): BigDecimal; overload; static;


    // -- Comparison functions --

    /// <summary>Returns 1 if Left is matehamtically greater than Right, 0 if Left is mathematically equal to Right and
    ///  -1 is Left is matheamtically less than Right.</summary>
    class function Compare(const Left, Right: BigDecimal): TValueSign; static;

    /// <summary>Returns the maximum of the two given BigDecimal values.</summary>
    class function Max(const Left, Right: BigDecimal): BigDecimal; static;

    /// <summary>Returns the minimum of the two given BigDecimal values.</summary>
    class function Min(const Left, Right: BigDecimal): BigDecimal; static;


    // -- Parsing --

    /// <summary>Tries to parse the given string as a BigDecimal into Res, using the given format settings.</summary>
    /// <returns>Returns only True of the function was successful.</returns>
    class function TryParse(const S: string; const Settings: TFormatSettings; out Value: BigDecimal): Boolean;
      overload; static;

    /// <summary>Tries to parse the given string as a BigDecimal into Res, using the system invariant format
    /// settings.</summary>
    /// <returns>Returns only True of the function was successful.</returns>
    class function TryParse(const S: string; out Value: BigDecimal): Boolean;
      overload; static;

    /// <summary>Returns the BigDecimal with a value as parsed from the given string, using the given
    /// format settings.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the string cannot be parsed to a valid BigDecimal.</exception>
    class function Parse(const S: string; const Settings: TFormatSettings): BigDecimal; overload; static;

    /// <summary>Returns the BigDecimal with a value as parsed from the given string, using the system
    /// invariant format settings.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the string cannot be parsed to a valid BigDecimal.</exception>
    class function Parse(const S: string): BigDecimal; overload; static;


    // -- Instance methods --

    /// <summary>Returns true if the current BigDecimal's value equals zero.</summary>
    function IsZero: Boolean;

    /// <summary>Returns the sign of the current BigDecimal: -1 if negative, 0 if zero, 1 if positive.</summary>
    function Sign: TValueSign;

    /// <summary>Returns the absolute (i.e. non-negative) value of the current BigDecimal.</summary>
    function Abs: BigDecimal; overload;

    /// <summary>Rounds the current BigDecimal to a value with at most Digits digits, using the given rounding
    /// mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    /// <remarks><para>The System.Math.RoundTo function uses the floating point equivalent of rmNearestEven, while
    /// System.Math.SimpleRoundTo uses the equivalent of rmNearestUp. This function is more versatile.</para>
    /// <para>This is exactly equivalent to</para>
    /// <code>    RoundToScale(-Digits, ARoundingMode);</code></remarks>
    function RoundTo(Digits: Integer; ARoundingMode: RoundingMode): BigDecimal; overload;

    /// <summary>Rounds the current BigDecimal to a value with at most Digits digits, using the default rounding
    /// mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    /// <remarks><para>The System.Math.RoundTo function uses the floating point equivalent of rmNearestEven, while
    /// System.Math.SimpleRoundTo uses the equivalent of rmNearestUp. This function is more versatile.</para>
    /// <para>This is exactly equivalent to</para>
    /// <code>    RoundToScale(-Digits, DefaultRoundingMode);</code></remarks>
    function RoundTo(Digits: Integer): BigDecimal; overload;

    /// <summary>Rounds the current BigDecimal to a value with the given scale, using the given rounding
    /// mode.</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    function RoundToScale(NewScale: Integer; ARoundingMode: RoundingMode): BigDecimal;

    /// <summary>Rounds the current Bigdecimal to a certain precision (number of significant digits).</summary>
    /// <exception cref="ERoundingNecessary">ERoundingNecessary is raised if a rounding mode
    /// rmUnnecessary was specified but rounding is necessary after all.</exception>
    function RoundToPrecision(APrecision: Integer): BigDecimal; overload;

    /// <summary>Returns a new BigDecimal with the decimal point shifted to the left by the given number of positions</summary>
    function MovePointLeft(Digits: Integer): BigDecimal;

    /// <summary>Returns a new BigDecimal with the decimal point shifted to the right by the given number of positions</summary>
    function MovePointRight(Digits: Integer): BigDecimal;

    /// <summary>Returns a value with any fraction (digits after the decimal point) removed from the current
    /// BigDecimal.</summary>
    /// <remarks>Example: BigDecimal('1234.5678') results in BigDecimal('1234').</remarks>.
    function Int: BigDecimal;

    /// <summary>Returns a signed 64 bit integer with any fraction (digits after the decimal point) removed
    /// from the current BigDecimal.</summary>
    /// <exception cref="EConvertError">EConvertError is raised if the result does not fit in an Int64.</exception>
    function Trunc: Int64;

    /// <summary>Returns a BigDecimal containing only the fractional part (digits after the decimal point) of
    /// the current BigDecimal.</summary>
    /// <remarks>Example: BigDecimal('1234.5678') results in BigDecimal('0.5678').</remarks>
    function Frac: BigDecimal;

    /// <summary>Returns a BigDecimal rounded down, towards negative infinity, to the next integral value.</summary>
    /// <remarks>Example: BigDecimal('1234.5678') results in BigDecimal('1234');</remarks>
    function Floor: BigDecimal;

    /// <summary>Returns a BigDecimal rounded up, towards positive infinity, to the next integral value.</summary>
    /// <remarks>Example: BigDecimal('1234.5678') results in BigDecimal('1235');</remarks>
    function Ceil: BigDecimal;

    /// <summary>Returns the number of significant digits of the current BigDecimal.</summary>
    function Precision: Integer;

    /// <summary>Returns the reciprocal of the current BigDecimal, using the given precision</summary>
    /// <exception cref="EZeroDivide">EZeroDivide is raised if the current BigDecimal is zero.</exception>
    function Reciprocal(Precision: Integer): BigDecimal; overload;

    /// <summary>Returns the reciprocal of the current BigDecimal, using the given precision</summary>
    function Reciprocal: BigDecimal; overload;

    /// <summary>Returns a new BigDecimal with all trailing zeroes (up to the preferred scale) removed from the
    /// current BigDecimal. No significant digits will be removed and the numerical value of the result compares
    /// as equal to the original value.</summary>
    /// <param name="TargetScale">The scale up to which trailing zeroes can be removed. It is possible that
    /// fewer zeroes are removed, but never more than necessary to reach the preferred scale.</param>
    /// <remarks><para>Note that no rounding is required. Removal stops at the rightmost non-zero digit.</para>
    /// <para>Example: BigDecimal('1234.5678900000').RemoveTrailingZeros(3) results in
    ///  BigDecimal('1234.56789').</para></remarks>
    function RemoveTrailingZeros(TargetScale: Integer): BigDecimal;

    /// <summary>Returns the square root of the current BigDecimal, with the given precision.</summary>
    function Sqrt(Precision: Integer): BigDecimal; overload;

    /// <summary>Returns the square root of the current BigDecimal, with the default precision.</summary>
    function Sqrt: BigDecimal; overload;

    /// <summary>Returns the integer power of the current BigDecimal, with unlimited precision.</summary>
    function IntPower(Exponent: Integer): BigDecimal; overload;

    /// <summary>Returns the integer power of the current BigDecimal, with the given precision.</summary>
    function IntPower(Exponent, Precision: Integer): BigDecimal; overload;

    /// <summary>Returns the square of the current BigDecimal.</summary>
    function Sqr: BigDecimal; overload;

    /// <summary>Returns the unit of least precision of the current BigDecimal.</summary>
    function ULP: BigDecimal;

    /// <summary>Returns a plain string of the BigDecimal value. This is sometimes called 'decimal notation', and
    /// shows the value without the use of exponents.</summary>
    function ToPlainString: string; overload;

    function ToPlainString(const Settings: TFormatSettings): string; overload;

    /// <summary>Returns a plain string under certain conditions, otherwise returns scientific notation.</summary>
    /// <remarks>This does not use FormatSettings. The output is roundtrip, so it is a valid string that can be
    /// parsed using Parse() or TryParse().</remarks>
    function ToString: string; overload;

    /// <summary>Returns a plain string under certain conditions, otherwise returns scientific notation.</summary>
    /// <remarks>This uses the given FormatSettings for the decimal point Char.</remarks>
    function ToString(const Settings: TFormatSettings): string; overload;


    // -- Class properties --

    /// <summary>The rounding mode to be used if no specific mode is given.</summary>
    class property DefaultRoundingMode: RoundingMode read FDefaultRoundingMode write FDefaultRoundingMode;

    /// <summary>The (maximum) precision to be used for e.g. division if the operation would otherwise result in a
    /// non-terminating decimal expansion, i.e. if there is no exact representable decimal result, e.g. when
    /// dividing <code>BigDecimal(1) / BigDecimal(3) (= 0.3333333...)</code></summary>
    class property DefaultPrecision: Integer read FDefaultPrecision write FDefaultPrecision;

    /// <summary>If set to False, division will not try to reduce the trailing zeros to match the
    /// preferred scale. That is faster, but usually produces bigger decimals</summary>
    class property ReduceTrailingZeros: Boolean read FReduceTrailingZeros write FReduceTrailingZeros;

    /// <summary>The string to be used to delimit the exponent part in scientific notation output.</summary>
    /// <remarks>Currently, only 'e' and 'E' are allowed. Setting any other value will be ignored. The default is 'e',
    /// because a lower case letter 'e' is usually more easily distinguished between digits '0'..'9'.</remarks>
    class property ExponentDelimiter: Char read FExponentDelimiter write SetExponentDelimiter;

    /// <summary>BigDecimal with value -1: unscaled value = -1, scale = 0.</summary>
    class property MinusOne: BigDecimal read FMinusOne;

    /// <summary>BigDecimal with value 0: unscaled value = 0, scale = 0.</summary>
    class property Zero: BigDecimal read FZero;

    /// <summary>BigDecimal with value 1: unscaled value = 1, scale = 0.</summary>
    class property One: BigDecimal read FOne;

    /// <summary>BigDecimal with value 2: unscaled value = 2, scale = 0.</summary>
    class property Two: BigDecimal read FTwo;

    /// <summary>BigDecimal with value 10: unscaled value = 10, scale = 0.</summary>
    class property Ten: BigDecimal read FTen;

    /// <summary>BigDecimal with value 0.5: unscaled value = 5, scale = 1.</summary>
    class property Half: BigDecimal read FHalf;

    /// <summary>BigDecimal with value 0.1: unscaled value = 1, scale = 1.</summary>
    class property OneTenth: BigDecimal read FOneTenth;


    // -- Instance properties --

    /// <summary>The scale of the current BigDecimal. This is the power of ten by which the UnscaledValue must
    /// be divided to get the value of the BigDecimal. Negative scale values denote multiplying by a
    /// power of ten.</summary>
    /// <remarks>So 1.79e+308 can be stored as UnscaledValue = 179 and Scale = -306, requiring only a small BigInteger
    /// with a precision of 3, and not a large one of 308 digits.</remarks>
    property Scale: Integer read FScale;

    /// <summary>The unscaled value of the current BigDecimal. This is the BigInteger than contains the
    /// significant digits of the BigDecimal. It is then scaled (in powers of ten) by Scale.</summary>
    property UnscaledValue: BigInteger read FValue;
  end;

{$HPPEMIT END '#include "Velthuis.BigDecimals.operators.hpp"'}

implementation

{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}

uses
  Velthuis.FloatUtils, Velthuis.Numerics, Velthuis.StrConsts;

var
  PowersOfTen: TArray<BigInteger>;

function InvariantSettings: TFormatSettings;
{$IF RTLVersion >= 29.0}
begin
  // XE8 and higher
  Result := TFormatSettings.Invariant;
end;
{$ELSE}
const
  Settings: TFormatSettings =
  (
    CurrencyString: #$00A4;
    CurrencyFormat: 0;
    CurrencyDecimals: 2;
    DateSeparator: '/';
    TimeSeparator: ':';
    ListSeparator: ',';
    ShortDateFormat: 'MM/dd/yyyy';
    LongDateFormat: 'dddd, dd MMMMM yyyy HH:mm:ss';
    TimeAMString: 'AM';
    TimePMString: 'PM';
    ShortTimeFormat: 'HH:mm';
    LongTimeFormat: 'HH:mm:ss';
    ShortMonthNames: ('Jan', 'Feb', 'Mar', 'Apr', 'May,', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    LongMonthNames: ('January', 'February', 'March', 'April', 'May', 'June',
                     'July', 'August', 'September', 'October', 'November', 'December');
    ShortDayNames: ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
    LongDayNames: ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
    ThousandSeparator: ',';
    DecimalSeparator: '.';
    TwoDigitYearCenturyWindow: 50;
    NegCurrFormat: 0;
  );
begin
  Result := Settings;
end;
{$IFEND}

{ BigDecimal }

function BigDecimal.Abs: BigDecimal;
begin
  if Self.FValue.IsNegative then
    Result := -Self
  else
    Result := Self;
end;

class function BigDecimal.Abs(const Value: BigDecimal): BigDecimal;
begin
  Result := Value.Abs;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//  Adding and subtracting is easy: the operand with the lowest scale is scaled up to the scale of the  //
//  other operand. Then the unscaled values (FValue members) can be added or subtracted respectively.   //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////

class function BigDecimal.Add(const Left, Right: BigDecimal): BigDecimal;
var
  L, R: BigInteger;
begin
  Result.Init;
  if Left.IsZero then
    if Right.IsZero then
      Exit(BigDecimal.Zero)
    else
      Exit(Right)
  else if Right.IsZero then
    Exit(Left);
  if Left.Scale > Right.Scale then
  begin
    L := Left.FValue;
    R := Right.FValue * GetPowerOfTen(Left.Scale - Right.Scale);
    Result.FScale := Left.FScale;
  end
  else
  begin
    L := Left.FValue * GetPowerOfTen(Right.Scale - Left.Scale);
    R := Right.FValue;
    Result.FScale := Right.FScale;
  end;
  Result.FValue := L + R;
end;

class operator BigDecimal.Add(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Add(Left, Right);
end;

////////////////////////////////////////////////////
//                                                //
//  See comment on rounding near RoundToScale().  //
//                                                //
////////////////////////////////////////////////////

class procedure BigDecimal.AdjustForRoundingMode(var Quotient: BigInteger; const Divisor, Remainder: BigInteger; Sign: Integer; Mode: RoundingMode);
begin
  if not Remainder.IsZero then
    case Mode of
      rmUp:                                             // 1.7x --> 1.8, -1.7x --> -1.8
        Inc(Quotient);
      rmDown:                                           // 1.7x --> 1.7, -1.7x --> -1.7
        ;                                               // No action required; truncation is default.
      rmCeiling:                                        // 1.7x --> 1.8, -1.7x --> -1.7
        if Sign >= 0 then
          Inc(Quotient);
      rmFloor:                                          // 1.7x --> 1.7, -1.7x --> -1.8
        if Sign <= 0 then
          Inc(Quotient);
      rmNearestUp, rmNearestDown, rmNearestEven:
        if Remainder + Remainder > Divisor then         // 1.78 --> 1.8, 1.72 --> 1.7, 1.75 --> see next
          Inc(Quotient)
        else if Remainder + Remainder = Divisor then    // the "Half" condition.
          if (Mode = rmNearestUp) or ((Mode = rmNearestEven) and not Quotient.IsEven) then
            Inc(Quotient);
      rmUnnecessary:                                    // No remainder allowed.
        Error(ecRounding, []);
    end;
end;

// Does a "binary search" to remove trailing zeros. This is much faster (10 times or more) than repeatedly
// dividing by BigInteger.Ten until there is a remainder, even for relatively small numbers of trailing zeros.
// Since this modifies Value, it cannot be made public, but there is a public version of this, called
// RemoveTrailingZeros.
class procedure BigDecimal.InPlaceRemoveTrailingZeros(var Value: BigDecimal; TargetScale: Integer);
var
  L, H, M, LSign: Integer;
  LValue, LDivisor, LQuotient, LRemainder: BigInteger;
  LScale: Integer;
begin
  LSign := Value.FValue.Sign;
  LValue := BigInteger.Abs(Value.FValue);
  LScale := Value.FScale;
  LQuotient := Value.FValue;
  L := TargetScale;
  H := LScale;
  while H > L do
  begin
    // Take the middle value and do a DivMod
    M := (L + H) div 2;
    if M = LScale then
      Break;
    LDivisor := GetPowerOfTen(LScale - M);
    if not LValue.IsEven then
      // Odd numbers can't be divisible by ten, so cut short.
      L := M + 1
    else
    begin
      BigInteger.DivMod(LValue, LDivisor, LQuotient, LRemainder);
      if LRemainder.IsZero then
      begin
        // Remainder was 0, so use the quotient (which has trailing zeroes removed) as new base and try to remove
        // more zeroes on the left.
        H := M;
        LValue := LQuotient;
        // Update the scale accordingly.
        LScale := M;
      end
      else
        // Remainder was not 0, so search further to the right.
        L := M + 1;
    end;
  end;

  // Value and scale may still be off by one.
  if (LScale > TargetScale) and (LValue >= BigInteger.Ten) then
  begin
    BigInteger.DivMod(LValue, BigInteger.Ten, LQuotient, LRemainder);
    if LRemainder.IsZero then
    begin
      LValue := LQuotient;
      Dec(LScale);
    end
  end;

  LValue.Sign := LSign;
  Value.Create(LValue, LScale);
end;

class function BigDecimal.Compare(const Left, Right: BigDecimal): TValueSign;
const
  Values: array[Boolean] of Integer = (-1, 1);
var
  L, R: BigInteger;
begin
  if Left.FValue.IsZero then
    if Right.FValue.IsZero then
      Exit(0)
    else
      Exit(Values[Right.FValue.IsNegative])
  else if Right.FValue.IsZero then
    Exit(Values[Left.FValue.IsPositive]);
  if Left.FScale > Right.FScale then
  begin
    L := Left.FValue;
    R := Right.FValue * GetPowerOfTen(RangeCheckedScale(Left.FScale - Right.FScale));
  end
  else
  begin
    L := Left.FValue * GetPowerOfTen(RangeCheckedScale(Right.FScale - Left.FScale));
    R := Right.FValue;
  end;
  Result := BigInteger.Compare(L, R);
end;

// Converts Value to components for binary FP format, with Significand, binary Exponent and Sign. Significand
// (a.k.a. mantissa) is SignificandSize bits. This can be used for conversion to Extended, Double and Single, and,
// if desired, IEEE 754-2008 binary128 (note: binary32 is equivalent to Single and binary64 to Double).
class procedure BigDecimal.ConvertToFloatComponents(const Value: BigDecimal; SignificandSize: Integer;
  var Sign, Exponent: Integer; var Significand: UInt64);
var
  LDivisor, LQuotient, LRemainder, LLowBit, LSignificand: BigInteger;
  LBitLen, LScale: Integer;
begin
  if Value.FValue.IsNegative then
    Sign := -1
  else
    Sign := 1;

  LScale := Value.Scale;
  Exponent := 0;

  if LScale < 0 then
  begin
    // Get rid of scale while retaining the value:
    // Reduce scale to 0 and at the same time multiply UnscaledValue with 10^-Scale
    // Multiplying by 10^-Scale is equivalent to multiplying with 5^-Scale while decrementing exponent by scale.
    Exponent := -LScale;
    LSignificand := BigInteger.Abs(Value.FValue) * GetPowerOfFive(Exponent);
  end
  else if LScale > 0 then
  begin
    // Get rid of scale, but the other way around: shift left as much as necessary (i.e. multiply by 2^-Scale)
    // and then divide by 5^Scale.
    Exponent := -LScale;
    LDivisor := GetPowerOfFive(LScale);
    LBitLen := LDivisor.BitLength;
    LSignificand := BigInteger.Abs(Value.FValue) shl (LBitLen + SignificandSize - 1);
    Dec(Exponent, LBitLen + SignificandSize - 1);
    BigInteger.DivMod(LSignificand, LDivisor, LQuotient, LRemainder);
    BigDecimal.AdjustForRoundingMode(LQuotient, LDivisor, LRemainder, Sign, rmNearestEven);
    LSignificand := LQuotient;
  end
  else
    LSignificand := BigInteger.Abs(Value.FValue);

  LBitLen := LSignificand.BitLength;
  if LBitLen > SignificandSize then
  begin
    LLowBit := BigInteger.One shl (LBitLen - SignificandSize);
    LRemainder := (LSignificand and (LLowBit - BigInteger.One)) shl 1;
    LSignificand := LSignificand shr (LBitLen - SignificandSize);
    Inc(Exponent, LBitLen - 1);
    if (LRemainder > LLowBit) or ((LRemainder = LLowBit) and not LSignificand.IsEven) then
    begin
      Inc(LSignificand);
      if LSignificand.BitLength > SignificandSize then
      begin
        LSignificand := LSignificand shr 1;
        Inc(Exponent);
      end;
    end
  end
  else
  begin
    LSignificand := LSignificand shl (SignificandSize - LBitLen);
    Inc(Exponent, LBitLen - 1);
  end;

  Significand := LSignificand.AsUInt64;
end;

constructor BigDecimal.Create(const UnscaledValue: BigInteger; Scale: Integer);
begin
  Init;
  FValue := UnscaledValue;
  FScale := Scale;
end;

class procedure BigDecimal.ConvertFromFloatComponents(Sign: TValueSign; Exponent: Integer; Significand: UInt64; var Result: BigDecimal);
type
  TUInt64 = packed record
    Lo, Hi: UInt32;
  end;
var
  NewUnscaledValue: BigInteger;
  NewScale: Integer;
  Shift: Integer;
begin
  Shift := NumberOfTrailingZeros(Significand);

  Significand := Significand shr Shift;
  Inc(Exponent, Shift);

  NewUnscaledValue := Significand;

  NewScale := 0;
  if Exponent < 0 then
  begin
    // To get rid of the binary exponent (make it 0), BigInt must repeatedly be divided by 2.
    // This isn't done directly: on each "iteration", BigInt is multipiled by 5 and then the
    // decimal point is moved by one, which is equivalent with a division by 10.
    // So, effectively, the result is divided by 2.
    // Instead of in a loop, this is done directly using Pow()
    NewUnscaledValue := NewUnscaledValue * BigInteger.Pow(5, -Exponent);
    NewScale := -Exponent;
  end
  else if Exponent > 0 then
    NewUnscaledValue := NewUnscaledValue shl Exponent;

  Result := BigDecimal.Create(NewUnscaledValue, NewScale);
  if Sign < 0 then
    Result := -Result;
end;

constructor BigDecimal.Create(const S: Single);
var
  Significand: UInt64;
  Exponent: Integer;
  Sign: TValueSign;
begin
  if IsInfinite(S) or IsNan(S) then
    Error(ecInvalidArg, ['Single']);

  if S = 0.0 then
  begin
    Self := BigDecimal.Zero;
    Exit;
  end;

  Significand := GetSignificand(S);
  Exponent := GetExponent(S) - 23;
  Sign := System.Math.Sign(S);

  ConvertFromFloatComponents(Sign, Exponent, Significand, Self);
end;

constructor BigDecimal.Create(const D: Double);
var
  Significand: UInt64;
  Exponent: Integer;
  Sign: TValueSign;
begin
  if IsInfinite(D) or IsNan(D) then
    Error(ecInvalidArg, ['Double']);

  if D = 0.0 then
  begin
    Self := BigDecimal.Zero;
    Exit;
  end;

  Significand := GetSignificand(D);
  Exponent := GetExponent(D) - 52;
  Sign := System.Math.Sign(D);

  ConvertFromFloatComponents(Sign, Exponent, Significand, Self);
end;

{$IFDEF HasExtended}
constructor BigDecimal.Create(const E: Extended);
var
  Significand: UInt64;
  Exponent: Integer;
  Sign: TValueSign;
begin
  if IsInfinite(E) or IsNan(E) then
    Error(ecInvalidArg, ['Extended']);

  if E = 0.0 then
  begin
    Self := BigDecimal.Zero;
    Exit;
  end;

  Significand := GetSignificand(E);
  Exponent := GetExponent(E) - 63;
  Sign := System.Math.Sign(E);

  ConvertFromFloatComponents(Sign,Exponent, Significand, Self);
end;
{$ENDIF}

constructor BigDecimal.Create(const S: string);
begin
  Init;
  if not TryParse(S, InvariantSettings, Self) then
    Error(ecParse, [S, 'BigDecimal']);
end;

constructor BigDecimal.Create(const I64: Int64);
begin
  Init;
  FValue := BigInteger.Create(I64);
end;

constructor BigDecimal.Create(const U64: UInt64);
begin
  Init;
  FValue := BigInteger.Create(U64);
end;

constructor BigDecimal.Create(U32: UInt32);
begin
  Init;
  FValue := BigInteger.Create(U32);
end;

constructor BigDecimal.Create(I32: Int32);
begin
  Init;
  FValue := BigInteger.Create(I32);
end;

constructor BigDecimal.Create(const UnscaledValue: BigInteger);
begin
  Init;
  FValue := UnscaledValue;
end;

class function BigDecimal.Divide(const Left, Right: BigDecimal; Precision: Integer;
  ARoundingMode: RoundingMode): BigDecimal;
var
  LQuotient, LRemainder, LDivisor: BigInteger;
  LScale, TargetScale: Integer;
  LSign: Integer;
  LMultiplier: Integer;
begin

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Naively dividing the BigInteger values would result in 0 when e.g. '0.01' and '0.0025' are divided    //
  // (1 div 25 = 0).                                                                                       //
  // So the dividend must be scaled up by at least Precision powers of ten. The end result must be rounded //
  // toward the target scale, which is Left.Scale - Right.Scale.                                           //
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Is there a way to find out beforehand if we need the full precision? Take the above: 0.01/0.0025 = 4. //
  // So we would only need to scale up BigInteger(1) to BigInteger(100) and then divide. Is there a way to //
  // determine this? OTOH, for 0.01/0.003 we need the full precision. Is there a way to determine if a     //
  // division will result in a non-terminating decimal expansion or if it is terminating, where it will    //
  // terminate?                                                                                            //
  // The decimal expansion will be terminating if the divisor can be reduced to 2^n * 5^m, with n,m >= 0,  //
  // in other words, if it can be reduced to only powers of 2 and 5.                                       //
  // Not sure if there is a fast way to determine this. I guess not.                                       //
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  if Right.FValue.IsZero then
    Error(ecDivByZero, []);
  TargetScale := Left.Scale - Right.Scale;
  if Left.FValue.IsZero then
  begin
    Result.FValue := BigInteger.Zero;
    Result.FScale := TargetScale;
    Exit;
  end;

  // Determine target sign.
  LSign := Left.FValue.Sign xor Right.FValue.Sign;

  // Use positive values (zero was discarded above).
//  LDivisor := BigInteger.Abs(Right.FValue);
  LDivisor := Right.FValue;

  // Determine minimum power of ten with which to multiply the dividend.
  // Previous code used:
  //  LMultiplier := RangeCheckedScale(Precision + Right.Precision - Left.Precision + 3);
  // but the code below is 20% faster - Calculating precision can be slow.
  LMultiplier := RangeCheckedScale(Precision + (Right.FValue.Size - Left.FValue.Size + 1) * 9 + 3);

  // Do the division of the scaled up dividend by the divisor. Quotient and remainder are needed.
  BigInteger.DivMod(Left.FValue * GetPowerOfTen(LMultiplier), LDivisor, LQuotient, LRemainder);

  // Calculate the scale that matches the division.
  LScale := RangeCheckedScale(TargetScale + LMultiplier);

  // Create a preliminary result.
  Result.Create(LQuotient, LScale);

  // Reduce the precision, if necessary.
  // Wow! This is slow. Time reduction of >50% if it could be omitted, e.g. if division were
  // accurate enough already.
  Result := Result.RoundToScale(RangeCheckedScale(LScale + Precision - Result.Precision), ARoundingMode);
  // Can this be combined with InPlaceRemoveTrailingZeros?

  // remove as many trailing zeroes as possible to get as close as possible to the target scale without
  // changing the value.
  // This should be optional, as it is slower.
  if FReduceTrailingZeros then
    InPlaceRemoveTrailingZeros(Result, TargetScale);

  // Finally, set the sign of the result.
  Result.FValue.Sign := LSign;
end;

class function BigDecimal.Divide(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Divide(Left, Right, DefaultPrecision, DefaultRoundingMode);
end;

class function BigDecimal.Divide(const Left, Right: BigDecimal; Precision: Integer): BigDecimal;
begin
  Result := Divide(Left, Right, Precision, DefaultRoundingMode);
end;

class function BigDecimal.Divide(const Left, Right: BigDecimal; ARoundingMode: RoundingMode): BigDecimal;
begin
  Result := Divide(Left, Right, DefaultPrecision, ARoundingMode);
end;

class operator BigDecimal.Divide(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Divide(Left, Right, DefaultPrecision, DefaultRoundingMode);
end;

class operator BigDecimal.Equal(const Left, Right: BigDecimal): Boolean;
begin
  Result := Compare(Left, Right) = 0;
end;

class procedure BigDecimal.Error(ErrorCode: TErrorCode; ErrorInfo: array of const);
begin
  // Raise an exception that matches the given error code. The message is determined by the
  // format strings and the Args parameter.
  // Note that, as much as possible, existing exceptions from the Delphi runtime library are used.
  case ErrorCode of
    ecParse:
       // Not a valid BigDecimal string representation.
      raise EConvertError.CreateFmt(SErrorParsingFmt, ErrorInfo);
    ecDivByZero:
      // Division by zero.
      raise EZeroDivide.Create(SDivisionByZero);
    ecConversion:
      // BigDecimal too large for conversion to...
      raise EConvertError.CreateFmt(SConversionFailedFmt, ErrorInfo);
    ecOverflow:
      // Scale would become too low.
      raise EOverflow.Create(SOverflow);
    ecUnderflow:
      // Scale would become too high.
      raise EUnderflow.Create(SUnderflow);
    ecInvalidArg:
      // Parameter is NaN or +/-Infinity.
      raise EInvalidArgument.CreateFmt(SInvalidArgumentFloatFmt, ErrorInfo);
    ecRounding:
      // Rounding was necessary but rmUnnecessary was specified.
      raise ERoundingNecessary.Create(SRounding);
    ecExponent:
      // Exponent outside the allowed range
      raise EIntPowerExponent.Create(SExponent);
    else
      // Invalid operand to operator.
      raise EInvalidOpException.Create(SInvalidOperation);
  end;
end;

class operator BigDecimal.Explicit(const Value: BigDecimal): Single;
var
  LSign, LExponent: Integer;
  LSignificand: UInt64;
  LDiff: Integer;
  LLowBits: UInt32;
  LRem: UInt32;
begin
  if Value.FValue.IsZero then
    Exit(0.0);

  // Convert the given BigDecimal (i.e. UnscaledValue and decimal Scale) to a signficand, sign and binary exponent using
  // the given size of the significand (24 bits for Single).
  ConvertToFloatComponents(Value, 24, LSign, LExponent, LSignificand);

  // Compose calculated sign, significand and exponent into a proper Single.

  // Handle special values:

  // * Values too large (infinities).
  if LExponent > 127 then
    if LSign < 0 then
      Result := NegInfinity
    else
      Result := Infinity
  // * Denormals or below (0).
  else if LExponent < -126 then
  begin
    LDiff := -126 - LExponent;
    if LDiff >= 24 then
      Exit(0.0);
    LLowBits := UInt32(1) shl LDiff;
    LRem := LSignificand and (LLowBits - 1);
    LSignificand := LSignificand shr LDiff;
    if LRem + LRem >= LLowBits then
      Inc(LSignificand);
    if LSign < 0 then
      LSignificand := LSignificand or $80000000;
    Result := PSingle(@LSignificand)^;
  end
  else
    Result := Velthuis.FloatUtils.MakeSingle(LSign, LSignificand, LExponent);
end;

class operator BigDecimal.Explicit(const Value: BigDecimal): Double;
var
  LSign: Integer;
  LExponent: Integer;
  LSignificand: UInt64;
  LDiff: Integer;
  LLowBits: UInt64;
  LRem: UInt64;
begin
  if Value.FValue.IsZero then
    Exit(0.0);

  // Convert the given BigDecimal (i.e. UnscaledValue and decimal Scale) to a significand, sign and binary exponent using
  // the given size of the significand (53 bits for Double).
  ConvertToFloatComponents(Value, 53, LSign, LExponent, LSignificand);

  // Compose calculated sign, significand and exponent into a proper Double.

  // Handle special values:

  // * Values too large (infinities).
  if LExponent > 1023 then
    if LSign < 0 then
      Result := NegInfinity
    else
      Result := Infinity
  // * Denormals or below (0).
  else if LExponent < -1022 then
  begin
    LDiff := -1022 - LExponent;
    if LDiff >= 53 then
      Exit(0.0);

    LLowBits := UInt64(1) shl LDiff;            // mask for the low bits after shift
    LRem := LSignificand and (LLowBits - 1);    // low bits, IOW LSignificand mod 2^LDiff
    LSignificand := LSignificand shr LDiff;     // LSignificand div 2^LDiff
    if (LRem + LRem > LLowBits) or ((LRem + LRem = LLowBits) and (Odd(LSignificand))) then
      Inc(LSignificand);                        // round up
    if LSign < 0 then
      LSignificand := LSignificand or $8000000000000000;
    Result := PDouble(@LSignificand)^;
  end
  else
    Result := Velthuis.FloatUtils.MakeDouble(LSign, LSignificand, LExponent);
end;

{$IFDEF HasExtended}
class operator BigDecimal.Explicit(const Value: BigDecimal): Extended;
var
  LSign, LExponent: Integer;
  LSignificand: UInt64;
  LDiff: Integer;
  LLowBits: UInt64;
  LExtendedRec: packed record
    Man: UInt64;
    Exp: Int16;
  end;
  LRem: UInt64;
begin
  ConvertToFloatComponents(Value, 64, LSign, LExponent, LSignificand);

  // Handle special values
  // * Infinities
  if LExponent > 16383 then
    if LSign < 0 then
      Result := NegInfinity
    else
      Result := Infinity
  else
  // * Denormals
  if LExponent < -16382 then
  begin
    LDiff := -16382 - LExponent;
    if LDiff >= 64 then
      Exit(0.0);
    LLowBits := UInt64(1) shl LDiff;
    LRem := LSignificand and (LLowBits - 1);
    LSignificand := LSignificand shr LDiff;
    if LRem + LRem >= LLowBits then
      Inc(LSignificand);
    LExtendedRec.Man := LSignificand;
    LExtendedRec.Exp := 0;
    if LSign < 0 then
      LExtendedRec.Exp := LExtendedRec.Exp or Int16($8000);
    Result := PExtended(@LExtendedRec)^;
  end
  else
    Result := Velthuis.FloatUtils.MakeExtended(LSign, LSignificand, LExponent);
end;
{$ENDIF}

class operator BigDecimal.Explicit(const Value: BigDecimal): string;
begin
  // General format: uses scientific notation when necessary.
  Result := Value.ToString;
end;

class operator BigDecimal.Explicit(const Value: BigDecimal): UInt64;
var
  Rounded: BigDecimal;
begin
  Rounded := Value.RoundToScale(0, rmDown);
  Result := UInt64(Rounded.FValue and High(UInt64));
end;

class operator BigDecimal.Explicit(const Value: BigDecimal): Int64;
var
  Rounded: BigDecimal;
begin
  Rounded := Value.RoundToScale(0, rmDown);
  Result := Int64(Rounded.FValue);
end;

function BigDecimal.Frac: BigDecimal;
begin
  Result := BigDecimal.Abs(Self - Self.Int());
end;

function BigDecimal.Floor: BigDecimal;
begin
  if Scale > 0 then
    Result := Self.RoundToScale(0, rmFloor)
  else
    Result := Self;
end;

function BigDecimal.Ceil: BigDecimal;
begin
  if Scale > 0 then
    Result := Self.RoundToScale(0, rmCeiling)
  else
    Result := Self;
end;

class operator BigDecimal.Explicit(const Value: BigDecimal): BigInteger;
var
  Rounded: BigDecimal;
begin
  Rounded := Value.RoundToScale(0, rmDown);
  Result := Rounded.FValue;
end;

// Note: 5^N = 10^N div 2^N = 10^N shr N;
// Powers of five are required when converting a decimal scale/unscaled value combination to a binary
// exponent/significand combination with the same value.
class function BigDecimal.GetPowerOfFive(N: Integer): BigInteger;
begin
  Result := GetPowerOfTen(N) shr N;
end;

// Since a scale denotes powers of ten, powers of ten are required as either multiplicator or divisor.
class function BigDecimal.GetPowerOfTen(N: Integer): BigInteger;
begin
  if N >= 0 then
  begin
    // If index outside array, enlarge the array.
    if N > High(PowersOfTen) then
      SetLength(PowersOfTen, N + 1);
    Result := PowersOfTen[N];

    // If the value read is 0, it is obviously invalid, so calculate power and store it at this index.
    if Result.IsZero then
    begin
      Result := BigInteger.Pow(BigInteger.Ten, N);
      PowersOfTen[N] := Result;
    end;
  end;
end;

class operator BigDecimal.GreaterThan(const Left, Right: BigDecimal): Boolean;
begin
  Result := Compare(Left, Right) > 0;
end;

class operator BigDecimal.GreaterThanOrEqual(const Left, Right: BigDecimal): Boolean;
begin
  Result := Compare(Left, Right) >= 0;
end;

class operator BigDecimal.Implicit(const S: Single): BigDecimal;
begin
  Result.Create(S);
end;

class operator BigDecimal.Implicit(const D: Double): BigDecimal;
begin
  Result.Create(D);
end;

{$IFDEF HasExtended}
class operator BigDecimal.Implicit(const E: Extended): BigDecimal;
begin
  Result.Create(E);
end;
{$ENDIF}

class operator BigDecimal.Implicit(const S: string): BigDecimal;
begin
  Result.Create(S);
end;

class operator BigDecimal.Implicit(const U: UInt64): BigDecimal;
begin
  Result.Create(U);
end;

class operator BigDecimal.Implicit(const I: Int64): BigDecimal;
begin
  Result.Create(I);
end;

class operator BigDecimal.Implicit(const UnscaledValue: BigInteger): BigDecimal;
begin
  Result.Create(UnscaledValue);
end;

procedure BigDecimal.Init;
begin
  FScale := 0;
  FPrecision := 0;
end;

{$IFDEF HasClassConstructors}
class constructor BigDecimal.InitClass;
{$ELSE}
class procedure BigDecimal.InitClass;
{$ENDIF}
var
  I: Integer;
  B: BigInteger;
begin
  SetLength(PowersOfTen, 64);
  B := BigInteger.One;
  for I := Low(PowersOfTen) to High(PowersOfTen) do
  begin
    PowersOfTen[I] := B;
    B := B * BigInteger.Ten;
  end;

  // My default. More or less arbitrary.
  BigDecimal.FDefaultPrecision := 64;

  // The most used rounding mode in Delphi, AFAIK.
  BigDecimal.FDefaultRoundingMode := rmNearestEven;

  // Reduce trialing zeros to target scale after division by default.
  BigDecimal.FReduceTrailingZeros := True;

  // I prefer the lower case 'e', because it is more visible between a number of decimal digits.
  // IOW, the 'e' in 1.23456789e+345 has, IMO, a little higher visibility than in the 'E' in 1.23456789E+345
  BigDecimal.FExponentDelimiter := 'e';

  // The usual constants.
  BigDecimal.FMinusOne := BigDecimal.Create(BigInteger.MinusOne, 0);
  BigDecimal.FZero := BigDecimal.Create(BigInteger.Zero, 0);
  BigDecimal.FOne := BigDecimal.Create(BigInteger.One, 0);
  BigDecimal.FTwo := BigDecimal.Create(BigInteger(2), 0);
  BigDecimal.FTen := BigDecimal.Create(BigInteger.Ten, 0);
  BigDecimal.FHalf := BigDecimal.Create(BigInteger(5), 1);
  BigDecimal.FOneTenth := BigDecimal.Create(BigInteger(1), 1);

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Note: one might expect constants like pi or e, but since BigDecimal relies on a certain   //
  // precision, there can be no constants for such values. The coming BigDecimalMath unit will //
  // however contain functions to determine them to a given precision.                         //
  ///////////////////////////////////////////////////////////////////////////////////////////////

end;

function BigDecimal.Int: BigDecimal;
begin
  Result := RoundToScale(0, rmDown);
end;

class operator BigDecimal.IntDivide(const Left, Right: BigDecimal): BigDecimal;
var
  LTargetScale: Integer;
  LRequiredPrecision: Integer;
begin
  LTargetScale := Left.FScale - Right.FScale;
  if Left.Abs < Right.Abs then
  begin
    Result.FValue := BigInteger.Zero;
    Result.FScale := LTargetScale;
    Exit;
  end;

  if Left.FValue.IsZero and not Right.FValue.IsZero then
    Exit(Left.RoundToScale(LTargetScale, rmUnnecessary));

  LRequiredPrecision := RangeCheckedScale(Left.Precision + 3 * Right.Precision + System.Abs(LTargetScale) + 3);
  Result := Divide(Left, Right, LRequiredPrecision, rmDown);

  if Result.FScale > 0 then
  begin
    Result := Result.RoundToScale(0, rmDown);
    InPlaceRemoveTrailingZeros(Result, LTargetScale);
  end;

  if Result.Scale < LTargetScale then
    Result := Result.RoundToScale(LTargetScale, rmUnnecessary);
end;

class function BigDecimal.IntPower(const Base: BigDecimal; Exponent, Precision: Integer): BigDecimal;
var
  LBase: BigDecimal;
  LNegativeExp: Boolean;
begin
  if Exponent = 0 then
    Exit(BigDecimal.One);

  LNegativeExp := Exponent < 0;
  if LNegativeExp then
    Exponent := -Exponent;

  if Exponent > 9999999 then
    Error(ecExponent, []);

  if (Base.Precision > 8) and (Exponent >= IntPowerExponentThreshold) then
  begin
    Result := One;
    LBase := Base;
    while Exponent <> 0 do
    begin
      if Odd(Exponent) then
        Result := (Result * LBase).RoundToPrecision(Precision + 3);
      LBase := (LBase * LBase).RoundToPrecision(Precision + 3);
      Exponent := Exponent shr 1;
    end;
  end
  else
    Result := IntPower(Base, Exponent);

  if LNegativeExp then
    Result := Result.Reciprocal(Precision)
  else
    Result := Result.RoundToPrecision(Precision);

  if Result.Scale < Precision then
    Result := Result.RemoveTrailingZeros(0);
end;

class function BigDecimal.IntPower(const Base: BigDecimal; Exponent: Integer): BigDecimal;
var
  LBase: BigDecimal;
  LNegativeExp: Boolean;
begin

  if Exponent = 0 then
    Exit(BigDecimal.One);

  LNegativeExp := Exponent < 0;
  if LNegativeExp then
    Exponent := -Exponent;

  if Exponent > 9999999 then
    Error(ecExponent, []);

  Result := One;
  LBase := Base;
  while Exponent <> 0 do
  begin
    if Odd(Exponent) then
      Result := Result * LBase;
    LBase := LBase * LBase;
    Exponent := Exponent shr 1;
  end;

  if LNegativeExp then
    Result := BigDecimal.Divide(BigDecimal.One, Result, DefaultPrecision);
end;

function BigDecimal.IntPower(Exponent, Precision: Integer): BigDecimal;
begin
  Result := IntPower(Self, Exponent, Precision);
end;

function BigDecimal.IntPower(Exponent: Integer): BigDecimal;
begin
  Result := IntPower(Self, Exponent);
end;

function BigDecimal.IsZero: Boolean;
begin
  Result := FValue.IsZero;
end;

class operator BigDecimal.LessThan(const left, Right: BigDecimal): Boolean;
begin
  Result := Compare(Left, Right) < 0;
end;

class operator BigDecimal.LessThanOrEqual(const Left, Right: BigDecimal): Boolean;
begin
  Result := Compare(Left, Right) <= 0;
end;

class function BigDecimal.Max(const Left, Right: BigDecimal): BigDecimal;
begin
  if Compare(Left, Right) > 0 then
    Result := Left
  else
    Result := Right;
end;

class function BigDecimal.Min(const Left, Right: BigDecimal): BigDecimal;
begin
  if Compare(Left, Right) < 0 then
    Result := Left
  else
    Result := Right;
end;

class operator BigDecimal.Modulus(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Remainder(Left, Right);
end;

function BigDecimal.MovePointLeft(Digits: Integer): BigDecimal;
var
  NewScale: Integer;
begin
  NewScale := RangeCheckedscale(Scale + Digits);
  Result := BigDecimal.Create(FValue, NewScale);
  if Result.FScale < 0 then
    Result.FScale := 0;
end;

function BigDecimal.MovePointRight(Digits: Integer): BigDecimal;
var
  NewScale: Integer;
begin
  NewScale := RangeCheckedScale(Scale - Digits);
  Result := BigDecimal.Create(FValue, NewScale);
  if Result.FScale < 0 then
    Result.FScale := 0;
end;

class operator BigDecimal.Multiply(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Multiply(Left, Right);
end;

///////////////////////////////////////////////////////////////////////////////////////
//                                                                                   //
//  Multiplication is the easiest: multiply the unscaled values and add the scales.  //
//                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////

class function BigDecimal.Multiply(const Left, Right: BigDecimal): BigDecimal;
begin
  Result.Init;
  Result.FScale := RangeCheckedScale(Left.FScale + Right.FScale);
  Result.FValue := Left.FValue * Right.FValue;
end;

class function BigDecimal.Negate(const Value: BigDecimal): BigDecimal;
begin
  Result.Init;
  Result.FValue := -Value.FValue;
  Result.FScale := Value.FScale;
end;

class operator BigDecimal.Negative(const Value: BigDecimal): BigDecimal;
begin
  Result := Negate(Value);
end;

class operator BigDecimal.NotEqual(const Left, Right: BigDecimal): Boolean;
begin
  Result := Compare(left, Right) <> 0;
end;

class function BigDecimal.Parse(const S: string; const Settings: TFormatSettings): BigDecimal;
begin
  Result.Init;
  if not TryParse(S, Settings, Result) then
    Error(ecParse, [S, 'BigDecimal']);
end;

class function BigDecimal.Parse(const S: string): BigDecimal;
begin
  Result.Init;
  if not TryParse(S, Result) then
    Error(ecParse, [S, 'BigDecimal']);
end;

class operator BigDecimal.Positive(const Value: BigDecimal): BigDecimal;
begin
  Result.Init;
  Result := Value;
end;

function BigDecimal.Precision: Integer;
type
  CardRec = packed record
    Lo: Cardinal;
    Hi: Integer;
  end;
const
  // 1292913986 is Log10(2) * 1^32.
  CMultiplier = Int64(1292913986);
var
  Full: Int64;
begin
  Result := FPrecision;
  if Result = 0 then
  begin
    //Note: Both 9999 ($270F) and 10000 ($2710) have a bitlength of 14, but 9999 has a precision of 4, while 10000 has a precision of 5.
    //      In other words: BitLength is not a good enough measure for precision. The test with the power of ten is necessary.
    Full := Int64(FValue.BitLength + 1) * CMultiplier;
    Result := CardRec(Full).Hi;
    if (GetPowerOfTen(Result) <= Abs(FValue)) or (Result = 0) then
      Inc(Result);
    FPrecision := Result;
  end;
end;

// Checks new scale for over- or underflow. Returns new scale.
class function BigDecimal.RangeCheckedScale(NewScale: Int32): Integer;
begin
  if NewScale > MaxScale then
    Error(ecUnderflow, [])
  else if NewScale < MinScale then
    Error(ecOverflow, []);
  Result := NewScale;
end;

function BigDecimal.Reciprocal(Precision: Integer): BigDecimal;
begin
  Result := Divide(BigDecimal.One, Self, Precision, DefaultRoundingMode);
end;

function BigDecimal.Reciprocal: BigDecimal;
begin
  Result := Divide(BigDecimal.One, Self, DefaultPrecision, DefaultRoundingMode);
end;

class function BigDecimal.Remainder(const Left, Right: BigDecimal): BigDecimal;
var
  LQuotient: BigDecimal;
begin
  Result.Init;
  LQuotient := Left div Right;
  Result := Left - LQuotient * Right;
end;

function BigDecimal.RemoveTrailingZeros(TargetScale: Integer): BigDecimal;
begin
  Result := Self;
  if (TargetScale >= FScale) or (Precision = 1) then
    Exit;
  FPrecision := 0;
  InPlaceRemoveTrailingZeros(Result, TargetScale);
end;

class function BigDecimal.Round(const Value: BigDecimal): Int64;
begin
  Result := Round(Value, DefaultRoundingMode);
end;

class function BigDecimal.Round(const Value: BigDecimal; ARoundingMode: RoundingMode): Int64;
var
  Rounded: BigDecimal;
begin
  Result := 0;
  Rounded := Value.RoundTo(0, ARoundingMode);
  try
    Result := Rounded.FValue.AsInt64;
  except
    Error(ecConversion, ['BigDecimal', 'Int64']);
  end;
end;

class operator BigDecimal.Round(const Value: BigDecimal): Int64;
begin
  Result := BigDecimal.Round(Value);
end;

function BigDecimal.RoundTo(Digits: Integer): BigDecimal;
begin
  Result := RoundToScale(-Digits, DefaultRoundingMode);
end;

function BigDecimal.RoundTo(Digits: Integer; ARoundingMode: RoundingMode): BigDecimal;
begin
  Result := RoundToScale(-Digits, ARoundingMode);
end;

function BigDecimal.RoundToPrecision(APrecision: Integer): BigDecimal;
var
  PrecisionDifference: Integer;
begin
  PrecisionDifference := APrecision - Self.Precision;
  Result := RoundTo(-(Scale + PrecisionDifference));
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                   //
//  Note:                                                                                            //
//      Rounding is done in several parts of this unit. Instead of using the classic bitwise         //
//      methodology (guard, round and sticky bits), I like to use the remainder after a              //
//      division by a power of ten.                                                                  //
//                                                                                                   //
//      Division truncates, so the first four rounding modes, rmDown, rmUp, rmCeiling and            //
//      rmFloor are easy: truncate and then look if you must add one to the quotient, depending      //
//      on these rounding modes only (and on the sign).                                              //
//                                                                                                   //
//      But the next three, rmNearestUp, rmNearestDown and rmNearestEven, depend on whether the      //
//      remainder is "half" of the low bit. That is how the remainder is used: if                    //
//      remainder + remainder > divisor, we must round up, if it is < divisor we must round down,    //
//      and if = divisor, the rounding mode determines if the quotient must be incremented or not.   //
//                                                                                                   //
//      This principle is used throughout this unit.                                                 //
//                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////

function BigDecimal.RoundToScale(NewScale: Integer; ARoundingMode: RoundingMode): BigDecimal;
var
  LScaleDifference: Integer;
  LValue, LDivisor: BigInteger;
  LRemainder, LQuotient: BigInteger;
  LSign: Integer;
begin
  Result.Init;
  LScaleDifference := RangeCheckedScale(Self.Scale - NewScale);
  if LScaleDifference > 0 then
  begin
    LDivisor := GetPowerOfTen(LScaleDifference);
    LSign := FValue.Sign;
    LValue := BigInteger.Abs(FValue);
    BigInteger.DivMod(LValue, LDivisor, LQuotient, LRemainder);
    AdjustForRoundingMode(LQuotient, LDivisor, LRemainder, LSign, ARoundingMode);
    Result.FValue := LSign * LQuotient;
  end
  else if LScaleDifference < 0 then
    Result.FValue := Self.FValue * GetPowerOfTen(-LScaleDifference)
  else
    Result.FValue := Self.FValue;
  Result.FScale := NewScale;
end;

class procedure BigDecimal.SetExponentDelimiter(const Value: Char);
begin
  if (Value = 'e') or (Value = 'E') then
    FExponentDelimiter := Value;
end;

function BigDecimal.Sign: TValueSign;
begin
  Result := FValue.Sign;
end;

class function BigDecimal.Sqr(const Value: BigDecimal): BigDecimal;
begin
  Result.Init;
  Result.FValue := BigInteger.Sqr(Value.FValue);
  Result.FScale := RangeCheckedScale(Value.FScale + Value.FScale);
end;

function BigDecimal.Sqr: BigDecimal;
begin
  Result := BigDecimal.Sqr(Self);
end;

class function BigDecimal.Sqrt(const Value: BigDecimal; Precision: Integer): BigDecimal;
begin
  Result := Value.Sqrt(System.Math.Max(Precision, DefaultPrecision));
end;

class function BigDecimal.Sqrt(const Value: BigDecimal): BigDecimal;
begin
  Result := Value.Sqrt(System.Math.Max(DefaultPrecision, Value.Precision));
end;

function BigDecimal.Sqrt(Precision: Integer): BigDecimal;
var
  LMultiplier: Integer;
  LValue: BigInteger;
begin
  // Note: the following self-devised algorithm works. I don't yet know if it can be optimized.
  // With "works", I mean that if A := B.Sqrt, then (A*A).RoundToScale(B.Scale) = B.
  Result.Init;
  Precision := System.Math.Max(Precision, 2 * Self.Precision);

  // Determine a suitable factor to multiply FValue by to get a useful precision
  LMultiplier := RangeCheckedScale(Precision - Self.Precision + 1);
  if Odd(LMultiplier + Self.Scale) then
    Inc(LMultiplier);

  // If the multiplier > 0, then multiply BigInteger by 10^LMultiplier
  if LMultiplier > 0 then
    LValue := Self.FValue * GetPowerOfTen(LMultiplier)
  else
    LValue := Self.FValue;

  // Using BigInteger.Sqrt should already be pretty close to the desired result.
  Result.FValue := BigInteger.Sqrt(LValue);
  Result.FScale := RangeCheckedScale(Self.Scale + LMultiplier) div 2;

  // Round the result and remove any unnecessary trailing zeroes.
  Result := Result.RoundToScale(RangeCheckedScale(Result.FScale + Precision div 2 - Result.Precision + 1), DefaultRoundingMode);
  InPlaceRemoveTrailingZeros(Result, System.Math.Min(Self.Scale, Self.Scale div 2));
end;

function BigDecimal.Sqrt: BigDecimal;
begin
  Result := Self.Sqrt(DefaultPrecision);
end;

class function BigDecimal.Subtract(const Left, Right: BigDecimal): BigDecimal;
var
  A, B: BigInteger;
begin
  Result.Init;
  if Left.Scale > Right.Scale then
  begin
    A := Left.FValue;

    // There is no need to use RangeCheckedScale, because one scale is simply changed to the other, and both
    // were already in range.
    B := Right.FValue * GetPowerOfTen(Left.Scale - Right.Scale);
    Result.FScale := Left.Scale;
  end
  else
  begin
    A := Left.FValue * GetPowerOfTen(Right.Scale - Left.Scale);
    B := Right.FValue;
    Result.FScale := Right.Scale;
  end;
  Result.FValue := A - B;
end;

class operator BigDecimal.Subtract(const Left, Right: BigDecimal): BigDecimal;
begin
  Result := Subtract(Left, Right);
end;

// Returns decimal notation (i.e. without using exponents).
function BigDecimal.ToPlainString(const Settings: TFormatSettings): string;
var
  S: string;
  LNegative: Boolean;
  LScale, LLength: Integer;
begin
  LNegative := FValue.IsNegative;
  S := BigInteger.Abs(FValue).ToString(10);
  LScale := Self.Scale;
  LLength := Length(S);
  if LScale < 0 then
    Result := S + StringOfChar('0', -LScale)
  else if LScale = 0 then
    Result := S
  else if LScale >= LLength then
    Result := '0' + Settings.DecimalSeparator + StringOfChar('0', LScale - LLength) + S
  else
    Result := Copy(S, 1, LLength - LScale) + Settings.DecimalSeparator + Copy(S, LLength - LScale + 1, MaxInt);
  if LNegative then
    Result := '-' + Result;
end;

function BigDecimal.ToPlainString: string;
begin
  Result := ToPlainString(InvariantSettings);
end;

function BigDecimal.ToString: string;
begin
  Result := ToString(InvariantSettings);
end;

function BigDecimal.ToString(const Settings: TFormatSettings): string;
var
  AdjustedExponent: Integer;
  PlainText: string;
  Negative: Boolean;
begin
  Negative := FValue.IsNegative;
  PlainText := BigInteger.Abs(FValue).ToString(10);
  AdjustedExponent := Length(PlainText) - 1 - Self.Scale;
  if (Self.Scale >= 0) and (AdjustedExponent >= -6) then
    Result := ToPlainString(Settings)
  else
  begin
    // Exponential notation
    if Length(PlainText) > 1 then
      PlainText := PlainText[1] + Settings.DecimalSeparator + Copy(PlainText, 2, MaxInt);
    PlainText := PlainText + FExponentDelimiter;
    if AdjustedExponent >= 0 then
      PlainText := PlainText + '+';
    PlainText := PlainText + IntToStr(AdjustedExponent);
    if Negative then
      PlainText := '-' + PlainText;
    Result := PlainText;
  end;
end;

function BigDecimal.Trunc: Int64;
var
  Rounded: BigDecimal;
begin
  Result := 0; // Avoid warning.
  Rounded := Self.RoundTo(0, rmDown);
  try
    Result := Rounded.FValue.AsInt64;
  except
    Error(ecConversion, ['BigDecimal', 'Int64']);
  end;
end;

class operator BigDecimal.Trunc(const Value: BigDecimal): Int64;
begin
  Result := Value.Trunc;
end;

// Converts string with national settings to invariant string and then calls TryParse(string, BigDecimal).
class function BigDecimal.TryParse(const S: string; const Settings: TFormatSettings; out Value: BigDecimal): Boolean;
var
  InvariantString: string;
  I: Integer;
begin
  SetLength(InvariantString, Length(S));
  for I := 1 to Length(S) do
  begin
    if S[I] = Settings.DecimalSeparator then
      InvariantString[I] := '.'
    else if S[I] = Settings.ThousandSeparator then
      InvariantString[I] := ','
    else
      InvariantString[I] := S[I];
  end;
  Result := TryParse(InvariantString, Value);
end;

class function BigDecimal.TryParse(const S: string; out Value: BigDecimal): Boolean;
var
  LIsNegative: Boolean;
  LIsNegativeExponent: Boolean;
  LExponent: Integer;
  LNumDecimals: Integer;
  LDecimalPointPos: PChar;
  LTrimmedS: string;
  LPtr: PChar;
  LChr: Char;
  LIntValue: string;
begin
  Value.Init;
  Result := False;
  LIntValue := '';
  LTrimmedS := Trim(S);
  LPtr := PChar(LTrimmedS);
  if LPtr^ = #0 then
    Exit;
  LIsNegative := False;
  LIsNegativeExponent := False;
  LDecimalPointPos := nil;
  if (LPtr^ = '+') or (LPtr^ = '-') then
  begin
    LIsNegative := (LPtr^ = '-');
    Inc(LPtr);
  end;
  if LPtr^ = #0 then
    Exit;
  Value.FValue := BigInteger.Zero;
  LNumDecimals := 0;

  // Parse text up to any exponent.
  LChr := LPtr^;
  while (LChr <> #0) and (LChr <> 'e') and (LChr <> 'E') do  // DO NOT TRANSLATE!
  begin
    case LChr of
      '0'..'9':
        LIntValue := LIntvalue + LChr;
      ',':
        ; // Ignore thousand-separators.
      '.':
        if Assigned(LDecimalPointPos) then
          // Decimal point was parsed already, so exit indicating invalid result.
          Exit
        else
          LDecimalPointPos := LPtr;
      else
        Exit;
    end;
    Inc(LPtr);
    LChr := LPtr^;
  end;

  // Parsed significand to end or up to first 'e' or 'E'.
  if Assigned(LDecimalPointPos) then
    LNumDecimals := LPtr - LDecimalPointPos - 1;

  LExponent := 0;
  if (LChr = 'e') or (LChr = 'E') then  // DO NOT TRANSLATE!
  begin
    // Parse exponent
    Inc(LPtr);
    if (LPtr^ = '+') or (LPtr^ = '-') then
    begin
      LIsNegativeExponent := (LPtr^ = '-');
      Inc(LPtr);
    end;
    while LPtr^ <> #0 do
    begin
      case LPtr^ of
        '0'..'9':
          LExponent := LExponent * 10 + Ord(LPtr^) - Ord('0');
        else
          Exit;
      end;
      Inc(LPtr);
    end;
  end;
  if LIsNegativeExponent then
    LExponent := -LExponent;
  LNumDecimals := LNumDecimals - LExponent;

  Value.FScale := LNumDecimals;
  Value.FValue := BigInteger(LIntValue);
  if not Value.FValue.IsZero and LIsNegative then
    Value.FValue.SetSign(-1);
  Result := True;
end;

function BigDecimal.ULP: BigDecimal;
begin
  Result.FPrecision := 1;
  Result.FValue := BigInteger.One;
  Result.FScale := Self.Scale;
end;

{$IFNDEF HasClassConstructors}
initialization
  BigDecimal.InitClass;
{$ENDIF}

end.
