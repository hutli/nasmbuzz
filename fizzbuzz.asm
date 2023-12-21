BITS 64

section .rodata
    fizz db 'Fizz', 0             ; String "Fizz" followed by null terminator
    buzz db 'Buzz', 0             ; String "Buzz" followed by null terminator
    dfmt db '%d', 0               ; Number format string for printf
    newline db 10, 0              ; Newline print string
    
section .bss
    counter resb 8                ; Reserve 64 bit for counter
    fizz_or_buzz resb 1           ; Reserve 1 byte to check if we've printed fizz and/or buzz

section .text
    extern printf                 ; External function printf from the C library
    global _start                 ; Linker entry point

_start:
    mov QWORD [counter], 1        ; Set the loop counter to 1

main_loop:
    mov QWORD [fizz_or_buzz], 0   ; Reset fizz/buzz check

    ; Print "Fizz" if counter % 5 == 0
    lea rdi, [fizz]               ; Copy "Fizz" poniter as 1st argument (print string)
    mov rsi, [counter]            ; Copy counter as 2nd argument (dividend)
    mov rdx, 5                    ; Copy 5 as 3rd argument (divisor)
    xor rax, rax                  ; Zero out rax (vararg function calling convention)
    call div_and_print
    
    ; Print "Buzz" if counter % 3 == 0
    lea rdi, [buzz]               ; Copy "Buzz" poniter as 1st argument (print string)
    mov rsi, [counter]            ; Copy counter as 2nd argument (dividend)
    mov rdx, 3                    ; Copy 3 as 3rd argument (divisor)
    xor rax, rax                  ; Zero out rax (vararg function calling convention)
    call div_and_print
    
    ; Print counter if neither
    cmp QWORD [fizz_or_buzz], 1   ; Check if we've printed "Fizz" and/or "Buzz"
    je _while                     ; If we have, skip counter print
    lea rdi, [dfmt]               ; Get 1st argument (format string)
    mov rsi, [counter]            ; Get 2nd argument (counter to print)
    xor rax, rax                  ; Zero out rax (vararg function calling convention)
    call printf                   ; Call printf

_while:
    ; Print '\n' to geat each iteration on a new line
    lea rdi, [newline]            ; Get 1st argument for printf
    call printf                   ; Call printf

    ; increase counter by 1
    mov rax, QWORD [counter]      ; Load current counter value into rax
    add rax, 1                    ; Add rax and 1 and store the result in rax
    mov QWORD [counter], rax      ; Load new value into counter

    cmp rax, 100001               ; Check if the loop counter has reached 100001
    jne main_loop                 ; If not, jump back to continue the loop

; Exit the program
exit_program:
    mov rax, 60                   ; syscall for exit
    xor rdi, rdi                  ; status 0
    syscall                       ; call kernel


; ==== DIV_AND_PRINT FUNCTION ====
div_and_print:
    ; save rbp
    push rbp
    mov rbp, rsp

    ; function body
    ; 1st argument "rdi" is directly passed to printf
    mov rax, rsi                  ; Copy dividend from 2nd argument
    mov rcx, rdx                  ; Copy devisor from 3rd argument

    mov rdx, 0                    ; Clear the dividend high part
    div rcx                       ; Divide rax (implicit) with rcx and store remainder in rdx (implicit)
    cmp rdx, 0                    ; Compare remainder
    jne _return                   ; If not zero return
    mov QWORD [fizz_or_buzz], 1   ; Register fizz/buzz
    call printf

_return:
    mov rax, 0
    ; restore rbp and return
    mov rsp, rbp
    pop rbp
    ret