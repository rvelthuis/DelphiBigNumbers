{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.Numerics.pas                                         }
{ Function:   Integer tool functions.                                       }
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

unit Velthuis.Numerics;

interface

// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
  {$LEGACYIFEND ON}
{$IFEND}

// For Delphi XE and up:
{$IF CompilerVersion >= 22.0}
  {$CODEALIGN 16}
  {$ALIGN 16}
{$IFEND}

{$INLINE AUTO}

uses
  System.Math;

// Return the number of set (1) bits in the given integers.
function BitCount(U: UInt8): Integer; overload;
function BitCount(U: UInt16): Integer; overload;
function BitCount(S: Int32): Integer; overload;
function BitCount(U: UInt32): Integer; overload;
function BitCount(S: Int64): Integer; overload;
function BitCount(S: UInt64): Integer; overload;

// Return the number of significant bits, excluding the sign bit.
function BitLength(S: Int32): Integer; overload;
function BitLength(U: UInt32): Integer; overload;
function BitLength(S: Int64): Integer; overload;
function BitLength(U: UInt64): Integer; overload;

// Return the number of significant digits.
function DigitCount(S: Int32): Int32; overload;
function DigitCount(U: UInt32): UInt32; overload;

// Return an integer value with at most a single one-bit, in the position
// of the most significant one-bit in the specified integer value.
function HighestOneBit(S: Int32): Int32; overload;
function HighestOneBit(U: UInt32): UInt32; overload;

// Checks if the given integer is a power of two.
function IsPowerOfTwo(S: Int32): Boolean; overload;
function IsPowerOfTwo(U: UInt32): Boolean; overload;

// Return an integer value with at most a single one-bit, in the position
// of the least significant one-bit in the given integers value.
function LowestOneBit(S: Int32): Int32; overload;
function LowestOneBit(U: UInt32): UInt32; overload;

// Return the number of leading (high order) zero-bits (excluding the sign bit) of
// the given integers.
function NumberOfLeadingZeros(U: UInt16): Integer; overload;
function NumberOfLeadingZeros(S: Int32): Integer; overload;
function NumberOfLeadingZeros(U: UInt32): Integer; overload;
function NumberOfLeadingZeros(S: Int64): Integer; overload;
function NumberOfLeadingZeros(U: UInt64): Integer; overload;

// Return the number of trailing (low order) zero-bits of the given integers.
function NumberOfTrailingZeros(U: UInt32): Integer; overload;
function NumberOfTrailingZeros(U: UInt64): Integer; overload;

// Reverse the bits of the given integers.
function Reverse(U: UInt8): UInt8; overload;
function Reverse(U: UInt16): UInt16; overload;
function Reverse(S: Int32): Int32; overload;
function Reverse(U: UInt32): UInt32; overload;

// Reverse the bytes of the given integers.
function ReverseBytes(S: Int32): Int32; overload;
function ReverseBytes(U: UInt32): UInt32; overload;

// Rotate the given integers left by Distance bits.
function RotateLeft(S: Int32; Distance: Integer): Int32; overload;
function RotateLeft(U: UInt32; Distance: Integer): UInt32; overload;

// Rotate the given integers right by Distance bits.
function RotateRight(S: Int32; Distance: Integer): Int32; overload;
function RotateRight(U: UInt32; Distance: Integer): UInt32; overload;

// Returns the sign of the integer: -1 for negative, 0 for zero and 1 for positive.
function Sign(S: Int32): TValueSign;

// Return a binary representation of the given integers.
function ToBinaryString(S: Int32): string; overload;
function ToBinaryString(U: UInt32): string; overload;

// Return a hexadecimal representation of the given integers.
function ToHexString(S: Int32): string; overload;
function ToHexString(U: UInt32): string; overload;

// Return an octal representation of the given integers.
function ToOctalString(S: Int32): string; overload;
function ToOctalString(U: UInt32): string; overload;

// Return a string representation of the given integers, in the given numerical base.
function ToString(S: Int32; Base: Byte): string; overload;
function ToString(U: UInt32; Base: Byte): string; overload;
function ToString(S: Int32): string; overload;
function ToString(U: UInt32): string; overload;

// Compare the given integers and return -1 for less, 0 for equal and 1 for greater.
function Compare(Left, Right: Int32): Integer; overload;
function Compare(Left, Right: UInt32): Integer; overload;
function Compare(Left, Right: Int64): Integer; overload;
function Compare(Left, Right: UInt64): Integer; overload;

