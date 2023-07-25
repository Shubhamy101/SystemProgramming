section .data
    num1 dq 10         ; First number (change this to any desired value)
    num2 dq 20         ; Second number (change this to any desired value)
    fmt_result db "Sum: %d", 10, 0

section .text
    global _start

_start:
    ; Calculate the sum
    mov rax, qword [num1]
    add rax, qword [num2]

    ; Print the sum
    mov rdi, fmt_result
    mov rsi, rax        ; The sum is stored in rax
    call printf wrt ..plt

    ; Exit the program
    mov rax, 60         ; System call number for sys_exit (60)
    xor rdi, rdi        ; Exit code 0
    syscall
