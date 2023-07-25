section	.text
   global _start        ;must be declared for using gcc

_start:
    ; Set n to the desired value (e.g., n = 10)
    mov  ebx,10

    ; Check for base cases (n = 0 and n = 1)
    cmp ebx, 0
    je fibonacci_done
    cmp ebx, 1
    je fibonacci_done
    jmp start_iteration

start_iteration:
    ; Initialize the first two Fibonacci numbers (F0 = 0, F1 = 1)
    mov dword [sum], 0   ; F0
    mov eax, 1                  ; F1

    ; Loop to calculate the Fibonacci number iteratively
    mov ecx, ebx        ; ECX will act as a loop counter
    dec ecx             ; We already have F0 and F1 calculated, so we need to calculate (n - 1) iterations

fibonacci_loop:
    add eax, dword [sun] ; Calculate the next Fibonacci number (F2 = F0 + F1)
    xchg eax, dword [sum] ; Store the new Fibonacci number and move the previous one to EAX

    loop fibonacci_loop ; Decrement ECX and loop until ECX becomes zero

fibonacci_done:
    ; At this point, the nth Fibonacci number will be stored in EAX

    ; Add your code here to use/display the result as needed.
    ; For example, you can print the Fibonacci number using syscalls for Linux.
	
   mov 	[sum], eax
   mov	ecx,msg	
   mov	edx, len
   mov	ebx,1	         ;file descriptor (stdout)
   mov	eax,4	         ;system call number (sys_write)
   int	0x80	         ;call kernel
	
   mov	ecx,sum
   mov	edx, 1
   mov	ebx,1	         ;file descriptor (stdout)
   mov	eax,4	         ;system call number (sys_write)
   int	0x80	         ;call kernel
	
   mov	eax,1	         ;system call number (sys_exit)
   int	0x80	         ;call kernel
	
section .data
msg db "The nth fibonacci number is:", 0xA,0xD 
len equ $ - msg   
segment .bss

sum resb 4
