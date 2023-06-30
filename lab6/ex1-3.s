.text
.global main

main:
	LDR r0, =b 	  @ Carrega o endereço de 'b' em r0
	LDR r1, [r0]  @ Carrega o valor em memória apontado por r0 em r1

	LDR r0, =c 	  @ Carrega o endereço de 'c' em r0
	LDR r2, [r0]  @ Carrega o valor em memória apontado por r0 em r2
    
	LDR r0, =d 	  @ Carrega o endereço de 'd' em r0
	LDR r3, [r0]  @ Carrega o valor em memória apontado por r0 em r3

	BL func1  	  @ Chama a função func1
    
	LDR r0, =a 	  @ Carrega o endereço de 'a' em r0
	STR r4, [r0]  @ Armazena o valor de r4 na memória apontada por r0

	B fim     	  @ Salta para a etiqueta 'fim'

func1:
	STMFD sp!, {lr}  @ Armazena na pilha o valor do link register (lr)

	MUL r0, r1, r2   @ Multiplica r1 por r2 e armazena o resultado em r0
	BL func2    	 @ Chama a função func2

	LDMFD sp!, {lr}  @ Recupera o valor do link register (lr) da pilha
	MOV pc, lr  	 @ Retorna para a instrução seguinte à chamada de função

func2:
	ADD r4, r0, r3  @ Soma r0 e r3 e armazena o resultado em r4
	MOV pc, lr  	@ Retorna para a instrução seguinte à chamada de função

fim:
	SWI 0x123456	@ Executa uma interrupção de software

.data
a:
	.word 0     	@ Define um valor inicial para 'a'

b:
	.word 2     	@ Define um valor inicial para 'b'

c:
	.word 3     	@ Define um valor inicial para 'c'

d:
	.word 4     	@ Define um valor inicial para 'd'