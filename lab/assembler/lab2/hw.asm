section .rodata
    array dd 1,2,3,4,5
    arraylen equ $ - array

;    msg db 'hello, world', 10

section .text
global _start

_start:
    mov r15d, 2
    mov edi, [array + 4]
    cmp r15d, edi
    jne _neq

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_neq:
    mov rax, 60
    mov rdi, 1
    syscall



