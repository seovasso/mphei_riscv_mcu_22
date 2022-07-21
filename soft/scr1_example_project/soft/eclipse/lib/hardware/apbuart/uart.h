/** \file
 *  \brief Заголовочный файл поддержки APB_UART
 * Содержит описание структуры регистров и базовые функции для управления UART
 */

#ifndef UART_H_
#define UART_H_
#include "global_inc.h"
#include "chip.h"

/**
 * \brief Описание регистров UART (см. файл grip.pdf, стр. 179)
 *
 */

typedef struct
{
    volatile uint32_t DATA;     ///< Регистр входных и выходных данных. Смещение относительно базового адреса - 0x00.
                                ///< Используются младшие восемь бит.
    volatile uint32_t STATUS;   ///< Регистр статуса, смещение 0x04
    volatile uint32_t CONTROL;  ///< Регистр управления, смещение 0x08.
                                ///< Для нас важны биты 0 (TxEn), 1 (RxEn) и 7 (LoopBackOn).
    volatile uint32_t SCALER;   ///< Регистр делителя частоты, определяет скорость. Смещение 0x0C
    volatile uint32_t FIFO;     ///< Регистр отладки через FIFO. Позволяет читать отсылаемые данные и писать принимаемые,
                                ///< имитируя обмен без посылок в линию (режим FIFO_DebugMode, CONTROL.11). Смещение 0x10
} uart_regs_s;

// CONTROL Register

#define UART_CTRL_FIFO_EN_POS   (31u)
#define UART_CTRL_NS_POS        (15u)   // Number of stop bits
#define UART_CTRL_TI_POS        (3u)    // Transmit Interrupt Enable
#define UART_CTRL_RI_POS        (2u)    // Receive Interrupt Enable
#define UART_CTRL_TE_POS        (1u)    // Transmit Enable
#define UART_CTRL_RE_POS        (0u)    // Receive Enable


#define UART_CTRL_FIFO_EN_MSK   (1u << (UART_CTRL_FIFO_EN_POS))
#define UART_CTRL_TI_EN_MSK     (1u << (UART_CTRL_TI_POS))
#define UART_CTRL_RI_EN_MSK     (1u << (UART_CTRL_RI_POS))

#define UART_CTRL_TE_MSK        (1u << (UART_CTRL_TE_POS))
#define UART_CTRL_RE_MSK        (1u << (UART_CTRL_RE_POS))

// STATUS Register
#define UART_STATUS_RCNT_POS    (26u)   ///< Receiver FIFO count
#define UART_STATUS_TCNT_POS    (20u)   ///< Transmitter FIFO count
#define UART_STATUS_RF_POS      (10u)   ///< Receiver FIFO full
#define UART_STATUS_TF_POS      (9u)    ///< Transmitter FIFO full
#define UART_STATUS_RH_POS      (8u)    ///< Receiver FIFO half-full
#define UART_STATUS_TH_POS      (7u)    ///< Transmitter FIFO half-full
#define UART_STATUS_FE_POS      (6u)    ///< Framing Error
#define UART_STATUS_PE_POS      (5u)    ///< Parity Error
#define UART_STATUS_OV_POS      (4u)    ///< Overrun
#define UART_STATUS_BR_POS      (3u)    ///< Break Received
#define UART_STATUS_TE_POS      (2u)    ///< Transmitter FIFO empty
#define UART_STATUS_TS_POS      (1u)    ///< Ttrasmitter Shift Register Empty
#define UART_STATUS_DR_POS      (0u)    ///< Data Ready


#define UART_STATUS_RCNT_MSK    (0x3Fu)
#define UART_STATUS_TCNT_MSK    (0x3Fu)
#define UART_STATUS_RF_MSK      (1u << (UART_STATUS_RF_POS))
#define UART_STATUS_TF_MSK      (1u << (UART_STATUS_TF_POS))
#define UART_STATUS_RH_MSK      (1u << (UART_STATUS_RH_POS))
#define UART_STATUS_TH_MSK      (1u << (UART_STATUS_TH_POS))
#define UART_STATUS_FE_MSK      (1u << (UART_STATUS_FE_POS))
#define UART_STATUS_PE_MSK      (1u << (UART_STATUS_PE_POS))
#define UART_STATUS_OV_MSK      (1u << (UART_STATUS_OV_POS))
#define UART_STATUS_BR_MSK      (1u << (UART_STATUS_BR_POS))
#define UART_STATUS_TE_MSK      (1u << (UART_STATUS_TE_POS))
#define UART_STATUS_TS_MSK      (1u << (UART_STATUS_TS_POS))
#define UART_STATUS_DR_MSK      (1u << (UART_STATUS_DR_POS))

typedef enum
{
    UART_BR_4800 = 4800u,
    UART_BR_9600 = 9600u,
    UART_BR_14400 = 14400u,
    UART_BR_19200 = 19200u,
    UART_BR_38400 = 38400u,
    UART_BR_57600 = 57600u,
    UART_BR_115200 = 115200u,
    UART_BR_230400 = 230400u,
    UART_BR_460800 = 460800u,
    UART_BR_921600 = 921600u
} uart_br_e;

#define ADDR_UART0          APB1_UART0_BA ///< Определяем адрес UART0 (см. chip.h)

#define UART0               ((uart_regs_s *)ADDR_UART0)
//#define UART0               ((uart_regs_s *)0)

#define FIFO_SIZE_UART0     4

#define UART_QTY    (2) // Количество модулей UART

uint32_t UART_GetControl(uart_regs_s * const UART);

void UART_Init(uart_regs_s * const UART, uart_br_e rate_to_set);

bool UART_BasicCommunicationTest(uart_regs_s * const UART, uint32_t rate_to_set);

void UART_SendByte(uart_regs_s * const UART, uint8_t charByte);

void UART_SendString(uart_regs_s * const UART, uint8_t const * charByte, uint32_t Length);

uint32_t uart_send_n_bytes(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout);

void uart_send_n_bytes_packets(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout,  uint32_t num_packets, uint32_t delay_between_packets);

uint8_t UART_ReadByte(uart_regs_s * const UART);

uint32_t uart_read_n_bytes(uart_regs_s * const UART, uint32_t len, uint32_t p_data, uint32_t timeout);
bool uart_is_rx_fifo_empty(uart_regs_s * const UART);

uint8_t uart_chk_tx_fifo(uart_regs_s * const UART);

//Вводится для совместимости с CustomPrintf:
void UART_SendChar(const char c);

void uart_set_instance_for_printf(uart_regs_s * const uart_instance_ptr);

#endif //UART_H_
