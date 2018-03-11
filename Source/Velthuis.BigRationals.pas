{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.BigRationals.pas                                     }
{ Function:   A multiple precision rational nubmer implementation, based    }
{             on the BigInteger implementation in                           }
{             Velthuis.BigIntegers.pas.                                     }
{ Language:   Delphi version XE2 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2016,2017 Rudy Velthuis                                   }
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

unit Velthuis.BigRationals experimental;

//$$RV comments are internal comments by RV, denoting a problem. Should be all removed as soon as problem solved.
// TODO: handle extended properly, e.g. in Create(Extended)

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals, System.Math, System.SysUtils;

// For Delphi versions below XE8
{$IF CompilerVersion < 29.0}
  {$IF (DEFINED(WIN32) OR DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}
    { $MESSAGE HINT 'Defining CPU32BITS'}
    {$DEFINE CPU32BITS}
  {$IFEND}
  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}
    { $MESSAGE HINT 'Defining CPU64BITS'}
    {$DEFINE CPU64BITS}
  {$IFEND}
{$IFEND}

// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
  {$LEGACYIFEND ON}
{$IFEND}

// For Delphi XE and up:
{$IF CompilerVersion >= 22.0}
  {$CODEALIGN 16}
  {$ALIGN 16}
{$IFEND}

// For Delphi 2010 and up.
{$IF CompilerVersion >= 21.0}
  {$DEFINE HasClassConstructors}
{$IFEND}

{$IF SizeOf(Extended) > SizeOf(Double)}
  {$DEFINE HasExtended}
{$IFEND}

type
  PBigRational = ^BigRational;

  /// <summary>BigRational is a multiple precision rational data type, where each value is expressed as the quotient
  ///   of two BigIntegers, the numerator and the denominator.</summary>
  /// <remarks><para>BigRationals are simplified, i.e. common factors in numerator and denominator are eliminated.
  ///   </para>
  ///   <para>The resulting sign is always moved to the numerator. The denominator must always be unsigned.</para>
  /// </remarks>
  BigRational = record
  private
    type
      // Error code for the Error procedure.
      TErrorCode = (ecParse, ecDivByZero, ecConversion, ecInvalidArg, ecZeroDenominator);

    var
      // The numerator (the "top" part of the fraction).
      FNumerator: BigInteger;
      // The denominator (the "bottom" part of the fraction).
      FDenominator: BigInteger;

    class var
      // Field for AlwaysReduce property.
      FAlwaysReduce: Boolean;

    // Returns -1 for negative values, 1 for positive values and 0 for zero.
    function GetSign: Integer;

    // Checks for invalid values, simplifies the fraction by eliminating common factors in numerator and denominator,
    // and moves sign to numerator.
    procedure Normalize(Forced: Boolean = False);

    // Raises exception using error code and additional data to decide which and how.
    procedure Error(Code: TErrorCode; ErrorInfo: array of const);
  public
    class var

      /// <summary>Predefined BigRational value 0.</summary>
      Zero: BigRational;

      /// <summary>Predefined BigRational value 1/10.</summary>
      OneTenth: BigRational;

      /// <summary>Predefined BigRational value 1/4.</summary>
      OneFourth: BigRational;

      /// <summary>Predefined BigRational value 1/3.</summary>
      OneThird: BigRational;

      /// <summary>Predefined BigRational value 1/2.</summary>
      OneHalf: BigRational;

      /// <summary>Predefined BigRational value 2/3.</summary>
      TwoThirds: BigRational;

      /// <summary>Predefined BigRational value 3/4.</summary>
      ThreeFourths: BigRational;

      /// <summary>Predefined BigRational value 1.</summary>
      One: BigRational;

      /// <summary>Predefined BigRational value 10.</summary>
      Ten: BigRational;

{$IFDEF HasClassConstructors}
    class constructor Initialize;
{$ENDIF}

    // -- Constructors --

    /// <summary>Creates a new BigRational with the given values as numerator and denominator, respectively. The
    ///  sign is adjusted thus, that the denominator is positive.</summary>
    constructor Create(const Numerator, Denominator: BigInteger); overload;

    /// <summary>Creates a new BigRational from the given value, with a denominator of 1.</summary>
    constructor Create(const Value: BigInteger); overload;

    /// <summary>Creates a new BigRational from the given value, with a denominator of 1.</summary>
    constructor Create(const Value: Integer); overload;

    /// <summary>Creates a new BigRational from the given values.</summary>
    constructor Create(const Numerator: Integer; const Denominator: Cardinal); overload;

    /// <summary>Creates a new BigRational with the exact same value as the given Double value.</summary>
    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the Double represents a positive or
    ///   negative infinity or a NaN.</exception>
    /// <remarks>Note that this is an exact conversion, taking into account the exact bit representation of the
    ///   double. This means that the numerator and denominator values can be rather big.</remarks>
    constructor Create(const Value: Double); overload;

