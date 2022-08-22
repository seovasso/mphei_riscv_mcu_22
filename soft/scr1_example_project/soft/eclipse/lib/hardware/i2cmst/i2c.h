
#ifndef HARDWARE_I2C_H_
#define HARDWARE_I2C_H_

#include "global_inc.h"
#include "chip.h"



typedef struct
{
    volatile uint32_t PRESCALE;	   ///< 0x00  clock presc	ale register
    volatile uint32_t CONTROL;             ///< 0x04  control register
    volatile uint32_t TRANSMIT;            ///< 0x08  transmit register
    volatile uint32_t RECEIVE;             ///< 0x08  receive register
    volatile uint32_t COMMAND;             ///< 0x0C  command register
    volatile uint32_t STATUS;              ///< 0x0c  status register
    volatile uint32_t DYNAMIC;             ///< 0x10  dynamic field register

} i2c_regs_s;

#define ADDR_I2C                (APB1_I2C0_BA)                  ///< Определяем адрес SPI0 (см. chip.h)
#define I2C0                     ((i2c_regs_s *)ADDR_I2C)      ///< Выражение для болле удобного присвоения адреса spi_regs_s указателю
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	    ///< на область расположения hdl SPI структуры подобной spi_regs_s

// All registers below contain one property that address start from zero  
//      -------------------
// All registers below contain one property that always take up all 32 bits and and don't need the mask
// Mask is not defined because it uses a single command (frequency reduction)


// MODE Register address of bit
#define I2C_PRESCALE_CP_POS        (7u) 
#define I2C_CONTROL_EN_POS         (7u) 
#define I2C_CONTROL_IEN_POS        (6u) 
#define I2C_TRANSMIT_RW_POS        (0u) 
#define I2C_COMMAND_STA_POS        (7u) 
#define I2C_COMMAND_STO_POS        (6u) 
#define I2C_COMMAND_RD_POS         (5u) 
#define I2C_COMMAND_WR_POS         (4u) 
#define I2C_COMMAND_ACK_POS        (3u) 
#define I2C_STATUS_TIP_POS         (1u) 
#define I2C_STATUS_RACK_POS        (7u) 

// MODE Register mask   
#define I2C_PRESCALE_CP_MSK      (0xfu   << (I2C_PRESCALE_CP_POS ))
#define I2C_CONTROL_EN_MSK       (1u     << (I2C_CONTROL_EN_POS ))
#define I2C_CONTROL_IEN_MSK      (1u     << (I2C_CONTROL_IEN_POS))
#define I2C_TRANSMIT_RW_MSK      (1u     << (I2C_TRANSMIT_RW_POS))
#define I2C_COMMAND_STA_MSK      (1u     << (I2C_COMMAND_STA_POS))
#define I2C_COMMAND_STO_MSK      (1u     << (I2C_COMMAND_STO_POS))
#define I2C_COMMAND_RD_MSK       (1u     << (I2C_COMMAND_RD_POS ))
#define I2C_COMMAND_WR_MSK       (1u     << (I2C_COMMAND_WR_POS ))
#define I2C_COMMAND_ACK_MSK      (1u     << (I2C_COMMAND_ACK_POS))
#define I2C_STATUS_TIP_MSK       (1u     << (I2C_STATUS_TIP_POS  ))
#define I2C_STATUS_RACK_MSK      (1u     << (I2C_STATUS_RACK_POS  ))


void      I2C_Init            (i2c_regs_s * const I2C);
		
void      I2C_Set_Frequency   (i2c_regs_s * const I2C, uint32_t PRESCALE);

void      I2C_Core_Enable     (i2c_regs_s * const I2C);

void      I2C_Interrupts_Enable     (i2c_regs_s * const I2C);

void      I2C_StartCond_Enable     (i2c_regs_s * const I2C);

//void      I2C_Write_Data     (i2c_regs_s * const I2C);

void      I2C_Write_n_Data     (i2c_regs_s * const I2C, uint32_t * p_data);

void      I2C_StopCond_Enable     (i2c_regs_s * const I2C);


#endif 
