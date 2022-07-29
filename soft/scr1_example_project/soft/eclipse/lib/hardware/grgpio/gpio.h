/*
 * gpio.h
 *
 *  Created on: 27 июл. 2022 г.
 *      Author: nmari
 */

#ifndef HARDWARE_GRGPIO_GPIO_H_
#define HARDWARE_GRGPIO_GPIO_H_

#include "global_inc.h"
#include "chip.h"

/**
 * \brief Описание регистров GPIO (см. файл GRLIB.pdf, стр. 711)
 *
 */

typedef struct
{
    volatile uint32_t DATA;                ///< 0x00 read only  register, stores received data
    volatile uint32_t OUTPUT;              ///< 0x04 read-write register, stores data for transfer
    volatile uint32_t DIRECTION;           ///< 0x08 read-write register, allows OUTPUT register to transmit data via I/O pins 
    volatile uint32_t INTR_MASK;           ///< 0x0C read-write register, allows to generate interrupt on I/O pins
    volatile uint32_t INTR_POLARITY;       ///< 0x10 read-write register
    volatile uint32_t INTR_EDGE;           ///< 0x14 read-write register
    volatile uint32_t BYPASS;              ///< 0x18 read-write register, set up output mode (normal - 0 / alternativ - 1)
    volatile uint32_t CAPABILITY;          ///< 0x1C read only  register, setting up with generic
    volatile uint32_t INTR_MAP[8];         ///< 0x20-0x3C 
    volatile uint32_t INTR_AVAILABLE;      ///< 0x40 read only  register, setting up with generic
    volatile uint32_t INTR_FLAG;           ///< 0x44 read-write register, shows the bit that generated the interrupt
    volatile uint32_t INPUT_ENABLE;        ///< 0x48 read-write register, allows DATA register to receive data from I/O pins
    volatile uint32_t PULSE;               ///< 0x4C read-write register, inverts n bit in OUTPUT register whenever sig_in n bit is hight 

// The logical-OR/AND/XOR registers will update the corresponding register according to:
// New value = <Old value> logical-op <Write data>

    volatile uint32_t OR_INPUT_ENABLE;     ///< 0x50 
    volatile uint32_t OR_OUTPUT;           ///< 0x54 
    volatile uint32_t OR_DIRECTION;        ///< 0x58 
    volatile uint32_t OR_INTR_MASK;        ///< 0x5C 

    volatile uint32_t AND_INPUT_ENABLE;    ///< 0x60 
    volatile uint32_t AND_OUTPUT;          ///< 0x64 
    volatile uint32_t AND_DIRECTION;       ///< 0x68 
    volatile uint32_t AND_INTR_MASK;       ///< 0x6C 

    volatile uint32_t XOR_INPUT_ENABLE;    ///< 0x70 
    volatile uint32_t XOR_OUTPUT;          ///< 0x74 
    volatile uint32_t XOR_DIRECTION;       ///< 0x78 
    volatile uint32_t XOR_INTR_MASK;       ///< 0x82 
} gpio_regs_s;

#define ADDR_GPIO0                     (APB1_GPIO0_BA)                ///< Определяем адрес GPIO0 (см. chip.h)
#define GPIO0                          ((gpio_regs_s *)ADDR_GPIO0)    ///< Выражение для болле удобного присвоения адреса gpio_regs_s указателю

//#define NBITS                          (31)                           ///< Namber of bits
//#define NBITS_MSK                      (pow(2, NBITS)-1)              ///< Mask for those registers that depend on the number of bits    
#define NBITS_MSK                      (0x7fffffff)                   ///< Number of bits in GPIO

// All registers below contain one property that address start from zero  
#define GPIO_DATA_MSK                  (NBITS_MSK) 
#define GPIO_OUTPUT_MSK                (NBITS_MSK) 
#define GPIO_DIRECTION_MSK             (NBITS_MSK) 
#define GPIO_INTR_MASK_MSK             (NBITS_MSK) 
#define GPIO_INTR_POLARITY_MSK         (NBITS_MSK) 
#define GPIO_INTR_EDGE_MSK             (NBITS_MSK) 
#define GPIO_BYPASS_MSK                (NBITS_MSK) 
// All registers below contain one property that always take up all 32 bits and and don't need the mask
// Mask is not defined because it uses a single command (frequency reduction)
//      INTR_AVAILABLE
//      INTR_FLAG     
//      INPUT_ENABLE  
//      PULSE    
// Also for OR/AND/XOR Register
//      INPUT_ENABLE
//      OUTPUT     
//      DIRECTION  
//      INTR_MASK          

// CAPABILITY Register address of bit
   // read-only
// CAPABILITY Register mask 

// INTR_MAP Register address of bit
// INTR_MAP Register mask

//void      GPIO_Init            (gpio_regs_s * const GPIO);

void      GPIO_Set_Interrupt   (gpio_regs_s * const GPIO, uint32_t pins_to_set);

void      GPIO_Set_Bypass      (gpio_regs_s * const GPIO, uint32_t pins_to_set);

void      GPIO_Set_Transmit    (gpio_regs_s * const GPIO, uint32_t pins_to_set);

void      GPIO_Set_Reseiv      (gpio_regs_s * const GPIO, uint32_t pins_to_set);

uint32_t  GPIO_Get_Capability  (gpio_regs_s * const GPIO);
    
void      GPIO_Send_Data       (gpio_regs_s * const GPIO, uint32_t p_data);
    
uint32_t  GPIO_Read_Data       (gpio_regs_s * const GPIO);

#endif /* HARDWARE_GRGPIO_GPIO_H_ */
