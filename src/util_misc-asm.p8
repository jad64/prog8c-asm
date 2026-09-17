;----------------------------------------------
; util_misc.p8
;----------------------------------------------

util {
	%option merge

	%asminclude "../inc/kernel.i"
	%asminclude "../inc/asc.i"

	;----------------------------------------------
	;  strlen()
	;----------------------------------------------
	asmsub strlen(uword string @AY) -> ubyte @A {
		%asm {{

			stay	P8ZP_SCRATCH_W1

			ldy		#0
_l0			lda		(P8ZP_SCRATCH_W1),y
			beq		_lx
			iny
			bne		_l0						;	jmp

_lx			tya
			rts
		}}
	}

	;----------------------------------------------
	;  memcpy()
	;----------------------------------------------
	asmsub memcpy(uword source @AY, uword dest @R0, ubyte length @X) {
		%asm {{

			stay	P8ZP_SCRATCH_W1

			lda		cx16.r0L
			ldy		cx16.r0H
			sta		P8ZP_SCRATCH_W2
			sty		P8ZP_SCRATCH_W2+1

			ldy		#0
-			lda		(P8ZP_SCRATCH_W1),y
			sta		(P8ZP_SCRATCH_W2),y
			iny
			dex
			bne		-
			rts
		}}
	}

	;----------------------------------------------
	;  asc2scr()
	;----------------------------------------------
	asmsub asc2scr(ubyte asc @A) -> ubyte @A {
		%asm {{

			ora		#$00
			bmi		_G80
			cmp		#$20
			bcs		_G20
			ora		#$80
			rts
_G20		cmp		#$60
			bcc		_L60
			and		#$DF
			rts
_L60		and		#$3F
			rts

_G80		and		#$7F
			cmp		#$7F
			bne		_GPI
			lda		#$5E
_GPI		cmp		#$20
			bcs		_GA0
			ora		#$80
_GA0		ora		#$40
			rts
		}}
	}

	;----------------------------------------------
	;  tolower()
	;----------------------------------------------
	asmsub tolower(ubyte ch @A) -> ubyte @A {
        %asm {{

            and		#%0111_1111
            cmp		#$61					;	'A'
            bcc		+
            cmp		#$7B					;	'Z'+1
            bcs		+
            and		#%1101_1111
+           rts
        }}
    }

	;----------------------------------------------
	;  puts()
	;----------------------------------------------
	asmsub puts(str text @AY) clobbers(X) {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

		;	ldx		#1
		;	jsr		CHKOUT

			ldy		#0
_l0			lda		(P8ZP_SCRATCH_PTR),y
			beq		_lx
			jsr		CHROUT
			iny
			bne		_l0						;	jmp

_lx			rts
		}}
	}
}
