/*
 ******************************************************************************************
 * @file		irq.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Interrupt Request.
 ******************************************************************************************
 */

#ifndef IRQ_H
#define IRQ_H

/* Includes ------------------------------------------------------------------------- */
#include <stdint.h>


/* Declarations --------------------------------------------------------------------- */
uint32_t *irq(uint32_t *regs, uint32_t irqs);
uint32_t set_timer(uint32_t timer_val)  __attribute__((optimize("O0")));
uint32_t mask_irq(uint32_t mask)  __attribute__((optimize("O0")));

void irq_enable_one_bit(uint32_t irq_num);
void irq_disable_one_bit(uint32_t irq_num);

void enable_external_interrupt(void);
void disable_external_interrupt(void);

void enable_timer_interrupt(void);
void disable_timer_interrupt(void);

void enable_interrupt_global(void);
void disable_interrupt_global(void);

#endif
