;----------------------------------------------
; label-asm.p8
;----------------------------------------------

;----------------------------------------------
;  label
;----------------------------------------------
label {

	%option merge

	;----------------------------------------------
	;  find_block()
	;----------------------------------------------
	asmsub find_block(ubyte block @A) clobbers(X,Y) {
		%asm {{

			sta  	P8ZP_SCRATCH_B1

			lda		p8v_count
			ora		p8v_count+1
			beq		_lbnf

			movew	P8ZP_SCRATCH_PTR,p8v_last

			loadw	P8ZP_SCRATCH_W1,0
_fb0		ldy		#p8t_S_LABEL.p8v_block_num
			cmpb	P8ZP_SCRATCH_B1,(P8ZP_SCRATCH_PTR),y
			bne		_fbn

			ldy		#p8t_S_LABEL.p8v_name_crc
			cmpb	p8s_str_find_label.p8v_crc,(P8ZP_SCRATCH_PTR),y
			bne		_fbn

			ldy		#p8t_S_LABEL.p8v_name_length
			cmpb	p8s_str_find_label.p8v_length,(P8ZP_SCRATCH_PTR),y
			bne		_fbn

			ldy		#p8t_S_LABEL.p8v_name-1
			ldx		#<-1
_fb1		iny
			inx
			lda		(P8ZP_SCRATCH_PTR),y
			cmp		p8b_util.p8v_string,x
			bne		_fbn
			cmp		#0
			bne		_fb1

;	label found
			movew	p8v_find_result,P8ZP_SCRATCH_PTR
			rts

_fbn		ldy		#p8t_S_LABEL.p8v_prev
			pushb	(P8ZP_SCRATCH_PTR),y
			iny
			lda		(P8ZP_SCRATCH_PTR),y
			sta		P8ZP_SCRATCH_PTR+1
			popb	P8ZP_SCRATCH_PTR

			incw	P8ZP_SCRATCH_W1
			cmpw	P8ZP_SCRATCH_W1,p8v_count
			bcc		_fb0

;	label not found
_lbnf		loadw	p8v_find_result,0
			rts
		}}
	}

	;----------------------------------------------
	;  str_get_crc()
	;----------------------------------------------
	asmsub str_get_crc(ubyte length @X) -> ubyte @A {
		%asm {{

			txa
			clc
-			adc		p8b_util.p8v_string-1,x
			dex
			bne		-
			rts
		}}
	}
}