// Calculate a hash code for the given integers.
function HashCode(Value: Int32): UInt32; overload;
function HashCode(Value: UInt32): UInt32; overload;
function HashCode(Value: Int64): UInt32; overload;
function HashCode(Value: UInt64): UInt32; overload;

implementation


uses
  System.SysUtils, Velthuis.StrConsts;

// https://en.wikipedia.org/wiki/Find_first_set

const
  // Currently not used.
  NLZDeBruijn32Mult = $07C4ACDD;
  NLZDeBruijn32: array[0..31] of Byte =
  (
    31, 22, 30, 21, 18, 10, 29,  2, 20, 17, 15, 13,  9,  6, 28,  1,
    23, 19, 11,  3, 16, 14,  7, 24, 12,  4,  8, 25,  5, 26, 27,  0
  );

  NTZDeBruijn32Mult = $077CB531;
  NTZDeBruijn32: array[0..31] of Byte =
  (
     0,  1, 28,  2, 29, 14, 24,  3, 30, 22, 20, 15, 25, 17,  4,  8,
    31, 27, 13, 23, 21, 19, 16,  7, 26, 12, 18,  6, 11,  5, 10,  9
  );

  BitCounts: array[0..15] of Byte = (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);

function BitCount(U: UInt8): Integer;
begin
  Result := BitCounts[U and $0F] + BitCounts[U shr 4];
end;

function BitCount(U: UInt16): Integer;
{$IF DEFINED(WIN32)}
asm
        MOV     DX,AX
        SHR     DX,1
        AND     DX,$5555
        SUB     AX,DX
        MOV     DX,AX
        AND     AX,$3333
        SHR     DX,2
        AND     DX,$3333
        ADD     AX,DX
        MOV     DX,AX
        SHR     DX,4
        ADD     AX,DX
        AND     AX,$0F0F
        MOV     DX,AX
        SHR     AX,8
        ADD     AX,DX
        AND     EAX,$7F
end;
{$ELSEIF DEFINED(WIN64)}
asm
        .NOFRAME

        MOV     AX,CX
        SHR     CX,1
        AND     CX,$5555
        SUB     AX,CX
        MOV     CX,AX
        AND     AX,$3333
        SHR     CX,2
        AND     CX,$3333
        ADD     AX,CX
        MOV     CX,AX
        SHR     CX,4
        ADD     AX,CX
        AND     AX,$0F0F
        MOV     CX,AX
        SHR     AX,8
        ADD     AX,CX
        AND     EAX,$7F
end;
{$ELSE PUREPASCAL}
begin
  U := U - ((U shr 1) and $5555);
  U := (U and $3333) + ((U shr 2) and $3333);
  U := (U + (U shr 4)) and $0F0F;
  U := U + (U shr 8);
  Result := U and $7F;
end;
{$IFEND PUREPASCAL}

function BitCount(S: Int32): Integer;
begin
  Result := BitCount(UInt32(S));
end;

// Faster than 16 bit table lookups
function BitCount(U: UInt32): Integer;
{$IF DEFINED(WIN32)}
asm
        MOV     EDX,EAX
        SHR     EDX,1
        AND     EDX,$55555555
        SUB     EAX,EDX
        MOV     EDX,EAX
        AND     EAX,$33333333
        SHR     EDX,2
        AND     EDX,$33333333
        ADD     EAX,EDX
        MOV     EDX,EAX
        SHR     EDX,4
        ADD     EAX,EDX
        AND     EAX,$0F0F0F0F
        MOV     EDX,EAX
        SHR     EAX,8
        ADD     EAX,EDX
        MOV     EDX,EAX
        SHR     EDX,16
        ADD     EAX,EDX
        AND     EAX,$7F
end;
{$ELSEIF DEFINED(WIN64)}
asm
        .NOFRAME

        MOV     EAX,ECX
        SHR     ECX,1
        AND     ECX,$55555555
        SUB     EAX,ECX
        MOV     ECX,EAX
        AND     EAX,$33333333
        SHR     ECX,2
        AND     ECX,$33333333
        ADD     EAX,ECX
        MOV     ECX,EAX
        SHR     ECX,4
        ADD     EAX,ECX
        AND     EAX,$0F0F0F0F
        MOV     ECX,EAX
        SHR     EAX,8
        ADD     EAX,ECX
        MOV     ECX,EAX
        SHR     ECX,16
        ADD     EAX,ECX
        AND     EAX,$7F
