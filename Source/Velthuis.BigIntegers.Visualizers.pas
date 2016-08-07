{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.BigIntegers.Visualizers.pas                          }
{ Function:   Visualizers for the BigInteger and BigDecimal classes,        }
{             as define in Velthuis.BigIntegers.pas and                     }
{             Velthuis.BigDecimals.pas, respectively.                       }
{             BigInteger implementation in Velthuis.BigIntegers.pas.        }
{ Language:   Delphi version XE2 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2016, Rudy Velthuis                                       }
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

unit Velthuis.BigIntegers.Visualizers;

interface

{$IFNDEF DLLEXPERT}
procedure Register;
{$ENDIF}

implementation

uses
  System.Classes, System.SysUtils, ToolsAPI, Velthuis.BigIntegers, Velthuis.BigDecimals, System.Generics.Collections;

resourcestring
  SBigIntegerVisualizerName = 'BigInteger and BigDecimal Visualizers for Delphi';
  SBigIntegerVisualizerDescription = 'Displays BigInteger and BigDecimal instances in human-readable format';

type
  TDebuggerBigIntegerVisualizer = class(TInterfacedObject,
                                        IOTADebuggerVisualizer,
                                        IOTADebuggerVisualizerValueReplacer,
                                        IOTAThreadNotifier,
                                        IOTAThreadNotifier160)
  private
    FCompleted: Boolean;
    FDeferredResult: string;
    class function ParseBigIntegerEvalResult(const AEvalResult: string): string; static;
    class function ParseBigDecimalEvalResult(const AEvalResult: string): string; static;
    class procedure Error(const S: string = ''); static;
    class function IsDecimalDigit(C: Char): Boolean; inline; static;
    class function IsDigit(C: Char): Boolean; static;
    class function IsIdentifierChar(C: Char): Boolean; inline; static;
    class function IsIdentifierStartChar(C: Char): Boolean; inline; static;
    class function IsIntegerStart(C: Char): Boolean; static;
    class procedure OptionalIdentifier(var P: PChar; const Identifier: string); static;
    class function ParseBigDecimal(var P: PChar): BigDecimal; static;
    class function ParseBigInteger(var P: PChar): BigInteger; static;
    class function ParseIdentifier(var P: PChar): string; inline; static;
    class function ParseInt32(var P: PChar): Integer; static;
    class function ParseMagnitude(var P: PChar): TMagnitude; static;
    class function ParseUInt32(var P: PChar): UInt32; static;
    class procedure RequiredChar(var P: PChar; C: Char); static;
    class procedure SkipComment(var P: PChar); inline; static;
    class procedure SkipDelimiter(var P: PChar); static;
    class procedure SkipWhitespace(var P: PChar); inline; static;
  public
    // IOTADEbuggerVisualizer
    function GetSupportedTypeCount: Integer;
    procedure GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants: Boolean);
    function GetVisualizerIdentifier: string;
    function GetVisualizerName: string;
    function GetVisualizerDescription: string;
    // IOTADebuggerVisualizerValueReplacer
    function GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
    // IOTAThreadNotifier
    // Note: it is called Evalute, not Evaluate, here!
    procedure EvaluteComplete(const ExprStr, ResultStr: string; CanModify: Boolean; ResultAddress, ResultSize: Cardinal; ReturnCode: Integer);
    procedure ModifyComplete(const ExprStr, ResultStr: string; ReturnCode: Integer);
    procedure ThreadNotify(Reason: TOTANotifyReason);
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    // IOTAThreadNotifier160
    procedure EvaluateComplete(const ExprStr, ResultStr: string; CanModify: Boolean; ResultAddress: TOTAAddress; ResultSize: Longword; ReturnCode: Integer);
  end;

{ TDebuggerBigIntegerVisualizer }

procedure TDebuggerBigIntegerVisualizer.AfterSave;
begin
  // Can be ignored.
end;

procedure TDebuggerBigIntegerVisualizer.BeforeSave;
begin
  // Can be ignored.
end;

procedure TDebuggerBigIntegerVisualizer.Destroyed;
begin
  // Can be ignored.
end;

procedure TDebuggerBigIntegerVisualizer.EvaluteComplete(const ExprStr, ResultStr: string; CanModify: Boolean;
  ResultAddress, ResultSize: Cardinal; ReturnCode: Integer);
begin
  EvaluateComplete(ExprStr, ResultStr, CanModify, TOTAAddress(ResultAddress), Longword(ResultSize), ReturnCode);
end;

procedure TDebuggerBigIntegerVisualizer.EvaluateComplete(const ExprStr, ResultStr: string; CanModify: Boolean;
  ResultAddress: TOTAAddress; ResultSize: Longword; ReturnCode: Integer);
begin
  FCompleted := True;
  if ReturnCode = 0 then
    FDeferredResult := ResultStr;
end;

// Parser

class procedure TDebuggerBigIntegerVisualizer.Error(const S: string = '');
begin
  if S = '' then
    raise Exception.Create('Visualizer error')
  else
    raise Exception.Create(S);
