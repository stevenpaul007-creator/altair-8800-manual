	PAGE	40		; 40 lines per page
	TITLE	"multiply.asm - Copyright (C) Kevin Cole 2020.10.06 (GPL)"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; NAME:    multiply.asm
; AUTHOR:  Kevin Cole ("The Ubuntourist") <kevin.cole@novawebdevelopment.org>
; LASTMOD: 2020.10.06 (kjc)
; 
; DESCRIPTION: 
; 
;     This is the assembly source code that produces the same machine
;     op codes as shown by the second example (multiply two numbers) in
;     the Altair 8800 Operator's Manual.
; 
;     On a modern (as of 2020) Linux machine, install the
;     Macroassembler AS found at:
;
;         http://john.ccac.rwth-aachen.de:8000/as/
; 
;     Then assemble this source file with the command:
; 
;         asl -a -cpu 8080 -L -listradix 8 multiply.asm
; 
;     to compare the generated list file (multiply.lst) to the octal
;     machine op codes provided in the manual.
;
;     However, if you have installed "most" -- you know you want it --
;     it is VERY instructive to instead assemble the source file with 
;     the command:
;
;         asl -a -cpu 8080 -L -listradix 16 multiply.asm
;
;     This produces the same binary file (multiply.p) but changes the
;     format of the list file, displaying the machine op codes in
;     hexadecimal, rather than octal, and, together with the command:
;
;         most multiply.p
;
;      you can study the actual binary "executable" produced, and
;      "debug" it by finding the machine op codes (in hex) embedded
;      in the executable (by comparing it to multiply.lst).
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Code segment:

	ORG	000o	; Set Program Counter to address 0
START:	MVI	A,2o	; Multiplier   (2) to A   Register
	MVI	D,3o	; Multiplicand (3) to D,E Registers
	MVI	E,0o
	LXI	H,0o	; Clear H,L Registers to initialize Partial Product
	MVI	B,10o	; Iteration Count (8) to B Register
LOOP:	DAD	H	; Shift Partial Product left into Carry (H&L)
	RAL		; Rotate Multiplier Bit to Carry
	JNC	NEXT	; Test Multiplier at Carry
	DAD	D	; Add Multiplicand to Partial Product (D&E)
			;   if Carry =1
	ACI	0o	; (Add Carry Bit)
NEXT:	DCR	B	; Decrement Iteration Counter
	JNZ	LOOP	; Check Iterations
	SHLD	TOTAL	; Store Answer in Locations 100,101
	JMP	START	; Restart

; Data segment:

 	ORG	100o	; Set Program Counter to address 100 (octal)
TOTAL:	DS	2o	; Reserve 2 bytes (1 word) of unintialized storage

	END		; End
