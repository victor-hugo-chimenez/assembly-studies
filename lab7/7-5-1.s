.text
.global main

main:
	LDR r1, =0x3FF5000              @ endereco de IOPMOD
	LDR r2, =0b11110000             @seta 1 os bits [7:4] para passar para IOPMOD
	STR r2, [r0]                    @ seta 1 os bits [7:4] do IOPMOD para configurar como output

	LDR r1, =0x3FF5008   @ pegamos o endereco de IOPDATA para manusear os LEDs

	MOV r0, #0                   @ index contador

loop:
	MOV r3, r0, LSL #4      @ carregamos o valor atual do index nas posicoes [7:4] de r3
	STR r3, [r1]                    @ carregamos este valor em IOPDATA [7:4]

	ADD r0, r0, #1                @ incrementamos index
	CMP r0, #0xF                  @ verificamos se index passou de 1 hexa
	MOVGT r0, #0               @ se sim, resetamos o index
	
	LDR r4, =0xFFFFF         @ “index” para o delay

delay_loop:
	SUB r4, r4, #1                @ logica fornecida no enunciado para delay, subtrair 1 de FFFFF ate chegar em 0
	CMP r4, #0
	BNE delay_loop
	B    loop                       @ voltamos para o loop principal
