/*
 * timer.h
 *
 *  Created on: 28 июл. 2022 г.
 *      Author: nmari
 */

#ifndef HARDWARE_GPTIMER_TIMER_H_
#define HARDWARE_GPTIMER_TIMER_H_

#include "global_inc.h"
#include "chip.h"

/**
 * \brief Описание регистров SPI (см. файл GRLIB.pdf, стр. 1744)
 *
 */

typedef struct
{
	// n = 1:7
	volatile uint32_t COUNTER;      ///< 0xn0 read-write register, timer Counter value. Decremented by 1 for each prescaler tick
	volatile uint32_t RELOAD;       ///< 0xn4 read-write register, timer Reload value
	volatile uint32_t CONTROL;      ///< 0xn8 read-write register, set up operating mode for this timers
	volatile uint32_t LATCH;        ///< 0xnC read only  register, latched timer counter value
} timer_s;

typedef struct
{
	volatile uint32_t SCALER_VALUE;        ///< 0x00 read-write register, scaler value register
	volatile uint32_t SCALER_RELOAD;       ///< 0x04 read-write register, scaler reload value. Writes to this register also set the scaler value.
	volatile uint32_t CONFIGURATION;       ///< 0x08 read-write register, set up operating mode for all timers
	volatile uint32_t LATCH_CONFIGURATION; ///< 0x0C read-write register, set up interrupt vector for latching
 
	timer_s TIM[7];
	
} timer_regs_s;

#define ADDR_TIMER0                       (APB1_TIMER0_BA)                ///< Определяем адрес SPI0 (см. chip.h)
#define TIMER0                            ((timer_regs_s *)ADDR_TIMER0)   ///< Выражение для болле удобного присвоения адреса spi_regs_s указателю
 	 	 	 	 	 	 	 	 	   	 	 	 	 	 	            ///< на область расположения hdl SPI структуры подобной spi_regs_s

// #define TIMEREN                          (2)                           ///< Namber of bits
// #define TIMEREN_MSK                      (pow(2, NBITS)-1)              ///< Mask for those registers that depend on the number of bits    

// All registers below contain one property that address start from zero  
#define TIMER_SCALER_VALUE_MSK            (0xffffu)
#define TIMER_SCALER_RELOAD_MSK           (0xffffu)
// All registers below contain one property that always take up all 32 bits and and don't need the mask
// Mask is not defined because it uses a single command (frequency reduction)
//      LATCH_CONFIGURATION
// Also for all timers registers except CONTROL register
//      TIMER_COUNTER
//      TIMER_RELOAD
//      TIMER_LATCH 

// CONFIGURATION Register address of bit
#define TIMER_CONFIGURATION_TIMEREN_POS   (16u)    ///< Writing 1 to one of this bits sets the enable bit in the corresponding timers control register
#define TIMER_CONFIGURATION_EV_POS        (13u)    ///< If set then the latch events are taken from the secondary input
#define TIMER_CONFIGURATION_ES_POS        (12u)    ///< If set, on the next matching interrupt, the timers will be loaded with the corresponding timer reload values
#define TIMER_CONFIGURATION_EL_POS        (10u)    ///< If set, on the next matching interrupt, the latches will be loaded with the corresponding timer values
#define TIMER_CONFIGURATION_EE_POS        (10u)    ///< If set the prescaler is clocked from the external clock source
#define TIMER_CONFIGURATION_DF_POS        (9u )    ///< If set the timer unit can not be freezed
#define TIMER_CONFIGURATION_SI_POS        (8u )    ///< read-only, Separate interrupts
#define TIMER_CONFIGURATION_IRQ_POS       (3u )    ///< read-only, APB interrupts
#define TIMER_CONFIGURATION_TIMERS_POS    (0u )    ///< read-only, Number of implemented timers
// CONFIGURATION Register mask     
#define TIMER_CONFIGURATION_TIMEREN_MSK   (0x7fu   << (TIMER_CONFIGURATION_TIMEREN_POS ))
#define TIMER_CONFIGURATION_EV_MSK        (1u      << (TIMER_CONFIGURATION_EV_POS      ))
#define TIMER_CONFIGURATION_ES_MSK        (1u      << (TIMER_CONFIGURATION_ES_POS      ))
#define TIMER_CONFIGURATION_EL_MSK        (1u      << (TIMER_CONFIGURATION_EL_POS      ))
#define TIMER_CONFIGURATION_EE_MSK        (1u      << (TIMER_CONFIGURATION_EE_POS      ))
#define TIMER_CONFIGURATION_DF_MSK        (1u      << (TIMER_CONFIGURATION_DF_POS      ))
#define TIMER_CONFIGURATION_SI_MSK        (1u      << (TIMER_CONFIGURATION_SI_POS      ))
#define TIMER_CONFIGURATION_IRQ_MSK       (0x1fu   << (TIMER_CONFIGURATION_IRQ_POS     ))
#define TIMER_CONFIGURATION_TIMERS_MSK    (7u      << (TIMER_CONFIGURATION_TIMERS_POS  ))
 
