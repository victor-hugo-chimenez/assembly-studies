.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
  B Reset_Handler /* Reset */
  B Undefined_Handler /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */
 
Reset_Handler:
  LDR sp, =stack_top


  @ Incializacao das stacks
  MRS r0, cpsr    @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11011011 @ alterando o modo para undefined - o SP eh automaticamente chaveado ao chavear o modo
  LDR sp, =undefined_stack_top @ a pilha de undefined eh setada 
  MSR cpsr, r0 @ volta para o modo anterior

  @ Mudar para modo usuário
  MRS r0, cpsr
  MSR cpsr_ctl, #0b11010000

  @ Volta para modo supervisor
  MSR cpsr, r0 @ volta para o modo anterior
  
  B .

Undefined_Handler:
  STMFD sp!, {R0-R12,pc}
  @ trata a interrupcao
  LDMFD sp!,{R0-R12,pc}^
