/* -*- mode: asm -*- */
/*--------------------------------------/)--------_-------------------*/
.att_syntax noprefix			/*                            */
.include "glibc.s"	                /*                            */
.global main    			/*                            */
/*******1^^^^^^^2*******3*******4-------/#******6**\****7*******8******/
.data					/*                            */
optstring:				/*`                           */
	.string "dh"			/*			      */
fmt:					/*                            */
	.string	"Usage: %s [option].. \'msg\'\n" /*                   */
help:					/*                            */
	.ascii	"  -d, decode\n"	/*			      */
	.asciz 	"  -h, help (not very useful)\n" /*		      */
prognom:				/*			      */
	.long	0			/* ptr returned by basename   */
deflag:					/* decode flag                */
	.long	0			/*                            */
msg:					/* msg addr                   */
	.long	0			/*			      */
/*``````1_______2-------3=======4~~~~~~~5.......6,,,,,,,7%%%%%%%8*******
0:	|0|0|0|0|0|0|    	1:	|0|0|0|0|0|1|    
3:	|0|0|0|0|1|1|    	2:	|0|0|0|0|1|0|    
5:	|0|0|0|1|0|1|    	4:	|0|0|0|1|0|0|    	
6:	|0|0|0|1|1|0|    	7:	|0|0|0|1|1|1|    
9:	|0|0|1|0|0|1|    	8:	|0|0|1|0|0|0|    
10:	|0|0|1|0|1|0|    	11:	|0|0|1|0|1|1|    
12:	|0|0|1|1|0|0|    	13:	|0|0|1|1|0|1|    
15:	|0|0|1|1|1|1|    	14:	|0|0|1|1|1|0|     
17:	|0|1|0|0|0|1|    	16:	|0|1|0|0|0|0|    
18:	|0|1|0|0|1|0|     	19:	|0|1|0|0|1|1|    
20:	|0|1|0|1|0|0|     	21:	|0|1|0|1|0|1|    
23:	|0|1|0|1|1|1|     	22:	|0|1|0|1|1|0|    
24:	|0|1|1|0|0|0|     	25:	|0|1|1|0|0|1|    
27:	|0|1|1|0|1|1|    	26:	|0|1|1|0|1|0|    
29:	|0|1|1|1|0|1|    	28:	|0|1|1|1|0|0|    
30:	|0|1|1|1|1|0|    	31:	|0|1|1|1|1|1|    
33:	|1|0|0|0|0|1|    	32:	|1|0|0|0|0|0|    
34:	|1|0|0|0|1|0|    	35:	|1|0|0|0|1|1|    
36:	|1|0|0|1|0|0|    	37:	|1|0|0|1|0|1|    
39:	|1|0|0|1|1|1|    	38:	|1|0|0|1|1|0|    
40:	|1|0|1|0|0|0|     	41:	|1|0|1|0|0|1|    
43:	|1|0|1|0|1|1|     	42:	|1|0|1|0|1|0|     
45:	|1|0|1|1|0|1|    	44:	|1|0|1|1|0|0|    
46:	|1|0|1|1|1|0|    	47:	|1|0|1|1|1|1|    
48:	|1|1|0|0|0|0|    	49:	|1|1|0|0|0|1|    
51:	|1|1|0|0|1|1|    	50:	|1|1|0|0|1|0|    
53:	|1|1|0|1|0|1|    	52:	|1|1|0|1|0|0|    
54:	|1|1|0|1|1|0|    	55:	|1|1|0|1|1|1|    
57:	|1|1|1|0|0|1|    	56:	|1|1|1|0|0|0|    
58:	|1|1|1|0|1|0|    	59:	|1|1|1|0|1|1|    	
60:	|1|1|1|1|0|0|    	61:	|1|1|1|1|0|1|    
63:	|1|1|1|1|1|1|    	62:	|1|1|1|1|1|0|    

|0|0| - void
|0|1| - lchr[0] character encoding
|1|0| - lchr[1] character encoding
|1|1| - Intel Reserved

ASCII
0	32: space	64: @
1     >	33: !         >	65: A
2	34: "	      >	66: B
3	35: #	      >	67: C
4	36: $	      >	68: D
5	37: %	      >	69: E
6	38: &	      >	70: F
7	39: '	      >	71: G
0    	40: (	      >	72: H
1	41: )	      >	73: I
2	42: *	      >	74: J
3     >	43: +	      >	75: K
4     >	44: ,	      >	76: L
5     >	45: -	      >	77: M
6     >	46: .	      >	78: N
7     >	47: /	      >	79: O
0	48: 0	      >	80: P
1	49: 1	      >	81: Q
2	50: 2	      >	82: R
3	51: 3	      >	83: S
4	52: 4	      >	84: T
5	53: 5	      >	85: U
6	54: 6	      >	86: V
7	55: 7	      >	87: W
0	56: 8	      >	88: X
1	57: 9	      >	89: Y
2     >	58: :	      >	90: Z
3	59: ;		91: [	
4	60: <		92: \
5	61: =		93: ]
6	62: >		94: ^
7     >	63: ?		95: _
 *------------------------------{-------|-----------------------+-----*/
