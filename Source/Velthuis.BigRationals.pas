{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.BigRationals.pas                                     }
{ Function:   A multiple precision rational nubmer implementation, based    }
{             on the BigInteger implementation in                           }
{             Velthuis.BigIntegers.pas.                                     }
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

unit Velthuis.BigRationals;

//$$RV comments are internal comments by RV, denoting a problem. Should be all removed as soon as problem solved.
//$$RV: all of this is untested! Yes, I write tests later.

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals, System.Math, System.SysUtils;

type
  BigRational = record
  private
    type
      ErrorCode = (ecDivByZero, ecBadArgument, ecNoInfinity, ecZeroDenominator);

    var
      FNumerator: BigInteger;
      FDenominator: BigInteger;

    function GetSign: Integer;
    procedure Normalize;
    procedure Error(Code: ErrorCode; Additional: array of const);
  public
    class var
      Zero: BigRational;
      OneTenth: BigRational;
      OneFourth: BigRational;
      OneThird: BigRational;
      OneHalf: BigRational;
      TwoThirds: BigRational;
      ThreeFourths: BigRational;
      One: BigRational;
      Ten: BigRational;

    class constructor Initialize;

    constructor Create(const Numerator, Denominator: BigInteger); overload;
    constructor Create(const Numerator: BigInteger); overload;
    constructor Create(const Numerator: Integer); overload;
    constructor Create(const Numerator: Integer; const Denominator: Cardinal); overload;
    constructor Create(const ADouble: Double); overload; // exact value of double, i.e. dividing mantissa by 2^53, etc.
    constructor Create(const Numerator: Int64); overload;
    constructor Create(const Numerator: Int64; const Denominator: UInt64); overload;
    constructor Create(const Value: string); overload;
    // TODO: Create(const Value: Double; MaxDenominator: Integer); overload; // gets best approximation
    // TODO: Create(const Value: Double; MaxEpsilon: Double); overload; // gets best approximation

    class function Add(const Left, Right: BigRational): BigRational; static;
    class operator Add(const Left, Right: BigRational): BigRational; static;
    class function Subtract(const Left, Right: BigRational): BigRational; static;
    class operator Subtract(const Left, Right: BigRational): BigRational; static;
    class function Multiply(const Left, Right: BigRational): BigRational; static;
    class operator Multiply(const Left, Right: BigRational): BigRational; static;
    class function Divide(const Left, Right: BigRational): BigRational; static;
    class operator Divide(const Left, Right: BigRational): BigRational; static;
    class operator IntDivide(const Left, Right: BigRational): BigInteger; static;
    class operator Modulus(const Left, Right: BigRational): BigRational; static;
    class procedure DivMod(const Left, Right: BigRational; var Quotient: BigInteger; var Remainder: BigRational); static;

    class function Compare(const Left, Right: BigRational): Integer; static;
    class operator LessThan(const Left, Right: BigRational): Boolean;
    class operator LessThanOrEqual(const Left, Right: BigRational): Boolean;
    class operator Equal(const Left, Right: BigRational): Boolean;
    class operator GreaterThanOrEqual(const Left, Right: BigRational): Boolean;
    class operator GreaterThan(const Left, Right: BigRational): Boolean;
    class operator NotEqual(const Left, Right: BigRational): Boolean;

    class operator Implicit(const Value: string): BigRational;
    class operator Explicit(const Value: BigRational): string;
    class operator Implicit(const Value: Integer): BigRational;
    class operator Explicit(const Value: BigRational): Integer;
    class operator Implicit(const Value: Int64): BigRational;
    class operator Explicit(const Value: BigRational): Int64;
    class operator Implicit(const Value: Double): BigRational;
    class operator Explicit(const Value: BigRational): Double;

    function ToString: string;

    property Numerator: BigInteger read FNumerator;
    property Denominator: BigInteger read FDenominator;
    property Sign: Integer read GetSign;

  end;

implementation

uses
  Velthuis.FloatUtils;

resourcestring
  SDivByZero   = 'Division by zero';
  SBadArgument = 'Invalid argument: %s';
  SNoInfinity  = 'Infinity cannot be converted to BigRational';
  SZeroDenominator = 'BigRational denominator cannot be zero';


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

constructor BigRational.Create(const Numerator: Integer);
begin
  FNumerator := BigInteger(Numerator);
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

constructor BigRational.Create(const Numerator: BigInteger);
begin
  FNumerator := Numerator;
  FDenominator := BigInteger.One;
