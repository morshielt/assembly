%define i r15
%define    curr r13b    ; current symbol
section .bss
    jt resb 128

section .text
global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

;    lea rax, [jt + 'x']
    mov rax, _exit2
    mov rdi, 'x'
    mov [jt + rdi], rax

    xor i, i
    mov curr, 'x'
    movsx r13, curr

    add i, r13
;    sub i, 48 ; ASCII
;    mov [jt + i], rax
;    mov r9, 'x'
;    lea r10, [jt + r9]
;    add rcx, rax
;    mov rbx, [jt + rax]
;    mov rbx, [rbx]
;    jmp r10
;    jmp rax
    jmp [jt + i]
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_exit2:
    mov rax, 60
    mov rdi, 1
    syscall


section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg
