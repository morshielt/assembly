; TODO ASK -no-pie
%define    n    r12     ; euron's id
%define    curr r13b    ; current symbol
%define    prog r15     ; from argument
%define    first rbx
%define    second rax


%define i r14



global    euron
extern    get_value, put_value, printf, register_dump, stack_dump

section .bss
    jt resq 128

section .data
    basic_print db "curr = %c, iter = %ld", 10, 0  ; The printf format, "\n",'0'
    check_print db "EURON_ID_n = %ld, PROG = %s", 10, 0  ; The printf format, "\n",'0'
    number_print db "stack number: %d", 10, 0

section .text
euron:
    push    r12         ; save registers
    push    r13
    push    r14
    push    r15
    push    rbx
    push    rbp
    mov     rbp, rsp

    ; JUMP_TABLE INIT
;    mov rax, PLUS
;    mov rcx, '+'
;    mov [jt + rcx], rax
;
;    mov rax, STAR
;    mov rcx, '*'
;    mov [jt + rcx], rax

    mov rax, MINUS
    mov rcx, '-'
    mov [jt + rcx*8], rax

    mov rax, def
    mov rcx, '1'
    mov [jt + rcx*8], rax

    mov rax, def
    mov rcx, '2'
    mov [jt + rcx*8], rax

    mov rax, EURON_ID
    mov rcx, 'n'
    mov [jt + rcx], rax

    ; init
    mov    n, rdi       ; save euron's id from rdi ;;; TODO czy mogę w rdi zostawić? printf zmienia rdi, nie :C
    mov    prog, rsi    ; save program from rsi
    ; check if we have good parameters in good registers
    call input_args_print

loop:
    mov    curr, [prog] ; current symbol
    call current_print
    inc prog
    test curr, curr
    jz _exit
    movsx i, curr
    jmp [jt + i]

PLUS:
    cmp    curr, '+'
    jne STAR
    call sdump
    pop first
    pop second
    add first, second
    push first
    call sdump
    jmp loop

STAR:
    cmp    curr, '*'
    jne MINUS
    call sdump
    pop first
    pop second
    imul first, second
    push first
    call sdump
    jmp loop

MINUS:
    cmp curr, '-'
    jne EURON_ID
    pop first
    neg first
    push first
    call sdump
    jmp loop

EURON_ID:
    cmp curr, 'n'
    jne B
    push n
    call sdump
    jmp loop

B: ;nwm czy do tyłu działa; edit: działa na przykładzie xd
    cmp curr, 'B'
    jne C
    pop first
    pop second
    push second
    test second, second
    jz loop
    add prog, first
;    inc prog - nie trzeba bo ja prze ten inc na początku jestem już o jeden do przodu chociaż nie jestem, rip
    jmp loop

C:
    cmp curr, 'C'
    jne D
    pop first
    call sdump
    jmp loop

D:
    cmp curr, 'D'
    jne E
    pop first
    push first
    push first
    call sdump
    jmp loop

E:
    cmp curr, 'E'
    jne G
    pop first
    pop second
    push first
    push second
    call sdump
    jmp loop

G:
    cmp curr, 'G'
    jne P
    push   rbp            ; set up stack frame
    mov rdi, n
    call get_value
    pop rbp
    push rax
    call sdump
    jmp loop

P:
    cmp curr, 'P'
    jne S
    pop rsi
    push   rbp            ; set up stack frame
    mov rdi, n
    call put_value
    pop rbp
    call sdump
    jmp loop

S:
    cmp curr, 'S'
    jne def
    pop first
    jmp loop


def:
    call sdump
    sub curr, '0'
;    call print_number
    movsx r13, curr
;    sub r13, '0' ; ASCII SHIFT
    push r13
    call sdump
    jmp loop

_exit:
    call sdump
    mov    rsp, rbp     ; restore register values
    pop    rbp
    pop    rbx
    pop    r15
    pop    r14
    pop    r13
    pop    r12
    ret

print_number:
    push   rbp            ; set up stack frame
    mov    rdi, number_print            ; format for printf
    MOVSX r13, curr
    mov    rsi, r13         ; first parameter for printf
    mov    rax, 0            ; no xmm registers
    call   printf        ; Call C function
    pop    rbp                ; restore stacks
    ret

input_args_print:
    push   rbp            ; set up stack frame
    mov    rdi, check_print            ; format for printf
    mov    rsi, n         ; first parameter for printf
    mov    rdx, prog         ; second parameter for printf
    mov    rax, 0            ; no xmm registers
    call   printf        ; Call C function
    pop    rbp                ; restore stacks
    ret

current_print:
    push   rbp            ; set up stack frame
    mov    rdi, basic_print            ; format for printf
    MOVSX r13, curr
    mov    rsi, r13         ; first parameter for printf
    mov    rdx, prog         ; second parameter for printf
    mov    rax, 0            ; no xmm registers
    call   printf        ; Call C function
    pop    rbp                ; restore stack
    ret

sdump:
	mov     rdi, [rsp + 8]
	mov     rsi, [rsp + 8 * 2]
	mov     rdx, [rsp + 8 * 3]
	mov     rcx, [rsp + 8 * 4]
	mov 	r8, [rsp + 8 * 5]
	mov	    r9, [rsp + 8 * 6]
	push	qword [rsp + 8 * 9]
	push	qword [rsp + 8 * 9]
	push	qword [rsp + 8 * 9]
    call    stack_dump
	add     rsp, 24         ; cleaning stack
	ret

rdump:
	push	r15
	push	r14
	push	r13
	push	r12
	push	r11
	push	r10
	push	rsp
	push	rbp
	push    rbx
	push    rax
    call    register_dump
	add     rsp, 80         ; cleaning stack
	ret