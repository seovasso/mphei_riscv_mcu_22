#ifndef _GLOBAL_CONSTS_H_
#define _GLOBAL_CONSTS_H_

/**
 * Процессорно ядро под которое разрабатывается
 */
///@{
#define CORE_SCR1       1   ///< Ядро SCR1
#define CORE_SCR3       2   ///< Ядро SCR3
///@}

#define BITS_SET(reg, mask)             ((reg) |= (mask))
#define BITS_RESET(reg, mask)           ((reg) &= ~(mask))

#define ALIGN_MASK(x, mask)             (((x) + (mask)) & ~(mask))

#define UNUSED __attribute__ ((unused))

#define ALL_PIN_ON                      (0xFFFFFFFF)
#define ALL_PIN_OFF                     (0x00000000)

#endif // _GLOBAL_CONSTS_H_
