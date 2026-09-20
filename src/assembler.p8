;----------------------------------------------
; assembler.p8
;----------------------------------------------

;----------------------------------------------
;  assembler
;----------------------------------------------
asm {

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	ubyte pass
	uword pc

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		pc = $1000
	}

	;----------------------------------------------
	;  parse_file()
	;----------------------------------------------
	sub parse_file()
	{
		util.str_copy("\nParsing #")
		util.str_append_dec(mkword(0, pass))
		util.str_append_str(" \'")
		util.str_nappend_str(fileio.fnadr, fileio.fnlen)
		util.str_append_char('\'')
		util.str_puts()

		fileio.open()
		do {
			if (macro.is_current_still_executing()) {
				macro.execute()
			} else {
				fileio.read_line()
			}
			stacks.push_b(stacks.STACK::STATUSES, c64.STATUS)

			parse_line()
			if (command.is_macro_feed_enabled()) {
				macro.feed()
			}

			c64.STATUS = stacks.pop_b(stacks.STACK::STATUSES)
		} until (0 != c64.STATUS)
		fileio.close()
	}

	;----------------------------------------------
	;  parse_line()
	;----------------------------------------------
	sub parse_line()
	{
		label.reset()
		command.reset()

		ubyte ptr
		for ptr in 0 to fileio.BUFFER_LEN - 1 {
			when (fileio.line_buffer[ptr]) {
				0   -> break
				';' -> break
				' ' -> continue
				'*' -> {
					if (is_modify_pc_enabled()) {
						goto asm.modify_pc
					}
				}
				'.' -> {
;					if (command.is_parse_enabled()) {
						goto command.parse
;					}
				}
				'#' -> {
					if (macro.is_execution_enabled()) {
						goto macro.prepare_execution
					}
				}
				'=' -> {
					if (evaluate.is_equation_enabled()) {
						goto evaluate.equation
					}
				}
				else -> {
					if (ptr == 0) {
						if (label.is_parse_enabled()) {
							label.parse()
							ptr--
						}
					} else {
						if (mnemonic.is_parse_enabled()) {
							goto mnemonic.parse
						}
					}
				}
			}
		}
	}

	;----------------------------------------------
	;  is_modify_pc_enabled()
	;----------------------------------------------
	inline sub is_modify_pc_enabled() -> bool
	{
		return (false == command.is_macro_feeding)
	}

	;----------------------------------------------
	;  modify_pc()
	;----------------------------------------------
	sub modify_pc()
	{
		util.str_copy(&fileio.line_buffer[asm.parse_line.ptr + 1])
		void util.str_store(evaluate.operand)

		evaluate.expression()
		if (evaluate.status != evaluate.STATUS::OK) {
			msg.error(msg.MSG::EVAL_EXPRESSION)
		}

		pc = evaluate.result
	}

	;----------------------------------------------
	;  store_at_pc()
	;----------------------------------------------
	sub store_at_pc(ubyte b)
	{
		if (pass == 2) {
			poke(pc, b)
		}
		pc++
	}

	;----------------------------------------------
	;  str_get_command()
	;----------------------------------------------
	sub str_get_command()
	{
		util.str_init()

		alias ptr = asm.parse_line.ptr
		repeat {
			ptr++										;	skip '.'

			ubyte ch = fileio.line_buffer[ptr]
			if (asm.is_delimeter(ch)) {
				break
			}

			util.str_append_char(ch)
		}
	}

	;----------------------------------------------
	;  is_delimeter()
	;----------------------------------------------
	sub is_delimeter(ubyte ch) -> bool
	{
		return ch in [0, ' ', ';']
	}

;	;----------------------------------------------
;	;  str_get_mnemonic()
;	;----------------------------------------------
;	sub str_get_mnemonic()
;	{
;		util.str_init()
;
;		alias ptr = asm.parse_line.ptr
;		repeat 3 {
;			ubyte ch = fileio.line_buffer[ptr]
;			util.str_append_char(ch)
;			ptr++
;		}
;	}
}
