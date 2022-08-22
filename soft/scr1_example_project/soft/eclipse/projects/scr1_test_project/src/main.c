#include "global_inc.h"
#include "core_scr1/core_scr1.h"

#include "spictrl/spi.h"
#include "apbuart/uart.h"
#include "grgpio/gpio.h"
#include "i2cmst/i2c.h"
#include "gptimer/timer.h"

#define BUFFER_SIZE_WORDS	(30)

#define _STOP_BYTE_VAL      (0x55)
#define _TEST_SIZE_BYTES    (100u)

uint32_t src[BUFFER_SIZE_WORDS];
uint32_t dst[BUFFER_SIZE_WORDS];

#define TEST_SPI   0
#define TEST_UART  0
#define TEST_GPIO  0
#define TEST_TIMER 0

#define TEST_I2C   1

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

//    uint8_t ipic_vector0 = 0;
//    uint8_t ipic_vector1 = 1;
//    uint8_t ipic_vector2 = 2;
//    uint8_t ipic_vector3 = 3;
//    uint8_t ipic_vector4 = 4;
//
////    Reset_Interrupt_Count();
//    init_ipic(ipic_vector0);
//    init_ipic(ipic_vector1);
//    init_ipic(ipic_vector2);
//    init_ipic(ipic_vector3);
//    init_ipic(ipic_vector4);
//    __enable_irq();
    
#if TEST_SPI
//*/  Test SPI

    spi_regs_s * SPI        = SPI0;

    uint16_t     selBank    = 0b0101111100000010;    // selecting one of the bank registers via ECON1 register
    uint16_t     setAddr    = 0b0101010000010100;    // write address of the PHLCON of the PHY to MIREGADR register
    uint16_t     setData1   = 0b0101011010100000;    // write into the MIWRL register
    uint16_t     setData2   = 0b0101011100111010;    // write into the MIWRH register
    uint16_t     readData   = 0b00000000;

    uint16_t     wordArr[4] = {selBank,setAddr,setData1,setData2};
    uint32_t     slv_addr   = 0b1;                   // using as CS

    //J10 4567

    uart_regs_s * const UART      = UART0;
    UART_Init(UART, UART_BR_115200);

    SPI_Init(SPI);
    //SPI_LoopMode(SPI);                			// Enable loop mode
    SPI_Slave_Select(SPI, slv_addr);  			    // Set up address of slave
    //SPI_Set_Interrupt(SPI);
    SPI_Core_Enable(SPI);             			    // Power on core (scr; enable to transmit)
    SPI_Set_Frequency(SPI, 1, 0, 0);

    uint8_t index = 0;

//    SPI_Set_Word_Lenght(SPI, SPI_LEN_16);
//    while(1){
//    	SPI_Slave_Select(SPI, 0);
//    	SPI_Send_Word(SPI, wordArr[index]);
//        while(SPI_Get_Event_TIP(SPI) != 0){
//        }
//        delayTact(100);
//    	SPI_Slave_Select(SPI, 1);
//    	index = index + 1;
//    	if(index == 4){
//    		index = 0;
//    	}
//    	uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
//        uart_send_n_bytes(UART, 4, &(SPI->MODE), 10);
//    }


//    SPI_Set_Word_Lenght(SPI, SPI_LEN_16);
//    SPI_Slave_Select(SPI, 0);


    while(1){
    	SPI_Set_Word_Lenght(SPI, SPI_LEN_32);
        SPI_Slave_Select(SPI, 0);
        for(uint8_t index = 0; index < 4; index++){
                SPI_Send_Word(SPI, readData);
                while(SPI_Get_Event_TIP(SPI) != 0){
                }
                uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
               }
               uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
        SPI_Slave_Select(SPI, 1);

        SPI_Set_Word_Lenght(SPI, SPI_LEN_32);
        SPI_Slave_Select(SPI, 0);
        	for(uint8_t index = 0; index < 4; index++){
        		SPI_Send_Word(SPI, readData);
        		while(SPI_Get_Event_TIP(SPI) != 0){
        		}
        		uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
        	}
        	uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
        SPI_Slave_Select(SPI, 1);

        uart_send_n_bytes(UART, 4, &(SPI->MODE), 10);
        }

