#BigNumbers

###BigInteger and BigDecimal for Delphi

These are implementations of the multi-precision `BigInteger` and `BigDecimal` types, built from scratch.

##BigInteger

`BigInteger` is a multi-precision integer. Its size is only limited by available memory.

`BigInteger` is built for easy of use, speed and reliability. It is written in plain Object Pascal and x86-32/x86-64 assembler, but every assembler function has a so called "pure Pascal" equivalent as well. It is modelled after the `BigInteger` type in .NET, but is far more optimized that that and provides an interface that is more in line with Delphi. It uses higher level algorithms like *Burnikel-Ziegler*, *Karatsuba*, *Toom-Cook*, etc. to make things fast even for very large integers. It offers overloaded operators and all the usual functions. More information can be found on the [BigIntegers unit](http://www.rvelthuis.de/programs/bigintegers.html) page on my website.

##BigDecimal

`BigDecimal` is a multi-precision decimal floating point type. It can have an almost unlimited precision.

`BigDecimal` is equally built for ease of use and reliability. It builds on top of BigInteger: the internal representation is a BigInteger for the significant digits, and a scale to indicate the decimals. It also offers overloaded operators and all the usual functions. This is modelled after the `BigDecimal` type in Java, but the interface is more in line with Delphi. More information about this type can be found on the [BigDecimals unit](http://www.rvelthuis.de/programs/bigdecimals.html) page on my website.
