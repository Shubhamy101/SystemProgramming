section .data
    output_format db "%s", 0     ; Format string for printing the result

section .bss
    num resq 1                   ; Variable to store the input number
    buffer resb 11               ; Buffer to store the ASCII representation (up to 10 digits + null terminator)

section .text
    global _start

_start:
    ; Read the integer from the command-line argument
    mov edi, 1                   ; File descriptor 1 points to stdout (standard output)
    mov esi, rdx                 ; rdx register contains the pointer to the arguments array
    mov edx, 10                  ; Read up to 10 bytes (we assume the number won't exceed 10 digits)
    call read_int

    ; Convert the integer to ASCII
    mov edi, buffer              ; Destination buffer for the ASCII string
    call int_to_ascii

    ; Print the result
    mov esi, edi                 ; rsi holds the pointer to the ASCII string
    call print_string

    ; Exit the program
    mov eax, 60                  ; syscall number for exit
    xor edi, edi                 ; Exit code 0
    syscall

; Function to convert an integer to an ASCII string
; Input:
;   rdi: Destination buffer for the ASCII string
;   rsi: Input integer
int_to_ascii:
    mov ecx, 10                 ; Set divisor (base 10)
    mov eax, esi                ; Copy the integer to rax
    mov ebx, edi                ; Copy the buffer address to rbx

    add ebx, 10                 ; Move the buffer pointer to the end (for null terminator)

    mov byte [ebx], 0           ; Null-terminate the string

int_to_ascii_loop:
    dec ebx                     ; Move the buffer pointer back
    xor edx, edx                ; Clear rdx for division
    div ecx                     ; Divide rax by 10, quotient in rax, remainder in rdx
    add dl, '0'                 ; Convert the remainder to ASCII
    mov [ebx], dl               ; Store the ASCII character in the buffer

    test eax, eax               ; Check if quotient is zero
    jnz int_to_ascii_loop       ; If not, continue the loop

    mov edi, ebx                ; Set rdi to point to the beginning of the ASCII string
    ret

; Function to print a null-terminated string
; Input:
;   rdi: Pointer to the null-terminated string to be printed
print_string:
    mov eax, 0x1               ; syscall number for write
    mov edx, 0xFFFFFFFF        ; Set the maximum number of bytes to write (large enough)
    xor esi, esi               ; rsi = 0, as we start writing from the beginning of the string
    syscall
    ret
