;----------------------------------------------
;  kernel.i
;----------------------------------------------

;-------------------------------------------------------------------------------------------------------------------------------------------
; LABEL                 JUMP    VECTOR REAL  FUNCTION                           FUNCTION INPUT/OUTPUT                    REGISTER USAGE
;                       ADDR     ADDR  CODE  DESCRIPTION                        PARAMETERS                             ENTRY  RETURN  USED
;-------------------------------------------------------------------------------------------------------------------------------------------
CINT                  = $FF81  ; ----  FF5B  INIT VIC & SCREEN EDITOR                                                  - - -  - - -  A X Y
IOINIT                = $FF84  ; ----  FDA3  INITIALIZE CIA & IRQ                                                      - - -  - - -  A X Y
RAMTAS                = $FF87  ; ----  FD50  RAM TEST & SEARCH RAM END                                                 - - -  - - -  A X Y
RESTOR                = $FF8A  ; ----  FD15  RESTORE DEFAULT I/O VECTORS                                               - - -  - - -  A - Y
VECTOR                = $FF8D  ; ----  FD1A  READ/SET I/O VECTORS               IN: C=0 MOVES FROM Y/X TO VECTORS      - X Y  - X -  A - Y
                               ;                                                    C=1 MOVES VECTORS TO Y/X           - X Y  - X -  A - Y
SETMSG                = $FF90  ; ----  FE18  ENABLE/DISABLE KERNEL_ MESSAGES     IN: A BIT7=1 ERROR MSGS ON             A - -  - - -  A - -
                               ;                                                      BIT6=1 CONTROL MSGS ON
SECOND                = $FF93  ; ----  EDB9  SEND SECONDARY ADDR AFTER LISTEN   IN: A=SECONDARY ADDRESS                A - -  - - -  A - -
TKSA                  = $FF96  ; ----  EDC7  SEND SECONDARY ADDR AFTER TALK     IN: A=SECONDARY ADDRESS                A - -  - - -  A - -
MEMTOP                = $FF99  ; ----  FE25  READ/SET TOP OF MEMORY             IN: C=0; Y/X ADDRESS                   - X Y  - X Y  - - -
                               ;                                                OUT:C=1; Y/X ADDRESS                   - - -  - X Y  - X Y
MEMBOT                = $FF9C  ; ----  FE34  READ/SET BOTTOM OF MEMORY          IN: C=0; Y/X ADDRESS                   - X Y  - X Y  - - -
                               ;                                                OUT:C=1; Y/X ADDRESS                   - - -  - X Y  - X Y
SCNKEY                = $FF9F  ; ----  EA87  SCAN KEYBOARD                                                             - - -  - - -  A X Y
SETTMO                = $FFA2  ; ----  FE21  SET IEEE TIMEOUT                   IN: A BIT7=1 DISABLE, BIT7=0 ENABLE    A - -  A - -  - - -
ACPTR                 = $FFA5  ; ----  EE13  INPUT BYTE FROM SERIAL             OUT:A=BYTE, C=1 AND ST=2 IF TIMEOUT    - - -  A - -  A - -
CIOUT                 = $FFA8  ; ----  EDDD  OUTPUT BYTE TO SERIAL              IN: A=BYTE, C=1 AND ST=3 IF TIMEOUT    A - -  A - -  - - -
UNTLK                 = $FFAB  ; ----  EDEF  UNTALK ALL SERIAL DEVICES                                                 - - -  - - -  A - -
UNLSN                 = $FFAE  ; ----  EDFE  UNLISTEN ALL SERIAL DEVICES                                               - - -  - - -  A - -
LISTEN                = $FFB1  ; ----  ED0C  MAKE SERIAL DEVICE LISTEN          IN: A=DEVICE NUMBER                    A - -  - - -  A - -
TALK                  = $FFB4  ; ----  ED09  MAKE SERIAL DEVICE TALK            IN: A=DEVICE NUMBER                    A - -  - - -  A - -
READST                = $FFB7  ; ----  FE07  READ I/O STATUS BYTE               OUT:A=STATUS BYTE                      - - -  A - -  A - -
SETLFS                = $FFBA  ; ----  FE00  SET FILE PARAMETERS                IN: A=LOGICAL FILE NUMBER              A X Y  A X Y  - - -
                               ;                                                    X=DEVICE NUMBER
                               ;                                                    Y=SECONDARY ADDR
