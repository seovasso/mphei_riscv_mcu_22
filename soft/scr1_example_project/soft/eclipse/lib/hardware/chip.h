/*
 * chip.h
 *
 *  Created on: 19 июл. 2022 г.
 *      Author: Turyshev
 */

#ifndef HARDWARE_CHIP_H_
#define HARDWARE_CHIP_H_

////// From core_const_pkg.vhd //////
#define APB1_BA             (0x20000000u)
#define APB1_SPI0_BA        ((APB1_BA) + 0x0000u)
#define APB1_UART0_BA       ((APB1_BA) + 0x1000u)
#define APB1_GPIO0_BA       ((APB1_BA) + 0x2000u)
#define APB1_TIMER0_BA      ((APB1_BA) + 0x3000u)


#endif /* HARDWARE_CHIP_H_ */
