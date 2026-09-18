;----------------------------------------------
; io.p8
;----------------------------------------------

c64 {
    %option merge

    ;---------------------------------------------------------------
    ;                       ADDRESS     BITS    DESCRIPTION
    ;---------------------------------------------------------------
    &ubyte  D6510           = $00   ;   7-0     MOS 6510 DATA DIRECTION
                                    ;                   REGISTER (XX101111)
                                    ;                   BIT= 1: OUTPUT, BIT=0:
                                    ;                   INPUT, X=DON'T CARE
    &ubyte  R6510           = $01   ;           MOS 6510 MICRO-PROCESSOR
                                    ;                   ON-CHIP I/O PORT
                                    ;   0       /LORAM SIGNAL (0=SWITCH BASIC ROM OUT)
                                    ;   1       /HIRAM SIGNAL (0=SWITCH KERNAL ROM OUT)
                                    ;   2       /CHAREN SIGNAL (0=SWITH CHAR. ROM IN)
                                    ;   3       CASSETTE DATA OUTPUT LINE
                                    ;   4       CASSETTE SWITCH SENSE: 1 = SWITCH CLOSED
                                    ;   5       CASSETTE MOTOR CONTROL
                                    ;           O = ON, 1 = OFF
                                    ;   6-7     UNDEFINED

;    &ubyte  SP0X            = $D000 ;           SPRITE 0 X POS
;    &ubyte  SP0Y            = $D001 ;           SPRITE 0 Y POS
;    &ubyte  SP1X            = $D002 ;           SPRITE 1 X POS
;    &ubyte  SP1Y            = $D003 ;           SPRITE 1 Y POS
;    &ubyte  SP2X            = $D004 ;           SPRITE 2 X POS
;    &ubyte  SP2Y            = $D005 ;           SPRITE 2 Y POS
;    &ubyte  SP3X            = $D006 ;           SPRITE 3 X POS
;    &ubyte  SP3Y            = $D007 ;           SPRITE 3 Y POS
;    &ubyte  SP4X            = $D008 ;           SPRITE 4 X POS
;    &ubyte  SP4Y            = $D009 ;           SPRITE 4 Y POS
;    &ubyte  SP5X            = $D00A ;           SPRITE 5 X POS
;    &ubyte  SP5Y            = $D00B ;           SPRITE 5 Y POS
;    &ubyte  SP6X            = $D00C ;           SPRITE 6 X POS
;    &ubyte  SP6Y            = $D00D ;           SPRITE 6 Y POS
;    &ubyte  SP7X            = $D00E ;           SPRITE 7 X POS
;    &ubyte  SP7Y            = $D00F ;           SPRITE 7 Y POS
;    &ubyte  MSIGX           = $D010 ;           SPRITES 0-7 X POS (MSB OF X COORD.)
;    &ubyte  SCROLY          = $D011 ;           VIC CONTROL REGISTER
;                                    ;   7       RASTER COMPARE: (BIT 8) SEE 53266
;                                    ;   6       EXTENDED COLOR TEXT MODE 1 = ENABLE
;                                    ;   5       BIT MAP MODE. 1 = ENABLE
;                                    ;   4       BLANK SCREEN TO BORDER COLOR: 0 = BLANK
;                                    ;   3       SELECT 24/25 ROW TEXT DISPLAY: 1 = 25 ROWS
;                                    ;   2-0     SMOOTH SCROLL TO Y DOT-POSITION (0-7)
;    &ubyte  RASTER          = $D012 ;           READ RASTER / WRITE RASTER VALUE FOR COMPARE IRQ
;    &ubyte  LPENX           = $D013 ;           LIGHT-PEN LATCH X POS
;    &ubyte  LPENY           = $D014 ;           LIGHT-PEN LATCH Y POS
;    &ubyte  SPENA           = $D015 ;           SPRITE DISPLAY ENABLE: 1 = ENABLE
;    &ubyte  SCROLX          = $D016 ;           VIC CONTROL REGISTER
;                                    ;   7-6     UNUSED
;                                    ;   5       ALWAYS SET THIS BIT TO 0 !
;                                    ;   4       MULTI-COLOR MODE: 1 = ENABLE (TEXT OR BIT-MAP)
;                                    ;   3       SELECT 38/40 COLUMN TEXT DISPLAY: 1 = 40 COLS
;                                    ;   2-0     SMOOTH SCROLL TO X POS
;    &ubyte  YXPAND          = $D017 ;           SPRITES 0-7 EXPAND 2X VERTICAL (Y)
;    &ubyte  VMCSB           = $D018 ;           VIC MEMORY CONTROL REGISTER
;                                    ;   7-4     VIDEO MATRIX BASE ADDRESS (INSIDE VIC)
;                                    ;   3-1     CHARACTER DOT-DATA BASE ADDRESS (INSIDE VIC)
;                                    ;   0       SELECT UPPER/LOWER CHARACTER SET
;    &ubyte  VICIRQ          = $D019 ;           VIC INTERRUPT FLAG REGISTER (BIT = 1: IRQ OCCURRED)
;                                    ;   7       SET ON ANY ENABLED VIC IRQ CONDITION
;                                    ;   3       LIGHT-PEN TRIGGERED IRQ FLAG
;                                    ;   2       SPRITE TO SPRITE COLLISION IRQ FLAG
;                                    ;   1       SPRITE TO BACKGROUND COLLISION IRQ FLAG
;                                    ;   0       RASTER COMPARE IRQ FLAG
;    &ubyte  IRQMSK          = $D01A ;           IRQ MASK REGISTER: 1 = INTERRUPT ENABLED
;    &ubyte  SPBGPR          = $D01B ;           SPRITE TO BACKGROUND DISPLAY PRIORITY: 1 = SPRITE
;    &ubyte  SPMC            = $D01C ;           SPRITES 0-7 MULTI-COLOR MODE SELECT: 1 = M.C.M.
;    &ubyte  XXPAND          = $D01D ;           SPRITES 0-7 EXPAND 2X HORIZONTAL (X)
;    &ubyte  SPSPCL          = $D01E ;           SPRITE TO SPRITE COLLISION DETECT
;    &ubyte  SPBGCL          = $D01F ;           SPRITE TO BACKGROUND COLLISION DETECT
;    &ubyte  EXTCOL          = $D020 ;           BORDER COLOR
;    &ubyte  BGCOL0          = $D021 ;           BACKGROUND COLOR 0
;    &ubyte  BGCOL1          = $D022 ;           BACKGROUND COLOR 1
;    &ubyte  BGCOL2          = $D023 ;           BACKGROUND COLOR 2
;    &ubyte  BGCOL3          = $D024 ;           BACKGROUND COLOR 3
;    &ubyte  SPMC0           = $D025 ;           SPRITE MULTI-COLOR REGISTER 0
;    &ubyte  SPMC1           = $D026 ;           SPRITE MULTI-COLOR REGISTER 1
;    &ubyte  SP0COL          = $D027 ;           SPRITE 0 COLOR
;    &ubyte  SP1COL          = $D028 ;           SPRITE 1 COLOR
;    &ubyte  SP2COL          = $D029 ;           SPRITE 2 COLOR
;    &ubyte  SP3COL          = $D02A ;           SPRITE 3 COLOR
;    &ubyte  SP4COL          = $D02B ;           SPRITE 4 COLOR
;    &ubyte  SP5COL          = $D02C ;           SPRITE 5 COLOR
;    &ubyte  SP6COL          = $D02D ;           SPRITE 6 COLOR
;    &ubyte  SP7COL          = $D02E ;           SPRITE 7 COLOR
;
;    &ubyte  FRELO1          = $D400 ;           VOICE 1: FREQUENCY CONTROL - LOW-BYTE
;    &ubyte  FREHI1          = $D401 ;           VOICE 1: FREQUENCY CONTROL - HIGH-BYTE
;    &ubyte  PWLO1           = $D402 ;           VOICE 1: PULSE WAVEFORM WIDTH - LOW-BYTE
;    &ubyte  PWHI1           = $D403 ;   7-4     UNUSED
;                                    ;   3-0     VOICE 1: PULSE WAVEFORM WIDTH - HIGH-NYBBLE
;    &ubyte  VCREG1          = $D404 ;           VOICE 1: CONTROL REGISTER
;                                    ;   7       SELECT RANDOM NOISE WAVEFORM, 1 = ON
;                                    ;   6       SELECT PULSE WAVEFORM, 1 = ON
;                                    ;   5       SELECT SAWTOOTH WAVEFORM, 1 = ON
;                                    ;   4       SELECT TRIANGLE WAVEFORM, 1 = ON
;                                    ;   3       TEST BIT: 1 = DISABLE OSCILLATOR 1
;                                    ;   2       RING MODULATE OSC. 1 WITH OSC. 3 OUTPUT, 1 = ON
;                                    ;   1       SYNCHRONIZE OSC. 1 WITH OSC. 3 FREQUENCY, 1 = ON
;                                    ;   0       GATE BIT: 1 = START ATT/DEC/SUS, 0 = START RELEASE
;    &ubyte  ATDCY1          = $D405 ;           ENVELOPE GENERATOR 1: ATTACK / DECAY CYCLE CONTROL
;                                    ;   7-4     SELECT ATTACK CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT DECAY CYCLE DURATION: 0-15
;    &ubyte  SUREL1          = $D406 ;           ENVELOPE GENERATOR 1: SUSTAIN / RELEASE CYCLE CONTROL
;                                    ;   7-4     SELECT SUSTAIN CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT RELEASE CYCLE DURATION: 0-15
;    &ubyte  FRELO2          = $D407 ;           VOICE 2: FREQUENCY CONTROL - LOW-BYTE
;    &ubyte  FREHI2          = $D408 ;           VOICE 2: FREQUENCY CONTROL - HIGH-BYTE
;    &ubyte  PWLO2           = $D409 ;           VOICE 2: PULSE WAVEFORM WIDTH - LOW-BYTE
;    &ubyte  PWHI2           = $D40A ;   7-4     UNUSED
;                                    ;   3-0     VOICE 2: PULSE WAVEFORM WIDTH - HIGH-NYBBLE
;    &ubyte  VCREG2          = $D40B ;           VOICE 2: CONTROL REGISTER
;                                    ;   7       SELECT RANDOM NOISE WAVEFORM, 1 = ON
;                                    ;   6       SELECT PULSE WAVEFORM, 1 = ON
;                                    ;   5       SELECT SAWTOOTH WAVEFORM, 1 = ON
;                                    ;   4       SELECT TRIANGLE WAVEFORM, 1 = ON
;                                    ;   3       TEST BIT: 1 = DISABLE OSCILLATOR 1
;                                    ;   2       RING MODULATE OSC. 2 WITH OSC. 1 OUTPUT, 1 = ON
;                                    ;   1       SYNCHRONIZE OSC. 2 WITH OSC. 1 FREQUENCY, 1 = ON
;                                    ;   0       GATE BIT: 1 = START ATT/DEC/SUS, 0 = START RELEASE
;    &ubyte  ATDCY2          = $D40C ;           ENVELOPE GENERATOR 2: ATTACK / DECAY CYCLE CONTROL
;                                    ;   7-4     SELECT ATTACK CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT DECAY CYCLE DURATION: 0-15
;    &ubyte  SUREL2          = $D40D ;           ENVELOPE GENERATOR 2: SUSTAIN / RELEASE CYCLE CONTROL
;                                    ;   7-4     SELECT SUSTAIN CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT RELEASE CYCLE DURATION: 0-15
;    &ubyte  FRELO3          = $D40E ;           VOICE 3: FREQUENCY CONTROL - LOW-BYTE
;    &ubyte  FREHI3          = $D40F ;           VOICE 3: FREQUENCY CONTROL - HIGH-BYTE
;    &ubyte  PWLO3           = $D410 ;           VOICE 3: PULSE WAVEFORM WIDTH - LOW-BYTE
;    &ubyte  PWHI3           = $D411 ;   7-4     UNUSED
;                                    ;   3-0     VOICE 3: PULSE WAVEFORM WIDTH - HIGH-NYBBLE
;    &ubyte  VCREG3          = $D412 ;           VOICE 3: CONTROL REGISTER
;                                    ;   7       SELECT RANDOM NOISE WAVEFORM, 1 = ON
;                                    ;   6       SELECT PULSE WAVEFORM, 1 = ON
;                                    ;   5       SELECT SAWTOOTH WAVEFORM, 1 = ON
;                                    ;   4       SELECT TRIANGLE WAVEFORM, 1 = ON
;                                    ;   3       TEST BIT: 1 = DISABLE OSCILLATOR 1
;                                    ;   2       RING MODULATE OSC. 3 WITH OSC. 2 OUTPUT, 1 = ON
;                                    ;   1       SYNCHRONIZE OSC. 3 WITH OSC. 2 FREQUENCY, 1 = ON
;                                    ;   0       GATE BIT: 1 = START ATT/DEC/SUS, 0 = START RELEASE
;    &ubyte  ATDCY3          = $D413 ;   ENVELOPE GENERATOR 3: ATTAC/DECAY CYCLE CONTROL
;                                    ;   7-4     SELECT ATTACK CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT DECAY CYCLE DURATION: 0-15
;    &ubyte  SUREL3          = $D414 ;           ENVELOPE GENERATOR 3: SUSTAIN / RELEASE CYCLE CONTROL
;                                    ;   7-4     SELECT SUSTAIN CYCLE DURATION: 0-15
;                                    ;   3-0     SELECT RELEASE CYCLE DURATION: 0-15
;    &ubyte  CUTLO           = $D415 ;           FILTER CUTOFF FREQUENCY: LOW-NYBBLE (BITS 2-0)
;    &ubyte  CUTHI           = $D416 ;           FILTER CUTOFF FREQUENCY: HIGH-BYTE
;    &ubyte  RESON           = $D417 ;           FILTER RESONANCE CONTROL / VOICE INPUT CONTROL
;                                    ;   7-4     SELECT FILTER RESONANCE: 0-15
;                                    ;   3       FILTER EXTERNAL INPUT: 1 = YES, 0 = NO
;                                    ;   2       FILTER VOICE 3 OUTPUT: 1 = YES, 0 = NO
;                                    ;           FILTER VOICE 2 OUTPUT: 1 = YES, 0 = NO
;                                    ;   0       FILTER VOICE 1 OUTPUT: 1 = YES, 0 = NO
;    &ubyte  SIGVOL          = $D418 ;           SELECT FILTER MODE AND VOLUME
;                                    ;   7       CUT-OFF VOICE 3 OUTPUT: 1 = OFF, 0 = ON
;                                    ;   6       SELECT FILTER HIGH-PASS MODE: 1 = ON
;                                    ;   5       SELECT FILTER BAND-PASS MODE: 1 = ON
;                                    ;   4       SELECT FILTER LOW-PASS MODE: 1 = ON
;                                    ;   3-0     SELECT OUTPUT VOLUME: 0-15
;    &ubyte  POTX            = $D419 ;           ANALOG/DIGITAL CONVERTER: GAME PADDLE 1 (0-255)
;    &ubyte  POTY            = $D41A ;           ANALOG/DIGITAL CONVERTER GAME PADDLE 2 (0-255)
;    &ubyte  RANDOM          = $D41B ;           OSCILLATOR 3 RANDOM NUMBER GENERATOR
;    &ubyte  ENV3            = $D41C ;           ENVELOPE GENERATOR 3 OUTPUT
;    &ubyte  COLOR           = $D800 ;-DBFF       55296-56319     COLOR RAM (NYBBLES)
;    &ubyte  CIAPRA          = $DC00 ;           DATA PORT A (KEYBOARD, JOYSTICK, PADDLES, LIGHT-PEN)
;                                    ;
;                                    ;   7-0     WRITE KEYBOARD COLUMN VALUES FOR KEYBOARD SCAN
;                                    ;   7-6     READ PADDLES ON PORT A / B (01 = PORT A, 10 = PORT B)
;                                    ;   4       JOYSTICK A FIRE BUTTON: 1 = FIRE
;                                    ;   3-2     PADDLE FIRE BUTTONS
;                                    ;   3-0     JOYSTICK A DIRECTION (0-15)
;    &ubyte  CIAPRB          = $DC01 ;           DATA PORT B (KEYBOARD, JOYSTICK, PADDLES): GAME PORT 1
;                                    ;   7-0     READ KEYBOARD ROW VALUES FOR KEYBOARD SCAN
;                                    ;
;                                    ;   7       TIMER B TOGGLE/PULSE OUTPUT
;                                    ;   6       TIMER A: TOGGLE/PULSE OUTPUT
;                                    ;
;                                    ;   4       JOYSTICK 1 FIRE BUTTON: 1 = FIRE
;                                    ;   3-2     PADDLE FIRE BUTTONS
;                                    ;   3-0     JOYSTICK 1 DIRECTION
;    &ubyte  CIDDRA          = $DC02 ;           DATA DIRECTION REGISTER - PORT A (56320)
;    &ubyte  CIDDRB          = $DC03 ;           DATA DIRECTION REGISTER - PORT B (56321)
;    &ubyte  TIMALO          = $DC04 ;           TIMER A: LOW-BYTE
;    &ubyte  TIMAHI          = $DC05 ;           TIMER A: HIGH-BYTE
;    &ubyte  TIMBLO          = $DC06 ;           TIMER B: LOW-BYTE
;    &ubyte  TIMBHI          = $DC07 ;           TIMER B: HIGH-BYTE
;    &ubyte  TODTEN          = $DC08 ;           TIME-OF-DAY CLOCK: 1/10 SECONDS
;    &ubyte  TODSEC          = $DC09 ;           TIME-OF-DAY CLOCK: SECONDS
;    &ubyte  TODMIN          = $DC0A ;           TIME-OF-DAY CLOCK: MINUTES
;    &ubyte  TODHRS          = $DC0B ;           TIME-OF-DAY CLOCK: HOURS + AM/PM FLAG (BIT 7)
;    &ubyte  CIASDR          = $DC0C ;           SYNCHRONOUS SERIAL I/O DATA BUFFER
    &ubyte  CIAICR          = $DC0D ;           CIA INTERRUPT CONTROL REGISTER (READ IRQS/WRITE MASK)
;                                    ;   7       IRQ FLAG (1 = IRQ OCCURRED) / SET-CLEAR FLAG
;                                    ;   4       FLAG1 IRQ (CASSETTE READ / SERIAL BUS SRQ INPUT)
;                                    ;   3       SERIAL PORT INTERRUPT
;                                    ;   2       TIME-OF-DAY CLOCK ALARM INTERRUPT
;                                    ;   1       TIMER B INTERRUPT
;                                    ;   0       TIMER A INTERRUPT
;    &ubyte  CIACRA          = $DC0E ;           CIA CONTROL REGISTER A
;                                    ;   7       TIME-OF-DAY CLOCK FREQUENCY: 1 = 50 HZ, 0 = 60 HZ
;                                    ;   6       SERIAL PORT I/O MODE OUTPUT, 0 = INPUT
;                                    ;   5       TIMER A COUNTS: 1 = CNT SIGNALS, 0 = SYSTEM 02 CLOCK
;                                    ;   4       FORCE LOAD TIMER A: 1 = YES
;                                    ;   3       TIMER A RUN MODE: 1 = ONE-SHOT, 0 = CONTINUOUS
;                                    ;   2       TIMER A OUTPUT MODE TO PB6: 1 = TOGGLE, 0 = PULSE
;                                    ;   1       TIMER A OUTPUT ON PB6: 1 = YES, 0 = NO
;                                    ;   0       START/STOP TIMER A: 1 = START, 0 = STOP
;    &ubyte  CIACRB          = $DC0F ;           CIA CONTROL REGISTER B
;                                    ;   7       SET ALARM/TOD-CLOCK: 1 = ALARM, 0 = CLOCK
;                                    ;   6-5     TIMER B MODE SELECT:
;                                    ;                   00 = COUNT SYSTEM 02 CLOCK PULSES
;                                    ;                   01 = COUNT POSITIVE CNT TRANSITIONS
;                                    ;                   10 = COUNT TIMER A UNDERFLOW PULSES
;                                    ;                   11 = COUNT TIMER A UNDERFLOWS WHILE CNT POSITIVE
;                                    ;   4-0     SAME AS CIA CONTROL REG. A - FOR TIMER B
;    &ubyte  CI2PRA          = $DD00 ;           DATA PORT A (SERIAL BUS, RS-232, VIC MEMORY CONTROL)
;                                    ;   7       SERIAL BUS DATA INPUT
;                                    ;   6       SERIAL BUS CLOCK PULSE INPUT
;                                    ;   5       SERIAL BUS DATA OUTPUT
;                                    ;   4       SERIAL BUS CLOCK PULSE OUTPUT
;                                    ;   3       SERIAL BUS ATN SIGNAL OUTPUT
;                                    ;   2       RS-232 DATA OUTPUT (USER PORT)
;                                    ;   1-0     VIC CHIP SYSTEM MEMORY BANK SELECT (DEFAULT = 11)
;    &ubyte  CI2PRB          = $DD01 ;   DATA PORT B (USER PORT, RS-232)
;                                    ;   7       USER / RS-232 DATA SET READY
;                                    ;   6       USER / RS-232 CLEAR TO SEND
;                                    ;   5       USER
;                                    ;   4       USER / RS-232 CARRIER DETECT
;                                    ;   3       USER / RS-232 RING INDICATOR
;                                    ;   2       USER / RS-232 DATA TERMINAL READY
;                                    ;   1       USER / RS-232 REQUEST TO SEND
;                                    ;   0       USER / RS-232 RECEIVED DATA
;    &ubyte  C2DDRA          = $DD02 ;           DATA DIRECTION REGISTER - PORT A
;    &ubyte  C2DDRB          = $DD03 ;           DATA DIRECTION REGISTER - PORT B
;    &ubyte  TI2ALO          = $DD04 ;           TIMER A: LOW-BYTE
;    &ubyte  TI2AHI          = $DD05 ;           TIMER A: HIGH-BYTE
;    &ubyte  TI2BLO          = $DD06 ;           TIMER B: LOW-BYTE
;    &ubyte  TI2BHI          = $DD07 ;           TIMER B: HIGH-BYTE
    &ubyte  TO2TEN          = $DD08 ;           TIME-OF-DAY CLOCK: 1/10 SECONDS
    &ubyte  TO2SEC          = $DD09 ;           TIME-OF-DAY CLOCK: SECONDS
    &ubyte  TO2MIN          = $DD0A ;           TIME-OF-DAY CLOCK: MINUTES
    &ubyte  TO2HRS          = $DD0B ;           TIME-OF-DAY CLOCK: HOURS + AM/PM FLAG (BIT 7)
;    &ubyte  CI2SDR          = $DD0C ;           SYNCHRONOUS SERIAL I/O DATA BUFFER
;    &ubyte  CI2ICR          = $DD0D ;           CIA INTERRUPT CONTROL REGISTER (READ NMLS/WRITE MASK)
;                                    ;   7       NMI FLAG (1 = NMI OCCURRED) / SET-CLEAR FLAG
;                                    ;   4       FLAG1 NMI (USER/RS-232 RECEIVED DATA INPUT)
;                                    ;   3       SERIAL PORT INTERRUPT
;                                    ;   1       TIMER B INTERRUPT
;                                    ;   0       TIMER A INTERRUPT
;    &ubyte  CI2DRA          = $DD0E ;           CIA CONTROL REGISTER A
;                                    ;   7       TIME-OF-DAY CLOCK FREQUENCY: 1 = 50 HZ, 0 = 60 HZ
;                                    ;   6       SERIAL PORT I/O MODE OUTPUT, 0 = INPUT
;                                    ;   5       TIMER A COUNTS: 1 = CNT SIGNALS, 0 = SYSTEM 02 CLOCK
;                                    ;   4       FORCE LOAD TIMER A: 1 = YES
;                                    ;   3       TIMER A RUN MODE: 1 = ONE-SHOT, 0 = CONTINUOUS
;                                    ;   2       TIMER A OUTPUT MODE TO PB6: 1 = TOGGLE, 0 = PULSE
;                                    ;   1       TIMER A OUTPUT ON PB6: 1 = YES, 0 = NO
;                                    ;   0       START/STOP TIMER A: 1 = START, 0 = STOP
;    &ubyte  CI2CRB          = $DD0F ;           CIA CONTROL REGISTER B
;                                    ;   7       SET ALARM/TOD-CLOCK: 1 = ALARM, 0 = CLOCK
;                                    ;   6-5     TIMER B MODE SELECT:
;                                    ;                   00 = COUNT SYSTEM 02 CLOCK PULSES
;                                    ;                   01 = COUNT POSITIVE CNT TRANSITIONS
;                                    ;                   10 = COUNT TIMER A UNDERFLOW PULSES
;                                    ;                   11 = COUNT TIMER A UNDERFLOWS WHILE CNT POSITIVE
;                                    ;   4-0     SAME AS CIA CONTROL REG. A - FOR TIMER B
}