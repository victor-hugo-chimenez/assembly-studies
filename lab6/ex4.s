.text
.global main

main:
    MOV r0, #1     @ r0 = 1: byte; 2: half-word; 4: word
    MOV r1, #10    @ r1 = valor a ser armazenado

    BL push_stack  @ Chama a função push_stack para empilhar o valor

    B fim          @ Salta para a etiqueta 'fim'

@ Empilha um valor sem uso de múltiplos armazenamentos
@ r0 - 1: byte; 2: half-word; 4: word
@ r1 - valor a ser empilhado
push_stack:
    MOV r2, #0     @ r2 = 0 (valor temporário)

    CMP r0, #1     @ Compara r0 com 1
    STREQ r2, [sp] @ Se for igual a 1, armazena 0 (byte) no endereço de pilha (sp)
    STREQB r1, [sp]@ Se for igual a 1, armazena o valor (byte) no endereço de pilha (sp)

    CMP r0, #2     @ Compara r0 com 2
    STREQ r2, [sp] @ Se for igual a 2, armazena 0 (half-word) no endereço de pilha (sp)
    STREQH r1, [sp]@ Se for igual a 2, armazena o valor (half-word) no endereço de pilha (sp)

    CMP r0, #4     @ Compara r0 com 4
    STREQ r1, [sp] @ Se for igual a 4, armazena o valor (word) no endereço de pilha (sp)

    SUB sp, sp, #4 @ Decrementa o ponteiro de pilha (sp) em 4 bytes para alocar espaço
    MOV pc, lr     @ Retorna para a instrução seguinte à chamada de função

fim:
    SWI 0x123456   @ Executa uma interrupção de software

