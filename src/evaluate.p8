;----------------------------------------------
; evaluate.p8
;----------------------------------------------

;----------------------------------------------
;  evaluate
;----------------------------------------------
evaluate {

	;----------------------------------------------
	;  struct
	;----------------------------------------------
	struct SUFX_AM {
		str   suffix
		uword adr_mode
	}

	;----------------------------------------------
	;  enum
	;----------------------------------------------
	enum STATUS {
		OK = 0,
		NOK
	}

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	&ubyte[45] operand	= $2A7
	
	&ubyte[44] datarow	= $2A7 + 45

	uword result
	ubyte status


	;----------------------------------------------
	;  is_equation_enabled()
	;----------------------------------------------
	inline sub is_equation_enabled() -> bool
	{
		return (false == command.is_macro_feeding)
	}

	;----------------------------------------------
	;  equation()
	;----------------------------------------------
	sub equation()
	{
		if (asm.pass == 1) {
			if (false == label.parsed) {
				msg.error(msg.MSG::NO_LABEL)
			}

			util.str_copy(&fileio.line_buffer[asm.parse_line.ptr + 1])
			util.str_ltrim()
			void util.str_store(operand)

			expression()
			if (status != STATUS::OK) {
				msg.error(msg.MSG::EVAL_EXPRESSION)
			}

			label.set_value(result)
		}
	}

	;----------------------------------------------
	;  quoted_filename()
	;----------------------------------------------
	sub quoted_filename()
	{
		fileio.fnadr = &fileio.line_buffer[asm.parse_line.ptr]
		fileio.fnlen = 0

		util.str_copy(fileio.fnadr)
		util.str_split(asc.QUOTE)

		if (util.split[0] >= 2) {
			fileio.fnadr += util.split[1] + 1
			fileio.fnlen  = util.split[2] - util.split[1] - 1
		}
	}

	;----------------------------------------------
	;  quoted_texts()
	;----------------------------------------------
	sub quoted_texts() -> ubyte
	{
		ubyte dataptr = 0
		ubyte quotes  = 0
		repeat {
			alias ptr = asm.parse_line.ptr
			ubyte ch  = fileio.line_buffer[ptr]

			if (ch == asc.QUOTE) {
				quotes++
			} else if ((quotes & 1) == 1) {
				datarow[dataptr] = ch
				dataptr++
			} else if (ch in [0, ';']) {
				break
			}

			ptr++
		}

		return dataptr
	}

	;----------------------------------------------
	;  comma_separated_data()
	;----------------------------------------------
	sub comma_separated_data() -> ubyte
	{
		alias ptr = asm.parse_line.ptr

		ubyte dataptr = 0
		do {
			ubyte ch, quotes = 0
			ubyte ptr0 = ptr
			repeat {
				ch = fileio.line_buffer[ptr]
				ptr++
				if (ch == asc.QUOTE) {
					quotes++
				} else if ((quotes & 1) == 0) {
					if (ch in [0, ';', ',']) {
						break
					}
				}
			}

			ubyte strlen = ptr - ptr0 - 1
			util.memcpy(&fileio.line_buffer[ptr0], operand, strlen)
			operand[strlen] = 0

			expression()
			pokew(&datarow[dataptr], result)
			dataptr += 2
		} until (ch in [0, ';'])

		return dataptr
	}

	;----------------------------------------------
	;  addressing_mode()
	;----------------------------------------------
	sub addressing_mode()
	{
		result = mnemonic.AM_INVALID

		util.str_copy(&fileio.line_buffer[asm.parse_line.ptr])
		util.str_ltrim()

		ubyte ch0 = util.string[0]
		ubyte ch1 = util.string[1]
		if (asm.is_delimeter(ch0)) {
			result = mnemonic.AM_IMP
		} else if ((ch0 == 'a') and asm.is_delimeter(ch1)) {
			result = mnemonic.AM_IMP
			util.str_scroll_left(1)
		} else if (ch0 == '#') {
			result = mnemonic.AM_IMM
			util.str_scroll_left(1)
		} else {
			check_indexed_mode()

			if ((result & (mnemonic.AM_INDX|mnemonic.AM_INDY|mnemonic.AM_INDW)) !=0) {
				if (ch0 == '(') {
					util.str_scroll_left(1)
				} else {
					result = mnemonic.AM_INVALID
				}
			} else if ((result & (mnemonic.AM_ZPX|mnemonic.AM_ABSX|mnemonic.AM_ZPY|mnemonic.AM_ABSY)) == 0) {
				result = mnemonic.AM_ZP|mnemonic.AM_ABS|mnemonic.AM_REL
			}
		}

		void util.str_store(operand)
	}

	;----------------------------------------------
	;  check_indexed_mode()
	;----------------------------------------------
	sub check_indexed_mode()
	{
		^^SUFX_AM[] s_sfam = [
			[",x)", mnemonic.AM_INDX],
			["),y", mnemonic.AM_INDY],
			[")",   mnemonic.AM_INDW],
			[",x",  mnemonic.AM_ZPX|mnemonic.AM_ABSX],
			[",y",  mnemonic.AM_ZPY|mnemonic.AM_ABSY],
		]

		^^SUFX_AM sm
		for sm in s_sfam {
			ubyte pos = util.str_str(sm.suffix)
			if (pos != lsb(-1)) {
				result = sm.adr_mode
				util.string[pos] = 0
				break
			}
		}
	}

	;----------------------------------------------
	;  is_letter()
	;----------------------------------------------
	sub is_letter(ubyte ch) -> bool
	{
		return (((ch >= 'a') and (ch <= 'z')) or (ch == '\xA4'))
	}

	;----------------------------------------------
	;  is_digit()
	;----------------------------------------------
	sub is_digit(ubyte ch) -> bool
	{
		return ((ch >= '0') and (ch <= '9'))
	}

	;----------------------------------------------
	;  expression()
	;----------------------------------------------
	sub expression()
	{
		status = STATUS::OK

		stacks.reset(stacks.STACK::OPERATORS)
		stacks.reset(stacks.STACK::VALUES)

		ubyte i = 0
		repeat {
			ubyte ch = operand[i]

			if ((ch == ';') or (ch == 0)) {
				break
			} else if (is_letter(ch)) {
				push_value(get_label_value())
			} else if (is_digit(ch)) {
				push_value(get_decimal_value())
			} else if (ch == '$') {
				push_value(get_hex_value())
			} else if (ch == '%') {
				push_value(get_binary_value())
			} else if (ch == '"') {
				push_value(get_quoted_value())
			} else {
				if (ch == '*') {
					if (stacks.is_empty(stacks.STACK::VALUES)) {
						push_value(asm.pc)
					} else {
						push_operator(ch)
					}
				} else if (ch in ['+', '-', '/', '&', '.', ':', '<', '>']) {
					push_operator(ch)
				} else if (ch == ')') {
					push_value(apply_operation())
				}
				i++
			}
		}

		while (not stacks.is_empty(stacks.STACK::OPERATORS)) {
			push_value(apply_operation())
		}

		result = stacks.pop_w(stacks.STACK::VALUES)

		return

		;----------------------------------------------
		;  push_value()
		;----------------------------------------------
		sub push_value(uword value)
		{
			stacks.push_w(stacks.STACK::VALUES, value)
		}

		;----------------------------------------------
		;  push_value()
		;----------------------------------------------
		sub push_operator(ubyte op)
		{
			stacks.push_b(stacks.STACK::OPERATORS, op)
		}

		;----------------------------------------------
		;  apply_operation()
		;----------------------------------------------
		sub apply_operation() -> uword
		{
			ubyte op = stacks.pop_b(stacks.STACK::OPERATORS)
			cx16.r1  = stacks.pop_w(stacks.STACK::VALUES)
			if (op not in ['<', '>']) {
				cx16.r0 = stacks.pop_w(stacks.STACK::VALUES)
			}

			when (op) {
				'+' -> return cx16.r0 + cx16.r1
				'*' -> return cx16.r0 * cx16.r1
				'-' -> return cx16.r0 - cx16.r1
				'/' -> return cx16.r0 / cx16.r1
				'&' -> return cx16.r0 & cx16.r1
				'.' -> return cx16.r0 | cx16.r1
				':' -> return cx16.r0 ^ cx16.r1
				'<' -> return lsb(cx16.r1)
				'>' -> return msb(cx16.r1)
			}

			return 0
		}

		;----------------------------------------------
		;  get_label_value()
		;----------------------------------------------
		sub get_label_value() -> uword
		{
			util.str_init()

			repeat {
				ch = operand[i]
				if (is_letter(ch) or is_digit(ch)) {
					util.str_append_char(ch)
				} else {
					break
				}
				i++
			}

			label.str_find_label()
			if (label.find_result == 0) {
				if (asm.pass == 2) {
					msg.error(msg.MSG::EVAL_EXPRESSION)
				}
				status = STATUS::NOK
				return 0
			} else {
				return label.get_value(label.find_result)
			}
		}

		;----------------------------------------------
		;  get_decimal_value()
		;----------------------------------------------
		sub get_decimal_value() -> uword
		{
			cx16.r0 = 0
			repeat {
				ch = operand[i]
				if (is_digit(ch)) {
					cx16.r0 *= 10
					cx16.r0 += (ch - '0')
				} else {
					break
				}
				i++
			}

			return cx16.r0
		}

		;----------------------------------------------
		;  get_hex_value()
		;----------------------------------------------
		sub get_hex_value() -> uword
		{
			cx16.r0 = 0
			repeat {
				i++
				ch = operand[i]
				if (is_digit(ch)) {
					cx16.r2L = (ch - '0')
				} else if (is_hex_letter()) {
					cx16.r2L = (ch - 'a' + 10)
				} else {
					break
				}
				cx16.r0 *= 16
				cx16.r0 += cx16.r2L
			}

			return cx16.r0
		}

		;----------------------------------------------
		;  get_binary_value()
		;----------------------------------------------
		sub get_binary_value() -> uword
		{
			cx16.r0 = 0
			repeat {
				i++
				ch = operand[i]
				if (is_digit(ch)) {
					cx16.r0 <<= 1 
					cx16.r0 += (ch - '0')
				} else {
					break
				}
			}

			return	cx16.r0
		}

		;----------------------------------------------
		;  get_quoted_value()
		;----------------------------------------------
		sub get_quoted_value() -> uword
		{
			ch = operand[i + 1]
			i += 3
			return mkword(0, ch)
		}

		;----------------------------------------------
		;  is_hex_letter()
		;----------------------------------------------
		sub is_hex_letter() -> bool
		{
			return ((ch >= 'a') and (ch <= 'f'))
		}
	}
}
