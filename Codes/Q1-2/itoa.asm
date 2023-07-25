section .bss
    num resb 10         ; Buffer to store ASCII representation of the number
    len equ $ - num     ; Length of the buffer (10 bytes)

section .text
    global _start

_start:
    ; Read an integer from the user (assuming a 64-bit Linux system)
    mov eax, 0          ; System call number for sys_read (0)
    mov edi, 0          ; File descriptor 0 (stdin)
    lea esi, [num]      ; Buffer to store the input
    mov edx, len        ; Maximum number of bytes to read
    syscall

    ; Convert the ASCII input to an integer (using atoi function)
    call ascii_to_int

    ; Convert the integer to an ASCII string
    call int_to_ascii

    ; Print the ASCII string (assuming a 64-bit Linux system)
    mov eax, 4          ; System call number for sys_write (4)
    mov edi, 1          ; File descriptor 1 (stdout)
    lea esi, [num]      ; Buffer containing the ASCII string
    mov edx, dword [len] ; Length of the ASCII string (using 32-bit size)
    syscall

    ; Exit the program
    mov eax, 1          ; System call number for sys_exit (1)
    xor edi, edi        ; Exit code 0
    syscall

; Function to convert ASCII input to an integer (atoi)
ascii_to_int:
    xor eax, eax        ; Clear eax to store the result
    xor ecx, ecx        ; Clear ecx (loop counter)
.loop:
    movzx edx, byte [esi + ecx] ; Load the next ASCII character
    test edx, edx       ; Check for the null terminator (end of the string)
    jz .done            ; If null terminator found, exit the loop
    sub edx, '0'        ; Convert ASCII character to integer (digit)
    imul eax, eax, 10   ; Multiply the current result by 10
    add eax, edx        ; Add the new digit to the result
    inc ecx             ; Move to the next character
    jmp .loop           ; Repeat the loop
.done:
    ret

; Function to convert an integer to an ASCII string
int_to_ascii:
    add esi, dword [len] ; Point esi to the end of the buffer
    mov byte [esi], 0   ; Null-terminate the string
.reverseLoop:
    dec esi             ; Move back through the buffer
    mov ebx, 10         ; Divisor (to convert to ASCII digits)
    xor ecx, ecx        ; Clear ecx (loop counter)
.nextDigit:
    xor edx, edx        ; Clear edx to get the remainder
    div ebx             ; Divide eax by 10, result in eax, remainder in edx
    add dl, '0'         ; Convert the remainder to ASCII
    mov [esi], dl       ; Store the ASCII digit in the buffer
    inc ecx             ; Move to the next position in the buffer
    test eax, eax       ; Check if quotient is zero (end of conversion)
    jnz .nextDigit      ; If not zero, continue the loop
    mov dword [len], ecx ; Store the length of the ASCII string
    ret
