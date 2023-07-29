intToAscii:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-4], edi
        mov     eax, DWORD PTR [rbp-4]
        add     eax, 48
        pop     rbp
        ret
.LC0:
        .string "The ASCII value is %d\n"
main:
        push    rbp
        mov     rbp, rsp
        mov     edi, 5
        call    intToAscii
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        pop     rbp
        ret
