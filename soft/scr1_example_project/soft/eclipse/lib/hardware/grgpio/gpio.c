/*
 * gpio.c
 *
 *  Created on: 27 июл. 2022 г.
 *      Author: nmari
 */

#include "grgpio/gpio.h"

void      GPIO_Set_Interrupt     (gpio_regs_s * const GPIO, uint32_t pins_to_set)
{
    GPIO->INTR_MASK = GPIO_INTR_MASK_MSK & pins_to_set;
}

void      GPIO_Set_Intr_Polarity (gpio_regs_s * const GPIO, uint32_t pins_to_set)
{
    GPIO->INTR_POLARITY = GPIO_INTR_POLARITY_MSK & pins_to_set;
}

void      GPIO_Set_Intr_Edge     (gpio_regs_s * const GPIO, uint32_t pins_to_set)
{
    GPIO->INTR_EDGE = GPIO_INTR_EDGE_MSK & pins_to_set;
}

void      GPIO_Set_Bypass        (gpio_regs_s * const GPIO, uint32_t pins_to_set)
{
    GPIO->BYPASS = GPIO_BYPASS_MSK & pins_to_set;
}

void      GPIO_Set_Transmit      (gpio_regs_s * const GPIO,  uint32_t pins_to_set)
{
    GPIO->DIRECTION = GPIO_DIRECTION_MSK & pins_to_set;
}

void      GPIO_Set_Reseiv        (gpio_regs_s * const GPIO,  uint32_t pins_to_set)
{
    GPIO->INPUT_ENABLE = pins_to_set;
}

uint32_t  GPIO_Get_Capability    (gpio_regs_s * const GPIO)
{
    return GPIO->CAPABILITY;
}

void      GPIO_Send_Data         (gpio_regs_s * const GPIO, uint32_t p_data)
{

    GPIO->OUTPUT = GPIO_OUTPUT_MSK & p_data;    // Записыаем в OUTPUT регистр данные
    //GPIO_Set_Bypass(GPIO, ALL_PIN_OFF);         // Переключаем выход DOUT на передачу OUTPUT регистра,
    									          // а не на передачу входа SIG_IN
}
    
uint32_t  GPIO_Read_Data         (gpio_regs_s * const GPIO)
{

	//GPIO_Set_Reseiv(GPIO, ALL_PIN_ON); // Устанавливаем возможность записи данных входа DIN в DATA регистр
    return GPIO->DATA;                 // Читаем данные с DATA региста
}