end;
{$ELSE PUREPASCAL}
begin
  U := U - ((U shr 1) and $55555555);
  U := (U and $33333333) + ((U shr 2) and $33333333);
  U := (U + (U shr 4)) and $0F0F0F0F;
  U := U + (U shr 8);
  U := U + (U shr 16);
  Result := U and $7F;
end;
{$IFEND PUREPASCAL}

function BitCount(S: Int64): Integer; overload;
begin
  Result := BitCount(UInt32(S)) + BitCount(Int32(S shr 32));
end;

function BitCount(S: UInt64): Integer; overload;
begin
  Result := BitCount(UInt32(S)) + BitCount(UInt32(S shr 32));
end;

function BitLength(S: Int32): Integer;
begin
  Result := BitLength(UInt32(S));
end;

function BitLength(U: UInt32): Integer;
begin
  Result := 32 - NumberOfLeadingZeros(U);
end;

function BitLength(S: Int64): Integer;
begin
  Result := 64 - NumberOfLeadingZeros(S);
end;

function BitLength(U: UInt64): Integer;
begin
  Result := 64 - NumberOfLeadingZeros(U);
end;

function DigitCount(S: Int32): Int32; overload;
begin
  if S <> Low(Int32) then
    Result := DigitCount(UInt32(Abs(S)))
  else
    Result := 9;
end;

function DigitCount(U: UInt32): UInt32; overload;
begin
  Result := 1;
  if U >= 100000000 then
  begin
    Inc(Result, 8);
    U := U div 100000000;
  end;
  if U >= 10000 then
  begin
    Inc(Result, 4);
    U := U div 10000;
  end;
  if U >= 100  then
  begin
    Inc(Result, 2);
    U := U div 100;
  end;
  if U >= 10 then
    Inc(Result);
end;

function IsPowerOfTwo(S: Int32): Boolean;
begin
  if S <> Low(Int32) then
    Result := IsPowerofTwo(UInt32(Abs(S)))
  else
    Result := True;
end;

function IsPowerOfTwo(U: UInt32): Boolean;
begin
  Result := (U and (U - 1)) = 0;
end;

function HighestOneBit(S: Int32): Int32;
begin
  Result := Int32(HighestOneBit(UInt32(S)));
end;

function HighestOneBit(U: UInt32): UInt32;
begin
  if U = 0 then
    Result := 0
  else
    Result := UInt32(1) shl (31 - NumberOfLeadingZeros(U));
end;

function LowestOneBit(S: Int32): Int32;
begin
  Result := Int32(LowestOneBit(UInt32(S)));
end;

function LowestOneBit(U: UInt32): UInt32;
begin
  Result := U and -Int32(U);
end;

function NumberOfLeadingZeros(U: UInt16): Integer;
{$IF DEFINED(WIN32)}
asm
        MOVZX   EAX,AX
        BSR     EDX,EAX
        JNZ     @Invert
        MOV     EAX,16
        RET

@Invert:

        MOV     EAX,15
        SUB     EAX,EDX
end;
{$ELSEIF DEFINED(WIN64)}
asm
        .NOFRAME

        MOVZX   EAX,CX
        BSR     ECX,EAX
        JNZ     @Invert
        MOV     EAX,16
        RET

@Invert:

        MOV     EAX,15
        SUB     EAX,ECX
end;
{$ELSE PUREPASCAL}
begin
  if U = 0 then
    Result := 16
  else
  begin
    Result := 0;
    if U <= High(Word) shr 8 then
    begin
      Result := Result + 8;
      U := U shl 8;
    end;
    if U <= High(Word) shr 4 then
    begin
      Result := Result + 4;
      U := U shl 4;
    end;
    if U <= High(Word) shr 2 then
    begin
      Result := Result + 2;
      U := U shl 2;
    end;
    if U <= High(Word) shr 1 then
      Result := Result + 1;
  end;
end;
{$IFEND PUREPASCAL}

function NumberOfLeadingZeros(S: Int32): Integer;
begin
  Result := NumberOfLeadingZeros(UInt32(Abs(S)));
end;

function NumberOfLeadingZeros(U: UInt32): Integer;
{$IF DEFINED(WIN32)}
asm
        BSR     EDX,EAX
        JNZ     @Invert
        MOV     EAX,32
        RET

