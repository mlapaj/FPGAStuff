/*
 ******************************************************************************************
 * @file		wbuart.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Wishbone UART Peripheral.
 ******************************************************************************************
 */

#ifndef WB_UART_H
#define WB_UART_H

/* Includes ------------------------------------------------------------------------- */
#include "picorv32.h"


/* Declarations --------------------------------------------------------------------- */
uint32_t wbuart_init(unsigned int BaudRate);
int wbuart_putc(int c);
int wbuart_getc(void);
int wbuart_outbyte(int c);

#endif
