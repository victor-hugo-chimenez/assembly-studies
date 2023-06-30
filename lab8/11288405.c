// Para gerar e depurar o código:
// gcc 11288405.c int2str.s -o tarefa.out
// gdb tarefa.out

#include <stdio.h>

extern char* int2str(int N, char* s);

void impstr(char *pont) {
    __asm__( 
        "inic_imprime: nop\n\t"
    );

    if (pont[0] != 0) {
          printf("num: %c\n", pont[0]);
          impstr(pont+1);
    }

    __asm__( 
        "fim_imprime: nop\n\t"
    );

    return;
}

int main() {
    int nusp = 11288405;

    __asm__( 
        "pronto: nop\n\t"
    );

    nusp = nusp % 1000;

    char a[50];
    int2str(nusp, a);

    impstr(a);

    __asm__( 
        "fim: nop\n\t"
    );

    return 0;
}