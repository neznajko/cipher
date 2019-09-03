/* -*- mode: asm -*- */
.data
.text
.altmacro       
/* Some advanced assembly techniques from asm community forums:       */
/* http://www.asmcommunity.net/forums/topic/?id=29732#post-211358     */
.macro ccall func:req, arg1, args:vararg
        argc = 0
	local pusher
	.macro pusher parg1, pargs:vararg       /* reverse pusher     */
                .ifnb \parg1
                        pusher \pargs
                        push \parg1
                        argc = argc + 1
                .endif
        .endm
        pusher  \arg1, \args
        call    \func
        add     $(argc*4), %esp
.endm /*##############################################################*/
.macro calloc nmemb, size
	push	%ecx
	push	%edx
	ccall	calloc, \nmemb, \size
	pop	%edx
	pop	%ecx
.endm /*--------------------------------------------------------------*/
.macro printf args:vararg
	push	%eax
	push	%ecx
	push	%edx
	ccall	printf, \args
	pop	%edx
	pop	%ecx
	pop	%eax
.endm /*______________________________________________________________*/
.macro puts s
	push	%eax
	push	%ecx
	push	%edx
	ccall	puts, \s
	pop	%edx
	pop	%ecx
	pop	%eax
.endm /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
.macro strlen s
	push	%ecx
	push	%edx
	ccall	strlen, \s
	pop	%edx
	pop	%ecx	
.endm /*ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff*/
