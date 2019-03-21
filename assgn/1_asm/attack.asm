BUFFER_LEN equ 8192
SPECIAL_NUMBER equ 68020
MOD equ 4 ; file has wrong length if (length % 4 != 0)

%define ONE ebx ; = 1, used to reset counter or set variable to 'true', for cmov use
%define fd r8 ; file descriptor
%define i r9 ; 'iterator' over numbers in current buffer
%define bytes_read r10 ; how many bytes were read by sys_read
%define curr r15d ; current number from buffer
%define found_number_between r12d ; 1 if already read x satisfying 68020 < x < 2^31
%define position_in_seq r13d ; current position in SEQUENCE
%define sum r14d ; (sum of all numbers from file) % 2^32 (guaranteed by 32-bit register)

section .rodata
    SEQUENCE dd 6, 8, 0, 2, 0 ; attack sequence

section .bss
    buffer resd BUFFER_LEN ; (dwords = 4 byte = 32 bit) * (BUFFER_LEN)

section .text
    global _start

; initialization of registers
_start:
    xor fd, fd
    mov ONE, 1
    xor i, i
    xor bytes_read, bytes_read
    xor curr, curr
    xor found_number_between, found_number_between
    xor position_in_seq, position_in_seq
    xor sum, sum

; check if number of arguments == 1
_check_argc:
    mov rbp, rsp
    mov rcx, [rbp] ; get argc from stack
    dec rcx ; program name doesn't count
    cmp rcx, 1 ; check if exactly one argument was given
    jne _no_attack

; attempt to open file
_open:
    mov rax, 2 ; sys_open
    lea rdi, [rbp + 16] ; argv[1] (filename) from stack
    mov rdi, [rdi]
    mov rsi, 0 ; 0 = O_RDONLY
    mov rdx, 0 ; NO MODE
    syscall

    mov fd, rax ; save file descriptor
    test fd, fd ; check if returned file descriptor >= 0
    js _no_attack

; attempt to read from file
_read:
    mov rax, 0 ; sys_read
    mov rdi, fd ; file_desc
    mov rsi, buffer ; *buf
    mov rdx, BUFFER_LEN ; how many bytes to read
    syscall

    mov bytes_read, rax
    test bytes_read, bytes_read
    jz _final_check ; EOF
    js _no_attack ; read error

; process portion of numbers from file
_process_buffer:
    xor i, i ; reset 'iterator'
    ; check for wrong file size (number of read bytes % 4 != 0)
    mov rcx, MOD - 1 ; MOD is a power of 2, so a % b == a & (b - 1)
    and rcx, bytes_read
    jne _no_attack

; check if current number satisfies any special conditions
_process_curr:
    ; get the number from buffer
    mov curr, [buffer + i]
    bswap curr ; big endian to little endian

; check if current number is the special number
_special_number:
    cmp curr, SPECIAL_NUMBER
    je _no_attack
    ; also check if (68020 < curr < 2^31)
    cmovg found_number_between, ONE ; if between, set found_number_between to 'true'

_attack_sequence:
    cmp position_in_seq, 5
    je _sum ; already found whole 5 number sequence, no need to check again

    ; check if sequence continues
    cmp curr, [SEQUENCE + 4 * position_in_seq]
    jne _check_start
    inc position_in_seq
    jmp _sum

; check if new sequence starts
_check_start:
    xor position_in_seq, position_in_seq ; reset position_in_seq
    cmp curr, [SEQUENCE]
    cmove position_in_seq, ONE ; new sequence starts, set counter to 1

; add current number to sum (mod 2^32 guaranteed by 32-bit register)
_sum:
    add sum, curr

; decide what to do next
_next_action:
    add i, MOD
    cmp i, bytes_read
    je _read ; already read whole buffer, read next bytes
    jmp _process_curr ; reading next number from buffer

; check if all conditions for attack were satisfied
_final_check:
    cmp found_number_between, ONE ; check if number between 68020 and 2^32 was present
    jne _no_attack
    cmp position_in_seq, 5 ; check if whole sequence was present
    jne _no_attack
    cmp sum, SPECIAL_NUMBER ; check if sum % 2^32 == 68020
    jne _no_attack

; quit with exit code 0
_attack:
    mov rax, 60
    mov rdi, 0
    syscall

; quit with exit code 1
_no_attack:
    mov rax, 60
    mov rdi, 1
    syscall
