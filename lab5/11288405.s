.text
.global main

main:
	@ input randômico (X)
	LDR r1, =0b1010101010101011010101010101010
	MOV r2, #0 @ output (Z)
	MOV r3, #0 @ contador de shifts
	LDR r4, =0b101 @ padrão que vai ser reconhecido
	MOV r5, #3 @ tamanho do padrão

	RSB r6, r5, #32 @ calcular o número de bits que precisam ser deslocados para a direita para comparar a sequência na entrada.

	BL finite_state_machine
	SWI 0x0

finite_state_machine:
	CMP r3, r6 @ se o contador for maior que o máximo de deslocamentos, retorna para main
	MOVGT pc, lr @ retorna para main

	MOV r7, r1, LSL r3 @ movemos o valor de r1 para esquerda “r3 vezes” e guardamos em r7
	MOV r7, r7, LSR r6 @ movemos r7 para direita “r6 vezes”, o resultado disso é a sequência que queremos detectar

	CMP r7, r4 @ comparação da sequência

	MOV r2, r2, LSL #1
	ADDEQ r2, r2, #1 @ adiciona 1 ao valor final de r2 (output) se for detectado o padrão

	ADD r3, r3, #1 @ incrementa o contador
	B finite_state_machine
