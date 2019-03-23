section .bss
    jump_table resb 128

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
    mov rax, label1
    mov [jump_table + '1'*8], rax

    mov rax, label2
    mov [jump_table + '2'*8], rax

    mov rax, _exit4
    mov [jump_table + '3'*8], rax
    ; end of init

    jmp [jump_table + '1'*8] ; label1

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

label1:
    jmp [jump_table + '2'*8] ;label2

_exit4:
    mov rax, 60
    mov rdi, 4
    syscall

label2:
    jmp [jump_table + '3'*8] ; _exit4


