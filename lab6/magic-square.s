@ Este código verifica se uma dada matriz NxN é um quadrado perfeito
@ Victor Hugo Chimenez Queiroz NUSP: 11288405


.text
.global main

main:
    LDR r3, =N @ N = 4              @ Carrega o endereço de N
    LDR r0, [r3]                   @ Carrega o valor de N em r0

    LDR r1, =quadrado @ M = matrix  @ Carrega o endereço de quadrado (matrix) em r1

    MUL r3, r0, r0                 @ Calcula N^2 e armazena em r3
    ADD r3, r3, #1                 @ Adiciona 1 ao valor de r3
    MUL r2, r3, r0                 @ Calcula N*(N^2+1) e armazena em r2
    MOV r2, r2, LSR #1             @ Divide r2 por 2 (N*(N^2+1)/2)

    BL magicSquare                 @ Chama a função magicSquare
    LDR r3, =ehmagico               @ Carrega o endereço de ehmagico em r3
    STR r9, [r3]                   @ Armazena o valor de r9 em ehmagico
    B fim                          @ Pula para o final do programa

magicSquare:
    STMFD sp!, {r0, r1, r2, lr} @ Guarda os registradores na pilha
    
    MOVS r9, #1
    
    @ A partir daqui haverão uma série de verificações
    @ caso alguma delas seja inválida, r10 será setado para 0 e terá um valor divergente de r9
    @ sendoa assim as verificações seguintes serão puladas dada uma falha em um dos steps anteriores

    BLNE verifica_quadrado
    ANDS r9, r9, r10

    BLNE verifica_linhas
    ANDS r9, r9, r10

    BLNE verifica_colunas
    ANDS r9, r9, r10

    BLNE verifica_diagonal_principal
    ANDS r9, r9, r10
    
    BLNE verifica_diagonal_secundaria
    ANDS r9, r9, r10
    
    LDMFD sp!, {r0, r1, r2, lr} @ Recupera os registradores da pilha
    MOV pc, lr

@ Se as linhas estiverem ok r10 será setado para 1
verifica_linhas:
    STMFD sp!, {r0, r1, r2}
    MOV r6, r0 

    verifica_linhas_loop:
        CMP r6, #0
        MOVLE r10, #1
        BLE verifica_linhas_loop_end

        MOV r3, #0 @ i = 0
        MOV r4, #0 @ Soma da linha

        loop_linha:
            CMP  r3, r0
            BGE loop_linha_fim

            LDR r5, [r1], #4
            ADD r4, r4, r5

            ADD r3, r3, #1 @ i++
            B loop_linha

        loop_linha_fim:

        @ Verifica se a soma bate com a fórmula do quadrado perfeito    
        CMP r2, r4

        MOVNE r10, #0
        BNE verifica_linhas_loop_end

        SUB r6, r6, #1
        B verifica_linhas_loop
    
    verifica_linhas_loop_end:
        LDMFD sp!, {r0, r1, r2}
        MOV pc, lr

@ Se as colunas estiverem ok r10 será setado para 1
verifica_colunas:
    STMFD sp!, {r0, r1, r2}

    MOV r3, #0 @ Contador loop principal
    verifica_colunas_loop:
        CMP r3, r0
        MOVGE r10, #1
        BGE verifica_colunas_loop_end

        @ Ler colunas, acumular e comparar com r2
        MOV r6, #0 @ Acumulador
        MOV r7, #0 @ Contador
        ADD r4, r1, r3, LSL #2
        column_read_loop:
            CMP r7, r0
            BGE verifica_soma_colunas
            LDR r5, [r4], r0, LSL #2

            ADD r6, r6, r5

            ADD r7, r7, #1
            B column_read_loop
        verifica_soma_colunas:
            @ Verifica se a soma bate com a fórmula do quadrado perfeito
            CMP r6, r2
            MOVNE r10, #0
            BNE verifica_colunas_loop_end

        ADD r3, r3, #1
        B verifica_colunas_loop
    verifica_colunas_loop_end:
        LDMFD sp!, {r0, r1, r2}
        MOV pc, lr

@ Se a diagonal principal estiver ok r10 será setado para 1
verifica_diagonal_principal:
    STMFD sp!, {r0, r1, r2}

    MOV r3, #0 @ i = 0
    MOV r4, r1 @ Endereco de M[i, i]
    MOV r6, #0 @ Acumulador
    
    verifica_diagonal_principal_loop:    
        CMP r3, r0
        BGE verifica_diagonal_principal_loop_end

        LDR r5, [r4]
        
        ADD r4, r4, r0, LSL #2
        ADD r4, r4, #4
        
        ADD r6, r6, r5

        ADD r3, r3, #1
        B verifica_diagonal_principal_loop

    verifica_diagonal_principal_loop_end:
        @ Verifica se a soma da diagonal principal bate com a fórmula do quadrado perfeito
        CMP r6, r2
        MOVNE r10, #0
        MOVEQ r10, #1
        
    verifica_diagonal_principal_end:
        LDMFD sp!, {r0, r1, r2}
        MOV pc, lr

@ Se as diagonais secundárias estiverem ok r10 será setado para 1
verifica_diagonal_secundaria:
    STMFD sp!, {r0, r1, r2}

    ADD r5, r1, r0, LSL #2
    SUB r5, r5, #4
     
    MOV r4, #0 @ Acumulador
    MOV r3, #0 @ Contador
    verifica_diagonal_secundaria_loop:
        CMP r3, r0
        BGE verifica_diagonal_secundaria_loop_end
        
        @ Lê e acumula valor da diagonal
        LDR r6, [r5]
        ADD r4, r4, r6
        
        @ Atualiza endereço
        ADD r5, r5, r0, LSL #2
        SUB r5, r5, #4

        ADD r3, r3, #1
        B verifica_diagonal_secundaria_loop
    verifica_diagonal_secundaria_loop_end:
        @ Verifica se a soma bate com a fórmula do quadrado perfeito
        CMP r4, r2
        MOVNE r10, #0
        MOVEQ r10, #1
        
    LDMFD sp!, {r0, r1, r2}
    MOV pc, lr

@ Verifica se a matriz corresponde aos padrões de ser um quadrado mágico
verifica_quadrado:
    STMFD sp!, {r0, r1, r2}
    
    MOV r10, #1 @ saida
    MOV r3, #0 @ i = 0
    LDR r5, =hash
    MUL r7, r0, r0

    loop_de_verificacao:
        CMP r3, r7
        BGE loop_de_verificacao_end
    
        LDR r4, [r1, r3, LSL #2]
        
        @ Verifica se não tem nenhum elemento maior que N² 
        CMP r4, r7
        MOVGT r10, #0
        BGT loop_de_verificacao_end

        @ Verifica se não tem nenhum número menor ou igual a 0
        CMP r4, #0
        MOVLE r10, #0
        BLE loop_de_verificacao_end

        @ Verifica se existem elementos iguais na matriz, usando um hash
        SUB r4, r4, #1
        LDR r6, [r5, r4, LSL #2]
        CMP r6, #1
        MOVEQ r10, #0
        BEQ loop_de_verificacao_end
        
        STR r10, [r5, r4, LSL #2]
        ADD r3, r3, #1
        B loop_de_verificacao

    loop_de_verificacao_end:
        LDMFD sp!, {r0, r1, r2}
        MOV pc, lr

fim:
    SWI 0x123456

.data
N:
    .word 3

quadrado:
    .word 5,5,5, 5,5,5, 5,5,5
hash:
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ehmagico:
    .word 0