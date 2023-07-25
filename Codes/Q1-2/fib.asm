section .data
    out_msg db "The nth Fibonacci number is: ", 0
    out_msg_len equ $ - out_msg

    nl db 10  ; Define the newline character

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

    ; Display the output message
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, out_msg  ; pointer to the output message
    mov edx, out_msg_len
    int 0x80          ; make syscall

    ; Loop to calculate the nth Fibonacci number
.fibonacci_loop:
    ; Calculate F(n) = F(n-1) + F(n-2)
    add ecx, ebx

    ; Update variables for the next iteration
    xchg ecx, ebx  ; F(n-2) = F(n-1), F(n-1) = F(n)

    ; Decrement the counter
    dec eax

    ; Display the current Fibonacci number
    push eax
    call display_number  ; Call the display_number function to print the Fibonacci number
    pop eax

    ; Check if we have reached the last Fibonacci number (F(n))
    jnz .fibonacci_loop

.fibonacci_done:
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

display_number:
    ; Clear the buffer before storing the ASCII representation of the number
    mov edi, fib      ; Set EDI to point to the buffer (fib)
    xor eax, eax      ; Clear EAX (used as a flag to indicate leading zeros)
    mov ecx, 10       ; Set ECX to 10 (number of digits to display)
.clear_buffer_loop:
    mov byte [edi], '0'  ; Clear the byte at each position in the buffer
    inc edi
    loop .clear_buffer_loop

    ; Convert the result (F(n)) to a string and store it in the buffer (fib)
    mov eax, ecx     ; Restore ECX (used as a loop counter)
    mov esi, 10      ; Set ESI to 10 (used as a divisor)
.convert_to_string:
    xor edx, edx     ; Clear EDX before the division
    div esi          ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'      ; Convert the digit to ASCII character
    dec edi          ; Move to the previous position in the buffer
    mov byte [edi], dl  ; Store the ASCII digit in the fib buffer
    test eax, eax    ; Check if EAX is zero (F(n) has been completely converted)
    jnz .convert_to_string

    ; Display the Fibonacci number digit by digit
.display_loop:
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, edi      ; pointer to the digit character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Move to the previous position in the buffer
    inc edi
    cmp byte [edi], '0'  ; Check if the byte in the buffer is not '0'
    jnz .display_loop

    ; Return from the display_number function
    ret

section .bss
    fib resb 10  ; Buffer to store the ASCII representation of the Fibonacci number
