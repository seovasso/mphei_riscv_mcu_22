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
	Spi_Irq_Handler,
	Uart_Irq_Handler,
	Gpio_Irq_Handler,
	Timer1_Irq_Handler,
	Timer2_Irq_Handler,
	0,0,0,0,0,0,0,0,0,0,
	Nothing
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

//#define INTERRUPT_COUNT_ADDR ((uint32_t*)0xf000ffb8u)

volatile uint32_t * interrupt_count_spi    = (uint32_t*)0xf000ffc8u;
volatile uint32_t * interrupt_count_uart   = (uint32_t*)0xf000ffccu;
volatile uint32_t * interrupt_count_gpio   = (uint32_t*)0xf000ffd0u;
volatile uint32_t * interrupt_count_timer1 = (uint32_t*)0xf000ffd4u;
volatile uint32_t * interrupt_count_timer2 = (uint32_t*)0xf000ffd8u;

// volatile uint32_t interrupt_count_spi   = (volatile uint32_t)0xf000ffC4u;
// volatile uint32_t interrupt_count_uart  = (volatile uint32_t)0xf000ffC0u;
// volatile uint32_t interrupt_count_gpio  = (volatile uint32_t)0xf000ffBCu;
// volatile uint32_t interrupt_count_timer = (volatile uint32_t)0xf000ffB8u;

void Nothing(void)
{
	write_csr(IPIC_EOI, 1);
}

void Reset_Interrupt_Count(void)
{
	//write_csr(IPIC_EOI, 1); // Пытался прекратить текущую обработку
	*interrupt_count_spi    = 0;
    *interrupt_count_uart   = 0;
    *interrupt_count_gpio   = 0;
    *interrupt_count_timer1 = 0;
	*interrupt_count_timer2 = 0;
}

void Spi_Irq_Handler (void) // 16-я функция
{
    *interrupt_count_spi++;
}

void Uart_Irq_Handler (void)
{
    *interrupt_count_uart++;
}

void Gpio_Irq_Handler (void)
{
    *interrupt_count_gpio++;
}

void Timer1_Irq_Handler (void)
{
    *interrupt_count_timer1++;
}

void Timer2_Irq_Handler (void)
{
    *interrupt_count_timer2++;
}

void init_ipic(uint8_t ipic_vector)
{
    //timer is initialized to not cause timer-interrupts in this test (after __enable_irq())
    CTIMER->Control = 0;
    CTIMER->MTime = 0;
    CTIMER->MTimeH = 0;
    CTIMER->MTimeCmp = 100; 
    CTIMER->MTimeCmpH = 0;
    write_csr(IPIC_IDX, ipic_vector);
    write_csr(IPIC_CICSR, 0x02);
    write_csr(IPIC_ICSR, (1 << IPIC_ICSR_IE_Bit) | (1 << IPIC_ICSR_IM_Bit));
}

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
