%define i r15
%define    prog r14     ; from argument
%define    curr r13b    ; current symbol

OSIEM equ 8
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

    mov rax, _exit2
    mov rdi, '1'
;    imul rdi, OSIEM
    lea rdx, [jt + rdi]
    mov [jt + rdi*8], rax

    mov rax, _exit3
    mov rdi, '2'
;    imul rdi, OSIEM
    mov [jt + rdi*8], rax

    mov rax, _exit4
    mov rdi, '3'
;    imul rdi, OSIEM
    mov [jt + rdi*8], rax

;    xor i, i
    mov curr, '1'
    movsx i, curr
    jmp [jt + i*8]


label:
    mov curr, '2'
    movsx i, curr
    jmp [jt + i*8]

;    add i, r13
;    sub i, 48 ; ASCII
;    mov [jt + i], rax
;    mov r9, 'x'
;    lea r10, [jt + r9]
;    add rcx, rax
;    mov rbx, [jt + rax]
;    mov rbx, [rbx]
;    jmp r10
;    jmp rax
;    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_exit2:
    jmp label
    mov rax, 60
    mov rdi, 2
    syscall

_exit3:
    mov rax, 60
    mov rdi, 3
    syscall

_exit4:
    mov rax, 60
    mov rdi, 4
    syscall


section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg
