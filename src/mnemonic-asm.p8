;----------------------------------------------
; mnemonic-asm.p8
;----------------------------------------------

;----------------------------------------------
;  mnemonic
;----------------------------------------------
mnemonic {

	%option merge

	;----------------------------------------------
	;  find()
	;----------------------------------------------
	asmsub find() clobbers(A,X,Y) -> bool @Pc {
		%asm {{

			ldy		p8b_asm.p8s_parse_line.p8v_ptr
			lda		p8b_fileio.p8v_line_buffer+3,y
			jsr  	p8b_asm.p8s_is_delimeter
			cmp  	#1
			bne		_fnf

			addbi	p8b_asm.p8s_parse_line.p8v_ptr,3

			ldx		#size(mnemonic0)-1
_f0			lda		mnemonic0,x
			cmp		p8b_fileio.p8v_line_buffer+0,y
			bne		_fn
			lda		mnemonic1,x
			cmp		p8b_fileio.p8v_line_buffer+1,y
			bne		_fn
			lda		mnemonic2,x
			cmp		p8b_fileio.p8v_line_buffer+2,y
			beq		_ff
_fn			dex
			bpl		_f0
_fnf		clc
			rts
_ff			sec
			stx		p8v_num
			rts

mnemonic0 	.text	"aaabbbbbbbbbbcccccccdddeiiijjllllnopppprrrrssssssstttttt"
mnemonic1 	.text	"dnscceimnprvvllllmppeeeonnnmsdddsorhhlloottbeeetttaasxxy"
mnemonic2 	.text	"cdlcsqtielkcscdivpxycxyrcxypraxyrpaapaplrisccdiaxyxyxasa"

			; !notreached!
		}}
	}
}