//    SPI_Set_Word_Lenght(SPI, SPI_LEN_8);
//    while(1){
//    	SPI_Slave_Select(SPI, 0);
//    	SPI_Send_Word(SPI, readData);
//        while(SPI_Get_Event_TIP(SPI) != 0){
//        }
//        delayTact(1000);
//    	SPI_Slave_Select(SPI, 1);
//        uart_send_n_bytes(UART, 4, &(SPI->MODE), 10);
//        uart_send_n_bytes(UART, 4, &(SPI->RECEIVE), 10);
//    	index = index + 1;
//    	if(index == 4){
//    		index = 0;
//    	}
//    }


//*/
#endif

#if TEST_UART
//*/  Test UART
    
    //частота тактирования 20 МГц
    //настроить 115200 бод

	uart_regs_s * const UART      = UART0;                   // pointer to UART structure, returns address of beginning this structure
    uint32_t            brate     = UART_BR_921600;          // bit rate
    uint8_t             data      = 100;                     // test data to transfer

    //uint32_t            p_data[4]   = {4056, 105, 39, 25};     // array of data to transfer
    //uint32_t            timeout     = 0;                       // timeout ???

    UART_Init(UART, brate);
    UART_Set_Interrupt(UART);

    UART_SendByte (UART, SPI->EVENT);

//    UART_SendString(UART, strToSend_p, Length)

//    while(1){
//    	while ((UART->STATUS & (1 << 0)) == 0)
//    	{}
//    	data = UART_ReadByte (UART);
//    	UART_SendByte (UART, data);
//    	printf("Введите строку: ");
//    }

    //uart_send_n_bytes (UART, 4, usflData, timeout);
    //uart_read_n_bytes (UART, 1, p_data, timeout);

//*/
#endif

#if TEST_GPIO
//*/  Test GPIO

    gpio_regs_s * GPIO = GPIO0;

    GPIO_Set_Intr_Polarity (GPIO, ALL_PIN_OFF);  
    GPIO_Set_Intr_Edge     (GPIO, ALL_PIN_OFF); 
    GPIO_Set_Interrupt     (GPIO, ALL_PIN_ON);
    GPIO_Set_Transmit      (GPIO, ALL_PIN_ON);

    GPIO_Send_Data(GPIO, ALL_PIN_OFF);

//    uint8_t index = 0;
//
//    while(1)
//    {
//    	GPIO_Send_Data(GPIO, index);
//    	index++;
//    	if(index == 16)
//    	{
//    		index = 0;
//    	}
//    	delayTact(CONFIG_SYS_CLK/4);
//    }


//    GPIO_Set_Reseiv(GPIO, ALL_PIN_ON);
//
//    GPIO_Set_Bypass(GPIO, ALL_PIN_ON);
//
//    GPIO_Set_Transmit(GPIO, ALL_PIN_OFF);
//
//    GPIO_Set_Reseiv(GPIO, ALL_PIN_OFF);
//
//    GPIO_Set_Bypass(GPIO, ALL_PIN_OFF);

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

    TIMER_Set_Scaler_Value   (TIMER, 1);

    TIMER_Init_Timer         (TIMER, TIM0);
    TIMER_Set_Timer_Counter  (TIMER, TIM0, 0x2710); //500ms
    TIMER_Set_Timer_Reload   (TIMER, TIM0, 0x2710);
    
    while(1){
    	data = GPIO_Get_Output(GPIO);
    	UART_SendByte (UART, data);
    }

    //*/
#endif

#if TEST_I2C
//*/  Test SPI

    i2c_regs_s * const I2C        = I2C0;


    I2C_Init(I2C);
//	I2C_Set_Frequency(I2C, 9);
//	I2C_Core_Enable(I2C);
//	I2C_Interrupts_Enable(I2C);
//	I2C_StartCond_Enable(I2C);
//
//
//    while(1){
////		I2C_Write_Data(I2C, 0b00010000);
//		I2C_StopCond_Enable(I2C);
//	}
//*/
#endif




    while(1)
    {
        __asm("nop");
    }
}
