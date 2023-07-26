section .bss
	digitSpace resb 100
	digitSpacePos resb 8

section .text
	global _start

_start:
	mov rcx, 10
	mov rsi, 1
	mov rdi, 1

	cmp rcx, 0
	jle output_fib

	cmp rcx, 1
	je output_fib

fib_loop:
	add rsi, rdi
	xchg rsi, rdi
	loop fib_loop

output_fib:
	mov rax, rsi
	call _printEAX
	mov rax, 60
	mov rdi, 0
	syscall

_printEAX:
	mov rcx, digitSpace
	mov rbx, 10
	mov [rcx], rbx
	inc rcx
	mov [digitSpacePos], rcx

_printEAXLoop:
	mov rdx, 0
	mov rbx, 10
	div rbx
	push rax
	add rdx, 48

	mov rcx, [digitSpacePos]
	mov [ecx], dl
	inc rcx
	mov [digitSpace], rcx

	pop rax
	cmp rax, 0
	jne _printEAXLoop

_printEAXLoop2:
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
	jge _printEAXLoop2

	ret
