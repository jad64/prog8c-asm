;----------------------------------------------
; main.p8
;----------------------------------------------

%output  library
%address $8000
%memtop  $A000


%import syslib

%import io
%import ram

%import stacks
%import "util_misc-asm"
%import "util_string-asm"
%import label
%import macro
%import fileio
%import command
%import mnemonic
%import "mnemonic-asm"
%import messages
%import assembler
%import evaluate
%import "label-asm"

;----------------------------------------------
;  c64
;----------------------------------------------
c64 {
	%option merge

	%asminlude ".\inc\io.i"

	extsub $79   = CHRGOT() -> ubyte @A, bool @Pz
	extsub $E20E = PAOC30()
	extsub $E206 = PAOC20()
	extsub $E257 = PAOC15() -> uword @XY, ubyte @A
	extsub $E200 = PLSV7() -> ubyte @X
}

;----------------------------------------------
;  main
;----------------------------------------------
main {

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	str fnadr = "?"*16
	ubyte fnlen

	;----------------------------------------------
	;  start()
	;----------------------------------------------
	sub start()
	{
		util.puts("\x0E\nAssembler (w) 2026 by jad\n")

		; check for parameters
		void c64.CHRGOT()
		if_eq {
			util.puts("\nusage: sys32768,\"filename\",fa\n")

			return
		}

		cbm.SETMSG(%00_000000)

		; skip comma
		c64.PAOC30()
		; get file name parameters
		c64.PAOC20()
		void c64.PAOC15()
		; get device number to .x
		c64.PAOC20()
		c64.FA = c64.PLSV7()

		c64.R6510 = $36

		util.str_init()
		util.str_nappend_str(c64.FNADR, c64.FNLEN)
		fnlen = util.str_store(fnadr)

		label.init()

		for asm.pass in 1 to 2 {
			asm.init()
			macro.init()
			stacks.init()
			fileio.init()
			command.init()

			fileio.fnadr = fnadr
			fileio.fnlen = fnlen
			asm.parse_file()
		}

		;	display tod
		util.str_copy("\nElapsed time:")
		util.str_append_hex(c64.TO2MIN)
		util.str_append_char(':')
		util.str_append_hex(c64.TO2SEC)
		util.str_append_char('.')
		util.str_append_hex(c64.TO2TEN)
		util.str_puts()

		c64.R6510 = $37
	}
}
