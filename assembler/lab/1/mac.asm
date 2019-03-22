;1.5

global mac ; etykietę trzeba dać jako global, żeby była widoczna na zewnątrz mofułu asembelrowego

section .text

; Argumenty f. mac:
; rdi - wsk. do a
; rsi - wsk. do x
; rdx - wks. do y

mac:
    mov r8, [rsi] ; dolna cz. x do r8
    mov r9, [rdx] ; dolna cz. y do r9
    imul r8, [rdx+8] ; młodsza x starsza y
    imul r9, [rsi + 8] ; starsza x młodsza y

    mov rax, [rsi]
    mul qword [rdx] ; mnoży z tym co jest w rax - mnoży młodsze części
    ; w mul wynik jest 128bitowy w rdx:rax

    ; dodajemy starsze części
    add rdx, r8
    add rdx, r9

    ; dodajemy a
    add rax, [rdi]
    adc rdx, [rdi+8] ; add with carry

    ret

;TODO zadanie A4
;połączenie z C, przestrzeganie tego czyszczenia po funkcji

