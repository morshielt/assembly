%macro jump_table_init 2 ; calculate ((%1) + (%2) * N) * 8, meaning index '[%1][%2]'
    mov rax, %1
    mov [jump_table + %2*8], rax
%endmacro

section .bss
    jump_table resq 128

section .text
global _start

section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; jump_table init
    jump_table_init label1, 125
;    mov rax, label1
;    mov [jump_table + 125*8], rax

    mov rax, label2
    mov [jump_table + 127*8], rax

    mov rax, _exit4
    mov [jump_table + 126*8], rax
    ; end of init

    jmp [jump_table + 125*8] ; label1

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

label1:
    jmp [jump_table + 127*8] ;label2

_exit4:
    mov rax, 60
    mov rdi, 4
    syscall

label2:
    jmp [jump_table + 126*8] ; _exit4


