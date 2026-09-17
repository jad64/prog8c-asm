;----------------------------------------------
; fileio.p8
;----------------------------------------------

%import syslib

%import asc
%import ram

;----------------------------------------------
;  fileio
;----------------------------------------------
fileio {

	;----------------------------------------------
	;  const
	;----------------------------------------------
	const ubyte BUFFER_LEN	=	80
	const ubyte FIRST_LA	=	1

	;----------------------------------------------
	;  variables
	;----------------------------------------------
	&ubyte[BUFFER_LEN] line_buffer = $200				;	c64.BUF

	ubyte la_num
	
	uword fnadr
	ubyte fnlen

	;----------------------------------------------
	;  init()
	;----------------------------------------------
	sub init()
	{
		la_num = FIRST_LA
	}

	;----------------------------------------------
	;  open()
	;----------------------------------------------
	sub open()
	{
		la_num++

		util.str_init()
		util.str_nappend_str(fnadr, fnlen)
		util.str_append_str(",s,r")

		cbm.SETNAM(util.str_length(), util.string)
		cbm.SETLFS(la_num, c64.FA, la_num)
		void cbm.OPEN()
		if_cs {
			msg.error(msg.MSG::IO)
		}
	}

	;----------------------------------------------
	;  read_line()
	;----------------------------------------------
	sub read_line()
	{
		void cbm.CHKIN(la_num)

		ubyte ptr
		for ptr in 0 to BUFFER_LEN - 1 {
			ubyte ch = cbm.CHRIN()
		;	cbm.CHROUT(ch)
			if (ch == asc.RETURN) {
				break
			}

			line_buffer[ptr] = ch

			when (c64.STATUS) {
				0    -> continue
				$40  -> break
				else -> msg.error(msg.MSG::IO)
			}
		}
		line_buffer[ptr] = 0
	}

	;----------------------------------------------
	;  close()
	;----------------------------------------------
	sub close()
	{
		cbm.CLOSE(la_num)

		la_num--

		cbm.CLRCHN()
	}

	;----------------------------------------------
	;  close_all()
	;----------------------------------------------
	sub close_all()
	{
		while (la_num > FIRST_LA) {
			cbm.CLOSE(la_num)
			la_num--
		}

		void cbm.CHKIN(0)
	}
}