#define TABSIZ 64 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ table size */
/*++++++++++++++++++++++++++++++++++++++|++++/++++++++++++\+++++++++++*
 *======================================|* *|=========`===============*/
/*******1*******2*******3*******4*******5* *****6*******7*******8******/
	.lcomm	eventab, TABSIZ /* even parity encoding table */
	.lcomm   oddtab, TABSIZ /*  odd parity encoding table */
tab:
	.long	eventab, oddtab /* yeah! */
evencode:
	.byte 	 0,  3,  5,  6,  9, 10, 12, 15
	.byte 	17, 18, 20, 23, 24, 27, 29, 30
	.byte	33, 34, 36, 39, 40, 43, 45, 46
	.byte	48, 51, 53, 54, 57, 58, 60, 63	
oddcode:
	.byte	 1,  2,  4,  7,  8, 11, 13, 14
	.byte	16, 19, 21, 22, 25, 26, 28, 31
	.byte	32, 35, 37, 38, 41, 42, 44, 47
	.byte	49, 50, 52, 55, 56, 59, 61, 62
code:	
	.long	evencode, oddcode
rchr: /* right field characters */
	.string	"!+-/:?ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lchr: /* left field characterz */
	.string	".,"
TOPSECRETMSG01:
	.ascii "-..WAS,IST/DAS??"
	.ascii "-DAS/IST:PROTIVEN,GLASETZ!.."
	.asciz "+AINE,.BULGARISHE,POURVENETZ."
TOPSECRETMSG02:
	.asciz	"..!YEAH/,!"
TOPSECRETMSG03:
	.asciz	"0C1728352E0C301D3A"
zecode:
	.ascii	"!!++--//::??AABBCCDDEEFFGGHHIIJJ"
	.asciz 	"KKLLMMNNOOPPQQRRSSTTUUVVWWXXYYZZ"
hex:
	.string	"0123456789ABCDEF"
hextab:
	.byte	0,  1,  2,  3,  4,  5,  6,  7
	.byte	8,  9,  0,  0,  0,  0,  0,  0
	.byte	0, 10, 11, 12, 13, 14, 15,  0
////////////////////////////////////////////////////////////////////////
/*......0.......1.......2.......3....... .......5.......6.......7.....*/
/*^^^^^^_^^^^^^^_^^^^^^^__^^^^^^__^^|^^^4^^^^^^^_^^^^^^^_^^^^^^_^^^^^^*/
.text 					/*                            */
setuptabs: /* setup tables      `       '                             */
	mov	$2, %ecx        /* loop index for odd and even tabs   */
2:	lea	-1(%ecx), %edi  /* tab index                          */
	mov	code(,%edi,4), %ebx     /* ebx <- code iterator       */
	mov	tab(,%edi,4), %edi      /* tab base address           */
	mov	$rchr, %esi     /* right fld characters iterator      */
