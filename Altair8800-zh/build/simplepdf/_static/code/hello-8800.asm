	PAGE	40		; 40 lines per page
	TITLE	"hello-8800.asm - Copyright (C) Kevin Cole 2020.10.06 (GPL)"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; NAME:    hello-8800.asm
; EDITOR:  Kevin Cole ("The Ubuntourist") <kevin.cole@novawebdevelopment.org>
; LASTMOD: 2020.10.06 (kjc)
; 
; DESCRIPTION: 
; 
;     "Hello world!" suitable for the Macroassembler AS found at:
;
;         http://john.ccac.rwth-aachen.de:8000/as/
; 
;     Assemble this source file with the command:
; 
;         asl -a -cpu 8080 -L -listradix 8 hello-8800.asm
; 
;     to generate a list file (sioecho.lst) that displays the machine
;     op codes as octal values.
;
;     However, if you have installed "most" -- you know you want it --
;     it is VERY instructive to instead assemble the source file with 
;     the command:
;
;         asl -a -cpu 8080 -L -listradix 16 hello-8800.asm
;
;     This produces the same binary file (sioecho.p) but changes the format
;     of the list file, displaying the machine op codes in hexadecimal,
;     rather than octal, and, together with the command:
;
;         most sioecho.p
;
;      you can study the actual binary "executable" produced, and
;      "debug" it by finding the machine op codes (in hex) embedded
;      in the executable (by comparing it to sioecho.lst).
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Code segment

	ORG	0
LOOP:	IN	10h		; Wait for character
	RRC
	JC	LOOP		; Nothing yet (negative logic)
	IN	11h		; Read the character
	OUT	11h		; Echo it
	JMP	LOOP		; Wait for next character
	
; Data segment

	ORG	100h

	END			; End
