	PAGE	40		; 40 lines per page
	TITLE	"goodbye.asm - Copyright (C) Kevin Cole 2020.10.18 (GPL)"
; goodbye.asm
; Written by Kevin Cole <ubuntourist@hacdc.org> 2020.10.18 (kjc)
;
; When the Altair just can't take it any more... ;-)
;
; REQUIRED READING: Altair 2SIO Serial I/O manual
; https://altairclone.com/downloads/manuals/Altair%202SIO%20Serial%20I-O.pdf
;
; OPTIONAL: RS-232 Data Control Signals and UART
; https://en.wikipedia.org/wiki/RS-232#Data_and_control_signals
; https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
;
; In order to understand communications between the Altair and an
; external device like a terminal, connected via the serial / USB
; cable, the above documents should be pondered. For details like:
;
;    UART = Universal Asynchronous Recever / Transmitter
;    XMIT = Transmit (OUT)
;    RECV = Receive  (IN)
;    RTS  = Request to Send
;
; Settings for synchronous (polled) communication:
;
; 15H = 0 0 0 1 0 1 0 1
;       ^ ^ ^ ^ ^ ^ ^ ^
;       | | | | | | | |
;       | | | | | | +-+-> 1 = Clock Divide = 16
;       | | | +-+-+-----> 5 = 8 Data bits, No parity, 1 Stop bit (8N1)
;       | +-+-----------> 0 = RTS = Low, XMIT interrupt = disabled
;       +---------------> 0 = RECV interrupt = disabled
;

; Constants

CR:	EQU	0DH	; ASCII CR  (Carriage Return, a.k.a. Ctrl-M)
LF:	EQU	0AH	; ASCII LF  (Line Feed a.k.a. Ctrl-J)
NUL:	EQU	00H	; ASCII NUL (Null)

SIO1S:	EQU	10H	; Serial I/O communications port 1 STATUS
SIO1D:	EQU	11H	; Serial I/O communications port 1 DATA

SENT:	EQU	002H	; Data sent. Output complete
MRST:	EQU	03H	; UART Master Reset

; Code segment

	ORG	000H	; Load at memory location 000 (hex)

	MVI	A,MRST
	OUT	SIO1S	; Reset the UART
	MVI	A,15H	; Settings: No RI, No XI, RTS Low, 8N1, /16
	OUT	SIO1S	; Configure the UART with above settings

	LXI	B,WORDS	; Point to WORDS

FETCH:	PUSH	PSW	; Save A & flags (Program Status Word)
SPIN:	IN	SIO1S	; Check serial I/O status bit 1 (XMIT status)
	ANI	SENT	; If data not sent (i.e. XMIT not finished)...
	JZ	SPIN	; ...spin wheels: continue checking status. Else...
	POP	PSW	; ...restore A & flags (Program Status Word)
	LDAX	B	; ...Fetch byte
	CPI	NUL	; ...If byte is ASCII NUL...
	JZ	HCF	; ......finish. Else...
	OUT	SIO1D	; ......output byte
	INX	B	; ......point to next byte
	JMP	FETCH	; ......lather, rinse, repeat: Fetch next byte.

HCF:	HLT		; Halt and Catch Fire ;-)

; Data segment

	ORG	200H	; Load at memory locaton 200 (hex)

WORDS:	DB	'Good-bye, cruel world!'
	DB	CR,LF	; Old-school CRLF newline
	DB	NUL	; NULL string terminator

	END