//{$IFDEF HasExtended}
//    /// <summary>Creates a new BigRational with the exact same value as the given Extended value.</summary>
//    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the Extended represents a positive or
//    ///   negative infinity or a NaN.</exception>
//    /// <remarks>Note that this is an exact conversion, taking into account the exact bit representation of the
//    ///   Extended. This means that the numerator and denominator values can be rather big.</remarks>
//    constructor Create(const Value: Extended); overload;
//{$ENDIF}

    /// <summary>Creates a new BigRational from the given value, with a denominator of 1.</summary>
    constructor Create(const Value: Int64); overload;

    /// <summary>Creates a new BigRational from the given values.</summary>
    constructor Create(const Numerator: Int64; const Denominator: UInt64); overload;

    /// <summary>Creates a new BigRational from the given string, which should be in the format
    ///   [optional sign] + numerator + '/' + denominator.</summary>
    /// <remarks>Example input: '-1234/5678'.</remarks>
    constructor Create(const Value: string); overload;

    /// <summary>Creates a new BigRational from the given BigDecimal.</summary>
    constructor Create(const Value: BigDecimal); overload;

    // TODO: Create(const Value: Double; MaxDenominator: Integer); overload; // gets best approximation
    // TODO: Create(const Value: Double; MaxEpsilon: Double); overload; // gets best approximation


    // -- Mathematical operators and functions --

    /// <summary>Adds two BigRationals and returns the sum. Simplifies the result.</summary>
    class function Add(const Left, Right: BigRational): BigRational; static;

    /// <summary>Adds two BigRationals and returns the sum. Simplifies the result.</summary>
    class operator Add(const Left, Right: BigRational): BigRational;

    /// <summary>Subtracts two BigRationals and returns the difference. Simplifies the result.</summary>
    class function Subtract(const Left, Right: BigRational): BigRational; static;

    /// <summary>Subtracts two BigRationals and returns the difference. Simplifies the result.</summary>
    class operator Subtract(const Left, Right: BigRational): BigRational;

    /// <summary>Multiplies two BigRationals and returns the product. Simplifies the result.</summary>
    class function Multiply(const Left, Right: BigRational): BigRational; static;

    /// <summary>Multiplies two BigRationals and returns the product. Simplifies the result.</summary>
    class operator Multiply(const Left, Right: BigRational): BigRational;

    /// <summary>Divides two BigRationals by multiplying Left by the reciprocal of Right. Returns the quotient.
    ///   Simplifies the result.</summary>
    class function Divide(const Left, Right: BigRational): BigRational; static;

    /// <summary>Divides two BigRationals by multiplying Left by the reciprocal of Right. Returns the quotient.
    ///   Simplifies the result.</summary>
    class operator Divide(const Left, Right: BigRational): BigRational;

    /// <summary>Divides two BigRationals returning a BigInteger result.</summary>
    class operator IntDivide(const Left, Right: BigRational): BigInteger;

    /// <summary>Divides two BigRationals returning the remainder. Simplifies the result.</summary>
    class operator Modulus(const Left, Right: BigRational): BigRational;

    /// <summary>Divides two BigRationals returning the remainder. Simplifies the result.</summary>
    class function Remainder(const Left, Right: BigRational): BigRational; static;

    /// <summary>Divides two BigRationals and returns the quotient and remainder.</summary>
    class procedure DivMod(const Left, Right: BigRational; var Quotient: BigInteger; var Remainder: BigRational); static;

    /// <summary>Returns the negation of the given BigRational value.</summary>
    class operator Negative(const Value: BigRational): BigRational;

    /// <summary>Returns the negation of the current BigRational value.</summary>
    function Negate: BigRational;

    /// <summary>Returns the multiplicative inverse of the current BigRational value by swapping numerator and
    ///   denominator.</summary>
    function Reciprocal: BigRational;

    /// <summary>Reduces numerator and denominator to their smallest values representing the same ratio.</summary>
    function Reduce: BigRational;


    // -- Comparison and relational operators --

    /// <summary>Compares two BigRationals. Returns -1 if Left < Right, 1 if Left > Right and
    ///   0 if Left = Right.</summary>
    class function Compare(const Left, Right: BigRational): Integer; static;

    /// <summary>Returns True only if Left < Right.</summary>
    class operator LessThan(const Left, Right: BigRational): Boolean;

    /// <summary>Returns True only if Left <= Right.</summary>
    class operator LessThanOrEqual(const Left, Right: BigRational): Boolean;

    /// <summary>Returns True only if Left = Right.</summary>
    class operator Equal(const Left, Right: BigRational): Boolean;

    /// <summary>Returns True only if Left >= Right.</summary>
    class operator GreaterThanOrEqual(const Left, Right: BigRational): Boolean;

    /// <summary>Returns True only if Left > Right.</summary>
    class operator GreaterThan(const Left, Right: BigRational): Boolean;

    /// <summary>Returns True only if Left <> Right.</summary>
    class operator NotEqual(const Left, Right: BigRational): Boolean;


    // --- Conversion operators --

    /// <summary>Converts the string to a BigRational.</summary>
    /// <exception cref="EConvertError"></exception>
    class operator Implicit(const Value: string): BigRational;

    /// <summary>Explicitly converts the BigRational to a string (using ToString).</summary>
    class operator Explicit(const Value: BigRational): string;

    /// <summary>Converts the integer to a BigRational.</summary>
    class operator Implicit(const Value: Integer): BigRational;

    /// <summary>Converts the BigRational to an Integer. If necessary, excess top bits are cut off.</summary>
    class operator Explicit(const Value: BigRational): Integer;

    /// <summary>Converts the Int64 to a BigRational.</summary>
    class operator Implicit(const Value: Int64): BigRational;

    /// <summary>Converts the BigRational to an Int64. If necessary, excess top bits are cut off.</summary>
    class operator Explicit(const Value: BigRational): Int64;

    /// <summary>Converts the given Double to a BigRational.</summary>
    /// <exception cref="EInvalidArgument">Raises an EInvalidArgument exception if Value represents
    ///   (+/-)infinity or NaN.</exception>
    class operator Implicit(const Value: Double): BigRational;

    /// <summary>Converts the given BigRational to a Double.</summary>
    class operator Explicit(const Value: BigRational): Double;

    /// <summary>Converts the given BigDecimal to a BigRational.</summary>
    /// <remarks>This conversion is exact.</remarks>
    class operator Implicit(const Value: BigDecimal): BigRational;

    /// <summary>Converts the given BigRational to a BigDecimal, using the default BigDecimal precision and
    ///   rounding mode.</summary>
    class operator Implicit(const Value: BigRational): BigDecimal;

    /// <summary>Converts the current BigRational to a string. This string can be used as valid input for
    ///  conversion.</summary>
    function ToString: string;

    function Parse(const S: string): BigRational;
    function TryParse(const S: string; out Value: BigRational): Boolean;


    // -- Properties --

    /// <summary>The numerator of the fraction represented by the current BigRational.</summary>
    property Numerator: BigInteger read FNumerator;

    /// <summary>The denominator of the fraction represented by the current BigRational.</summary>
    property Denominator: BigInteger read FDenominator;

    /// <summary>The sign of the fraction represented by the current BigRational.</summary>
    property Sign: Integer read GetSign;

    /// <summary>If AlwaysReduce is set (default), fractions like 2/10 are reduced to 1/5.
    ///   If it is not set, you can manually call Reduce on any BigRational.</summary>
    class property AlwaysReduce: Boolean read FAlwaysReduce write FAlwaysReduce;

  end;

