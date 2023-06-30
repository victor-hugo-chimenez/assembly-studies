
.text
.global main

main:
    LDR r1, =array         	@ r1 guarda o endereco inicial do array
    LDR r2, [r1], #4       	@ r2 guarda o tamanho da array, que seria o primeiro elemento da array de acordo com o enunciado e incrementamos 4 para agora pegar a lista de fato
    BL  bubble_sort
    B   end
    
bubble_sort:
    STMFD sp!, {r1, r2, lr} @ Store in stack registers
    MOV r3, r2             	@ r3 guarda o valor do tamanho do array, serve como um indicie para o loop principal
    
    sort_main_loop:
   	 MOV r0, #0     	@ contador do loop interto
   	 
   	 sort_internal_loop:
   		 ADD r4, r1, r0, LSL #2  	@ atualizador do indice do array, guardado em r4
   		 
   		 ADD r0, r0, #1          	@ incrementa o indice do loop interno
   		 CMP r0, r3              	@ se este indice passar ou ficar igual ao indice do loop principal
   		 BGE sort_internal_loop_end  @ sair do loop interno
   		 
   		 LDMIA r4, {r8, r9}      	@ se nao, seguimos para o algoritmo de swap, carregando em r8 e r9 os valores do array na posicao atual
   		 CMP   r8, r9            	@ comparamos os 2 valores adjacentes
   		 BLE   sort_internal_loop	@ se o primeiro elemento for menor ou igual ao segundo, nada acontece, esta tudo certo e passamos para a proxima iteracaco do loop interno
   		 
   		 MOV   r10, r8           	@ se r8 > r9, seguimos com o swap
   		 MOV   r8, r9            	@ r8 recebe r9
   		 MOV   r9, r10           	@ r9 recebe r8
   		 STMIA r4, {r8, r9}      	@ salvamos os valores trocados de volta
   		 
   		 B   sort_internal_loop  	@ voltamos para o loop interior
   		 
   		 
   	 sort_internal_loop_end:
   		 SUB r3, r3, #1
   		 CMP r3, #1
   		 BLE sort_main_loop_end
   		 B   sort_main_loop
    
    sort_main_loop_end:
   	 LDMFD sp!, {r1, r2, lr}
   	 MOV pc, lr
    
end:
    SWI 0x123456
    
.data

array: .word 7, 6,5,7,3,6,8,2
