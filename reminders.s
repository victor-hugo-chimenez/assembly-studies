    @ Mover um valor imediato para um registrador
    mov r0, #10

    @ Mover o conteúdo de um registrador para outro
    mov r1, r0

    @ Adicionar dois registradores e armazenar o resultado em um terceiro registrador
    add r2, r0, r1

    @ Carregar um valor da memória para um registrador
    ldr r3, =my_var      @ Carrega o valor de "my_var" para o registrador r3

    @ Armazenar um valor de um registrador na memória
    str r2, [r3]         @ Armazena o valor do registrador r2 no endereço apontado por r3
@-----------------------------------------------------------------------------------------------
    @ Condicional: comparar dois registradores
    cmp r0, r1
    beq label_equal      @ Salta para "label_equal" se r0 for igual a r1
    bne label_not_equal  @ Salta para "label_not_equal" se r0 for diferente de r1

    @ Loop: decrementar um contador e verificar se atingiu zero
    mov r4, #10          @ Inicializa o contador com 10
loop:
    subs r4, r4, #1      @ Decrementa o contador em 1
    bne loop             @ Salta para "loop" se o contador for diferente de zero

    @ Chamada de função
    bl function_name     @ Chama a função chamada "function_name"
    b end                @ Salta para o fim do código

label_equal:
    @ Código a ser executado se os registradores forem iguais
    b end

label_not_equal:
    @ Código a ser executado se os registradores forem diferentes
    b end

function_name:
    @ Código da função
    bx lr                @ Retorna da função
@-----------------------------------------------------------------------------------------------
    .data
    my_var:   .word 42      @ Declara uma variável chamada "my_var" e atribui o valor 42 a ela
@-----------------------------------------------------------------------------------------------
    mov r0, #10       @ Inicialize o contador com 10

loop:
    @ Código a ser executado dentro do loop
    @ ...

    subs r0, r0, #1   @ Decrementa o contador em 1
    bne loop          @ Salta para "loop" se o contador for diferente de zero
@-----------------------------------------------------------------------------------------------
    mov r0, #0        @ Inicialize o contador com 0

loop:
    @ Código a ser executado dentro do loop
    @ ...

    cmp r0, #10       @ Compara o contador com 10
    beq exit_loop     @ Salta para "exit_loop" se o contador for igual a 10

    @ Código a ser executado após a condição de saída
    @ ...

    add r0, r0, #1    @ Incrementa o contador em 1
    b loop            @ Salta para "loop" para a próxima iteração

exit_loop:
    @ Código a ser executado após o loop
    @ ...
@-----------------------------------------------------------------------------------------------
    @ Verifica se o número em R0 é assinado ou não assinado
    @ O resultado é armazenado no registrador R1, onde 1 indica um número assinado e 0 indica um número não assinado

    mov r1, r0              @ Copia o número original para o registrador R1

    asr r1, r1, #31         @ Desloca o número aritmético para a direita (preservando o sinal) em 31 bits

    cmp r1, #0              @ Compara o resultado com 0
    movge r1, #1            @ Se for maior ou igual a 0, o número é assinado (define R1 = 1)
    movlt r1, #0            @ Caso contrário, o número é não assinado (define R1 = 0)
@-----------------------------------------------------------------------------------------------
@ gcc p1.s
@ gdb a.out
@ x/3d primos_anteriores
@ b 85
@ r
@ x/3d primos_anteriores
@ q

	.text
	.globl main
main:
    LDR r0, =10773565 @ Número N para e verificar quais primos se tem antes del
    ADR r7, primos_anteriores @ Ponteiro para o vetor de resultdos

    MOV r11, #0 @ Número de números primos encontrados

	SUB r6, r0, #1
list_of_primes_loop:
	CMP r11, #3
    BEQ done_list_of_primes
    CMP r6, #2
    BLT done_list_of_primes

	@ ==== Início do loop de verificar se um número é primo ====

    MOV r9, r6, LSR #1 @ r9 é o maior divisor possível de r6, tirando r6, que é a metade de r6
	MOV r8, #2
	MOV r10, #-1 @ Guarda o menor divisor de r6 ou -1 se for primo
is_prime_loop:
    CMP r10, #-1
    BNE done_prime
    CMP r8, r9
    BGT done_prime

	MOV	r1, r6 @ Dividendo
	MOV	r2, r8 @ Divisor
	MOV	r3, #0 @ Quociente
	MOV	r5, #0 @ Resto

    @ ==== Início do loop da divisão ====

	MOV r4, r2

	@ Alinhamento do divisor com o dividendo
	CLZ r12, r1
	CLZ r13, r2
	SUBS r12, r13, r12
	MOVPL r2, r2, LSL r12 @ Dá o shift se a subtração resultou num valor positivo

	@ Loop que realiza a divisao desejada
	B div_condition
div_loop:
	MOV r3, r3, LSL #1
	CMP r1, r2
	SUBGE r1, r1, r2 @ Subtração do dividendo, r1 = r1 - r2
	ADDGE r3, r3, #1 @ Adição do quociente, r3 = r3 + 1
	MOV r2, r2, LSR #1 @ Deslocamento do dividendo para a direita
div_condition:
	CMP r2, r4
	BGE div_loop

	MOV r5, r1 @ Guarda o valor do resto

    @ ==== Fim do loop da divisão ====

    @ Guarda o valor do divisor atual se o resto for zero
    CMP r5, #0
    MOVEQ r10, r8

    ADD r8, r8, #1
    B is_prime_loop
done_prime:
	@ ==== Fim do loop de verificar se um número é primo ====

	CMP r10, #-1
    STREQ r6, [r7, r11, LSL #2]
    ADDEQ r11, r11, #1

    SUB r6, r6, #1
    B list_of_primes_loop
done_list_of_primes:
	SWI	0x123456

primos_anteriores:
    .word -1, -1, -1