    .data
    n:       .word 10    @ Defina o valor de N

    .text
    .global main

main:
    @ Carregue o valor de N em R1
    ldr r1, =n
    ldr r1, [r1]

    @ Alocar memória para armazenar os números primos
    mov r7, #45         @ Chamar a chamada de sistema brk
    mov r0, #0          @ Argumento 0 para brk (solicitar aumento de heap)
    swi 0               @ Executa a chamada de sistema

    @ R0 agora contém o endereço de início da memória alocada

    @ Inicialize o contador de números primos em R2
    mov r2, #0

    @ Inicialize o número atual em R3
    mov r3, #2

loop:
    @ Verifique se R2 atingiu o valor de N
    cmp r2, r1
    beq end

    @ Verifique se o número atual (R3) é primo
    mov r4, #2    @ Inicialize o divisor como 2
    mov r5, #1    @ Defina a flag de número primo como 1

check_prime:
    @ Verifique se o número atual é divisível por qualquer divisor
    cmp r4, r3
    bge prime

    mov r6, r3    @ Faça uma cópia do número atual em R6
    sdiv r6, r6, r4    @ Divida o número atual pelo divisor

    cmp r6, #0    @ Verifique se a divisão deu resto 0
    beq not_prime    @ Se o resto for 0, não é primo

    add r4, r4, #1    @ Incremente o divisor em 1
    b check_prime

prime:
    @ O número atual é primo
    add r2, r2, #1    @ Incremente o contador de números primos em 1

    @ Armazene o número primo na memória alocada
    str r3, [r0], #4  @ Armazene o número em R3 e incremente o endereço

not_prime:
    @ Incremente o número atual em 1
    add r3, r3, #1

    b loop

end:
    mov r7, #1    @ Chamada de sistema de saída (exit)
    mov r0, #0    @ Código de saída 0
    swi 0         @ Executa a chamada de sistema
