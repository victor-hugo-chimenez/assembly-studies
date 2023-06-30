@ Este código resolve o problema descrito no exercício 3.10.7
@ O objetivo dele é realizar uma divisão baseada no algoritmo de shift e subtração

.text
.global main
dados: .word 0x1, 0x2, 3, 4, 5, 6, 7, 0x8, 0x9, 0
resposta: .space 88 @abre espaço de 88 bytes para armazenar a resposta

main:
    LDR R0, =dados              @ recebe o endereço do array de dados
    LDR R1, [R0]             	@ dividendo - Carrega o primeiro elemento de dados em R1
	LDR R2, = 1000     	        @ divisor
	MOV R3, #0    		        @ quociente
	MOV R4, #1     		        @ variável que realiza a soma do quociente
pronto:
alinhar_divisor:             	@ alinhamos o divisor para a “mesma” casa do divisor como fazemos com divisão de decimais normalmente, onde subtraímos o divisor dos números mais significativos do dividendo
	CMP R1, R2, LSL #1  	    @ comparamos o dividendo com o divisor (<< 1)
	BLT divisao       	        @ se dividendo < divisor, passamos para divisão
	LSL R2, R2, #1 		        @ anteriormente foi apenas uma verificação, aqui realizamos de fato o shift left do divisor
	LSL R4, R4, #1 		        @ valor somado ao quociente seria equivalente ao número de shifts
	B alinhar_divisor

divisao:
	CMP R1, R2         	@ caso R1-R2 seja negativo, devemos pular as operacoes e
	BMI continua	      	@ mover uma casa
	SUB R1, R1, R2   	@ subtração do dividendo e divisor
	ADD R3, R3, R4   	@ soma do var no quociente
continua:
	LSRS R2, R2, #1  	@ “correcao” do dividendo movendo uma casa para direita
	LSRS R4, R4, #1  	@ “correcao” do inc movendo uma casa para direita
	BNE divisao          	@ a operacao termina quando inc eh zerado

	MOV R5, R1         	@ colocamos o resto no R5

	SWI 0                   @ fim do codigo
