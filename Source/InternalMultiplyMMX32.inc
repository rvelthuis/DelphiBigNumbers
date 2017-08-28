


(*
    Let's assume that LSize >= RSize. If not, we swap Left and Right and LSize and RSize so it becomes true.
    The following code should do, more or less, the following:
    1. Do the first row and move to result
       get excess nubmer of limbs and save that result. Use that for the tail.
        MOV MM7,[Right]
        loop:
        MOV     MM0,[Left]
        MOV     MM1,[Left + 1] // [ESI + CLimbSize]
        MOV     MM2,[Left + 2]
        MOV     MM3,[Left + 3]
        PMULUDQ MM0,MM7
        PMULUDQ MM1,MM7
        PMULUDQ MM2,MM7
        PMULUDQ MM3,MM7
        MOV     [Result],MM0
        PSRLQ   MM0,32
        PADDQ   MM1,MM0
        MOV     [Result + 1],MM1
        PSRLQ   MM1,32
        PADDQ   MM2,MM1
        MOV     [Result + 2],MM2
        PSRLQ   MM2,32
        PADDQ   MM3,MM2
        MOV     [Result + 3],MM3
        PSRLQ   MM3,32
        Increment Left by 4 // 4 * CLimbSize
        Increment Result by 4 // 4 * ClimbSize
        Decrement loop counter by 4
        Loop if not 0

    1a. Do Tail.

       The above should be shuffled to remove dependencies. It might make sense to use one register, e.g.
       MM6, to hold the carry. So instead of PSRLQ MM0,32; PADDQ MM1,MM0, we do: PSRLQ MM6; PADDQ MM6,MM0 etc.

    2. Do the other rows and add to result, row-wise. Each time, the row is multiplied with anoher limb of the smaller array.

       Do something similar as point 1, but add in the already stored results, for the rest of the Right limbs.
       Perhaps MM5 can be used to load the existing limbs and ad them in. Shuffle again to remove dependencies.

    3. Do the tail. GMP uses four different sequences for each possible tail: 0, 1, 2 and 3, fusing them with point 2. I'm not sure if I should.

    4. Special cases for LSize = 1, 2, 3.
*)


class procedure BigInteger.InternalMultiplyMMX(Left, Right, Result: PLimb; LSize, RSize: Integer);
//
// EAX = Left
// EDX = Right
// ECX = Result
// LSize, RSize: on stack
//
var
  SaveResult: PLimb;
  LRest, LCount: Integer;
  PRight, PDestRowStart: PLimb;
  LLeft, LRight: PLimb;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX

        // $$RV: Remove the shuffling -- rename registers later on
                            // EAX = Left
        MOV     ESI,EDX     // ESI = Right
        MOV     EDX,ECX     // EDX = Result
        MOV     ECX,LSize   // ECX = LSize
        MOV     EBX,RSize   // EBX = RSize
        MOV     SaveResult,EDX
        MOV     LLeft,EAX
        MOV     LRight,ESI

        // LSize must be > RSize. If not, swap
        CMP     ECX,EBX
        JNB     @SkipSwap
        XCHG    EAX,ESI
        XCHG    EBX,ECX

@SkipSwap:
        MOV     MM7,DWORD PTR [ESI]                     // Right[0]

        CMP     ECX,3
        JA      @Big
        MOV     MM6,DWORD PTR [EAX]                     // Left[0]
        PMULUDQ MM6,MM7                                 // Lf0 * Rg0
        JE      @un3
        CMP     ECX,2
        JE      @un2

@un1:   // Both 1 limb
        MOV     DWORD PTR [EDX],MM6                     // Result[0]
        PSRLQ   MM6,32
        MOV     DWORD PTR [EDX+CLimbSize],MM6           // Result[1]
        JMP     @Exit

