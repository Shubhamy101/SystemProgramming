secion .bss
	digitSpace resb 100
	digitSpacePos resb 8

section .text
	global _start

_start:
	mov ecx, 10
	mov esi, 1
	mov edi, 1

	cmp ecx, 0
	jle output_fib

	cmp ecx, 1
	je output_fib

fib_loop:
	add esi, edi
	xchg esi, edi
	loop fib_loop

outpub_fib:
	mov eax, esi
	call _printEAX
	mov eax, 60
	mov edi, 0
	syscall

_printEAX:
	mov ecx, digitSpace
	mov ebx, 10
	mov [ecx], ebx
	inc ecx
	mov [digitSpacePos], ecx

_printEAXLoop:
	mov edx, 0
	mov ebx, 10
	div ebx
	push eax
	add edx, 48
