{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.FloatUtils.pas                                       }
{ Function:   Routines to extract or set the internals of Delphi's floating }
{             point types Single, Double and Extended.                      }
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

unit Velthuis.FloatUtils;

interface

uses
  System.Math;

function IsNegativeInfinity(const AValue: Single): Boolean; overload;
function IsNegativeInfinity(const AValue: Double): Boolean; overload;
function IsNegativeInfinity(const AValue: Extended): Boolean; overload;

function IsPositiveInfinity(const AValue: Single): Boolean; overload;
function IsPositiveInfinity(const AValue: Double): Boolean; overload;
function IsPositiveInfinity(const AValue: Extended): Boolean; overload;

function GetMantissa(const AValue: Single): UInt32; overload;
function GetMantissa(const AValue: Double): UInt64; overload;
function GetMantissa(const AValue: Extended): UInt64; overload;

function GetExponent(const AValue: Single): Integer; overload;
function GetExponent(const AValue: Double): Integer; overload;
function GetExponent(const AValue: Extended): Integer; overload;

function IsDenormal(const AValue: Single): Boolean; overload;
function IsDenormal(const AValue: Double): Boolean; overload;
function IsDenormal(const AValue: Extended): Boolean; overload;

function MakeSingle(Sign: TValueSign; Mantissa: UInt32; Exponent: Integer): Single;
function MakeDouble(Sign: TValueSign; Mantissa: UInt64; Exponent: Integer): Double;
function MakeExtended(Sign: TValueSign; Mantissa: UInt64; Exponent: Integer): Extended;

type
  PUInt8  = ^UInt8;
  PUInt16 = ^UInt16;
  PUInt32 = ^UInt32;
  PUInt64 = ^UInt64;

  PExt80Rec = ^TExt80Rec;
  TExt80Rec = packed record
    Mantissa: UInt64;
    ExponentAndSign: Word;
  end;

const
  CSingleExponentShift  = 23;
  CDoubleExponentShift  = 52;
  CSingleExponentMask   = $FF;
  CDoubleExponentMask   = $7FF;
  CExtendedExponentMask = $7FFF;
  CSingleBias           = CSingleExponentMask shr 1;
  CDoubleBias           = CDoubleExponentMask shr 1;
  CExtendedBias         = CExtendedExponentMask shr 1;
  CSingleMantissaMask   = UInt32(1) shl CSingleExponentShift - 1;
  CDoubleMantissaMask   = UInt64(1) shl CDoubleExponentShift - 1;
  CSingleSignMask       = UInt32(1) shl 31;
  CDoubleSignMask       = UInt64(1) shl 63;

implementation

uses
  System.SysUtils;
//{$IF NOT DECLARED(TSingleHelper)}
  {$DEFINE NORECORDHELPERS}
//{$IFEND}

{$IF CompilerVersion >= 24.0}
  {$LEGACYIFEND ON}
{$IFEND}

{$POINTERMATH ON}

{$IFDEF NORECORDHELPERS}
function GetPlainMantissa(const AValue: Single): UInt32; overload;
begin
  Result := PUInt32(@AValue)^ and CSingleMantissaMask;
end;

function GetPlainMantissa(const AValue: Double): UInt64; overload;
begin
  Result := PUInt64(@AValue)^ and CDoubleMantissaMask;
end;

function GetPlainExp(const AValue: Single): Integer; overload;
begin
  Result := PUInt32(@AValue)^ shr CSingleExponentShift and CSingleExponentMask;
end;

function GetPlainExp(const AValue: Double): Integer; overload;
begin
  Result := PUInt16(@AValue)[3] shr 4 and CDoubleExponentMask;
//  Result := PUInt64(@AValue)^ shr CDoubleExponentShift and CDoubleExponentMask;
end;

function GetPlainExp(const AValue: Extended): Integer; overload;
begin
  Result := PUInt16(@AValue)[4] and CExtendedExponentMask;
end;
{$ENDIF}

function IsNegativeInfinity(const AValue: Single): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (System.Math.Sign(AValue) < 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function IsNegativeInfinity(const AValue: Double): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (Sign(AValue) < 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function IsNegativeInfinity(const AValue: Extended): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (Sign(AValue) < 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function IsPositiveInfinity(const AValue: Single): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (Sign(AValue) > 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function IsPositiveInfinity(const AValue: Double): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (Sign(AValue) > 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function IsPositiveInfinity(const AValue: Extended): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := System.Math.IsInfinite(AValue) and (Sign(AValue) > 0);
{$ELSE}
  Result := AValue.IsNegativeInfinity;
{$ENDIF}
end;

function GetMantissa(const AValue: Single): UInt32; overload;
{$IFDEF NORECORDHELPERS}
var
  E: Integer;
begin
  E := GetPlainExp(AValue);
  Result := GetPlainMantissa(AValue);
  if (0 < E) and (E < CSingleExponentMask) then
    Result := Result or (UInt32(1) shl CSingleExponentShift);
end;
{$ELSE}
begin
  Result := AValue.Mantissa;
end;
{$ENDIF}

function GetMantissa(const AValue: Double): UInt64; overload;
{$IFDEF NORECORDHELPERS}
var
  E: Integer;
begin
  E := GetPlainExp(AValue);
  Result := GetPlainMantissa(AValue);
  if (0 < E) and (E < CDoubleExponentMask) then
    Result := Result or ((UInt64(1) shl CDoubleExponentShift));
end;
{$ELSE}
begin
  Result := AValue.Mantissa;
end;
{$ENDIF}

function GetMantissa(const AValue: Extended): UInt64; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := PUInt64(@AValue)^;
{$ELSE}
  Result := AValue.Mantissa;
{$ENDIF}
end;

function GetExponent(const AValue: Single): Integer; overload;
{$IFDEF NORECORDHELPERS}
var
  M, E: UInt32;
begin
  M := GetPlainMantissa(AValue);
  E := GetPlainExp(AValue);
  if (0 < E) and (E < CSingleExponentMask) then
    Result := E - CSingleBias
  else if E = 0 then
    if M = 0 then
      // +/- Zero
      Result := 0
    else
      // Denormal
      Result := 1 - CSingleBias
  else
    // NaN or +/-Infinity
    Result := 0;
end;
{$ELSE}
begin
  Result := AValue.Exponent;
end;
{$ENDIF}

function GetExponent(const AValue: Double): Integer; overload;
{$IFDEF NORECORDHELPERS}
var
  M: UInt64;
  E: UInt32;
begin
  M := GetPlainMantissa(AValue);
  E := GetPlainExp(AValue);
  if (0 < E) and (E < CDoubleExponentMask) then
    Result := E - CDoubleBias
  else if E = 0 then
    if M = 0 then
      // +/-Zero
      Result := 0
    else
      // Denormal
      Result := 1 - CDoubleBias
  else
    // NaN or +/-Infinity
    Result := 0;
end;
{$ELSE}
begin
  Result := AValue.Exponent;
end;
{$ENDIF}

function GetExponent(const AValue: Extended): Integer; overload;
{$IFDEF NORECORDHELPERS}
var
  M: UInt64;
  E: UInt32;
begin
  M := PUInt64(@AValue)^;
  E := GetPlainExp(AValue);
  if (0 < E) and (E < CExtendedExponentMask) then
    Result := E - CExtendedBias
  else if E = 0 then
    if M = 0 then
      // +/- Zero
      Result := 0
    else
      // Denormal
      Result := 1 - CExtendedBias
  else
    // NaN or +/-Infinity
    Result := 0;
end;
{$ELSE}
begin
  Result := AValue.Exponent;
end;
{$ENDIF}

function IsDenormal(const AValue: Single): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := ((PUInt32(@AValue)^ shr CSingleExponentShift and CSingleExponentMask) = 0) and (GetMantissa(AValue) <> 0);
{$ELSE}
  Result := AValue.SpecialType in [fsDenormal, fsNDenormal];
{$ENDIF}
end;

function IsDenormal(const AValue: Double): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := ((PUInt64(@AValue)^ shr 52) = 0) and (GetMantissa(AValue) <> 0);
{$ELSE}
  Result := AValue.SpecialType in [fsDenormal, fsNDenormal];
{$ENDIF}
end;

function IsDenormal(const AValue: Extended): Boolean; overload;
begin
{$IFDEF NORECORDHELPERS}
  Result := ((PUInt16(@AValue)[4] and $7FFF) = 0) and (GetMantissa(AValue) <> 0);
{$ELSE}
  Result := AValue.SpecialType in [fsDenormal, fsNDenormal];
{$ENDIF}
end;

function MakeSingle(Sign: TValueSign; Mantissa: UInt32; Exponent: Integer): Single;
{$IFDEF NORECORDHELPERS}
var
  U: UInt32;
begin
  U := (Sign and CSingleSignMask) or
       ((UInt32(Exponent + CSingleBias) and CSingleExponentMask) shl CSingleExponentShift) or
       (Mantissa and CSingleMantissaMask);
  PUInt32(@Result)^ := U;
end;
{$ELSE}
begin
  Result.BuildUp(Sign < 0, Mantissa, Exponent);
end;
{$ENDIF}

function MakeDouble(Sign: TValueSign; Mantissa: UInt64; Exponent: Integer): Double;
{$IFDEF NORECORDHELPERS}
var
  U: UInt64;
begin
  U := UInt64(Int64(Sign) and CDoubleSignMask) or
       (UInt64((Exponent + CDoubleBias) and CDoubleExponentMask) shl CDoubleExponentShift) or
       (Mantissa and CDoubleMantissaMask);
  PUInt64(@Result)^ := U;
end;
{$ELSE}
begin
  Result.BuildUp(Sign < 0, Mantissa, Exponent);
end;
{$ENDIF}

function MakeExtended(Sign: TValueSign; Mantissa: UInt64; Exponent: Integer): Extended;
{$IFDEF NORECORDHELPERS}
var
  E: TExt80Rec;
begin
  E.Mantissa := Mantissa;
  E.ExponentAndSign := (Sign and $8000) or ((Exponent + CExtendedBias) and CExtendedExponentMask);
  PExt80Rec(@Result)^ := E;
end;
{$ELSE}
begin
  Result.BuildUp(Sign < 0, Mantissa, Exponent);
end;
{$ENDIF}

end.

