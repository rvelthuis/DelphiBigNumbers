{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.RandomNumbers.pas                                    }
{ Function:   Simple random number generators.                              }
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

unit Velthuis.RandomNumbers;

// TODO: streamline this.
// TODO: better random number algorithms

interface

type
  IRandom = interface
    function NextInteger: Integer; overload;
    function NextInteger(MaxValue: Integer): Integer; overload;
    function NextInteger(MinValue, MaxValue: Integer): Integer; overload;
    function NextDouble: Double;
    function NextInt64: Int64;
    procedure NextBytes(var Bytes: array of Byte);
    procedure SetSeed(Seed: Int64);
    function GetSeed: Int64;
    property Seed: Int64 read GetSeed write SetSeed;
  end;

  /// <summary>Base for 32 bit random number generators implementing IRandom</summary>
  TRandomBase = class(TInterfacedObject, IRandom)
  protected
    // Abstract. Must be overridden.
    function Next(Bits: Integer): UInt32; virtual; abstract;
    procedure SetSeed(ASeed: Int64); virtual; abstract;
    function GetSeed: Int64; virtual; abstract;
  public
    // Generates exception.
    constructor Create;

    // default implementations.
    function NextInteger: Integer; overload;
    function NextInteger(MaxValue: Integer): Integer; overload;
    function NextInteger(MinValue, MaxValue: Integer): Integer; overload;
    procedure NextBytes(var Bytes: array of Byte);
    function NextDouble: Double;
    function NextInt64: Int64;
  end;

  /// <summary>Base for 64 bit random number generators implementing IRandom</summary>
  TRandomBase64 = class(TRandomBase, IRandom)
  protected
    function Next64(Bits: Integer): UInt64; virtual; abstract;
    function Next(Bits: Integer): UInt32; override;
  public
    procedure NextBytes(var Bytes: array of Byte);
    function NextDouble: Double;
    function NextInt64: Int64;
  end;

  TRandom = class(TRandomBase, IRandom)
  private
    FSeed: Int64;       // Only 48 bits are used.
  protected
    function Next(Bits: Integer): UInt32; override;
    procedure SetSeed(ASeed: Int64); override;
    function GetSeed: Int64; override;
  public
    constructor Create(Seed: Int64 = 0);
  end;

  TDelphiRandom = class(TRandomBase, IRandom)
  protected
    function Next(Bits: Integer): UInt32; override;
    procedure SetSeed(ASeed: Int64); override;
    function GetSeed: Int64; override;
  public
    constructor Create; overload;
    constructor Create(Seed: Int64); overload;
  end;

implementation

uses
  System.SysUtils, Velthuis.Numerics;

{ TRandom }

const
  CMultiplier = Int64(6364136223846793005);
  CIncrement  = Int64(1442695040888963407);
  CSeedSize   = 64 div 8;

constructor TRandom.Create(Seed: Int64);
begin
  FSeed := Seed;
end;

function TRandom.Next(Bits: Integer): UInt32;
begin
{$IFOPT Q+}
{$DEFINE HasRangeChecks}
{$ENDIF}
  FSeed := (FSeed * CMultiplier + CIncrement);
  Result := UInt32(FSeed shr (64 - Bits)); // Use the highest bits; Lower bits have lower period.
{$IFDEF HasRangeChecks}
{$RANGECHECKS ON}
{$ENDIF}
end;

function TRandom.GetSeed: Int64;
begin
  Result := FSeed;
end;

procedure TRandom.SetSeed(ASeed: Int64);
begin
  FSeed := ASeed;
end;

{ TDelphiRandom }

constructor TDelphiRandom.Create(Seed: Int64);
begin
  System.RandSeed := Integer(Seed);
end;

constructor TDelphiRandom.Create;
begin
  Randomize;
end;

function TDelphiRandom.GetSeed: Int64;
begin
  Result := System.RandSeed;
end;

function TDelphiRandom.Next(Bits: Integer): UInt32;
begin
  Result := UInt32(System.RandSeed) shr (32 - Bits);
  System.Random;
