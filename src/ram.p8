;----------------------------------------------
; ram.p8
;----------------------------------------------

c64 {
    %option merge

    ;-------------------------------------------------------------------------------------------------------
    ;           LABEL          ADDRESS        DESCRIPTION
    ;-------------------------------------------------------------------------------------------------------
    &uword      ADRAY1       = $03   ;-04     JUMP VECTOR: CONVERT FAC TO INTEGER IN (A/Y) ($B1AA).
    &uword      ADRAY2       = $05   ;-06     JUMP VECTOR: CONVERT INTEGER IN (A/Y) TO FLOATING POINT IN (FAC); ($B391).
    &ubyte      CHARAC       = $07   ;        SEARCH CHARACTER/TEMPORARY INTEGER DURING INT.
    &ubyte      ENDCHR       = $08   ;        FLAG: SCAN FOR QUOTE AT END OF STRING.
    &uword      INTEGR       = $07   ;-08     TEMPORARY INTEGER DURING OR/AND.
    &ubyte      TRMPOS       = $09   ;        SCREEN COLUMN FOR LAST TAB.
    &ubyte      VERCK        = $0A   ;        FLAG: 0 = LOAD, 1 = VERIFY.
    &ubyte      COUNT        = $0B   ;        INPUT BUFFER POINTER/NUMBER OF SUBSCRIPTS.
    &ubyte      DIMFLG       = $0C   ;        FLAG: DEFAULT ARRAY DIMENSION.
    &ubyte      VALTYP       = $0D   ;        DATA TYPE FLAG: $00 = NUMERIC, $FF = STRING.
    &ubyte      INTFLG       = $0E   ;        DATA TYPE FLAG: $00 = FLOATING POINT, $80 = INTEGER.
    &ubyte      GARBFL       = $0F   ;        FLAG: DATA SCAN/LIST QUOTE/GARBAGE COLLECTION.
    &ubyte      SUBFLG       = $10   ;        FLAG: SUBSCRIPT REFERENCE/USER FUNCTION CALL.
    &ubyte      INPFLG       = $11   ;        INPUT FLAG: $00 = INPUT, $40 = GET, $98 = READ.
    &ubyte      TANSGN       = $12   ;        FLAG: TAN SIGN/COMPARATIVE RESULT.
    &ubyte      CHANNL       = $13   ;        FILE NUMBER OF CURRENT INPUT DEVICE.
    &uword      LINNUM       = $14   ;-15     TEMPORARY: INTEGER VALUE.
    &ubyte      TEMPPT       = $16   ;        POINTER: TEMPORARY STRING STACK.
    &uword      LASTPT       = $17   ;-18     LAST TEMPORARY STRING ADDRESS.
    &uword      TEMPST       = $19   ;-21     STACK FOR TEMPORARY STRINGS.
    &ubyte[4]   INDEX        = $22   ;-25     UTILITY POINTER AREA.
    &uword      INDEX1       = $22   ;-23     FIRST UTILITY POINTER.
    &uword      INDEX2       = $24   ;-25     SECOND UTILITY POINTER.
    &ubyte[5]   RESHO        = $26   ;-2A     FLOATING POINT PRODUCT OF MULTIPLY AND DIVIDE.
    &uword      TXTTAB       = $2B   ;-2C     POINTER: START OF BASIC TEXT AREA ($0801).
    &uword      VARTAB       = $2D   ;-2E     POINTER: START OF BASIC VARIABLES.
    &uword      ARYTAB       = $2F   ;-30     POINTER: START OF BASIC ARRAYS.
    &uword      STREND       = $31   ;-32     POINTER: END OF BASIC ARRAYS + 1.
    &uword      FRETOP       = $33   ;-34     POINTER: BOTTOM OF STRING SPACE.
    &uword      FRESPC       = $35   ;-36     UTILITY STRING POINTER.
    &uword      BASSIZ       = $37   ;-38     POINTER: HIGHEST ADDRESS AVAILABLE TO BASIC ($A000).
    &uword      CURLIN       = $39   ;-3A     CURRENT BASIC LINE NUMBER.
    &uword      OLDLIN       = $3B   ;-3C     PREVIOUS BASIC LINE NUMBER.
    &uword      OLDTXT       = $3D   ;-3E     POINTER: BASIC STATEMENT FOR CONT.
    &uword      DATLIN       = $3F   ;-40     CURRENT DATA LINE NUMBER.
    &uword      DATPTR       = $41   ;-42     POINTER: USED BY READ - CURRENT DATA ITEM ADDRESS.
    &uword      INPPTR       = $43   ;-44     POINTER: TEMPORARY STORAGE OF POINTER DURING INPUT ROUTINE.
    &uword      VARNAM       = $45   ;-46     NAME OF VARIABLE BEING SOUGHT IN VARIABLE TABLE.
    &uword      VARPNT       = $47   ;-48     POINTER: TO VALUE OF (VARNAM) IF INTEGER, TO DESCRIPTOR IF STRING.
    &uword      FORPNT       = $49   ;-4A     POINTER: INDEX VARIABLE FOR FOR/NEXT LOOP.
    &uword      VARTXT       = $4B   ;-4C     TEMPORARY STORAGE FOR TXTPTR DURING READ, INPUT AND GET.
    &ubyte      OPMASK       = $4D   ;        MASK USED DURING FRMEVL.
    &ubyte[5]   TEMPF3       = $4E   ;-52     TEMPORARY STORAGE FOR FLPT VALUE.
    &ubyte      FOUR6        = $53   ;        LENGTH OF STRING VARIABLE DURING GARBEGE COLLECTION.
    &ubyte[3]   JMPER        = $54   ;-56     JUMP VECTOR USED IN FUNCTION EVALUATION - JMP FOLLOWED BY ADDRESS ($4C,$LB,$MB).
    &ubyte[5]   TEMPF1       = $57   ;-5B     TEMPORARY STORAGE FOR FLPT VALUE.
    &ubyte[5]   TEMPF2       = $5C   ;-60     TEMPORARY STORAGE FOR FLPT VALUE.
    &ubyte[6]   FAC          = $61   ;-66     MAIN FLOATING POINT ACCUMULATOR.
    &ubyte      FACEXP       = $61   ;        FAC EXPONENT.
    &ubyte[4]   FACHO        = $62   ;-65     FAC MANTISSA.
    &ubyte      FACSGN       = $66   ;        FAC SIGN.
    &ubyte      SGNFLG       = $67   ;        POINTER: SERIES EVALUATION CONSTANT.
    &ubyte      BITS         = $68   ;        BIT OVERFLOW AREA DURING NORMALISATION ROUTINE.
    &ubyte[6]   AFAC         = $69   ;-6E     AUXILIARY FLOATING POINT ACCUMULATOR.
    &ubyte      ARGEXP       = $69   ;        AFAC EXPONENT.
    &ubyte[4]   ARGHO        = $6A   ;-6D     AFAC MANTISSA.
    &ubyte      ARGSGN       = $6E   ;        AFAC SIGN.
    &ubyte      ARISGN       = $6F   ;        SIGN OF RESULT OF ARITHMETIC EVALUATION.
    &ubyte      FACOV        = $70   ;        FAC LOW-ORDER ROUNDING.
    &uword      FBUFPT       = $71   ;-72     POINTER: USED DURING CRUNCH/ASCII CONVERSION.
    &ubyte[24]  CHRGET       = $73   ;-8A     SUBROUTINE: GET NEXT BYTE OF BASIC TEXT.
;   const ubyte CHRGOT       = $79   ;        ENTRY TO GET SAME BYTE AGAIN.
    &uword      TXTPTR       = $7A   ;-7B     POINTER: CURRENT BYTE OF BASIC TEXT.
    &ubyte[5]   RNDX         = $8B   ;-8F     FLOATING RND FUNCTION SEED VALUE.
    &ubyte      STATUS       = $90   ;        KERNAL I/O STATUS WORD  ST.
    &ubyte      STKEY        = $91   ;        FLAG: $7F = STOP KEY.
    &ubyte      SVXT         = $92   ;        TIMING CONSTANT FOR TAPE.
    &ubyte      VERCKK       = $93   ;        FLAG: 0 = LOAD, 1 = VERIFY.
    &ubyte      C3PO         = $94   ;        FLAG: SERIAL BUS - OUTPUT CHARACTER BUFFERED.
    &ubyte      BSOUR        = $95   ;        BUFFERED CHARACTER FOR SERIAL BUS.
    &ubyte      SYNO         = $96   ;        CASSETTE SYNC. NUMBER.
    &ubyte      TEMPX        = $97   ;        TEMPORARY STORAGE OF X REGISTER DURING CHRIN.
    &ubyte      TEMPY        = $97   ;        TEMPORARY STORAGE OF Y REGISTER DURING RS232 FETCH.
    &ubyte      LDTND        = $98   ;        NUMBER OF OPEN FILES/INDEX TO FILE TABLE.
    &ubyte      DFLTN        = $99   ;        DEFAULT INPUT DEVICE (0).
    &ubyte      DFLTO        = $9A   ;        DEFAULT OUTPUT DEVICE (3).
    &ubyte      PRTY         = $9B   ;        PARITY OF BYTE OUTPUT TO TAPE.
    &ubyte      DPSW         = $9C   ;        FLAG: BYTE RECEIVED FROM TAPE.
    &ubyte      MSGFLG       = $9D   ;        FLAG: $00 = PROGRAM MODE: SUPPRESS ERROR
                                     ;        MESSAGES, $40 = KERNAL ERROR MESSAGES ONLY,
                                     ;        $80 = DIRECT MODE: FULL ERROR MESSAGES.
    &ubyte      FNMIDX       = $9E   ;        INDEX TO CASSETTE FILE NAME/HEADER ID FOR TAPE WRITE.
    &ubyte      PTR1         = $9E   ;        TAPE ERROR LOG PASS 1.
    &ubyte      PTR2         = $9F   ;        TAPE ERROR LOG PASS 2.
    &ubyte[3]   TIME         = $A0   ;-A2     REAL-TIME JIFFY CLOCK (UPDATED BY IRQ
                                     ;        INTERRUPT APPROX. EVERY 1/60 OF SECOND);
                                     ;        UPDATE ROUTINE: UDTIMK ($F69B).
    &ubyte      TSFCNT       = $A3   ;        BIT COUNTER TAPE READ OR WRITE/SERIAL BUS EOI (END OF INPUT) FLAG.
    &ubyte      TBTCNT       = $A4   ;        PULSE COUNTER TAPE READ OR WRITE/SERIAL BUS SHIFT COUNTER.
    &ubyte      CNTDN        = $A5   ;        TAPE SYNCHRONISING COUNT DOWN.
    &ubyte      BUFPNT       = $A6   ;        POINTER: TAPE I/O BUFFER.
    &ubyte      INBIT        = $A7   ;        RS232 TEMPORARY FOR RECEIVED BIT/TAPE TEMPORARY.
    &ubyte      BITC1        = $A8   ;        RS232 INPUT BIT COUNT/TAPE TEMPORARY.
    &ubyte      RINONE       = $A9   ;        RS232 FLAG: START BIT CHECK/TAPE TEMPORARY.
    &ubyte      RIDATA       = $AA   ;        RS232 INPUT BYTE BUFFER/TAPE TEMPORARY.
    &ubyte      RIPRTY       = $AB   ;        RS232 INPUT PARITY/TAPE TEMPORARY.
    &uword      SAL          = $AC   ;-AD     POINTER: TAPE BUFFER/SCREEN SCROLLING.
    &uword      EAL          = $AE   ;-AF     TAPE END ADDRESS/END OF PROGRAM.
    &uword      CMPO         = $B0   ;-B1     TAPE TIMING CONSTANTS.
    &uword      TAPE1        = $B2   ;-B3     POINTER: START ADDRESS OF TAPE BUFFER ($033C).
    &ubyte      BITTS        = $B4   ;        RS232 WRITE BIT COUNT/TAPE READ TIMING FLAG.
    &ubyte      NXTBIT       = $B5   ;        RS232 NEXT BIT TO SEND/TAPE READ - END OF TAPE.
    &ubyte      RODATA       = $B6   ;        RS232 OUTPUT BYTE BUFFER/TAPE READ ERROR FLAG.
    &ubyte      FNLEN        = $B7   ;        NUMBER OF CHARACTERS IN FILENAME.
    &ubyte      LA           = $B8   ;        CURRENT FILE - LOGICAL FILE NUMBER.
    &ubyte      SA           = $B9   ;        CURRENT FILE - SECONDARY ADDRESS.
    &ubyte      FA           = $BA   ;        CURRENT FILE - FIRST ADDRESS (DEVICE NUMBER).
                                     ;          OPEN LA,FA,SA;  OPEN 1,8,15,"I0":CLOSE 1
    &uword      FNADR        = $BB   ;-BC     POINTER: CURRENT FILE NAME ADDRESS.
    &ubyte      ROPRTY       = $BD   ;        RS232 OUTPUT PARITY/TAPE BYTE TO BE INPUT OR OUTPUT.
    &ubyte      FSBLK        = $BE   ;        TAPE INPUT/OUTPUT BLOCK COUNT.
    &ubyte      MYCH         = $BF   ;        SERIAL WORD BUFFER.
    &ubyte      CAS1         = $C0   ;        TAPE MOTOR SWITCH.
    &uword      STAL         = $C1   ;-C2     START ADDRESS FOR LOAD AND CASSETTE WRITE.
    &uword      MEMUSS       = $C3   ;-C4     POINTER: TYPE 3 TAPE LOAD AND GENERAL USE.
    &ubyte      LSTX         = $C5   ;        MATRIX VALUE OF LAST KEY PRESSED; NO KEY = $40.
    &ubyte      NDX          = $C6   ;        NUMBER OF CHARACTERS IN KEYBOARD BUFFER QUEUE.
    &ubyte      RVS          = $C7   ;        FLAG: REVERSE ON/OFF; ON = $01, OFF = $00.
    &ubyte      INDX         = $C8   ;        POINTER: END OF LINE FOR INPUT (USED TO SUPPRESS TRAILING SPACES).
    &ubyte[2]   LXSP         = $C9   ;-CA     CURSOR X/Y (LINE/COLUMN) POSITION AT START OF INPUT.
    &ubyte      SFDX         = $CB   ;        FLAG: PRINT SHIFTED CHARACTERS.
    &ubyte      BLNSW        = $CC   ;        FLAG: CURSOR BLINK; $00 = ENABLED, $01 = DISABLED.
    &ubyte      BLNCT        = $CD   ;        TIMER: COUNT DOWN FOR CURSOR BLINK TOGGLE.
    &ubyte      GDBLN        = $CE   ;        CHARACTER UNDER CURSOR WHILE CURSOR INVERTED.
    &ubyte      BLNON        = $CF   ;        FLAG: CURSOR STATUS; $00 = OFF, $01 = ON.
    &ubyte      CRSW         = $D0   ;        FLAG: INPUT FROM SCREEN = $03, OR KEYBOARD = $00.
    &uword      PNT          = $D1   ;-D2     POINTER: CURRENT SCREEN LINE ADDRESS.
    &ubyte      PNTR         = $D3   ;        CURSOR COLUMN ON CURRENT LINE, INCLUDING WRAP-ROUND LINE, IF ANY.
    &ubyte      QTSW         = $D4   ;        FLAG: EDITOR IN QUOTE MODE; $00 = NOT.
    &ubyte      LNMX         = $D5   ;        CURRENT LOGICAL LINE LENGTH: 39 OR 79.
    &ubyte      TBLX         = $D6   ;        CURRENT SCREEN LINE NUMBER OF CURSOR.
    &ubyte      SCHAR        = $D7   ;        SCREEN VALUE OF CURRENT INPUT CHARACTER/LAST CHARACTER OUTPUT.
    &ubyte      INSRT        = $D8   ;        COUNT OF NUMBER OF INSERTS OUTSTANDING.
    &ubyte      LDTB1        = $D9   ;-F2     SCREEN LINE LINK TABLE/EDITOR TEMPORARIES.
                                     ;        HIGH BYTE OF LINE SCREEN MEMORY LOCATION.
    &uword      USER         = $F3   ;-F4     POINTER: CURRENT COLOUR RAM LOCATION.
    &uword      KEYTAB       = $F5   ;-F6     VECTOR: CURRENT KEYBOARD DECODING TABLE. ($EB81)
    &uword      RIBUF        = $F7   ;-F8     RS232 INPUT BUFFER POINTER.
    &uword      ROBUF        = $F9   ;-FA     RS232 OUTPUT BUFFER POINTER.
    &uword      FREKZP       = $FB   ;-FE     FREE ZERO PAGE SPACE FOR USER PROGRAMS.
    &ubyte      BASZPT       = $FF   ;        BASIC TEMPORARY DATA AREA.
    &ubyte[12]  ASCWRK       = $FF   ;-010A   ASSEMBLY AREA FOR FLOATING POINT TO ASCII CONVERSION.
    &ubyte[63]  BAD          = $0100 ;-013E   TAPE INPUT ERROR LOG.
    &ubyte[256] STACK        = $0100 ;-01FF   6510 HARDWARE STACK AREA.
    &ubyte[192] BSTACK       = $013F ;-01FF   BASIC STACK AREA.
    &ubyte[89]  BUF          = $0200 ;-0258   BASIC INPUT BUFFER (INPUT LINE FROM SCREEN).
    &ubyte[10]  LAT          = $0259 ;-0262   KERNAL TABLE: ACTIVE LOGICAL FILE NUMBERS.
    &ubyte[10]  FAT          = $0263 ;-026C   KERNAL TABLE: ACTIVE FILE FIRST ADDRESSES (DEVICE NUMBERS).
    &ubyte[10]  SAT          = $026D ;-0276   KERNAL TABLE: ACTIVE FILE SECONDARY ADDRESSES.
    &ubyte      KEYD         = $0277 ;-0280   KEYBOARD BUFFER QUEUE (FIFO).
    &uword      MEMSTR       = $0281 ;-0282   POINTER: BOTTOM OF MEMORY FOR OPERATING SYSTEM ($0800).
    &uword      MEMSIZ       = $0283 ;-0284   POINTER: TOP OF MEMORY FOR OPERATING SYSTEM ($A000).
    &ubyte      TIMOUT       = $0285 ;        SERIAL IEEE BUS TIMEOUT DEFEAT FLAG.
    &ubyte      CHRCOL       = $0286 ;        CURRENT CHARACTER COLOUR CODE.
    &ubyte      GDCOL        = $0287 ;        BACKGROUND COLOUR UNDER CURSOR.
    &ubyte      HIBASE       = $0288 ;        HIGH BYTE OF SCREEN MEMORY ADDRESS ($04).
    &ubyte      XMAX         = $0289 ;        MAXIMUM NUMBER OF BYTES IN KEYBOARD BUFFER ($0A).
    &ubyte      RPTFLG       = $028A ;        FLAG: REPEAT KEYS; $00 = CURSORS, INST/DEL & SPACE REPEAT,
                                     ;                           $40 NO KEYS REPEAT,
                                     ;                           $80 ALL KEYS REPEAT ($00).
    &ubyte      KOUNT        = $028B ;        REPEAT KEY: SPEED COUNTER ($04).
    &ubyte      DELAY        = $028C ;        REPEAT KEY: FIRST REPEAT DELAY COUNTER ($10).
    &ubyte      SHFLAG       = $028D ;        FLAG: SHIFT KEYS: BIT 1 = SHIFT, BIT 2 = CBM,
                                     ;        BIT 3 = CTRL; ($00 = NONE, $01 = SHIFT, ETC.).
    &ubyte      LSTSHF       = $028E ;        LAST SHIFT KEY USED FOR DEBOUNCING.
    &uword      KEYLOG       = $028F ;-0290   VECTOR: ROUTINE TO DETERMINE KEYBOARD TABLE
                                     ;        TO USE BASED ON SHIFT KEY PATTERN ($EB48).
    &ubyte      MODE         = $0291 ;        FLAG: UPPER/LOWER CASE CHANGE: $00 = DISABLED, $80 = ENABLED ($00).
    &ubyte      AUTODN       = $0292 ;        FLAG: AUTO SCROLL DOWN: $00 = DISABLED ($00).
    &ubyte      M51CTR       = $0293 ;        RS232 PSEUDO 6551 CONTROL REGISTER IMAGE.
    &ubyte      M51CDR       = $0294 ;        RS232 PSEUDO 6551 COMMAND REGISTER IMAGE.
    &ubyte[2]   M51AJB       = $0295 ;-0296   RS232 NON-STANDARD BITS/SECOND.
    &ubyte      RSSTAT       = $0297 ;        RS232 PSEUDO 6551 STATUS REGISTER IMAGE.
    &ubyte      BITNUM       = $0298 ;        RS232 NUMBER OF BITS LEFT TO SEND.
    &ubyte[2]   BAUDOF       = $0299 ;-029A   RS232 BAUD RATE; FULL BIT TIME MICROSECONDS.
    &ubyte      RIDBE        = $029B ;        RS232 INDEX TO END OF INPUT BUFFER.
    &ubyte      RIDBS        = $029C ;        RS232 POINTER: HIGH BYTE OF ADDRESS OF INPUT BUFFER.
    &ubyte      RODBS        = $029D ;        RS232 POINTER: HIGH BYTE OF ADDRESS OF OUTPUT BUFFER.
    &ubyte      RODBE        = $029E ;        RS232 INDEX TO END OF OUTPUT BUFFER.
    &uword      IRQTMP       = $029F ;-02A0   TEMPORARY STORE FOR IRQ VECTOR DURING TAPE OPERATIONS.
    &ubyte      ENABL        = $02A1 ;        RS232 ENABLES.
    &ubyte      TODSNS       = $02A2 ;        TOD SENSE DURING TAPE I/O.
    &ubyte      TRDTMP       = $02A3 ;        TEMPORARY STORAGE DURING TAPE READ.
    &ubyte      TD1IRQ       = $02A4 ;        TEMPORARY D1IRQ INDICATOR DURING TAPE READ.
    &ubyte      TLNIDX       = $02A5 ;        TEMPORARY FOR LINE INDEX.
    &ubyte      TVSFLG       = $02A6 ;        FLAG: TV STANDARD: $00 = NTSC, $01 = PAL.
    &uword      IERROR       = $0300 ;-0301   VECTOR: INDIRECT ENTRY TO BASIC ERROR MESSAGE, (X) POINTS TO MESSAGE ($E38B).
    &uword      IMAIN        = $0302 ;-0303   VECTOR: INDIRECT ENTRY TO BASIC INPUT LINE AND DECODE ($A483).
    &uword      ICRNCH       = $0304 ;-0305   VECTOR: INDIRECT ENTRY TO BASIC TOKENISE ROUTINE ($A57C).
    &uword      IQPLOP       = $0306 ;-0307   VECTOR: INDIRECT ENTRY TO BASIC LIST ROUTINE ($A71A).
    &uword      IGONE        = $0308 ;-0309   VECTOR: INDIRECT ENTRY TO BASIC CHARACTER DISPATCH ROUTINE ($A7E4).
    &uword      IEVAL        = $030A ;-030B   VECTOR: INDIRECT ENTRY TO BASIC TOKEN EVALUATION ($AE86).
    &ubyte      SAREG        = $030C ;        STORAGE FOR 6510 ACCUMULATOR DURING SYS.
    &ubyte      SXREG        = $030D ;        STORAGE FOR 6510 X-REGISTER DURING SYS.
    &ubyte      SYREG        = $030E ;        STORAGE FOR 6510 Y-REGISTER DURING SYS.
    &ubyte      SPREG        = $030F ;        STORAGE FOR 6510 STATUS REGISTER DURING SYS.
    &ubyte      USRPOK       = $0310 ;        USR FUNCTION JMP INSTRUCTION ($4C).
    &uword      USRADD       = $0311 ;-0312   USR ADDRESS ($LB,$MB).
    &uword      CINV         = $0314 ;-0315   VECTOR: HARDWARE IRQ INTERRUPT ADDRESS ($EA31).
    &uword      CBINV        = $0316 ;-0317   VECTOR: BRK INSTRUCTION INTERRUPT ADDRESS ($FE66).
    &uword      NMINV        = $0318 ;-0319   VECTOR: HARDWARE NMI INTERRUPT ADDRESS ($FE47).
    &uword      IOPEN        = $031A ;-031B   VECTOR: INDIRECT ENTRY TO KERNAL OPEN ROUTINE ($F34A).
    &uword      ICLOSE       = $031C ;-031D   VECTOR: INDIRECT ENTRY TO KERNAL CLOSE ROUTINE ($F291).
    &uword      ICHKIN       = $031E ;-031F   VECTOR: INDIRECT ENTRY TO KERNAL CHKIN ROUTINE ($F20E).
    &uword      ICKOUT       = $0320 ;-0321   VECTOR: INDIRECT ENTRY TO KERNAL CHKOUT ROUTINE ($F250).
    &uword      ICLRCH       = $0322 ;-0323   VECTOR: INDIRECT ENTRY TO KERNAL CLRCHN ROUTINE ($F333).
    &uword      IBASIN       = $0324 ;-0325   VECTOR: INDIRECT ENTRY TO KERNAL CHRIN ROUTINE ($F157).
    &uword      IBSOUT       = $0326 ;-0327   VECTOR: INDIRECT ENTRY TO KERNAL CHROUT ROUTINE ($F1CA).
    &uword      ISTOP        = $0328 ;-0329   VECTOR: INDIRECT ENTRY TO KERNAL STOP ROUTINE ($F6ED).
    &uword      IGETIN       = $032A ;-032B   VECTOR: INDIRECT ENTRY TO KERNAL GETIN ROUTINE ($F13E).
    &uword      ICLALL       = $032C ;-032D   VECTOR: INDIRECT ENTRY TO KERNAL CLALL ROUTINE ($F32F).
    &uword      USRCMD       = $032E ;-032F   USER DEFINED VECTOR ($FE66).
    &uword      ILOAD        = $0330 ;-0331   VECTOR: INDIRECT ENTRY TO KERNAL LOAD ROUTINE ($F4A5).
    &uword      ISAVE        = $0332 ;-0333   VECTOR: INDIRECT ENTRY TO KERNAL SAVE ROUTINE ($F5ED).
    &ubyte[192] TBUFFR       = $033C ;-03FB   TAPE I/O BUFFER.
    &uword      VICSCNz     = $0400 ;-07E7   DEFAULT SCREEN VIDEO MATRIX.
    &ubyte[8]   SPNTRS       = $07F8 ;-07FF   DEFAULT SPRITE DATA POINTERS.
}