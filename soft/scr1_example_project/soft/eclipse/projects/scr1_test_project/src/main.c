#include "global_inc.h"
#include "core_scr1/core_scr1.h"

#include "spictrl/spi.h"
#include "apbuart/uart.h"
#include "grgpio/gpio.h"
#include "gptimer/timer.h"

#define BUFFER_SIZE_WORDS	(30)

#define _STOP_BYTE_VAL      (0x55)
#define _TEST_SIZE_BYTES    (100u)

uint32_t src[BUFFER_SIZE_WORDS];
uint32_t dst[BUFFER_SIZE_WORDS];

#define TEST_SPI   1
#define TEST_UART  1
#define TEST_GPIO  1
#define TEST_TIMER 1

#define USFL_DATA_ADDR ((uint32_t*)0xf000ffc8u)

void delayTact (uint32_t delay_tact)
{
	for(uint32_t i = 0; i < delay_tact; i++)
	{
		__asm volatile ("nop");
	}
}

int main(void)
{

    //uint32_t * usflData = USFL_DATA_ADDR;
    //usflData[0] = &(testAddr->AMTRANSMIT[0]);

    uint8_t ipic_vector0 = 0;
    uint8_t ipic_vector1 = 1;
    uint8_t ipic_vector2 = 2;
    uint8_t ipic_vector3 = 3;
    uint8_t ipic_vector4 = 4;
    uint8_t ipic_vector5 = 15;

    __enable_irq();
    Reset_Interrupt_Count();
    init_ipic(ipic_vector0);
    init_ipic(ipic_vector1);
    init_ipic(ipic_vector2);
    init_ipic(ipic_vector3);
    init_ipic(ipic_vector4);
    init_ipic(ipic_vector5);
    

#if TEST_SPI
//*/  Test SPI

    spi_regs_s * SPI        = SPI0;
    uint32_t     word       = 1000;
    uint32_t     wordArr[3] = {1000,5000,3535};
    uint32_t     slv_addr   = 0b10;

    // Initialization of SPI
    SPI_Init(SPI);
    SPI_LoopMode(SPI);                			// Enable loop mode
    SPI_Slave_Select(SPI, slv_addr);  			// Set up address of slave
    //SPI_Set_Word_Lenght(SPI, SPI_LEN_16);       // Set up word length for transfer
    SPI_Set_Interrupt(SPI);
    SPI_Core_Enable(SPI);             			// Power on core (scr; enable to transmit)

    SPI_Send_Word(SPI, word);
    //usflData[1] = SPI_Read_Word(SPI);

    //SPI_Send_n_Word(SPI, wordArr, 3);
    //SPI_Read_n_Word(SPI, (usflData+2), 3);

//*/
#endif

#if TEST_UART
//*/  Test UART

	uart_regs_s * const UART       = UART0;                   // pointer to UART structure, returns address of beginning this structure
    uint32_t            brate      = UART_BR_921600;          // bit rate
    uint8_t             data       = 100;                     // test data to transfer

    //uint32_t            p_data[4]  = {4056, 105, 39, 25};     // array of data to transfer
    //uint32_t            len        = 2;                       // number bit of the array to transfer
    //uint32_t            timeout    = 0;                       // timeout ???

    // Initialization of UART, and rate of transfer (brate)
    UART_Init(UART, brate);
    UART_Set_Interrupt(UART);
    //UART_LoopBackMode(UART);

    UART_SendByte (UART, data);

    //uart_send_n_bytes (UART, 4, usflData, timeout);
    
    //data = UART_ReadByte (UART);

    //uart_read_n_bytes (UART, 1, p_data, timeout);

//*/
#endif

#if TEST_GPIO
//*/  Test GPIO

    gpio_regs_s * GPIO = GPIO0;

    GPIO_Set_Intr_Polarity (GPIO, ALL_PIN_OFF);  
    GPIO_Set_Intr_Edge     (GPIO, ALL_PIN_OFF); 
    GPIO_Set_Interrupt     (GPIO, ALL_PIN_ON);

    GPIO_Send_Data(GPIO, data);

    delayTact(50);

    GPIO_Set_Transmit(GPIO, ALL_PIN_ON);

    delayTact(50);

    GPIO_Set_Reseiv(GPIO, ALL_PIN_ON);

    delayTact(50);

    GPIO_Set_Bypass(GPIO, ALL_PIN_ON);

    delayTact(50);

    GPIO_Set_Transmit(GPIO, ALL_PIN_OFF);

    delayTact(50);

    GPIO_Set_Reseiv(GPIO, ALL_PIN_OFF);

    delayTact(50);

    GPIO_Set_Bypass(GPIO, ALL_PIN_OFF);

//*/
#endif

#if TEST_TIMER
//*/  Test TIMER

    #define TIM0 (0)
    #define TIM1 (1)
    #define TIM2 (2)
    #define TIM3 (3)
    #define TIM4 (4)
    #define TIM5 (5)
    #define TIM6 (6)

    timer_regs_s * const TIMER = TIMER0;
    
    TIMER_Init_All_Timers    (TIMER);

    TIMER_Set_Scaler_Value   (TIMER, 10);
    TIMER_Set_Scaler_Reload  (TIMER, 20);

    TIMER_Init_Timer         (TIMER, TIM0);
    TIMER_Set_Timer_Counter  (TIMER, TIM0, 10);
    TIMER_Set_Timer_Reload   (TIMER, TIM0, 20);

    TIMER_Init_Timer         (TIMER, TIM1);
    TIMER_Set_Timer_Counter  (TIMER, TIM1, 10);
    TIMER_Set_Timer_Reload   (TIMER, TIM1, 20);
    
//*/
#endif

    while(1)
    {
        __asm("nop");
    }
}
