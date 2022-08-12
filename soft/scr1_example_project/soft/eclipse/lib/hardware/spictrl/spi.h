/*
 * spi.h
 *
 *  Created on: 23 июл. 2022 г.
 *      Author: nmari
 */

#ifndef HARDWARE_SPICTRL_SPI_H_
#define HARDWARE_SPICTRL_SPI_H_

#include "global_inc.h"
#include "chip.h"

/**
 * \brief Описание регистров SPI (см. файл GRLIB.pdf, стр. 1744)
 *
 */

typedef struct
{
    volatile uint32_t CAPABILITY0;         ///< 0x00  read only  register, setting up with generic
    volatile uint32_t CAPABILITY1;         ///< 0x04  read only  register, setting up with generic
    
    volatile uint32_t RESERVED0;           ///< 0x08
    volatile uint32_t RESERVED1;           ///< 0x0C
    volatile uint32_t RESERVED2;           ///< 0x10
    volatile uint32_t RESERVED3;           ///< 0x14
    volatile uint32_t RESERVED4;           ///< 0x18
    volatile uint32_t RESERVED5;           ///< 0x1C

    volatile uint32_t MODE;                ///< 0x20 read-write register, setting up operating mode
    volatile uint32_t EVENT;               ///< 0x24 read only  register, shows the completion of some conditions
    volatile uint32_t MASK;                ///< 0x28 read-write register, setting up the conditions for interrupts
    volatile uint32_t COMMAND;             ///< 0x2C read-write register, setting up SPI protocol
    volatile uint32_t TRANSMIT;            ///< 0x30 read-write register, stores data for transfer
    volatile uint32_t RECEIVE;             ///< 0x34 read only  register, stores received data
    volatile uint32_t SLAVESELECT;         ///< 0x38 read-write register, stores address of SPI slaves

    volatile uint32_t AM_SLAVESELECT;      ///< 0x3C *       
   
///< All subsequent registers for Automated periodic transfers

    volatile uint32_t AM_CONFIGURATION;    ///< 0x40 **
    volatile uint32_t AM_PERIOD;           ///< 0x44 **

    volatile uint32_t RESERVED6;           ///< 0x48
    volatile uint32_t RESERVED7;           ///< 0x4C

    volatile uint32_t AM_MASK0;            ///< 0x50 ***
    volatile uint32_t AM_MASK1;            ///< 0x54 ***
    volatile uint32_t AM_MASK2;            ///< 0x58 ***
    volatile uint32_t AM_MASK3;            ///< 0x5C ***

    volatile uint32_t VOIDSPACE [104];     ///< 0x60-0x1FC

    volatile uint32_t AM_TRANSMIT[128];    ///< 0x200-0x3FC ****
    volatile uint32_t AM_RECEIVE [128];    ///< 0x400-0x5FC ****
} spi_regs_s;

#define ADDR_SPI0                (APB1_SPI0_BA)                 ///< Определяем адрес SPI0 (см. chip.h)
#define SPI0                     ((spi_regs_s *)ADDR_SPI0)      ///< Выражение для болле удобного присвоения адреса spi_regs_s указателю
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	    ///< на область расположения hdl SPI структуры подобной spi_regs_s

// All registers below contain one property that address start from zero  
//      -------------------
// All registers below contain one property that always take up all 32 bits and and don't need the mask
// Mask is not defined because it uses a single command (frequency reduction)
//      -------------------

// CAPABILITY0 Register address of bit
// CAPABILITY0 Register mask

// MODE Register address of bit
#define SPI_MODE_LOOP_POS          (30u) ///< Core will operate in loopback mode
#define SPI_MODE_CPOL_POS          (29u) ///< Determines the polarity (idle state) of the SCK clock
#define SPI_MODE_CPHA_POS          (28u) ///< Determines when data will be read, 0 - first edge, 2 - second edge
#define SPI_MODE_DIV16_POS         (27u) ///< Changes the frequency, see the formula p.1741
#define SPI_MODE_REV_POS           (26u) ///< Determines how data is transmitted: 0 - LSB first, 1 - MSB first
#define SPI_MODE_MS_POS            (25u) ///< When this bit is set to 1 the core will act as a master
#define SPI_MODE_EN_POS            (24u) ///< When this bit is set to 1 the core is enabled, no registers can be changed
#define SPI_MODE_LEN_POS           (20u) ///< Determines the length in bits of a transfer on the SPI bus
#define SPI_MODE_PM_POS            (16u) ///< Changes the frequency, see the formula p.1741
#define SPI_MODE_FACT_POS          (13u) ///< Changes the frequency, see the formula p.1741
#define SPI_MODE_IGSEL_POS         (2u ) ///< Core will ignore the value of the SPI-SEL input
// MODE Register mask   
#define SPI_MODE_LOOP_MSK          (1u   << (SPI_MODE_LOOP_POS ))
#define SPI_MODE_CPOL_MSK          (1u   << (SPI_MODE_CPOL_POS ))
#define SPI_MODE_CPHA_MSK          (1u   << (SPI_MODE_CPHA_POS ))
#define SPI_MODE_DIV16_MSK         (1u   << (SPI_MODE_DIV16_POS))
#define SPI_MODE_REV_MSK           (1u   << (SPI_MODE_REV_POS  ))
#define SPI_MODE_MS_MSK            (1u   << (SPI_MODE_MS_POS   ))
#define SPI_MODE_EN_MSK            (1u   << (SPI_MODE_EN_POS   ))
#define SPI_MODE_LEN_MSK           (0xfu << (SPI_MODE_LEN_POS  ))
#define SPI_MODE_PM_MSK            (0xfu << (SPI_MODE_PM_POS   ))
#define SPI_MODE_FACT_MSK          (1u   << (SPI_MODE_FACT_POS ))
#define SPI_MODE_IGSEL_MSK         (1u   << (SPI_MODE_IGSEL_POS))
   
