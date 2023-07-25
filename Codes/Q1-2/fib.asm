section .data
    out_msg db "The nth Fibonacci number is: ", 0
    nl db 10

section .bss
    fib resd 1

section .text
    global _start

_start:
    ; Programmer-defined constant for the value of n
    mov ecx, 10  ; Change this value to find the nth Fibonacci number

    ; Check if n is 0 or 1 (special cases)
    cmp ecx, 0
    je .fibonacci_done
    cmp ecx, 1
    je .fibonacci_done

    ; Initialize variables to hold the last two Fibonacci numbers
    mov eax, 0  ; F(n-2)
    mov ebx, 1  ; F(n-1)

    ; Loop to calculate the nth Fibonacci number
.fibonacci_loop:
    ; Calculate F(n) = F(n-1) + F(n-2)
    add eax, ebx

    ; Update variables for the next iteration
    xchg eax, ebx  ; F(n-2) = F(n-1), F(n-1) = F(n)

    ; Decrement the counter
    dec ecx

    ; Check if we have reached the second Fibonacci number (F(1))
    jnz .fibonacci_loop

.fibonacci_done:
    ; The result (the nth Fibonacci number) is now in the eax register

    ; Display the output message
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, out_msg  ; pointer to the output message
    mov edx, out_msg_len
    int 0x80          ; make syscall

    ; Convert the result (F(n)) to a string
    mov edi, 10       ; Divisor (10)
    mov esi, fib      ; Pointer to the buffer to store the ASCII representation of the number
    mov ebx, 0        ; Clear EBX to calculate the number of digits

.convert_to_string:
    xor edx, edx      ; Clear EDX before the division
    div edi           ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'       ; Convert the digit to ASCII character
    mov [esi], dl     ; Store the ASCII digit in the fib buffer
    inc esi           ; Move to the next position in the buffer
    inc ebx           ; Increment the digit counter
    test eax, eax     ; Check if EAX is zero (F(n) has been completely converted)
    jnz .convert_to_string

    ; Display the Fibonacci number digit by digit
.display_loop:
    dec esi           ; Move the buffer pointer back to the last digit
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, esi      ; pointer to the digit character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Continue displaying the digits until all are printed
    test esi, esi
    jnz .display_loop

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
