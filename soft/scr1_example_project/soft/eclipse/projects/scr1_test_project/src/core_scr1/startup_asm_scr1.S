#define TRAP_REGS_SPACE 32 * 4

     ## some useful macros
     .altmacro

 	.macro save_reg_offs reg, offs, save_mem_base=zero
 		sw   \reg, \offs*4(\save_mem_base)
 	.endm

 	.macro save_reg regn, save_mem_base=zero
 		sw   x\regn, \regn*4(\save_mem_base)
 	.endm

 	.macro load_reg_offs reg, offs, load_mem_base=zero
 		lw   \reg, \offs*4(\load_mem_base)
 	.endm

 	.macro load_reg regn, load_mem_base=zero
 		lw   x\regn, \regn*4(\load_mem_base)
	.endm

   	.macro save_regs reg_first, reg_last, save_mem_base=zero
   		LOCAL regn
   		regn = \reg_first
   		.rept \reg_last - \reg_first + 1
   		save_reg %(regn), \save_mem_base
   		regn = regn+1
   		.endr
 	.endm

   	.macro load_regs reg_first, reg_last, load_mem_base=zero
   		LOCAL regn
   		regn = \reg_first
   		.rept \reg_last - \reg_first + 1
   		load_reg %(regn), \load_mem_base
   		regn = regn+1
   		.endr
   	.endm

   	.macro irq_save_regs
		addi sp, sp, -TRAP_REGS_SPACE
		save_reg 1, sp
    	save_regs 3, 15, sp
    	addi a0, sp, TRAP_REGS_SPACE
    	save_reg_offs a0, 2, sp 		## save original sp

    	## load trap handler args
    	csrr a0, mcause
    	csrr a1, mepc
    	mv   a2, sp
	.endm

	.macro irq_load_regs
		load_reg 1, sp
    	load_regs 3, 15, sp
    	load_reg 2, sp
	.endm

    .globl _start
    .globl startup_scr1
    .globl main
	.globl trap_handler

 .option norvc
 .section ".init.startup","ax",@progbits

_start:
	# init stack
	la    sp, __C_STACK_TOP__

	# set base trap vector
	la  a0, trap_entry
    csrw mtvec, a0

	call startup_scr1
	call main

.option norvc
.section ".init.traphandler","ax",@progbits

trap_entry:
	irq_save_regs
    call trap_handler
	irq_load_regs
    mret