0:	mov	(%esi), %al     /* load rigth fld char to al          */
	cmp	$0, %al	        /* arvedon?                           */
	jz	1f              /* yeah!                              */
	sub	$' , %al        /* get tab index                      */
	mov	(%ebx), %dl     /* pass encoding to dl                */
	mov	%dl, (%edi, %eax)       /* store encoding             */
	inc	%ebx            /* next code                          */
	inc	%esi            /* next char                          */
	jmp 	0b              /* continuer à répéter                */
1:	loop	2b		/* follow me                          */
	ret			/* bye setuptabs                      */
/*------/^^^^^^^\_______,,,,,,,,^^^^^^^^))))))))********j_______8-----*
 * infut: al - lchr encoding                                          *
 *	  dl - next character                                         *
 * oufut: al - combined al and dl characters code                     *
 * description: Ve call that function ven encoding a msg and we've    *
 * encountered a lchr. Zen we put it's code in al, and next character *
 * in dl. Ve might have three different cases:                        *
 * 1.) dl is a zero byte. Now because left fld characters has one     *
 * byte ve use the Intel Reserved code, and repeat al in the right    *
 * field as follows:                                                  *
 * |1|1|0|1|0|0|a,l|, vere a,l is the actual al code.                 *
 * 2.) dl is a left fld character, zen again ve use the               *
 * Intel Reserved code: |1|1|0|0|d,l|a,l|, d,l here is corresponding  *
 * left field encoding. (1 or 2)                                      *
 * 3,] dl iz a rchr. Zen in the left fld ve put al and in right fld   *
 * the dl odd encoding.                                               */
setupbyte: /*_ _ _ _ _ _ _ _ _ _ ` _ _ _ , _ _ _ _ _ _ _ _ _ _ _ _ _ _*/
	cmp	$0, %dl /* * * * * * * * * * * * * * * * * zero byte? */
	jnz	1f              /* nop                                */
	or	$0xd0, %al      /* add 1101 to the Queen side of al   */
	jmp	0f              /* ve are don!                        */
1:	cmp	lchr, %dl       /* ck if first lchr                   */
	jnz	2f              /* nop                                */
	or	$0xc4, %al      /* yeah!                              */
	jmp	0f              /* click next                         */
2:	cmp	lchr+1, %dl     /* ck if second lchr                  */
	jnz	3f              /* nop                                */
	or	$0xc8, %al      /* boom                               */
	jmp	0f              /* click next                         */
3:	shl	$6, %al         /* shift al code to the left field    */
	sub	$' , %dl        /* get table index                    */
	mov	oddtab(%edx), %dl       /* get character odd encoding */
	or	%dl, %al        /* add it to the right fld of al      */
0:	ret     		/* bye setupbyte                      */
/*-------________````````========________^^^^^^^^........,,,,,,,,******
 * infut: r32 - 32-bit register holding source memory address         *
 * oufut: r8  - 8-bit destination register                            *
 * loads a byte at r32 to r8                                          *
 ********~~~~~~~~^^^^^^^^________<<<<<<<<--------````````________******/
.macro	load	r32, r8 /*       '                                    */
	inc	\r32            /* click next                         */
	mov	(\r32), \r8     /* load byte                          */
.endm
/********@@@@@@@@((((((((````````LLLLLLLL????????////////>>>>>>>>******
 * infut: r8  - 8-bit source register                                 *
 * oufut: r32 - 32-bit register holding destination memory address    *
 * stores a byte from r8 to r32                                       *
 ********________<<<<<<<<````````))))))))########!!!!!!!!00000000******/
.macro	store	r8, r32 /*       `                                    */
	inc	\r32            /* clcknext                           */
	mov	\r8, (\r32)     /* store byte                         */
.endm
/*	0	1	2	3	4	5	6	7     */
/*******________////////--------~~~~~~~~11111111<<<<<<<<........*******
 * infut: esi - ascii msg addr                                        *
 * oufut: edi - encoded string addr                                   *
 *******~~~~~~~~^^^^^^^^________>>>>>>>>````````aaaaaaaa***************/
