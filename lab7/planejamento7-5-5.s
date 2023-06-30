.text
.global main

main:
    LDR r0, =0x3ff5000     @ Endereço de memória de IOPMOD
    LDR r2, =0xf0          @ Configura bits [7:4] como 1 (output) e bits [3:0] como 0 (input)
    STR r2, [r0]           @ Escreve em IOPMOD para configurar os bits [7:4] como output e bits [3:0] como input
    
    LDR r0, =0x3FF5008     @ Endereço de memória de IOPDATA
    MOV r1, #0             @ Registrador para armazenar o valor de IOPDATA
    
loop:
    LDR r1, [r0]           @ Carrega o valor de IOPDATA para r1
    MOV r1, r1, LSL #4     @ Move o valor para os bits [7:4]
    STR r1, [r0]           @ Escreve o valor de volta em IOPDATA para exibir no display
    
    B loop                 @ Salto para loop, repetindo o processo indefinidamente
