.text
.global main

main:
    LDR	r0, =0x3ff5000 	@ Endereço de IOPMOD
    LDR	r2, =0xf0	@ Configura 1 nos bits [7:4] e 0 nos bits [3:0]
    STR	r2, [r0]	@ Configura IOPMOD[7:4] como saída e IOPMOD[3:0] como entrada
    
    LDR r0, =0x3FF5008 @ Endereço de IOPDATA
    MOV r1, #0 @ Registrador para armazenar o valor de IOPDATA

loop:
    LDR r1, [r0] @ Lê o valor de IOPDATA
    AND r1, r1, #0x0F @ Obtém os valores dos switches (mantendo apenas os bits [3:0])

    BL display_hex_led @ Chama a função display_hex_led
    B loop @ Volta para o início do loop

@ display_hex_led(r0, r1)
@   r0: Endereço de IOPDATA
@   r1: Valor a ser exibido
display_hex_led:
    STMFD sp!, {r2} @ Armazena os registradores na pilha

    MOV r2, r1, LSL #4 @ Coloca o valor nos bits [7:4]
    STR r2, [r0] @ Escreve o valor em IOPDATA

    LDMFD sp!, {r2} @ Recupera os registradores da pilha
    MOV pc, lr @ Retorna da função
