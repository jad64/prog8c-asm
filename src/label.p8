;----------------------------------------------
; label.p8
;----------------------------------------------

;----------------------------------------------
;  label
;----------------------------------------------
label {

	;----------------------------------------------
	;  struct
	;----------------------------------------------
	struct S_LABEL {
		uword next
		uword prev
		ubyte block_num
		ubyte status
		uword value
		ubyte name_crc
		ubyte name_length
		str   name
;		str   macro
	}

	;----------------------------------------------
	;  const
	;----------------------------------------------
	const uword LABELS				= $A000
	const uword LABELS_END			= $CE00

	const ubyte MAX_NAME_LENGTH		= 16
	const uword NO_BLOCK			= 0

	const ubyte DEFAULT_STATUS		= STATUS::LABEL|STATUS::ASSIGN_EQU|STATUS::CALCULATED

	enum STATUS {
		LABEL        = %0000_0001,
		MACRO        = %0000_0010,
		SEGMENT      = %0000_0100,
		FORCE_AM_ABS = %0000_1000,
		ASSIGN_EQU   = %0001_0000,
		ASSIGN_VAR   = %0010_0000,
		ASSIGN_LBL   = %0100_0000,
		CALCULATED   = %1000_0000,
	}

	enum MASK {
		CALCULATED   = %0111_1111,
		ASSIGN_EQU   = %1000_1111,
		FORCE_AM_ABS = %1111_0111,
		LBLMACSEG    = %1111_1000,
	}

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	uword current
	uword last
	uword count

	uword find_result

	bool parsed

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		current = LABELS
		last = LABELS
		count   = 0
		set_next(LABELS)
		set_prev(LABELS)
	}

	;----------------------------------------------
	;  reset()
	;----------------------------------------------
	inline sub reset()
	{
		parsed  = false
	}

	;----------------------------------------------
	;  is_parse_enabled()
	;----------------------------------------------
	inline sub is_parse_enabled() -> bool
	{
		return (false == command.is_macro_feeding)
	}

	;----------------------------------------------
	;  is_delimeter()
	;----------------------------------------------
	inline sub is_delimeter(ubyte ch) -> bool
	{
		return ch in [0, ' ', ';', '=']
	}

	;----------------------------------------------
	;  parse()
	;----------------------------------------------
	sub parse()
	{
		str_get_name()

		if (asm.pass == 1) {
			str_find_label()
			if (0 != find_result) {
				msg.error(msg.MSG::DOUBLE_DEFINED)
			}

			cx16.r0 = current
			current = get_next(current)
			last = current

			set_name()
			set_block_num()
			set_value(asm.pc)
			set_status(DEFAULT_STATUS, $00)
			set_next(current + get_size(current))
			set_prev(cx16.r0)

			count++
		}

		parsed = true
	}

	;----------------------------------------------
	;  str_get_name()
	;----------------------------------------------
	sub str_get_name()
	{
		util.str_init()

		alias ptr = asm.parse_line.ptr
		for ptr in 0 to MAX_NAME_LENGTH - 1 {
			ubyte ch = fileio.line_buffer[ptr]
			if (label.is_delimeter(ch)) {
				return
			}

			util.str_append_char(ch)
		}

		msg.error(msg.MSG::LBL_TOO_LONG)
	}

	;----------------------------------------------
	;  set_block_num()
	;----------------------------------------------
	inline sub set_block_num()
	{
		pokew(current + offsetof(S_LABEL.block_num), if (command.is_block_parsing()) command.block_num else NO_BLOCK)
	}

	;----------------------------------------------
	;  set_value()
	;----------------------------------------------
	sub set_value(uword value)
	{
		pokew(current + offsetof(S_LABEL.value), value)
	}

	;----------------------------------------------
	;  get_value()
	;----------------------------------------------
	inline sub get_value(uword plabel) -> uword
	{
		return peekw(plabel + offsetof(S_LABEL.value))
	}

	;----------------------------------------------
	;  set_status()
	;----------------------------------------------
	sub set_status(ubyte st_bit, ubyte mask)
	{
		uword addr   = current + offsetof(S_LABEL.status)
		ubyte status = peek(addr)
		poke(addr, (status & mask) | st_bit)
	}

	;----------------------------------------------
	;  set_name()
	;----------------------------------------------
	sub set_name()
	{
		ubyte name_length = util.str_store(current + offsetof(S_LABEL.name))

		poke(current + offsetof(S_LABEL.name_length), name_length)
		poke(current + offsetof(S_LABEL.name_crc), str_get_crc(name_length))
	}

	;----------------------------------------------
	;  get_size()
	;----------------------------------------------
	sub get_size(uword plabel) -> ubyte
	{
		ubyte length = util.strlen(plabel + offsetof(S_LABEL.name))

		return length + sizeof(S_LABEL) - 1
	}

	;----------------------------------------------
	;  set_next()
	;----------------------------------------------
	sub set_next(uword addr)
	{
		if (addr >= LABELS_END) {
			msg.error(msg.MSG::TOO_MANY_LABELS)
		}

		pokew(current + offsetof(S_LABEL.next), addr)
	}

	;----------------------------------------------
	;  set_prev()
	;----------------------------------------------
	sub set_prev(uword addr)
	{
		pokew(current + offsetof(S_LABEL.prev), addr)
	}

	;----------------------------------------------
	;  get_next()
	;----------------------------------------------
	inline sub get_next(uword plabel) -> uword
	{
		return peekw(plabel + offsetof(S_LABEL.next))
	}

	;----------------------------------------------
	;  get_prev()
	;----------------------------------------------
	inline sub get_prev(uword plabel) -> uword
	{
		return peekw(plabel + offsetof(S_LABEL.prev))
	}

	;----------------------------------------------
	;  str_find_label()
	;----------------------------------------------
	sub str_find_label()
	{
		ubyte length = util.str_length()
		ubyte crc = str_get_crc(length)
		ubyte block0 = if command.is_block_parsing() command.block_num else 0

		find_block(block0)
		if (0 == find_result) {
			if (block0 > 0) {
				find_block(0)
			}
		}

		;----------------------------------------------
		;  find_block()
		;----------------------------------------------
		sub find_block(ubyte block)
		{
			find_result = last
			repeat count {
				if (block == peek(find_result + offsetof(S_LABEL.block_num))) {
					if (crc == peek(find_result + offsetof(S_LABEL.name_crc))) {
						if (length == peek(find_result + offsetof(S_LABEL.name_length))) {
							if (util.str_cmp(find_result + offsetof(S_LABEL.name))) {
								return
							}
						}
					}
				}
				find_result = get_prev(find_result)
			}

			find_result = 0
		}
	}
}