encode:	strlen	esi             /* oufut to eax                       */
	inc	%eax            /* add space for end of msg byte      */
	calloc	eax, $1         /* allocate some space                */
	push	%eax            /* save ptr to stack                  */
	lea	-1(%esi), %esi  /* ready steady .. **                 */
	lea	-1(%eax), %edi  /** .. go **                    oo    */
	xor	%eax, %eax      /* clean                              */
	mov	$1, %dl         /* init dl with a non zero value      */
1:	load	esi, al 	/* load character ascii code to al    */
	cmp	$0, %al 	/* ar ve don?                         */
	jz	0f 		/* aye aye                            */
	cmp	lchr, %al 	/* left field first character?        */
	jnz	2f 		/* eNOuPe                             */
	mov	$1, %al 	/* set character encoding             */
	jmp	3f 		/* yeah!                              */
2:	cmp	lchr+1, %al 	/* left field second character?       */
	jnz	4f 		/* eNOuPe                             */
	mov	$2, %al 	/* set character encoding             */
3:	load	esi, dl 	/* boom (get next character)          */
	call	setupbyte 	/* wow! what is this?                 */
	jmp	5f 		/* store encoding                     */
4:	sub	$' , %al 	/* get table index                    */
	mov	eventab(%eax), %al 	/* get encoding               */
5:	store	al, edi 	/* i-j-ye-s-z-t!! (come on!)          */
	cmp	$0, %dl 	/* ar ve don?                         */
	jnz	1b 		/* mais non, continuer à répéter      */
0:	mov	$0xff, %al 	/* end of message byte                */
	store	al, edi 	/* one last time                      */
	pop	%edi 		/* yeah!                              */
	ret			/* bye encode                         */
/********________````````00000000--------$$$$$$$$\\\\\\\\^^^^^^^^******
 * get encoded message length                                         *
 * infut: edi - encoded msg addr                                      *
 * oufut: ecx - msg length                                            *
 * Count bytes until end of msg byte is encountered (0xff)            *
 *	7	6	5	4	3	2	1	0     */
msglen:	nop	 /* Okay	`	,			      */
	xor	%ecx, %ecx      /* initialize counter                 */
1:	cmpb	$0xff, (%edi, %ecx)     /* ar ve don?                 */
	jz	0f 		/* yep!				      */
	inc	%ecx		/* click next 			      */
	jmp	1b 		/* loof 			      */
0:	ret			/* bye msglen			      */
/********########))))))))________^^^^^^^^@@@@@@@@________&&&&&&&&******
 * get field value from al byte                                       *	
 * infut: offset, width - byte mask (field)                           *
 *        al - ze byte                                                *
 * oufut: dl                                                          *
 * The macro will extract the value from al field specified by        *
 * offset and width                                                   *
 *	0	1	2	3	4	5	6	7     */
.macro getfld	offset, width   /* get field			      */
	mov	$1, %edx 	/* next 4 lines will setup the mask   */
	shl	\width, %edx 	/* 2^\width 			      */
	dec	%edx 		/* now we have \width one bits        */
	shl	\offset, %edx 	/* now mask is set		      */
	and	%eax, %edx 	/* extract field bits to edx 	      */
	shr	\offset, %edx 	/* get field value 		      */
.endm
/********++++++++========@@@@@@@^@@@@@@@@================++++++++******
 * infut: edi - encoded msg addr                                      *
 * oufut: esi - decoded msg addr                                      *
 *	0	1	2	3	4	5	6	7     */
decode: nop	/* yeah!	`	'			      */
	call	msglen 		/* get message length (ecx) 	      */
	shl	$1, %ecx 	/* multiply by 2 		      */
	inc	%ecx		/* add space for a zero byte 	      */
	calloc	ecx, $1 	/* allocate space for oufut msg       */
	push	%eax 		/* bckup oufut addr to stack 	      */
	lea	-1(%edi), %edi 	/* initialize iterators  	      */
	lea	-1(%eax), %esi
	xor	%eax, %eax 	/* clear 			      */
