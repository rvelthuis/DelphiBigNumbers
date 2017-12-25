unit Velthuis.StrConsts;

interface

resourcestring
  // BigIntegers
  SErrorParsingFmt           = '''%s'' is not a valid %s value';
  SDivisionByZero            = 'Division by zero';
  SOverflow                  = 'Resulting value too big to represent';
  SOverflowFmt               = '%s: Resulting value too big to represent';
  SInvalidOperation          = 'Invalid operation';
  SConversionFailedFmt       = '%s value too large for conversion to %s';
  SInvalidArgumentFloatFmt   = '%s parameter may not be NaN or +/- Infinity';
  SInvalidArgumentBase       = 'Base parameter must be in the range 2..36';
  SInvalidArgumentFmt        = 'Invalid argument: %s';
  SSqrtBigInteger            = 'Negative values not allowed for Sqrt';
  SNoInverse                 = 'No modular inverse possible';
  SNegativeExponent          = 'Negative exponent %s not allowed';

  // BigDecimals
  SUnderflow               = 'Resulting value too small to represent';
  SRounding                = 'Rounding necessary';
  SExponent                = 'Exponent to IntPower outside the allowed range';

  // BigRationals
//  SDivisionByZero       = 'Division by zero';
//  SInvalidArgumentFmt     = 'Invalid argument: %s';
  SNoInfinity      = 'Infinity cannot be converted to BigRational';
  SNoNan           = 'NaN cannot be converted to BigRational';
  SZeroDenominator = 'BigRational denominator cannot be zero';
//  SErrorParsingFmt      = '''%s'' is not a valid BigRational value';

implementation

end.
