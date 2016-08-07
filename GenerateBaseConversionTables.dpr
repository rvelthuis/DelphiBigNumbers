program GenerateBaseConversionTables;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.Math, System.Classes;

type
  TBaseInfo = record
    MaxPower: UInt64;
    MaxDigits: Integer;
    PowerOfTwo: Boolean;
    MaxFactor: UInt32;
  end;

var
  BaseInfos32: array[2..36] of TBaseInfo;
  BaseInfos64: array[2..36] of TBaseInfo;

  MaxFactorShift: Integer;

function IsPowerofTwo(I: Integer): Boolean;
begin
  Result := (I and (I - 1)) = 0;
end;

procedure FindMaxValue(const Base, Max: UInt64; var Info: TBaseInfo);
var
  MaxPower: UInt64;
begin
  if (Base < 2) or (Base > 36) then
    raise EInvalidArgument.Create('Invalid base value');
  MaxPower := Max div Base;
  Write('Max = ', MaxPower, ': ');
  Info.PowerOfTwo := IsPowerofTwo(Base);
  Info.MaxPower := Base;
  Info.MaxDigits := 1;
  repeat
    Write(Info.MaxPower, ' ');
    Info.MaxPower := Info.MaxPower * Base;
    Inc(Info.MaxDigits);
  until Info.MaxPower >= MaxPower;
  Writeln(Info.MaxPower);
  Info.MaxFactor := Round((Ln(2) / Ln(Info.MaxPower)) * (1 shl MaxFactorShift));
  Writeln;
end;

const
  Bools: array[Boolean] of string = ('False', 'True');

procedure WriteArray(W: TStreamWriter; const Name: string; const Bases: array of TBaseInfo; const Comment: string);
var
  Comma: Char;
  I: Integer;
begin
  Comma := ',';
  W.WriteLine('  // %s', [Comment]);
  W.WriteLine('  %s: array[TNumberBase] of BigInteger.TNumberBaseInfo = ', [Name]);
  W.WriteLine('  (');

  for I := Low(Bases) to High(Bases) do
  begin
    if I = High(Bases) then
      Comma := ' ';
    W.WriteLine(Format('    (MaxPower: %20u; MaxDigits: %2d; PowerofTwo: %5s; MaxFactor: %6u)%s  // Base %d',
                       [Bases[I].MaxPower, Bases[I].MaxDigits, Bools[Bases[I].PowerOfTwo], Bases[I].MaxFactor, Comma, I + 2],
                       TFormatSettings.Invariant));
  end;

  W.WriteLine('  );');
end;

procedure WriteArrays;
var
  W: TStreamWriter;
begin
  W := TStreamWriter.Create('bases.inc', False, TEncoding.UTF8);
  try
    W.WriteLine('{$IF CompilerVersion < 29.0}');
    W.WriteLine('  {$IF (DEFINED(WIN32) or DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}');
    W.WriteLine('    {$DEFINE CPU32BITS}');
    W.WriteLine('  {$IFEND}');
    W.WriteLine('  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}');
    W.WriteLine('    {$DEFINE CPU64BITS}');
    W.WriteLine('  {$IFEND}');
    W.WriteLine('{$IFEND}');
    W.WriteLine;
    W.WriteLine('const');
    W.WriteLine('  CMaxFactorShift = %d;', [MaxFactorShift]);

    W.WriteLine('{$IFDEF CPU64BITS}');
    WriteArray(W, 'CBaseInfos', BaseInfos64, 'Maximum powers of given bases that fit into UInt64');
    W.WriteLine('{$ELSE}');
    WriteArray(W, 'CBaseInfos', BaseInfos32, 'Maximum powers of given bases that fit into UInt32');
    W.WriteLine('{$ENDIF}');
    W.WriteLine;
  finally
    W.Free;
  end;
end;

var
  I: Integer;

begin
  try
    MaxFactorShift := 24;
    for I := 2 to 36 do
    begin
      FindMaxValue(I, High(UInt32), BaseInfos32[I]);
      FindMaxValue(I, High(UInt64), BaseInfos64[I]);
    end;
    WriteArrays;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