implementation

uses
  Velthuis.FloatUtils, Velthuis.StrConsts;

{ BigRational }

class operator BigRational.Add(const Left, Right: BigRational): BigRational;
begin
  if Left.FDenominator = Right.FDenominator then
  begin
    Result.FNumerator := Left.FNumerator + Right.FNumerator;
    Result.FDenominator := Left.FDenominator;
  end
  else
  begin
    Result.FDenominator := Left.FDenominator * Right.FDenominator;
    Result.FNumerator := Left.FNumerator * Right.FDenominator + Right.FNumerator * Left.FDenominator;
  end;
  Result.Normalize;
end;

class function BigRational.Add(const Left, Right: BigRational): BigRational;
begin
  Result := Left + Right;
end;

constructor BigRational.Create(const Value: Integer);
begin
  FNumerator := BigInteger(Value);
  FDenominator := BigInteger.One;
end;

constructor BigRational.Create(const Numerator: Integer; const Denominator: Cardinal);
begin
  FNumerator := BigInteger(Numerator);
  FDenominator := BigInteger(Denominator);
  Normalize;
end;

constructor BigRational.Create(const Numerator, Denominator: BigInteger);
begin
  FNumerator := Numerator;
  FDenominator := Denominator;
  Normalize;
end;

constructor BigRational.Create(const Value: BigInteger);
begin
  FNumerator := Value;
  FDenominator := BigInteger.One;
