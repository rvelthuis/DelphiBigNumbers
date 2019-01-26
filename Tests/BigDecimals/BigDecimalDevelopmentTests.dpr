program BigDecimalDevelopmentTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestBigDecimals in 'TestBigDecimals.pas',
  Velthuis.BigDecimals in '..\..\Source\Velthuis.BigDecimals.pas',
  Velthuis.ExactFloatStrings in '..\..\Source\Velthuis.ExactFloatStrings.pas',
  Velthuis.FloatUtils in '..\..\Source\Velthuis.FloatUtils.pas',
  Velthuis.Numerics in '..\..\Source\Velthuis.Numerics.pas',
  Velthuis.RandomNumbers in '..\..\Source\Velthuis.RandomNumbers.pas',
  Velthuis.Sizes in '..\..\Source\Velthuis.Sizes.pas',
  Velthuis.Loggers in '..\..\Source\Velthuis.Loggers.pas',
  Velthuis.BigIntegers in '..\..\Source\Velthuis.BigIntegers.pas',
  Velthuis.StrConsts in '..\..\Source\Velthuis.StrConsts.pas',
  CompilerAndRTLVersions in '..\..\Source\CompilerAndRTLVersions.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


