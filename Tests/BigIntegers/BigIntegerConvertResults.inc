  ByteArrayResults: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOk;            val: '00000000000000000000000000000000CCED'),      // Arguments[0].ToByteArray
    (info: triOk;            val: '01000000000000000000000000000000CB'),        // Arguments[1].ToByteArray
    (info: triOk;            val: 'EF6EB4A07659B348C7041328F6'),                // Arguments[2].ToByteArray
    (info: triOk;            val: '7AF13B46222F0D5192A332F6FE'),                // Arguments[3].ToByteArray
    (info: triOk;            val: '8631A02B39486123BA3C6FE3'),                  // Arguments[4].ToByteArray
    (info: triOk;            val: '42A1F9D040CBD7A785AC62FE'),                  // Arguments[5].ToByteArray
    (info: triOk;            val: 'D87BEA26285B07F94121FA'),                    // Arguments[6].ToByteArray
    (info: triOk;            val: '7C70856AA8B08AE044F0'),                      // Arguments[7].ToByteArray
    (info: triOk;            val: 'F69B3327268A8FB328FD'),                      // Arguments[8].ToByteArray
    (info: triOk;            val: 'A6F0170FDA084F9C3FFE'),                      // Arguments[9].ToByteArray
    (info: triOk;            val: 'DA186ADA5A2AB14AA5'),                        // Arguments[10].ToByteArray
    (info: triOk;            val: '6079FE'),                                    // Arguments[11].ToByteArray
    (info: triOk;            val: '104DFF'),                                    // Arguments[12].ToByteArray
    (info: triOk;            val: 'F0D8'),                                      // Arguments[13].ToByteArray
    (info: triOk;            val: '18FC'),                                      // Arguments[14].ToByteArray
    (info: triOk;            val: '9C'),                                        // Arguments[15].ToByteArray
    (info: triOk;            val: 'C8'),                                        // Arguments[16].ToByteArray
    (info: triOk;            val: 'F6'),                                        // Arguments[17].ToByteArray
    (info: triOk;            val: 'F9'),                                        // Arguments[18].ToByteArray
    (info: triOk;            val: 'FE'),                                        // Arguments[19].ToByteArray
    (info: triOk;            val: 'FF'),                                        // Arguments[20].ToByteArray
    (info: triOk;            val: '00'),                                        // Arguments[21].ToByteArray
    (info: triOk;            val: '01'),                                        // Arguments[22].ToByteArray
    (info: triOk;            val: '02'),                                        // Arguments[23].ToByteArray
    (info: triOk;            val: '07'),                                        // Arguments[24].ToByteArray
    (info: triOk;            val: '0A'),                                        // Arguments[25].ToByteArray
    (info: triOk;            val: '64'),                                        // Arguments[26].ToByteArray
    (info: triOk;            val: '9901'),                                      // Arguments[27].ToByteArray
    (info: triOk;            val: '3203'),                                      // Arguments[28].ToByteArray
    (info: triOk;            val: 'E803'),                                      // Arguments[29].ToByteArray
    (info: triOk;            val: '1027'),                                      // Arguments[30].ToByteArray
    (info: triOk;            val: 'A08601'),                                    // Arguments[31].ToByteArray
    (info: triOk;            val: '40420F'),                                    // Arguments[32].ToByteArray
    (info: triOk;            val: 'FC4DCB8D343CC43A'),                          // Arguments[33].ToByteArray
    (info: triOk;            val: '4721E743C953C34A'),                          // Arguments[34].ToByteArray
    (info: triOk;            val: '0000FEFF0000008000'),                        // Arguments[35].ToByteArray
    (info: triOk;            val: '44346F771E32165F09'),                        // Arguments[36].ToByteArray
    (info: triOk;            val: 'FFFFFFFFFFFFFFFF34'),                        // Arguments[37].ToByteArray
    (info: triOk;            val: '26E79525A5D54EB55A'),                        // Arguments[38].ToByteArray
    (info: triOk;            val: '5A0FE8F025F7B063C001'),                      // Arguments[39].ToByteArray
    (info: triOk;            val: '0A64CCD8D975704CD702'),                      // Arguments[40].ToByteArray
    (info: triOk;            val: '848F7A95574F751FBB0F'),                      // Arguments[41].ToByteArray
    (info: triOk;            val: '00000000000000003412'),                      // Arguments[42].ToByteArray
    (info: triOk;            val: '288415D9D7A4F806BEDE05'),                    // Arguments[43].ToByteArray
    (info: triOk;            val: 'BE5E062FBF3428587A539D01'),                  // Arguments[44].ToByteArray
    (info: triOk;            val: 'C665CD027AC9616FBF940404'),                  // Arguments[45].ToByteArray
    (info: triOk;            val: '7ACE5FD4C6B79EDC45C3901C'),                  // Arguments[46].ToByteArray
    (info: triOk;            val: '01000080FFFFFF7FFFFFFF3F'),                  // Arguments[47].ToByteArray
    (info: triOk;            val: '89674523018967452301EFCD00'),                // Arguments[48].ToByteArray
    (info: triOk;            val: '860EC4B9DDD0F2AE6D5CCD0901'),                // Arguments[49].ToByteArray
    (info: triOk;            val: '11914B5F89A64CB738FBECD709'),                // Arguments[50].ToByteArray
    (info: triOk;            val: 'F5756A9ACB9D2C0E7EDC7A6D01'),                // Arguments[51].ToByteArray
    (info: triOk;            val: '45230189674523018967452301EF00'),            // Arguments[52].ToByteArray
    (info: triOk;            val: 'C36684A8F7804291066FE895887311'),            // Arguments[53].ToByteArray
    (info: triOk;            val: '0100000000000000FFFFFFFFFFFFFF3F'),          // Arguments[54].ToByteArray
    (info: triOk;            val: '0200000000000000FFFFFFFFFFFFFF3F'),          // Arguments[55].ToByteArray
    (info: triOk;            val: '00000000000000000000000000FEFFFF01'),        // Arguments[56].ToByteArray
    (info: triOk;            val: 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF34'),        // Arguments[57].ToByteArray
    (info: triOk;            val: '000000000000000000000000000000003412'),      // Arguments[58].ToByteArray
    (info: triOk;            val: 'D20A3FCE96F1CFACCB9869D7C22F162FBA394466' + 
                                  '378926F42D4CECCA2D'),                        // Arguments[59].ToByteArray
    (info: triOk;            val: '2BBC42A011524BB16C6F4AD5745C81A3257CB44E' + 
                                  '9390B52A60E73BBCC831'),                      // Arguments[60].ToByteArray
    (info: triOk;            val: '00E0C09A3EDED75CA4250287D3F2B13B6B868C6E' + 
                                  'AA1139772C2D8D29569B9B34B1C8C401'),          // Arguments[61].ToByteArray
    (info: triOk;            val: '00A0724E1809'),                              // Arguments[62].ToByteArray
    (info: triOk;            val: '000000000000004A83DA4A8654CBFDEB71259AC8' + 
                                  'B57CC828')                                   // Arguments[63].ToByteArray
  );

  HexResults: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOk;            val: '-123400000000000000000000000000000000'),     // Arguments[0].ToString(16)
    (info: triOk;            val: '-34FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'),       // Arguments[1].ToString(16)
    (info: triOk;            val: '-9D7ECFB38B74CA6895F4B9111'),                // Arguments[2].ToString(16)
    (info: triOk;            val: '-109CD5C6DAEF2D0DDB9C40E86'),                // Arguments[3].ToString(16)
    (info: triOk;            val: '-1C90C345DC9EB7C6D45FCE7A'),                 // Arguments[4].ToString(16)
    (info: triOk;            val: '-19D537A582834BF2F065EBE'),                  // Arguments[5].ToString(16)
    (info: triOk;            val: '-5DEBE06F8A4D7D9158428'),                    // Arguments[6].ToString(16)
    (info: triOk;            val: '-FBB1F754F57957A8F84'),                      // Arguments[7].ToString(16)
    (info: triOk;            val: '-2D74C7075D9D8CC640A'),                      // Arguments[8].ToString(16)
    (info: triOk;            val: '-1C063B0F725F0E80F5A'),                      // Arguments[9].ToString(16)
    (info: triOk;            val: '-5AB54ED5A52595E726'),                       // Arguments[10].ToString(16)
    (info: triOk;            val: '-186A0'),                                    // Arguments[11].ToString(16)
    (info: triOk;            val: '-B2F0'),                                     // Arguments[12].ToString(16)
    (info: triOk;            val: '-2710'),                                     // Arguments[13].ToString(16)
    (info: triOk;            val: '-3E8'),                                      // Arguments[14].ToString(16)
    (info: triOk;            val: '-64'),                                       // Arguments[15].ToString(16)
    (info: triOk;            val: '-38'),                                       // Arguments[16].ToString(16)
    (info: triOk;            val: '-A'),                                        // Arguments[17].ToString(16)
    (info: triOk;            val: '-7'),                                        // Arguments[18].ToString(16)
    (info: triOk;            val: '-2'),                                        // Arguments[19].ToString(16)
    (info: triOk;            val: '-1'),                                        // Arguments[20].ToString(16)
    (info: triOk;            val: '0'),                                         // Arguments[21].ToString(16)
    (info: triOk;            val: '1'),                                         // Arguments[22].ToString(16)
    (info: triOk;            val: '2'),                                         // Arguments[23].ToString(16)
    (info: triOk;            val: '7'),                                         // Arguments[24].ToString(16)
    (info: triOk;            val: 'A'),                                         // Arguments[25].ToString(16)
    (info: triOk;            val: '64'),                                        // Arguments[26].ToString(16)
    (info: triOk;            val: '199'),                                       // Arguments[27].ToString(16)
    (info: triOk;            val: '332'),                                       // Arguments[28].ToString(16)
    (info: triOk;            val: '3E8'),                                       // Arguments[29].ToString(16)
    (info: triOk;            val: '2710'),                                      // Arguments[30].ToString(16)
    (info: triOk;            val: '186A0'),                                     // Arguments[31].ToString(16)
    (info: triOk;            val: 'F4240'),                                     // Arguments[32].ToString(16)
    (info: triOk;            val: '3AC43C348DCB4DFC'),                          // Arguments[33].ToString(16)
    (info: triOk;            val: '4AC353C943E72147'),                          // Arguments[34].ToString(16)
    (info: triOk;            val: '80000000FFFE0000'),                          // Arguments[35].ToString(16)
    (info: triOk;            val: '95F16321E776F3444'),                         // Arguments[36].ToString(16)
    (info: triOk;            val: '34FFFFFFFFFFFFFFFF'),                        // Arguments[37].ToString(16)
    (info: triOk;            val: '5AB54ED5A52595E726'),                        // Arguments[38].ToString(16)
    (info: triOk;            val: '1C063B0F725F0E80F5A'),                       // Arguments[39].ToString(16)
    (info: triOk;            val: '2D74C7075D9D8CC640A'),                       // Arguments[40].ToString(16)
    (info: triOk;            val: 'FBB1F754F57957A8F84'),                       // Arguments[41].ToString(16)
    (info: triOk;            val: '12340000000000000000'),                      // Arguments[42].ToString(16)
    (info: triOk;            val: '5DEBE06F8A4D7D9158428'),                     // Arguments[43].ToString(16)
    (info: triOk;            val: '19D537A582834BF2F065EBE'),                   // Arguments[44].ToString(16)
    (info: triOk;            val: '40494BF6F61C97A02CD65C6'),                   // Arguments[45].ToString(16)
    (info: triOk;            val: '1C90C345DC9EB7C6D45FCE7A'),                  // Arguments[46].ToString(16)
    (info: triOk;            val: '3FFFFFFF7FFFFFFF80000001'),                  // Arguments[47].ToString(16)
    (info: triOk;            val: 'CDEF01234567890123456789'),                  // Arguments[48].ToString(16)
    (info: triOk;            val: '109CD5C6DAEF2D0DDB9C40E86'),                 // Arguments[49].ToString(16)
    (info: triOk;            val: '9D7ECFB38B74CA6895F4B9111'),                 // Arguments[50].ToString(16)
    (info: triOk;            val: '16D7ADC7E0E2C9DCB9A6A75F5'),                 // Arguments[51].ToString(16)
    (info: triOk;            val: 'EF01234567890123456789012345'),              // Arguments[52].ToString(16)
    (info: triOk;            val: '11738895E86F06914280F7A88466C3'),            // Arguments[53].ToString(16)
    (info: triOk;            val: '3FFFFFFFFFFFFFFF0000000000000001'),          // Arguments[54].ToString(16)
    (info: triOk;            val: '3FFFFFFFFFFFFFFF0000000000000002'),          // Arguments[55].ToString(16)
    (info: triOk;            val: '1FFFFFE00000000000000000000000000'),         // Arguments[56].ToString(16)
    (info: triOk;            val: '34FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'),        // Arguments[57].ToString(16)
    (info: triOk;            val: '123400000000000000000000000000000000'),      // Arguments[58].ToString(16)
    (info: triOk;            val: '2DCAEC4C2DF4268937664439BA2F162FC2D76998' + 
                                  'CBACCFF196CE3F0AD2'),                        // Arguments[59].ToString(16)
    (info: triOk;            val: '31C8BC3BE7602AB590934EB47C25A3815C74D54A' + 
                                  '6F6CB14B5211A042BC2B'),                      // Arguments[60].ToString(16)
    (info: triOk;            val: '1C4C8B1349B9B56298D2D2C773911AA6E8C866B3' + 
                                  'BB1F2D3870225A45CD7DE3E9AC0E000'),           // Arguments[61].ToString(16)
    (info: triOk;            val: '9184E72A000'),                               // Arguments[62].ToString(16)
    (info: triOk;            val: '28C87CB5C89A2571EBFDCB54864ADA834A000000' + 
                                  '00000000')                                   // Arguments[63].ToString(16)
  );

  AsIntegerResults: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOverflow;      val: ''),                                          // Arguments[0].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[1].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[2].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[3].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[4].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[5].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[6].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[7].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[8].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[9].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[10].AsInteger
    (info: triOk;            val: '-100000'),                                   // Arguments[11].AsInteger
    (info: triOk;            val: '-45808'),                                    // Arguments[12].AsInteger
    (info: triOk;            val: '-10000'),                                    // Arguments[13].AsInteger
    (info: triOk;            val: '-1000'),                                     // Arguments[14].AsInteger
    (info: triOk;            val: '-100'),                                      // Arguments[15].AsInteger
    (info: triOk;            val: '-56'),                                       // Arguments[16].AsInteger
    (info: triOk;            val: '-10'),                                       // Arguments[17].AsInteger
    (info: triOk;            val: '-7'),                                        // Arguments[18].AsInteger
    (info: triOk;            val: '-2'),                                        // Arguments[19].AsInteger
    (info: triOk;            val: '-1'),                                        // Arguments[20].AsInteger
    (info: triOk;            val: '0'),                                         // Arguments[21].AsInteger
    (info: triOk;            val: '1'),                                         // Arguments[22].AsInteger
    (info: triOk;            val: '2'),                                         // Arguments[23].AsInteger
    (info: triOk;            val: '7'),                                         // Arguments[24].AsInteger
    (info: triOk;            val: '10'),                                        // Arguments[25].AsInteger
    (info: triOk;            val: '100'),                                       // Arguments[26].AsInteger
    (info: triOk;            val: '409'),                                       // Arguments[27].AsInteger
    (info: triOk;            val: '818'),                                       // Arguments[28].AsInteger
    (info: triOk;            val: '1000'),                                      // Arguments[29].AsInteger
    (info: triOk;            val: '10000'),                                     // Arguments[30].AsInteger
    (info: triOk;            val: '100000'),                                    // Arguments[31].AsInteger
    (info: triOk;            val: '1000000'),                                   // Arguments[32].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[33].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[34].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[35].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[36].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[37].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[38].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[39].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[40].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[41].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[42].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[43].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[44].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[45].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[46].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[47].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[48].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[49].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[50].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[51].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[52].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[53].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[54].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[55].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[56].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[57].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[58].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[59].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[60].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[61].AsInteger
    (info: triOverflow;      val: ''),                                          // Arguments[62].AsInteger
    (info: triOverflow;      val: '')                                           // Arguments[63].AsInteger
  );

  AsCardinalResults: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOverflow;      val: ''),                                          // Arguments[0].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[1].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[2].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[3].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[4].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[5].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[6].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[7].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[8].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[9].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[10].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[11].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[12].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[13].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[14].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[15].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[16].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[17].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[18].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[19].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[20].AsCardinal
    (info: triOk;            val: '0'),                                         // Arguments[21].AsCardinal
    (info: triOk;            val: '1'),                                         // Arguments[22].AsCardinal
    (info: triOk;            val: '2'),                                         // Arguments[23].AsCardinal
    (info: triOk;            val: '7'),                                         // Arguments[24].AsCardinal
    (info: triOk;            val: '10'),                                        // Arguments[25].AsCardinal
    (info: triOk;            val: '100'),                                       // Arguments[26].AsCardinal
    (info: triOk;            val: '409'),                                       // Arguments[27].AsCardinal
    (info: triOk;            val: '818'),                                       // Arguments[28].AsCardinal
    (info: triOk;            val: '1000'),                                      // Arguments[29].AsCardinal
    (info: triOk;            val: '10000'),                                     // Arguments[30].AsCardinal
    (info: triOk;            val: '100000'),                                    // Arguments[31].AsCardinal
    (info: triOk;            val: '1000000'),                                   // Arguments[32].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[33].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[34].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[35].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[36].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[37].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[38].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[39].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[40].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[41].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[42].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[43].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[44].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[45].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[46].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[47].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[48].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[49].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[50].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[51].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[52].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[53].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[54].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[55].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[56].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[57].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[58].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[59].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[60].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[61].AsCardinal
    (info: triOverflow;      val: ''),                                          // Arguments[62].AsCardinal
    (info: triOverflow;      val: '')                                           // Arguments[63].AsCardinal
  );

  AsInt64Results: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOverflow;      val: ''),                                          // Arguments[0].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[1].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[2].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[3].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[4].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[5].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[6].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[7].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[8].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[9].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[10].AsInt64
    (info: triOk;            val: '-100000'),                                   // Arguments[11].AsInt64
    (info: triOk;            val: '-45808'),                                    // Arguments[12].AsInt64
    (info: triOk;            val: '-10000'),                                    // Arguments[13].AsInt64
    (info: triOk;            val: '-1000'),                                     // Arguments[14].AsInt64
    (info: triOk;            val: '-100'),                                      // Arguments[15].AsInt64
    (info: triOk;            val: '-56'),                                       // Arguments[16].AsInt64
    (info: triOk;            val: '-10'),                                       // Arguments[17].AsInt64
    (info: triOk;            val: '-7'),                                        // Arguments[18].AsInt64
    (info: triOk;            val: '-2'),                                        // Arguments[19].AsInt64
    (info: triOk;            val: '-1'),                                        // Arguments[20].AsInt64
    (info: triOk;            val: '0'),                                         // Arguments[21].AsInt64
    (info: triOk;            val: '1'),                                         // Arguments[22].AsInt64
    (info: triOk;            val: '2'),                                         // Arguments[23].AsInt64
    (info: triOk;            val: '7'),                                         // Arguments[24].AsInt64
    (info: triOk;            val: '10'),                                        // Arguments[25].AsInt64
    (info: triOk;            val: '100'),                                       // Arguments[26].AsInt64
    (info: triOk;            val: '409'),                                       // Arguments[27].AsInt64
    (info: triOk;            val: '818'),                                       // Arguments[28].AsInt64
    (info: triOk;            val: '1000'),                                      // Arguments[29].AsInt64
    (info: triOk;            val: '10000'),                                     // Arguments[30].AsInt64
    (info: triOk;            val: '100000'),                                    // Arguments[31].AsInt64
    (info: triOk;            val: '1000000'),                                   // Arguments[32].AsInt64
    (info: triOk;            val: '4234575746049986044'),                       // Arguments[33].AsInt64
    (info: triOk;            val: '5387241703157997895'),                       // Arguments[34].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[35].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[36].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[37].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[38].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[39].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[40].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[41].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[42].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[43].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[44].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[45].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[46].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[47].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[48].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[49].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[50].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[51].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[52].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[53].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[54].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[55].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[56].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[57].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[58].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[59].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[60].AsInt64
    (info: triOverflow;      val: ''),                                          // Arguments[61].AsInt64
    (info: triOk;            val: '10000000000000'),                            // Arguments[62].AsInt64
    (info: triOverflow;      val: '')                                           // Arguments[63].AsInt64
  );

  AsUInt64Results: array[0.. TestCount - 1] of TTestResult =
  (
    (info: triOverflow;      val: ''),                                          // Arguments[0].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[1].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[2].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[3].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[4].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[5].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[6].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[7].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[8].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[9].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[10].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[11].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[12].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[13].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[14].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[15].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[16].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[17].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[18].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[19].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[20].AsUInt64
    (info: triOk;            val: '0'),                                         // Arguments[21].AsUInt64
    (info: triOk;            val: '1'),                                         // Arguments[22].AsUInt64
    (info: triOk;            val: '2'),                                         // Arguments[23].AsUInt64
    (info: triOk;            val: '7'),                                         // Arguments[24].AsUInt64
    (info: triOk;            val: '10'),                                        // Arguments[25].AsUInt64
    (info: triOk;            val: '100'),                                       // Arguments[26].AsUInt64
    (info: triOk;            val: '409'),                                       // Arguments[27].AsUInt64
    (info: triOk;            val: '818'),                                       // Arguments[28].AsUInt64
    (info: triOk;            val: '1000'),                                      // Arguments[29].AsUInt64
    (info: triOk;            val: '10000'),                                     // Arguments[30].AsUInt64
    (info: triOk;            val: '100000'),                                    // Arguments[31].AsUInt64
    (info: triOk;            val: '1000000'),                                   // Arguments[32].AsUInt64
    (info: triOk;            val: '4234575746049986044'),                       // Arguments[33].AsUInt64
    (info: triOk;            val: '5387241703157997895'),                       // Arguments[34].AsUInt64
    (info: triOk;            val: '9223372041149612032'),                       // Arguments[35].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[36].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[37].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[38].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[39].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[40].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[41].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[42].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[43].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[44].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[45].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[46].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[47].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[48].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[49].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[50].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[51].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[52].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[53].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[54].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[55].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[56].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[57].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[58].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[59].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[60].AsUInt64
    (info: triOverflow;      val: ''),                                          // Arguments[61].AsUInt64
    (info: triOk;            val: '10000000000000'),                            // Arguments[62].AsUInt64
    (info: triOverflow;      val: '')                                           // Arguments[63].AsUInt64
  );


  CreateDoubleResults: array[0..DoubleCount - 1] of TTestResult =
  (
    (info: triOk;            val: '-600000000000000000000'),                    // BigInteger.Create(-6E+20)
    (info: triOk;            val: '-100000000000000000000'),                    // BigInteger.Create(-1E+20)
    (info: triOk;            val: '-3'),                                        // BigInteger.Create(-3.51)
    (info: triOk;            val: '-3'),                                        // BigInteger.Create(-3.5)
    (info: triOk;            val: '-3'),                                        // BigInteger.Create(-3.49)
    (info: triOk;            val: '-2'),                                        // BigInteger.Create(-2.51)
    (info: triOk;            val: '-2'),                                        // BigInteger.Create(-2.5)
    (info: triOk;            val: '-2'),                                        // BigInteger.Create(-2.49)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(-2E-100)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(7E-08)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.0001)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.1)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.2)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.3)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.4)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.49999999999999)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.5)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.50000001)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.7)
    (info: triOk;            val: '0'),                                         // BigInteger.Create(0.9)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.00000000000001)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.1)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.49999999999999)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.5)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.50000000000001)
    (info: triOk;            val: '1'),                                         // BigInteger.Create(1.9999)
    (info: triOk;            val: '2'),                                         // BigInteger.Create(2)
    (info: triOk;            val: '2'),                                         // BigInteger.Create(2.49)
    (info: triOk;            val: '2'),                                         // BigInteger.Create(2.5)
    (info: triOk;            val: '2'),                                         // BigInteger.Create(2.51)
    (info: triOk;            val: '3'),                                         // BigInteger.Create(3)
    (info: triOk;            val: '3'),                                         // BigInteger.Create(3.49)
    (info: triOk;            val: '3'),                                         // BigInteger.Create(3.5)
    (info: triOk;            val: '3'),                                         // BigInteger.Create(3.51)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.1)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.2)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.4)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.5)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.6)
    (info: triOk;            val: '4'),                                         // BigInteger.Create(4.9999)
    (info: triOk;            val: '5'),                                         // BigInteger.Create(5)
    (info: triOk;            val: '6'),                                         // BigInteger.Create(6)
    (info: triOk;            val: '7'),                                         // BigInteger.Create(7)
    (info: triOk;            val: '8'),                                         // BigInteger.Create(8)
    (info: triOk;            val: '9'),                                         // BigInteger.Create(9)
    (info: triOk;            val: '10'),                                        // BigInteger.Create(10)
    (info: triOk;            val: '15'),                                        // BigInteger.Create(15)
    (info: triOk;            val: '22'),                                        // BigInteger.Create(22)
    (info: triOk;            val: '44'),                                        // BigInteger.Create(44)
    (info: triOk;            val: '85'),                                        // BigInteger.Create(85)
    (info: triOk;            val: '128'),                                       // BigInteger.Create(128)
    (info: triOk;            val: '256'),                                       // BigInteger.Create(256)
    (info: triOk;            val: '256'),                                       // BigInteger.Create(256.1)
    (info: triOk;            val: '256'),                                       // BigInteger.Create(256.5)
    (info: triOk;            val: '256'),                                       // BigInteger.Create(256.7)
    (info: triOk;            val: '300'),                                       // BigInteger.Create(300)
    (info: triOk;            val: '876'),                                       // BigInteger.Create(876.543210987654)
    (info: triOk;            val: '645000'),                                    // BigInteger.Create(645000)
    (info: triOk;            val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (info: triOk;            val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (info: triOk;            val: '1000000'),                                   // BigInteger.Create(1000000.5)
    (info: triOk;            val: '1048576'),                                   // BigInteger.Create(1048576.1)
    (info: triOk;            val: '1048576'),                                   // BigInteger.Create(1048576.5)
    (info: triOk;            val: '10000000000'),                               // BigInteger.Create(10000000000)
    (info: triOk;            val: '14900000000'),                               // BigInteger.Create(14900000000)
    (info: triOk;            val: '15000000000'),                               // BigInteger.Create(15000000000)
    (info: triOk;            val: '15100000000'),                               // BigInteger.Create(15100000000)
    (info: triOk;            val: '31415920000'),                               // BigInteger.Create(31415920000)
    (info: triOk;            val: '100000000000'),                              // BigInteger.Create(100000000000)
    (info: triOk;            val: '1000000000000'),                             // BigInteger.Create(1000000000000)
    (info: triOk;            val: '10000000000000'),                            // BigInteger.Create(10000000000000)
    (info: triOk;            val: '100000000000000'),                           // BigInteger.Create(100000000000000)
    (info: triOk;            val: '1000000000000000'),                          // BigInteger.Create(1E+15)
    (info: triOk;            val: '2000000000000000'),                          // BigInteger.Create(2E+15)
    (info: triOk;            val: '4000000000000000'),                          // BigInteger.Create(4E+15)
    (info: triOk;            val: '4900000000000000'),                          // BigInteger.Create(4.9E+15)
    (info: triOk;            val: '8000000000000000'),                          // BigInteger.Create(8E+15)
    (info: triOk;            val: '10000000000000000'),                         // BigInteger.Create(1E+16)
    (info: triOk;            val: '20000000000000000'),                         // BigInteger.Create(2E+16)
    (info: triOk;            val: '40000000000000000'),                         // BigInteger.Create(4E+16)
    (info: triOk;            val: '50000000000000000'),                         // BigInteger.Create(5E+16)
    (info: triOk;            val: '100000000000000000'),                        // BigInteger.Create(1E+17)
    (info: triOk;            val: '1000000000000000000'),                       // BigInteger.Create(1E+18)
    (info: triOk;            val: '10000000000000000000'),                      // BigInteger.Create(1E+19)
    (info: triOk;            val: '12345678901234599936'),                      // BigInteger.Create(1.23456789012346E+19)
    (info: triOk;            val: '100000000000000000000'),                     // BigInteger.Create(1E+20)
    (info: triOk;            val: '100000000000001'),                           // BigInteger.Create(100000000000001)
    (info: triOk;            val: '100000000000002'),                           // BigInteger.Create(100000000000002)
    (info: triOk;            val: '100000000000004'),                           // BigInteger.Create(100000000000004)
    (info: triOk;            val: '100000000000008'),                           // BigInteger.Create(100000000000008)
    (info: triOk;            val: '100000000000016'),                           // BigInteger.Create(100000000000016)
    (info: triOk;            val: '100000000000032'),                           // BigInteger.Create(100000000000032)
    (info: triOk;            val: '100000000000064'),                           // BigInteger.Create(100000000000064)
    (info: triOk;            val: '100000000000128'),                           // BigInteger.Create(100000000000128)
    (info: triOk;            val: '100000000000256'),                           // BigInteger.Create(100000000000256)
    (info: triOk;            val: '100000000000512'),                           // BigInteger.Create(100000000000512)
    (info: triOk;            val: '1000000000000000000266098647083672765374' + 
                                  '0240118120080909813197745348975891631308' + 
                                  '8')                                          // BigInteger.Create(1E+80)
  );

  DoubleResults: array[0.. TestCount - 1] of Double =
  (
    -1585715829851573239739325670632039865384960.0,                             // Double(Arguments[0])
    -18034965446809736145707214964625365794816.0,                               // Double(Arguments[1])
    -779879232593610221556296843264.0,                                          // Double(Arguments[2])
    -82261793876695337239964549120.0,                                           // Double(Arguments[3])
    -8840587743209014137519603712.0,                                            // Double(Arguments[4])
    -499680576774082227196657664.0,                                             // Double(Arguments[5])
    -7096499840976816923738112.0,                                               // Double(Arguments[6])
    -74287305190053395824640.0,                                                 // Double(Arguments[7])
    -13416290973509622956032.0,                                                 // Double(Arguments[8])
    -8271324858169862127616.0,                                                  // Double(Arguments[9])
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
    4234575746049985536.0,                                                      // Double(Arguments[33])
    5387241703157997568.0,                                                      // Double(Arguments[34])
    9223372041149612032.0,                                                      // Double(Arguments[35])
    172872415652910923776.0,                                                    // Double(Arguments[36])
    977677435906606104576.0,                                                    // Double(Arguments[37])
    1673271581108184809472.0,                                                   // Double(Arguments[38])
    8271324858169862127616.0,                                                   // Double(Arguments[39])
    13416290973509622956032.0,                                                  // Double(Arguments[40])
    74287305190053395824640.0,                                                  // Double(Arguments[41])
    85961827383486510530560.0,                                                  // Double(Arguments[42])
    7096499840976816923738112.0,                                                // Double(Arguments[43])
    499680576774082227196657664.0,                                              // Double(Arguments[44])
    1243478184157338865279959040.0,                                             // Double(Arguments[45])
    8840587743209014137519603712.0,                                             // Double(Arguments[46])
    19807040619342710162507956224.0,                                            // Double(Arguments[47])
    63733365657267276355614015488.0,                                            // Double(Arguments[48])
    82261793876695337239964549120.0,                                            // Double(Arguments[49])
    779879232593610221556296843264.0,                                           // Double(Arguments[50])
    113110558780721268998390415360.0,                                           // Double(Arguments[51])
    4847586039315419747821476688953344.0,                                       // Double(Arguments[52])
    90612345123875498624757274872119296.0,                                      // Double(Arguments[53])
    85070591730234606421110686118651625472.0,                                   // Double(Arguments[54])
    85070591730234606421110686118651625472.0,                                   // Double(Arguments[55])
    680564693277057719623408366969033850880.0,                                  // Double(Arguments[56])
    18034965446809736145707214964625365794816.0,                                // Double(Arguments[57])
    1585715829851573239739325670632039865384960.0,                              // Double(Arguments[58])
    1234567890123456737673593825840554821162769359150501237866527851544576.0,   // Double(Arguments[59])
    343597383679999982609552107524812441991666411460492486506587003520286720.0, // Double(Arguments[60])
    3435973836799999833864439411668570331207020580367909909555087220424346823778176598016.0,// Double(Arguments[61])
    10000000000000.0,                                                           // Double(Arguments[62])
    999999999999999874122120252033165764280595840825189990400.0                 // Double(Arguments[63])
  );

