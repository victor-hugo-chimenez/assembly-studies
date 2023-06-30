.text
.global main

main:
    @Definir o valor do código Gray de 2 bits em r1
    MOV r1, #0b01

    @Extrair o valor do bit mais significativo (MSB) do código Gray de 2 bits e armazená-lo em um registrador temporário
    LSR r2, r1, #1

    @Deslocar o valor de 2 bits de r1 para a esquerda (LSL #1) para fazer espaço para o novo bit do código Gray de 3 bits
    LSL r1, r1, #1

    @Extrair o valor do bit menos significativo (LSB) do código Gray de 2 bits e armazená-lo em outro registrador temporário
    AND r3, r1, #0b01

    @XOR do valor do MSB com o valor do LSB e armazenar o resultado no novo bit de r2
    EOR r2, r2, r3

    @XOR do valor do MSB com o valor original de r1 e armazenar o resultado em r2
    EOR r2, r2, r1

    @Fim
    MOV r0, #0
    SYS #0
    
    .end
