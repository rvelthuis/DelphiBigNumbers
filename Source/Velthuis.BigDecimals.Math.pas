unit Velthuis.BigDecimals.Math;

interface

uses
  Velthuis.BigIntegers, Velthuis.BigDecimals;

// Perhaps we first need BigRational to delay the evaluation of items.

type
  BigDecimalMath = class
  private
    FFactorials: TArray<BigDecimal>;
    FLastFactorialIndex: Integer;
    FLastFactorial: BigInteger;
    procedure InitFactorials(Precision: Integer);
    class constructor Init;
  public
    function Cos(const X: BigDecimal; Precision: Integer = 0): BigDecimal; static;
    function Sin(const X: BigDecimal; Precision: Integer = 0): BigDecimal; static;
    function Pi(Precision: Integer = 0): BigDecimal; static;
    function Ln(const X: BigDecimal; Precision: Integer = 0): BigDecimal; static;
    function Log10(const X: BigDecimal; Precision: Integer = 0): BigDecimal; static;
  end;

implementation

(*
/**
 * Compute the natural logarithm of x to a given scale, x > 0.
 */
public static BigDecimal ln(BigDecimal x, int scale)
{
    // Check that x > 0.
    if (x.signum() <= 0) {
        throw new IllegalArgumentException("x <= 0");
    }

    // The number of digits to the left of the decimal point.
    int magnitude = x.toString().length() - x.scale() - 1;

    if (magnitude < 3) {
        return lnNewton(x, scale);
    }

    // Compute magnitude*ln(x^(1/magnitude)).
    else {

        // x^(1/magnitude)
        BigDecimal root = intRoot(x, magnitude, scale);

        // ln(x^(1/magnitude))
        BigDecimal lnRoot = lnNewton(root, scale);

        // magnitude*ln(x^(1/magnitude))
        return BigDecimal.valueOf(magnitude).multiply(lnRoot)
                    .setScale(scale, BigDecimal.ROUND_HALF_EVEN);
    }
}

/**
 * Compute the natural logarithm of x to a given scale, x > 0.
 * Use Newton's algorithm.
 */
private static BigDecimal lnNewton(BigDecimal x, int scale)
{
    int        sp1 = scale + 1;
    BigDecimal n   = x;
    BigDecimal term;

    // Convergence tolerance = 5*(10^-(scale+1))
    BigDecimal tolerance = BigDecimal.valueOf(5)
                                        .movePointLeft(sp1);

    // Loop until the approximations converge
    // (two successive approximations are within the tolerance).
    do {

        // e^x
        BigDecimal eToX = exp(x, sp1);

        // (e^x - n)/e^x
        term = eToX.subtract(n)
                    .divide(eToX, sp1, BigDecimal.ROUND_DOWN);

        // x - (e^x - n)/e^x
        x = x.subtract(term);

        Thread.yield();
    } while (term.compareTo(tolerance) > 0);

    return x.setScale(scale, BigDecimal.ROUND_HALF_EVEN);
}
*)

// http://people.math.sc.edu/girardi/m142/handouts/10sTaylorPolySeries.pdf

// Exp(x) = 1 + x + x^2/2! + x^3/3! + x^4/4! + ...      x in /R
// Sin(x) = x - x^3/3! + x^5/5! - x^7/7! + ...          all x
// Cos(x) = 1 - x^2/2! + x^4/4! - x^6/6! + ...          all x
// Tan(x) = x + x^3/3 + 2*x^5/15                        |x| < pi/2
// Ln(x)  = (x - 1) - (x - 1)^2/2 + (x - 1)^3/3 - ...   0 < x <= 2
// Ln((x - 1)/(x + 1)) = 2*x + (2 * x^3) / 3 + (2 * x^5) / 5 + ... -1 < x < 1 (converges faster)

(*
  OK, how to tackle this:

  For a certain precision, I need, say, precision + 5 inverse factorials. But these must have, well at least precision + 5.
  So pre-calculating inverse factorials is not enough, because precision can change. I can pre-calculate factorials though.
  If precision is less, no problem. If it is higher inverse factorials must be re-calculated. wow!

  Hmmm... instead of a TArray<BigInteger>, we use a TList<BigDecimal> and add to it until
*)


{ BigDecimalMath }

function BigDecimalMath.Cos(const X: BigDecimal; Precision: Integer): BigDecimal;
begin

end;

class constructor BigDecimalMath.Init;
var
  Fac: BigInteger;
  I: Integer;
begin
  SetLength(FFactorials, BigDecimal.DefaultPrecision + 6);
  Fac := BigInteger.One;
  FFactorials[0] := Fac;
  FFactorials[1] := Fac;
  for I := 2 to High(FFactorials) do
  begin
    Fac := Fac * I;
    FFactorials[I] := Fac;
  end;
  FLastFactorialIndex := High(FFactorials);
end;

// TODO: we only need as many as necessary to get the desired precision. That is probably less than
// the number of factorials we calculate here. Large factorials can easily change precision by 2 or 3.
// How to handle that?

// Solution: use a TList<BigInteger> and not a TArray<BigInteger>.

procedure BigDecimalMath.InitFactorials(Precision: Integer);
var
  I: Integer;
  Fac: BigInteger;
begin
  if Precision + 5 > FLastFactorialIndex then
  begin
    Fac := FFactorials[FLastFactorialIndex];
    SetLength(FFactorials, Precision + 6);
    for I := FLastFactorialIndex + 1 to High(FFactorials) do
    begin
      Fac := Fac * I;
      FFactorials[I] := Fac;
    end;
  end;
  FLastFactorialIndex := High(FFactorials);
end;

function BigDecimalMath.Ln(const X: BigDecimal; Precision: Integer): BigDecimal;
begin

end;

function BigDecimalMath.Log10(const X: BigDecimal; Precision: Integer): BigDecimal;
begin

end;

function BigDecimalMath.Pi(Precision: Integer): BigDecimal;
begin

end;

function BigDecimalMath.Sin(const X: BigDecimal; Precision: Integer): BigDecimal;
begin

end;

(*

*)

end.

