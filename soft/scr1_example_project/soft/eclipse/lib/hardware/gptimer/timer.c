/*
 * timer.c
 *
 *  Created on: 28 июл. 2022 г.
 *      Author: nmari
 */

#include "gptimer/timer.h"

void    TIMER_Init_All_Timers      (timer_regs_s * const TIMER)
{
    TIMER->CONFIGURATION |= TIMER_CONFIGURATION_TIMEREN_MSK ;//& 0x00020000;
}
 
void    TIMER_Set_Scaler_Value     (timer_regs_s * const TIMER, uint32_t value)
{
    TIMER->SCALER_VALUE = TIMER_SCALER_VALUE_MSK & value;
}

void    TIMER_Set_Scaler_Reload    (timer_regs_s * const TIMER, uint32_t value)
{
    TIMER->SCALER_RELOAD = TIMER_SCALER_RELOAD_MSK & value;
}

uint32_t  TIMER_Get_Configuration  (timer_regs_s * const TIMER)
{
    return TIMER->CONFIGURATION;
}

void      TIMER_Init_Timer         (timer_regs_s * const TIMER, uint8_t timer_n)
{
    //TIMER->TIM[timer_n].CONTROL =   0u;
    TIMER->TIM[timer_n].CONTROL |=  TIMER_TIMER_CONTROL_IE_MSK;  // enable interupt
    TIMER->TIM[timer_n].CONTROL |=  TIMER_TIMER_CONTROL_RS_MSK;  // enable reload
    TIMER->TIM[timer_n].CONTROL &= (~TIMER_TIMER_CONTROL_CH_MSK);  // disable chain
    TIMER->TIM[timer_n].CONTROL |=  TIMER_TIMER_CONTROL_EN_MSK;  // enable timer
}
  
void      TIMER_Set_Timer_Counter  (timer_regs_s * const TIMER, uint8_t timer_n, uint32_t value)
{
    TIMER->TIM[timer_n].COUNTER = value;
}

void      TIMER_Set_Timer_Reload   (timer_regs_s * const TIMER, uint8_t timer_n, uint32_t value)
{
    TIMER->TIM[timer_n].RELOAD = value;
}

uint32_t  TIMER_Get_Timer_Latch    (timer_regs_s * const TIMER, uint8_t timer_n)
{
    return TIMER->TIM[timer_n].LATCH;
}
