@ Iniciar o emulador QEMU com o kernel.bin
@ eabi-gdb --command=gdb-comandos1.txt kernel.elf

.global _start
.text
_start:
    b _Reset                 @posição 0x00 - Reset
    ldr pc, _undefined_instruction   @posição 0x04 - Instrução não-definida
    ldr pc, _software_interrupt     @posição 0x08 - Interrupção de Software
    ldr pc, _prefetch_abort     @posição 0x0C - Prefetch Abort
    ldr pc, _data_abort         @posição 0x10 - Data Abort
    ldr pc, _not_used           @posição 0x14 - Não utilizado
    ldr pc, _irq                @posição 0x18 - Interrupção (IRQ)
    ldr pc, _fiq                @posição 0x1C - Interrupção (FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq
_taskB: .word taskB

INTPND: .word 0x10140000       @Registrador de status de interrupção
INTSEL: .word 0x1014000C       @Registrador de seleção de interrupção (0 = IRQ, 1 = FIQ)
INTEN: .word 0x10140010        @Registrador de habilitação de interrupção
TIMER0L: .word 0x101E2000      @Registrador de carga do Timer 0
TIMER0V: .word 0x101E2004      @Registrador de valor do Timer 0
TIMER0C: .word 0x101E2008      @Registrador de controle do Timer 0

_Reset:
    LDR sp, =supervisor_stack_top

    @ Inicialização das pilhas
    MRS r0, cpsr                @ Salvar o modo atual em R0
    MSR cpsr_ctl, #0b11010010   @ Alterar o modo para IRQ - SP é automaticamente trocado ao mudar de modo
    LDR sp, =irq_stack_top       @ Definir a pilha para IRQ
    MSR cpsr, r0                @ Voltar para o modo anterior

    bl timer_init               @ Inicializar interrupções e Timer 0

    MRS r0, cpsr                @ Valor de CPSR para taskB
    LDR r1, _taskB              @ Valor de PC para taskB
    SUB r2, sp, #0x500          @ Valor de SP para taskB

    ADR r3, linhaB
    STR r1, [r3, #52]           @ Salvar PC
    STR r0, [r3, #56]           @ Salvar CPSR
    STR r2, [r3, #60]           @ Salvar SP

    b taskA

undefined_instruction:
    b .
software_interrupt:
    b do_software_interrupt     @ Ir para o tratador de interrupção de software
prefetch_abort:
    b .
data_abort:
    b .
not_used:
    b .
irq:
    b do_irq_interrupt          @ Ir para o tratador de interrupção IRQ
fiq:
    b .

do_software_interrupt:         @ Rotina de interrupção de software
    add r1, r2, r3             @ r1 = r2 + r3
    mov pc, r14                @ Retornar para o endereço armazenado em r14

do_irq_interrupt:              @ Rotina de interrupção IRQ
    @ Corrigir lr
    SUB lr, lr, #4

    STMFD sp!, {r10-r11}

    ADR r11, nproc              @ r11 = endereço de nproc
    LDR r10, [r11]              @ r10 = valor de nproc
    CMP r10, #0

    @ Salvar r0 na primeira posição
    @ Usar r0 como base para indexar e armazenar registradores
    STREQ r0, linhaA
    ADREQ r0, linhaA

    STRNE r0, linhaB
    ADRNE r0, linhaB

    LDMFD sp!, {r10-r11}

    ADD r0, r0, #4
    STMIA r0!, {r1-r12, lr}

    @ Salvar SPSR
    MRS r1, spsr
    STMIA r0!, {r1}

    @ Mudar para o modo de armazenar SP e LR
    MRS r1, cpsr
    MSR cpsr_ctl, #0b11010011
    STMIA r0!, {sp, lr}
    MSR cpsr, r1
    @ Ordem de armazenamento: r0 a r12 - pc - cpsr - sp - lr

    @@ Interrupção
    LDR r0, INTPND              @ Carregar o registrador de status de interrupção
    LDR r0, [r0]
    TST r0, #0x0010             @ Verificar se é uma interrupção de timer
    BLNE timer_irq

    @ Preparar o processo para a próxima tarefa
    ADR r11, nproc              @ r11 = endereço de nproc
    LDR r10, [r11]              @ r10 = valor de nproc
    CMP r10, #0

    @@ Restaurar todos os registradores para a próxima tarefa
    ADREQ r0, linhaA
    ADRNE r0, linhaB
    ADD r0, r0, #68

    MRS   r1, cpsr
    MSR   cpsr_ctl, #0b11010011 @ Modo supervisor
    LDMDB r0!, {sp, lr}         @ Restaurar SP e LR
    vesp_saida:
    MSR   cpsr, r1              @ Sair do modo supervisor

    LDMDB r0!, {r1}
    MSR   spsr, r1              @ Restaurar SPSR
    vespsr_saida:

    LDMDB r0, {r0-r12, pc}^      @ Restaurar r0-r12 e pc


timer_irq:
    STMFD sp!, {r10-r11, lr}
    BL handler_timer            @ Ir para a rotina de tratamento de interrupção de timer

    ADR r11, nproc              @ r11 recebe o endereço de nproc
    LDR r10, [r11]              @ r10 recebe o valor de nproc
    CMP r10, #0

    @ Salvar r0 na primeira posição
    @ Usar r0 como base para indexar e armazenar registradores
    MOVEQ r10, #1
    MOVNE r10, #0

    STR r10, [r11]              @ Alternar entre os processos

    LDMFD sp!, {r10-r11, lr}
    MOV pc, lr

timer_init:
    @ Habilitar interrupção do timer 0
    LDR r0, INTEN
    LDR r1, =0x10               @ Bit 4 para habilitar interrupção do timer 0
    STR r1, [r0]

    @ Configurar o valor do timer
    LDR r0, TIMER0L
    LDR r1, =0xff               @ Configurar o valor do timer
    STR r1, [r0]

    @ Habilitar contagem do timer 0
    LDR r0, TIMER0C
    MOV r1, #0xE0               @ Habilitar módulo do timer
    STR r1, [r0]

    @ Habilitar interrupção do processador no CPSR
    mrs r0, cpsr
    bic r0, r0, #0x80
    msr cpsr_c, r0              @ Habilitar interrupções no cpsr

    mov pc, lr

linhaA:
    .space 68

linhaB:
    .space 68

nproc:
    .word 0x0


/*
Este código assembly implementa um sistema de tratamento de interrupções em um ambiente embarcado. 
O programa define um vetor de interrupções para direcionar diferentes tipos de interrupções para suas respectivas rotinas de tratamento. 
O código possui rotinas específicas para interrupções de instrução indefinida, interrupção de software, aborto de pré-busca, aborto de dados, interrupção não utilizada, interrupção IRQ e interrupção FIQ. 
Além disso, há uma rotina de inicialização de temporizador que habilita a interrupção do temporizador e configura seu valor. 
O código também inclui mecanismos para salvar e restaurar o estado dos registradores durante o tratamento de interrupções, bem como para alternar entre processos em um ambiente multitarefa.

 */