1:	load	edi, al 	/* load byte to al 		      */
	cmp	$0xff, %al 	/* are we done? 		      */
	jz	0f 		/* yep! 			      */
	getfld	$6, $2 		/* get left field (edx) 	      */
	cmp	$0, %dl 	/* ck if rchr only 		      */
	jnz	2f 		/* nop 				      */
	mov	zecode(%eax), %edx 	/* decode 		      */
	jmp	6f 		/* store 			      */
2:	cmp	$1, %dl 	/* ck if first lchr 		      */
	jz	3f 		/* ha-ha! 			      */
	cmp	$2, %dl 	/* ck if second lchr 		      */
	jnz	4f 		/* nop 				      */
3:	mov	lchr-1(%edx), %edx 	/* decode 		      */
	store	dl, esi 	/* what? (y-y-yeah!) 		      */
	getfld	$0, $6 		/* get right field encoding 	      */
	mov	zecode(%edx), %edx 	/* yeah! 		      */
	jmp	6f 		/* follow me 			      */
4:	getfld	$4, $2 		/* get rfld 2 leftmost bits 	      */
	cmp	$0, %dl 	/* ck if two consecutive lchrs 	      */
	jnz	5f 		/* nop   			      */
	getfld	$0, $2 		/* get ze first one 		      */
	mov	lchr-1(%edx), %edx 	/* decode 		      */
	store	dl, esi 	/* jest! 			      */
	getfld	$2, $2 		/* get ze second one 		      */
	mov	lchr-1(%edx), %edx 	/* decode 		      */
	jmp	6f 		/* follow me! 			      */
5:	getfld	$0, $2 		/* get ze encoding 		      */
	mov	lchr-1(%edx), %edx 	/* decode 		      */
6:	store	dl, esi 	/* i-j-y-e-s-z-t-! 		      */
	jmp	1b 		/* loof 			      */
0:	pop	%esi 		/* re-establish 		      */
	ret 			/* bye decode:) 		      */
/*
 * infut: edi - encoded msg addr                                      *
 * oufut: esi - hex str addr                                          *
 *	0	1	2	3	4	5	6	7     */
code2hexstr: /* code to hex string 				      */
	call	msglen 		/* get message length (ecx)           */
	shl	$1, %ecx 	/* multiply by 2                      */
	inc	%ecx 		/* add space for a zero byte          */
	calloc	ecx, $1 	/* allocate space for hex str         */
	push	%eax 		/* bckup oufut addr to stack          */
	lea	-1(%edi), %edi 	/* initialize iterators               */
	lea	-1(%eax), %esi
	xor	%eax, %eax 	/* clear                              */
1:	load	edi, al 	/* load byte to al                    */
	cmp	$0xff, %al 	/* are we done?                       */
	jz	0f 		/* yep!                               */
	getfld	$4, $4 		/* get first hex number 	      */
	mov	hex(%edx), %dl 	/* get the ascii representation       */
	store	dl, esi		/* store first hex number 	      */
	getfld	$0, $4 		/* get second hex number 	      */
	mov	hex(%edx), %dl 	/* get the ascii representation       */
	store	dl, esi		/* store second hex number	      */
	jmp	1b 		/* loof 			      */
0:	pop	%esi 		/* re-establish 		      */
	ret 			/* bye code2hexstr:) 		      */
/*_______........,,,,,,,,````````--------********^^^^^^^^<<<<<<<<******
 * hex string to code                                                 *
 * infut: esi - hex str ptr                                           *
 * oufut: edi - code str addr                                         *
 * Converts hex string to numeric values and adds end of message byte *
 *	1	2	3	4	5	6	7	8     */
hexstr2code: /* hex to string code				      */
	strlen	esi 		/* get string length to eax */
	shr	$1, %eax	/* divide by 2 (e.g. AF is one byte)  */
	inc	%eax 		/* end of message byte                */
	calloc	eax, $1 	/* allocate some space		      */
	push	%eax 		/* backup			      */
	lea	-1(%esi), %esi 	/* initialize iterators		      */
	lea	-1(%eax), %edi
	xor	%eax, %eax 	/* clear			      */
