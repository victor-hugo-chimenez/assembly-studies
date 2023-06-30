.text
.global main

main:
	@ carrega o valor armazenado em array[5] em r0 e atualiza o index do array
	ADD r2, r2, #20
	LDR r0, [r2], #20     
	@ adiciona o valor de y ao valor armazenado em r0
	ADD r0, r0, r1    	
	@ armazena o valor atualizado em array[10]	
	STR r0, [r2] 
	
	SWI 0x0                    @ fim do programa

