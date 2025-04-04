/*
 ******************************************************************************************
 * @file		simpleuart.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Simple UART Peripheral.
 ******************************************************************************************
 */

/* Includes ----------------------------------------------------------------------- */
#include "simpleuart.h"


/* Definitions -------------------------------------------------------------------- */

void uart_init(uint32_t BaudRate)
{
	PICO_SIMPLEUART->CLKDIV = SYSCLKFREQ / BaudRate;
}

int outbyte(int c)
{
	if (c == '\n')
	{
		outbyte('\r');
	}

	PICO_SIMPLEUART->DATA = c;

	return c;
}

void uart_putchar(char c)
{
	PICO_SIMPLEUART->DATA = c;
}

char getchar_prompt(char *prompt)
{
	int32_t c = -1;
	uint32_t cycles_begin, cycles_now, cycles;

	__asm__ volatile ("rdcycle %0" : "=r"(cycles_begin));

	while (c == -1)
	{
		__asm__ volatile ("rdcycle %0" : "=r"(cycles_now));

		cycles = cycles_now - cycles_begin;
		if (cycles > 12000000)
		{
			cycles_begin = cycles_now;
		}

		c = PICO_SIMPLEUART->DATA;
	}

	return c;
}

char uart_getchar(void)
{
	return getchar_prompt(0);
}
