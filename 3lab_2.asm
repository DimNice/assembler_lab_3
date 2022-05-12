%include "io64.inc"

; a=2, b=0, c=2, d=2; f=e; x>=z

section .bss
    class: resb 16
    structura: resb 16
section .text
global CMAIN
CEXTERN _ZN4hard4var21C6accessERKNS0_1SE 
CMAIN:
    mov rbp, rsp; for correct debugging

    push rbp
    mov rbp, rsp
    sub rsp, 40
    and rsp, -16
    
    mov eax, 2 ;                 a
    mov [class], eax 
    mov eax, 0 ;                 b
    mov [class + 4], eax 
    mov eax, 2 ;                 c
    mov [class + 8], eax 
   ;                 d
    mov [class + 12], eax 
    
    mov eax, 0 ;                 f
    mov [structura], eax
                   ; e
    mov [structura+4], eax
    mov eax, 5 ;                 z
    cvtsi2ss xmm4, eax
    movss [structura + 8], xmm4 
    mov eax, 5 ;                 x
    movss [structura + 12], xmm4
    
    lea rcx, [class]; пробрасываем аргументы (в rcx - класс, в rdx - структура)
    lea rdx, [structura]
    
    call _ZN4hard4var21C6accessERKNS0_1SE ;вызываем функцию
    mov rsp, rbp
    pop rbp
    
    xor rax, rax
    ret