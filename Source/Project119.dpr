program Project119;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Velthuis.BigDecimals in 'Velthuis.BigDecimals.pas',
  Velthuis.BigIntegers in 'Velthuis.BigIntegers.pas',
  Velthuis.ExactFloatStrings in 'Velthuis.ExactFloatStrings.pas',
  Velthuis.FloatUtils in 'Velthuis.FloatUtils.pas',
  Velthuis.Numerics in 'Velthuis.Numerics.pas',
  Velthuis.RandomNumbers in 'Velthuis.RandomNumbers.pas',
  Velthuis.Sizes in 'Velthuis.Sizes.pas';

procedure Test;
var
  D1, D2, D3, D4, D5: Single;
  B1, B2: BigDecimal;
begin
  D1 := 1.0;
  D2 := D1 / 3.0;
  D3 := D2 * 3.0;
  B1 := BigDecimal.Create(D3);

  D4 := 0.3333333;
  D5 := 3.0 * D4;
  B2 := BigDecimal.Create(D5);

  Writeln(B1.ToPlainString);
  Writeln(B2.ToPlainString);
end;

begin
  try
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
