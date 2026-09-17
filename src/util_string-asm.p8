;----------------------------------------------
; util_util.str_p8
;----------------------------------------------

util {

	%asminclude "../inc/asc.i"
	%asminclude "../inc/kernel.i"
	%asminclude "../inc/macros.i"

	;----------------------------------------------
	;  util string
	;----------------------------------------------
	ubyte[256] string
	ubyte[32] split

	;----------------------------------------------
	;  str_init()
	;----------------------------------------------
	asmsub str_init() clobbers(A) {
		%asm {{

			lda		#0
			sta		p8v_string
			rts
		}}
	}

	;----------------------------------------------
	;  str_length()
	;----------------------------------------------
	asmsub str_length() clobbers(Y) -> ubyte @A {
		%asm {{

			lday	p8v_string
			jmp		p8s_strlen
		}}
	}

	;----------------------------------------------
	;  str_replace()
	;
	; string = haystack
	;----------------------------------------------
	asmsub str_replace(uword search @AY, uword replace @R0) clobbers(X) {
		%asm {{

			stay	P8ZP_SCRATCH_PTR
			jsr		p8b_util.p8s_strlen
			sta		diff

			lda		cx16.r0L
			ldy		cx16.r0H
;			stay	P8ZP_SCRATCH_W1
			jsr		p8b_util.p8s_strlen
			sec
			sbc		diff
			sta		diff

_l0			jsr		p8s_str_str._internal
			cmp		#<-1
			beq		_lx

			tax
			jsr		_adjust

			ldy		#0
_l1			lda		(P8ZP_SCRATCH_W1),y
			beq		_l0
			sta		p8v_string,x
			inx
			iny
			bne		_l1									;	jmp

_adjust		lda		diff
			beq		_lx
			stx		tmpx
			bmi		_delete

_insert		ldx		#255
			sec
			txa
			sbc		diff
			tay
_i0			lda		p8v_string,y
			sta		p8v_string,x
			dey
			dex
			cpx		tmpx
			bne		_i0
_lx			rts

_delete		clc
;			lda		diff
			adc		tmpx
			tay
_d0			lda		p8v_string+1,x
			sta		p8v_string+1,y
			iny
			inx
			bne		_d0
			ldx		tmpx
			rts

.section	BSS_NOCLEAR
diff		.byte	?
tmpx		.byte	?
.endsection	BSS_NOCLEAR

			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_str()
	;
	; string = haystack
	;----------------------------------------------
	asmsub str_str(uword needle @AY) clobbers(X)  -> ubyte @A {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

_internal	ldx     #0
			stx		pos

_L0			ldy     #0
			ldx     pos

_L1			lda		(P8ZP_SCRATCH_PTR),y
			beq		_LM

			lda		p8v_string,x
			beq		_LNM

			cmp		(P8ZP_SCRATCH_PTR),y
			bne		_LD

			iny
			inx
			bne		_L1

_LD			inc		pos
			bne		_L0
;	needle not found
_LNM		lda		#<-1
			rts
;	needle found
_LM			lda     pos
			rts

.section	BSS_NOCLEAR
pos			.byte	?
.endsection	BSS_NOCLEAR
			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_padr()
	;----------------------------------------------
	asmsub str_padr(ubyte length @Y, ubyte ch @A) {
		%asm {{

			pha
			sty		length
			jsr		p8s_str_length
			pla
			cpy		length
			bcs		_ls
;	PAD
_lpad		sta		p8v_string,y
			iny
			cpy		length
			bcc		_lpad

_ls			lda		#0
			ldy		length
			sta		p8v_string,y
			rts

.section	BSS_NOCLEAR
length		.byte	?
.endsection	BSS_NOCLEAR

			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_cmp()
	;----------------------------------------------
	asmsub str_cmp(uword str_ @AY) -> ubyte @A {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

			ldy		#<-1
_l0			iny
			lda		p8v_string,y
		;	jsr		p8b_uttil.p8s_tolower
			cmp		(P8ZP_SCRATCH_PTR),y
			beq		_lq

			bmi		_ll
_lg			lda		#1
			rts
_ll			lda		#<-1
			rts

_lq			cmp		#0
			bne		_l0
			rts
		}}
	}

	;----------------------------------------------
	;  str_split()
	;----------------------------------------------
	asmsub str_split(ubyte ch @A) clobbers(Y) {
		%asm {{

			sta		ch

			ldy		#0
			sty		p8v_split

_l0			lda		p8v_string,y
			beq		_lx
			cmp		ch
			bne		_l1

			lda		#0
			sta		p8v_string,y

			inc		p8v_split
			ldx		p8v_split
			tya
			sta		p8v_split,x

_l1			iny
			bne		_l0
_lx			rts

.section	BSS_NOCLEAR
ch			.byte	?
.endsection	BSS_NOCLEAR

			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_unsplit()
	;----------------------------------------------
	asmsub str_unsplit(ubyte ch @A, ubyte length @Y) clobbers(X) {
		%asm {{

			sty		length

			ldy		#0
_l0			ldx		p8v_split+1,y
			sta		p8v_string,x
			iny
			dec		length
			bne		_l0

			lda		#0
			sta		p8v_string+1,x
			rts

.section	BSS_NOCLEAR
length		.byte	?
.endsection	BSS_NOCLEAR

			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_ltrim()
	;----------------------------------------------
	asmsub str_ltrim() clobbers(A,X,Y) {
		%asm {{

			ldx		#<-1
_l0			inx
			lda		p8v_string,x
			cmp		#ASC_SPACE
			beq		_l0

			jmp		p8s_str_scroll_left
		}}
	}

	;----------------------------------------------
	;  str_scroll_left()
	;----------------------------------------------
	; TODO: verify correct operation
	asmsub str_scroll_left(ubyte scroll @X) clobbers(A,Y) {
		%asm {{

			ldy		#0
_l0			lda		p8v_string,x
			sta		p8v_string,y
			iny
			inx
			bne		_l0
			rts
		}}
	}

	;----------------------------------------------
	;  str_copy()
	;----------------------------------------------
	asmsub str_copy(uword string @AY) {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

			ldy		#0
_l0			lda		(P8ZP_SCRATCH_PTR),y
			sta		p8v_string,y
			beq		_lx
			iny
			bne		_l0						;	jmp
_lx			rts
		}}
	}

	;----------------------------------------------
	;  str_store()
	;----------------------------------------------
	asmsub str_store(uword address @AY) -> ubyte @Y {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

			ldy		#0
_l0			lda		p8v_string,y
			sta		(P8ZP_SCRATCH_PTR),y
			beq		_lx
			iny
			bne		_l0						;	jmp
_lx			rts
		}}
	}

	;----------------------------------------------
	;  str_append_str()
	;----------------------------------------------
	asmsub str_append_str(uword str_ @AY) clobbers(X) {
		%asm {{

			stay	P8ZP_SCRATCH_PTR

			jsr		p8s_str_length
;			tya
			tax

			ldy		#0
_l0			lda		(P8ZP_SCRATCH_PTR),y
			sta		p8v_string,x
			beq		_lx
			inx
			iny
			bne		_l0						;	jmp
_lx			rts
		}}
	}

	;----------------------------------------------
	;  str_nappend_str()
	;----------------------------------------------
	asmsub str_nappend_str(uword string @AY, ubyte length @X) {
		%asm {{

			stay	P8ZP_SCRATCH_PTR
			stx		P8ZP_SCRATCH_REG

			jsr		p8s_str_length
;			tya
			tax

			ldy		#0
_l0			lda		(P8ZP_SCRATCH_PTR),y
			sta		p8v_string,x
			inx
			iny
			dec		P8ZP_SCRATCH_REG
			bne		_l0

			lda		#0
			sta		p8v_string,x
			rts
		}}
	}

	;----------------------------------------------
	;  str_append_char()
	;----------------------------------------------
	asmsub str_append_char(ubyte ch @A) clobbers(Y) {
		%asm {{

			pha

			jsr		p8s_str_length

			pla
			sta		p8v_string,y
			lda		#0
			sta		p8v_string+1,y
			rts
		}}
	}

	;----------------------------------------------
	;  str_append_bin()
	;----------------------------------------------
	asmsub str_append_bin(ubyte value @A) clobbers(X,Y) {
		%asm {{

			sta		value
			ldx		#8
-			asl		value
			lda		#0
			adc		#"0"
			jsr		p8s_str_append_char
			dex
			bne		-
			rts

.section	BSS_NOCLEAR
value		.byte	?
.endsection	BSS_NOCLEAR
			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_append_hex()
	;----------------------------------------------
	asmsub str_append_hex(ubyte value @A) clobbers(Y) {
		%asm {{

			pha
			lsr
			lsr
			lsr
			lsr
			jsr		_nib
			pla

_nib		and		#$0f
			sed
			cmp		#10
			adc		#'0'
			cld
			jmp		p8s_str_append_char
		}}
	}

	;----------------------------------------------
	;  str_append_dec()
	;----------------------------------------------
asmsub str_append_dec(uword value @AY) clobbers(X) {
		%asm {{

			sta		tmpv
			stay	P8ZP_SCRATCH_PTR

			lda		#'0'+1
			sta		digit0

			ldx		#4
_pd1		dec		digit0
_pd2		lda		#'0'-1
			sta		digit

			sec
			bcs		_pds
_pd3		sta		P8ZP_SCRATCH_PTR+1
_pds		lda		tmpv
			sta		P8ZP_SCRATCH_PTR

			inc		digit

			sbc		_potsl,x
			sta		tmpv
			lda		P8ZP_SCRATCH_PTR+1
			sbc		_potsh,x
			bcs		_pd3

			lda		P8ZP_SCRATCH_PTR
			sta		tmpv

			lda		digit
			cmp		digit0
			beq		_pd4

			jsr		p8s_str_append_char

			dec		digit0

_pd4		dex
			beq		_pd1
			bpl		_pd2
			rts

.section	BSS_NOCLEAR
tmpv		.byte	?
digit		.byte	?
digit0		.byte	?
.endsection	BSS_NOCLEAR

;	powers of ten
_pots		:=		1, 10, 100, 1000, 10000
_potsl		.byte	<_pots
_potsh		.byte	>_pots

			; !notreached!
		}}
	}

	;----------------------------------------------
	;  str_puts()
	;----------------------------------------------
	asmsub str_puts() clobbers (A,Y) {
		%asm {{

			lday	p8v_string
			jmp		p8s_puts
		}}
	}
}
