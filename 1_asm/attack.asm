section .text
global _start

_start:
    pop rdi ; argc
    pop rdi ; argv[0]


_exit:
    mov rax, 60
    mov rdi, 0
    syscall



