section .data
    msg db 'hello, world', 10
    msg_len equ $ - msg

section .text
  global _start

_start:
    mov rbp,rsp
    mov rcx, [rbp] ; argc
    dec rcx ; pierwszy arg się nie liczy
    cmp rcx, 1 ; czy podane dokł. 1 arg.
    je _args_ok
    jmp _failure

_args_ok:
    ;open(const char *pathname, int flags, mode_t mode);
    mov rax, 2 ; sys_open
    lea rdi, [rbp+16] ; pathaddress
    mov rdi, [rdi] ;pathname
    mov rsi, 0 ; O_RDONLY
    mov rdx, 0 ; NO MODE
    syscall
    cmp rax, 0
    jge _file_opened
    jmp _failure

_file_opened:
   jmp _success

_success:
    mov rax, 60
    mov rdi, 0
    syscall

_failure:
    mov rax, 60
    mov rdi, 1
    syscall
