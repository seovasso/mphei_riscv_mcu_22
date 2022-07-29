/*
 * timer.c
 *
 *  Created on: 28 июл. 2022 г.
 *      Author: nmari
 */

#include "gptimer/timer.h"

void    TIMER_Init_All_Timers   (timer_regs_s * TIMER)
{
    TIMER->CONFIGURATION |= TIMER_CONFIGURATION_TIMEREN_MSK & 0b11;;
}
 
void    TIMER_Set_Scaler_Value  (timer_regs_s * TIMER, uint32_t value)
{
    TIMER->SCALER_VALUE = TIMER_SCALER_VALUE_MSK & value;
}

void    TIMER_Set_Scaler_Reload (timer_regs_s * TIMER, uint32_t value)
{
    TIMER->SCALER_RELOAD = TIMER_SCALER_RELOAD_MSK & value;
}

