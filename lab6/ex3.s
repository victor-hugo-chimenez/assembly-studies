.text
.global main

main:
	MOV r1, #4                       	@ valor de N variavel
	LDR r2, =quadrado                	@ endereco do quadrado

	MUL r9, r1, r1                   	@ aqui fazemos N^2
	ADD r9, r9, #1                   	@ N^2 + 1
	MUL r3, r9, r1                   	@ (N^2 + 1) * N
	MOV r3, r3, LSR #1               	@ N(N^2 + 1)/2

	BL   verify_values
    
	CMP  r10, #0
	BLNE verify_rows
    
	CMP  r10, #0
	BLNE verify_columns
    
	CMP  r10, #0
	BLNE verify_main_diagonal
    
	CMP  r10, #0
	BLNE verify_second_diagonal
    
	LDR r4, =ehmagico
	STR r10, [r4]
	B fim


verify_rows:
	STMFD sp!, {r0 - r9}
	MOV r6, r0                       	@ index decremental do loop principal

	rows_loop:
    	CMP r6, #0                   	@ verificamos se o index chegou em menor ou igual a 0
    	MOVLE r10, #1                	@ se sim, r10 = 1
    	BLE rows_loop_end            	@ e saimos do loop principal

    	MOV r0, #0                   	@ index do loop interno i
    	MOV r4, #0                   	@ Soma da linha

    	row_loop:
        	CMP  r0, r1              	@ comparamos o index com N
        	BGE row_loop_end         	@ se i >= N, saimos do loop interno

        	LDR r5, [r2], #4   	  @ se nao, r5 recebe o valor do elemento atual e incrementamos posteriormente 1 de indice (ou 4 bytes no endereco)
        	ADD r4, r4, r5           	@ somamos este valor em r4

        	ADD r0, r0, #1           	@ incrementamos o index do loop interno
        	B row_loop               	@ voltamos para o loop interno

    	row_loop_end:
       	 
    	CMP r3, r4                   	@ comparamos a soma com o N(N^2 + 1)/2
    	MOVNE r10, #0                	@ se forem diferentes, r10 = 0 (sinal de erro)
    	BNE rows_loop_end            	@ saimos do loop principal

    	SUB r6, r6, #1               	@ se a soma for igual (tudo certo), decrementamos o indice do loop principal
    	B rows_loop                  	@ voltamos para o loop principal
    
	rows_loop_end:
    	LDMFD sp!, {r0 - r9}
    	MOV pc, lr                   	@ saimos da sub rotina


verify_columns:
	STMFD sp!, {r0 - r9}
	MOV r6, #0                       	@ indice incremental do loop principal
    
	columns_loop:
    	CMP r6, r1                   	@ verificamos o indice do loop principal
    	MOVGE r10, #1                	@ se for maior ou igual a N, r10 = 1 (tudo certo)
    	BGE columns_loop_end         	@ e saimos do loop principal

    	MOV r0, #0                   	@ indice do loop interno
    	MOV r4, #0                   	@ somador das colunas
    	ADD r7, r2, r6, LSL #2       	@ calculo do endereco da proxima coluna (na teoria, essa linha devolve o endereco do proximo item da primeira linha)
   	 
    	column_loop:
        	CMP r0, r1               	@ verificacao do indice do loop interno
        	BGE column_loop_end      	@ se i >= N, said do loop
        	LDR r5, [r7], r1, LSL #2 	@ carregamos o r5 com o valor do proximo elemento de uma coluna (na teoria, aqui ele acessa a proxima linha da mesma coluna, incrementando N*4 ao endereco atual)

        	ADD r4, r4, r5           	@ somamos este valor ao r4
        	ADD r0, r0, #1           	@ somamos 1 ao indice do loop interno
        	B column_loop            	@ voltamos para o loop interno
       	 
    	column_loop_end:
        	CMP r4, r3               	@ comparamos a soma com N(N^2 + 1)/2
        	MOVNE r10, #0            	@ se forem diferentes, r10 = 0 (algo errado)
        	BNE columns_loop_end     	@ saimos do loop principal

    	ADD r6, r6, #1               	@ se forem iguais, incrementamos 1 ao loop principal
    	B columns_loop               	@ voltamos para o loop principal
   	 
	columns_loop_end:
    	LDMFD sp!, {r0 - r9}
    	MOV pc, lr                   	@ saida da sub rotina