@Invert:

        MOV     EAX,31
        SUB     EAX,EDX

@Exit:
end;
{$ELSEIF DEFINED(WIN64)}
asm
         .NOFRAME

         BSR    EDX,ECX
         JNZ    @Invert
         MOV    EAX,32
         RET

@Invert:

         MOV    EAX,31
         SUB    EAX,EDX

@Exit:
end;
{$ELSE PUREPASCAL}

// Faster than X := X or X shr 1..16; Result := NLZDeBruijn32[...];

begin
  if U = 0 then
    Result := 32
  else
  begin
    Result := 0;
    if U <= High(Cardinal) shr 16 then
    begin
      Result := Result + 16;
      U := U shl 16;
    end;
    if U <= High(Cardinal) shr 8 then
    begin
      Result := Result + 8;
      U := U shl 8;
    end;
    if U <= High(Cardinal) shr 4 then
    begin
      Result := Result + 4;
      U := U shl 4;
    end;
    if U <= High(Cardinal) shr 2 then
    begin
      Result := Result + 2;
      U := U shl 2;
    end;
    if U <= High(Cardinal) shr 1 then
      Result := Result + 1;
  end;
end;
{$IFEND PUREPASCAL}

function NumberOfLeadingZeros(S: Int64): Integer;
begin
  Result := NumberOfLeadingZeros(UInt64(Abs(S)));
end;

function NumberOfLeadingZeros(U: UInt64): Integer;
begin
  if U = 0 then
    Exit(1);
  if U <= High(UInt32) then
    Result := NumberOfLeadingZeros(UInt32(U)) + 32
  else
    Result := NumberOfLeadingZeros(UInt32(U shr 32));
end;

// Faster than NumberOfTrailingZeros2().
function NumberOfTrailingZeros(U: UInt32): Integer;
{$IF DEFINED(WIN32)}
asm
        BSF     EAX,EAX
        JNZ     @Exit
        MOV     EAX,32

@Exit:
end;
{$ELSEIF DEFINED(WIN64)}
asm
        .NOFRAME

        BSF     EAX,ECX
        JNZ     @Exit
        MOV     EAX,32

@Exit:
end;
{$ELSE PUREPASCAL}
begin
  if U = 0 then
    Result := 32
  else
    Result := NTZDeBruijn32[((U and (-Integer(U))) * NTZDeBruijn32Mult) shr 27];
end;
{$IFEND PUREPASCAL}

function NumberOfTrailingZeros(U: UInt64): Integer;
{$IF DEFINED(WIN32)}
asm
        BSF    EAX,DWORD PTR [U]
        JNZ    @Exit
        BSF    EAX,DWORD PTR [U+TYPE DWORD]
        JZ     @Ret64
        ADD    EAX,32
        JMP    @Exit
@Ret64:
        MOV    EAX,64
@Exit:
end;
{$ELSEIF DEFINED(WIN64)}
asm
        .NOFRAME

        BSF    RAX,RCX
        JNZ    @Exit
        MOV    EAX,64
@Exit:
end;
{$ELSE PUREPASCAL}
type
  TUInt64 = packed record
    Lo, Hi: UInt32;
  end;
begin
  if UInt32(U) = 0 then
    Result := 32 + NumberOfTrailingZeros(TUInt64(U).Hi)
  else
    Result := NumberOfTrailingZeros(UInt32(U));
end;
{$IFEND PUREPASCAL}

function Reverse(U: UInt8): UInt8;
begin
  U := ((U shr 1) and $55) or ((U and $55) shl 1);
  U := ((U shr 2) and $33) or ((U and $33) shl 2);
  U := (U shr 4) or (U shl 4);
  Result := U;
end;

function Reverse(U: UInt16): UInt16;
begin
  U := ((U shr 1) and $5555) or ((U and $5555) shl 1);
  U := ((U shr 2) and $3333) or ((U and $3333) shl 2);
  U := ((U shr 4) and $0F0F) or ((U and $0F0F) shl 4);
  U := Swap(U);
  Result := U;
end;

function Reverse(S: Int32): Int32;
begin
  Result := Int32(Reverse(UInt32(S)));
end;

