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
#include <nds_intrinsic.h>
#include "csr.h"

// Definitions ------------------------------------------------------------------------------

// Declarations
void amoswapw_func(void);

#define set_csr(reg, bit)   __nds__csrrs(bit, reg)
#define clear_csr(reg, bit) __nds__csrrc(bit, reg)
#define read_fcsr()         __nds__frcsr()
#define read_csr(reg)       __nds__csrr(reg)
#define csr_read(reg)       __nds__csrr(reg)
#define csr_write(reg, val) __nds__csrw(val, reg)

void uboot_enable_cache(void)
{
    unsigned long mcache_ctl_val = csr_read(CSR_MCACHE_CTL);
    unsigned long mmisc_ctl_val = csr_read(CSR_MMISC_CTL);

    mcache_ctl_val |= (MCACHE_CTL_CCTL_SUEN | \
            MCACHE_CTL_IC_PREFETCH_EN | MCACHE_CTL_DC_PREFETCH_EN | \
            MCACHE_CTL_DC_WAROUND_EN | MCACHE_CTL_L2C_WAROUND_EN | \
            MCACHE_CTL_IC_ECCEN | MCACHE_CTL_DC_ECCEN | MCACHE_CTL_TLB_ECCEN);

    //if (!CONFIG_IS_ENABLED(SYS_ICACHE_OFF))
        mcache_ctl_val |= MCACHE_CTL_IC_EN;

    //if (!CONFIG_IS_ENABLED(SYS_DCACHE_OFF))
        mcache_ctl_val |= (MCACHE_CTL_DC_EN | MCACHE_CTL_DC_COHEN);

    csr_write(CSR_MCACHE_CTL, mcache_ctl_val);

    if (1) { // !CONFIG_IS_ENABLED(SYS_DCACHE_OFF)
        /*
         * Check mcache_ctl.DC_COHEN, we assume this platform does
         * not support CM if the bit is hard-wired to 0.
         */
        if (csr_read(CSR_MCACHE_CTL) & MCACHE_CTL_DC_COHEN) {
            /* Wait for DC_COHSTA bit to be set */
            while (!(csr_read(CSR_MCACHE_CTL) & MCACHE_CTL_DC_COHSTA));
        }
    }

    mmisc_ctl_val |= MMISC_CTL_NON_BLOCKING_EN;

    csr_write(CSR_MMISC_CTL, mmisc_ctl_val);
}


void enable_l1_cache()
{
	/* Do your platform low-level initial */

	/*
	 * Enable I/D cache with HW pre-fetcher,
	 * D-cache write-around (threshold: 4 cache lines),
	 * and CM (Coherence Manager).
	 */
	/* CSR: control and status register */
	clear_csr(NDS_MCACHE_CTL, (3 << 13)); // see csr.h in uboot in  arch/riscv/include/asm/arch-andes
	set_csr(NDS_MCACHE_CTL, (1 << 19) | (1 << 13) | (1 << 10) | (1 << 9) | (1 << 8) | (1 << 1) | (1 << 0)); // see AE350 soc 6.2 chapter cache control register

	/* Check if CPU support CM or not. */
	if (read_csr(NDS_MCACHE_CTL) & (1 << 19))
	{
		/* Wait for cache coherence enabling completed */
		while((read_csr(NDS_MCACHE_CTL) & (1 << 20)) == 0);
	}

    #define CSR_MMISC_CTL 0x7d0
    /* mmisc_ctl register */
    unsigned long mmisc_ctl_val = read_csr(CSR_MMISC_CTL);
    mmisc_ctl_val |= MMISC_CTL_NON_BLOCKING_EN;
    set_csr(CSR_MMISC_CTL, mmisc_ctl_val);

}


// Main function entry
int main(void)
{
    uart_init(9600);
    //enable_l1_cache();
    uboot_enable_cache();
	amoswapw_func();	// amoswap.w
	return 0;
}

// amoswap.w
void amoswapw_func(void)
{
    uart_puts("Before amoswapw\n");
	// We want to perform an atomic swap operation.
	signed int data, newv, oldv;
    volatile x = *(void *) 0x40000;
    //x = *ptr;
    //flush_cache();
    //void *ptr = &data;
    // hooray - to dziala
    //asm ("li t0, 0x40000");
    //asm("li t1, 0x10");
    //asm("sw t1, 0(t0)");
	//newv = 10;

	// new value: 10
	oldv = __nds__amoswapw(newv, ptr, UNORDER);

    uart_puts("Done\n");


    asm("j .");

}

