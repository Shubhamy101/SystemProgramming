section .bss
    n resd 1         ; Buffer to store the input value n
    result resb 12   ; Buffer to store the result (max 12 bytes for 32-bit integer)

section .text
    global _start

_start:
    ; Read the input value n
    mov eax, 3       ; syscall for sys_read
    mov ebx, 0       ; file descriptor 0 (stdin)
    mov ecx, n       ; pointer to the buffer to store n
    mov edx, 4       ; number of bytes to read (4 bytes for int)
    int 0x80         ; make syscall

    ; Convert the input value from ASCII to integer (atoi)
    mov ebx, [n]     ; pointer to the input value n
    call atoi

    ; Calculate the nth Fibonacci number
    mov eax, ebx     ; Move n to EAX for calculation
    call fibonacci

    ; Convert the result to ASCII and store it in the result buffer
    mov eax, ebx     ; Copy the result to EAX
    mov edi, result  ; Pointer to the buffer to store the result
    call itoa

    ; Display the output message
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, result   ; pointer to the output message
    call strlen       ; Get the length of the result
    mov edx, eax      ; Length of the result
    int 0x80          ; make syscall

    ; Display a newline character
    mov eax, 4        ; syscall for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, newline  ; pointer to the newline character
    mov edx, 1        ; number of bytes to write (1 character)
    int 0x80          ; make syscall

    ; Exit the program
    mov eax, 1        ; syscall for sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80          ; make syscall

fibonacci:
    ; Calculate the nth Fibonacci number iteratively
    ; Input: n (in EAX)
    ; Output: nth Fibonacci number (in EAX)

    ; Check if n is 0 or 1 (special cases)
    cmp eax, 0
    je .fibonacci_done
    cmp eax, 1
    je .fibonacci_done

    ; Initialize variables to hold the last two Fibonacci numbers
    xor ebx, ebx  ; F(n-2)
    mov ecx, 1    ; F(n-1)

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
    mov eax, ecx
    ret

itoa:
    ; Convert an integer to ASCII representation
    ; Input: Integer to convert (in EAX)
    ; Output: ASCII representation (null-terminated string) in EDI

    mov edi, result ; Pointer to the buffer (output)
    mov ecx, 10     ; Base 10 for division
    add edi, 11     ; Move the pointer to the end of the buffer (12 bytes max for 32-bit integer)

.reverse_loop:
    xor edx, edx   ; Clear the remainder
    div ecx        ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'    ; Convert the digit to ASCII
    dec edi        ; Move pointer back to the previous position
    mov [edi], dl  ; Store the ASCII digit

    test eax, eax  ; Check if the quotient is zero
    jnz .reverse_loop

    ; Null-terminate the string
    inc edi
    mov byte [edi], 0

    ret

atoi:
    ; Convert an ASCII string to an integer
    ; Input: Pointer to the ASCII string (in EBX)
    ; Output: Integer value (in EAX)

    xor eax, eax   ; Clear the result (accumulator)
    xor ecx, ecx   ; Clear the digit counter

.convert_loop:
    movzx edx, byte [ebx + ecx]   ; Load the next ASCII character
    test dl, dl                   ; Check if it's null-terminated
    jz .convert_done

    sub edx, '0'   ; Convert ASCII character to a digit
    imul eax, eax, 10   ; Multiply the result by 10
    add eax, edx       ; Add the digit to the result
    inc ecx            ; Move to the next character
    jmp .convert_loop

.convert_done:
    ret

strlen:
    ; Calculate the length of a null-terminated string
    ; Input: Pointer to the string (in ECX)
    ; Output: Length of the string (in EAX)

    xor eax, eax     ; Clear the length counter

.length_loop:
    cmp byte [ecx], 0 ; Check for null-termination
    je .length_done
    inc eax           ; Increment the length counter
    inc ecx           ; Move to the next character
    jmp .length_loop

.length_done:
    ret

section .data
    newline db 10    ; Define the newline character
