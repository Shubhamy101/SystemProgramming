section .bss
    fib resq 1 ; Variable to store the nth Fibonacci number

section .text
    global _start

_start:
    ; Read the value of n from the command line argument
    mov rdi, 1              ; File descriptor 1 points to stdout (standard output)
    mov rsi, rdx            ; rdx register contains the pointer to the arguments array
    mov rdx, 10             ; Read up to 10 bytes (we assume n won't exceed 10 digits)
    call read_int

    ; Check if the input is a valid positive integer (n >= 0)
    test rax, rax           ; Check if rax (the input) is zero
    js invalid_input        ; If it's negative, jump to the invalid_input label

    ; Calculate the nth Fibonacci number iteratively
    mov rsi, 0              ; Initialize F(0) = 0
    mov rdi, 1              ; Initialize F(1) = 1

    cmp rax, 1              ; Check if n is less than or equal to 1
    jbe fib_done            ; If yes, we are done as F(0) or F(1) is the result

fib_loop:
    add rsi, rdi            ; F(n) = F(n-1) + F(n-2)
    mov rcx, rdi            ; Save F(n-1) in rcx
    mov rdi, rsi            ; Save F(n) in rdi
    mov rsi, rcx            ; Save F(n-2) in rsi
    dec rax                 ; Decrement n

    cmp rax, 1              ; Check if n is less than or equal to 1
    jg fib_loop             ; If yes, continue the loop

fib_done:
    ; The result (F(n)) is stored in the rdi register.
    ; You can use it for further operations or print it as needed.

    ; Exit the program
    mov rax, 60             ; syscall number for exit
    xor rdi, rdi            ; Exit code 0
    syscall

invalid_input:
    ; Handle invalid input (negative n)
    ; You can implement an error message or simply exit with an error code here.
    ; For simplicity, we will exit with an error code of 1.
    mov rax, 60             ; syscall number for exit
    mov rdi, 1              ; Error code 1
    syscall
