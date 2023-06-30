    .text
    .global main

main:
    @ Carregue os números de baixa ordem em R0 e R1
    ldr r0, =low_a
    ldr r0, [r0]
    ldr r1, =low_b
    ldr r1, [r1]

    @ Carregue os números de alta ordem em R2 e R3
    ldr r2, =high_a
    ldr r2, [r2]
    ldr r3, =high_b
    ldr r3, [r3]

    @ Some os números de baixa ordem
    add r4, r0, r1

    @ Some os números de alta ordem e o carry
    adc r5, r2, r3

    @ Exiba o resultado
    mov r0, r4
    mov r1, r5
    bl printf

    mov r7, #1    @ Chamada de sistema de saída (exit)
    mov r0, #0    @ Código de saída 0
    swi 0         @ Executa a chamada de sistema

.section .data
low_a:    .word 0x12345678
high_a:   .word 0xabcdefab
low_b:    .word 0x87654321
high_b:   .word 0xfedcbafe
format:   .asciz "%016llx%016llx\n"
