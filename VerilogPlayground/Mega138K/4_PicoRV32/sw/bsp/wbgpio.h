/*
 ******************************************************************************************
 * @file		wbgpio.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Wishbone GPIO Peripheral.
 ******************************************************************************************
 */

#ifndef WB_GPIO_H
#define WB_GPIO_H

/* Includes ----------------------------------------------------------------------- */
#include "picorv32.h"


/* Definitions -------------------------------------------------------------------- */

#define WBGPIO_BIT_DIR_OUT 1UL
#define WBGPIO_BIT_DIR_IN  0UL


/* Declarations: */
void GPIO_Init(WBGPIO_RegDef* GPIOx);							//Initializes GPIO
uint32_t GPIO_GetDir(WBGPIO_RegDef* GPIOx);						//Get input/output direction
void GPIO_SetDir(WBGPIO_RegDef* GPIOx, uint32_t dir);			//Set input/output direction
void GPIO_EnableWriteBit(WBGPIO_RegDef* GPIOx, uint32_t bit);	//Enable output bit
void GPIO_WriteData(WBGPIO_RegDef* GPIOx, uint32_t data);		//Output data
void GPIO_EnableReadBit(WBGPIO_RegDef* GPIOx, uint32_t bit);	//Enable input bit
uint32_t GPIO_ReadData(WBGPIO_RegDef* GPIOx);					//Input data

#endif
