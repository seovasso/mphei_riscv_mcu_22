#include "global_inc.h"
#include "apbuart/uart.h"
#include "core_scr1/core_scr1.h"


#define BUFFER_SIZE_WORDS	(30)

#define _STOP_BYTE_VAL      (0x55)
#define _TEST_SIZE_BYTES    (100u)

uint32_t src[BUFFER_SIZE_WORDS];
uint32_t dst[BUFFER_SIZE_WORDS];

int main(void)
{

//  UART example
//	UART_Init(UART, brate);
//
//	 while (rw_data != _STOP_BYTE_VAL)
//	{
//		while (!(UART->STATUS & UART_STATUS_DR_MSK))
//		{}
//		rw_data = UART->DATA;
//	}
//
//	while (bytes_received < _TEST_SIZE_BYTES)
//	{
//		while (!(UART->STATUS & UART_STATUS_DR_MSK))
//		{}
//
//		rw_data = UART->DATA;
//
//		while(UART->STATUS & UART_STATUS_TF_MSK)
//		{}
//
//		UART->DATA = rw_data;
//
//		bytes_received++;
//	}
//  for (uint32_t i = 0; i < BUFFER_SIZE_WORDS; i++)
//  {
//      src[i] = i;
//  }
//  memcpy(dst, src, sizeof(dst));

//*/  Test UART

	uart_regs_s * const UART       = UART0;                   // pointer to UART structure, returns address of beginning this structure
    uint32_t            brate      = UART_BR_921600;          // bit rate
    uint8_t             data       = 100;                     // test data to transfer

    uint32_t            p_data[4]  = {4056, 105, 39, 25};     // array of data to transfer
    uint32_t            len        = 2;                       // number bit of the array to transfer
    uint32_t            timeout    = 0;                       // timeout ???

    // Initialization of UART, and rate of transfer (brate)
    UART_Init(UART, brate);

    UART_SendByte (UART, data);

    // should transmit just 1 word - 46, because len = 4 (transfer just 4 byte)
    uart_send_n_bytes (UART, len, p_data, timeout);
    
    //data = UART_ReadByte (UART);

    uart_read_n_bytes (UART, 1, p_data, timeout);

//*/


    while(1)
    {
        __asm("nop");
    }
}
