{$IF CompilerVersion < 29.0}
  {$IF (DEFINED(WIN32) or DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}
    {$DEFINE CPU32BITS}
  {$IFEND}
  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}
    {$DEFINE CPU64BITS}
  {$IFEND}
{$IFEND}

const
  CMaxFactorShift = 24;
{$IFDEF CPU64BITS}
  // Maximum powers of given bases that fit into UInt64
  CBaseInfos: array[TNumberBase] of BigInteger.TNumberBaseInfo = 
  (
    (MaxPower:  9223372036854775808; MaxDigits: 63; PowerofTwo:  True; MaxFactor: 266305),  // Base 2
    (MaxPower: 12157665459056928801; MaxDigits: 40; PowerofTwo: False; MaxFactor: 264631),  // Base 3
    (MaxPower:  4611686018427387904; MaxDigits: 31; PowerofTwo:  True; MaxFactor: 270600),  // Base 4
    (MaxPower:  7450580596923828125; MaxDigits: 27; PowerofTwo: False; MaxFactor: 267613),  // Base 5
    (MaxPower:  4738381338321616896; MaxDigits: 24; PowerofTwo: False; MaxFactor: 270430),  // Base 6
    (MaxPower:  3909821048582988049; MaxDigits: 22; PowerofTwo: False; MaxFactor: 271644),  // Base 7
    (MaxPower:  9223372036854775808; MaxDigits: 21; PowerofTwo:  True; MaxFactor: 266305),  // Base 8
    (MaxPower: 12157665459056928801; MaxDigits: 20; PowerofTwo: False; MaxFactor: 264631),  // Base 9
    (MaxPower: 10000000000000000000; MaxDigits: 19; PowerofTwo: False; MaxFactor: 265813),  // Base 10
    (MaxPower:  5559917313492231481; MaxDigits: 18; PowerofTwo: False; MaxFactor: 269428),  // Base 11
    (MaxPower:  2218611106740436992; MaxDigits: 17; PowerofTwo: False; MaxFactor: 275287),  // Base 12
    (MaxPower:  8650415919381337933; MaxDigits: 17; PowerofTwo: False; MaxFactor: 266697),  // Base 13
    (MaxPower:  2177953337809371136; MaxDigits: 16; PowerofTwo: False; MaxFactor: 275408),  // Base 14
    (MaxPower:  6568408355712890625; MaxDigits: 16; PowerofTwo: False; MaxFactor: 268391),  // Base 15
    (MaxPower:  1152921504606846976; MaxDigits: 15; PowerofTwo:  True; MaxFactor: 279620),  // Base 16
    (MaxPower:  2862423051509815793; MaxDigits: 15; PowerofTwo: False; MaxFactor: 273637),  // Base 17
    (MaxPower:  6746640616477458432; MaxDigits: 15; PowerofTwo: False; MaxFactor: 268226),  // Base 18
    (MaxPower: 15181127029874798299; MaxDigits: 15; PowerofTwo: False; MaxFactor: 263300),  // Base 19
    (MaxPower:  1638400000000000000; MaxDigits: 14; PowerofTwo: False; MaxFactor: 277277),  // Base 20
    (MaxPower:  3243919932521508681; MaxDigits: 14; PowerofTwo: False; MaxFactor: 272834),  // Base 21
    (MaxPower:  6221821273427820544; MaxDigits: 14; PowerofTwo: False; MaxFactor: 268728),  // Base 22
    (MaxPower: 11592836324538749809; MaxDigits: 14; PowerofTwo: False; MaxFactor: 264918),  // Base 23
    (MaxPower:   876488338465357824; MaxDigits: 13; PowerofTwo: False; MaxFactor: 281476),  // Base 24
    (MaxPower:  1490116119384765625; MaxDigits: 13; PowerofTwo: False; MaxFactor: 277906),  // Base 25
    (MaxPower:  2481152873203736576; MaxDigits: 13; PowerofTwo: False; MaxFactor: 274560),  // Base 26
    (MaxPower:  4052555153018976267; MaxDigits: 13; PowerofTwo: False; MaxFactor: 271417),  // Base 27
    (MaxPower:  6502111422497947648; MaxDigits: 13; PowerofTwo: False; MaxFactor: 268454),  // Base 28
    (MaxPower: 10260628712958602189; MaxDigits: 13; PowerofTwo: False; MaxFactor: 265657),  // Base 29
    (MaxPower: 15943230000000000000; MaxDigits: 13; PowerofTwo: False; MaxFactor: 263009),  // Base 30
    (MaxPower:   787662783788549761; MaxDigits: 12; PowerofTwo: False; MaxFactor: 282205),  // Base 31
    (MaxPower:  1152921504606846976; MaxDigits: 12; PowerofTwo:  True; MaxFactor: 279620),  // Base 32
    (MaxPower:  1667889514952984961; MaxDigits: 12; PowerofTwo: False; MaxFactor: 277159),  // Base 33
    (MaxPower:  2386420683693101056; MaxDigits: 12; PowerofTwo: False; MaxFactor: 274813),  // Base 34
    (MaxPower:  3379220508056640625; MaxDigits: 12; PowerofTwo: False; MaxFactor: 272572),  // Base 35
    (MaxPower:  4738381338321616896; MaxDigits: 12; PowerofTwo: False; MaxFactor: 270430)   // Base 36
  );
{$ELSE}
  // Maximum powers of given bases that fit into UInt32
  CBaseInfos: array[TNumberBase] of BigInteger.TNumberBaseInfo = 
  (
    (MaxPower:           2147483648; MaxDigits: 31; PowerofTwo:  True; MaxFactor: 541201),  // Base 2
    (MaxPower:           3486784401; MaxDigits: 20; PowerofTwo: False; MaxFactor: 529262),  // Base 3
    (MaxPower:           1073741824; MaxDigits: 15; PowerofTwo:  True; MaxFactor: 559241),  // Base 4
    (MaxPower:           1220703125; MaxDigits: 13; PowerofTwo: False; MaxFactor: 555812),  // Base 5
    (MaxPower:           2176782336; MaxDigits: 12; PowerofTwo: False; MaxFactor: 540859),  // Base 6
    (MaxPower:           1977326743; MaxDigits: 11; PowerofTwo: False; MaxFactor: 543288),  // Base 7
    (MaxPower:           1073741824; MaxDigits: 10; PowerofTwo:  True; MaxFactor: 559241),  // Base 8
    (MaxPower:           3486784401; MaxDigits: 10; PowerofTwo: False; MaxFactor: 529262),  // Base 9
    (MaxPower:           1000000000; MaxDigits:  9; PowerofTwo: False; MaxFactor: 561161),  // Base 10
    (MaxPower:           2357947691; MaxDigits:  9; PowerofTwo: False; MaxFactor: 538856),  // Base 11
    (MaxPower:            429981696; MaxDigits:  8; PowerofTwo: False; MaxFactor: 584986),  // Base 12
    (MaxPower:            815730721; MaxDigits:  8; PowerofTwo: False; MaxFactor: 566730),  // Base 13
    (MaxPower:           1475789056; MaxDigits:  8; PowerofTwo: False; MaxFactor: 550816),  // Base 14
    (MaxPower:           2562890625; MaxDigits:  8; PowerofTwo: False; MaxFactor: 536783),  // Base 15
    (MaxPower:            268435456; MaxDigits:  7; PowerofTwo:  True; MaxFactor: 599186),  // Base 16
    (MaxPower:            410338673; MaxDigits:  7; PowerofTwo: False; MaxFactor: 586365),  // Base 17
    (MaxPower:            612220032; MaxDigits:  7; PowerofTwo: False; MaxFactor: 574769),  // Base 18
    (MaxPower:            893871739; MaxDigits:  7; PowerofTwo: False; MaxFactor: 564215),  // Base 19
    (MaxPower:           1280000000; MaxDigits:  7; PowerofTwo: False; MaxFactor: 554555),  // Base 20
    (MaxPower:           1801088541; MaxDigits:  7; PowerofTwo: False; MaxFactor: 545668),  // Base 21
    (MaxPower:           2494357888; MaxDigits:  7; PowerofTwo: False; MaxFactor: 537455),  // Base 22
    (MaxPower:           3404825447; MaxDigits:  7; PowerofTwo: False; MaxFactor: 529836),  // Base 23
    (MaxPower:            191102976; MaxDigits:  6; PowerofTwo: False; MaxFactor: 609864),  // Base 24
    (MaxPower:            244140625; MaxDigits:  6; PowerofTwo: False; MaxFactor: 602129),  // Base 25
    (MaxPower:            308915776; MaxDigits:  6; PowerofTwo: False; MaxFactor: 594881),  // Base 26
    (MaxPower:            387420489; MaxDigits:  6; PowerofTwo: False; MaxFactor: 588069),  // Base 27
    (MaxPower:            481890304; MaxDigits:  6; PowerofTwo: False; MaxFactor: 581651),  // Base 28
    (MaxPower:            594823321; MaxDigits:  6; PowerofTwo: False; MaxFactor: 575589),  // Base 29
    (MaxPower:            729000000; MaxDigits:  6; PowerofTwo: False; MaxFactor: 569852),  // Base 30
    (MaxPower:            887503681; MaxDigits:  6; PowerofTwo: False; MaxFactor: 564411),  // Base 31
    (MaxPower:           1073741824; MaxDigits:  6; PowerofTwo:  True; MaxFactor: 559241),  // Base 32
    (MaxPower:           1291467969; MaxDigits:  6; PowerofTwo: False; MaxFactor: 554319),  // Base 33
    (MaxPower:           1544804416; MaxDigits:  6; PowerofTwo: False; MaxFactor: 549626),  // Base 34
    (MaxPower:           1838265625; MaxDigits:  6; PowerofTwo: False; MaxFactor: 545145),  // Base 35
    (MaxPower:           2176782336; MaxDigits:  6; PowerofTwo: False; MaxFactor: 540859)   // Base 36
  );
{$ENDIF}

