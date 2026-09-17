;----------------------------------------------
;  macros.i
;----------------------------------------------

;----------------------------------------------
;  sfunctions
;----------------------------------------------
to_vmcsb		.sfunction	_screen, _gfx,	(>(((_screen & $3fff) * 4))) | (((>_gfx) / 4) & $0f)
to_ci2pra		.sfunction	_gfx,			(%00000011 ^ ((>_gfx) / $40))


;----------------------------------------------
;  basic_upstart
;----------------------------------------------
basic_upstart	.function	year, start

				.addr	+
				.word	year									; line number
				.byte	$9e										; sys token
				.null	format("%d", start)
+				.word	0										; basic end marker
.endfunction

;----------------------------------------------
;  load byte
;----------------------------------------------
loadb			.function	dest, imm

				lda		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  load word
;----------------------------------------------
loadw			.function	dest, imm

				lda		#>(imm)
				sta		dest+1
				.ifne	<(imm) - >(imm)
				lda		#<(imm)
				.endif
				sta		dest
.endfunction

;----------------------------------------------
;  load byte via .x
;----------------------------------------------
loadx			.function	dest, imm

				ldx		#imm
				stx		dest
.endfunction

;----------------------------------------------
;  load x/y
;----------------------------------------------
ldxy			.function	value

				ldy		#>(value)
				ldx		#<(value)
.endfunction

;----------------------------------------------
;  store x/y
;----------------------------------------------
stxy			.function	dest

				stx		dest
				sty		dest+1
.endfunction

;----------------------------------------------
;  load y/a
;----------------------------------------------
ldya			.function	value

				lda		#>(value)
				ldy		#<(value)
.endfunction

;----------------------------------------------
;  store y/a
;----------------------------------------------
stya			.function	dest

				sty		dest
				sta		dest+1
.endfunction

;----------------------------------------------
;  mov a/y
;----------------------------------------------
movay			.function	addr

				ldy		addr+1
				lda		addr
.endfunction

;----------------------------------------------
;  adc a/y
;----------------------------------------------
adcay			.function	value

				clc
				adc		value
				bcc		+
				iny
+
.endfunction

;----------------------------------------------
;  adc+1 a/y
;----------------------------------------------
adsay			.function	value

				sec
				adc		value
				bcc		+
				iny
+
.endfunction

;----------------------------------------------
;  load a/y
;----------------------------------------------
lday			.function	value

				lda		#<(value)
				ldy		#>(value)
.endfunction

;----------------------------------------------
;  store a/y
;----------------------------------------------
stay			.function	dest

				sta		dest
				sty		dest+1
.endfunction

;----------------------------------------------
;  move byte
;----------------------------------------------
moveb			.function	dest, sour

				lda		sour
				sta		dest
.endfunction

;----------------------------------------------
;  move word
;----------------------------------------------
movew			.function	dest, sour

				lda		sour+1
				sta		dest+1
				lda		sour
				sta		dest
.endfunction

;----------------------------------------------
;  increment word
;----------------------------------------------
incw			.function	word

				inc		word
				bne		+
				inc		word+1
+
.endfunction

;----------------------------------------------
;  decrement word
;----------------------------------------------
decw			.function	word

				lda		word
				bne		+
				dec		word+1
+				dec		word
.endfunction

;----------------------------------------------
;  add
;----------------------------------------------
add				.function	sour

				clc
				adc		sour
.endfunction

;----------------------------------------------
;  add byte
;----------------------------------------------
addb			.function	dest, sour

				clc
				lda		dest
				adc		sour
				sta		dest
.endfunction

;----------------------------------------------
;  add byte to word
;----------------------------------------------
addwb			.function	dest, sour

				clc
				lda		dest
				adc		sour
				sta		dest
				bcc		+
				inc		dest+1
+
.endfunction

;----------------------------------------------
;  add accumulator to byte
;----------------------------------------------
addba			.function	dest

				clc
				adc		dest
				sta		dest
.endfunction

;----------------------------------------------
;  add accumulator to byte
;----------------------------------------------
addbba			.function	sour, dest

				clc
				adc		sour
				sta		dest
.endfunction

;----------------------------------------------
;  add accumulator to word
;----------------------------------------------
addwa			.function	dest

				clc
				adc		dest
				sta		dest
				bcc		+
				inc		dest+1
+
.endfunction

;----------------------------------------------
;  add word
;----------------------------------------------
addw			.function	dest, sour

				clc
				lda		dest
				adc		sour
				sta		dest
				lda		dest+1
				adc		sour+1
				sta		dest+1
.endfunction

;----------------------------------------------
;  add immediate byte
;----------------------------------------------
addbi			.function	dest, imm

				clc
				lda		dest
				adc		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  add immediate byte
;----------------------------------------------
addbbi			.function	source, dest, imm

				clc
				lda		source
				adc		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  sub immediate byte
;----------------------------------------------
subbbi			.function	source, dest, imm

				sec
				lda		source
				sbc		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  add immediate word
;----------------------------------------------
addwwi			.function	source, dest, imm

				clc
				lda		source
				adc		#<imm
				sta		dest
				lda		source+1
				adc		#>imm
				sta		dest+1
.endfunction

;----------------------------------------------
;  add immediate word
;----------------------------------------------
addwi			.function	dest, imm

				clc
				lda		dest
				adc		#<(imm)
				sta		dest
				.ifne	>(imm)
				lda		dest+1
				adc		#>(imm)
				sta		dest+1
				.else
				bcc		+
				inc		dest+1
+
				.endif
.endfunction

