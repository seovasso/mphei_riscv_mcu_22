#include <stdint.h>
#include "core_scr1.h"
#include "grgpio\gpio.h"

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
	0,0,0,0,0,0,0,0,0,0,0
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

volatile uint32_t * interrupt_count_spi    = (uint32_t*)0xf0000000u;
volatile uint32_t * interrupt_count_uart   = (uint32_t*)0xf0000004u;
volatile uint32_t * interrupt_count_gpio   = (uint32_t*)0xf0000008u;
volatile uint32_t * interrupt_count_timer1 = (uint32_t*)0xf000000cu;
volatile uint32_t * interrupt_count_timer2 = (uint32_t*)0xf0000010u;

void Reset_Interrupt_Count(void)
{
	*interrupt_count_spi    = 0;
    *interrupt_count_uart   = 0;
    *interrupt_count_gpio   = 0;
    *interrupt_count_timer1 = 0;
	*interrupt_count_timer2 = 0;
}

void Spi_Irq_Handler (void) // 16-я функция
{
    *interrupt_count_spi = *interrupt_count_spi + 1;
}

void Uart_Irq_Handler (void)
{
	*interrupt_count_uart = *interrupt_count_uart + 1;
}

void Gpio_Irq_Handler (void)
{
    *interrupt_count_gpio = *interrupt_count_gpio + 1;
}

void Timer1_Irq_Handler (void)
{
    gpio_regs_s * GPIO = GPIO0;
	if(GPIO_Get_Output(GPIO) == ALL_PIN_OFF){
		GPIO_Send_Data(GPIO, ALL_PIN_ON);
	}
	else{
		GPIO_Send_Data(GPIO, ALL_PIN_OFF);
	}
}

void Timer2_Irq_Handler (void)
{
    *interrupt_count_timer2 = *interrupt_count_timer2 + 1;
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
    //write_csr(IPIC_CICSR, 0x02);
    write_csr(IPIC_ICSR, (1 << IPIC_ICSR_IE_Bit) | (1 << IPIC_ICSR_IM_Bit));
}

void trap_handler(uint32_t mcause, uint32_t __unused mepc, __unused  uint32_t * regs)
{
	write_csr(IPIC_SOI, 0x01);
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
	write_csr(IPIC_EOI, 0x01);
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
