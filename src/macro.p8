;----------------------------------------------
; macro.p8
;----------------------------------------------

;----------------------------------------------
;  macro
;----------------------------------------------
macro {

	;----------------------------------------------
	;  const
	;----------------------------------------------
	const ubyte PARAMETERS_LENGTH	= 32

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	uword macro_ptr
	uword macro_end

	ubyte[PARAMETERS_LENGTH] parameters

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		macro_ptr = 0
		macro_end = 0
	}

	;----------------------------------------------
	;  is_execution_enabled()
	;----------------------------------------------
	inline sub is_execution_enabled() -> bool
	{
		return (false == command.is_macro_feeding)
	}

	;----------------------------------------------
	;  is_current_still_executing()
	;----------------------------------------------
	sub is_current_still_executing() -> bool
	{
		return (macro.macro_ptr < macro.macro_end)
	}

	;----------------------------------------------
	;  is_current_execution_completed()
	;----------------------------------------------
	sub is_current_execution_completed() -> bool
	{
		return (false == is_current_still_executing())
	}

	;----------------------------------------------
	;  is_previous_execution_suspended()
	;----------------------------------------------
	inline sub is_previous_execution_suspended() -> bool
	{
		return (stacks.sp[stacks.STACK::MACROS] > 0)
	}

	;----------------------------------------------
	;  feed()
	;----------------------------------------------
	sub feed()
	{
		util.str_copy(&fileio.line_buffer)
		uword addr = label.get_next(label.current)
		ubyte length = util.str_store(addr)
		label.set_next(addr + length + 1)
	}

	;----------------------------------------------
	;  prepare_execution()
	;----------------------------------------------
	sub prepare_execution()
	{
		asm.str_get_command()

		alias vmacro = label.find_result
		label.str_find_label()
		if (0 == vmacro) {
			msg.error(msg.MSG::UNKNOWN_MACRO)
		}

		if (macro.is_current_still_executing()) {
			stacks.push_w(stacks.STACK::MACROS, macro_ptr)
			stacks.push_w(stacks.STACK::MACROS, macro_end)
			stacks.push_p()
		}

		; macro
		macro_ptr = vmacro + label.get_size(vmacro)
		macro_end = label.get_next(vmacro)

		; parameters
		util.str_copy(&fileio.line_buffer[asm.parse_line.ptr])
		util.str_ltrim()
		util.str_padr(PARAMETERS_LENGTH - 1, 0)
		util.str_split(',')
		parameters[0] = util.split[0]
		util.memcpy(util.string, &parameters[1], PARAMETERS_LENGTH - 1)
	}

	;----------------------------------------------
	;  execute()
	;----------------------------------------------
	sub execute()
	{
		parse_parameters()

		macro_ptr += (util.strlen(macro_ptr) + 1)

		if (macro.is_current_execution_completed()) {
			if (macro.is_previous_execution_suspended()) {
				stacks.pop_p()
				macro_end = stacks.pop_w(stacks.STACK::MACROS)
				macro_ptr = stacks.pop_w(stacks.STACK::MACROS)
			}
		}
	}

	;----------------------------------------------
	;  parse_parameters()
	;----------------------------------------------
	sub parse_parameters()
	{
		util.str_copy(macro_ptr)

	;	if (util.strlen(&parameters[1]) > 0) {
		if (parameters[1] != 0) {
			ubyte par
			for par in 0 to parameters[0] {
				uword value = get_parameter_value(par)
				uword name  = get_parameter_name(par)

				util.str_replace(name, value)
			}
		}

		void util.str_store(&fileio.line_buffer)
	}

	;----------------------------------------------
	;  get_parameter_value()
	;----------------------------------------------
	sub get_parameter_value(ubyte num) -> uword
	{
		ubyte offset
		for offset in 1 to PARAMETERS_LENGTH - 1 {
			if (num == 0) {
				break
			}

			if (parameters[offset] == 0) {
				num--
			}
		}

		return &parameters[offset]
	}

	;----------------------------------------------
	;  get_parameter_name()
	;----------------------------------------------
	sub get_parameter_name(ubyte num) -> uword
	{
		str name = "\x5c?"

		name[1] = '1' + num

		return name
	}
}
