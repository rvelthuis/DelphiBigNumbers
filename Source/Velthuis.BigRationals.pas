unit Velthuis.BigRationals;

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals, System.Math, System.SysUtils;

type
  BigRational = record
  private
    FNum, FDenom: BigInteger;
    function GetSign: Integer;
    procedure Normalize;
  public
    constructor Create(const Numerator, Denominator: BigInteger); overload;
    constructor Create(const Numerator: BigInteger); overload;
    constructor Create(const Numerator: Integer); overload;
    constructor Create(const Numerator: Integer; const Denominator: Cardinal); overload;
    constructor Create(const ADouble: Double); overload;
    constructor Create(const Numerator: Int64); overload;
    constructor Create(const Numerator: Int64; const Denominator: UInt64); overload;
    constructor Create(const Value: string); overload;

    class function Add(const Left, Right: BigRational): BigRational; static;
    class operator Add(const Left, Right: BigRational): BigRational; static;
    class function Subtract(const Left, Right: BigRational): BigRational; static;
    class operator Subtract(const Left, Right: BigRational): BigRational; static;
    class function Multiply(const Left, Right: BigRational): BigRational; static;
    class operator Multiply(const Left, Right: BigRational): BigRational; static;
    class function Divide(const Left, Right: BigRational): BigRational; static;
    class operator Divide(const Left, Right: BigRational): BigRational; static;
    class operator IntDivide(const Left, Right: BigRational): BigRational; static;
    class operator Modulus(const Left, Right: BigRational): BigRational; static;
    class procedure DivMod(const Left, Right: BigRational; var Quotient, Remainder: BigRational); static;

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

    property Numerator: BigInteger read FNum;
    property Denominator: BigInteger read FDenom;
    property Sign: Integer read GetSign;
  end;

implementation

uses
  Velthuis.FloatUtils;

{ BigRational }

class operator BigRational.Add(const Left, Right: BigRational): BigRational;
begin
  Result.FDenom := Left.FDenom * Right.FDenom;
  Result.FNum := Left.FNum * Right.FDenom + Right.FNum * Left.FDenom;
  Result.Normalize;
end;

class function BigRational.Add(const Left, Right: BigRational): BigRational;
begin
  Result := Left + Right;
end;

constructor BigRational.Create(const Numerator: Integer);
begin
  FNum := BigInteger(Numerator);
  FDenom := BigInteger.One;
end;

constructor BigRational.Create(const Numerator: Integer; const Denominator: Cardinal);
begin
  FNum := BigInteger(Numerator);
  FDenom := BigInteger(Denominator);
  Normalize;
end;

constructor BigRational.Create(const Numerator, Denominator: BigInteger);
begin
  FNum := Numerator;
  FDenom := Denominator;
  Normalize;
end;

constructor BigRational.Create(const Numerator: BigInteger);
begin
  FNum := Numerator;
  FDenom := BigInteger.One;
end;

constructor BigRational.Create(const ADouble: Double);
begin

end;

class function BigRational.Compare(const Left, Right: BigRational): Integer;
begin
  Result := BigInteger.Compare(Left.FNum * Right.FDenom, Right.FNum * Left.FDenom);
end;

constructor BigRational.Create(const Numerator: Int64; const Denominator: UInt64);
begin
  FNum := BigInteger(Numerator);
  FDenom := BigInteger(Denominator);
  Normalize;
end;

constructor BigRational.Create(const Numerator: Int64);
begin
  FNum := BigInteger(Numerator);
  FDenom := BigInteger.One;
end;

class function BigRational.Divide(const Left, Right: BigRational): BigRational;
begin
  Result.FNum := Left.FNum * Right.FDenom;
  Result.FDenom := Left.FDenom * Right.FNum;
  Result.Normalize;
end;

class operator BigRational.Divide(const Left, Right: BigRational): BigRational;
begin
  Result := Left / Right;
end;

class procedure BigRational.DivMod(const Left, Right: BigRational; var Quotient, Remainder: BigRational);
begin

end;

class operator BigRational.Equal(const Left, Right: BigRational): Boolean;
begin
  Result := Compare(Left, Right) = 0;
end;

class operator BigRational.Explicit(const Value: BigRational): Integer;
begin
  if Value.FDenom = BigInteger.One then
    Result := Integer(Value.FNum)
  else
    Result := Integer(Value.FNum div Value.FDenom);
end;

class operator BigRational.Explicit(const Value: BigRational): string;
begin
  Result := Value.ToString;
end;

class operator BigRational.Explicit(const Value: BigRational): Double;
begin
  if Value.FDenom = BigInteger.One then
    Result := Value.FNum.AsDouble
  else
    Result := Value.FNum.AsDouble / Value.FDenom.AsDouble;
end;

class operator BigRational.Explicit(const Value: BigRational): Int64;
begin
  if Value.FDenom = BigInteger.One then
    Result := Int64(Value.FNum)
  else
    Result := Int64(Value.FNum div Value.FDenom);
end;

function BigRational.GetSign: Integer;
begin
  if FNum.IsZero then
    Result := 0
  else if FNum.IsNegative then
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
  Result.FNum := BigInteger(Value);
  Result.FDenom := BigInteger.One;
end;

class operator BigRational.Implicit(const Value: string): BigRational;
begin
  Result.Create(Value);
end;

class operator BigRational.Implicit(const Value: Double): BigRational;
begin

end;

class operator BigRational.Implicit(const Value: Int64): BigRational;
begin

end;

class operator BigRational.IntDivide(const Left, Right: BigRational): BigRational;
begin

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
begin

end;

class operator BigRational.Multiply(const Left, Right: BigRational): BigRational;
begin
  Result.FNum := Left.FNum * Right.FNum;
  Result.FDenom := Left.FDenom * Right.FDenom;
  Result.Normalize;
end;

procedure BigRational.Normalize;
var
  GCD: BigInteger;
begin
  if FDenom.IsZero then
    raise EDivByZero.Create('BigRational denominator cannot be zero');
  if FDenom = BigInteger.One then
    Exit;

  GCD := BigInteger.Abs(BigInteger.GreatestCommonDivisor(FNum, FDenom));

  // TODO: See if this can be simplified by shifting common low zero bits away first
  if GCD > BigInteger.One then
  begin
    FNum := FNum div GCD;
    FDenom := FDenom div GCD;
  end;
  if FDenom.IsNegative then
  begin
    FDenom := -FDenom;
    FNum := -FNum;
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
  Result.FDenom := Left.FDenom * Right.FDenom;
  Result.FNum := Left.FNum * Right.FDenom - Right.FNum * Left.FDenom;
  Result.Normalize;
end;

function BigRational.ToString: string;
begin
  if FDenom = BigInteger.One then
    Result := FNum.ToString
  else
    Result := FNum.ToString + '/' + FDenom.ToString;
end;

class function BigRational.Subtract(const Left, Right: BigRational): BigRational;
begin
  Result := Left - Right;
end;

constructor BigRational.Create(const Value: string);
begin

end;

end.
