/*
 ******************************************************************************************
 * @file		wbuart.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Wishbone UART Peripheral.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------------ */
#include "wbuart.h"


/* Definitions --------------------------------------------------------------------- */

uint32_t wbuart_init(unsigned int BaudRate)
{
	uint32_t ClkDiv = SYSCLKFREQ / BaudRate;

	PICO_WBUART->SETUP = ClkDiv;

	return ClkDiv;
}

int wbuart_putc(int c)
{
	while((PICO_WBUART->TXREG) & (1UL << 8));
	uint32_t tmp = PICO_WBUART->TXREG & (~0xff);
	PICO_WBUART->TXREG = tmp + (c & 0xff);

	return c;
}

int wbuart_getc(void)
{
	uint8_t tmp = 0;

	while((PICO_WBUART->RXREG) & (1UL << 8));
	tmp = (PICO_WBUART->RXREG) & 0xff;

	return tmp;
}

int wbuart_outbyte(int c)
{
	wbuart_putc(c);
	if (c =='\n')
	{
		wbuart_putc('\r');
	}

	return c;
}