end;

procedure TDelphiRandom.SetSeed(ASeed: Int64);
begin
  System.RandSeed := Integer(ASeed);
end;

{ TRandomBase }

constructor TRandomBase.Create;
begin
  raise EArgumentException.Create('Seed needs initialization');
end;

procedure TRandomBase.NextBytes(var Bytes: array of Byte);
var
  Head, Tail: Integer;
  N, Rnd, I: Integer;
begin
  Head := Length(Bytes) div SizeOf(Int32);
  Tail := Length(Bytes) mod SizeOf(Int32);
  N := 0;
  for I := 1 to Head do
  begin
    Rnd := Next(32);
    Bytes[N] := Byte(Rnd);
    Bytes[N + 1] := Byte(Rnd shr 8);
    Bytes[N + 2] := Byte(Rnd shr 16);
    Bytes[N + 3] := Byte(Rnd shr 24);
    Inc(N, 4);
  end;
  Rnd := Next(32);
  for I := 1 to Tail do
  begin
    Bytes[N] := Byte(Rnd);
    Rnd := Rnd shr 8;
    Inc(N);
  end;
end;

function TRandomBase.NextDouble: Double;
const
  Divisor = UInt64(1) shl 53;
begin
  Result := (UInt64(Next(26) shl 27) + Next(27)) / Divisor;
end;

function TRandomBase.NextInteger: Integer;
begin
  Result := Next(32);
end;

function TRandomBase.NextInt64: Int64;
begin
  Result := Int64(Next(32)) shl 32 + Next(32);
end;

function TRandomBase.NextInteger(MinValue, MaxValue: Integer): Integer;
begin
  if MinValue < 0 then
    raise EArgumentException.Create('MinValue must be positive or 0');
  Result := MinValue + NextInteger(MaxValue - MinValue);
end;

function TRandomBase.NextInteger(MaxValue: Integer): Integer;
var
  Bits: Integer;
begin
  if MaxValue = 0 then
    raise EArgumentException.Create('MaxValue not be 0');

  if IsPowerOfTwo(MaxValue) then
  begin
    Bits := Next(31);
    Exit((Int64(MaxValue) * Bits) shr 31);
  end;

  repeat
    Bits := Next(31);
    Result := Bits mod MaxValue;
  until (Bits - Result + (MaxValue - 1) >= 0);
end;

{ TRandomBase64 }

function TRandomBase64.Next(Bits: Integer): UInt32;
begin
  Result := Next64(Bits + 32) shr 32;
end;

procedure TRandomBase64.NextBytes(var Bytes: array of Byte);
var
  Head, Tail: Integer;
  N, I: Integer;
  Rnd: UInt64;
begin
  Head := Length(Bytes) div SizeOf(UInt64);
  Tail := Length(Bytes) mod SizeOf(UInt64);
  N := 0;
  for I := 1 to Head do
  begin
    Rnd := Next64(64);
    Bytes[N] := Byte(Rnd);
    Bytes[N + 1] := Byte(Rnd shr 8);
    Bytes[N + 2] := Byte(Rnd shr 16);
    Bytes[N + 3] := Byte(Rnd shr 24);
    Bytes[N + 4] := Byte(Rnd shr 32);
    Bytes[N + 5] := Byte(Rnd shr 40);
    Bytes[N + 6] := Byte(Rnd shr 48);
    Bytes[N + 7] := Byte(Rnd shr 56);
    Inc(N, 8);
  end;
  Rnd := Next64(64);
  for I := 1 to Tail do
  begin
    Bytes[N] := Byte(Rnd);
    Rnd := Rnd shr 8;
    Inc(N);
  end;
end;

function TRandomBase64.NextDouble: Double;
const
  Divisor = UInt64(1) shl 53;
begin
  Result := Next64(53) / Divisor;
end;

function TRandomBase64.NextInt64: Int64;
begin
  Result := Int64(Next64(64));
end;

end.




