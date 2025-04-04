/*
 ******************************************************************************************
 * @file		irq.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Interrupt request.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------------ */
#include <stdio.h>
#include "firmware.h"
#include "simpleuart.h"
#include "picorv32.h"
#include "wbuart.h"
#include "irq.h"
#include "config.h"



/* Definitions --------------------------------------------------------------------- */

uint32_t tmp = 0;
uint32_t val = 0;

extern uint8_t irq00_flag;
extern uint8_t irq13_flag;
extern uint8_t irq20_flag;
extern uint8_t irq21_flag;
//Can add other interrupts by user's need

#ifdef USE_WBUART
#define get_char()  wbuart_getc()
#define put_char(c)  wbuart_putc(c)
#else
#define get_char()  uart_getchar()
#define put_char(c)  uart_putchar(c)
#endif


uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	volatile uint32_t mask = mask_irq(0xffffffff) | irqs;

	mask_irq(mask);

	if ((irqs & 1) != 0)
	{
		irq00_flag = 1;
	}

	if ((irqs & (1<<13)) != 0)
	{
		irq13_flag = 1;
	}

	if ((irqs & (1<<20)) != 0)
	{
		irq20_flag = 1;
	}

	if ((irqs & (1<<21)) != 0)
	{
		irq21_flag = 1;
	}


	if ((irqs & 14) != 0)
	{
		uint32_t pc = (regs[0] & 1) ? regs[0] - 3 : regs[0] - 4;
		uint32_t instr = *(uint16_t*)pc;

		if ((instr & 3) == 3)
		{
			instr = instr | (*(uint16_t*)(pc + 2)) << 16;
		}

		if ((irqs & 8) != 0)
		{
			printf("Illegal Ins at 0x");
			printf("%x\r\n", pc);
			printf(": 0x");
			printf("%x\r\n", instr);
		}

		if ((irqs & 4) != 0)
		{
			printf("Bus error at 0x");
			printf("%x\r\n", pc);
			printf(": 0x");
			printf("%x\r\n", instr);
		}
	}

	return regs;
}

void __attribute__((naked, optimize("O0"))) return_from_irq (void)
{
	__asm__ __volatile__(".word(0x0000c08b)");
	__asm__ __volatile__(".word(0x0001410b)");
	__asm__ __volatile__(".word(0x0400000b)");
}

//Mask IRQ
inline uint32_t mask_irq(uint32_t mask)
{
	uint32_t old_mask;

	__asm__ __volatile__("mv a4, a0");
	__asm__ __volatile__(".word(0x0607678b)");
	__asm__ __volatile__("add %[dest], x0, a5" :[dest]"=r"(old_mask));

	return old_mask;
}

//Enable a local interrupt
inline void irq_enable_one_bit(uint32_t irq_num)
{
	uint32_t mask = 0;

	mask = mask_irq(0xffffffff);
	mask = mask & (~(1 << irq_num));
	mask_irq(mask);

	return;
}

//Disable a local interrupt
inline void irq_disable_one_bit(uint32_t irq_num)
{
	uint32_t mask = 0;

	mask = mask_irq(0xffffffff);
	mask = mask | (1 << irq_num);
	mask_irq(mask);

	return;
}

//Enable external interrupts
//Register 'mie' 's external interrupt bit
inline void enable_external_interrupt(void)
{
	__asm__ __volatile__("csrr   t4, mie");
	__asm__ __volatile__("li     t5, 0x800");
	__asm__ __volatile__("or    t4, t4, t5");
	__asm__ __volatile__("csrrw  t5, mie, t4");
}

//Disable external interrupts
//Register 'mie' 's external interrupt bit
inline void disable_external_interrupt(void)
{
	__asm__ __volatile__("csrr   t4, mie");
	__asm__ __volatile__("li     t5, 0xfffff7ff");
	__asm__ __volatile__("and    t4, t4, t5");
	__asm__ __volatile__("csrrw  t5, mie, t4");
}

//Enable timer interrupt
//Register 'mie' 's timer interrupt bit
inline void enable_timer_interrupt(void)
{
	__asm__ __volatile__("csrr   t4, mie");
	__asm__ __volatile__("li     t5, 0x80");
	__asm__ __volatile__("or     t4, t4, t5");
	__asm__ __volatile__("csrrw  t5, mie, t4");
}

//Disable timer interrupt
//Register 'mie' 's mie interrupt bit
inline void disable_timer_interrupt(void)
{
	__asm__ __volatile__("csrr   t4, mie");
	__asm__ __volatile__("li     t5, 0xffffff7f");
	__asm__ __volatile__("and    t4, t4, t5");
	__asm__ __volatile__("csrrw  t5, mie, t4");
}

//Enable global interrupt
//Register 'mstatus' 's 'MIE' bit (global interrupt)
inline void enable_interrupt_global(void)
{
	__asm__ __volatile__("csrrwi t5, mstatus, 8");
}

//Disable global interrupt
//Register 'mstatus' 's 'MIE' bit (global interrupt)
inline void disable_interrupt_global(void)
{
	__asm__ __volatile__("csrrwi t5, mstatus, 0");
}

//Set timer
uint32_t set_timer(uint32_t timer_val)
{
	uint32_t old_val = 0;

	__asm__ __volatile__("mv a4, a0");
	__asm__ __volatile__(".word(0x0a07078b)");
	__asm__ __volatile__("mv %[dest], a5"  :[dest]"=r"(old_val));

	return old_val;
}