end;

class function TDebuggerBigIntegerVisualizer.IsDecimalDigit(C: Char): Boolean;
begin
  Result := ((C >= '0') and (C <= '9'));
end;

class function TDebuggerBigIntegerVisualizer.IsIdentifierStartChar(C: Char): Boolean;
begin
  Result := ((C >= 'A') and (C <= 'Z')) or ((C >= 'a') and (C <= 'z')) or (C = '_');
end;

class function TDebuggerBigIntegerVisualizer.IsIdentifierChar(C: Char): Boolean;
begin
  Result := IsIdentifierStartChar(C) or IsDecimalDigit(C);
end;

class function TDebuggerBigIntegerVisualizer.IsDigit(C: Char): Boolean;
begin
  Result := ((C >= '0') and (C <= '9'));
end;

class function TDebuggerBigIntegerVisualizer.IsIntegerStart(C: Char): Boolean;
begin
  Result := IsDigit(C) or (C = '-');
end;

class procedure TDebuggerBigIntegerVisualizer.SkipWhitespace(var P: PChar);
begin
  while P^ = ' ' do
    Inc(P);
end;

class procedure TDebuggerBigIntegerVisualizer.SkipComment(var P: PChar);
begin
  if P^ = '{' then
  begin
    repeat
      Inc(P);
    until P^ = '}';
    Inc(P);
  end;
end;

class procedure TDebuggerBigIntegerVisualizer.SkipDelimiter(var P: PChar);
begin
  if (P^ = ',') or (P^ = ';') then
    Inc(P);
end;

class procedure TDebuggerBigIntegerVisualizer.RequiredChar(var P: PChar; C: Char);
begin
  if P^ = C then
    Inc(P)
  else
    Error;
end;

class function TDebuggerBigIntegerVisualizer.ParseIdentifier(var P: PChar): string;
begin
  Result := '';
  repeat
    if IsIdentifierChar(P^) then
    begin
      Result := Result + P^;
      Inc(P);
    end
    else
      Error;
  until P^ = ':';
  Inc(P);
end;

// If a field identifier was specified, it must be Identifier. If not, ignore.
class procedure TDebuggerBigIntegerVisualizer.OptionalIdentifier(var P: PChar; const Identifier: string);
var
  Id: string;
begin
  if IsIdentifierStartChar(P^) then
  begin
    Id := ParseIdentifier(P);
    if UpperCase(Id) <> UpperCase(Identifier) then
      Error(Format('%s missing', [Identifier]));
  end;
end;

class function TDebuggerBigIntegerVisualizer.ParseUInt32(var P: PChar): UInt32;
begin
  Result := 0;

  // Skip whitespace
  SkipWhitespace(P);

  // parse digits
  while IsDecimalDigit(P^) do
  begin
    Result := Result * 10 + UInt32(Ord(P^) - Ord('0'));
    Inc(P);
  end;

  SkipWhitespace(P);
  SkipComment(P);
  SkipWhitespace(P);
end;

class function TDebuggerBigIntegerVisualizer.ParseInt32(var P: PChar): Integer;
var
  Sign: Boolean;
begin
  if not IsIntegerStart(P^) then
    Error;

  Result := 0;
  Sign := False;

  // Check for sign
  if P^ = '-' then
  begin
    Sign := True;
    Inc(P);
  end;

  // Parse number
  while IsDigit(P^) do
  begin
    Result := Result * 10 + (Ord(P^) - Ord('0'));
    Inc(P);
  end;

  SkipWhitespace(P);
  SkipComment(P);
  SkipWhitespace(P);

  // Prepend sign
  if Sign then
    Result := -Result;
end;

class function TDebuggerBigIntegerVisualizer.ParseMagnitude(var P: PChar): TMagnitude;
var
  Limbs: TList<TLimb>;
begin
  RequiredChar(P, '(');

  // Check for empty magnitude
  if P^ = ')' then
  begin
    Inc(P);
    Exit(nil);
  end;

  // Parse values in magnitude
  Limbs := TList<TLimb>.Create;
  try
    while P^ <> ')' do
    begin
      Limbs.Add(ParseUInt32(P));
      SkipDelimiter(P);
    end;

    if Limbs.Count > 0 then
      Result := Limbs.ToArray
    else
      Result := nil;

  finally
    Limbs.Free;
  end;

  RequiredChar(P, ')');
end;

class function TDebuggerBigIntegerVisualizer.ParseBigInteger(var P: PChar): BigInteger;
var
  LMagnitude: TMagnitude;
  LSize: Integer;
begin
  RequiredChar(P, '(');

  OptionalIdentifier(P, 'FData');
  LMagnitude := ParseMagnitude(P);
  SkipDelimiter(P);

  SkipWhitespace(P);
  OptionalIdentifier(P, 'FSize');
  LSize := ParseInt32(P);

  RequiredChar(P, ')');

  // BigInteger takes two parameters: magnitude and sign
  SetLength(LMagnitude, LSize and BigInteger.SizeMask);

  // Turn parsed data into BigInteger
  Result := BigInteger.Create(LMagnitude, LSize < 0);
