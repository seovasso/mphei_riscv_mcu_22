/*
 * uart.c
 *
 *  Created on: 19 июл. 2022 г.
 *      Author: Turyshev
 */


#include "apbuart/uart.h"

uart_regs_s * g_uart_dbg_instance = UART0;    // Номер UART, используемый для дебага. Меняется методом

static void _set_stop_bits_one(uart_regs_s * const UART);
static void _set_stop_bits_two(uart_regs_s * const UART);

static void UNUSED _set_stop_bits_one(uart_regs_s * const UART)
{
    UART->CONTROL &= ~(1 << UART_CTRL_NS_POS);
}

static void UNUSED _set_stop_bits_two(uart_regs_s * const UART)
{
    UART->CONTROL |= (1 << UART_CTRL_NS_POS);
}

uint32_t UART_GetControl(uart_regs_s * const UART)
{
    return UART->CONTROL;
}

void UART_Init(uart_regs_s * const UART, uart_br_e rate_to_set)
{
    UART->CONTROL = 0u; //~(UART_CTRL_TE_MSK | UART_CTRL_RE_MSK | UART_CTRL_TI_EN_MSK | UART_CTRL_RI_EN_MSK); //0x03;
//    DBG_MSG("Uart clk = %u", UART_CLK);
    UART->SCALER = (UART_CLK / ((rate_to_set * 8) + 7));
    _set_stop_bits_one(UART);
    UART->CONTROL |= (UART_CTRL_FIFO_EN_MSK | UART_CTRL_TE_MSK | UART_CTRL_RE_MSK);   //0x8003; //|= 0x03; //Включение передатчика и приёмника
}

void UART_SendByte(uart_regs_s * const UART, uint8_t byteToSend)
{
    UART->CONTROL |= 0x02; //На всякий случай включаем передатчик

    while ((UART->STATUS & (1 << 9)) == (1 << 9))
    {} //Ждём появления места в FIFO

    UART->DATA = ((uint32_t)byteToSend) & 0xFF;
}

uint8_t UART_ReadByte(uart_regs_s * const UART) // Поставить в обработку прерывания!
{
    return (uint8_t)((UART->DATA) & 0xFF);
}

uint32_t uart_read_n_bytes(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout)
{
    (void)timeout;  /// \todo Использовать timeout
    uint32_t err = 0;

    for(uint32_t rec_bytes = 0; rec_bytes < len; rec_bytes++)
    {
        ///Ожидание приёма байта
        while ((UART->STATUS & (1 << 0)) == 0)
        {}

        *(uint8_t *)(p_data + rec_bytes) = UART->DATA;
    }

    return err;
}

uint32_t uart_send_n_bytes(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout)
{
    (void)timeout;  /// \todo Использовать timeout

    uint32_t err = 0;

    for(uint32_t snt_bytes = 0; snt_bytes < len; snt_bytes++)
    {
        const uint8_t byte_to_send = *(uint8_t const *)(p_data + snt_bytes);

        UART_SendByte(UART, byte_to_send);
    }

    return err;
}

void uart_send_n_bytes_packets(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout,  uint32_t num_packets, uint32_t delay_between_packets)
{
    uint32_t one_packet_length = len / num_packets;
    for (uint32_t idx = 0; idx < num_packets; idx++)
    {
        uart_send_n_bytes(UART, one_packet_length, p_data + idx * one_packet_length, timeout);
        for(uint32_t i = 0; i < delay_between_packets; i++)
        {
            __asm volatile ("nop");
        }
    }
}

bool UART_BasicCommunicationTest(uart_regs_s * UART, uint32_t rate_to_set)
{
    bool retFlag = true;
    uint32_t rxByte = 0x01;
    uint32_t txByte = 0x00;

    UART_Init(UART, rate_to_set);

    UART->CONTROL |= (1 << 7); //Взводим LoopBack

    for ( ; txByte <= 0xFF ; txByte++)
    {
        UART_SendByte(UART, (uint8_t)txByte);

        while ((UART->STATUS & (1 << 0)) == 0)
        {}

        rxByte = (uint32_t)UART_ReadByte(UART);

        if (rxByte != txByte)
        {
            retFlag = false;
            break;
        }
    }

    UART->CONTROL &= (~(1 << 7));

    return retFlag;
}

void UART_SendString(uart_regs_s * const UART, uint8_t const * strToSend_p, uint32_t Length)
{
    for(uint16_t chrCntr = 0 ; chrCntr < Length ; chrCntr++)
    {
        UART_SendByte(UART, *strToSend_p);

        if (chrCntr < (Length-1))
        {
            strToSend_p++;
        }
    }
}

void UART_SendChar(const char c) ///< Функция введена для совместимости с функцией CustomPrintf
{
    UART_SendByte(g_uart_dbg_instance, (uint8_t)c);
}

#if 0
/// \brief Задаёт инстанс UART для функции printf, используемой для дебага
/// \param uart_instance_ptr Указатель на UART
void uart_set_instance_for_printf(uart_regs_s * const uart_instance_ptr)
{
    if ((uart_instance_ptr != UART0) &&
       ((uart_instance_ptr != UART1)))
    {
        DBG_ERR("Incorr UART Instance: 0x%08X", uart_instance_ptr);
    }
    else
    {
        g_uart_dbg_instance = uart_instance_ptr;
    }
}
#endif

uint8_t uart_chk_tx_fifo(uart_regs_s * const UART)
{
    uint8_t fifo_tx_cnt = ((UART->STATUS) >> 20) & 0x3F;
    return fifo_tx_cnt;
}

/// \brief Проверяет, что RX FIFO пустой
/// \return true - пустой; false - не пустой
bool uart_is_rx_fifo_empty(uart_regs_s * const UART)
{
    if (0u == ((UART->STATUS >> UART_STATUS_RCNT_POS) & UART_STATUS_RCNT_MSK))
    {
        return true;
    }
    else
    {
        return false;
    }
}