verify_main_diagonal:
	STMFD sp!, {r0 - r9}

	MOV r6, #0    			  @ indice do loop principal
	MOV r7, r2                       	@ endereco de M[i, i]
	MOV r4, #0                       	@ soma da diagonal principal
    
	main_diagonal_loop:    
    	CMP r6, r1                   	@ verificamos o indice
    	BGE main_diagonal_loop_end   	@ se i >= N, saimos do loop

    	LDR r5, [r7]                 	@ carregamos em r5 o valor de M[i][i]
   	 
    	ADD r7, r7, r1, LSL #2       	@ ataulizamos o endereco [i][i], pegando primeiramente a proxima linha da mesma coluna
    	ADD r7, r7, #4               	@ e em seguida movendo 1 coluna para a direita, resultando na posicao M[i+1][i+1]
   	 
    	ADD r4, r4, r5               	@ somamos r5 em r4

    	ADD r6, r6, #1               	@ incrementamos 1 ao indice do loop            	 
    	B main_diagonal_loop         	@ voltamos para o loop

	main_diagonal_loop_end:
    	CMP r4, r3                   	@ verificacao se a soma esta de acordo
    	MOVNE r10, #0                	@ se nao for, r10 = 0 (algo errado)
   	 
    	LDMFD sp!, {r0 - r9}
    	MOV pc, lr                   	@ saida da sub rotina


verify_second_diagonal:
	STMFD sp!, {r0 - r9}

	MOV r7, r2
	ADD r7, r7, r1, LSL #2           	@ aqui primeiro pegamos o primeiro elemento da diagonal secundaria
	SUB r7, r7, #4                   	@ referente ao utlimo elemento da primeira linha
	 
	MOV r4, #0                       	@ soma da diagonal
	MOV r0, #0                       	@ indice do loop
    
	second_diagonal_loop:
    	CMP r0, r1                   	@ verificacao do indice
    	BGE second_diagonal_loop_end 	@ se i >= N, saimos do loop
   	 
    	LDR r5, [r7]                 	@ pegamos em r5 o valor atual do elemento de diagonal
    	ADD r4, r4, r5               	@ somamos em r4
   	 
    	ADD r7, r7, r1, LSL #2       	@ autalizamos o proximo endereco a ser lido, movendo 1 linha para baixo
    	SUB r7, r7, #4               	@ e uma coluna para esquerda

    	ADD r0, r0, #1               	@ incrementamos o indice
    	B second_diagonal_loop       	@ voltamos para o loop
   	 
	second_diagonal_loop_end:
    	CMP r4, r3                   	@ verificacao se a soma esta de acordo
    	MOVNE r10, #0                	@ se nao, r10 = 0 (algo errado)
   	 
	LDMFD sp!, {r0 - r9}
	MOV pc, lr                       	@ saida da sub rotina

verify_values:
	STMFD sp!, {r0 - r9}
    
	MOV r10, #1                      	@ verificador se o magic square esta indo certo         	 
	MOV r0, #0                       	@ indice do loop
	LDR r5, =hash                    	@ endereco da mascara (hash)
	MUL r7, r1, r1                   	@ r7 = N^2

	hash_loop:
    	CMP r0, r7                   	@ verificacao de saida do loop
    	BGE hash_loop_end            	@ se i >= N^2, sair do loop
    
    	LDR r4, [r2, r0, LSL #2]     	@ carregamos em r4 o valor de um elemento

    	CMP r4, r7                   	@ comparamos este valor com N^2
    	MOVGT r10, #0                	@ se o elemento tiver um valor maior que N^2, r10 = 0 (erro!)
    	BGT hash_loop_end            	@ e saimos do loop imediatamente

    	CMP r4, #0                   	@ comparamos este valor com 0
    	MOVLE r10, #0                	@ se for igual ou menor que 0, r10 = 0 (erro!)
    	BLE hash_loop_end            	@ e saimos do loop

    	SUB r4, r4, #1               	@ decrementamos 1 para o "endereco do valor na mascara"
    	LDR r6, [r5, r4, LSL #2]     	@ carregamos em r6 o valor salvado neste endereco do array hash (mascara); Aqui, se o valor 11 esta sendo lido, por exemplo, verifica no endereco 10 do hash se ja teve um outro elemento com o mesmo valor, onde se nesse endereco tiver o valor 1 (ja encontrado anteriormente) eh sinal de algo errado!

    	CMP r6, #1                   	@ se este valor for 1, ou seja, ja foi encontrado anteriormente este valor
    	MOVEQ r10, #0                	@ r10 = 0 (erro!)
    	BEQ hash_loop_end            	@ e saimos do loop
   	 
    	STR r10, [r5, r4, LSL #2]    	@ se nao saimos do loop, ou seja, o valor da mascara neste endereco for 0, trocamos para 1
    	ADD r0, r0, #1               	@ incrementamos 1 no indice
    	B hash_loop                  	@ voltamos para o loop

	hash_loop_end:
    	LDMFD sp!, {r0 - r9}
    	MOV pc, lr                   	@ saida da sub rotina

fim:
	SWI 0x123456

.data

quadrado:
	.word 16,3,2,13, 5,10,11,8, 9,6,7,12, 4,15,14,1
hash:
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ehmagico:
	.word 0
