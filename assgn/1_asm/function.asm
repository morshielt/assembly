buf_len equ 64

section .bss
    buf RESD buf_len
    fd RESD 1

;section .data
    ;msg db 'hello, world', 10
    ;msg_len equ $ - msg 

section .text
  global _start

_start:
    push 1 ; 8
    push 2
    push 3
    call _func
    add rsp, 24
    call _func
    call _func

    jmp _success
    
_func:
    push    rbp       ; save old call frame
    mov     rbp, rsp 
    sub rsp, 12 ; 3 x int
    MOV RSI, 0xFF
    MOV RDI, 0xFF
    
    mov     rsp,rbp  ; restore old call frame
    pop     rbp
    add rsp
    ret 0

_success:
    mov rax, 60
    mov rdi, 0
    syscall
    
_failure:
    mov rax, 60
    mov rdi, 1
    syscall

