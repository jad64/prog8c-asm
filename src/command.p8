;----------------------------------------------
; command.p8
;----------------------------------------------

;----------------------------------------------
;  command
;----------------------------------------------
command {

	;----------------------------------------------
	;  const
	;----------------------------------------------
	const ubyte C_TEXT	  = 1
	const ubyte C_BYTE	  = 2
	const ubyte C_WORD	  = 3
	const ubyte C_RTA	  = 4
	const ubyte C_NULL	  = 5
	const ubyte C_EOR	  = 6
	const ubyte C_SHIFT	  = 7

	const ubyte C_MACRO	  = 8
	const ubyte C_SEGMENT = 9
	const ubyte C_ENDM    = 10

	str[] COMMANDS = [
		"offs",
		"text", "byte", "word", "rta", "null", "eor", "shift",
		"macro", "segment", "endm",
		"if", "ifne", "ifpl", "ifmi", "ifeq", "endif",
		"block", "bend",
		"pron", "proff",
		"include",
		"lbl", "var", "goto",
		"showmac", "hidemac",
		"page",
		"end"
	]

	uword[] PROCEDURES = [
		c_nop,
		c_tenush, c_bywort, c_bywort, c_bywort, c_tenush, c_nop, c_tenush,
		c_macro, c_macro, c_endm,
		c_nop, c_nop, c_nop, c_nop, c_nop, c_nop,
		c_block, c_bend,
		c_nop, c_nop,
		c_include,
		c_nop, c_nop, c_nop,
		c_nop, c_nop,
		c_nop,
		c_end
	]

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	ubyte num

	ubyte block_num
	bool  in_block
	bool  is_macro_feeding

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		block_num = 0
		is_macro_feeding = false
	}

	;----------------------------------------------
	;  reset()
	;----------------------------------------------
	inline sub reset()
	{
		num = lsb(-1)
	}

	;----------------------------------------------
	;  is_macro_feed_enabled()
	;----------------------------------------------
	inline sub is_macro_feed_enabled() -> bool
	{
		; don't feed macro with '.macro' itself
		return ((true == command.is_macro_feeding) and (command.num != C_MACRO) and (asm.pass == 1))
	}

;	;----------------------------------------------
;	;  is_parse_enabled()
;	;----------------------------------------------
;	inline sub is_parse_enabled() -> bool
;	{
;		return true
;	}

	;----------------------------------------------
	;  is_exec_enabled()
	;----------------------------------------------
	inline sub is_exec_enabled() -> bool
	{
		return (false == command.is_macro_feeding) or (command.is_macro_feeding and (command.num == command.C_ENDM))
	}

	;----------------------------------------------
	;  is_block_parsing()
	;----------------------------------------------
	inline sub is_block_parsing() -> bool
	{
		return command.in_block
	}

	;----------------------------------------------
	;  parse()
	;----------------------------------------------
	sub parse()
	{
		asm.str_get_command()

		for num in len(COMMANDS) - 1 downto 0 {
			if (util.str_cmp(COMMANDS[num])) {
				if (is_exec_enabled()) {
					goto PROCEDURES[num]
				}
				return
			}
		}

		msg.error(msg.MSG::UNKNOWN_COMMAND)
	}

	;----------------------------------------------
	;  c_include()
	;----------------------------------------------
	sub c_include()
	{
		evaluate.quoted_filename()
		asm.parse_file()
	}

	;----------------------------------------------
	;  c_end()
	;----------------------------------------------
	sub c_end()
	{
		stacks.poke_b(stacks.STACK::STATUSES, $40)
	}

	;----------------------------------------------
	;  c_block()
	;----------------------------------------------
	sub c_block()
	{
		block_num++
		in_block = true
	}

	;----------------------------------------------
	;  c_bend()
	;----------------------------------------------
	sub c_bend()
	{
		in_block = false
	}

	;----------------------------------------------
	;  c_macro()
	;----------------------------------------------
	sub c_macro()
	{
		if (asm.pass == 1) {
			if (false == label.parsed) {
				msg.error(msg.MSG::NO_LABEL)
			}

			;	change status
			label.set_status(if (command.num == C_SEGMENT) label.STATUS::SEGMENT else label.STATUS::MACRO, label.MASK::LBLMACSEG)
		}

		is_macro_feeding = true
	}

	;----------------------------------------------
	;  c_endm()
	;----------------------------------------------
	sub c_endm()
	{
	;	if (false == is_macro_feeding) {
	;		msg.error(msg.MSG::ENDM_WITHOUT_MACRO)
	;	}

		is_macro_feeding = false
	}

	;----------------------------------------------
	;  c_tenush()
	;
	;	.text .null .shift
	;----------------------------------------------
	sub c_tenush()
	{
		ubyte datalen = evaluate.quoted_texts()
		ubyte dataptr = 0
		while (dataptr < (datalen - 1)) {
			asm.store_at_pc(evaluate.datarow[dataptr])
			dataptr++
		}

		ubyte last = evaluate.datarow[dataptr]
		if (command.num == C_SHIFT) {
			last |= $80
		}
		asm.store_at_pc(last)

		if (command.num == C_NULL) {
			asm.store_at_pc(0)
		}
	}

	;----------------------------------------------
	;  c_bywort()
	;----------------------------------------------
	sub c_bywort()
	{
		ubyte datalen = evaluate.comma_separated_data()
		ubyte dataptr = 0
		while (dataptr < datalen) {
			uword data = peekw(&evaluate.datarow[dataptr])

			if (command.num == C_BYTE) {
				asm.store_at_pc(lsb(data))
			} else {
				if (command.num == C_RTA) {
					data--
				}
				asm.store_at_pc(lsb(data))
				asm.store_at_pc(msb(data))
			}
			dataptr += 2
		}
	}

	;----------------------------------------------
	;  no-operation/not-implemented
	;----------------------------------------------
	sub c_nop()
	{
	;	msg.warn(msg.MSG::NOT_IMPLEMENTED)
		util.puts("\n")
		util.puts(fileio.line_buffer)
	}
}