1:	load	esi, al 	/* get ascii to al		      */
	cmp	$0, %al 	/* are we done?			      */
	jz	0f 		/* aye-aye			      */
	sub	$'0, %al 	/* get hextab index		      */
	mov	hextab(%eax), %dl 	/* get integer to dl	      */
	shl	$4, %dl 	/* shift on the queen side 	      */
	load	esi, al 	/* get ascii to al 		      */
	sub	$'0, %al	/* get hextab index 		      */
	mov	hextab(%eax), %al	/* get integer to al 	      */
	or	%al, %dl 	/* now %dl has the value 	      */
	store	dl, edi		/* yeah! (store) 		      */
	jmp	1b 		/* follow me 			      */
0:	mov	$0xff, %al  	/* add end of message byte 	      */
	store	al, edi 	/* yeah! 			      */
	pop	%edi 		/* re-establish 		      */
	ret			/* come on 			      */
////////////////////////////////////////////////////////////////////////
clean:	nop			/* */
	xor	%eax, %eax      /*      _                        */
	xor	%ecx, %ecx      /* gkegau                        */
	xor	%edx, %edx      /*                               */
	xor	%ebx, %ebx      /* - HsMa ga ro cnpa!            */
	sub	%esi, %esi      /*   				 */
	xor	%edi, %edi      /* 				 */
	ret		        /*                               */
//////////////////////////////////////////////////////rpqt//////////////
.macro usage status
	printf	$fmt, prognom
	printf	$help
	ccall	exit, \status
.endm /*            ****++++xxxx====----,,,,____ roqt                 */
// infut: ebx - argc
//	  edi - argv	
geropt:
	ccall	basename, (edi)	/* output at eax (char *)             */
	mov	%eax, prognom	/* save ptr at prognom	              */
1:	ccall	getopt, ebx, edi, $optstring /* eax <- option char    */
	cmp	$-1, %eax	/* < are we done >                    */
	jz	1f		/* yep                                */
d:	cmp	$'d, %eax	/* < decode flag >                    */
	jnz	h		/* N                                  */
	movl	$1, deflag      /* raise flag                         */
	jmp	1b		/* get next option                    */
h:	cmp	$'h, %eax	/* < help >                           */
	jnz	daft		/* N                                  */
	usage	$0		/* exit status 0                      */
daft:	usage	$1		/* exit status 1 		      */
1:	nop			/*				      */
	mov	optind, %ecx	/* msg argv index                     */
	cmp	%ecx, %ebx	/* ck if any msg is given             */
	jnz	2f		/* yep                                */
	usage	$1              /* nop			              */
2:	mov	(%edi, %ecx, 4), %eax /* thatz 			      */
	mov	%eax, msg       /* copy Ninja Kakashi		      */
	ret			/* 		 		      */
/* OK ON Y VA!..                                                      */
/*******1*******2*******3*******4* *****5*******6*******7*******8******/
main:	nop		        /* 		                      */
	mov	4(%esp), %ebx	/* argc                               */
	mov	8(%esp), %edi	/* argv                               */
	call	geropt		/* get options			      */
	call	clean		/* empty trash			      */
	enter 	$0, $0	        /* He e >ecHo ga cu 6ypkoa	      */
	nop		        /* cnpeTe cu 3ByKa Ha Te<eBu3opa!     */
	// Initialize tables
	call	setuptabs	/* setup tables */
	// ¿!! Test Zone !!!
	nop
	mov	msg, %esi
	cmp	$1, deflag
	jz	1f
	call	encode
	call	code2hexstr
	jmp	2f
1:	call	hexstr2code
	call	decode
2:	puts	esi
bye:	nop			/*                    o               */
	leave		        /*	            < x >             */
	xor	%eax, %eax	/* exit status	      v		      */
	ret		        /*       	                      */
/*------f-------0-------a-------!/ -----/s------L------->-------b-----*/
/*								   bugs:
/*	L	h	>	*	G	a	=	/     */
/*******1*******2*******3*******4*******5*******6*******7*******8******/
/* 7e ce BuguM Ha peBaHma                                           log:
 *	v	v	v	V	v	v	V	_     */