;----------------------------------------------
;  and  byte
;----------------------------------------------
andb			.function	addr1, addr2

				lda		addr1
				and		addr2
				sta		addr1
.endfunction

;----------------------------------------------
;  and immediate byte
;----------------------------------------------
andbi			.function	dest, imm

				lda		dest
				and		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  and byte with accumulator
;----------------------------------------------
andba			.function	dest

				and		dest
				sta		dest
.endfunction

;----------------------------------------------
;  or immediate byte
;----------------------------------------------
orabi			.function	dest, imm

				lda		dest
				ora		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  ora byte with accumulator
;----------------------------------------------
oraba			.function	dest

				ora		dest
				sta		dest
.endfunction

;----------------------------------------------
;  ora byte
;----------------------------------------------
orab			.function	dest, sour

				lda		dest
				ora		sour
				sta		dest
.endfunction

;----------------------------------------------
;  eor immediate byte
;----------------------------------------------
eorbi			.function	dest, imm

				lda		dest
				eor		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  eor byte with accumulator
;----------------------------------------------
eorba			.function	dest

				eor		dest
				sta		dest
.endfunction

;----------------------------------------------
;  sub
;----------------------------------------------
sub			.function	sour

				sec
				sbc		sour
.endfunction

;----------------------------------------------
;  sub immediate word
;----------------------------------------------
subwi			.function	dest, imm

				sec
				lda		dest
				sbc		#<(imm)
				sta		dest
				.ifeq	>(imm)
				bcs		+
				dec		dest+1
+
				.else
				lda		dest+1
				sbc		#>(imm)
				sta		dest+1
				.endif
.endfunction

;----------------------------------------------
;  sub immediate word
;----------------------------------------------
subbi			.function	dest, imm

				sec
				lda		dest
				sbc		#imm
				sta		dest
.endfunction

;----------------------------------------------
;  sub byte
;----------------------------------------------
subb			.function	dest, sour

				sec
				lda		dest
				sbc		sour
				sta		dest
.endfunction

;----------------------------------------------
;  sub byte from word
;----------------------------------------------
subwb			.function	dest, sour

				sec
				lda		dest
				sbc		sour
				sta		dest
				bcs		+
				dec		dest+1
+
.endfunction

;----------------------------------------------
;  sub word
;----------------------------------------------
subw			.function	dest, sour

				sec
				lda		dest
				sbc		sour
				sta		dest
				lda		dest+1
				sbc		sour+1
				sta		dest+1
.endfunction

;----------------------------------------------
;  compare byte w/.x
;----------------------------------------------
cpxb			.function	sour, imm

				ldx		sour
				cpx		imm
.endfunction

;----------------------------------------------
;  compare immediate byte w/.x
;----------------------------------------------
cpxbi			.function	sour, imm

				ldx		sour
				cpx		#imm
.endfunction

;----------------------------------------------
;  compare immediate byte w/.y
;----------------------------------------------
cpybi			.function	sour, imm

				ldy		sour
				cpy		#imm
.endfunction

;----------------------------------------------
;  compare immediate byte
;----------------------------------------------
cmpbi			.function	sour, imm

				lda		sour
				cmp		#imm
.endfunction

;----------------------------------------------
;  compare immediate word
;----------------------------------------------
cmpwi			.function	sour, imm

				lda		sour
				cmp		#<(imm)
				lda		sour+1
				sbc		#>(imm)
.endfunction

;----------------------------------------------
;  compare byte w/.y
;----------------------------------------------
cpyb			.function	sour, value

				ldy		sour
				cpy		value
.endfunction

;----------------------------------------------
;  compare byte
;----------------------------------------------
cmpb			.function	sour, value

				lda		sour
				cmp		value
.endfunction

;----------------------------------------------
;  compare word
;----------------------------------------------
cmpw			.function	sour, value

				lda		sour
				cmp		value
				lda		sour+1
				sbc		value+1
.endfunction

;----------------------------------------------
;  push byte
;----------------------------------------------
pushb			.function	sour

				lda		sour
				pha
.endfunction

;----------------------------------------------
;  pop byte
;----------------------------------------------
popb			.function	dest

				pla
				sta		dest
.endfunction

;----------------------------------------------
;  push word
;----------------------------------------------
pushw			.function	sour

				pushb	sour+1
				pushb	sour
.endfunction

;----------------------------------------------
;  push word immediate
;----------------------------------------------
pushwi			.function	imm

				pushb	#>(imm)
				pushb	#<(imm)
.endfunction

;----------------------------------------------
;  push .x
;----------------------------------------------
pushx			.function

				txa
				pha
.endfunction

;----------------------------------------------
;  push .y
;----------------------------------------------
pushy			.function

				tya
				pha
.endfunction

;----------------------------------------------
;  pop .x
;----------------------------------------------
popx			.function

				pla
				tax
.endfunction

;----------------------------------------------
;  pop .y
;----------------------------------------------
popy			.function

				pla
				tay
.endfunction

;----------------------------------------------
;  pop word
;----------------------------------------------
popw			.function	dest

				popb	dest
				popb	dest+1
.endfunction

;----------------------------------------------
;  stax
;----------------------------------------------
stax			.function	dest

				sta		dest
				stx		dest+1
.endfunction

;----------------------------------------------
;  stxa
;----------------------------------------------
stxa			.function	dest

				stx		dest
				sta		dest+1
.endfunction

;----------------------------------------------
;  bit 8
;----------------------------------------------
bit8			.function

				.byte		$24
.endfunction

;----------------------------------------------
;  bit 16
;----------------------------------------------
bit16			.function

				.byte		$2c
.endfunction
