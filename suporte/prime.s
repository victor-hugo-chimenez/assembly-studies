    .text
    .global main

main:
    @ Armazene o número a ser verificado em R0
    mov r0, #17

    @ Verifique se o número é menor ou igual a 1
    cmp r0, #1
    ble not_prime

    @ Verifique se o número é 2 (o único número primo par)
    cmp r0, #2
    beq prime

    @ Verifique se o número é divisível por 2
    mov r1, #2       @ Inicialize o divisor como 2
loop:
    mov r2, r0       @ Faça uma cópia do número em R2
    sdiv r2, r2, r1  @ Divida o número pelo divisor

    cmp r2, #0      @ Verifique se a divisão deu resto 0
    beq not_prime   @ Se o resto for 0, não é primo

    add r1, r1, #1   @ Incremente o divisor em 1
    cmp r1, r0      @ Verifique se o divisor ultrapassou o número
    ble loop        @ Se não, continue o loop

prime:
    @ O número é primo
    mov r0, #1
    b end

not_prime:
    @ O número não é primo
    mov r0, #0

end:
    mov r7, #1       @ Chamada de sistema de saída (exit)
    mov r1, r0       @ Passe o resultado como código de saída
    swi 0            @ Executa a chamada de sistema
