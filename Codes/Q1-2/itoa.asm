section .bss
n resb 1

section .text
    global _start

_start:
    mov rax, 83
    sub rax, 48
    add rax, '0'
    mov [n], rax
    mov rcx, n
    mov rax, 4
    mov rbx, 1
    mov rdx, 1
    int 0x80
    
    mov rax, 1
    int 0x80
