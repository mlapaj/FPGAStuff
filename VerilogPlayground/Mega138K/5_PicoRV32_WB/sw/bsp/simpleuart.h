/*
 ******************************************************************************************
 * @file		simpleuart.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Simple UART Peripheral.
 ******************************************************************************************
 */

#ifndef SIMPLE_UART_H
#define SIMPLE_UART_H

/* Includes ------------------------------------------------------------------------ */
#include "picorv32.h"


/* Declarations -------------------------------------------------------------------- */
void uart_init(uint32_t BaudRate);	//Initializes UART
void uart_putchar(char c);
int outbyte(int c);
char getchar_prompt(char *prompt);
char uart_getchar(void);

#endif
