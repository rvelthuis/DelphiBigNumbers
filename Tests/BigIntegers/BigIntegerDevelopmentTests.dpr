program BigIntegerDevelopmentTests;
{

  Delphi DUnit Test Project

  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

// FastMM4 can slow down testing a lot.
{$DEFINE USEFASTMM4}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

{$WARN UNIT_EXPERIMENTAL OFF}

uses
  {$IFDEF USEFASTMM4}
  {$ENDIF }
  DUnitTestRunner,
  Velthuis.Sizes in '..\..\Source\Velthuis.Sizes.pas',
  Velthuis.RandomNumbers in '..\..\Source\Velthuis.RandomNumbers.pas',
  Velthuis.Loggers in '..\..\Source\Velthuis.Loggers.pas',
  Velthuis.Numerics in '..\..\Source\Velthuis.Numerics.pas',
  Velthuis.ExactFloatStrings in '..\..\Source\Velthuis.ExactFloatStrings.pas',
  Velthuis.FloatUtils in '..\..\Source\Velthuis.FloatUtils.pas',
  Velthuis.BigDecimals in '..\..\Source\Velthuis.BigDecimals.pas',
  TestBigIntegers in 'TestBigIntegers.pas',
  Velthuis.BigRationals in '..\..\Source\Velthuis.BigRationals.pas',
  Velthuis.BigIntegers in '..\..\Source\Velthuis.BigIntegers.pas',
  Velthuis.StrConsts in '..\..\Source\Velthuis.StrConsts.pas',
  Velthuis.XorShifts in '..\..\Source\Velthuis.XorShifts.pas',
  Velthuis.BigIntegers.Primes in '..\..\Source\Velthuis.BigIntegers.Primes.pas',
  CompilerAndRTLVersions in '..\..\Source\CompilerAndRTLVersions.pas';

{$R *.RES}

begin
{$IFDEF USEFASTMM4}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  DoDebug := False;
  DUnitTestRunner.RunRegisteredTests;
end.


