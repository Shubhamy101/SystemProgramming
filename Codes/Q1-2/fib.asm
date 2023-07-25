section .data
    out_msg db "The nth Fibonacci number is: %d", 10, 0

section .bss
    fib resb 4

section .text
    global _start

_start:
    ; Programmer-defined constant for the value of n
    mov eax, 10  ; Change this value to find a different Fibonacci number

    ; Check if n is 0 or 1 (special cases)
    cmp eax, 0
    je .fibonacci_done
    cmp eax, 1
    je .fibonacci_done

    ; Initialize variables to hold the last two Fibonacci numbers
    mov ebx, 0  ; F(n-2)
    mov edx, 1  ; F(n-1)

    ; Loop to calculate the nth Fibonacci number
.fibonacci_loop:
    ; Calculate F(n) = F(n-1) + F(n-2)
    add edx, ebx

    ; Update variables for the next iteration
    mov ebx, edx  ; F(n-2) = F(n-1)
    mov edx, eax  ; F(n-1) = F(n)

    ; Decrement the counter
    dec eax

    ; Check if we have reached the first Fibonacci number (F(1))
    cmp eax, 1
    jge .fibonacci_loop

.fibonacci_done:
    ; The result (the nth Fibonacci number) is now in the edx register

    ; Display the result
    push edx
    push dword out_msg
    call printf
    add esp, 8  ; Clean up the stack after the function call

    ; Exit the program
    mov eax, 1  ; syscall for sys_exit
    xor ebx, ebx  ; exit code 0
    int 0x80  ; make syscall

; Function to print the result using printf from the C library
extern printf