// This mask is common for all timers 
// TIMER_CONTROL Register address of bit 
#define TIMER_TIMER_CONTROL_WDOGWINC_POS  (16u)    ///< Reload value for the watchdog window counter
#define TIMER_TIMER_CONTROL_WS_POS        (8u )    ///< If this field is set to 1 then the GPTO.WDOG and GPTO.WDOGN outputs are disabled 
#define TIMER_TIMER_CONTROL_WN_POS        (7u )    ///< If this field is set to 1 then the watchdog timer will also generate a non-maskable interrupt when an interrupt is signalled
#define TIMER_TIMER_CONTROL_DH_POS        (6u )    ///< read-only, Value of GPTI.DHALT signal which is used to freeze counters
#define TIMER_TIMER_CONTROL_CH_POS        (5u )    ///< If set for timer n, timer n will be decremented each time when timer (n-1) underflows
#define TIMER_TIMER_CONTROL_IP_POS        (4u )    ///< The core sets this bit to 1 when an interrupt is signalled. This bit remains 1 until cleared by writing 1 to this bit
#define TIMER_TIMER_CONTROL_IE_POS        (3u )    ///< If set the timer signals interrupt when it underflows
#define TIMER_TIMER_CONTROL_LD_POS        (2u )    ///< Load value from the timer reload register to the timer counter value register
#define TIMER_TIMER_CONTROL_RS_POS        (1u )    ///< If set, the timer counter value register is reloaded with the value of the reload register when the timer underflows 
#define TIMER_TIMER_CONTROL_EN_POS        (0u )    ///< Enable the timer
// TIMER_CONTROL Register mask  
#define TIMER_TIMER_CONTROL_WDOGWINC_MSK  (0xffffu << (TIMER_TIMER_CONTROL_WDOGWINC_POS))
#define TIMER_TIMER_CONTROL_WS_MSK        (1u      << (TIMER_TIMER_CONTROL_WS_POS      ))
#define TIMER_TIMER_CONTROL_WN_MSK        (1u      << (TIMER_TIMER_CONTROL_WN_POS      ))
#define TIMER_TIMER_CONTROL_DH_MSK        (1u      << (TIMER_TIMER_CONTROL_DH_POS      ))
#define TIMER_TIMER_CONTROL_CH_MSK        (1u      << (TIMER_TIMER_CONTROL_CH_POS      ))
#define TIMER_TIMER_CONTROL_IP_MSK        (1u      << (TIMER_TIMER_CONTROL_IP_POS      ))
#define TIMER_TIMER_CONTROL_IE_MSK        (1u      << (TIMER_TIMER_CONTROL_IE_POS      ))
#define TIMER_TIMER_CONTROL_LD_MSK        (1u      << (TIMER_TIMER_CONTROL_LD_POS      ))
#define TIMER_TIMER_CONTROL_RS_MSK        (1u      << (TIMER_TIMER_CONTROL_RS_POS      ))
#define TIMER_TIMER_CONTROL_EN_MSK        (1u      << (TIMER_TIMER_CONTROL_EN_POS      ))

void      TIMER_Init_All_Timers    (timer_regs_s * const TIMER); // set TIMER_CONFIGURATION_TIMEREN_MSK
   
void      TIMER_Set_Scaler_Value   (timer_regs_s * const TIMER, uint32_t value);
  
void      TIMER_Set_Scaler_Reload  (timer_regs_s * const TIMER, uint32_t value);

uint32_t  TIMER_Get_Configuration  (timer_regs_s * const TIMER);

void      TIMER_Init_Timer         (timer_regs_s * const TIMER, uint8_t timer_n);
  
void      TIMER_Set_Timer_Counter  (timer_regs_s * const TIMER, uint8_t timer_n, uint32_t value);
  
void      TIMER_Set_Timer_Reload   (timer_regs_s * const TIMER, uint8_t timer_n, uint32_t value);

uint32_t  TIMER_Get_Timer_Latch    (timer_regs_s * const TIMER, uint8_t timer_n);


#endif /* HARDWARE_GPTIMER_TIMER_H_ */