// See http://stackoverflow.com/questions/746171/best-algorithm-for-bit-reversal-from-msb-lsb-to-lsb-msb-in-c too.
// http://stackoverflow.com/a/9144870/95954
function Reverse(U: UInt32): UInt32;
begin
  U := ((U shr 1) and $55555555) or ((U and $55555555) shl 1);  // Swap adjacent bits.
  U := ((U shr 2) and $33333333) or ((U and $33333333) shl 2);  // Swap adjacent bit pairs.
  U := ((U shr 4) and $0F0F0F0F) or ((U and $0F0F0F0F) shl 4);  // Swap nibbles.
  U := ((U shr 8) and $00FF00FF) or ((U and $00FF00FF) shl 8);  // Swap bytes.
  U := (U shr 16) or (U shl 16);                                // Swap words.
  Result := U;
end;

function ReverseBytes(S: Int32): Int32;
begin
  Result := Int32(ReverseBytes(UInt32(S)));
end;

// Byte and word swaps of Reverse(U).
function ReverseBytes(U: UInt32): UInt32;
begin
  U := ((U shr 8) and $00FF00FF) or ((U and $00FF00FF) shl 8);  // Swap bytes.
  U := (U shr 16) or (U shl 16);                                // Swap words.
  Result := U;
end;

function RotateLeft(S: Int32; Distance: Integer): Int32;
begin
  Result := Int32(RotateLeft(UInt32(S), Distance));
end;

function RotateLeft(U: UInt32; Distance: Integer): UInt32;
begin
  Distance := Distance and 31;
  Result := (U shl Distance) or (U shr (32 - Distance));
end;

function RotateRight(S: Int32; Distance: Integer): Int32;
begin
  Result := Int32(RotateRight(UInt32(S), Distance));
end;

function RotateRight(U: UInt32; Distance: Integer): UInt32;
begin
  Distance := Distance and 31;
  Result := (U shr Distance) or (U shl (32- Distance));
end;

function Sign(S: Int32): TValueSign;
begin
  Result := System.Math.Sign(S);
end;

function ToBinaryString(S: Int32): string;
begin
  Result := ToString(S, 2);
end;

function ToBinaryString(U: UInt32): string;
begin
  Result := ToString(U, 2);
end;

function ToHexString(S: Int32): string;
begin
  Result := ToString(S, 16);
end;

function ToHexString(U: UInt32): string;
begin
  Result := ToString(U, 16);
end;

function ToOctalString(S: Int32): string;
begin
  Result := ToString(S, 8);
end;

function ToOctalString(U: UInt32): string;
begin
  Result := ToString(U, 8);
end;

const
  Digits: array[0..35] of Char = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function ToString(S: Int32; Base: Byte): string;
begin
  if S < 0 then
    Result := '-' + ToString(UInt32(Abs(S)), Base)
  else
    Result := ToString(UInt32(S), Base);
end;

function ToString(U: UInt32; Base: Byte): string;
begin
  if not (Base in [2..36]) then
    raise EInvalidArgument.Create(SInvalidArgumentBase);

  if U = 0 then
    Result := '0'
  else
  begin
    Result := '';
    while U > 0 do
    begin
      Result := Digits[U mod Base] + Result;
      U := U div Base;
    end;
  end;
end;

function ToString(S: Int32): string;
begin
  Result := ToString(S, 10);
end;

function ToString(U: UInt32): string;
begin
  Result := ToString(U, 10);
end;

function Compare(Left, Right: Int32): Integer;
begin
  if Left > Right then
    Exit(1)
  else if Left < Right then
    Exit(-1)
  else
    Exit(0);
end;

function Compare(Left, Right: UInt32): Integer;
begin
  if Left > Right then
    Exit(1)
  else if Left < Right then
    Exit(-1)
  else
    Exit(0);
end;

function Compare(Left, Right: Int64): Integer;
begin
  if Left > Right then
    Exit(1)
  else if Left < Right then
    Exit(-1)
  else
    Exit(0);
end;

function Compare(Left, Right: UInt64): Integer;
begin
  if Left > Right then
    Exit(1)
  else if Left < Right then
    Exit(-1)
  else
    Exit(0);
end;

function HashCode(Value: Int32): UInt32;
begin
  Result := UInt32(Value);
end;

function HashCode(Value: UInt32): UInt32;
begin
  Result := Value;
end;

function HashCode(Value: Int64): UInt32;
begin
  Result := UInt32(Value) xor UInt32(Value shr 32);
end;

function HashCode(Value: UInt64): UInt32;
begin
  Result := UInt32(Value) xor UInt32(Value shr 32);
end;

end.
