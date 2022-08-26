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

#define TEST_SPI   0
#define TEST_UART  0
#define TEST_GPIO  1
#define TEST_TIMER 0

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

    Reset_Interrupt_Count();
    init_ipic(ipic_vector0);
    init_ipic(ipic_vector1);
    init_ipic(ipic_vector2);
    init_ipic(ipic_vector3);
    init_ipic(ipic_vector4);
    __enable_irq();
    
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
    uint32_t            brate     = UART_BR_115200;          // bit rate
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
    //    GPIO_Set_Intr_Edge     (GPIO, ALL_PIN_OFF);
    //    GPIO_Set_Interrupt     (GPIO, ALL_PIN_ON);
        GPIO_Set_Transmit      (GPIO, ALL_PIN_ON);

        GPIO_Send_Data(GPIO, ALL_PIN_OFF);

        const uint32_t PWM_PERIOD   = 2048;
//        const uint32_t R_DUTY_CYCLE = 6 ;
//        const uint32_t G_DUTY_CYCLE = 5 ;
//        const uint32_t B_DUTY_CYCLE = 3 ;

		#define GPIO_R_POS      (0u)    ///<
		#define GPIO_G_POS      (1u)    ///<
		#define GPIO_B_POS      (2u)    ///<

		#define GPIO_R_MSK     (1u << (GPIO_R_POS))
		#define GPIO_G_MSK     (1u << (GPIO_G_POS))
		#define GPIO_B_MSK     (1u << (GPIO_B_POS))

        uint32_t r_cycle = 0;
        uint32_t g_cycle = 682;
        uint32_t b_cycle = 1365;
        uint32_t gpio_state=0x0000000f;

        int r_dir = 0;
        int g_dir = 0;
        int b_dir = 0;

        GPIO_Send_Data(GPIO, gpio_state);
		while(1)
				{
					for (uint32_t i=0; i<PWM_PERIOD; i++){

						if (i==r_cycle){
							gpio_state ^= GPIO_R_MSK;
						}
						if (i==g_cycle){
							gpio_state ^= GPIO_G_MSK;
						}
						if (i==b_cycle){
							gpio_state ^= GPIO_B_MSK;
						}
						else if(i==0){
							gpio_state |= GPIO_R_MSK;
							gpio_state |= GPIO_G_MSK;
							gpio_state |= GPIO_B_MSK;
						}

						if(i==0){
							if (r_cycle<PWM_PERIOD && r_dir ==0 )
								r_cycle++;
							else if (r_cycle > 0 && r_dir ==1 )
								r_cycle--;
							else
								r_dir = (r_dir+1)%2;

							if (g_cycle<PWM_PERIOD && g_dir ==0 )
								g_cycle++;
							else if (g_cycle > 0 && g_dir ==1 )
								g_cycle--;
							else
								g_dir = (g_dir+1)%2;

							if (b_cycle<PWM_PERIOD && b_dir ==0 )
								b_cycle++;
							else if (b_cycle > 0 && b_dir ==1 )
								b_cycle--;
							else
								b_dir = (b_dir+1)%2;
						}
						GPIO_Send_Data(GPIO, gpio_state);
					}
				}

//        while(1)
//        {
//        	for (uint32_t i=0; i<=PWM_PERIOD; i++){
//
//        		GPIO_Send_Data(GPIO, gpio_state);
//
//        		if (i==r_cycle){
//        			gpio_state ^= GPIO_R_MSK;
//        		}
//
//        		else if(i==0){
//        			gpio_state ^= GPIO_R_MSK;
//        		}
//
//        		if(i==0){
//        			if (r_cycle<PWM_PERIOD)
//        				r_cycle=r_cycle*j;
//        			else
//        				r_cycle=0;


//        		GPIO_Send_Data(GPIO, B_DUTY_CYCLE);

//        		GPIO_Send_Data(GPIO, gpio_state);
//        		if (i==0){
//        			GPIO_Send_Data(GPIO, 0);
//        		}
//        		else if (i==R_DUTY_CYCLE){
//        			GPIO_Send_Data(GPIO, 1);
//        		}
//        		else if (i==G_DUTY_CYCLE){
//        			GPIO_Send_Data(GPIO, 3);
//        		}
//        		else if (i==B_DUTY_CYCLE){
//        			GPIO_Send_Data(GPIO, 7);
//        		}

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

    while(1)
    {
        __asm("nop");
    }
}
