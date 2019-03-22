global    _start

section   .text
_start:
    pop       r9                   ; address of string to output
    pop       rsi                   ; address of string to output
    dec         r9

print_one_arg:
    pop       r10                   ; address of string to output

    ; rcx <- len([rdi])
    mov       rdi, r10                   ; address of string to output
    xor       rcx, rcx
    xor       al, al ; null terminating string
    not       rcx ; czy to musi być?
    repne scasb
    nop
    not       rcx
    dec       rcx


    ; syscall write
    mov       rax, 1                  ; system call for write
    mov       rdi, 1                  ; file handle 1 is stdout
    mov       rdx, rcx                 ; number of bytes
    mov       rsi, r10
    syscall                           ; invoke operating system to do the write
    dec       r9

    cmp       r9, 0
    ja        print_one_arg


    ; exit
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

; section   .data
    ; message:  db        "aaaaaaaabbbbbbbbccccccccdddddddd"      ; note the newline at the end
