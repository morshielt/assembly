section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg

section .text
global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    jp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall



