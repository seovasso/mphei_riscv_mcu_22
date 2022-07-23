/// Syntacore SCR* infra
///
/// @copyright (C) Syntacore 2015-2017. All rights reserved.
///
/// @brief Architecture specific defs and inlines

#ifndef _CORE_H_
#define _CORE_H_

#include "global_inc.h"

#define __TOSTR(s) #s
#define _TOSTR(s) __TOSTR(s)

// Machine Trap Setup Registers
#define CSR_MSTATUS		0x300
#define CSR_MISA		0x301
#define CSR_MIE			0x304
#define CSR_MTVEC		0x305

#define CSR_MSTATUS_MIE_Bit		(3)		// Global interrupt enable
#define CSR_MSTATUS_PMIE_Bit	(7)		// Previous global interrupt enable
#define CSR_MSTATUS_MPP_Bit		(11)	// Previous privilege mode (hardware to 3)

#define CSR_MISA_RVC_Bit		(2)		// Compressed instruction extension implemented
#define CSR_MISA_RVE_Bit		(4)		// RV32E base integer instruction set
#define CSR_MISA_RVI_Bit		(8)		// RV32I base integer instruction set
#define CSR_MISA_RVM_Bit		(12)	// Integer Multiply/Divide extension implemented
#define CSR_MISA_RVX_Bit		(23)	// Non-standard extensions
#define CSR_MISA_MXL_Bit		(30)	// Machine XLEN (hardwired to 1)

#define CSR_MIE_MSIE_Bit		(3)		// Machine Software Interrupt Enable
#define CSR_MIE_MIIE_Bit		(7)		// Machine Timer Interrupt Enable
#define CSR_MIE_MEIE_Bit		(11)	// Machine External Interrupt Enable

#define CSR_MTVEC_MODE_Bit		(0)		// Vector mode (0 - deirect mode, 1 - vectored)
#define CSR_MTVEC_VBA_Bit		(6)		// Vector base address (upper 26 bits)

// Machine Trap Handling Registers
#define CSR_MSCRATCH	0x340
#define CSR_MEPC		0x341
#define CSR_MCAUSE		0x342
#define CSR_MTVAL		0x343
#define CSR_MIP			0x344

#define CSR_MCAUSE_EC_Bit			(0)		// Exception Code
#define CSR_MCAUSE_INT_Bit			(31)	// Interrupt

#define CSR_MCAUSE_EC_MSI_Val		(3)		// Machine Soft Interrupt
#define CSR_MCAUSE_EC_MTI_Val		(7)		// Machine Timer Interrupt
#define CSR_MCAUSE_EC_MEI_Val		(11)	// Machine External Interrupt

#define CSR_MIP_MSIP_Bit		(3)		// Machine Software Interrupt Pending
#define CSR_MIP_MTIP_Bit		(7)		// Machine Timer Interrupt Pending
#define CSR_MIP_MEIP_Bit		(11)	// Machine External Interrupt Pending

// Non-Standart Registers
#define CSR_BRKM0		0x7C0
#define CSR_BRKM1		0x7C1
#define CSR_BRKM2		0x7C2
#define CSR_BRKM3		0x7C3
#define CSR_BRKM4		0x7C4
#define CSR_BRKM5		0x7C5
#define CSR_BRKM6		0x7C6
#define CSR_BRKM7		0x7C7
#define CSR_DBG_SCRATCH	0x7C8
#define CSR_MCOUNTEN	0x7E0

#define CSR_MCOUNTEN_CY_Bit		(0)		// Enable cycle counter
#define CSR_MCOUNTEN_IR_Bit		(2)		// Enable instructions-retired counter

// Machine Counters/Timers Registers
#define CSR_MCYCLE		0xB00
#define CSR_MINSTRET	0xB02
#define CSR_MCYCLEH		0xB80
#define CSR_MINSTRETH	0xB82

// IPIC Registers
#define IPIC_CISV		0xBF0
#define IPIC_CICSR		0xBF1
#define IPIC_IPR		0xBF2
#define IPIC_ISVR		0xBF3
#define IPIC_EOI		0xBF4
#define IPIC_SOI		0xBF5
#define IPIC_IDX		0xBF6
#define IPIC_ICSR		0xBF7

#define IPIC_CICSR_IP_Bit	(0)		// Interrupt pending (0 - no interrupt, 1 - interrupt pending)
#define IPIC_CICSR_IE_Bit	(1)		// Interrupt enable (0 - no interrupt, 1 - interrupt enable)

#define IPIC_ICSR_IP_Bit	(0)		// Interrupt pending (0 - no interrupt, 1 - interrupt pending)
#define IPIC_ICSR_IE_Bit	(1)		// Interrupt enable (0 - no interrupt, 1 - interrupt enable)
#define IPIC_ICSR_IM_Bit	(2)		// Interrupt mode (0 - level interrupt, 1 - edge interrupt)
#define IPIC_ICSR_INV_Bit	(3)		// Line inversion (0 - no inversion, 1 - line inversion)
#define IPIC_ICSR_IS_Bit	(4)		// In Service
#define IPIC_ICSR_PRV_Bit	(8)		// Privilege mode (hardware to 3)
#define IPIC_ICSR_LN_Bit	(12)	// External IRQ Line Number

// User Counters/Timers
#define CSR_CYCLE		0xC00
#define CSR_TIME		0xC01
#define CSR_INSTRET		0xC02
#define CSR_CYCLEH		0xC80
#define CSR_TIMEH		0xC81
#define CSR_INSTRETH	0xC82

// Machine Informations Registers
#define CSR_MVENDORID	0xF11
#define CSR_MARCHID		0xF12
#define CSR_MIMPID		0xF13
#define CSR_MHARTID		0xF14

#define CSR_MVENDORID_Val			(0x00)			// hardware set
#define CSR_MARCHID_Val				(0x00)			// hardware set
#define CSR_MIMPID_Val				(0x17101000)	//
#define CSR_MHARTID_Val				(0)				// is defined by external fuses


#define _IMM_5BIT_CONST(val) \
    (__builtin_constant_p(val) && (unsigned long)(val) < 32)
#define _IMM_ZERO_CONST(val) \
    (__builtin_constant_p(val) && (val) == 0)

#define read_csr(reg)                           \
    ({                                          \
        unsigned long __tmp;                    \
        asm volatile ("csrr %0, " _TOSTR(reg)   \
                      : "=r"(__tmp));           \
        __tmp;                                  \
    })

#define write_csr(reg, val)                                 \
    do {                                                    \
        if (_IMM_ZERO_CONST(val)) {                         \
            asm volatile ("csrw " _TOSTR(reg) ", zero" ::); \
        } else if (_IMM_5BIT_CONST(val)) {                  \
            asm volatile ("csrw " _TOSTR(reg) ", %0"        \
                          :: "i"(val));                     \
        } else {                                            \
            asm volatile ("csrw " _TOSTR(reg) ", %0"        \
                          :: "r"(val));                     \
        }                                                   \
    } while (0)

#define swap_csr(reg, val)                                  \
    ({                                                      \
        unsigned long __tmp;                                \
        if (_IMM_ZERO_CONST(val)) {                         \
            asm volatile ("csrrw %0, " _TOSTR(reg) ", zero" \
                          :  "=r"(__tmp) :);                \
        } else if (_IMM_5BIT_CONST(val)) {                  \
            asm volatile ("csrrw %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "i"(val));        \
        } else {                                            \
            asm volatile ("csrrw %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "r"(val));        \
        }                                                   \
        __tmp;                                              \
    })

