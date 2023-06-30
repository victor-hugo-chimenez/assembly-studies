.text
.global main

main:
	MOV r3, #0                 @ index i = 0
	MOV r4, #10                @ valor de index final 10
	MOV r5, #10                @ variavel c = 10
	ADR r1, a                  @ carregamos a posicao inicial do a em r1
	ADR r2, b                  @ carregamos a posicao inicial de b em r2
	
check:
	CMP r3, r4 	 	    	   @ checamos se i<=10
	BLE loop                   @ se i <= 10, vamos para o loop principal
	B   fim                    @ caso contrario, finalizamos

loop:
	LDR r6, [r2, r3, LSL #2]   @ carregamos o r6 com o valor guardado em b[i]
	ADD r0, r6, r5             @ realizamos a soma b[i] + c
	STR r0, [r1, r3, LSL #2]   @ guardamos o resultado da soma em a[i]
	ADD r3, r3, #1             @ incrementamos o i
	B   check                  @ voltamos para a checagem 

fim:	
	SWI 0x0                    @ fim do programa
	
	
a: .space 100
b: .word  0,1,2,3,4,5,6,7,8,9,10

