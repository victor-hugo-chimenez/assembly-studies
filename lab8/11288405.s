	.file	"11288405.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%c\n\000"
	.text
	.align	2
	.global	impstr
	.type	impstr, %function
impstr:
	@ args = 0, pretend = 0, frame = 4
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #4
	str	r0, [fp, #-16]
	inic_imprime: nop
	
	ldr	r3, [fp, #-16]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2
	ldr	r3, [fp, #-16]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r0, .L3
	mov	r1, r3
	bl	printf
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	mov	r0, r3
	bl	impstr
.L2:
	fim_imprime: nop
	
	ldmfd	sp, {r3, fp, sp, pc}
.L4:
	.align	2
.L3:
	.word	.LC0
	.size	impstr, .-impstr
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #56
	mov	r3, #11272192
	add	r3, r3, #16192
	add	r3, r3, #21
	str	r3, [fp, #-16]
	pronto: nop
	
	ldr	r1, [fp, #-16]
	ldr	r3, .L6
	smull	r2, r3, r1, r3
	mov	r2, r3, asr #6
	mov	r3, r1, asr #31
	rsb	r2, r3, r2
	mov	r3, r2
	mov	r3, r3, asl #5
	rsb	r3, r2, r3
	mov	r3, r3, asl #2
	add	r3, r3, r2
	mov	r3, r3, asl #3
	rsb	r3, r3, r1
	str	r3, [fp, #-16]
	sub	r3, fp, #68
	ldr	r0, [fp, #-16]
	mov	r1, r3
	bl	int2str
	sub	r3, fp, #68
	mov	r0, r3
	bl	impstr
	fim: nop
	
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #12
	ldmfd	sp, {fp, sp, pc}
.L7:
	.align	2
.L6:
	.word	274877907
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
