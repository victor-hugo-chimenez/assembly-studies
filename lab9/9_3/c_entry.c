volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *UART0DR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}


void Undefined() {
 print_uart0("Instrucao invalida!\n");
 return;
}

int c_entry(){
return 0;
}


