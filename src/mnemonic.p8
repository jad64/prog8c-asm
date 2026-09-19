;----------------------------------------------
; mnemonic.p8
;----------------------------------------------

;----------------------------------------------
;  mnemonic
;----------------------------------------------
mnemonic {

	%asminclude "../inc/macros.i"

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

	uword[] MODES = [
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_REL,
		AM_REL,
		AM_REL,
		AM_ZP|AM_ABS,
		AM_REL,
		AM_REL,
		AM_REL,
		AM_IMP,
		AM_REL,
		AM_REL,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMM|AM_ZP|AM_ABS,
		AM_IMM|AM_ZP|AM_ABS,
		AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP,
		AM_IMP,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP,
		AM_IMP,
		AM_ABS|AM_INDW,
		AM_ABS,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMM|AM_ZP|AM_ZPY|AM_ABS|AM_ABSY,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX,
		AM_IMP,
		AM_IMP,
		AM_IMM|AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_ZP|AM_ZPX|AM_ABS|AM_ABSX|AM_ABSY|AM_INDX|AM_INDY,
		AM_ZP|AM_ZPY|AM_ABS,
		AM_ZP|AM_ZPX|AM_ABS,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP,
		AM_IMP,
	]

	ubyte[] C_ADC = [$69, $65, $75, $6D, $7D, $79, $61, $71]
	ubyte[] C_AND = [$29, $25, $35, $2D, $3D, $39, $21, $31]
	ubyte[] C_ASL = [$0A, $06, $16, $0E, $1E]
	ubyte[] C_BCC = [$90]
	ubyte[] C_BCS = [$B0]
	ubyte[] C_BEQ = [$F0]
	ubyte[] C_BIT = [$24, $2C]
	ubyte[] C_BMI = [$30]
	ubyte[] C_BNE = [$D0]
	ubyte[] C_BPL = [$10]
	ubyte[] C_BRK = [$00]
	ubyte[] C_BVC = [$50]
	ubyte[] C_BVS = [$70]
	ubyte[] C_CLC = [$18]
	ubyte[] C_CLD = [$D8]
	ubyte[] C_CLI = [$58]
	ubyte[] C_CLV = [$B8]
	ubyte[] C_CMP = [$C9, $C5, $D5, $CD, $DD, $D9, $C1, $D1]
	ubyte[] C_CPX = [$E0, $E4, $EC]
	ubyte[] C_CPY = [$C0, $C4, $CC]
	ubyte[] C_DEC = [$C6, $D6, $CE, $DE]
	ubyte[] C_DEX = [$CA]
	ubyte[] C_DEY = [$88]
	ubyte[] C_EOR = [$49, $45, $55, $4D, $5D, $59, $41, $51]
	ubyte[] C_INC = [$E6, $F6, $EE, $FE]
	ubyte[] C_INX = [$E8]
	ubyte[] C_INY = [$C8]
	ubyte[] C_JMP = [$4C, $6C]
	ubyte[] C_JSR = [$20]
	ubyte[] C_LDA = [$A9, $A5, $B5, $AD, $BD, $B9, $A1, $B1]
	ubyte[] C_LDX = [$A2, $A6, $B6, $AE, $BE]
	ubyte[] C_LDY = [$A0, $A4, $B4, $AC, $BC]
	ubyte[] C_LSR = [$4A, $46, $56, $4E, $5E]
	ubyte[] C_NOP = [$EA]
	ubyte[] C_ORA = [$09, $05, $15, $0D, $1D, $19, $01, $11]
	ubyte[] C_PHA = [$48]
	ubyte[] C_PHP = [$08]
	ubyte[] C_PLA = [$68]
	ubyte[] C_PLP = [$28]
	ubyte[] C_ROL = [$2A, $26, $36, $2E, $3E]
	ubyte[] C_ROR = [$6A, $66, $76, $6E, $7E]
	ubyte[] C_RTI = [$40]
	ubyte[] C_RTS = [$60]
	ubyte[] C_SBC = [$E9, $E5, $F5, $ED, $FD, $F9, $E1, $F1]
	ubyte[] C_SEC = [$38]
	ubyte[] C_SED = [$F8]
	ubyte[] C_SEI = [$78]
	ubyte[] C_STA = [$85, $95, $8D, $9D, $99, $81, $91]
	ubyte[] C_STX = [$86, $96, $8E]
	ubyte[] C_STY = [$84, $94, $8C]
	ubyte[] C_TAX = [$AA]
	ubyte[] C_TAY = [$A8]
	ubyte[] C_TSX = [$BA]
	ubyte[] C_TXA = [$8A]
	ubyte[] C_TXS = [$9A]
	ubyte[] C_TYA = [$98]

	uword[] CODES = [
		C_ADC, C_AND, C_ASL, C_BCC, C_BCS, C_BEQ, C_BIT, C_BMI,
		C_BNE, C_BPL, C_BRK, C_BVC, C_BVS, C_CLC, C_CLD, C_CLI,
		C_CLV, C_CMP, C_CPX, C_CPY, C_DEC, C_DEX, C_DEY, C_EOR,
		C_INC, C_INX, C_INY, C_JMP, C_JSR, C_LDA, C_LDX, C_LDY,
		C_LSR, C_NOP, C_ORA, C_PHA, C_PHP, C_PLA, C_PLP, C_ROL,
		C_ROR, C_RTI, C_RTS, C_SBC, C_SEC, C_SED, C_SEI, C_STA,
		C_STX, C_STY, C_TAX, C_TAY, C_TSX, C_TXA, C_TXS, C_TYA,
	]

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	ubyte num

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
		if (false == find()) {
			msg.error(msg.MSG::UNKNOWN_MNEMONIC)
		}
		uword modes = MODES[num]
		uword codes = CODES[num]

		evaluate.addressing_mode()

		uword am = evaluate.result & modes
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
				ubyte code = codes[i]

				if ((ami & AM_IMP) != 0) {
					asm.store_at_pc(code)
					return
				} else if ((ami & (AM_IMM|AM_INDX|AM_INDY)) != 0) {
					if (msb(result) > 0) {
						msg.error(msg.MSG::NUMBER_TOO_BIG)
					}
					asm.store_at_pc(code)
					asm.store_at_pc(lsb(result))
					return
				} else if ((ami & (AM_ZP|AM_ZPX|AM_ZPY)) != 0) {
					if (status == evaluate.STATUS::OK) {
						if (msb(result) == 0) {
							asm.store_at_pc(code)
							asm.store_at_pc(lsb(result))
							return
						}
					}
				} else if ((ami & AM_REL) != 0) {
					asm.store_at_pc(code)
					asm.store_at_pc(lsb(result - asm.pc - 1))
					return
				} else if ((ami & (AM_ABS|AM_ABSX|AM_ABSY|AM_INDW)) != 0) {
					asm.store_at_pc(code)
					asm.store_at_pc(lsb(result))
					asm.store_at_pc(msb(result))
					return
				}
			}
			if ((ami & modes) != 0) {
				i++
			}
			ami <<= 1
		}

		msg.error(msg.MSG::SYNTAX_ERROR)
	}
}
