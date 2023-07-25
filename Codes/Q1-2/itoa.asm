section .bss
    num resb 10         ; Buffer to store ASCII representation of the number
    len equ $ - num     ; Length of the buffer (10 bytes)

section .text
    global _start

_start:
    ; Read an integer from the user (assuming a 64-bit Linux system)
    mov rdi, 0          ; File descriptor 0 (stdin)
    lea rsi, [num]      ; Buffer to store the input
    mov rdx, len        ; Maximum number of bytes to read
    mov rax, 0          ; System call number for sys_read (0)
    syscall

    ; Convert the ASCII input to an integer (using atoi function)
    call ascii_to_int

    ; Convert the integer to an ASCII string
    call int_to_ascii

    ; Print the ASCII string (assuming a 64-bit Linux system)
    mov rdi, 1          ; File descriptor 1 (stdout)
    lea rsi, [num]      ; Buffer containing the ASCII string
    mov rdx, r8         ; Length of the ASCII string
    mov rax, 1          ; System call number for sys_write (1)
    syscall

    ; Exit the program
    mov rax, 60         ; System call number for sys_exit (60)
    xor rdi, rdi        ; Exit code 0
    syscall

; Function to convert ASCII input to an integer (atoi)
ascii_to_int:
    xor rax, rax        ; Clear rax to store the result
    xor rcx, rcx        ; Clear rcx (loop counter)
.loop:
    movzx r8b, byte [rsi + rcx] ; Load the next ASCII character
    test r8b, r8b       ; Check for the null terminator (end of the string)
    jz .done            ; If null terminator found, exit the loop
    sub r8b, '0'        ; Convert ASCII character to integer (digit)
    imul rax, rax, 10   ; Multiply the current result by 10
    add rax, r8         ; Add the new digit to the result
    inc rcx             ; Move to the next character
    jmp .loop           ; Repeat the loop
.done:
    ret

; Function to convert an integer to an ASCII string
int_to_ascii:
    add rdx, rsi        ; Point rdx to the end of the buffer
    mov byte [rdx], 0   ; Null-terminate the string
.reverseLoop:
    dec rdx             ; Move back through the buffer
    mov rbx, 10         ; Divisor (to convert to ASCII digits)
    xor rcx, rcx        ; Clear rcx (loop counter)
.nextDigit:
    xor rdx, rdx        ; Clear rdx to get the remainder
    div rbx             ; Divide rax by 10, result in rax, remainder in rdx
    add dl, '0'         ; Convert the remainder to ASCII
    mov [rdx], dl       ; Store the ASCII digit in the buffer
    inc rcx             ; Move to the next position in the buffer
    test rax, rax       ; Check if quotient is zero (end of conversion)
    jnz .nextDigit      ; If not zero, continue the loop
    mov r8, rcx         ; Store the length of the ASCII string in r8
    ret