// EVENT Register address of bit  
#define SPI_EVENT_TIP_POS          (31u) ///< This bit is 1 when the core has a transfer in progress.
#define SPI_EVENT_OV_POS           (12u) ///< Core will ignore the value of the SPI-SEL input
#define SPI_EVENT_NE_POS           (9u ) ///< This bit is set when the receive queue contains one or more elements
#define SPI_EVENT_NF_POS           (8u ) ///< This bit is set when the transmit queue has room for one or more words
// EVENT Register mask   
#define SPI_EVENT_TIP_MSK          (1u   << (SPI_EVENT_TIP_POS ))
#define SPI_EVENT_OV_MSK           (1u   << (SPI_EVENT_OV_POS  ))
#define SPI_EVENT_NE_MSK           (1u   << (SPI_EVENT_NE_POS  ))
#define SPI_EVENT_NF_MSK           (1u   << (SPI_EVENT_NF_POS  ))

// MASK Register address of bit
#define SPI_MASK_TIPE_POS          (31u) ///< If this bit is set the core will generate an interrupt when the TIP bit in the Event is set
// MASK Register mask
#define SPI_MASK_TIPE_MSK          (1    << (SPI_MASK_TIPE_POS))

// COMMAND Register address of bit
   //Nothing need
// COMMAND Register mask

// TRANSMIT Register address of bit
   //All bits
// TRANSMIT Register mask

// RECEIVE Register address of bit
   //All bits
// RECEIVE Register mask

//#define SSSZ                       (1)                            ///< Number of slave
// SLAVESELECT Register address of bit
//#define SPI_SLAVESELECT_SLVSEL_POS (0u)                           ///< Slave select addres
// SLAVESELECT Register mask
//#define SPI_SLAVESELECT_SLVSEL_MSK ((uint32_t)(pow(2, SSSZ)-1))
#define SPI_SLAVESELECT_SLVSEL_MSK     (0xffffffff)

typedef enum
{
	SPI_LEN_32 = 0b0000 << SPI_MODE_LEN_POS,
	SPI_LEN_4  = 0b0011 << SPI_MODE_LEN_POS,
	SPI_LEN_5  = 0b0100 << SPI_MODE_LEN_POS,
	SPI_LEN_6  = 0b0101 << SPI_MODE_LEN_POS,
	SPI_LEN_7  = 0b0110 << SPI_MODE_LEN_POS,
	SPI_LEN_8  = 0b0111 << SPI_MODE_LEN_POS,
	SPI_LEN_9  = 0b1000 << SPI_MODE_LEN_POS,
	SPI_LEN_10 = 0b1001 << SPI_MODE_LEN_POS,
	SPI_LEN_11 = 0b1010 << SPI_MODE_LEN_POS,
	SPI_LEN_12 = 0b1011 << SPI_MODE_LEN_POS,
	SPI_LEN_13 = 0b1100 << SPI_MODE_LEN_POS,
	SPI_LEN_14 = 0b1101 << SPI_MODE_LEN_POS,
	SPI_LEN_15 = 0b1110 << SPI_MODE_LEN_POS,
	SPI_LEN_16 = 0b1111 << SPI_MODE_LEN_POS
} spi_transmitted_words_length;

void      SPI_Init            (spi_regs_s * const SPI);
   
void      SPI_LoopMode        (spi_regs_s * const SPI);
 
void      SPI_Set_Word_Lenght (spi_regs_s * const SPI, uint32_t SPI_LEN);

void      SPI_Set_Interrupt   (spi_regs_s * const SPI);

void      SPI_Set_Frequency   (spi_regs_s * const SPI, uint32_t DIV16, uint32_t PM, uint32_t FACT);

void      SPI_Slave_Select    (spi_regs_s * const SPI, uint32_t slv_addr);
 
void      SPI_Core_Enable     (spi_regs_s * const SPI);
  
uint32_t  SPI_Get_Capability  (spi_regs_s * const SPI);

uint32_t  SPI_Get_Event_TIP   (spi_regs_s * const SPI);
       
void      SPI_Send_Word       (spi_regs_s * const SPI, uint32_t p_data);
        
void      SPI_Send_n_Word     (spi_regs_s * const SPI, uint32_t * p_data, uint32_t len);
    
uint32_t  SPI_Read_Word       (spi_regs_s * const SPI);
    
void      SPI_Read_n_Word     (spi_regs_s * const SPI, uint32_t * p_data, uint32_t len);


#endif /* HARDWARE_SPICTRL_SPI_H_ */