end;

class function TDebuggerBigIntegerVisualizer.ParseBigIntegerEvalResult(const AEvalResult: string): string;
var
  P: PChar;
  LValue: BigInteger;
begin
  P := PChar(AEvalResult);

  try
    LValue := ParseBigInteger(P);
  except
    on E: Exception do
      Exit(AEvalResult + ' ' + E.Message);
  end;

  Result := LValue.ToString(10);
end;

class function TDebuggerBigIntegerVisualizer.ParseBigDecimal(var P: PChar): BigDecimal;
var
  LScale: Integer;
  LValue: BigInteger;
begin
  LValue := BigInteger.Zero;

  RequiredChar(P, '(');

  OptionalIdentifier(P, 'FValue');
  LValue := ParseBigInteger(P);
  SkipDelimiter(P);

  SkipWhiteSpace(P);
  OptionalIdentifier(P, 'FScale');
  LScale := ParseInt32(P);
  SkipDelimiter(P);

  SkipWhiteSpace(P);
  OptionalIdentifier(P, 'FPrecision');
  {LPrecision :=} ParseInt32(P);

  RequiredChar(P, ')');

  Result := BigDecimal.Create(LValue, LScale);
end;

class function TDebuggerBigIntegerVisualizer.ParseBigDecimalEvalResult(const AEvalResult: string): string;
var
  P: PChar;
  LValue: BigDecimal;
begin
  P := PChar(AEvalResult);

  try
    LValue := ParseBigDecimal(P);
  except
    Exit(AEvalResult);
  end;

  Result := LValue.ToString;
end;

function TDebuggerBigIntegerVisualizer.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
begin
  if (EvalResult <> '') and (EvalResult[1] = '(') then
    if TypeName = 'BigInteger' then
      Result := ParseBigIntegerEvalResult(EvalResult)
    else if TypeName = 'BigDecimal' then
      Result := ParseBigDecimalEvalResult(EvalResult)
    else
      Result := EvalResult
  else
    Result := EValResult;
end;

procedure TDebuggerBigIntegerVisualizer.GetSupportedType(Index: Integer; var TypeName: string;
  var AllDescendants: Boolean);
begin
  AllDescendants := False;
  if Index = 0 then
    TypeName := 'BigInteger'
  else if Index = 1 then
    TypeName := 'BigDecimal';
end;

function TDebuggerBigIntegerVisualizer.GetSupportedTypeCount: Integer;
begin
  Result := 2;
end;

function TDebuggerBigIntegerVisualizer.GetVisualizerDescription: string;
begin
  Result := SBigIntegerVisualizerDescription;
end;

function TDebuggerBigIntegerVisualizer.GetVisualizerIdentifier: string;
begin
  Result := ClassName;
end;

function TDebuggerBigIntegerVisualizer.GetVisualizerName: string;
begin
  Result := SBigIntegerVisualizerName;
end;

procedure TDebuggerBigIntegerVisualizer.Modified;
begin
  // Can be ignored.
end;

procedure TDebuggerBigIntegerVisualizer.ModifyComplete(const ExprStr, ResultStr: string; ReturnCode: Integer);
begin
  // Can be ignored.
end;

procedure TDebuggerBigIntegerVisualizer.ThreadNotify(Reason: TOTANotifyReason);
begin
  // Can be ignored.
end;

var
  Visualizer: IOTADEbuggerVisualizer = nil;
  IDEServices: IBorlandIDEServices = nil;

{$IFNDEF DLLEXPERT}
procedure Register;
var
  DebuggerServices: IOTADebuggerServices;
begin
  Visualizer := TDebuggerBigIntegerVisualizer.Create;
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
    DebuggerServices.RegisterDebugVisualizer(Visualizer);
end;

procedure RemoveVisualizer;
var
  DebuggerServices: IOTADebuggerServices;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
    DebuggerServices.UnregisterDebugVisualizer(Visualizer);
end;

initialization

finalization
  RemoveVisualizer;
{$ELSE}
procedure RegisterVisualizer;
var
  DebuggerServices: IOTADebuggerServices;
begin
  Visualizer := TDebuggerBigIntegerVisualizer.Create;
  if Supports(IDEServices, IOTADebuggerServices, DebuggerServices) then
    DebuggerServices.RegisterDebugVisualizer(Visualizer);
end;

procedure TerminateVisualizer;
var
  DebuggerServices: IOTADEbuggerServices;
begin
  if Supports(IDEServices, IOTADebuggerServices, DebuggerServices) then
    DebuggerServices.UnregisterDebugVisualizer(Visualizer);
end;

function InitWizard(const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  var Terminate: TWizardTerminateProc): Boolean; stdcall;
begin
  Result := Assigned(BorlandIDEServices);
  if Result then
  begin
    IDEServices := BorlandIDEServices;
    RegisterVisualizer;
    Terminate := TerminateVisualizer;
  end;
end;

exports
  InitWizard name WizardEntryPoint;
{$ENDIF}

end.