@un2:
        // Longest ist 2 limbs.

        // First part:
        //                   [ Lf1 ][ Lf0 ]             // Lf = Left
        //                          [ Rg0 ]             // Rg = Right
        //                   -------------- x
        //                   [  Lf0 * Rg0 ]
        //            [  Lf1 * Rg0 ]
        //            --------------------- +
        //            [ Rs2 ][ Rs1 ][ Rs0 ]             // Rs = Result

        MOV     MM1,DWORD PTR [EAX + CLimbSize]         // MM1 = Lf1 (MM7 = Rg1)
        PMULUDQ MM1,MM7                                 // MM1 = Lf1 * Rg0
        MOV     DWORD PTR [EDX],MM6                     // Rs0 = Lo(Lf0 * Rg0)
        PSRLQ   MM6,32
        PADDQ   MM6,MM1                                 // MM6 = Hi(Lf0 * Rg0) + Lf1 * Rg0
        MOV     DWORD PTR [EDX+CLimbSize],MM6           // Rs1 = Lo(MM6)
        PSRLQ   MM6,32
        MOV     DWORD PTR [EDX+2*CLimbSize],MM6         // Rs2 = Hi(MM6)
        DEC     EBX                                     // RSize > 1?
        JZ      @Exit

        // Second part (if RSize > 1):
        //                    [ Lf1 ][ Lf0 ]
        //                    [ Rg1 ]
        //                    -------------- x
        //             [ Rs2 ][ Rs1 ][ Rs0 ]            // See first part
        //             [  Lf0 * Rg1 ]
        //      [  Lf1 * Rg1 ]
        //      ---------------------------- +
        //      [ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]


        MOV     MM7,DWORD PTR [ESI+CLimbSize]           // MM7 = Rg1
        MOV     MM6,DWORD PTR [EAX]                     // MM6 = Lf0
        PMULUDQ MM6,MM7                                 // MM6 = Rg1 * Lf0
        MOV     MM1,DWORD PTR [EAX+CLimbSize]           // MM1 = Lf1
        MOV     MM4,DWORD PTR [EDX+CLimbSize]           // MM4 = Rs1
        PMULUDQ MM1,MM7                                 // MM1 = Lf1 * Rg1
        MOV     MM5,DWORD PTR [EDX+2*CLimbSize]         // MM5 = Rs2
        PADDQ   MM6,MM4                                 // MM6 = Lf0 * Rg1 + Rs1
        PADDQ   MM1,MM5                                 // MM1 = Lf1 * Rg1 + Rs2
        MOV     DWORD PTR [EDX+CLimbSize],MM6           // Rs1 = Lo(MM6)
        PSRLQ   MM6,32                                  // MM6 = Hi(Lf0 * Rg1 + Rs1)
        PADDQ   MM6,MM5                                 // MM6 = Hi(Lf0 * Rg1 + Rs1) + Rs2
        MOV     DWORD PTR [EDX+2*CLimbSize],MM6         // Rs2 = Lo(MM6)
        PSRLQ   MM6,32                                  //
        MOV     DWORD PTR [EDX+3*CLimbSize],MM6         // Rs3 = Hi(MM6)
        JMP     @Exit

