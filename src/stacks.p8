;----------------------------------------------
; stacks.p8
;----------------------------------------------

;----------------------------------------------
;  stacks
;----------------------------------------------
stacks {

	;----------------------------------------------
	;  const
	;----------------------------------------------
	const ubyte MAX_STACK	= 5
	const ubyte MAX_SP		= 20

	enum STACK {
		STATUSES = 0,
		MACROS,
		OPERATORS,
		VALUES,

		PARAMETERS,
	}

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	ubyte[MAX_STACK] sp
	ubyte[4][20] stack									;	ubyte[MAX_STACK][MAX_SP] stack
	ubyte[128] parameters

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		ubyte i
		for i in MAX_STACK - 1 downto 0 {
			sp[i] = 0
		}
	}

	;----------------------------------------------
	;  reset()
	;----------------------------------------------
	sub reset(ubyte stack_num)
	{
		sp[stack_num] = 0
	}

	;----------------------------------------------
	;  is_empty()
	;----------------------------------------------
	sub is_empty(ubyte stack_num) -> bool
	{
		return (sp[stack_num] == 0)
	}

	;----------------------------------------------
	;  push_p()
	;----------------------------------------------
	sub push_p()
	{
		util.memcpy(macro.parameters, &stacks.parameters[sp[STACK::PARAMETERS]], macro.PARAMETERS_LENGTH)
		sp[STACK::PARAMETERS] += macro.PARAMETERS_LENGTH
	}

	;----------------------------------------------
	;  pop_p()
	;----------------------------------------------
	sub pop_p()
	{
		sp[STACK::PARAMETERS] -= macro.PARAMETERS_LENGTH
		util.memcpy(&stacks.parameters[sp[STACK::PARAMETERS]], macro.parameters, macro.PARAMETERS_LENGTH)
	}

	;----------------------------------------------
	;  poke_b()
	;----------------------------------------------
	sub poke_b(ubyte stack_num, ubyte value)
	{
		stack[stack_num][sp[stack_num] - 1] = value
	}

;	;----------------------------------------------
;	;  peek_b()
;	;----------------------------------------------
;	sub peek_b(ubyte stack_num) -> ubyte
;	{
;		return stack[stack_num][sp[stack_num] - 1]
;	}

;	;----------------------------------------------
;	;  peek_w()
;	;----------------------------------------------
;	sub peek_w(ubyte stack_num) -> uword
;	{
;		cx16.r0H = stack[stack_num][sp[stack_num] - 1]
;		cx16.r0L = stack[stack_num][sp[stack_num] - 2]
;
;		return cx16.r0
;	}

	;----------------------------------------------
	;  push_w()
	;----------------------------------------------
	sub push_w(ubyte stack_num, uword value)
	{
		push_b(stack_num, lsb(value))
		push_b(stack_num, msb(value))
	}

	;----------------------------------------------
	;  pop_w()
	;----------------------------------------------
	sub pop_w(ubyte stack_num) -> uword
	{
		cx16.r0H = pop_b(stack_num)
		cx16.r0L = pop_b(stack_num)

		return cx16.r0
	}

	;----------------------------------------------
	;  push_b()
	;----------------------------------------------
	sub push_b(ubyte stack_num, ubyte value)
	{
		stack[stack_num][sp[stack_num]] = value

		sp[stack_num]++
		if (sp[stack_num] >= MAX_SP) {
			msg.error(msg.MSG::STACK_OVERFLOW)
		}
	}

	;----------------------------------------------
	;  pop_b()
	;----------------------------------------------
	sub pop_b(ubyte stack_num) -> ubyte
	{
		if (sp[stack_num] == 0) {
			msg.error(msg.MSG::STACK_OVERFLOW)
		}

		sp[stack_num]--

		return stack[stack_num][sp[stack_num]]
	}
}
