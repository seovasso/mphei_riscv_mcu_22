#include "i2cmst/i2c.h"
#include "apbuart/uart.h"

void      I2C_Init         (i2c_regs_s * const I2C)
{
	I2C->CONTROL          = 0u;
	I2C->COMMAND          = 0u;
	I2C->STATUS           = 0u;
	I2C->PRESCALE         = 0u;
}

void      I2C_Set_Frequency   (i2c_regs_s * const I2C, uint32_t PRESCALE)
{

	I2C->PRESCALE |= I2C_PRESCALE_CP_MSK  & (PRESCALE  << (I2C_PRESCALE_CP_POS ));
}


void      I2C_Core_Enable     (i2c_regs_s * const I2C)			//1
{
	I2C->CONTROL |= I2C_CONTROL_EN_MSK;
}

void      I2C_Interrupts_Enable     (i2c_regs_s * const I2C)	//1
{
	I2C->CONTROL |= I2C_CONTROL_IEN_MSK;
}

void      I2C_StartCond_Enable     (i2c_regs_s * const I2C)		//2
{
	I2C->COMMAND |= I2C_COMMAND_STA_MSK;
}

//void      I2C_Write_Data     (i2c_regs_s * const I2C)
//{
//    while((I2C -> I2C_STATUS_TIP_MSK & STATUS != I2C_STATUS_TIP_MSK)
//	{
//		{} // waiting for a place to appear in the queue
//		if ((I2C -> I2C_STATUS_RACK_MSK & STATUS) != I2C_STATUS_RACK_MSK)
//		{
//			I2C->TRANSMIT = p_data;
//		}
//	}
//}

void      I2C_Write_n_Data     (i2c_regs_s * const I2C, uint32_t * p_data)
{
    for(uint32_t word = 0; word < 8; word++)
    {
        I2C_Write_Data(I2C, *(p_data + word));
    }
}

void      I2C_StopCond_Enable     (i2c_regs_s * const I2C)	
{
    I2C->COMMAND |= I2C_COMMAND_STO_MSK;
	I2C->COMMAND |= I2C_COMMAND_WR_MSK;
}




 
//uint32_t  SPI_Read_Word       (i2c_regs_s * const SPI)
//{
//    while((SPI->EVENT & SPI_EVENT_NE_MSK) != SPI_EVENT_NE_MSK)
//    {} // waiting for the word to appear in the queue
//    return SPI->RECEIVE;
//}
// 
//void      SPI_Read_n_Word     (spi_regs_s * const SPI, uint32_t * p_data, uint32_t len)
//{
//    for(uint32_t word = 0; word < len; word++)
//    {
//        p_data += word;
//        *p_data = SPI_Read_Word(SPI);
//    }
//}
