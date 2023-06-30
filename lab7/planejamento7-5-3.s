.text
.global main

main:
    LDR r0, =0x3ff5000   @ Endereço de memória de IOPMOD
    LDR r3, =0x1FC00     @ Configura bits [16:10] como 1 (output)
    STR r3, [r0]        @ Escreve em IOPMOD para configurar os bits [16:10] como output
    
    LDR r0, =0x3FF5008   @ Endereço de memória de IOPDATA

    ADR r3, data         @ Endereço do byte de dados
    LDRB r1, [r3]        @ Carrega o valor a ser mostrado no display

    ADR r2, 7_segments_map  @ Endereço da tabela de valores para os displays

    LDRB r3, [r2, r1]    @ Carrega o valor do registrador correto para o número selecionado

    MOV r3, r3, LSL 10   @ Move o valor para os bits corretos do registrador
    STR r3, [r0]        @ Escreve o valor em IOPDATA para exibir no display

fim:
    SWI 0x123456        @ Chamada de sistema

data:
    .byte 10             @ Valor a ser exibido no display

@ Tabela de valores para cada um dos displays
@ Aqui não ficou claro no manual quais valores precisamos para habilitar cada segmento
@ Deixei em branco, pois provavelmente será incrementado em aula
7_segments_map:
    .byte                @ Valores dos registradores para cada número
