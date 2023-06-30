.text
.global main
dados: .word 0x1, 0x2, 3, 4, 5, 6, 7, 0x8, 0x9, 0

main:
    LDR R0, =dados
    LDR R1, [R0]
    LDR R2, = 1000     	        
	MOV R3, #0    		        
	MOV R4, #1  

fim: 
	SWI 0                   @ fim do codigo    