#define set_csr(reg, bit)                                   \
    ({                                                      \
        unsigned long __tmp;                                \
        if (_IMM_5BIT_CONST(bit)) {                         \
            asm volatile ("csrrs %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "i"(bit));        \
        } else {                                            \
            asm volatile ("csrrs %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "r"(bit));        \
        }                                                   \
        __tmp;                                              \
    })

#define clear_csr(reg, bit)                                 \
    ({                                                      \
        unsigned long __tmp;                                \
        if (_IMM_5BIT_CONST(bit)) {                         \
            asm volatile ("csrrc %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "i"(bit));        \
        } else {                                            \
            asm volatile ("csrrc %0, " _TOSTR(reg) ", %1"   \
                          : "=r"(__tmp) : "r"(bit));        \
        }                                                   \
        __tmp;                                              \
    })

#define rdtime() 			read_csr(time)
#define rdcycle() 			read_csr(cycle)
#define rdinstret() 		read_csr(instret)

static inline void __enable_irq()
{
	write_csr(CSR_MIE, (1 << CSR_MIE_MSIE_Bit) | (1 << CSR_MIE_MEIE_Bit));
	write_csr(CSR_MSTATUS, (1 << CSR_MSTATUS_MIE_Bit));
}

static inline void __disable_irq()
{
	write_csr(CSR_MIE, 0);
	write_csr(CSR_MSTATUS, 0);
}

static inline unsigned long __attribute__((const)) arch_isa(void)
{
  unsigned long res;
  asm ("csrr %0, misa" : "=r"(res));
  return res;
}

static inline unsigned long __attribute__((const)) arch_impid(void)
{
  unsigned long res;
  asm ("csrr %0, mimpid" : "=r"(res));
  return res;
}

static inline unsigned long __attribute__((const)) arch_hartid(void)
{
  unsigned long res;
  asm ("csrr %0, mhartid" : "=r"(res));
  return res;
}

static inline unsigned long __attribute__((const)) arch_badaddr(void)
{
  unsigned long res;
  asm ("csrr %0, 0x343" : "=r"(res));
  return res;
}

static inline void ifence(void)		{asm volatile ("fence.i" ::: "memory");}
static inline void fence(void)		{asm volatile ("fence" ::: "memory");}
static inline void wfi(void) 		{asm volatile ("wfi" ::: "memory");}

void __attribute__((noreturn)) _hart_halt(void);

/* TIMER START */

#define CTIMER_BA                               (0x00490000)

typedef struct
{
    uint32_t Control;
    uint32_t Divider;
    uint32_t MTime;
    uint32_t MTimeH;
    uint32_t MTimeCmp;
    uint32_t MTimeCmpH;
}CTimer_s;

#define CTIMER      ((volatile CTimer_s*)       CTIMER_BA)

//These inlines deal with timer wrapping correctly a,b must be unsigned int
#define TIME_AFTER(a,b) ((int32_t)((b) - (a)) < 0)
#define TIME_BEFORE(a,b)     TIME_AFTER(b,a)

#define RTC_TIMEBASE_DIVISOR ((SYS_CLK) / (RTC_HZ) - 1)

static inline unsigned int CTMR_GetUs(void)
{
    return rdtime();
}

static inline bool CTMR_UsTimerExpired(uint32_t usDeadline)
{
    return TIME_AFTER(CTMR_GetUs(), usDeadline);
}

static inline uint32_t CTMR_UsTimerStart(uint32_t us)
{
    return CTMR_GetUs() + us;
}

static inline void CTMR_DelayUs(unsigned int us)
{
    unsigned int t1 = CTMR_GetUs() + us;
    while(TIME_BEFORE(CTMR_GetUs(), t1));
}

static inline void CTMR_Init(void)
{
    CTIMER->MTime = 0;
    CTIMER->Divider = RTC_TIMEBASE_DIVISOR;
    CTIMER->MTime = 0;
    CTIMER->MTimeCmp = 0;
}

/* TIMER END */

#endif // _CORE_H_
