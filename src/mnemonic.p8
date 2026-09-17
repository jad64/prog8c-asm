;----------------------------------------------
; mnemonic.p8
;----------------------------------------------

;----------------------------------------------
;  mnemonic
;----------------------------------------------
mnemonic {

	;----------------------------------------------
	;  struct
	;----------------------------------------------
	struct S_MNEMONIC {
		str   name
		uword modes
		str   codes
	}

	;----------------------------------------------
	;  const
	;----------------------------------------------
	; addressing modes
	const uword AM_IMP		= %0000_0000_0001_0000	; no operand
	const uword AM_IMM		= %0000_0000_0010_0000	; #aa
	const uword AM_ZP		= %0000_0000_0100_0000	; zp
	const uword AM_ZPX		= %0000_0000_1000_0000	; zp,x
	const uword AM_ZPY		= %0000_0001_0000_0000	; zp,y
	const uword AM_ABS		= %0000_0010_0000_0000	; aaaa
	const uword AM_ABSX		= %0000_0100_0000_0000	; aaaa,x
	const uword AM_ABSY		= %0000_1000_0000_0000	; aaaa,y
	const uword AM_REL		= %0001_0000_0000_0000	; offset (+127/-128)
	const uword AM_INDX		= %0010_0000_0000_0000	; (zp,x)
	const uword AM_INDY		= %0100_0000_0000_0000	; (zp),y
	const uword AM_INDW		= %1000_0000_0000_0000	; (aaaa)

	const uword AM_INVALID	= 0

	^^S_MNEMONIC[] MNEMONICS = [
		["adc", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\x69\x65\x75\x6D\x7D\x79\x61\x71"],
		["and", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\x29\x25\x35\x2D\x3D\x39\x21\x31"],
		["asl", AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 						"\x0A\x06\x16\x0E\x1E"],
		["bcc", AM_REL, 													"\x90"],
		["bcs", AM_REL, 													"\xB0"],
		["beq", AM_REL, 													"\xF0"],
		["bit", AM_ZP|AM_ABS, 												"\x24\x2C"],
		["bmi", AM_REL, 													"\x30"],
		["bne", AM_REL, 													"\xD0"],
		["bpl", AM_REL, 													"\x10"],
		["brk", AM_IMP, 													"\x00"],
		["bvc", AM_REL, 													"\x50"],
		["bvs", AM_REL, 													"\x70"],
		["clc", AM_IMP, 													"\x18"],
		["cld", AM_IMP, 													"\xD8"],
		["cli", AM_IMP, 													"\x58"],
		["clv", AM_IMP, 													"\xB8"],
		["cmp", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\xC9\xC5\xD5\xCD\xDD\xD9\xC1\xD1"],
		["cpx", AM_IMM|AM_ZP|AM_ABS, 										"\xE0\xE4\xEC"],
		["cpy", AM_IMM|AM_ZP|AM_ABS, 										"\xC0\xC4\xCC"],
		["dec", AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 								"\xC6\xD6\xCE\xDE"],
		["dex", AM_IMP, 													"\xCA"],
		["dey", AM_IMP, 													"\x88"],
		["eor", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\x49\x45\x55\x4D\x5D\x59\x41\x51"],
		["inc", AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 								"\xE6\xF6\xEE\xFE"],
		["inx", AM_IMP, 													"\xE8"],
		["iny", AM_IMP, 													"\xC8"],
		["jmp", AM_ABS|AM_INDW, 											"\x4C\x6C"],
		["jsr", AM_ABS, 													"\x20"],
		["lda", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\xA9\xA5\xB5\xAD\xBD\xB9\xA1\xB1"],
		["ldx", AM_IMM|AM_ZP|AM_ZPY|AM_ABS|AM_ABSY, 						"\xA2\xA6\xB6\xAE\xBE"],
		["ldy", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 						"\xA0\xA4\xB4\xAC\xBC"],
		["lsr", AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 						"\x4A\x46\x56\x4E\x5E"],
		["nop", AM_IMP, 													"\xEA"],
		["ora", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\x09\x05\x15\x0D\x1D\x19\x01\x11"],
		["pha", AM_IMP, 													"\x48"],
		["php", AM_IMP, 													"\x08"],
		["pla", AM_IMP, 													"\x68"],
		["plp", AM_IMP, 													"\x28"],
		["rol", AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 						"\x2A\x26\x36\x2E\x3E"],
		["ror", AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX, 						"\x6A\x66\x76\x6E\x7E"],
		["rti", AM_IMP, 													"\x40"],
		["rts", AM_IMP, 													"\x60"],
		["sbc", AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,	"\xE9\xE5\xF5\xED\xFD\xF9\xE1\xF1"],
		["sec", AM_IMP, 													"\x38"],
		["sed", AM_IMP, 													"\xF8"],
		["sei", AM_IMP, 													"\x78"],
		["sta", AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,		"\x85\x95\x8D\x9D\x99\x81\x91"],
		["stx", AM_ZP|AM_ZPY|AM_ABS, 										"\x86\x96\x8E"],
		["sty", AM_ZP|AM_ZPX|AM_ABS, 										"\x84\x94\x8C"],
		["tax", AM_IMP, 													"\xAA"],
		["tay", AM_IMP, 													"\xA8"],
		["tsx", AM_IMP, 													"\xBA"],
		["txa", AM_IMP, 													"\x8A"],
		["txs", AM_IMP, 													"\x9A"],
		["tya", AM_IMP, 													"\x98"]
	]

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	^^S_MNEMONIC s_mnemonic

	;----------------------------------------------
	;  is_parse_enabled()
	;----------------------------------------------
	inline sub is_parse_enabled() -> bool
	{
		return (false == command.is_macro_feeding)
	}

	;----------------------------------------------
	;  parse()
	;----------------------------------------------
	sub parse()
	{
		if (asm.is_delimeter(fileio.line_buffer[asm.parse_line.ptr + 3])) {
			asm.str_get_mnemonic()

			for s_mnemonic in MNEMONICS {
				if (0 == util.str_cmp(s_mnemonic.name)) {
					evaluate.addressing_mode()

					uword am = evaluate.result & s_mnemonic.modes
					if (mnemonic.AM_INVALID == am) {
						msg.error(msg.MSG::SYNTAX_ERROR)
					}

					if ((am & AM_IMP) == 0) {
						evaluate.expression()
					}
					alias result = evaluate.result
					alias status = evaluate.status

					uword ami = %0000_0000_0001_0000
					ubyte i = 0
					repeat 12 {
						if ((ami & am) != 0) {
							ubyte mncode = peek(s_mnemonic.codes +  i)

							when (ami) {
								AM_IMP -> {
									asm.store_at_pc(mncode)
									return
								}
								AM_IMM, AM_INDX, AM_INDY -> {
									if (msb(result) > 0) {
										msg.error(msg.MSG::NUMBER_TOO_BIG)
									}
									asm.store_at_pc(mncode)
									asm.store_at_pc(lsb(result))
									return
								}
								AM_ZP, AM_ZPX, AM_ZPY -> {
									if (status == evaluate.STATUS::OK) {
										if (msb(result) == 0) {
											asm.store_at_pc(mncode)
											asm.store_at_pc(lsb(result))
											return
										}
									}
								}
								AM_REL -> {
									asm.store_at_pc(mncode)
									asm.store_at_pc(lsb(result - asm.pc - 1))
									return
								}
								AM_ABS, AM_ABSX, AM_ABSY, AM_INDW -> {
									asm.store_at_pc(mncode)
									asm.store_at_pc(lsb(result))
									asm.store_at_pc(msb(result))
									return
								}
							}
						}
						if ((ami & s_mnemonic.modes) != 0) {
							i++
						}
						ami <<= 1
					}

					msg.error(msg.MSG::SYNTAX_ERROR)
				}
			}
		}

		msg.error(msg.MSG::UNKNOWN_MNEMONIC)
	}
}
