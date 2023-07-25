section .data
    output_buffer db 11 ; Allocate 11 bytes for the output buffer (10 digits + null terminator)

section .bss
    num resd 1         ; Reserve 4 bytes (32 bits) to store the input integer

section .text
    global _start

_start:
    ; Get the input integer (you can replace 42 with any desired integer)
    mov eax, 42
    mov [num], eax

    ; Convert the integer to ASCII string
    mov ebx, output_buffer   ; Set ebx to point to the output buffer
    call int_to_ascii

    ; Print the ASCII string
    mov eax, 4               ; 'write' system call number
    mov ebx, 1               ; file descriptor (1 = STDOUT)
    mov ecx, output_buffer   ; pointer to the buffer
    mov edx, 11              ; number of bytes to write (including null terminator)
    int 0x80                 ; invoke the system call

    ; Exit the program
    mov eax, 1               ; 'exit' system call number
    xor ebx, ebx             ; exit code 0
    int 0x80                 ; invoke the system call

int_to_ascii:
    ; Convert the integer (in [num]) to ASCII string (output in [ebx])
    xor ecx, ecx             ; Clear ecx (used for digit count)

    check_zero:
        cmp dword [num], 0   ; Check if the number is zero
        jz end_conversion    ; If it's zero, end the conversion

        mov eax, 10          ; Divide by 10 (since we're working with 32-bit integers)
        div eax              ; Divide [num] by 10, quotient in eax, remainder in edx

        add dl, '0'          ; Convert remainder to ASCII character
        dec ebx              ; Move back one position in the buffer (starting from the end)
        mov [ebx], dl        ; Store the ASCII character in the buffer
        inc ecx              ; Increment digit count

        jmp check_zero      ; Repeat the loop to handle next digit

    end_conversion:
        test ecx, ecx       ; Check if the number was zero (no digits)
        jnz not_zero        ; If it's not zero, skip this part

        ; Special case for 0 (single-digit number)
        mov byte [ebx], '0' ; Store '0' in the buffer
        inc ecx             ; Increment digit count

    not_zero:
        mov byte [ebx+ecx], 0 ; Null-terminate the string
        ret
