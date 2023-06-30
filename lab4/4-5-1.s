.text
.global main

main:
	ADR r2, array              @ carregamos a posicao inicial do array em r2
	MOV r4, #5                 @ carregamos o indice do vetor que queremos acessar n = 5
	
	MOV r1, #2                 @ carregamos um valor qualquer para y
	MOV r5, #7                 @ carregamos o r5 que servira para colocar um valor no array[5]
	STR r5, [r2, r4, LSL #2]   @ salvamos o valor de r5 no array[5]
	
preindexado:
	LDR r3, [r2, r4, LSL #2]   @ carregamos em r3 o valor guardado no endereco de indice 5 do array
	ADD r0, r1, r3             @ realizamos a soma pedida, r0 = r1 + r3 equivale a x = y + array[5]
	
posindexado:
	ADD r2, r4, LSL #2         @ atualizamos o indice do array antecipadamente
	LDR r3, [r2]               @ realizamos um LDR pos indexado do valor pegado do endereco atualizado
	ADD r0, r1, r3             @ realizamos a soma
	
	SWI 0x0                    @ fim do programa
	
array: .space 100

