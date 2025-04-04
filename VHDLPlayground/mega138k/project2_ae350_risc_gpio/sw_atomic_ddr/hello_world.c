/*
 * ******************************************************************************************
 * File		: main.c
 * Author 	: GowinSemicoductor
 * Chip		: AE350_SOC
 * Function	: Main functions
 * ******************************************************************************************
 */

// Includes ---------------------------------------------------------------------------------
#include "uart.h"
#include <stdio.h>
#include <nds_intrinsic.h>
#include "bsp/ae350/cache.h"



// Definitions ------------------------------------------------------------------------------

// Declarations
void amoswapw_func(void);
void amoaddw_func(void);
void amoxorw_func(void);
void amoandw_func(void);
void amoorw_func(void);
void amominw_func(void);
void amomaxw_func(void);
void amominuw_func(void);
void amomaxuw_func(void);


// Main function entry
int main(void)
{
	uart_init(9600);

	printf("\r\nIt's an Atomic Instruction demo.\r\n\r\n");

	amoswapw_func();	// amoswap.w
	amoaddw_func();		// amoadd.w
	amoxorw_func();		// amoxor.w
	amoandw_func();		// amoand.w
	amoorw_func();		// amoor.w
	amominw_func();		// amomin.w
	amomaxw_func();		// amomax.w
	amominuw_func();	// amominu.w
	amomaxuw_func();	// amomaxu.w

	printf("\r\nAtomic instruction PASS!");

	return 0;
}

// amoswap.w
void amoswapw_func(void)
{
	// We want to perform an atomic swap operation.
	signed int data, newv, oldv;
	newv = 10;
    volatile int i = *((int *)0x40000);

	// new value: 10
	oldv = __nds__amoswapw(newv, (void *)0x40000 , UNORDER);

	printf("amoswap.w : oldv = 0x%x\r\n", oldv);
}

// amoadd.w
void amoaddw_func(void)
{
	// We want to perform an atomic add operation.
	signed int data, addv, oldv;
	addv = 10;

	// new value: data + 10
	oldv = __nds__amoaddw(addv, &data, UNORDER);

	printf("amoadd.w : oldv = 0x%x\r\n", oldv);
}

// amoxor.w
void amoxorw_func(void)
{
	// We want to perform an atomic xor operation.
	unsigned int data, xorv, oldv;
	xorv = 0x22334455;

	// new value: data xor 0x22334455
	oldv = __nds__amoxorw(xorv, &data, UNORDER);

	printf("amoxor.w : oldv = 0x%x\r\n", oldv);
}

// amoand.w
void amoandw_func(void)
{
	// We want to perform an atomic AND operation.
	unsigned int data, andv, oldv;
	andv = 0x22334455;

	// new value: data AND 0x22334455
	oldv = __nds__amoandw(andv, &data, UNORDER);

	printf("amoand.w : oldv = 0x%x\r\n", oldv);
}

// amoor.w
void amoorw_func(void)
{
	// We want to perform an atomic or operation.
	unsigned int data, orv, oldv;
	orv = 0x22334455;

	// new value: data OR 0x22334455
	oldv = __nds__amoorw(orv, &data, UNORDER);

	printf("amoor.w : oldv = 0x%x\r\n", oldv);
}

// amomin.w
void amominw_func(void)
{
	// We want to perform an atomic min operation.
	signed int data, cmpv, oldv;
	cmpv = 10;

	// new value: minimum(data, cmpv)
	oldv = __nds__amominw(cmpv, &data, UNORDER);

	printf("amomin.w : oldv = 0x%x\r\n", oldv);
}

// amomax.w
void amomaxw_func(void)
{
	// We want to perform an atomic max operation.
	signed int data, cmpv, oldv;
	cmpv = 10;

	// new value: maximum(data, cmpv)
	oldv = __nds__amomaxw(cmpv, &data, UNORDER);

	printf("amomax.w : oldv = 0x%x\r\n", oldv);
}

// amominu.w
void amominuw_func(void)
{
	// We want to perform an atomic unsigned min operation.
	unsigned int data, cmpv, oldv;
	cmpv = 0x22334455;

	// new value: unsigned minimum(data, cmpv)
	oldv = __nds__amominuw(cmpv, &data, UNORDER);

	printf("amominu.w : oldv = 0x%x\r\n", oldv);
}

// amomaxu.w
void amomaxuw_func(void)
{
	// We want to perform an atomic unsigned min operation.
	unsigned int data, cmpv, oldv;
	cmpv = 0x22334455;

	// new value: unsigned maximum(data, cmpv)
	oldv = __nds__amomaxuw(cmpv, &data, UNORDER);

	printf("amomaxu.w : oldv = 0x%x\r\n", oldv);
}
