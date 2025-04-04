/*
 ******************************************************************************************
 * @file		config.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Configurations.
 ******************************************************************************************
 */

#ifndef CONFIG_H_
#define CONFIG_H_

//This is for users to configure the MCU booting mode
/*
 * BUILD_LOAD : MCU boot from and run in ITCM
 *              sections.lds
 * BUILD_BURN : MCU boot from external flash and run in ITCM
 *              sections.lds
 * BUILD_XIP  : MCU boot from and run in external flash
 *              sections_xip.lds
 *
 * */
#define BUILD_LOAD 0  // MCU boot from and run in ITCM, must use sections.lds as linker script!
#define BUILD_BURN 1  // MCU boot from external flash and run in ITCM, must use sections.lds as linker script!
#define BUILD_XIP  2  // MCU boot from and run in external flash, must use sections_xip.lds as linker script!

#define BUILD_MODE BUILD_BURN	//Must match with hardware IP

/*
 * sections_debug.lds is for debug.
 *
 * */

#endif /* CONFIG_H_ */
