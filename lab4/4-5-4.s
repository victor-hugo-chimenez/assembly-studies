.text
.global main

main:
	ADR r1, array              @ achamos o endereco do array
	MOV r3, #0                 @ iniciamos i = 0
	ADR r4, s                  @ achamos o endereco de s
	LDR r2, [r4]               @ carregamos o valor passado de s em r2
	MOV r0, #0                 @ r0 sera o registrador para o numero 0
	
loop:
	STR r0, [r1, r3, LSL #2]   @ salvamos o 0 no array[i]
	ADD r3, r3, #1             @ incrementamos o i
	CMP r3, r2                 @ verificamos se i<s
	BLT loop                   @ se for, volta para o loop, se nao passa e termina o codigo
	
fim:	
	SWI 0x0                    @ fim do programa
	
	
array: .space 100
s:     .word 5

