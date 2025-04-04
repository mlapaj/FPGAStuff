/*
 ******************************************************************************************
 * @file		main.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Main body.
 ******************************************************************************************
 */

/* Includes --------------------------------------------------------------------------- */
#include "config.h"
#include "picorv32.h"
#include "firmware.h"
#include "wbuart.h"
#include "wbgpio.h"
#include "irq.h"


uint8_t irq00_flag = 0;         //Timer interrupt
uint8_t irq13_flag = 0;         //WBUART interrupt
uint8_t irq20_flag = 0;         //An external button interrupt
uint8_t irq21_flag = 0;         //An external button interrupt


#define get_char()   wbuart_getc()
#define put_char(c)  wbuart_putc(c)


void wb_test(void);


int __attribute__((optimize("O0"))) main(void)
{
	//Close all interrupt
	//mask_irq(0xffffffff);
	wbuart_init(115200);	//Initializes WBUART
	GPIO_Init(PICO_WBGPIO);	//Initializes GPIO
	printf("\r\n------------------- LAPAY_PicoRV32 Demo ----------------------\r\n");
	printf("\r\n");
	wb_test();
	wb_test();
	wb_test();
	stats();
	return 0;
}


//Open Wishbone interface demo
void wb_test(void)
{
	volatile uint32_t *ptr_reg0 = (uint32_t *)(0x20000000);
	printf("Before write Wishbone demo register:\r\n");
	printf("Reg0: %08x\r\n", *ptr_reg0);
	*ptr_reg0 = (*ptr_reg0) + 0x11111111;
	printf("After write Wishbone demo register:\r\n");
	printf("Reg0: %08x\r\n", *ptr_reg0);
	printf("Open Wishbone interface demo finished.\r\n");
	printf("\r\n");

	return;
}

