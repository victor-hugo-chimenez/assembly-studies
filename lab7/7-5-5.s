.text
.global main

main:
	LDR r1, =0x3FF5000          @ endereco de IOPMOD
	LDR r2, =0xF0                     @ carregamos 1 nos bits [7:4] e 0 nos restantes
	STR r2, [r0]                          @ setamos IOPMOD[7:4] como output e IOPMOD[3:0] como input

	LDR r1, =0x3FF5008          @ endereco de IOPDATA
	MOV r0, #0                          @ registrador para armazenar o valor de IOPDATA

loop:
	LDR r0, [r1]                          @ pegamos os 4 primeiros bits que sao as entradas do DIP switch
	MOV r0, r0, LSL #4              @ shiftamos este valor em 4 para [7:4]
	STR r0, [r1]                           @ carregamos os LEDs que seriam IOPDATA[7:4]
	B loop
end:
	SWI 0x123456
