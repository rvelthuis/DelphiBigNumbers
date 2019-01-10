program TestPPAddSpeed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Diagnostics,
  Velthuis.AutoConsole,
  Velthuis.BigIntegers in '..\..\Source\Velthuis.BigIntegers.pas',
  Velthuis.Numerics in '..\..\Source\Velthuis.Numerics.pas',
  Velthuis.RandomNumbers in '..\..\Source\Velthuis.RandomNumbers.pas';

function Fibonacci(n: Integer): BigInteger;
var
  prevprev, prev: BigInteger;
begin
  prevprev := BigInteger.Zero;
  prev := BigInteger.One;
  Result := BigInteger.Zero;
  while n >= 2 do
  begin
    Result := prevprev + prev;
    prevprev := prev;
    prev := Result;
    Dec(n);
  end;
end;

procedure Test;
begin
  var SW := TStopwatch.StartNew;
  for var N := 5000 downto 1 do
    var X := Fibonacci(N);
  Writeln(SW.ElapsedMilliseconds);
end;

begin
{$IFDEF CPU64BITS}
  Writeln('64 bit');
{$ELSE}
  Writeln('32 bit');
{$ENDIF}
  try
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
