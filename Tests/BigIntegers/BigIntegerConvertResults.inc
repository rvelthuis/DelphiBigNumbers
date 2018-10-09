//                                                                                                  //
// File: BigIntegerConvertResults.inc                                                               //
//                                                                                                  //
// Test data for Velthuis.BigIntegers.pas, generated 10 Okt, 2018, 01:32:33                         //
//                                                                                                  //
// Do not modify the generated data in this file.  Modify the data in the generator source file.    //
// The source file for the generator is BigIntegerTestDataGenerator.java, in the Test subdirectory. //
//                                                                                                  //
// The freely available NetBeans IDE (V8.1) was used to compile and run this project.               //
// http://www.netbeans.org                                                                          //
//                                                                                                  //

type
  TTryParseResult = record
    Str: string;
    Str10: string;
    Base: Integer;
    Result: Boolean;
  end;

const
  TryParseResults: array[0..89] of TTryParseResult =
  (
    (Str: '1884533426';           Str10: '772501236';                        Base:  9; Result: True),
    (Str: 'XDZGKDTJ7BPFY';        Str10: '158207314324491860110';            Base: 36; Result: True),
    (Str: '8A2EEBACABH4A4E932';   Str10: 'error';                            Base: 17; Result: False),
    (Str: '30738686603';          Str10: '10780692330';                      Base:  9; Result: True),
    (Str: '221201010';            Str10: 'error';                            Base:  2; Result: False),
    (Str: '4T';                   Str10: '173';                              Base: 36; Result: True),
    (Str: '5525975281';           Str10: '5525975281';                       Base: 10; Result: True),
    (Str: '7A8449';               Str10: 'error';                            Base: 10; Result: False),
    (Str: '8QW3KIZUFD7';          Str10: '31980381687657547';                Base: 36; Result: True),
    (Str: '1DCDCB8F3DBBE';        Str10: '1053978895959753';                 Base: 17; Result: True),
    (Str: '804728014313';         Str10: '252913313073';                     Base:  9; Result: True),
    (Str: '311230302102111';      Str10: 'error';                            Base:  3; Result: False),
    (Str: 'A0F';                  Str10: '2575';                             Base: 16; Result: True),
    (Str: '7507B3BB56C';          Str10: '8042246288748';                    Base: 16; Result: True),
    (Str: '214A50352601';         Str10: 'error';                            Base: 10; Result: False),
    (Str: 'D0G64524B20E16BC0';    Str10: '635351473509160908411';            Base: 17; Result: True),
    (Str: '001202';               Str10: '47';                               Base:  3; Result: True),
    (Str: 'BR98XO';               Str10: '710909052';                        Base: 36; Result: True),
    (Str: '32G6B327E65E9FEF44F';  Str10: '44641370792245883206917';          Base: 17; Result: True),
    (Str: '156862043A477';        Str10: 'error';                            Base: 10; Result: False),
    (Str: '80670831093571';       Str10: 'error';                            Base:  9; Result: False),
    (Str: '8763';                 Str10: '6456';                             Base:  9; Result: True),
    (Str: '257';                  Str10: '257';                              Base: 10; Result: True),
    (Str: '000210';               Str10: '21';                               Base:  3; Result: True),
    (Str: 'A8368201064339A977A';  Str10: 'error';                            Base: 10; Result: False),
    (Str: '6116782051150268';     Str10: 'error';                            Base:  8; Result: False),
    (Str: '9CH0B19EE4';           Str10: 'error';                            Base: 17; Result: False),
    (Str: 'ZCC8SZ9Q72ZELSQZI';    Str10: '281281219162174919546918046';      Base: 36; Result: True),
    (Str: 'A98AA6';               Str10: 'error';                            Base: 10; Result: False),
    (Str: '12022031321320';       Str10: 'error';                            Base:  3; Result: False),
    (Str: '7AC1H69071';           Str10: 'error';                            Base: 17; Result: False),
    (Str: 'C30B';                 Str10: '49931';                            Base: 16; Result: True),
    (Str: '457851408';            Str10: 'error';                            Base:  8; Result: False),
    (Str: '73032320';             Str10: '15480016';                         Base:  8; Result: True),
    (Str: 'G9A678124AFA45662';    Str10: 'error';                            Base: 16; Result: False),
    (Str: '3741F7D4G430CAD';      Str10: '576861449495749408';               Base: 17; Result: True),
    (Str: '1021102012';           Str10: 'error';                            Base:  2; Result: False),
    (Str: '68902154021257487';    Str10: 'error';                            Base:  9; Result: False),
    (Str: '3111112';              Str10: 'error';                            Base:  3; Result: False),
    (Str: '5824091731424';        Str10: 'error';                            Base:  9; Result: False),
    (Str: '910';                  Str10: 'error';                            Base:  9; Result: False),
    (Str: '11';                   Str10: '3';                                Base:  2; Result: True),
    (Str: '020';                  Str10: 'error';                            Base:  2; Result: False),
    (Str: '541';                  Str10: '541';                              Base: 10; Result: True),
    (Str: '92C';                  Str10: '2647';                             Base: 17; Result: True),
    (Str: '41GA39BCBEB';          Str10: 'error';                            Base: 16; Result: False),
    (Str: '5A9A444319';           Str10: 'error';                            Base: 10; Result: False),
    (Str: '200GG2E3G8';           Str10: 'error';                            Base: 16; Result: False),
    (Str: '20221111121100222';    Str10: 'error';                            Base:  2; Result: False),
    (Str: '70249FG73CA';          Str10: 'error';                            Base: 16; Result: False),
    (Str: '2C52E570904A07DC';     Str10: '3193867357378971612';              Base: 16; Result: True),
    (Str: '225';                  Str10: '269';                              Base: 11; Result: True),
    (Str: '2313003';              Str10: 'error';                            Base:  3; Result: False),
    (Str: 'H61KFOMQ';             Str10: '1345346273906';                    Base: 36; Result: True),
    (Str: '34';                   Str10: '52';                               Base: 16; Result: True),
    (Str: 'QR8PPC';               Str10: '1617876768';                       Base: 36; Result: True),
    (Str: '1111111213';           Str10: 'error';                            Base:  3; Result: False),
    (Str: '21212010';             Str10: 'error';                            Base:  2; Result: False),
    (Str: '345455';               Str10: '117549';                           Base:  8; Result: True),
    (Str: '60E0EG';               Str10: 'error';                            Base: 16; Result: False),
    (Str: 'FB42SIVU1M5PU';        Str10: '72538467041692094322';             Base: 36; Result: True),
    (Str: '83325747';             Str10: 'error';                            Base:  8; Result: False),
    (Str: '1213121220';           Str10: 'error';                            Base:  3; Result: False),
    (Str: '739B69B321373A';       Str10: 'error';                            Base: 11; Result: False),
    (Str: '3381A7A3032319678';    Str10: '153487103455839084';               Base: 11; Result: True),
    (Str: '23230';                Str10: 'error';                            Base:  3; Result: False),
    (Str: '6EF3F';                Str10: '454463';                           Base: 16; Result: True),
    (Str: 'QVL44K1T2ZBQQ8MX';     Str10: '5941892890998190954693689';        Base: 36; Result: True),
    (Str: '15286601153';          Str10: '5551787838';                       Base:  9; Result: True),
    (Str: '28138317546';          Str10: 'error';                            Base:  8; Result: False),
    (Str: '3525633814626555';     Str10: 'error';                            Base:  8; Result: False),
    (Str: '67401567694';          Str10: 'error';                            Base:  9; Result: False),
    (Str: 'NMZIGI';               Str10: '1429330482';                       Base: 36; Result: True),
    (Str: 'BE4G88EECF686';        Str10: '6898671987110680';                 Base: 17; Result: True),
    (Str: '156671710561217262';   Str10: '3900647519100594';                 Base:  8; Result: True),
    (Str: '2021210';              Str10: 'error';                            Base:  2; Result: False),
    (Str: '23020223010';          Str10: 'error';                            Base:  3; Result: False),
    (Str: 'A9A02AB1A53110336B0';  Str10: 'error';                            Base: 11; Result: False),
    (Str: '12000002200';          Str10: '98487';                            Base:  3; Result: True),
    (Str: '68';                   Str10: 'error';                            Base:  8; Result: False),
    (Str: '112123311';            Str10: 'error';                            Base:  3; Result: False),
    (Str: '2CZ2HYP5R4JKM';        Str10: '11184442466083437334';             Base: 36; Result: True),
    (Str: '40708122475029355';    Str10: 'error';                            Base:  9; Result: False),
    (Str: '254';                  Str10: '254';                              Base: 10; Result: True),
    (Str: '498B608B0654';         Str10: 'error';                            Base: 11; Result: False),
    (Str: '6A0';                  Str10: 'error';                            Base: 10; Result: False),
    (Str: '15D82';                Str10: '111981';                           Base: 17; Result: True),
    (Str: '10011';                Str10: '19';                               Base:  2; Result: True),
    (Str: '31A74';                Str10: '46545';                            Base: 11; Result: True),
    (Str: '964461016676296357';   Str10: 'error';                            Base:  9; Result: False)
  );
  ByteArrayResults: array[0..64 - 1] of TTestResult =
  (
    (Info: triOk;            Val: '00000000000000000000000000000000CCED'),      // Arguments[0].ToByteArray
    (Info: triOk;            Val: '01000000000000000000000000000000CB'),        // Arguments[1].ToByteArray
    (Info: triOk;            Val: 'EF6EB4A07659B348C7041328F6'),                // Arguments[2].ToByteArray
    (Info: triOk;            Val: '7AF13B46222F0D5192A332F6FE'),                // Arguments[3].ToByteArray
    (Info: triOk;            Val: '8631A02B39486123BA3C6FE3'),                  // Arguments[4].ToByteArray
    (Info: triOk;            Val: '42A1F9D040CBD7A785AC62FE'),                  // Arguments[5].ToByteArray
    (Info: triOk;            Val: 'D87BEA26285B07F94121FA'),                    // Arguments[6].ToByteArray
    (Info: triOk;            Val: '7C70856AA8B08AE044F0'),                      // Arguments[7].ToByteArray
    (Info: triOk;            Val: 'F69B3327268A8FB328FD'),                      // Arguments[8].ToByteArray
    (Info: triOk;            Val: 'A6F0170FDA084F9C3FFE'),                      // Arguments[9].ToByteArray
    (Info: triOk;            Val: 'DA186ADA5A2AB14AA5'),                        // Arguments[10].ToByteArray
    (Info: triOk;            Val: '6079FE'),                                    // Arguments[11].ToByteArray
    (Info: triOk;            Val: '104DFF'),                                    // Arguments[12].ToByteArray
    (Info: triOk;            Val: 'F0D8'),                                      // Arguments[13].ToByteArray
    (Info: triOk;            Val: '18FC'),                                      // Arguments[14].ToByteArray
    (Info: triOk;            Val: '9C'),                                        // Arguments[15].ToByteArray
    (Info: triOk;            Val: 'C8'),                                        // Arguments[16].ToByteArray
    (Info: triOk;            Val: 'F6'),                                        // Arguments[17].ToByteArray
    (Info: triOk;            Val: 'F9'),                                        // Arguments[18].ToByteArray
    (Info: triOk;            Val: 'FE'),                                        // Arguments[19].ToByteArray
    (Info: triOk;            Val: 'FF'),                                        // Arguments[20].ToByteArray
    (Info: triOk;            Val: '00'),                                        // Arguments[21].ToByteArray
    (Info: triOk;            Val: '01'),                                        // Arguments[22].ToByteArray
    (Info: triOk;            Val: '02'),                                        // Arguments[23].ToByteArray
    (Info: triOk;            Val: '07'),                                        // Arguments[24].ToByteArray
    (Info: triOk;            Val: '0A'),                                        // Arguments[25].ToByteArray
    (Info: triOk;            Val: '64'),                                        // Arguments[26].ToByteArray
    (Info: triOk;            Val: '9901'),                                      // Arguments[27].ToByteArray
    (Info: triOk;            Val: '3203'),                                      // Arguments[28].ToByteArray
    (Info: triOk;            Val: 'E803'),                                      // Arguments[29].ToByteArray
    (Info: triOk;            Val: '1027'),                                      // Arguments[30].ToByteArray
    (Info: triOk;            Val: 'A08601'),                                    // Arguments[31].ToByteArray
    (Info: triOk;            Val: '40420F'),                                    // Arguments[32].ToByteArray
    (Info: triOk;            Val: 'FC4DCB8D343CC43A'),                          // Arguments[33].ToByteArray
    (Info: triOk;            Val: '4721E743C953C34A'),                          // Arguments[34].ToByteArray
    (Info: triOk;            Val: '0000FEFF0000008000'),                        // Arguments[35].ToByteArray
    (Info: triOk;            Val: '44346F771E32165F09'),                        // Arguments[36].ToByteArray
    (Info: triOk;            Val: 'FFFFFFFFFFFFFFFF34'),                        // Arguments[37].ToByteArray
    (Info: triOk;            Val: '26E79525A5D54EB55A'),                        // Arguments[38].ToByteArray
    (Info: triOk;            Val: '5A0FE8F025F7B063C001'),                      // Arguments[39].ToByteArray
    (Info: triOk;            Val: '0A64CCD8D975704CD702'),                      // Arguments[40].ToByteArray
    (Info: triOk;            Val: '848F7A95574F751FBB0F'),                      // Arguments[41].ToByteArray
    (Info: triOk;            Val: '00000000000000003412'),                      // Arguments[42].ToByteArray
    (Info: triOk;            Val: '288415D9D7A4F806BEDE05'),                    // Arguments[43].ToByteArray
    (Info: triOk;            Val: 'BE5E062FBF3428587A539D01'),                  // Arguments[44].ToByteArray
    (Info: triOk;            Val: 'C665CD027AC9616FBF940404'),                  // Arguments[45].ToByteArray
    (Info: triOk;            Val: '7ACE5FD4C6B79EDC45C3901C'),                  // Arguments[46].ToByteArray
    (Info: triOk;            Val: '01000080FFFFFF7FFFFFFF3F'),                  // Arguments[47].ToByteArray
    (Info: triOk;            Val: '89674523018967452301EFCD00'),                // Arguments[48].ToByteArray
    (Info: triOk;            Val: '860EC4B9DDD0F2AE6D5CCD0901'),                // Arguments[49].ToByteArray
    (Info: triOk;            Val: '11914B5F89A64CB738FBECD709'),                // Arguments[50].ToByteArray
    (Info: triOk;            Val: 'F5756A9ACB9D2C0E7EDC7A6D01'),                // Arguments[51].ToByteArray
    (Info: triOk;            Val: '45230189674523018967452301EF00'),            // Arguments[52].ToByteArray
    (Info: triOk;            Val: 'C36684A8F7804291066FE895887311'),            // Arguments[53].ToByteArray
    (Info: triOk;            Val: '0100000000000000FFFFFFFFFFFFFF3F'),          // Arguments[54].ToByteArray
    (Info: triOk;            Val: '0200000000000000FFFFFFFFFFFFFF3F'),          // Arguments[55].ToByteArray
    (Info: triOk;            Val: '00000000000000000000000000FEFFFF01'),        // Arguments[56].ToByteArray
    (Info: triOk;            Val: 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF34'),        // Arguments[57].ToByteArray
    (Info: triOk;            Val: '000000000000000000000000000000003412'),      // Arguments[58].ToByteArray
    (Info: triOk;            Val: 'D20A3FCE96F1CFACCB9869D7C22F162FBA394466' + 
                                  '378926F42D4CECCA2D'),                        // Arguments[59].ToByteArray
    (Info: triOk;            Val: '2BBC42A011524BB16C6F4AD5745C81A3257CB44E' + 
                                  '9390B52A60E73BBCC831'),                      // Arguments[60].ToByteArray
    (Info: triOk;            Val: '00E0C09A3EDED75CA4250287D3F2B13B6B868C6E' + 
                                  'AA1139772C2D8D29569B9B34B1C8C401'),          // Arguments[61].ToByteArray
    (Info: triOk;            Val: '00A0724E1809'),                              // Arguments[62].ToByteArray
    (Info: triOk;            Val: '000000000000004A83DA4A8654CBFDEB71259AC8' + 
                                  'B57CC828')                                   // Arguments[63].ToByteArray
  );

  HexResults: array[0..64 - 1] of TTestResult =
  (
    (Info: triOk;            Val: '-123400000000000000000000000000000000'),     // Arguments[0].ToString(16)
    (Info: triOk;            Val: '-34FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'),       // Arguments[1].ToString(16)
    (Info: triOk;            Val: '-9D7ECFB38B74CA6895F4B9111'),                // Arguments[2].ToString(16)
    (Info: triOk;            Val: '-109CD5C6DAEF2D0DDB9C40E86'),                // Arguments[3].ToString(16)
    (Info: triOk;            Val: '-1C90C345DC9EB7C6D45FCE7A'),                 // Arguments[4].ToString(16)
    (Info: triOk;            Val: '-19D537A582834BF2F065EBE'),                  // Arguments[5].ToString(16)
    (Info: triOk;            Val: '-5DEBE06F8A4D7D9158428'),                    // Arguments[6].ToString(16)
    (Info: triOk;            Val: '-FBB1F754F57957A8F84'),                      // Arguments[7].ToString(16)
    (Info: triOk;            Val: '-2D74C7075D9D8CC640A'),                      // Arguments[8].ToString(16)
    (Info: triOk;            Val: '-1C063B0F725F0E80F5A'),                      // Arguments[9].ToString(16)
    (Info: triOk;            Val: '-5AB54ED5A52595E726'),                       // Arguments[10].ToString(16)
    (Info: triOk;            Val: '-186A0'),                                    // Arguments[11].ToString(16)
    (Info: triOk;            Val: '-B2F0'),                                     // Arguments[12].ToString(16)
    (Info: triOk;            Val: '-2710'),                                     // Arguments[13].ToString(16)
    (Info: triOk;            Val: '-3E8'),                                      // Arguments[14].ToString(16)
    (Info: triOk;            Val: '-64'),                                       // Arguments[15].ToString(16)
    (Info: triOk;            Val: '-38'),                                       // Arguments[16].ToString(16)
    (Info: triOk;            Val: '-A'),                                        // Arguments[17].ToString(16)
    (Info: triOk;            Val: '-7'),                                        // Arguments[18].ToString(16)
    (Info: triOk;            Val: '-2'),                                        // Arguments[19].ToString(16)
    (Info: triOk;            Val: '-1'),                                        // Arguments[20].ToString(16)
    (Info: triOk;            Val: '0'),                                         // Arguments[21].ToString(16)
    (Info: triOk;            Val: '1'),                                         // Arguments[22].ToString(16)
    (Info: triOk;            Val: '2'),                                         // Arguments[23].ToString(16)
    (Info: triOk;            Val: '7'),                                         // Arguments[24].ToString(16)
    (Info: triOk;            Val: 'A'),                                         // Arguments[25].ToString(16)
    (Info: triOk;            Val: '64'),                                        // Arguments[26].ToString(16)
    (Info: triOk;            Val: '199'),                                       // Arguments[27].ToString(16)
    (Info: triOk;            Val: '332'),                                       // Arguments[28].ToString(16)
    (Info: triOk;            Val: '3E8'),                                       // Arguments[29].ToString(16)
    (Info: triOk;            Val: '2710'),                                      // Arguments[30].ToString(16)
    (Info: triOk;            Val: '186A0'),                                     // Arguments[31].ToString(16)
    (Info: triOk;            Val: 'F4240'),                                     // Arguments[32].ToString(16)
    (Info: triOk;            Val: '3AC43C348DCB4DFC'),                          // Arguments[33].ToString(16)
    (Info: triOk;            Val: '4AC353C943E72147'),                          // Arguments[34].ToString(16)
    (Info: triOk;            Val: '80000000FFFE0000'),                          // Arguments[35].ToString(16)
    (Info: triOk;            Val: '95F16321E776F3444'),                         // Arguments[36].ToString(16)
    (Info: triOk;            Val: '34FFFFFFFFFFFFFFFF'),                        // Arguments[37].ToString(16)
    (Info: triOk;            Val: '5AB54ED5A52595E726'),                        // Arguments[38].ToString(16)
    (Info: triOk;            Val: '1C063B0F725F0E80F5A'),                       // Arguments[39].ToString(16)
    (Info: triOk;            Val: '2D74C7075D9D8CC640A'),                       // Arguments[40].ToString(16)
    (Info: triOk;            Val: 'FBB1F754F57957A8F84'),                       // Arguments[41].ToString(16)
    (Info: triOk;            Val: '12340000000000000000'),                      // Arguments[42].ToString(16)
    (Info: triOk;            Val: '5DEBE06F8A4D7D9158428'),                     // Arguments[43].ToString(16)
    (Info: triOk;            Val: '19D537A582834BF2F065EBE'),                   // Arguments[44].ToString(16)
    (Info: triOk;            Val: '40494BF6F61C97A02CD65C6'),                   // Arguments[45].ToString(16)
    (Info: triOk;            Val: '1C90C345DC9EB7C6D45FCE7A'),                  // Arguments[46].ToString(16)
    (Info: triOk;            Val: '3FFFFFFF7FFFFFFF80000001'),                  // Arguments[47].ToString(16)
    (Info: triOk;            Val: 'CDEF01234567890123456789'),                  // Arguments[48].ToString(16)
    (Info: triOk;            Val: '109CD5C6DAEF2D0DDB9C40E86'),                 // Arguments[49].ToString(16)
    (Info: triOk;            Val: '9D7ECFB38B74CA6895F4B9111'),                 // Arguments[50].ToString(16)
    (Info: triOk;            Val: '16D7ADC7E0E2C9DCB9A6A75F5'),                 // Arguments[51].ToString(16)
    (Info: triOk;            Val: 'EF01234567890123456789012345'),              // Arguments[52].ToString(16)
    (Info: triOk;            Val: '11738895E86F06914280F7A88466C3'),            // Arguments[53].ToString(16)
    (Info: triOk;            Val: '3FFFFFFFFFFFFFFF0000000000000001'),          // Arguments[54].ToString(16)
    (Info: triOk;            Val: '3FFFFFFFFFFFFFFF0000000000000002'),          // Arguments[55].ToString(16)
    (Info: triOk;            Val: '1FFFFFE00000000000000000000000000'),         // Arguments[56].ToString(16)
    (Info: triOk;            Val: '34FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'),        // Arguments[57].ToString(16)
    (Info: triOk;            Val: '123400000000000000000000000000000000'),      // Arguments[58].ToString(16)
    (Info: triOk;            Val: '2DCAEC4C2DF4268937664439BA2F162FC2D76998' + 
                                  'CBACCFF196CE3F0AD2'),                        // Arguments[59].ToString(16)
    (Info: triOk;            Val: '31C8BC3BE7602AB590934EB47C25A3815C74D54A' + 
                                  '6F6CB14B5211A042BC2B'),                      // Arguments[60].ToString(16)
    (Info: triOk;            Val: '1C4C8B1349B9B56298D2D2C773911AA6E8C866B3' + 
                                  'BB1F2D3870225A45CD7DE3E9AC0E000'),           // Arguments[61].ToString(16)
    (Info: triOk;            Val: '9184E72A000'),                               // Arguments[62].ToString(16)
    (Info: triOk;            Val: '28C87CB5C89A2571EBFDCB54864ADA834A000000' + 
                                  '00000000')                                   // Arguments[63].ToString(16)
  );

  AsIntegerResults: array[0..64 - 1] of TTestResult =
  (
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[0].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[1].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[2].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[3].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[4].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[5].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[6].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[7].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[8].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[9].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[10].AsInteger
    (Info: triOk;            Val: '-100000'),                                   // Arguments[11].AsInteger
    (Info: triOk;            Val: '-45808'),                                    // Arguments[12].AsInteger
    (Info: triOk;            Val: '-10000'),                                    // Arguments[13].AsInteger
    (Info: triOk;            Val: '-1000'),                                     // Arguments[14].AsInteger
    (Info: triOk;            Val: '-100'),                                      // Arguments[15].AsInteger
    (Info: triOk;            Val: '-56'),                                       // Arguments[16].AsInteger
    (Info: triOk;            Val: '-10'),                                       // Arguments[17].AsInteger
    (Info: triOk;            Val: '-7'),                                        // Arguments[18].AsInteger
    (Info: triOk;            Val: '-2'),                                        // Arguments[19].AsInteger
    (Info: triOk;            Val: '-1'),                                        // Arguments[20].AsInteger
    (Info: triOk;            Val: '0'),                                         // Arguments[21].AsInteger
    (Info: triOk;            Val: '1'),                                         // Arguments[22].AsInteger
    (Info: triOk;            Val: '2'),                                         // Arguments[23].AsInteger
    (Info: triOk;            Val: '7'),                                         // Arguments[24].AsInteger
    (Info: triOk;            Val: '10'),                                        // Arguments[25].AsInteger
    (Info: triOk;            Val: '100'),                                       // Arguments[26].AsInteger
    (Info: triOk;            Val: '409'),                                       // Arguments[27].AsInteger
    (Info: triOk;            Val: '818'),                                       // Arguments[28].AsInteger
    (Info: triOk;            Val: '1000'),                                      // Arguments[29].AsInteger
    (Info: triOk;            Val: '10000'),                                     // Arguments[30].AsInteger
    (Info: triOk;            Val: '100000'),                                    // Arguments[31].AsInteger
    (Info: triOk;            Val: '1000000'),                                   // Arguments[32].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[33].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[34].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[35].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[36].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[37].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[38].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[39].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[40].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[41].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[42].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[43].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[44].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[45].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[46].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[47].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[48].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[49].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[50].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[51].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[52].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[53].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[54].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[55].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[56].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[57].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[58].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[59].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[60].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[61].AsInteger
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[62].AsInteger
    (Info: triOverflow;      Val: 'Overflow')                                   // Arguments[63].AsInteger
  );

  AsCardinalResults: array[0..64 - 1] of TTestResult =
  (
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[0].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[1].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[2].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[3].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[4].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[5].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[6].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[7].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[8].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[9].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[10].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[11].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[12].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[13].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[14].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[15].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[16].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[17].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[18].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[19].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[20].AsCardinal
    (Info: triOk;            Val: '0'),                                         // Arguments[21].AsCardinal
    (Info: triOk;            Val: '1'),                                         // Arguments[22].AsCardinal
    (Info: triOk;            Val: '2'),                                         // Arguments[23].AsCardinal
    (Info: triOk;            Val: '7'),                                         // Arguments[24].AsCardinal
    (Info: triOk;            Val: '10'),                                        // Arguments[25].AsCardinal
    (Info: triOk;            Val: '100'),                                       // Arguments[26].AsCardinal
    (Info: triOk;            Val: '409'),                                       // Arguments[27].AsCardinal
    (Info: triOk;            Val: '818'),                                       // Arguments[28].AsCardinal
    (Info: triOk;            Val: '1000'),                                      // Arguments[29].AsCardinal
    (Info: triOk;            Val: '10000'),                                     // Arguments[30].AsCardinal
    (Info: triOk;            Val: '100000'),                                    // Arguments[31].AsCardinal
    (Info: triOk;            Val: '1000000'),                                   // Arguments[32].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[33].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[34].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[35].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[36].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[37].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[38].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[39].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[40].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[41].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[42].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[43].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[44].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[45].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[46].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[47].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[48].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[49].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[50].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[51].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[52].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[53].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[54].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[55].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[56].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[57].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[58].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[59].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[60].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[61].AsCardinal
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[62].AsCardinal
    (Info: triOverflow;      Val: 'Overflow')                                   // Arguments[63].AsCardinal
  );

  AsInt64Results: array[0..64 - 1] of TTestResult =
  (
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[0].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[1].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[2].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[3].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[4].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[5].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[6].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[7].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[8].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[9].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[10].AsInt64
    (Info: triOk;            Val: '-100000'),                                   // Arguments[11].AsInt64
    (Info: triOk;            Val: '-45808'),                                    // Arguments[12].AsInt64
    (Info: triOk;            Val: '-10000'),                                    // Arguments[13].AsInt64
    (Info: triOk;            Val: '-1000'),                                     // Arguments[14].AsInt64
    (Info: triOk;            Val: '-100'),                                      // Arguments[15].AsInt64
    (Info: triOk;            Val: '-56'),                                       // Arguments[16].AsInt64
    (Info: triOk;            Val: '-10'),                                       // Arguments[17].AsInt64
    (Info: triOk;            Val: '-7'),                                        // Arguments[18].AsInt64
    (Info: triOk;            Val: '-2'),                                        // Arguments[19].AsInt64
    (Info: triOk;            Val: '-1'),                                        // Arguments[20].AsInt64
    (Info: triOk;            Val: '0'),                                         // Arguments[21].AsInt64
    (Info: triOk;            Val: '1'),                                         // Arguments[22].AsInt64
    (Info: triOk;            Val: '2'),                                         // Arguments[23].AsInt64
    (Info: triOk;            Val: '7'),                                         // Arguments[24].AsInt64
    (Info: triOk;            Val: '10'),                                        // Arguments[25].AsInt64
    (Info: triOk;            Val: '100'),                                       // Arguments[26].AsInt64
    (Info: triOk;            Val: '409'),                                       // Arguments[27].AsInt64
    (Info: triOk;            Val: '818'),                                       // Arguments[28].AsInt64
    (Info: triOk;            Val: '1000'),                                      // Arguments[29].AsInt64
    (Info: triOk;            Val: '10000'),                                     // Arguments[30].AsInt64
    (Info: triOk;            Val: '100000'),                                    // Arguments[31].AsInt64
    (Info: triOk;            Val: '1000000'),                                   // Arguments[32].AsInt64
    (Info: triOk;            Val: '4234575746049986044'),                       // Arguments[33].AsInt64
    (Info: triOk;            Val: '5387241703157997895'),                       // Arguments[34].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[35].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[36].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[37].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[38].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[39].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[40].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[41].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[42].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[43].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[44].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[45].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[46].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[47].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[48].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[49].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[50].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[51].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[52].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[53].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[54].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[55].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[56].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[57].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[58].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[59].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[60].AsInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[61].AsInt64
    (Info: triOk;            Val: '10000000000000'),                            // Arguments[62].AsInt64
    (Info: triOverflow;      Val: 'Overflow')                                   // Arguments[63].AsInt64
  );

  AsUInt64Results: array[0..64 - 1] of TTestResult =
  (
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[0].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[1].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[2].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[3].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[4].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[5].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[6].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[7].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[8].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[9].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[10].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[11].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[12].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[13].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[14].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[15].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[16].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[17].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[18].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[19].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[20].AsUInt64
    (Info: triOk;            Val: '0'),                                         // Arguments[21].AsUInt64
    (Info: triOk;            Val: '1'),                                         // Arguments[22].AsUInt64
    (Info: triOk;            Val: '2'),                                         // Arguments[23].AsUInt64
    (Info: triOk;            Val: '7'),                                         // Arguments[24].AsUInt64
    (Info: triOk;            Val: '10'),                                        // Arguments[25].AsUInt64
    (Info: triOk;            Val: '100'),                                       // Arguments[26].AsUInt64
    (Info: triOk;            Val: '409'),                                       // Arguments[27].AsUInt64
    (Info: triOk;            Val: '818'),                                       // Arguments[28].AsUInt64
    (Info: triOk;            Val: '1000'),                                      // Arguments[29].AsUInt64
    (Info: triOk;            Val: '10000'),                                     // Arguments[30].AsUInt64
    (Info: triOk;            Val: '100000'),                                    // Arguments[31].AsUInt64
    (Info: triOk;            Val: '1000000'),                                   // Arguments[32].AsUInt64
    (Info: triOk;            Val: '4234575746049986044'),                       // Arguments[33].AsUInt64
    (Info: triOk;            Val: '5387241703157997895'),                       // Arguments[34].AsUInt64
    (Info: triOk;            Val: '9223372041149612032'),                       // Arguments[35].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[36].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[37].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[38].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[39].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[40].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[41].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[42].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[43].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[44].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[45].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[46].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[47].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[48].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[49].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[50].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[51].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[52].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[53].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[54].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[55].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[56].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[57].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[58].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[59].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[60].AsUInt64
    (Info: triOverflow;      Val: 'Overflow'),                                  // Arguments[61].AsUInt64
    (Info: triOk;            Val: '10000000000000'),                            // Arguments[62].AsUInt64
    (Info: triOverflow;      Val: 'Overflow')                                   // Arguments[63].AsUInt64
  );


  CreateDoubleResults: array[0..DoubleCount - 1] of TTestResult =
  (
    (Info: triOk;            Val: '-600000000000000000000'),                    // BigInteger.Create(-600000000000000000000.0)
    (Info: triOk;            Val: '-100000000000000000000'),                    // BigInteger.Create(-100000000000000000000.0)
    (Info: triOk;            Val: '-3'),                                        // BigInteger.Create(-3.5099999999999997868371792719699442386627197265625)
    (Info: triOk;            Val: '-3'),                                        // BigInteger.Create(-3.5)
    (Info: triOk;            Val: '-3'),                                        // BigInteger.Create(-3.4900000000000002131628207280300557613372802734375)
    (Info: triOk;            Val: '-2'),                                        // BigInteger.Create(-2.5099999999999997868371792719699442386627197265625)
    (Info: triOk;            Val: '-2'),                                        // BigInteger.Create(-2.5)
    (Info: triOk;            Val: '-2'),                                        // BigInteger.Create(-2.4900000000000002131628207280300557613372802734375)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(-0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000399837996052057672392955215770683188403652060118731913985110869352353525772265859791654921496218237015970565410794993080445368720839225272167125662825574358854498578849381613317832611860008691572046029005015889997371182867751115974641606953809969127178192138671875)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.0)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.0000000700000000000000047733017083211037867584991545299999415874481201171875)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.000100000000000000004792173602385929598312941379845142364501953125)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.1000000000000000055511151231257827021181583404541015625)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.200000000000000011102230246251565404236316680908203125)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.299999999999999988897769753748434595763683319091796875)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.40000000000000002220446049250313080847263336181640625)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.4999999999999900079927783735911361873149871826171875)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.5)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.50000001000000005024759275329415686428546905517578125)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.6999999999999999555910790149937383830547332763671875)
    (Info: triOk;            Val: '0'),                                         // BigInteger.Create(0.90000000000000002220446049250313080847263336181640625)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.0)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.0000000000000099920072216264088638126850128173828125)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.100000000000000088817841970012523233890533447265625)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.4999999999999900079927783735911361873149871826171875)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.5)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.5000000000000099920072216264088638126850128173828125)
    (Info: triOk;            Val: '1'),                                         // BigInteger.Create(1.9999000000000000110134124042815528810024261474609375)
    (Info: triOk;            Val: '2'),                                         // BigInteger.Create(2.0)
    (Info: triOk;            Val: '2'),                                         // BigInteger.Create(2.4900000000000002131628207280300557613372802734375)
    (Info: triOk;            Val: '2'),                                         // BigInteger.Create(2.5)
    (Info: triOk;            Val: '2'),                                         // BigInteger.Create(2.5099999999999997868371792719699442386627197265625)
    (Info: triOk;            Val: '3'),                                         // BigInteger.Create(3.0)
    (Info: triOk;            Val: '3'),                                         // BigInteger.Create(3.4900000000000002131628207280300557613372802734375)
    (Info: triOk;            Val: '3'),                                         // BigInteger.Create(3.5)
    (Info: triOk;            Val: '3'),                                         // BigInteger.Create(3.5099999999999997868371792719699442386627197265625)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.0)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.0999999999999996447286321199499070644378662109375)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.20000000000000017763568394002504646778106689453125)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.4000000000000003552713678800500929355621337890625)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.5)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.5999999999999996447286321199499070644378662109375)
    (Info: triOk;            Val: '4'),                                         // BigInteger.Create(4.999900000000000233058017329312860965728759765625)
    (Info: triOk;            Val: '5'),                                         // BigInteger.Create(5.0)
    (Info: triOk;            Val: '6'),                                         // BigInteger.Create(6.0)
    (Info: triOk;            Val: '7'),                                         // BigInteger.Create(7.0)
    (Info: triOk;            Val: '8'),                                         // BigInteger.Create(8.0)
    (Info: triOk;            Val: '9'),                                         // BigInteger.Create(9.0)
    (Info: triOk;            Val: '10'),                                        // BigInteger.Create(10.0)
    (Info: triOk;            Val: '15'),                                        // BigInteger.Create(15.0)
    (Info: triOk;            Val: '22'),                                        // BigInteger.Create(22.0)
    (Info: triOk;            Val: '44'),                                        // BigInteger.Create(44.0)
    (Info: triOk;            Val: '85'),                                        // BigInteger.Create(85.0)
    (Info: triOk;            Val: '128'),                                       // BigInteger.Create(128.0)
    (Info: triOk;            Val: '256'),                                       // BigInteger.Create(256.0)
    (Info: triOk;            Val: '256'),                                       // BigInteger.Create(256.1000000000000227373675443232059478759765625)
    (Info: triOk;            Val: '256'),                                       // BigInteger.Create(256.5)
    (Info: triOk;            Val: '256'),                                       // BigInteger.Create(256.69999999999998863131622783839702606201171875)
    (Info: triOk;            Val: '300'),                                       // BigInteger.Create(300.0)
    (Info: triOk;            Val: '876'),                                       // BigInteger.Create(876.543210987653992560808546841144561767578125)
    (Info: triOk;            Val: '645000'),                                    // BigInteger.Create(645000.0)
    (Info: triOk;            Val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (Info: triOk;            Val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (Info: triOk;            Val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (Info: triOk;            Val: '1048576'),                                   // BigInteger.Create(1048576.1000000000931322574615478515625)
    (Info: triOk;            Val: '1048576'),                                   // BigInteger.Create(1048576.5)
    (Info: triOk;            Val: '10000000000'),                               // BigInteger.Create(10000000000.0)
    (Info: triOk;            Val: '14900000000'),                               // BigInteger.Create(14900000000.0)
    (Info: triOk;            Val: '15000000000'),                               // BigInteger.Create(15000000000.0)
    (Info: triOk;            Val: '15100000000'),                               // BigInteger.Create(15100000000.0)
    (Info: triOk;            Val: '31415920000'),                               // BigInteger.Create(31415920000.0)
    (Info: triOk;            Val: '100000000000'),                              // BigInteger.Create(100000000000.0)
    (Info: triOk;            Val: '1000000000000'),                             // BigInteger.Create(1000000000000.0)
    (Info: triOk;            Val: '10000000000000'),                            // BigInteger.Create(10000000000000.0)
    (Info: triOk;            Val: '100000000000000'),                           // BigInteger.Create(100000000000000.0)
    (Info: triOk;            Val: '1000000000000000'),                          // BigInteger.Create(1000000000000000.0)
    (Info: triOk;            Val: '2000000000000000'),                          // BigInteger.Create(2000000000000000.0)
    (Info: triOk;            Val: '4000000000000000'),                          // BigInteger.Create(4000000000000000.0)
    (Info: triOk;            Val: '4900000000000000'),                          // BigInteger.Create(4900000000000000.0)
    (Info: triOk;            Val: '8000000000000000'),                          // BigInteger.Create(8000000000000000.0)
    (Info: triOk;            Val: '10000000000000000'),                         // BigInteger.Create(10000000000000000.0)
    (Info: triOk;            Val: '20000000000000000'),                         // BigInteger.Create(20000000000000000.0)
    (Info: triOk;            Val: '40000000000000000'),                         // BigInteger.Create(40000000000000000.0)
    (Info: triOk;            Val: '50000000000000000'),                         // BigInteger.Create(50000000000000000.0)
    (Info: triOk;            Val: '100000000000000000'),                        // BigInteger.Create(100000000000000000.0)
    (Info: triOk;            Val: '1000000000000000000'),                       // BigInteger.Create(1000000000000000000.0)
    (Info: triOk;            Val: '10000000000000000000'),                      // BigInteger.Create(10000000000000000000.0)
    (Info: triOk;            Val: '12345678901234599936'),                      // BigInteger.Create(12345678901234599936.0)
    (Info: triOk;            Val: '100000000000000000000'),                     // BigInteger.Create(100000000000000000000.0)
    (Info: triOk;            Val: '100000000000001'),                           // BigInteger.Create(100000000000001.0)
    (Info: triOk;            Val: '100000000000002'),                           // BigInteger.Create(100000000000002.0)
    (Info: triOk;            Val: '100000000000004'),                           // BigInteger.Create(100000000000004.0)
    (Info: triOk;            Val: '100000000000008'),                           // BigInteger.Create(100000000000008.0)
    (Info: triOk;            Val: '100000000000016'),                           // BigInteger.Create(100000000000016.0)
    (Info: triOk;            Val: '100000000000032'),                           // BigInteger.Create(100000000000032.0)
    (Info: triOk;            Val: '100000000000064'),                           // BigInteger.Create(100000000000064.0)
    (Info: triOk;            Val: '100000000000128'),                           // BigInteger.Create(100000000000128.0)
    (Info: triOk;            Val: '100000000000256'),                           // BigInteger.Create(100000000000256.0)
    (Info: triOk;            Val: '100000000000512'),                           // BigInteger.Create(100000000000512.0)
    (Info: triOk;            Val: '1000000000000000000266098647083672765374' + 
                                  '0240118120080909813197745348975891631308' + 
                                  '8')                                          // BigInteger.Create(100000000000000000026609864708367276537402401181200809098131977453489758916313088.0)
  );

  DoubleResults: array[0..ArgumentCount - 1] of Double =
  (
    -1585715829851573239739325670632039865384960.0,                             // Double(Arguments[0])
    -18034965446809738563558854193883715207168.0,                               // Double(Arguments[1])
    -779879232593610221556296843264.0,                                          // Double(Arguments[2])
    -82261793876695337239964549120.0,                                           // Double(Arguments[3])
    -8840587743209015237031231488.0,                                            // Double(Arguments[4])
    -499680576774082295916134400.0,                                             // Double(Arguments[5])
    -7096499840976816923738112.0,                                               // Double(Arguments[6])
    -74287305190053404213248.0,                                                 // Double(Arguments[7])
    -13416290973509622956032.0,                                                 // Double(Arguments[8])
    -8271324858169863176192.0,                                                  // Double(Arguments[9])
    -1673271581108184809472.0,                                                  // Double(Arguments[10])
    -100000.0,                                                                  // Double(Arguments[11])
    -45808.0,                                                                   // Double(Arguments[12])
    -10000.0,                                                                   // Double(Arguments[13])
    -1000.0,                                                                    // Double(Arguments[14])
    -100.0,                                                                     // Double(Arguments[15])
    -56.0,                                                                      // Double(Arguments[16])
    -10.0,                                                                      // Double(Arguments[17])
    -7.0,                                                                       // Double(Arguments[18])
    -2.0,                                                                       // Double(Arguments[19])
    -1.0,                                                                       // Double(Arguments[20])
    0.0,                                                                        // Double(Arguments[21])
    1.0,                                                                        // Double(Arguments[22])
    2.0,                                                                        // Double(Arguments[23])
    7.0,                                                                        // Double(Arguments[24])
    10.0,                                                                       // Double(Arguments[25])
    100.0,                                                                      // Double(Arguments[26])
    409.0,                                                                      // Double(Arguments[27])
    818.0,                                                                      // Double(Arguments[28])
    1000.0,                                                                     // Double(Arguments[29])
    10000.0,                                                                    // Double(Arguments[30])
    100000.0,                                                                   // Double(Arguments[31])
    1000000.0,                                                                  // Double(Arguments[32])
    4234575746049986048.0,                                                      // Double(Arguments[33])
    5387241703157997568.0,                                                      // Double(Arguments[34])
    9223372041149612032.0,                                                      // Double(Arguments[35])
    172872415652910923776.0,                                                    // Double(Arguments[36])
    977677435906606235648.0,                                                    // Double(Arguments[37])
    1673271581108184809472.0,                                                   // Double(Arguments[38])
    8271324858169863176192.0,                                                   // Double(Arguments[39])
    13416290973509622956032.0,                                                  // Double(Arguments[40])
    74287305190053404213248.0,                                                  // Double(Arguments[41])
    85961827383486510530560.0,                                                  // Double(Arguments[42])
    7096499840976816923738112.0,                                                // Double(Arguments[43])
    499680576774082295916134400.0,                                              // Double(Arguments[44])
    1243478184157339140157865984.0,                                             // Double(Arguments[45])
    8840587743209015237031231488.0,                                             // Double(Arguments[46])
    19807040619342712361531211776.0,                                            // Double(Arguments[47])
    63733365657267276355614015488.0,                                            // Double(Arguments[48])
    82261793876695337239964549120.0,                                            // Double(Arguments[49])
    779879232593610221556296843264.0,                                           // Double(Arguments[50])
    113110558780721286590576459776.0,                                           // Double(Arguments[51])
    4847586039315419747821476688953344.0,                                       // Double(Arguments[52])
    90612345123875517071501348581670912.0,                                      // Double(Arguments[53])
    85070591730234615865843651857942052864.0,                                   // Double(Arguments[54])
    85070591730234615865843651857942052864.0,                                   // Double(Arguments[55])
    680564693277057719623408366969033850880.0,                                  // Double(Arguments[56])
    18034965446809738563558854193883715207168.0,                                // Double(Arguments[57])
    1585715829851573239739325670632039865384960.0,                              // Double(Arguments[58])
    1234567890123456737673593825840554821162769359150501237866527851544576.0,   // Double(Arguments[59])
    343597383679999982609552107524812441991666411460492486506587003520286720.0, // Double(Arguments[60])
    3435973836799999833864439411668570331207020580367909909555087220424346823778176598016.0, // Double(Arguments[61])
    10000000000000.0,                                                           // Double(Arguments[62])
    1000000000000000048346692115553659057528394845890514255872.0                // Double(Arguments[63])
  );

