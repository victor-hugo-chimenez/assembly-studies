void impstr(char *pont) {
    __asm__( 
    "inic_imprime: nop\n\t"
    );

    if (pont[0] != 0) {
        impstr(pont+1);
    }

    __asm__( 
    "fim_imprime: nop\n\t"
    );

    return;
}
