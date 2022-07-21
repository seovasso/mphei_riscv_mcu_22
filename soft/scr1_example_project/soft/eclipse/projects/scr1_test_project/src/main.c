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
	// Пример работы с юартом (рабочий код из теста микросхемы): в while на 27 строке ждем _STOP_BYTE_VAL пришедший по UART (работает RX).
	// Далее в while на 34 ждем приема _TEST_SIZE_BYTES и отправляем эти байты в UART TX.
	// Твоя задача просто отправить в UART какую-нибудь константу (берем 44 строчку (UART->DATA = rw_data;) и пишем константу )

//	uint32_t brate = UART_BR_921600;
//	uart_regs_s * const UART = UART0;
//	uint8_t rw_data = 0;
//	uint32_t bytes_received = 0;
//
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

	/* Place your code here */

    for (uint32_t i = 0; i < BUFFER_SIZE_WORDS; i++)
    {
    	src[i] = i;
    }

    memcpy(dst, src, sizeof(dst));

    while(1)
    {
    	__asm("nop");
    }
}