@un3:

        // Longest is 3 limbs.

        // First part:
        //                      [ Lf2 ][ Lf1 ][ Lf0 ]
        //                                    [ Rg0 ]
        //                      --------------------- x
        //                             [  Lf0 * Rg0 ]
        //                      [  Lf1 * Rg0 ]
        //               [  Lf2 * Rg0 ]
        //               ---------------------------- +
        //               [ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]

        MOV     MM1,DWORD PTR [EAX+CLimbSize]
        PMULUDQ MM1,MM7
        MOV     MM2,DWORD PTR [EAX+2*CLimbSize]
        PMULUDQ MM2,MM7
        MOV     DWORD PTR [EDX],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM1
        MOV     DWORD PTR [EDX+CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM2
        MOV     DWORD PTR [EDX+2*CLimbSize],MM6
        PSRLQ   MM6,32
        MOV     DWORD PTR [EDX+3*CLimbSize],MM6
        DEC     EBX
        JZ      @Exit

        // Second part:
        //                      [ Lf2 ][ Lf1 ][ Lf0 ]
        //                             [ Rg1 ]
        //                      --------------------- x
        //               [ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]
        //                      [  Lf0 * Rg1 ]
        //               [  Lf1 * Rg1 ]
        //        [  Lf2 * Rg1 ]
        //        ----------------------------------- +
        //        [ Rs4 ][ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]

        MOV     MM7,[ESI+CLimbSize]
        MOV     MM6,[EAX]
        PMULUDQ MM6,MM7
        MOV     MM1,[EAX+CLimbSize]
        MOV     MM4,[EDX+CLimbSize]
        PMULUDQ MM1,MM7
        MOV     MM2,[EAX+2*CLimbSize]
        MOV     MM5,[EDX+2*CLimbSize]
        PMULUDQ MM2,MM7
        PADDQ   MM6,MM4
        PADDQ   MM5,MM1
        MOV     MM4,[EDX+3*CLimbSize]
        MOV     [EDX+CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM5
        PADDQ   MM4,MM2
        MOV     [EDX+2*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM4
        MOV     [EDX+3*CLimbSize],MM6
        PSRLQ   MM6,32
        MOV     [EDX+4*CLimbSize],MM6
        DEC     EBX
        JE      @Exit

        // Third part:
        //                      [ Lf2 ][ Lf1 ][ Lf0 ]
        //                      [ Rg2 ]
        //                      --------------------- x
        //        [ Rs4 ][ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]
        //               [  Lf0 * Rg2 ]
        //        [  Lf1 * Rg2 ]
        // [  Lf2 * Rg2 ]
        // ------------------------------------------ +
        // [ Rs5 ][ Rs4 ][ Rs3 ][ Rs2 ][ Rs1 ][ Rs0 ]

        MOV     MM7,[ESI+2*CLimbSize]
        MOV     MM6,[EAX]
        PMULUDQ MM6,MM7
        MOV     MM1,[EAX+CLimbSize]
        MOV     MM4,[EDX+2*CLimbSize]
        PMULUDQ MM1,MM7
        MOV     MM2,[EAX+2*CLimbSize]
        MOV     MM5,[EDX+3*CLimbSize]
        PMULUDQ MM2,MM7
        PADDQ   MM6,MM4
        PADDQ   MM5,MM1
        MOV     MM4,[EDX+4*CLimbSize]
        MOV     [EDX+2*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM5
        PADDQ   MM4,MM2
        MOV     [EDX+3*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM4
        MOV     [EDX+4*CLimbSize],MM6
        PSRLQ   MM6,32
        MOV     [EDX+5*CLimbSize],MM6
        JMP     @Exit

@Big:


//      More than 3 limbs each, so we must loop.
//      Loops are unrolled to a level of 4.
//      There are 4 loops: one each for a rest of 0, 1, 2, 3, respectively

        PXOR    MM6,MM6
        LEA     ESI,[ESI+CLimbSize]
        AND     ECX,3
        JZ      @L0
        CMP     ECX,2
        JL      @L1
        JE      @L2
        JMP     @L3

@L0:
        MOV     MM3,[EAX]
        SUB     ECX,LSize                              // Inner loop count
        MOV     LSize,ECX                              // Update for later

        PMULUDQ MM3,MM7
        MOV     MM0,[EAX+CLimbSize]
        PMULUDQ MM0,MM7
        MOV     MM1,[EAX+2*CLimbSize]
        JMP     @m00

        .ALIGN  16

@lpm0:                                                  // LoopMain0
        PMULUDQ MM4,MM7
        PADDQ   MM6,MM0
        MOV     MM3,[EAX]
        MOV     [EDX-3*CLimbSize],MM6
        PSRLQ   MM6,32
        PMULUDQ MM3,MM7
        PADDQ   MM6,MM1
        MOV     MM0,[EAX+CLimbSize]
        MOV     [EDX-2*CLimbSize],MM6
        PSRLQ   MM6,32
        PMULUDQ MM0,MM7
        PADDQ   MM6,MM4
        MOV     MM1,[EAX+2*CLimbSize]
        MOV     MM6,[EDX-CLimbSize]
        PSRLQ   MM6,32
@m00:                                                   // Main00
        PMULUDQ MM1,MM7
        PADDQ   MM6,MM3
        MOV     MM4,[EAX+3*CLimbSize]
        MOV     [EDX],MM6
        PSRLQ   MM6,32
        LEA     EAX,[EAX+4*CLimbSize]
        LEA     EDX,[EDX+4*CLimbSize]
        ADD     ECX,4
        JA      @lpm0
        PMULUDQ MM4,MM7
        PADDQ   MM6,MM0
        MOV     [EDX-3*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM1
        MOV     EDI,SaveResult
        JMP     @x0

@olp0:                                                  // @OuterLoop0
        LEA     EDI,[EDI+CLimbSize]
        MOV     MM7,[ESI]
        LEA     ESI,[ESI+4]
        MOV     EDX,EDI
        MOV     EAX,LLeft
        MOV     MM3,[EAX]
        MOV     ECX,LSize
        PXOR    MM6,MM6
        PMULUDQ MM3,MM7
        MOV     MM0,[EAX+CLimbSize]
        MOV     MM5,[EDX]
        PMULUDQ MM0,MM7
        MOV     MM1,[EAX+2*CLimbSize]
        PADDQ   MM5,MM3
        MOV     MM4,[EDX+CLimbSize]
        JMP     @am00

        .ALIGN  16

@lam0:                                                  // @LoopAddMove0
        PMULUDQ MM2,MM7
        PADDQ   MM6,MM4
        MOV     MM3,[EAX]
        PADDQ   MM5,MM1
        MOV     MM4,[EDX-CLimbSize]
        MOV     [EDX-3*CLimbSize],MM6
        PSRLQ   MM6,32
        PMULUDQ MM3,MM7
        PADDQ   MM6,MM5
        MOV     MM0,[EAX+CLimbSize]
        PADDQ   MM4,MM2
        MOV     MM5,[EDX]
        MOV     [EDX-2*CLimbSize],MM6
        PSRLQ   MM6,32
        PMULUDQ MM0,MM7
        PADDQ   MM6,MM4
        MOV     MM1,[EAX+2*CLimbSize]
        PADDQ   MM5,MM3
        MOV     MM4,[EDX+CLimbSize]
        MOV     [EDX-CLimbSize],MM6
        PSRLQ   MM6,32
@am00:                                                  // AddMove00
        PMULUDQ MM1,MM7
        PADDQ   MM6,MM5
        MOV     MM2,[EAX+3*CLimbSize]
        PADDQ   MM4,MM0
        MOV     MM5,[EDX+2*CLimbSize]
        MOV     [EDX],MM6
        PSRLQ   MM6,32
        LEA     EAX,[EAX+4*CLimbSize]
        LEA     EDX,[EDX+4*CLimbSize]
        ADD     ECX,4
        JNZ     @lam0
        PMULUDQ MM2,MM7
        PADDQ   MM6,MM4
        PADDQ   MM5,MM1
        MOV     MM4,[EDX-CLimbSize]
        MOV     [EDX-3*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM5
        PADDQ   MM4,MM2
@x0:                                                    // Exit00
        MOV     [EDX-2*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM4
        MOV     [EDX-CLimbSize],MM6
        PSRLQ   MM6
        DEC     EBX
        JNZ     @olp0
        JMP     @Exit

@L1:                                                    // Set up:
        MOV     MM4,[EAX]                               // Get lowest limb of Left
        SUB     ECX,LSize                               // LSize := 1 - LSize;
        MOV     LSize,ECX
        PMULUDQ MM4,MM7                                 // MM4 = Right[0] * Left[0]
        MOV     MM3,[EAX+CLimbSize]
        PMULUDQ MM3,MM7                                 // MM3 = Right[0] * Left[1]
        MOV     MM0,[EAX+2*CLimbSize]                   // MM0 = Left[2]
        JMP     @m01

        .ALIGN  16

@lpm1:                                                  // LoopMove1
        PMULUDQ MM4,MM7
        PADDQ   MM6,MM0
        MOV     MM3,[EAX+CLimbSize]
        MOV     [EDX-2*CLimbSize],MM6
        PSRLQ   MM6,32
        PMULUDQ MM3,MM7
        PADDQ   MM6,MM1
        MOV     MM0,[EAX+2*CLimbSize]
        MOV     [EDX-CLimbSize],MM6
        PSRLQ   MM6,32
@m01:                                                   // Move01
        PMULUDQ MM0,MM7
        PADDQ   MM6,MM4
        MOV     MM1,[EAX+3*CLimbSize]
        MOV     [EDX],MM6
        PSRLQ   MM6,32
        PMULUDQ MM1,MM7
        PADDQ   MM6,MM3
        MOV     MM4,[EAX+4*CLimbSize]
        MOV     [EDX+CLimbSize],MM6
        PSRLQ   MM6,32
        LEA     EAX,[EAX+4*CLimbSize]
        LEA     EDX,[EDX+4*CLimbSize]
        ADD     ECX,4
        JA      @lmp1
        PMULUDQ MM7,MM4
        PADDQ   MM6,MM0
        MOV     [EDX-2*CLimbSize],MM6
        PSRLQ   MM6,32
        PADDQ   MM6,MM1
        MOV     EDI,SaveResult
        JMP     @x1

@olp1:                                                  // OuterLoop1
        LEA     EDI,[EDI+CLimbSize]
        MOV     MM7,[ESI]
        LEA     ESI,[ESI+CLimbSize]
        MOV     EDX,EDI
        MOV     EAX,LLeft
        MOV     MM2,[EAX]
        MOV     ECX,LSize
        PXOR    MM6,MM6
        PMULUDQ MM2,MM7
        MOV     MM3,[EAX+CLimbSize]
        MOV     MM4,[EDX]
        PMULUDQ MM3,MM7
        MOV     MM0,[EAX+2*CLimbSize]
        PADDQ   MM4,MM2
        MOV     MM5,[EDX+CLimbSize]
        JMP     @am01

        .ALIGN  16

@lam1:                                                  // LoopAddMove1
        PMULUDQ MM2,MM7
        PADDQ   MM6,MM4
        MOV     MM3,[EAX+CLimbSize]
        PADDQ   MM5,MM1
        MOV     MM4,[EDX]










@Exit:
        EMMS
        POP     EBX
        POP     ESI
        POP     EDI
end;

