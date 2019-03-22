%define n r12
%define prog rsi
%define curr r13b

global euron
extern get_value, put_value

section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg
section .text

euron:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push rbp
    mov rbp, rsp

    ; save euron's id
    mov n, rdi
    ; program is in rsi
    mov curr, [prog]




;prog print test~
    push rcx
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, prog
    mov rdx, 42
    syscall
    pop r11
    pop rcx

;    mov   dl, [rsi] ; nie używać dl D:
;    cmp   dl, 'B'

    mov rsp, rbp
    pop rbp
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    ret