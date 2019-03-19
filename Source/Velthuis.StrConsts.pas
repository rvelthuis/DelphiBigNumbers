{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.StrConsts.pas                                        }
{ Function:   Constants for error messages for BigNumbers.                  }
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

unit Velthuis.StrConsts;

interface

resourcestring
  SErrorParsingFmt         = '''%s'' is not a valid %s value';
  SDivisionByZero          = 'Division by zero';
  SOverflow                = 'Resulting value too big to represent';
  SOverflowFmt             = '%s: Resulting value too big to represent';
  SInvalidOperation        = 'Invalid operation';
  SConversionFailedFmt     = '%s value too large for conversion to %s';
  SInvalidArgumentFloatFmt = '%s parameter may not be NaN or +/- Infinity';
  SInvalidArgumentBase     = 'Base parameter must be in the range 2..36';
  SInvalidArgumentFmt      = 'Invalid argument: %s';
  SOverflowInteger  = 'Value %g cannot be converted to an integer ratio';
  SNegativeRadicand        = '%s: Negative radicand not allowed';
  SNoInverse               = 'No modular inverse possible';
  SNegativeExponent        = 'Negative exponent %s not allowed';
  SUnderflow               = 'Resulting value too small to represent';
  SRounding                = 'Rounding necessary';
  SExponent                = 'Exponent to IntPower outside the allowed range';
  SZeroDenominator         = 'BigRational denominator cannot be zero';

implementation

end.

