section .bss
    digitSpace resb 100
    digitSpacePos resb 8
 
section .text
    global _start
 
_start:
 
    mov rax, 12345     ; Replace '12345' with the integer you want to convert to ASCII
    call _intToAscii    ; Convert the integer in rax to ASCII
 
    ; Your code to print the ASCII string goes here
    ; (For example, you can use 'write' syscall to print the ASCII string)
 
    mov rax, 60
    xor rdi, rdi
    syscall
 
_intToAscii:
    xor rcx, rcx       ; Clear rcx to use it as a counter for the digits
    mov rbx, 10        ; Base 10 to divide the number
 
_intToAsciiLoop:
    xor rdx, rdx       ; Clear rdx for division
    div rbx            ; Divide rax by 10, quotient in rax, remainder in rdx
    add dl, '0'        ; Convert the remainder to ASCII character
 
    ; Store the ASCII character in the digitSpace buffer in reverse order
    mov [digitSpace + rcx], dl
 
    inc rcx            ; Increment the counter
 
    test rax, rax      ; Check if quotient is zero (end of conversion)
    jnz _intToAsciiLoop
 
    ; Null-terminate the string
    mov byte [digitSpace + rcx], 0
 
    ; Calculate the length of the ASCII string (excluding null terminator)
    mov [digitSpacePos], rcx
 
    ; Reverse the ASCII string in place to get the correct order
    xor rsi, rsi       ; rsi points to the beginning of the string
_reverseLoop:
    mov rdi, rcx       ; rdi points to the end of the string
    dec rdi
    cmp rsi, rdi
    jge _reverseDone   ; If rsi >= rdi, the entire string is reversed
    mov al, [digitSpace + rsi]
    mov dl, [digitSpace + rdi]
    mov [digitSpace + rsi], dl
    mov [digitSpace + rdi], al
    inc rsi
    dec rdi
    jmp _reverseLoop
 
_reverseDone:
    ret
