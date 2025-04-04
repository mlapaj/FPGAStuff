/*
 ******************************************************************************************
 * @file		firmware.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Firmware.
 ******************************************************************************************
 */

#ifndef FIRMWARE_H
#define FIRMWARE_H

/* Includes ------------------------------------------------------------------------- */
#include "config.h"
#include <stdint.h>


/* Declarations --------------------------------------------------------------------- */
void stats(void);

#if BUILD_MODE == BUILD_XIP
unsigned int delay( unsigned int delay_cycles) __attribute__((optimize("O0"), section(".delay"))) ;
#else
unsigned int delay( unsigned int delay_cycles) __attribute__((optimize("O0"))) ;
#endif

void memset_32(uint32_t* dest, uint32_t data, uint32_t length);//Length is 32bit

#endif
