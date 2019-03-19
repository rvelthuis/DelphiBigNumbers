{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.Sizes.pas                                            }
{ Function:   Constants for sizes and bit sizes of Delphi's integral types. }
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

unit Velthuis.Sizes;

interface

const
  CUInt8Bits    = 8;
  CInt8Bits     = CUInt8Bits - 1;
  CUInt16Bits   = 16;
  CInt16Bits    = CUInt16Bits - 1;
  CUInt32Bits   = 32;
  CInt32Bits    = CUInt32Bits - 1;
  CUInt64Bits   = 64;
  CInt64Bits    = CUInt64Bits - 1;
  CByteBits     = CUInt8Bits;
  CShortintBits = CByteBits - 1;
  CWordBits     = CByteBits * SizeOf(Word);
  CSmallintBits = CWordBits - 1;

  // Note: up to XE8, Longword and Longint were fixed sizes (32 bit). This has changed in XE8.
  CLongwordBits = CByteBits * SizeOf(Longword);
  CLongintBits  = CLongwordBits - 1;

  // Note: up to XE8, Integer and Cardinal were platform dependent. This has changed in XE8.
  CCardinalBits = CByteBits * SizeOf(Cardinal);
  CIntegerBits  = CCardinalBits - 1;

implementation

end.





