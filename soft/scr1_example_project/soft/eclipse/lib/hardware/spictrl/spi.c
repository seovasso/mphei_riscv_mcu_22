/*
 * spi.c
 *
 *  Created on: 23 июл. 2022 г.
 *      Author: nmari
 */

#include "spictrl/spi.h"
#include "apbuart/uart.h"

void      SPI_Init         (spi_regs_s * const SPI)
{
    // reset all write registers
    SPI->MODE        = 0u;
    SPI->MASK        = 0u;
    SPI->COMMAND     = 0u;
    // individual setup (temporary code)
    SPI->MODE |= SPI_MODE_IGSEL_MSK | SPI_MODE_MS_MSK;  //master ignore input slave select signal
}
     
void      SPI_LoopMode        (spi_regs_s * const SPI)
{
	SPI->MODE |= SPI_MODE_LOOP_MSK;
}

void      SPI_Set_Word_Lenght (spi_regs_s * const SPI, uint32_t SPI_LEN)
{
	SPI->MODE &= (~SPI_MODE_LEN_MSK);
    SPI->MODE |=  SPI_LEN;
}

void      SPI_Set_Interrupt   (spi_regs_s * const SPI)
{
    SPI->MASK |= SPI_MASK_TIPE_MSK;
}

void      SPI_Set_Frequency   (spi_regs_s * const SPI, uint32_t DIV16, uint32_t PM, uint32_t FACT)
{
    SPI->MODE |= SPI_MODE_DIV16_MSK & (DIV16 << (SPI_MODE_DIV16_POS));
    SPI->MODE |= SPI_MODE_PM_MSK    & (PM    << (SPI_MODE_PM_POS   ));
    SPI->MODE |= SPI_MODE_FACT_MSK  & (FACT  << (SPI_MODE_FACT_POS ));
}

void      SPI_Slave_Select    (spi_regs_s * const SPI, uint32_t slv_addr)
{
    SPI->SLAVESELECT = SPI_SLAVESELECT_SLVSEL_MSK & slv_addr;
}

void      SPI_Core_Enable     (spi_regs_s * const SPI)
{
    SPI->MODE |= SPI_MODE_EN_MSK;
}

uint32_t  SPI_Get_Capability  (spi_regs_s * const SPI)
{
    return SPI->CAPABILITY0;
}

uint32_t  SPI_Get_Event_TIP   (spi_regs_s * const SPI)
{
    return (SPI->EVENT & SPI_EVENT_TIP_MSK);
}

void      SPI_Send_Word       (spi_regs_s * const SPI, uint32_t p_data)
{
    while((SPI->EVENT & SPI_EVENT_NF_MSK) != SPI_EVENT_NF_MSK)
    {} // waiting for a place to appear in the queue
    SPI->TRANSMIT = p_data;
}

void      SPI_Send_n_Word     (spi_regs_s * const SPI, uint32_t * p_data, uint32_t len)
{
    for(uint32_t word = 0; word < len; word++)
    {
        SPI_Send_Word(SPI, *(p_data + word));
    }
}
 
uint32_t  SPI_Read_Word       (spi_regs_s * const SPI)
{
    while((SPI->EVENT & SPI_EVENT_NE_MSK) != SPI_EVENT_NE_MSK)
    {} // waiting for the word to appear in the queue
    return SPI->RECEIVE;
}
 
void      SPI_Read_n_Word     (spi_regs_s * const SPI, uint32_t * p_data, uint32_t len)
{
    for(uint32_t word = 0; word < len; word++)
    {
        p_data += word;
        *p_data = SPI_Read_Word(SPI);
    }
}

