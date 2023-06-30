.text
.global main

main:
	LDR r1, =0x3FF5000          @ endereco de IOPMOD
	LDR r2, =0x1FCF0                     @ carregamos 1 nos bits [16:10] e [7:4] e 0 nos restantes
	STR r2, [r1]                          @ setamos IOPMOD[16:10][7:4] como output e IOPMOD[3:0] como input

	LDR r1, =0x3FF5008          @ endereco de IOPDATA
	MOV r0, #0                          @ registrador para armazenar o valor de IOPDATA
	MOV r3, #0                           @ contador para o 7seg

loop:
	LDR r0, [r1]                          @ pegamos os 4 primeiros bits que sao as entradas do DIP switch
    AND r0, r0, #0b1111                     @ garantia que pegamos apenas os 4 bits	

	MOV r6, r0, LSL #4                  @ shiftamos este valor em 4 para [7:4]

	LDR r4, =0xFFFFFF            @ delay para tempo suficiente do usuario alterar o DIP
	BL delay_loop
	
	LDR r5, [r1]
	AND r5, r5, #0b1111
	CMP r0, r5
	ADDNE r3, r3, #1
	
	BL update_display

	B loop


update_display:
	STMFD sp!, {r5}
    LDR r5, =seg_display    @ carregamos o endereco de onde esta o “mapeamento” de cada “caractere” 
	LDR r8, [r5, r3,LSL  #2]             @ pegamos o caractere correspondente como valor a ser carregado no IOPDATA
	MOV r8, r8, LSL #10       @ shiftamos o valor de r6 para [16:10]
	ADD r7, r6, r8 
	STR r7, [r1]                      @ carregamos o valor em IOPDATA [16:10]

	LDMFD sp!, {r5}
	MOV pc, lr

delay_loop:
	SUB r4, r4, #1                @ logica fornecida no enunciado para delay, subtrair 1 de FFFFF ate chegar em 0
	CMP r4, #0
	BNE delay_loop
	MOV pc, lr                       @ voltamos para o loop principal

.data

seg_display: .word 0x5F, 0x06, 0x3B, 0x2F, 0x66, 0x6D, 0x7D, 0x47, 0x7F, 0x6F, 0x77, 0x7C, 0x59, 0x3E, 0x79, 0x71
