@ Este programa calcula uma sequência de fibonacci e guarda seus termos em um array.
@ A sequencia vai até o indice correspondente aos últimos 2 dígitos do meu nusp
@ Meu nusp é 11288405, os dois últimos dígitos são 05, somando 10, temos 15 que será o último indice da sequencia

.text
.global main

main:
    MOV r0, #15        @ nusp
    MOV r2, #0         @ índice do array
    MOV r7, #0x400     @ tamanho do array
    LDR r6, =array     @ endereço do array
    MOV r4, #0         @ guarda o valor de f(x-2)
    MOV r5, #1         @ guarda o valor de f(x-1)
 
pronto:
    CMP r2, r0
    STR r4, [r6, r2, LSL #2] @ salvar o valor de f(x-2) no array
	BGE fim

    ADD r6, r6, #4           @ atualizar o endereço do array
    ADD r1, r5, r4           @ calcular o valor atual da sequência
    MOV r4, r5
    MOV r5, r1
    ADD r2, r2, #1           @ incrementar o índice do array
    B pronto

fim:
	ADR r8, ultimo         @ passando o endereço do ultimo para r8 (temporário)
	STR r4,[r8]            @ guarda o valor de r4 (ultimo numero da sequencia) no endereço "último"
    SWI 0x123456           @ sair do programa

array:
    .space 400            @ alocar espaço para o array
ultimo:
	.word 0
