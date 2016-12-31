unit Velthuis.BigDecimals.Math;

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals;

type
  BigDecimalMath = class
  private
    class var
      FCurrentPrecision: Integer;
      FCurrentPi: BigDecimal;
      FCurrentPiPrecision: Integer;
      FFactorials: TArray<BigDecimal>;
    class procedure MakeFactorials(NewPrecision: Integer); static;
    class constructor InitMath;
  public
    class function Pi(Precision: Integer): BigDecimal; overload; static;
    class function Pi: BigDecimal; overload; static;
    class function Sin(X: BigDecimal; Precision: Integer): BigDecimal; overload; static;
    class function Sin(X: BigDecimal): BigDecimal; overload; static;
    class function Cos(X: BigDecimal; Precision: Integer): BigDecimal; overload; static;
    class function Cos(X: BigDecimal): BigDecimal; overload; static;
  end;

implementation

{ BigDecimalMath }

class function BigDecimalMath.Cos(X: BigDecimal; Precision: Integer): BigDecimal;
begin
  MakeFactorials(Precision);

end;

class function BigDecimalMath.Cos(X: BigDecimal): BigDecimal;
begin

end;

class constructor BigDecimalMath.InitMath;
begin

end;

class procedure BigDecimalMath.MakeFactorials(NewPrecision: Integer);
var
  I: Integer;
  Factor, Factorial: BigDecimal;
begin
  if NewPrecision > FCurrentPrecision then
  begin
    SetLength(FFactorials, NewPrecision);
    Factorial := FFactorials[FCurrentPrecision];
    Factor := FCurrentPrecision;
    for I := FCurrentPrecision + 1 to NewPrecision do
    begin
      Inc(Factor);
      Factorial := Factorial * Factor;
      FFactorials[I] := Factorial;
    end;
  end;
  FCurrentPrecision := NewPrecision;
end;

class function BigDecimalMath.Pi(Precision: Integer): BigDecimal;
begin

end;

class function BigDecimalMath.Pi: BigDecimal;
begin

end;

class function BigDecimalMath.Sin(X: BigDecimal; Precision: Integer): BigDecimal;
begin

end;

class function BigDecimalMath.Sin(X: BigDecimal): BigDecimal;
begin

end;

end.
