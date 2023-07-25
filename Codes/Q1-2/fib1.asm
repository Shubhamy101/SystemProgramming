section .text
    default rel
    extern printf
    global main

main:
    ; Create a stack-frame, re-aligning the stack to 16-byte alignment before calls
    push rbp

    ; Set the value of n to the desired Fibonacci number (e.g., 10 for the 10th Fibonacci number)
    mov rdi, fmt
    mov rsi, 10     ; Replace 10 with the desired value of n
    call fibonacci

    ; Print the result
    mov rdi, fmt_result
    mov rsi, rax    ; The result of the Fibonacci function is stored in rax
    call printf wrt ..plt
    
    pop rbp         ; Pop stack

    mov rax, 0      ; Exit code 0
    ret             ; Return

section .data
    fmt:        db "Calculating Fibonacci(%d)...", 10, 0
    fmt_result: db "Fibonacci(%d) = %d", 10, 0

section .bss
    fib_result resq 1   ; Buffer to store the result of the Fibonacci calculation

section .text

; Function to calculate the nth Fibonacci number
fibonacci:
    push rbp
    mov rbp, rsp

    ; Get the value of n from the first function argument (rdi)
    mov rax, rdi

    ; Base case: Fibonacci(0) and Fibonacci(1) are both 1
    cmp rax, 1
    jbe .fibonacci_base

    ; Allocate space for Fibonacci(n) and Fibonacci(n-1) on the stack
    sub rsp, 16

    ; Calculate Fibonacci(n-1) recursively
    dec rax
    mov rdi, rax        ; Pass n-1 as the first argument to the recursive call
    call fibonacci

    ; Store the result of Fibonacci(n-1) in [rbp - 8]
    mov qword [rbp - 8], rax

    ; Calculate Fibonacci(n-2) recursively
    dec rax
    mov rdi, rax        ; Pass n-2 as the first argument to the recursive call
    call fibonacci

    ; Add Fibonacci(n-1) and Fibonacci(n-2) to get Fibonacci(n)
    add rax, qword [rbp - 8]

    ; Clean up the stack
    add rsp, 16

    pop rbp
    ret

.fibonacci_base:
    mov rax, 1          ; Fibonacci(0) and Fibonacci(1) are both 1
    pop rbp
    ret
