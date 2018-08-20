{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.XorShifts.pas                                        }
{ Function:   Simple xorshift random number generators, implementing        }
{             IRandom interface from Velthuis.RandomNumbers.                }
{ Language:   Delphi version XE3 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2018 Rudy Velthuis                                        }
{                                                                           }
{ Literature: https://de.wikipedia.org/wiki/Xorshift                        }
{             https://en.wikipedia.org/wiki/Xorshift                        }
{                                                                           }
{ Acknowledgement:                                                          }
{             Several of the algorithms below were developed by             }
{             Sebastiano Vigna and released to the public domain,           }
{             see http://vigna.di.unimi.it/                                 }
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

unit Velthuis.XorShifts;

interface

uses
  Velthuis.RandomNumbers;

type
  TXorShift32 = class(TRandomBase)
  private
    FSeed: UInt32;
  protected
    function GetSeed: Int64; override;
    function Next(Bits: Integer): UInt32; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create;
  end;

  TXorShift64 = class(TRandomBase64)
  private
    FSeed: UInt64;
  protected
    function GetSeed: Int64; override;
    function Next64(Bits: Integer): UInt64; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create;
  end;

  TXorShift128 = class(TRandomBase)
  private
    FSeed: array[0..3] of UInt32;
    FSeedIndex: Integer;
  protected
    function GetSeed: Int64; override;
    function Next(Bits: Integer): UInt32; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create;
  end;

  TXorWowState = array[0..4] of UInt32;

  TXorWow = class(TRandomBase)
  private
    FSeed: TXorWowState;
    FSeedIndex: Integer;
  protected
    function GetSeed: Int64; override;
    function Next(Bits: Integer): UInt32; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create(const State: TXorWowState);
  end;

  TXorShift64Star = class(TRandomBase64)
  private
    FSeed: UInt64;
  public
    constructor Create(const State: UInt64);
    function GetSeed: Int64; override;
    function Next64(Bits: Integer): UInt64; override;
    procedure SetSeed(Seed: Int64); override;
  end;

  TXorShift1024Star = class(TRandomBase64)
  private
    FSeed: array[0..15] of UInt64;
    FSeedIndex: Integer;
    FNextIndex: Integer;
  protected
    function GetSeed: Int64; override;
    function Next64(Bits: Integer): UInt64; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create(State: array of UInt64);
  end;

  TXorShift128Plus = class(TRandomBase64)
  private
    FSeed: array[0..1] of UInt64;
    FSeedIndex: Integer;
  protected
    function GetSeed: Int64; override;
    function Next64(Bits: Integer): UInt64; override;
    procedure SetSeed(Seed: Int64); override;
  public
    constructor Create(State0, State1: UInt64);
  end;

implementation

uses
  System.Math, Winapi.Windows;

{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}

function SplitMix64(var X: UInt64) : UInt64;
var
  Z: UInt64;
begin
  Inc(X, UInt64($9E3779B97F4A7C15));
  Z := (X xor (X shr 30)) * UInt64($BF58476D1CE4E5B9);
  Z := (Z xor (Z shr 27)) * UInt64($94D049BB133111EB);
  Result := Z xor (Z shr 31);
end;

{ TXorShift32 }

constructor TXorShift32.Create;
var
  C: Int64;
begin
  if QueryPerformanceCounter(C) then
    FSeed := UInt32(C)
  else
    FSeed := GetTickCount;
end;

function TXorShift32.GetSeed: Int64;
begin
  Result := FSeed;
end;

function TXorShift32.Next(Bits: Integer): UInt32;
begin
  FSeed := FSeed xor (FSeed shl 13);
  FSeed := FSeed xor (FSeed shr 17);
  FSeed := FSeed xor (FSeed shl 5);
  Result := FSeed shr (32 - Bits);
end;

procedure TXorShift32.SetSeed(Seed: Int64);
begin
  FSeed := UInt32(Seed);
end;

{ TXorShift64 }

constructor TXorShift64.Create;
var
  C: Int64;
begin
  if QueryPerformanceCounter(C) then
    FSeed := C
  else
    FSeed := 88172645463325252 + GetTickCount;
end;

function TXorShift64.GetSeed: Int64;
begin
  Result := Int64(FSeed);
end;

function TXorShift64.Next64(Bits: Integer): UInt64;
begin
  FSeed := FSeed xor (FSeed shl 13);
  FSeed := FSeed xor (FSeed shr 7);
  FSeed := FSeed xor (FSeed shl 17);
  Result := FSeed shr (64 - Bits);
end;

procedure TXorShift64.SetSeed(Seed: Int64);
begin
  FSeed := UInt64(Seed);
end;

{ TXorShift128 }

constructor TXorShift128.Create;
begin
  FSeed[0] := 123456789;
  FSeed[1] := 362436069;
  FSeed[2] := 521288629;
  FSeed[3] := 88675123;
  FSeedIndex := 0;
end;

function TXorShift128.GetSeed: Int64;
begin
  Result := Int64(FSeed[1]) shl 32 + FSeed[0];
end;

function TXorShift128.Next(Bits: Integer): UInt32;
const
  X = 0;
  y = 1;
  z = 2;
  w = 3;
var
  T: UInt32;
begin
  T := FSeed[x] xor (FSeed[x] shl 11);
  FSeed[x] := FSeed[y];
  FSeed[y] := FSeed[z];
  FSeed[z] := FSeed[w];
  FSeed[w] := FSeed[w] xor ((FSeed[w] shr 19) xor T xor (T shr 8));

  Result := FSeed[w] shr (32 - Bits);
end;

// Call twice to set full seed.
procedure TXorShift128.SetSeed(Seed: Int64);
begin
  FSeed[FSeedIndex] := UInt32(Seed);
  FSeed[FSeedIndex + 1] := UInt32(Seed shr 32);
  FSeedIndex := (FSeedIndex + 2) and 3;
end;

{ TXorWow }

constructor TXorWow.Create(const State: TXorWowState);
begin
  FSeed := State;
  FSeedIndex := 0;
end;

function TXorWow.GetSeed: Int64;
begin
  Result := Int64(FSeed[1]) shr 32 + FSeed[0];
end;

function TXorWow.Next(Bits: Integer): UInt32;
var
  S, T: UInt32;
begin
  T := FSeed[3];
  T := T xor (T shr 2);
  T := T xor (T shl 1);
  FSeed[3] := FSeed[2];
  FSeed[2] := FSeed[1];
  FSeed[1] := FSeed[0];
  S := FSeed[0];
  T := T xor S;
  T := T xor (S shl 4);
  FSeed[0] := T;
  FSeed[4] := FSeed[4] + 362437;
  Result := (T + FSeed[4]) shr (32 - Bits);
end;

// Call thrice to set full seed.
procedure TXorWow.SetSeed(Seed: Int64);
begin
  if FSeedIndex = 4 then
  begin
    FSeed[4] := UInt32(Seed);
    FSeedIndex := 0;
  end
  else
  begin
    FSeed[FSeedIndex] := UInt32(Seed);
    FSeed[FSeedIndex + 1] := UInt32(Seed shr 32);
    FSeedIndex := FSeedIndex + 2;
  end;
end;

{ TXorShift64Star }

constructor TXorShift64Star.Create(const State: UInt64);
begin
  FSeed := State;
end;

function TXorShift64Star.GetSeed: Int64;
begin
  Result := Int64(FSeed);
end;

function TXorShift64Star.Next64(Bits: Integer): UInt64;
var
  X: UInt64;
begin
  X := FSeed;
  X := X xor (X shr 12);
  X := X xor (X shl 25);
  X := X xor (X shr 27);
  FSeed := X;
  Result := (X * UInt64($2545F4914F6CDD1D)) shr (64 - Bits);
end;

procedure TXorShift64Star.SetSeed(Seed: Int64);
begin
  FSeed := UInt64(Seed);
end;

{ TXorShift1024Star }

constructor TXorShift1024Star.Create(State: array of UInt64);
var
  I: Integer;
begin
  for I := 0 to Max(High(State), High(FSeed)) do
    FSeed[I] := State[I];
  FSeedIndex := 0;
  FNextIndex := 0;
end;

function TXorShift1024Star.GetSeed: Int64;
begin
  Result := Int64(FSeed[FSeedIndex]);
end;

function TXorShift1024Star.Next64(Bits: Integer): UInt64;
var
  S0, S1: UInt64;
begin
  S0 := FSeed[FNextIndex];
  FNextIndex := (FNextIndex + 1) and 15;
  S1 := FSeed[FNextIndex];
  S1 := S1 xor (S1 shl 31);
  S1 := S1 xor (S1 shr 11);
  S1 := S1 xor (S0 xor (S0 shr 30));
  FSeed[FNextIndex] := S1;

  Result := (S1 * UInt64(1181783497276652981)) shr (64 - Bits);
end;

procedure TXorShift1024Star.SetSeed(Seed: Int64);
begin
  FSeed[FSeedIndex] := UInt64(Seed);
  FSeedIndex := (FSeedIndex + 1) and 15;
end;

{ TXorShift182Plus }

constructor TXorShift128Plus.Create(State0, State1: UInt64);
begin
  FSeed[0] := State0;
  FSeed[1] := State1;
  FSeedIndex := 0;
end;

function TXorShift128Plus.GetSeed: Int64;
begin
  Result := FSeed[0];
end;

function TXorShift128Plus.Next64(Bits: Integer): UInt64;
var
  X, Y: UInt64;
begin
  X := FSeed[0];
  Y := FSeed[1];
  FSeed[0] := Y;
  X := X xor (X shl 23);
  FSeed[1] := X xor Y xor (X shr 17) xor (Y shr 26);

  Result := (FSeed[1] + Y) shr (64 - Bits);
end;

procedure TXorShift128Plus.SetSeed(Seed: Int64);
begin
  FSeed[FSeedIndex] := Seed;
  FSeedIndex := FSeedIndex xor 1;
end;

end.
