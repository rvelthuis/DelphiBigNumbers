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

// To implement:
// Create(Value: Double; MaxDenominator: Integer); -- see below
// AsSingle
// AsDouble
// AsExtended
// AsBigDecimal()
// AsBigDecimal(RoundingMode)
// AsBigDecimal(Scale, RoundingMode)
// AsInteger
// AsInt64
// Add(BigRational, BigRational)
// Add(BigRational, Integer)
// Add(BigRational, Int64)
// Add(BigRational, BigInteger)
// same for Subtract, Multiply and Divide
// Negate
// PercentageValue ?
// Pow(Exponent: Integer)
// Pow(Exponent: Int64);
// Pow(Exponent: BigInteger);
// Pow(Exponent: Double): Double;
// My own:
// ToMixedString (returns "97/15" as "6 7/15")
// IsProper (proper fraction is when num < denom)

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals, System.Math, System.SysUtils, CompilerAndRTLVersions;

{$IF CompilerVersion < CompilerVersionDelphiXE8}
  {$IF (DEFINED(WIN32) OR DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}
    {$DEFINE CPU32BITS}
  {$IFEND}
  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}
    {$DEFINE CPU64BITS}
  {$IFEND}
{$IFEND}

{$IF CompilerVersion >= CompilerVersionDelphiXE3}
  {$LEGACYIFEND ON}
{$IFEND}

{$IF CompilerVersion >= CompilerVersionDelphiXE}
  {$CODEALIGN 16}
  {$ALIGN 16}
{$IFEND}

{$IF CompilerVersion >= CompilerVersionDelphi2010}
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
    // and moves sign to numerator. In other words, turns a BigRational into its canonical form.
    procedure Normalize(Forced: Boolean = False);

    // Raises exception using error code and additional data to decide which and how.
    procedure Error(Code: TErrorCode; ErrorInfo: array of const);
  public
    const
      MinEpsilon = 5e-10;

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

    /// <summary>Creates a new BigRational with the same value as the given Double value. For this, it uses
    ///  at most MaxIterations and the error is at most Epsilon.</summary>
    /// <exception cref="EInvalidArgument">EInvalidArgument is raised if the Double represents a positive or
    ///  negative infinity or a NaN.</exception>
    /// <exception cref="EOverflow">EOverflow is raised when the Double represents a value that is not representable
    ///  as a fraction of Integers.</exception>
    /// <remarks><para>Note that this conversion creates enumerator and denominator that are at most Integer
    ///  values.</para>
    /// <para>This uses a conversion to a finite continued fraction combined with the unfolding to a simple fraction
    ///  in one loop, steadily refining the fraction. MaxIterations and Epsilon determine when the loop ends.
    //   MaxIterations governs the maximum number of iterations in the loop, and Epsilon governs the maximum difference
    //   between the double and the fraction.</para>
    /// <para>Typical values are MaxIterations = 15 and Epsilon = 4e-10 (which is close to 1/MaxInt).</para></remarks>
    constructor Create(Value, Epsilon: Double; MaxIterations: Integer); overload;

    /// <summary>Creates a new BigRational with the best matching value, with a denominator value of at most
    ///  MaxDenominator</summary>
    constructor Create(F: Double; MaxDenominator: Cardinal); overload;

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

    // Instance functions

    function IsNegative: Boolean; inline;
    function IsPositive: Boolean; inline;
    function IsZero: Boolean; inline;

    /// <summary>Returns the absolute value of the current BigRational.</summary>
    function Abs: BigRational;

    /// <summary>Returns the negation of the current BigRational.</summary>
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

function BigRational.Abs: BigRational;
begin
  if Self.FNumerator.IsNegative then
    Result := Self.Negate
  else
    Result := Self;
end;

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
   Test with e.g.

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

constructor BigRational.Create(F: Double; MaxDenominator: Cardinal);

// https://rosettacode.org/wiki/Convert_decimal_number_to_rational#C

var
  A: Int64;
  H, K: array[0..2] of Int64;
  X, D, N: Int64;
  I: Integer;
  LNegative: Boolean;
  MustBreak: Boolean;
begin
  H[0] := 0; H[1] := 1; H[2] := 0;
  K[0] := 1; K[1] := 0; K[2] := 0;
  N := 1;

  if MaxDenominator <= 1 then
  begin
    FDenominator := 1;
    FNumerator := Trunc(F);
    Exit;
  end;

  LNegative := F < 0;
  if LNegative then
    F := -F;

  while (F <> System.Trunc(F)) and (N < (High(Int64) shr 1)) do
  begin
    N := N shl 1;
    F := F * 2;
  end;
  D := System.Trunc(F);

  // Continued fraction and check denominator each step
  for I := 0 to 63 do
  begin
    MustBreak := False;
    if N <> 0 then
      A := D div N
    else
      A := 0;

    if (I <> 0) and (A = 0) then
      Break;

    if N = 0 then
      Break;

    X := D;
    D := N;
    N := X mod N;

    X := A;
    if K[1] * A + K[0] >= MaxDenominator then
    begin
      X := (MaxDenominator - K[0]) div K[1];
      if (X * 2 >= A) or (K[1] >= MaxDenominator) then
        MustBreak := True
      else
        Break;
    end;
    H[2] := X * H[1] + H[0]; H[0] := H[1]; H[1] := H[2];
    K[2] := X * K[1] + K[0]; K[0] := K[1]; K[1] := K[2];
    if MustBreak then
      Break;
  end;
  FDenominator := K[1];
  if LNegative then
    FNumerator := -H[1]
  else
    FNumerator := H[1];
end;

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

