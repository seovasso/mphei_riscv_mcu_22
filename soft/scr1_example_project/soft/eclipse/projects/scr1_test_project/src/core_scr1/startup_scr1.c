#include <stdint.h>
#include "core_scr1.h"

extern unsigned int _sbss;
extern unsigned int _ebss;
extern unsigned int _sdata;
extern unsigned int _edata;
extern unsigned int _ldata;

#include "global_defs.h"

static void Default_Handler(__unused const char* message) {}

#define WEAK __attribute__ ((weak))

void WEAK MSoftware_Handler(void);
void WEAK MTimer_Handler(void);

void WEAK InstrAddrMisalign_Handler(void)	{Default_Handler("\nInstrAddrMisalign_Handler()\n");}
void WEAK InstrAccess_Handler(void)			{Default_Handler("\nInstrAccess_Handler()\n");}
void WEAK IllegalInstr_Handler(void)		{Default_Handler("\nIllegalInstr_Handler()\n");}
void WEAK Breakpoint_Handler(void)			{Default_Handler("\nBreakPoint_Handler()\n");}
void WEAK LoadAddrMisalign_Handler(void)	{Default_Handler("\nLoadAddrMisalign_Handler()\n");}
void WEAK LoadAccess_Handler(void)			{Default_Handler("\nLoadAccess_Handler()\n");}
void WEAK StoreAddrMisalign_Handler(void)	{Default_Handler("\nStoreAddrMisalign_Handler()\n");}
void WEAK StoreAccess_Handler(void)			{Default_Handler("\nStoreAccess_Handler()\n");}
void WEAK Ecall_Handler(void) 				{Default_Handler("\nEcall_Handler()\n");}

static void (*ext_vector_table[])() =
{
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};__unused __unused

static void (*fault_vector_table[])() =
{
	InstrAddrMisalign_Handler,
	InstrAccess_Handler,
	IllegalInstr_Handler,
	Breakpoint_Handler,
	LoadAddrMisalign_Handler,
	LoadAccess_Handler,
	StoreAddrMisalign_Handler,
	StoreAccess_Handler,
	0,0,0,
	Ecall_Handler,
	0,0,0,0,0
};

void trap_handler(uint32_t mcause, uint32_t __unused mepc, __unused  uint32_t * regs)
{
	uint32_t exCode = mcause & 0x1F;
	if (mcause & (1 << CSR_MCAUSE_INT_Bit))
	{
		switch(exCode)
		{
			case CSR_MCAUSE_EC_MEI_Val: {
				uint32_t irqVect = read_csr(IPIC_CISV);
				ext_vector_table[irqVect]();
			}break;
			case CSR_MCAUSE_EC_MSI_Val: {MSoftware_Handler();} break;
			case CSR_MCAUSE_EC_MTI_Val: {MTimer_Handler();} break;
		}
	}
	else
	{

		fault_vector_table[exCode]();

		while(1){}
	}
}

void startup_scr1()
{
	// clear bss
	volatile uint32_t* bss = (uint32_t*) &_sbss;

	while(bss < (uint32_t*) &_ebss)
	{
		*bss = 0;
		bss++;
	}

	// data init
	volatile uint32_t* rom_src = (uint32_t*) &_ldata;
	volatile uint32_t* ram_data = (uint32_t*) &_sdata;

	while(ram_data < (uint32_t*) &_edata)
	{
		*ram_data = *rom_src;
		ram_data++;
		rom_src++;
	}
}
