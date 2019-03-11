buffer_len equ 64
%define fd r8
%define i r9
%define bytes_read r10
%define curr r11d
%define between_cond r12b
%define seq_ctr r13
%define sum r14 ; przerobić na d

;; tablica bd wolna, bo bd skakać po pamięci~ D:
; tablica z {6, 8, 0, 2, 0} i sprawdzać cmp biezaca, tablica[seq_ctr] CCCCCC:

; TODO! sys_close! XD

section .bss
    buffer resd buffer_len ; dwords (4 byte = 32 bit) * buffer_len

section .text
    global _start

_start: ; init
    mov fd, 0
    mov i, 0
    mov bytes_read, 0
    mov curr, 0
    mov between_cond, 0
    mov seq_ctr, 0
    mov sum, 0

_file_name:
    mov rbp, rsp
    mov rcx, [rbp] ; argc
    dec rcx
    cmp rcx, 1 ; check if exactly one argument was given
    je _open
    jmp _failure

_open:
    mov rax, 2 ; sys_open
    lea rdi, [rbp+16]
    mov rdi, [rdi] ; file_name from stack
    mov rsi, 0 ; O_RDONLY flag
    mov rdx, 0 ; NO MODE
    syscall

    mov fd, rax ; save file descriptor
    cmp rax, 0 ; TODO change to fd?
    jae _read
    jmp _failure
    
_read: ; read_chunk
    mov rax, 0 ; sys_read
    mov rdi, fd ; file_desc
    mov rsi, buffer ; *buf
    mov rdx, buffer_len ; how many to read
    syscall

    mov i, 0 ; TODO! to chyba trzeba inicjalizować przed?
    ;  a nie chyba nie!, chyba za każdym razem xD, dla każego nowego chunka
    mov bytes_read, rax
    cmp bytes_read, 0
    ja _process_chunk ; process_chunk
    je _final_check ; read EOF, finalization
    jmp _failure ; read error
    
_process_chunk:
    mov rdx, 0        ; clear dividend
    mov rax, bytes_read   ; dividend
    mov rcx, 4    ; divisor
    div rcx           ; rax = WYNIK, RDX = RESZTA
    cmp rdx, 0 ; read bytes MOD 4 == 0
    jne _failure

_process_curr:
    nop
    nop
    nop
    ;read current integer
    mov curr, 0
    ;;;mov curr, [buffer + i*4] ; to dziwne xD
    mov curr, [buffer + i] ;;; bo już nie i++, tylko i += 4
    bswap curr
    
    ;condition1 - not 68020
_condition1:
    cmp curr, 68020
    je _failure
    ; wpp idź dalej
    ; jmp _success <- co to w ogóle tu jest xD
    
    ;condition2 - between
_condition2:
    cmp between_cond, 0
    jne _condition3 ; already found, no need to check
    cmp curr, 68020
    jbe _condition3 ; curr <= 68020, next
    cmp curr, 2147483648 ; = 2^31
    jae _condition3 ; 2^31  curr >= 2^31, next
    mov between_cond, 1 ; 68020 < curr < 2^31, ok, found
    
_condition3: ;TODO! optymalizacja kolejności porównań, ale to na koniec,
             ; teraz nie zawracać się tym xD
    ;condtion3
    cmp seq_ctr, 5
    je _condition4 ; already found sequence, no need to check

    ;(seq_ctr == 0 && _curr == 6)
_seq_ctr0:
    cmp seq_ctr, 0
    jne _seq_ctr1
    cmp curr, 6
    jne _condition4
    inc seq_ctr
    jmp _condition4

    ; (seq_ctr == 1 && _curr == 8)
_seq_ctr1:
    cmp seq_ctr, 1
    jne _seq_ctr24
    cmp curr, 8
    jne _seq_ctr_reset
    inc seq_ctr
    jmp _condition4

    ; ((seq_ctr == 2 || seq_ctr == 4 ) && _curr == 0)
_seq_ctr24:
    cmp seq_ctr, 2
    je _seq_ctr24_liczba0
    cmp seq_ctr, 4
    jne _seq_ctr3

_seq_ctr24_liczba0:
    cmp curr, 0
    jne _seq_ctr_reset
    inc seq_ctr
    jmp _condition4

    ;elif seq_ctr == 3 && _curr == 2:
_seq_ctr3:
    ;cmp seq_ctr, 3
    ;jne _seq_ctr_reset
    cmp curr, 2
    jne _seq_ctr_reset
    inc seq_ctr
    jmp _condition4

_seq_ctr_reset:
    mov seq_ctr, 0

_condition4:
    mov rax, 0
    mov eax, curr
    add sum, rax
    mov rdx, 0        ; clear dividend
    mov rax, sum   ; dividend
    mov rcx, 4294967296    ; divisor 2**32
    div rcx           ; rax = WYNIK, RDX = RESZTA
    mov sum, rdx
    nop

_next_number:
    ;;; to raczej było źle c:
    ;;; inc i
    ;;;cmp i, bytes_read ; czy jak ja to tu co 1 zwiększam,
    ; to czy to nie jest źle?
    ; bo to tak, jakbym czytała ich więcej tu jakoś, niedobrze~

    add i, 4
    cmp i, bytes_read
    je _read
    jmp _process_curr
    
_final_check:
  cmp between_cond, 1
  jne _failure
  cmp seq_ctr, 5
  jne _failure
  cmp sum, 68020
  jne _failure

_success:
    mov rax, 60
    mov rdi, 0
    syscall
    
_failure:
    mov rax, 60
    mov rdi, 1
    syscall

_dwa:
    mov rax, 60
    mov rdi, 2
    syscall
