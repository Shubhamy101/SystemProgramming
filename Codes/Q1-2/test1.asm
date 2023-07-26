section .bss
    digitSpace resb 100
    digitSpacePos resb 8

section .data
    text db "Hello, World!", 10, 0

section .text
    global _start

_start:

    ; Calculate the 10th Fibonacci number (n = 10)
    mov rax, 10
    mov rsi, 1
    mov rdi, 1

fib_loop:
    add rsi, rdi
    xchg rsi, rdi
    loop fib_loop

    ; Store the 10th Fibonacci number in rax
    ; It can be accessed as needed.

    ; Print the 10th Fibonacci number
    mov rax, rsi
    call _printRAX

    ; Exit the program
    mov rax, 60
    mov rdi, 0
    syscall


_printRAX:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48

    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx

    pop rax
    cmp rax, 0
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos]

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    cmp rcx, digitSpace
    jge _printRAXLoop2

    ret
