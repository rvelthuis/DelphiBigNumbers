{---------------------------------------------------------------------------}
{                                                                           }
{ File:       Velthuis.BigIntegers.Primes.pas                               }
{ Function:   Prime functions for BigIntegers                               }
{ Language:   Delphi version XE2 or later                                   }
{ Author:     Rudy Velthuis                                                 }
{ Copyright:  (c) 2017 Rudy Velthuis                                        }
{ Notes:      See http://rvelthuis.de/programs/bigintegers.html             }
{             See https://github.com/rvelthuis/BigNumbers                   }
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

unit Velthuis.BigIntegers.Primes;

interface

uses
  Velthuis.BigIntegers;

type
  /// <summary>Type indicating primality of a number.</summary>
  TPrimality = (
    /// <summary>Number is definitely composite.</summary>
    primComposite,
    /// <summary>Number is probably prime.</summary>
    primProbablyPrime,
    /// <summary>Number is definitely prime.</summary>
    primPrime
  );

/// <summary>Detects if N is probably prime according to a Miller-Rabin test.</summary>
/// <param name="N">The number to be tested</param>
/// <param name="Precision">Determines the probability of the test, which is 1.0 - 0.25^Precision</param>
/// <returns>True if N is prime with the given precision, False if N is definitely composite.</returns>
function IsProbablePrime(const N: BigInteger; Precision: Integer): Boolean;

/// <summary>Detects if N is prime, probably prime or composite. Deterministically correct for N &lt; 341,550,071,728,321, otherwise
///  with a probability determined by the Precision parameter</summary>
/// <param name="N">The number to be tested</param>
/// <param name="Precision">For values >= 341,550,071,728,321, IsProbablyPrime(N, Precision) is called</param>
/// <returns>Returns primComposite if N is definitely composite, primProbablyPrime if N is probably prime and
///  primPrime if N is definitely prime.</returns>
function IsPrime(const N: BigInteger; Precision: Integer): TPrimality;

/// <summary>Returns a random probably prime number.</summary>
/// <param name="NumBits">Maximum number of bits of th random number</param>
/// <param name="Precision">Precision to be used for IsProbablePrime</param>
/// <returns> a random prime number that is probably prime with the given precision.</returns>
function RandomProbablePrime(NumBits: Integer; Precision: Integer): BigInteger;

/// <summary>Returns a probable prime >= N.</summary>
/// <param name="N">Number to start with</param>
/// <param name="Precision">Precision for primality test</param>
/// <returns>A number >= N that is probably prime with the given precision.</returns>
function NextProbablePrime(const N: BigInteger; Precision: Integer): BigInteger;

/// <summary>Checks if the (usually randomly chosen) number A witnesses N's compositeness.</summary>
/// <param name="A">Value to test with</param>
/// <param name="N">Number to be tested as composite</param>
///
/// <remarks>See https://en.wikipedia.org/wiki/Miller-Rabin_primality_test#Algorithm_and_running_time</remarks>
function IsWitness(const A, N: BigInteger): Boolean;

function IsComposite(const A, D, N: BigInteger; S: Integer): Boolean;

implementation

// See https://en.wikipedia.org/wiki/Miller-Rabin_primality_test.

uses
  Velthuis.RandomNumbers, System.SysUtils;

var
  Two: BigInteger;
  DeterminicityThreshold: BigInteger;
  CertainlyComposite: BigInteger;
  Random: IRandom;

// Rabin-Miller test, deterministically correct for N < 341,550,071,728,321.
// http://rosettacode.org/wiki/Miller-Rabin_primality_test#Python:_Proved_correct_up_to_large_N
// If you want to improve upon this:
// https://en.wikipedia.org/wiki/Miller-Rabin_primality_test#Deterministic_variants_of_the_test
function IsPrime(const N: BigInteger; Precision: Integer): TPrimality;
var
  R: Integer;
  I: Integer;
  PrimesToTest: Integer;
  D: BigInteger;
  N64: UInt64;
const
  CPrimesToTest: array[0..6] of Integer = (2, 3, 5, 7, 11, 13, 17);
  CProbabilityResults: array[Boolean] of TPrimality = (primComposite, primProbablyPrime);
begin
  if BigInteger.Compare(N, DeterminicityThreshold) > 0 then
    Exit(CProbabilityResults[IsProbablePrime(N, Precision)]);

  if BigInteger.Compare(N, CertainlyComposite) = 0 then
    Exit(primComposite);

  N64 := UInt64(N);
  if N64 > Int64(3474749660383) then
    PrimesToTest := 7
  else if N64 > Int64(2152302898747) then
    PrimesToTest := 6
  else if N64 > Int64(118670087467) then
    PrimesToTest := 5
  else if N64 > Int64(25326001) then
    PrimesToTest := 4
  else if N64 > Int64(1373653) then
    PrimesToTest := 3
  else
    PrimesToTest := 2;

  D := N - BigInteger.One;
  R := 0;

  while D.IsEven do
  begin
    D := D shr 1;
    Inc(R);
  end;

  for I := 0 to PrimesToTest - 1 do
    if IsComposite(CPrimesToTest[I], D, N, R) then
      Exit(primComposite);

  Result := primPrime;
end;

// Check if N is probably prime with a probability of at least 1.0 - 0.25^Precision
function IsProbablePrime(const N: BigInteger; Precision: Integer): Boolean;
var
  I: Integer;
  A, NLessOne: BigInteger;
begin
  if (N = 2) or (N = 3) then
    Exit(True)
  else if (N = BigInteger.Zero) or (N = BigInteger.One) or (N.IsEven) then
    Exit(False);

  NLessOne := N;
  Dec(NLessOne);

  for I := 1 to Precision do
  begin
    repeat
      A := BigInteger.Create(N.BitLength, Random);
    until (A > BigInteger.One) and (A < NLessOne);

    if IsWitness(A, N) then
      Exit(False);
  end;
  Result := True;
end;

function RandomProbablePrime(NumBits: Integer; Precision: Integer): BigInteger;
begin
  repeat
    Result := BigInteger.Create(NumBits, Random);
  until IsProbablePrime(Result, Precision);
end;

// Next probable prime >= N.
function NextProbablePrime(const N: BigInteger; Precision: Integer): BigInteger;
var
  Two: BigInteger;
begin
  Two := 2;
  Result := N;
  if Result = Two then
    Exit;
  if Result.IsEven then
    Result := Result.FlipBit(0);
  while not IsProbablePrime(Result, Precision) do
  begin
    Result := Result + Two;
  end;
  Result := N;
end;

function IsWitness(const A, N: BigInteger): Boolean;
var
  R: Integer;
  D: BigInteger;
begin
  //  Write N - 1 as (2 ^ Power) * Factor, where Factor is odd.
  //  Repeatedly try to divide N - 1 by 2
  R := 1;
  D := (N - BigInteger.One) shr 1;
  while D.IsEven do
  begin
    D := D shr 1;
    Inc(R);
  end;

  // Now check if A is a witness to N's compositeness
  Result := IsComposite(A, D, N, R);
end;

function IsComposite(const A, D, N: BigInteger; S: Integer): Boolean;
var
  I: Integer;
  NLessOne: BigInteger;
begin
  NLessOne := N - BigInteger.One;

  // if A^(2^0 * D) ≡ 1 (mod N) then prime.
  if BigInteger.ModPow(A, D, N) = BigInteger.One then
    Exit(False);

  for I := 0 to S - 1 do
    // if A^(2^I * D) ≡ N - 1 (mod N) then prime.
    if BigInteger.ModPow(A, (BigInteger.One shl I) * D, N) = NLessOne then
      Exit(False);

  Result := True;
end;

initialization
  Two := 2;
  DeterminicityThreshold := UInt64(341550071728321);
  CertainlyComposite := UInt64(3215031751);
  Random := TRandom.Create(Round(Now * SecsPerDay * MSecsPerSec));

end.