end;

(*
https://rosettacode.org/wiki/Convert_decimal_number_to_rational#Ada

procedure Real_To_Rational (R: Real;
                            Bound: Positive;
                            Nominator: out Integer;
                            Denominator: out  Positive) is
   Error: Real;
   Best: Positive := 1;
   Best_Error: Real := Real'Last;
begin
   if R = 0.0 then
      Nominator := 0;
      Denominator := 1;
      return;
   elsif R < 0.0 then
      Real_To_Rational(-R, Bound, Nominator, Denominator);
      Nominator := - Nominator;
      return;
   else
      for I in 1 .. Bound loop
         Error := abs(Real(I) * R - Real'Rounding(Real(I) * R));
         if Error < Best_Error then
            Best := I;
            Best_Error := Error;
         end if;
      end loop;
   end if;
   Denominator := Best;
   Nominator   := Integer(Real'Rounding(Real(Denominator) * R));

end Real_To_Rational;

procedure RealToRational(R: Extended; Bound: Cardinal; out Nominator: Integer; Denominator: Cardinal);
var
  Error: Extended;
  Best: Cardinal;
  BestError: Extended;
  I: Integer;
begin
  Best := 1;
  BestError := Math.MaxExtended;

  if R = 0.0 then
  begin
    Nominator := 0;
    Denominator := 1;
  end
  else if R < 0.0 then
  begin
    RealToRational(-R, Bound, Nominator, Denominator);
    Nominator := -Nominator;
  end
  else
  begin
    for I := 1 to Bound do
    begin
      Error := Abs(I * R - Round(I * R));
      if Error < BestError then
      begin
        Best := I;
        BestError := Error;
      end; // if
    end; // for
  end; // if
  Denominator := Best;
  Nominator := Round(Denominator * R);
end;

// --------------------------------------

with Ada.Text_IO; With Real_To_Rational;

procedure Convert_Decimal_To_Rational is

   type My_Real is new Long_Float; -- change this for another "Real" type

   package FIO is new Ada.Text_IO.Float_IO(My_Real);
   procedure R2R is new Real_To_Rational(My_Real);

   Nom, Denom: Integer;
   R: My_Real;

begin
   loop
      Ada.Text_IO.New_Line;
      FIO.Get(R);
      FIO.Put(R, Fore => 2, Aft => 9, Exp => 0);
      exit when R = 0.0;
      for I in 0 .. 4 loop
         R2R(R, 10**I, Nom, Denom);
         Ada.Text_IO.Put("  " & Integer'Image(Nom) &
                         " /" & Integer'Image(Denom));
      end loop;
   end loop;
end Convert_Decimal_To_Rational;

// Output: -----------------------------

> ./convert_decimal_to_rational < input.txt

 0.750000000   1 / 1   3 / 4   3 / 4   3 / 4   3 / 4
 0.518518000   1 / 1   1 / 2   14 / 27   14 / 27   14 / 27
 0.905405400   1 / 1   9 / 10   67 / 74   67 / 74   67 / 74
 0.142857143   0 / 1   1 / 7   1 / 7   1 / 7   1 / 7
 3.141592654   3 / 1   22 / 7   22 / 7   355 / 113   355 / 113
 2.718281828   3 / 1   19 / 7   193 / 71   1457 / 536   25946 / 9545
-0.423310825   0 / 1  -3 / 7  -11 / 26  -69 / 163  -1253 / 2960
31.415926536   31 / 1   157 / 5   377 / 12   3550 / 113   208696 / 6643
 0.000000000

*)

constructor BigRational.Create(const Value: Double);
var
  Exponent: Integer;
  Mantissa: Int64;
begin
  if IsInfinite(Value) or IsNaN(Value) then
    Error(ecInvalidArg, ['Double']);

  if Value = 0.0 then
  begin
    FNumerator := BigInteger.Zero;
    FDenominator := BigInteger.One;
    Exit;
  end;

  Exponent := GetExponent(Value);
  Mantissa := GetMantissa(Value);

  if IsDenormal(Value) then
  begin
    FNumerator := Mantissa;
    FDenominator := BigInteger.Zero.FlipBit(1023 + 52);
  end
  else
  begin
    FDenominator := BigInteger.Zero.FlipBit(52);
    FNumerator := Mantissa;
    if Exponent < 0 then
      FDenominator := FDenominator shl -Exponent
    else
      FNumerator := FNumerator shl Exponent;
  end;
  if Value < 0 then
    FNumerator := -FNumerator;
  Normalize;
end;

class function BigRational.Compare(const Left, Right: BigRational): Integer;
begin
  if Left.FDenominator = Right.FDenominator then
    Result := BigInteger.Compare(Left.FNumerator, Right.FNumerator)
  else
    Result := BigInteger.Compare(Left.FNumerator * Right.FDenominator, Right.FNumerator * Left.FDenominator);
end;

constructor BigRational.Create(const Numerator: Int64; const Denominator: UInt64);
begin
  FNumerator := BigInteger(Numerator);
  FDenominator := BigInteger(Denominator);
  Normalize;
end;

constructor BigRational.Create(const Value: Int64);
begin
  FNumerator := BigInteger(Value);
  FDenominator := BigInteger.One;
end;

constructor BigRational.Create(const Value: string);
begin
  Self := Parse(Value);
end;

constructor BigRational.Create(const Value: BigDecimal);
var
  Num, Denom: BigInteger;
  Scale: Integer;
begin
  Num := Value.UnscaledValue;
  Scale := Value.Scale;
  Denom := BigInteger.One;

  if Scale < 0 then
    Num := Num * BigInteger.Pow(BigInteger.Ten, -Scale)
  else if Scale > 0 then
    Denom := BigInteger.Pow(BigInteger.Ten, Scale);

  Create(Num, Denom);
end;

//{$IFDEF HasExtended}
//constructor BigRational.Create(const Value: Extended);
//var
//  D: Double;
//begin
//  D := Value;
//  Create(D);
//end;
//{$ENDIF HasExtended}

class function BigRational.Divide(const Left, Right: BigRational): BigRational;
begin
  Result := Left / Right;
end;

class operator BigRational.Divide(const Left, Right: BigRational): BigRational;
begin
  if Left.FDenominator = Right.FDenominator then
  begin
    Result.FNumerator := Left.FNumerator;
    Result.FDenominator := Right.FNumerator;
  end
  else
  begin
    Result.FNumerator := Left.FNumerator * Right.FDenominator;
    Result.FDenominator := Left.FDenominator * Right.FNumerator;
  end;
  Result.Normalize;
end;

class procedure BigRational.DivMod(const Left, Right: BigRational; var Quotient: BigInteger; var Remainder: BigRational);
var
  AD, BC: BigInteger;
begin
  if Left.FDenominator = Right.FDenominator then
  begin
    AD := Left.FNumerator;
    BC := Right.FNumerator;
  end
  else
  begin
    AD := Left.FNumerator * Right.FDenominator;
    BC := Left.FDenominator * Right.FNumerator;
  end;

  Quotient := AD div BC;

  Remainder.FNumerator := AD - Quotient * BC;
  Remainder.FDenominator := Left.FDenominator * Right.FDenominator;
  Remainder.Normalize;
end;

class operator BigRational.Equal(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) = 0;
end;

procedure BigRational.Error(Code: TErrorCode; ErrorInfo: array of const);
begin
  case Code of
    ecParse:
      raise EConvertError.CreateFmt(SErrorParsingFmt, ErrorInfo);
    ecDivByZero:
      raise EDivByZero.Create(SDivisionByZero);
    ecConversion:
      raise EConvertError.CreateFmt(SConversionFailedFmt, ErrorInfo);
    ecInvalidArg:
      raise EInvalidArgument.CreateFmt(SInvalidArgumentFmt, ErrorInfo);
    ecZeroDenominator:
      raise EDivByZero.Create(SZeroDenominator);
  end;
end;

class operator BigRational.Explicit(const Value: BigRational): Integer;
begin
  if Value.FDenominator = BigInteger.One then
    Result := Integer(Value.FNumerator)
  else
    Result := Integer(Value.FNumerator div Value.FDenominator);
end;

class operator BigRational.Explicit(const Value: BigRational): string;
begin
  Result := Value.ToString;
end;

class operator BigRational.Explicit(const Value: BigRational): Double;
begin
  if Value.FDenominator = BigInteger.One then
    Result := Value.FNumerator.AsDouble
  else
    Result := Value.FNumerator.AsDouble / Value.FDenominator.AsDouble;
end;

class operator BigRational.Explicit(const Value: BigRational): Int64;
begin
  if Value.FDenominator = BigInteger.One then
    Result := Int64(Value.FNumerator)
  else
    Result := Int64(Value.FNumerator div Value.FDenominator);
end;

function BigRational.GetSign: Integer;
begin
  if FNumerator.IsZero then
    Result := 0
  else if FNumerator.IsNegative then
    Result := -1
  else
    Result := 1;
end;

class operator BigRational.GreaterThan(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) > 0;
end;

class operator BigRational.GreaterThanOrEqual(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) >= 0;
end;

class operator BigRational.Implicit(const Value: Integer): BigRational;
begin
  Result.FNumerator := BigInteger(Value);
  Result.FDenominator := BigInteger.One;
end;

class operator BigRational.Implicit(const Value: string): BigRational;
begin
  Result.Create(Value);
end;

class operator BigRational.Implicit(const Value: Double): BigRational;
begin
  Result.Create(Value);
end;

class operator BigRational.Implicit(const Value: Int64): BigRational;
begin
  Result.FNumerator := BigInteger(Value);
  Result.FDenominator := BigInteger.One;
end;

class operator BigRational.Implicit(const Value: BigDecimal): BigRational;
begin
  if Value.Scale = 0 then
  begin
    Result.FNumerator := Value.UnscaledValue;
    Result.FDenominator := BigInteger.One
  end
  else if Value.Scale > 0 then
  begin
    Result.FNumerator := Value.UnscaledValue;
    Result.FDenominator := BigInteger.Pow(BigInteger.Ten, Value.Scale);
  end
  else
  begin
    Result.FNumerator := Value.UnscaledValue * BigInteger.Pow(BigInteger.Ten, -Value.Scale);
    Result.FDenominator := BigInteger.One;
  end;
  Result.Normalize;
end;

class operator BigRational.Implicit(const Value: BigRational): BigDecimal;
begin
  Result := BigDecimal(Value.FNumerator) / Value.FDenominator;
end;

{$IFDEF HasClassConstructors}
class constructor BigRational.Initialize;
{$ELSE}
procedure Init;
{$ENDIF}
begin
  BigRational.FAlwaysReduce := True;
  BigRational.Zero := BigRational.Create(BigInteger.Zero, BigInteger.One);
  BigRational.OneTenth := BigRational.Create(BigInteger.One, BigInteger.Ten);
  BigRational.OneFourth := BigRational.Create(BigInteger.One, BigInteger(4));
  BigRational.OneThird := BigRational.Create(BigInteger.One, BigInteger(3));
  BigRational.OneHalf := BigRational.Create(BigInteger.One, BigInteger(2));
  BigRational.TwoThirds := BigRational.OneThird + BigRational.OneThird;
  BigRational.ThreeFourths := BigRational.OneHalf + BigRational.OneFourth;
  BigRational.One := BigRational.Create(BigInteger.One, BigInteger.One);
  BigRational.Ten := BigRational.Create(BigInteger.Ten, BigInteger.One);
end;

class operator BigRational.IntDivide(const Left, Right: BigRational): BigInteger;
begin
  Result := (Left.FNumerator * Right.FDenominator) div (Left.FDenominator * Right.FNumerator);
end;

function BigRational.Reciprocal: BigRational;
begin
  if FNumerator.IsZero then
    Error(ecDivByZero, []);
  if Self.FNumerator.IsNegative then
  begin
    Result.FNumerator := -Self.FDenominator;
    Result.FDenominator := -Self.FNumerator;
  end
  else
  begin
    Result.FNumerator := Self.FDenominator;
    Result.FDenominator := Self.FNumerator;
  end;
end;

function BigRational.Reduce: BigRational;
begin
  Result := Self;
  Result.Normalize(True);
end;

class function BigRational.Remainder(const Left, Right: BigRational): BigRational;
begin
  Result := Left mod Right;
end;

class operator BigRational.LessThan(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) < 0;
end;

class operator BigRational.LessThanOrEqual(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) <= 0;
end;

class operator BigRational.Modulus(const Left, Right: BigRational): BigRational;
var
  AD, BC: BigInteger;
begin
  // Result := Left - (Left div Right) * Right;
  // This can be elaborated:
  // X := A/B mod C/D -->
  // X := A/B - (AD div BC) * C/D; -->
  // X := AD/BD - (AD div BC) * BC/BD; -->
  // X := [AD - (AD div BC) * BC] / BD;

  //$$RV: Can this be simplified?
  AD := Left.FNumerator * Right.FDenominator;
  BC := Left.FDenominator * Right.FNumerator;
  Result.FNumerator := AD - (AD div BC) * BC;
  Result.FDenominator := Left.FDenominator * Right.FDenominator;
  Result.Normalize;
end;

class operator BigRational.Multiply(const Left, Right: BigRational): BigRational;
begin
  Result.FNumerator := Left.FNumerator * Right.FNumerator;
  Result.FDenominator := Left.FDenominator * Right.FDenominator;
  Result.Normalize;
end;

function BigRational.Negate: BigRational;
begin
  Result.FDenominator := Self.FDenominator;
  Result.FNumerator := -Self.FNumerator;
end;

class operator BigRational.Negative(const Value: BigRational): BigRational;
begin
  Result.FDenominator := Value.FDenominator;
  Result.FNumerator := -Value.FNumerator;
end;

procedure BigRational.Normalize(Forced: Boolean = False);
var
  GCD: BigInteger;
begin
  if FDenominator.IsZero then
    Error(ecZeroDenominator, []);

  if FDenominator = BigInteger.One then
    Exit;

  if FDenominator.IsNegative then
  begin
    FNumerator := -FNumerator;
    FDenominator := -FDenominator;
  end;

  if (FAlwaysReduce or Forced) then
  begin
    GCD := BigInteger.Abs(BigInteger.GreatestCommonDivisor(FNumerator, FDenominator));

    // TODO: See if this can be simplified by shifting common low zero bits away first
    if GCD > BigInteger.One then
    begin
      FNumerator := FNumerator div GCD;
      FDenominator := FDenominator div GCD;
    end;
  end;
end;

class operator BigRational.NotEqual(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) <> 0;
end;

function BigRational.Parse(const S: string): BigRational;
begin
  if not TryParse(S, Result) then
    Error(ecParse, [S, 'BigRational']);
end;

class function BigRational.Multiply(const Left, Right: BigRational): BigRational;
begin
  Result := Left * Right;
end;

class operator BigRational.Subtract(const Left, Right: BigRational): BigRational;
begin
  if Left.FDenominator = Right.FDenominator then
  begin
    Result.FNumerator := Left.FNumerator - Right.FNumerator;
    Result.FDenominator := Left.FDenominator;
  end
  else
  begin
    Result.FDenominator := Left.FDenominator * Right.FDenominator;
    Result.FNumerator := Left.FNumerator * Right.FDenominator - Right.FNumerator * Left.FDenominator;
  end;
  Result.Normalize;
end;

class function BigRational.Subtract(const Left, Right: BigRational): BigRational;
begin
  Result := Left - Right;
end;

function BigRational.ToString: string;
begin
  if FDenominator = BigInteger.One then
    Result := FNumerator.ToString
  else
    Result := FNumerator.ToString + '/' + FDenominator.ToString;
end;


function BigRational.TryParse(const S: string; out Value: BigRational): Boolean;
var
  LSlash: Integer;
  Num, Denom: BigInteger;
begin
  if S = '' then
    Exit(False);

  LSlash := Pos('/', S);
  if LSlash < 1 then
  begin
    Result := BigInteger.TryParse(S, Num);
    Denom := BigInteger.One;
  end
  else
  begin
    Result := BigInteger.TryParse(Copy(S, 1, LSlash - 1), Num);
    Result := BigInteger.TryParse(Copy(S, LSlash + 1, MaxInt), Denom) or Result;
  end;
  if Result then
    Value := BigRational.Create(Num, Denom);
end;

{$IFNDEF HasClassConstructors}
initialization
  Init;
{$ENDIF}

end.
