#ifndef _GLOBAL_DEFS_H_
#define _GLOBAL_DEFS_H_

#include "global_consts.h"

// ------------------------ Configuration ---------------------------------
#define CONFIG_SYS_CLK			(20000000)       //(50000000)
#define UART_CLK        		(CONFIG_SYS_CLK)
#define UART_BAUDRATE   		(UART_BR_921600)

#define RTC_HZ			        (1000000u)
#define SYS_CLK			        (40000000u)

#define G_CORE                  CORE_SCR1

#endif // _GLOBAL_DEFS_H_
