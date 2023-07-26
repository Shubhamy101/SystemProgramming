section .bss
    digitSpace resb 100
    digitSpacePos resb 8
 
section .text
    global _start
 
_start:
 
    mov rcx, 10     ;rcx have the value n

    mov rax, 0    
    jle output      ;print 0 if n is less than equal to 0

    mov rax, 1
    je output       ;print 1 if n is equal to 1

    sub rcx, 3      ;subtracting 3 since we are starting from fib(1) and fib(2)
    mov rax, 1      ;storing fib(1) in rax
    mov rbx, 1      ;storing fib(2) in r2x

;To calculate fib iteratively
fib:
    mov rdx, rax
    add rax, rbx
    mov rbx, rdx
    loop fib

;printing value in eax
output:
    and rax, rax
    call _printRAX
 
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
