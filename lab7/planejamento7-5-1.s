.text
.global main

main:
    LDR r0, =0x3ff5000 	    @ Endereço de memória de IOPMOD
    LDR r2, =0xf0	        @ Configura bits [7:4] para 1 (output)
    STR r2, [r0]	        @ Escreve em IOPMOD para configurar os bits [7:4] como output

    LDR r0, =0x3FF5008	    @ Endereço de memória de IOPDATA
    MOV r1, #0	            @ Inicializa contador como 0

loop:
    BL display_value	    @ Chama a função display_value
    BL ascending_order	    @ Chama a função ascending_order
    BL delay		        @ Chama a função delay
    B loop		            @ Salto para loop

display_value:
    STMFD sp!, {r2}	        @ Armazena os registradores na pilha

    MOV r2, r1, LSL #4	    @ Move o valor do contador para os bits [7:4]
    STR r2, [r0]	        @ Escreve em IOPDATA para exibir o valor

    LDMFD sp!, {r2}	        @ Recupera os registradores da pilha
    MOV pc, lr		        @ Retorna para a instrução após a chamada da função

ascending_order:
    ADD r1, r1, #1	        @ Incrementa o contador em 1
    CMP r1, #0xF	        @ Compara o contador com 15 (0xF)
    MOVGT r1, #0	        @ Define o contador como 0 se for maior que 15
    MOV pc, lr		        @ Retorna para a instrução após a chamada da função

descending_order:
    SUBS r1, r1, #1	        @ Decrementa o contador em 1
    MOVMI r1, #0xF	        @ Define o contador como 15 se for negativo
    MOV pc, lr		        @ Retorna para a instrução após a chamada da função

delay:
    STMFD sp!, {r2}	        @ Armazena os registradores na pilha

    LDR r2, =0xfffff	    @ Valor de atraso
    delay_loop:
        SUBS r2, r2, #1	    @ Decrementa o contador de atraso
        BPL delay_loop	    @ Salto se o resultado ainda for positivo (não negativo)

    LDMFD sp!, {r2}	        @ Recupera os registradores da pilha
    MOV pc, lr		        @ Retorna para a instrução após a chamada da função
