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

{===========================================================================}
{ NOTE:                                                                     }
{                                                                           }
{ Due to a serious misunderstanding of how visualizers work, I assumed      }
{ that it was necessary to parse the EvalResult parameter of                }
{ GetReplacementValue. I did not know that it was possible to let the       }
{ current thread evaluate the expression passed to it (usually the          }
{ variable name). Now, simply '.ToString' is added to the expression        }
{ and the result is dequoted before it is returned. The entire parsing      }
{ code was removed.                                                         }
{===========================================================================}


unit Velthuis.BigIntegers.Visualizers;

interface

{$IFNDEF DLLEXPERT}
procedure Register;
{$ENDIF}

{$IF RTLVersion >= 32.0}
{$DEFINE GENERICS}
{$IFEND}

implementation

uses
  System.Classes, System.SysUtils, ToolsAPI, Velthuis.BigIntegers, Velthuis.BigDecimals, System.Generics.Collections, Vcl.Dialogs;

resourcestring
  SBigIntegerVisualizerName = 'BigInteger and BigDecimal Visualizers for Delphi';
  SBigIntegerVisualizerDescription = 'Displays BigInteger and BigDecimal instances in human-readable format';

type
  TDebuggerBigIntegerVisualizer = class(TInterfacedObject,
                                        IOTADebuggerVisualizer,
                                      {$IFDEF GENERICS}
                                        IOTADebuggerVisualizer250,
                                      {$ENDIF}
                                        IOTADebuggerVisualizerValueReplacer,
                                        IOTAThreadNotifier,
                                        IOTAThreadNotifier160)
  private
    FCompleted: Boolean;
    FDeferredResult: string;
    FNotifierIndex: Integer;
  public
    constructor Create;
    // IOTADEbuggerVisualizer
    function GetSupportedTypeCount: Integer;
    procedure GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants: Boolean); overload;
    function GetVisualizerIdentifier: string;
    function GetVisualizerName: string;
    function GetVisualizerDescription: string;
    // IOTADEbuggerVisualizer250
    procedure GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants: Boolean; var IsGeneric: Boolean); overload;
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

constructor TDebuggerBigIntegerVisualizer.Create;
begin
  inherited;
  FNotifierIndex := -1;
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

function TDebuggerBigIntegerVisualizer.GetReplacementValue(const Expression,
  TypeName, EvalResult: string): string;
var
  CurProcess: IOTAProcess;
  CurThread: IOTAThread;
  ResultStr: array[0..255] of Char;
  CanModify: Boolean;
  ResultAddr, ResultSize, ResultVal: Longword;
  EvalRes: TOTAEvaluateResult;
  Services: IOTADebuggerServices;
  Done: Boolean;
begin
  Result := EvalResult;
  if Supports(BorlandIDEServices, IOTADebuggerServices, Services) then
    CurProcess := Services.CurrentProcess;
  if (CurProcess <> nil) and (CurProcess.GetProcessType <> optOSX32) then
  begin
    CurThread := CurProcess.CurrentThread;
    if CurThread <> nil then
      repeat
        Done := True;
        EvalRes := CurThread.Evaluate(Expression + '.ToString', @ResultStr,
          Length(ResultStr), CanModify, eseAll, '', ResultAddr, ResultSize,
          ResultVal, '', 0);
        case EvalRes of
          erOK:
            Result := AnsiDequotedStr(ResultStr, '''');
          erDeferred:
            begin
              FCompleted := False;
              FDeferredResult := '';
              FNotifierIndex := CurThread.AddNotifier(Self);
              while not FCompleted do
                Services.ProcessDebugEvents;
              CurThread.RemoveNotifier(FNotifierIndex);
              FNotifierIndex := -1;
              if FDeferredResult <> '' then
                Result := AnsiDequotedStr(FDeferredResult, '''')
              else
                Result := EvalResult;
            end;
          erBusy:
            begin
              Services.ProcessDebugEvents;
              Done := False;
            end;
        end;
      until Done;
  end;
end;

procedure TDebuggerBigIntegerVisualizer.GetSupportedType(Index: Integer; var TypeName: string;
  var AllDescendants: Boolean);
begin
  AllDescendants := False;
  case Index of
    0: TypeName := 'BigInteger';
    1: TypeName := 'BigDecimal';
  else
    TypeName := '';
  end;
end;

{$IFDEF GENERICS}
procedure TDebuggerBigIntegerVisualizer.GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants,
  IsGeneric: Boolean);
begin
  GetSupportedType(Index, TypeName, AllDescendants);
  IsGeneric := False;
end;
{$ENDIF}

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
