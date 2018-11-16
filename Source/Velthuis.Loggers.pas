{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.Loggers.pas                                          }
{ Function:   Very simple logger type                                       }
{ Language:   Delphi version XE3 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2016 Rudy Velthuis                                        }
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

unit Velthuis.Loggers;

interface

uses
  System.Classes;

type
  ILogger = interface
    ['{B6821CA6-64F8-48B0-89D0-A9A3E6304D82}']
    procedure Log(Msg: string); overload;
    procedure Log(Format: string; Args: array of const); overload;
  end;

  TLogger = class(TInterfacedObject, ILogger)
  private
    FStream: TStream;
    FWriter: TStreamWriter;
  public
    constructor Create(S: TStream); overload;
    constructor Create(LogFileName: string); overload;
    destructor Destroy; override;
    procedure Log(Msg: string); overload;
    procedure Log(Format: string; Args: array of const); overload;
  end;

var
  Logger: TLogger = nil;

implementation

uses
  System.SysUtils;

{ TLogger }

constructor TLogger.Create(S: TStream);
begin
  FStream := S;
  FWriter := TStreamWriter.Create(S);
end;

constructor TLogger.Create(LogFileName: string);
var
  F: TFileStream;
begin
  F := TFileStream.Create(LogFileName, fmCreate);
  Create(F);
end;

destructor TLogger.Destroy;
begin
  FWriter.Free;
  FStream.Free;
end;

procedure TLogger.Log(Msg: string);
begin
  FWriter.WriteLine(Msg);
end;

procedure TLogger.Log(Format: string; Args: array of const);
begin
  FWriter.WriteLine(System.SysUtils.Format(Format, Args));
end;

end.
