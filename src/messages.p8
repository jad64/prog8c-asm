;----------------------------------------------
; messages.p8
;----------------------------------------------

%import asc
%import ram

;----------------------------------------------
;  msg
;----------------------------------------------
msg {
	%asminclude "../inc/asc.i"
	%asminclude "../inc/ram.i"
	%asminclude "../inc/kernel.i"
	%asminclude "../inc/macros.i"

	;----------------------------------------------
	;  enum
	;----------------------------------------------
	enum MSG {
		IO = 0,
		SYNTAX_ERROR,
		LBL_TOO_LONG,
		TOO_MANY_LABELS,
		UNKNOWN_COMMAND,
		NO_LABEL,
		UNKNOWN_MNEMONIC,
		UNKNOWN_MACRO,
		DOUBLE_DEFINED,
		STACK_OVERFLOW,
		EVAL_EXPRESSION,
		NUMBER_TOO_BIG,

		NOT_IMPLEMENTED,
	}

	;----------------------------------------------
	;  messages
	;----------------------------------------------
	str[] messages = [
		"I/O",
		"Syntax",
		"Label too long",
		"Too many labels",
		"Unknown command",
		"No label",
		"Unknown mnemonic",
		"Unknown macro",
		"Double defined",
		"Stack overflow",
		"Eval expression",
		"Number too big",

		"Not implemented",
	]

;	;----------------------------------------------
;	;  warn()
;	;----------------------------------------------
;	sub warn(ubyte num)
;	{
;		util.str_copy("\n?")
;		util.str_append_str(messages[num])
;		util.str_append_str(" in line:\n\x12")
;		util.str_append_str(fileio.line_buffer)
;		util.str_append_str("\n")
;		util.str_puts()
;	}

	;----------------------------------------------
	;  error()
	;----------------------------------------------
	sub error(ubyte num)
	{
		util.str_copy("\n?")
		util.str_append_str(messages[num])
		util.str_append_str(" error")
		if (MSG::IO != num) {
			util.str_append_str(" in line:\n\x12")
			util.str_append_str(fileio.line_buffer)
			util.str_append_str("\n")
		}
		util.str_puts()

		fileio.close_all()
		c64.R6510 = $37
		goto $A474
	}
}
