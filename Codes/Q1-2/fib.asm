section .data
    out_msg db "The nth Fibonacci number is: ", 0
    out_msg_len equ $ - out_msg

    nl db 10  ; Define the newline character

section .bss
    fib resb 16  ; Buffer to store the ASCII representation of the Fibonacci number

section .text
    global _start

_start:
    ; Programmer-defined constant for the value of n
    mov eax, 10  ; Change this value to find the nth Fibonacci number

    ; Check if n is 0 or 1 (special cases)
    cmp eax, 0
    je .fibonacci_done
    cmp eax, 1
    je .fibonacci_done

    ; Initialize variables to hold the last two Fibonacci numbers
    mov ebx, 0  ; F(n-2)
    mov ecx, 1  ; F(n-1)

    ; Loop to calculate the nth Fibonacci number
.fibonacci_loop:
    ; Calculate F(n) = F(n-1) + F(n-2)
    add ecx, ebx

    ; Update variables for the next iteration
    xchg ecx, ebx  ; F(n-2) = F(n-1), F(n-1) = F(n)

    ; Decrement the counter
    dec eax

    ; Check if we have reached the last Fibonacci number (F(n))
    jnz .fibonacci_loop

.fibonacci_done:
    ; The result (the nth Fibonacci number) is now in the ecx register

    ; Clear the fib buffer before storing the ASCII representation of the number
    xor edi, edi     ; Clear EDI (used for buffer index)
    mov byte [fib + edi], '0'  ; Initialize the buffer with '0' (in case it's a single-digit number)
    mov esi, ecx     ; Copy the Fibonacci number to ESI

    ; Convert the result (F(n)) to a string
.convert_to_string:
    mov eax, esi     ; Restore the Fibonacci number from ESI
    xor edx, edx     ; Clear EDX before the division
    mov ebx, 10      ; Divisor (10)
    div ebx          ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'      ; Convert the digit to ASCII character
    inc edi          ; Move to the next position in the buffer
    mov byte [fib + edi], dl  ; Store the ASCII digit in the fib buffer
    test eax, eax    ; Check if EAX is zero (F(n) has been completely converted)
    jnz .convert_to_string

    ; Display the output message
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, out_msg  ; pointer to the output message
    mov edx, out_msg_len
    int 0x80          ; make syscall

    ; Move EDI to the end of the buffer (pointing to the last digit)
    lea edi, [fib + edi]

    ; Display the Fibonacci number digit by digit
.display_loop:
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, edi      ; pointer to the digit character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Move to the previous position in the buffer
    dec edi
    cmp edi, fib
    jge .display_loop

    ; Display a newline character
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, nl       ; pointer to the newline character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Exit the program
    mov eax, 1        ; syscall for sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80          ; make syscall
