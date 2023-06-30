.text
.global main

main:
    LDR r1, =a 	@ endereco de a
    LDR r2, =b 	@ b
    LDR r3, =c 	@ c
    LDR r4, =d 	@ d
    
    LDR r5, [r2]   @ r5 = b
    LDR r6, [r3]   @ r6 = c
    LDR r7, [r4]   @ r7 = d
    
    BL func1
    
    B end
    
func1:
    MUL r0, r5, r6   @ a = b*c
    ADD r0, r0, r7   @ a = b*c + d
    STR r0, [r1] 	@ salvamos o valor de a (r0) no endereco de a (r1)
    MOV pc, lr
end:
    SWI 0x123456
    
.data
a: .space 4
b: .word 5
c: .word 3
d: .word 2