end;

constructor BigRational.Create(const ADouble: Double);
var
  Exponent: Integer;
  Mantissa: Int64;
begin
  if ADouble = 0.0 then
  begin
    FNumerator := BigInteger.Zero;
    FDenominator := BigInteger.One;
    Exit;
  end;

  Exponent := GetExponent(ADouble);
  Mantissa := GetMantissa(ADouble);

  // TODO: resource strings, private error method.

  if IsNegativeInfinity(ADouble) or IsPositiveInfinity(ADouble) then
    Error(ecNoInfinity, []);

  //$$RV: Untested, until now. --> adjust values where necessary.
  if IsDenormal(ADouble) then
  begin
    FNumerator := Mantissa;
    FDenominator := BigInteger.Zero.FlipBit(1023);
  end
  else
  begin
    FDenominator := BigInteger.Zero.FlipBit(53);
    FNumerator := Mantissa;
    if Exponent < 0 then
      FDenominator := FDenominator shl -Exponent
    else
      FNumerator := FNumerator shl Exponent;
  end;
  if ADouble < 0 then
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

constructor BigRational.Create(const Numerator: Int64);
begin
  FNumerator := BigInteger(Numerator);
  FDenominator := BigInteger.One;
end;

class function BigRational.Divide(const Left, Right: BigRational): BigRational;
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

class operator BigRational.Divide(const Left, Right: BigRational): BigRational;
begin
  Result := Left / Right;
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

procedure BigRational.Error(Code: ErrorCode; Additional: array of const);
begin
  case Code of
    ecDivByZero:
      raise EDivByZero.Create(SDivByZero);
    ecBadArgument:
      raise EInvalidArgument.CreateFmt(SBadArgument, Additional);
    ecNoInfinity:
      raise EInvalidArgument.Create(SNoInfinity);
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

// $$RV: have normal initialize function for non-class-constructor versions.
class constructor BigRational.Initialize;
begin
  Zero := BigRational.Create(BigInteger.Zero, BigInteger.One);
  OneTenth := BigRational.Create(BigInteger.One, BigInteger.Ten);
  OneFourth := BigRational.Create(BigInteger.One, BigInteger(4));
  OneThird := BigRational.Create(BigInteger.One, BigInteger(3));
  OneHalf := BigRational.Create(BigInteger.One, BigInteger(2));
  TwoThirds := OneThird + OneThird;
  ThreeFourths := OneHalf + OneFourth;
  One := BigRational.Create(BigInteger.One, BigInteger.One);
  Ten := BigRational.Create(BigInteger.Ten, BigInteger.One);
end;

class operator BigRational.IntDivide(const Left, Right: BigRational): BigInteger;
begin
  Result := (Left.FNumerator * Right.FDenominator) div (Left.FDenominator * Right.FNumerator);
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

procedure BigRational.Normalize;
var
  GCD: BigInteger;
begin
  if FDenominator.IsZero then
    Error(ecZeroDenominator, []);

  if FDenominator = BigInteger.One then
    Exit;

  GCD := BigInteger.Abs(BigInteger.GreatestCommonDivisor(FNumerator, FDenominator));

  // TODO: See if this can be simplified by shifting common low zero bits away first
  if GCD > BigInteger.One then
  begin
    FNumerator := FNumerator div GCD;
    FDenominator := FDenominator div GCD;
  end;
  if FDenominator.IsNegative then
  begin
    FDenominator := -FDenominator;
    FNumerator := -FNumerator;
  end;
end;

class operator BigRational.NotEqual(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) <> 0;
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

function BigRational.ToString: string;
begin
  if FDenominator = BigInteger.One then
    Result := FNumerator.ToString
  else
    Result := FNumerator.ToString + '/' + FDenominator.ToString;
end;

class function BigRational.Subtract(const Left, Right: BigRational): BigRational;
begin
  Result := Left - Right;
end;

constructor BigRational.Create(const Value: string);
var
  Slash: Integer;
  S: string;
begin
  S := Trim(S);
  Slash := Pos('/', S);
  if Slash = 0 then
  begin //$$RV: try ... except raise new exception end?
    FNumerator := S;
    FDenominator := BigInteger.One;
  end
  else
  begin //$$RV: try ... except raise new exception end?
    FNumerator := Copy(S, 1, Slash - 1);
    FDenominator := Copy(S, Slash + 1, MaxInt);
    Normalize;
  end;
end;

end.
