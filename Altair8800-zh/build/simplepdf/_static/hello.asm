; "Hello World" example, Netwide Assembler (nasm) syntax
; Copied by "The Ubuntourist" (kevin.cole@novawebdevelopment.org) 2020.09.25
; from https://en.wikipedia.org/wiki/Netwide_Assembler
;
; To assemble and run:
;
;     nasm -f elf64 hello.asm && ld hello.o && ./a.out
;
; See also https://cs.lmu.edu/~ray/notes/nasmtutorial/
;

global _start

section .text
_start:
        mov  eax, 4         ; write
        mov  ebx, 1         ; stdout
        mov  ecx, msg
        mov  edx, msg.len
        int  0x80           ; write(stdout, msg, strlen(msg));

        xor   eax, msg.len  ; invert return value from write()
        xchg  eax, ebx      ; value for exit()
        mov   eax, 1        ; exit
        int   0x80          ; exit(...)

section .data
msg:    db    "Hello, world!", 10 ; 10 = ^J = LF = "\n"
.len:   equ   $ - msg             ; current location - msg: location
