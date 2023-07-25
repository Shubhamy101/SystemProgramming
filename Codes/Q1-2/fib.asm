section .data
    out_msg db "The nth Fibonacci number is: ", 0
    nl db 10

section .bss
    fib resd 1

section .text
    global _start

_start:
    ; Programmer-defined constant for the value of n
    mov eax, 10  ; Change this value to find a different Fibonacci number

    ; Initialize variables to hold the last two Fibonacci numbers
    mov ebx, 0  ; F(n-2)
    mov ecx, 1  ; F(n-1)

    ; Check if n is 0 or 1 (special cases)
    cmp eax, 0
    je .fibonacci_done
    cmp eax, 1
    je .fibonacci_done

    ; Loop to calculate the nth Fibonacci number
.fibonacci_loop:
    ; Calculate F(n) = F(n-1) + F(n-2)
    add ebx, ecx

    ; Update variables for the next iteration
    mov ecx, ebx  ; F(n-1) = F(n)
    mov ebx, eax  ; F(n-2) = n

    ; Decrement the counter
    dec eax

    ; Check if we have reached the second Fibonacci number (F(1))
    cmp eax, 1
    jge .fibonacci_loop

.fibonacci_done:
    ; The result (the nth Fibonacci number) is now in the ecx register

    ; Display the output message
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, out_msg  ; pointer to the output message
    mov edx, 30       ; message length (adjust as needed)
    int 0x80          ; make syscall

    ; Convert the result (F(n)) to a string
    mov eax, ecx      ; Copy the Fibonacci number to EAX (result in ECX)
    mov edi, 10       ; Divisor (10)
    xor esi, esi      ; Counter for the number of digits in the Fibonacci number
    mov edx, 0        ; Clear EDX for the division operation

.convert_to_string:
    xor edx, edx      ; Clear EDX before the division
    div edi           ; Divide EAX by 10, quotient in EAX, remainder in EDX
    push edx          ; Store the remainder (digit) on the stack
    inc esi           ; Increment the digit counter
    test eax, eax     ; Check if EAX is zero (F(n) has been completely converted)
    jnz .convert_to_string

    ; Display the Fibonacci number digit by digit
.display_loop:
    pop edx           ; Pop the next digit from the stack
    add dl, '0'       ; Convert the digit to ASCII character
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, edx      ; pointer to the digit character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Continue displaying the digits until all are printed
    dec esi
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