SETNAM                = $FFBD  ; ----  FDF9  SET FILE NAME                      IN: A=LENGTH OF FILENAME               A X Y  A X Y  - - -
                               ;                                                    Y/X=POINTER TO NAME ADDR
OPEN                  = $FFC0  ; 031A  F34A  OPEN LOG. FILE AFTER SETLFS,SETNAM OUT:A=ERROR# IF C=1                    - - -  - - -  A X Y
CLOSE                 = $FFC3  ; 031C  F291  CLOSE A LOGICAL FILE               IN: A=LOGICAL FILE NUMBER              A - -  - - -  A X Y
CHKIN                 = $FFC6  ; 031E  F20E  OPEN CHANNEL FOR INPUT             IN: X=LOGICAL FILE NUMBER              - X -  - - -  A X -
CHKOUT                = $FFC9  ; 0320  F250  OPEN CHANNEL FOR OUTPUT            IN: X=LOGICAL FILE NUMBER              - X -  - - -  A X -
CLRCHN                = $FFCC  ; 0322  F333  RESTORE DEFAULT DEVICES                                                   - - -  - - -  A X -
CHRIN                 = $FFCF  ; 0324  F157  INPUT CHARACTER                    OUT:A=CHARACTER, C=1 AND ST=ERROR      - - -  A - -  A - -
CHROUT                = $FFD2  ; 0326  F1CA  OUTPUT CHARACTER                   IN: A=CHARACTER, C=1 AND ST=ERROR      A - -  A - -  - - -
LOAD                  = $FFD5  ; 0330  F49E  LOAD AFTER CALL SETLFS,SETNAM      IN: A=0 LOAD, A=1 VERIFY               A X Y  A X Y  A X Y
                               ;                                                    Y/X = DEST.ADDR IF SEC.ADDR=0
SAVE                  = $FFD8  ; 0332  F5DD  SAVE AFTER CALL SETLFS,SETNAM      IN: A=ZERO PAGE POINTER TO START.ADDR  A X Y  - - -  A X Y
                               ;                                                    Y/X=ENDING ADDRESS
SETTIM                = $FFDB  ; ----  F6E4  SET JIFFY CLOCK                    IN: A=MSB, X=MIDDLE, Y=LSB             A X Y  - - -  - - -
RDTIM                 = $FFDE  ; ----  F6DD  READ JIFFY CLOCK                   OUT:A=MSB, X=MIDDLE, Y=LSB             - - -  A X Y  A X Y
STOP                  = $FFE1  ; 0328  F6ED  CHECK STOP KEY                     OUT:Z=0 IF STOP NOT USED; X UNCHANGED  - - -  A - -  A - -
                               ;                                                    Z=1 IF STOP USED; X CHANGED        - - -  A - -  A X -
                               ;                                                    A=LAST LINE OF KEYBOARD MATRIX
GETIN                 = $FFE4  ; 032A  F13E  GET A BYTE FROM CHANNEL            OUT:KEYBOARD:A=0 IF PUFFER EMPTY       - - -  A - -  A X Y
                               ;                                                    RS232:STATUS BYTE                  - - -  A - -  A - -
                               ;                                                    SERIAL:STATUS BYTE                 - - -  A - -  A - -
                               ;                                                    TAPE:STATUS BYTE                   - - -  A - -  A - Y
CLALL                 = $FFE7  ; 032C  F32F  CLOSE OR ABORT ALL FILES                                                  - - -  - - -  A X -
UDTIM                 = $FFEA  ; ----  F69B  UPDATE JIFFY CLOCK                                                        - - -  - - -  A X -
SCREEN                = $FFED  ; ----  E505  RETURN SCREEN SIZE                 OUT:X=COLUMNS, Y=ROWS                  - - -  - X Y  - X Y
PLOT                  = $FFF0  ; ----  E50A  READ/SET CURSOR POSITION           IN: C=0, X=ROW, Y=COLUMN               - X Y  - X Y  - - -
                               ;                                                OUT:C=1, X=ROW, Y=COLUMN               - - -  - X Y  - X Y
IOBASE                = $FFF3  ; ----  E500  RETURNS THE ADDR OF I/O DEVICES    OUT:Y/X=ADDR($DC00)                    - - -  - X Y  - X Y
