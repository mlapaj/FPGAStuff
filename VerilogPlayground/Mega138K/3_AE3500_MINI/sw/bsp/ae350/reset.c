/*
 * ******************************************************************************************
 * File		: reset.c
 * Author	: GowinSemicoductor
 * Chip		: AE350_SOC
 * Function	: Boot into main function through start up reset
 * ******************************************************************************************
 */

// Includes ---------------------------------------------------------------------------------
#include "config.h"

#ifdef CFG_GCOV
#include <stdlib.h>
#endif


// Declarations -----------------------------------------------------------------------------
extern void c_startup(void);
extern void system_init(void);
extern void __libc_init_array(void);
extern void __libc_fini_array(void);


// Definitions ------------------------------------------------------------------------------

__attribute__((weak)) void reset_handler(void)
{
	extern int main(void);


	/* Call platform specific hardware initialization */
	//system_init();

    main();

}

