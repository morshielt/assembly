; TODO  rbx, rsp, rbp i r12 do r15 MOGĘ UŻYWAĆ
MOD equ 15                             ; stack is not aligned if ((rsp + 8) % 16 != 0)

%define    n r12                       ; euron's id
%define    prog r13                    ; from argument
%define    arr r14
%define    val r15
;%define    jt rbx
; TODO rbx było jt, teraz wolne <chyba>

%define    curr cl                     ; current symbol
%define    first rdx                   ; registers chosen for local usage, can be overwritten
%define    second rax

%define    m rdx                       ; id of euron to synchronize with
%define    nm rax                      ; equivalent of [n][m] in 2d array
%define    mn rcx                      ; equivalent of [m][n] in 2d array

global     euron
;extern    get_value, put_value
extern     get_value, put_value, printf, register_dump, stack_dump

section    .bss
;    align 8
;    JT    resq 128
    align  8
    VAL    resq (N*N)

section .data
    align  8
    ARR    times (N*N) dq -1

section .text
align 8
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
;    lea jt, [rel JT]
;
;    lea rax, [rel PLUS]               ; JUMP_TABLE INIT
;    mov [jt + '+'*8], rax
;
;    lea rax, [rel STAR]
;    mov [jt + '*'*8], rax
;
;    lea rax, [rel MINUS]
;    mov [jt + '-'*8], rax
;
;    lea rax, [rel def]
;    mov [jt + '0'*8], rax
;    mov [jt + '1'*8], rax
;    mov [jt + '2'*8], rax
;    mov [jt + '3'*8], rax
;    mov [jt + '4'*8], rax
;    mov [jt + '5'*8], rax
;    mov [jt + '6'*8], rax
;    mov [jt + '7'*8], rax
;    mov [jt + '8'*8], rax
;    mov [jt + '9'*8], rax
;
;    lea rax, [rel EURON_ID]
;    mov [jt + 'n'*8], rax
;
;    lea rax, [rel B]
;    mov [jt + 'B'*8], rax
;
;    lea rax, [rel C]
;    mov [jt + 'C'*8], rax
;
;    lea rax, [rel D]
;    mov [jt + 'D'*8], rax
;
;    lea rax, [rel E]
;    mov [jt + 'E'*8], rax
;
;    lea rax, [rel G]
;    mov [jt + 'G'*8], rax
;
;    lea rax, [rel P]
;    mov [jt + 'P'*8], rax
;
;    lea rax, [rel S]
;    mov [jt + 'S'*8], rax              ; JUMP_TABLE END OF INIT

    ; init
    mov    n, rdi                      ; save euron's id
    mov    prog, rsi                   ; save program

loop_start:
    mov    curr, [prog]                ; current symbol
    inc    prog

    test   curr, curr                  ; check if reached the end ('\0')
    jz     _exit
;    movsx rcx, curr
;    jmp [jt + rcx*8]

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
;    inc prog - nie trzeba bo ja przeZ ten inc na początku jestem już o jeden do przodu chociaż nie jestem, rip
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

    mov    rdx, rsp                    ; check if stack needs to be aligned
    add    rdx, 8
    and    rdx, MOD
    je     G_aligned
    sub    rsp, 8                      ; align the stack

    G_aligned:
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

    mov    rdx, rsp                    ; check if stack needs to be aligned
    add    rdx, 8
    and    rdx, MOD
    je     P_aligned
    sub    rsp, 8                      ; align the stack

    P_aligned:
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

    access_wait:                       ; while (arr[n][m] != -1) {}
    cmp    qword [arr + nm*8], -1
    jne    access_wait

    pop    qword [val + nm*8]          ; val[n][m] = pop
    mov    [arr + nm*8], m             ; arr[n][m] = m

    swap_wait:                         ; while (arr[m][n] != n) {}
    cmp    qword [arr + mn*8], n
    jne    swap_wait

    push   qword [val + mn*8]          ; push val[m][n]
    mov    qword [arr + mn*8], -1      ; arr[m][n] = -1

    jmp    loop_start

def:
    sub    curr, '0'
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
;	mov     rdi, [rsp + 8]
;	mov     rsi, [rsp + 8 * 2]
;	mov     rdx, [rsp + 8 * 3]
;	mov     rcx, [rsp + 8 * 4]
;	mov 	r8, [rsp + 8 * 5]
;	mov	    r9, [rsp + 8 * 6]
;	push	qword [rsp + 8 * 9]
;	push	qword [rsp + 8 * 9]
;	push	qword [rsp + 8 * 9]
;    call    stack_dump
;	add     rsp, 24         ; cleaning stack
;	ret