constructor BigRational.Create(Value, Epsilon: Double; MaxIterations: Integer);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//  One way to solve this is to convert the Value into a (finite) continous fraction, i.e. a fraction in the form   //
//  a0 + 1/(a1 + 1/(a2 + 1/(a3 + ...))) or, often also written as [a0; a1, a2, a3 ...].                             //
//  If we reverse this using numerator and denominator, we can easily construct a suitable normal fraction.         //
//                                                                                                                  //
//  This constructor does something similar, except that the loop to construct a continued fraction and the loop    //
//  to decompose the continued fraction into a simple fraction are folded together. This repeatedly refines the     //
//  fraction, until the maximum number of iterations is reached, or the difference between fraction and Value is    //
//  less than the given epsilon, whichever comes first.                                                             //
//                                                                                                                  //
//  This uses numerators and denominators as much as possible in the Integer range. A tested version using          //
//  BigDecimals and BigIntegers was far too precise and did not stop early enough.                                  //
//                                                                                                                  //
//  There is a MinEpsilon constant of value 5e-10, which is slightly above 1/MaxInt. Smaller values could cause     //
//  invalid  results.                                                                                               //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(*
function ConvertDoubleToRational(Value, Epsilon: Double; MaxIterations: Integer; var FNumerator, FDenominator: Int64): Double; overload;
*)
var
  LNegative: Boolean;
  LQuot: Double;
  LError: Double;
  I: Integer;
  NewRatio, Ratio: Double;
  Rest, Rest0, Inverse, Inverse0: Double;
  K, H: array[0..2] of Int64;
  A: Int64;
  LNum, LDenom: BigInteger;
begin
  LQuot := 0.0;

  if IsInfinite(Value) or IsNaN(Value) then
    Error(ecInvalidArg, ['Double']);

  LNegative := Value < 0;
  if LNegative then
    Value := -Value;

  if Value > MaxInt then
  begin
    // reduce Value to range [0..MaxInt)
    LQuot := Int(Value / MaxInt) * MaxInt;
    Value := Value - LQuot;
    // Hmmm... turn it into a suitable range
    // FloatMod(Value, MaxInt, Quot, Rem);
    // Quot := Int(Value / MaxInt);
    // Value := Value - Quot * MaxInt;
    // work on rem --> value, remember quot;
    // raise EOverflow.CreateFmt('Value %g cannot be converted to an integer ratio', [Value]);
  end;

  if Value = 0.0 then
  begin
    FNumerator := BigInteger.Zero;
    FDenominator := BigInteger.One;
    Exit;
  end;

  if Epsilon = 0 then
    Epsilon := 5e-10;

  I := 0;
  while I < MaxIterations do
  begin
    if I = 0 then
    begin
      A := Trunc(Value);
      Rest := Value - A;
      if Rest = 0.0 then
      begin
        FNumerator := A;
        FDenominator := 1;
        Exit;
      end;
      Inverse := 1.0 / Rest;
      K[2] := A;
      H[2] := 1;
      NewRatio := K[2] / H[2];
      LError := System.Abs(Value - NewRatio);
    end
    else
    begin
      A := Trunc(Inverse0);
      Rest := Inverse0 - A;
      if Rest = 0.0 then
        Rest := Epsilon;
      Inverse := 1.0 / Rest;
      if I = 1 then
      begin
        K[2] := A * K[1] + 1;
        H[2] := A * H[1];
      end
      else
      begin
        if (A > MaxInt) or (K[1] > MaxInt) or (H[1] > MaxInt) then
          Break;
        K[2] := A * K[1] + K[0];
        H[2] := A * H[1] + H[0];
      end;
      NewRatio := K[2] / H[2];
      LError := System.Abs(NewRatio - Ratio);
    end;
    if LError < Epsilon then
      Break
    else
      Ratio := NewRatio;
    Inc(I);
    K[0] := K[1];
    K[1] := K[2];
    H[0] := H[1];
    H[1] := H[2];
    Inverse0 := Inverse;
    Rest0 := Rest;
    if Inverse0 > MaxInt then
      Break;
  end;
  LNum := K[1];
  LDenom := H[1];
  if LQuot > 0.0 then
    LNum := LNum + BigInteger(LQuot) * LDenom;
  if LNegative then
    LNum := -LNum;

  FNumerator := LNum;
  FDenominator := LDenom;
  Normalize;
end;

class function BigRational.Compare(const Left, Right: BigRational): Integer;
begin
  if Left.FDenominator = Right.FDenominator then
    Result := BigInteger.Compare(Left.FNumerator, Right.FNumerator)
  else
    Result := BigInteger.Compare(Left.FNumerator * Right.FDenominator,
                                 Right.FNumerator * Left.FDenominator);
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

class procedure BigRational.DivMod(const Left, Right: BigRational;
  var Quotient: BigInteger; var Remainder: BigRational);
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

function BigRational.IsNegative: Boolean;
begin
  Result := Self.FNumerator.IsNegative;
end;

function BigRational.IsPositive: Boolean;
begin
  Result := Self.FNumerator.IsPositive;
end;

function BigRational.IsZero: Boolean;
begin
  Result := Self.FNumerator.IsZero;
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

  Value := Zero;
  LSlash := Pos('/', S);
  if LSlash < 1 then
  begin
    Result := BigInteger.TryParse(Trim(S), Num);
    Denom := BigInteger.One;
  end
  else
  begin
    Result := BigInteger.TryParse(Trim(Copy(S, 1, LSlash - 1)), Num);
    Result := BigInteger.TryParse(Trim(Copy(S, LSlash + 1, MaxInt)), Denom) or Result;
  end;
  if Result then
    Value := BigRational.Create(Num, Denom);
end;

{$IFNDEF HasClassConstructors}
initialization
  Init;
{$ENDIF}

end.
