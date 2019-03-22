global inc_thread
%define value rsi
%define count ecx

section .text

align 8
inc_thread:
    mov     value, [rdi]      ; value
    mov     count, [rdi + 8]  ; count
    jmp     count_test
count_loop:
    inc     dword [value]     ; ++*value
count_test:
    sub     count, 1          ; --count
    jge     count_loop      ; skok, gdy count >= 0
    xor     eax, eax        ; return NULL
    ret
