ALIGNMENT  equ -15                     ; stack is not aligned if ((rsp + 8) % 16 != 0)
                                       ; (AND rsp, -15) aligns the stack to 16

%define    n r12                       ; euron's id
%define    prog r13                    ; from argument
%define    arr r14
%define    val r15

%define    curr cl                     ; current symbol
%define    first rdx                   ; registers chosen for local usage, can be overwritten
%define    second rax

%define    m rdx                       ; id of euron to synchronize with
%define    nm rax                      ; equivalent of [n][m] in 2d array
%define    mn rcx                      ; equivalent of [m][n] in 2d array

global     euron
extern     get_value, put_value

section    .bss
    align  8
    VAL    resq (N*N)                  ; array for stack top values exchange
    align  8
    ARR    resb (N*N)                  ; array for synchronization

section    .text
align      8
euron:
    push   r12                         ; save registers
    push   r13
    push   r14
    push   r15
    push   rbx
    push   rbp
    mov    rbp, rsp

    lea    arr, [rel ARR]              ; no-pie resolve
    lea    val, [rel VAL]

    mov    n, rdi                      ; save euron's id
    mov    prog, rsi                   ; save program

loop_start:
    mov    curr, [prog]                ; current symbol
    inc    prog

    test   curr, curr                  ; check if reached the end ('\0')
    jz     _exit

PLUS:
    cmp    curr, '+'
    jne    STAR

    pop    first
    pop    second
    add    first, second
    push   first

    jmp    loop_start

STAR:
    cmp    curr, '*'
    jne    MINUS

    pop    first
    pop    second
    imul   first, second               ; signed multiplication
    push   first

    jmp    loop_start

MINUS:
    cmp    curr, '-'
    jne    EURON_ID

    pop    first
    neg    first
    push   first

    jmp    loop_start

EURON_ID:
    cmp    curr, 'n'
    jne    B

    push   n

    jmp    loop_start

B:
    cmp    curr, 'B'
    jne    C

    pop    first
    pop    second
    push   second

    test   second, second
    jz     loop_start
    add    prog, first

    jmp    loop_start

C:
    cmp    curr, 'C'
    jne    D

    pop    first

    jmp    loop_start

D:
    cmp    curr, 'D'
    jne    E

    pop    first
    push   first
    push   first

    jmp    loop_start

E:
    cmp    curr, 'E'
    jne    G

    pop    first
    pop    second
    push   first
    push   second

    jmp    loop_start

G:
    cmp    curr, 'G'
    jne    P

    push   rbp                         ; save stack frame
    mov    rbp, rsp                    ; initialize new call frame
    and    rsp, ALIGNMENT              ; align the stack

    mov    rdi, n                      ; get_value() n argument
    call   get_value

    mov    rsp, rbp                    ; revert call frame
    pop    rbp                         ; revert stack frame

    push   rax
    jmp    loop_start

P:
    cmp    curr, 'P'
    jne    S

    pop    rsi                         ; put_value() w argument

    push   rbp                         ; save stack frame
    mov    rbp, rsp                    ; initialize new call frame
    and    rsp, ALIGNMENT              ; align the stack

    push   rbp                         ; set up stack frame
    mov    rdi, n                      ; put_value() n argument
    call   put_value

    mov    rsp, rbp                    ; revert call frame
    pop    rbp                         ; revert stack frame
    jmp    loop_start

S:
    cmp    curr, 'S'
    jne    def

    pop    m                           ; euron to synchronize with

    mov    nm, n                       ; [n][m] index
    imul   nm, N
    add    nm, m

    mov    mn, m                       ; [m][n] index
    imul   mn, N
    add    mn, n

    access_wait:                       ; while (arr[n][m] != 0) {}
    cmp    byte [arr + nm], 0
    jne    access_wait

    pop    qword [val + nm*8]          ; val[n][m] = stack.top(); stack.pop();
    mov    byte [arr + nm], 1          ; arr[n][m] = 1;

    swap_wait:                         ; while (arr[m][n] != 1) {}
    cmp    byte [arr + mn], 1
    jne    swap_wait

    push   qword [val + mn*8]          ; stack.push(val[m][n]);
    mov    byte [arr + mn], 0          ; arr[m][n] = 0

    jmp    loop_start

def:
    sub    curr, '0'                   ; convert ASCII to integer
    movsx  rax, curr
    push   rax
    jmp    loop_start

_exit:
;    call sdump
    pop    rax                         ; return value from top of the stack

    mov    rsp, rbp                    ; restore register values
    pop    rbp
    pop    rbx
    pop    r15
    pop    r14
    pop    r13
    pop    r12
    ret

;sdump:
;    mov     rdi, [rsp + 8]
;    mov     rsi, [rsp + 8 * 2]
;    mov     rdx, [rsp + 8 * 3]
;    mov     rcx, [rsp + 8 * 4]
;    mov 	r8, [rsp + 8 * 5]
;    mov	    r9, [rsp + 8 * 6]
;    push	qword [rsp + 8 * 9]
;    push	qword [rsp + 8 * 9]
;    push	qword [rsp + 8 * 9]
;    call    stack_dump
;    add     rsp, 24         ; cleaning stack
;    ret
