.text
.global main

main:
	LDR r1, =0x3FF5000      @ endereco de IOPMOD
	LDR r3, =0x1FC00          @ carregamos 1 nos bits [16:10] 
	STR r3, [r1]                      @ setamos IOPMOD[16:10] como output

	LDR r1, =0x3FF5008       @ endereco de IOPDATA
	
	LDR r2, =data                    @ endereco onde esta o valor a ser colocado no display
	LDR r4, [r2]                     @ o valor a ser carregado no display

	LDR r5, =seg_display    @ carregamos o endereco de onde esta o “mapeamento” de cada “caractere” 

	LDR r6, [r5, r4, LSL #2]             @ pegamos o caractere correspondente como valor a ser carregado no IOPDATA

	MOV r6, r6, LSL #10       @ shiftamos o valor de r6 para [16:10]
	STR r6, [r1]                      @ carregamos o valor em IOPDATA [16:10]

end:
	SWI 0x123456

.data

data: .word 14

seg_display: .word 0x5F, 0x06, 0x3B, 0x2F, 0x66, 0x6D, 0x7D, 0x47, 0x7F, 0x6F, 0x77, 0x7C, 0x59, 0x3E, 0x79, 0x71
