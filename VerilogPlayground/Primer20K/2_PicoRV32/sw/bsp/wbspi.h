/*
 ******************************************************************************************
 * @file		wbspi.h
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Wishbone SPI Peripheral.
 ******************************************************************************************
 */

#ifndef WB_SPI_H
#define WB_SPI_H

/* Includes -------------------------------------------------------------------------- */
#include "picorv32.h"


/* Definitions ----------------------------------------------------------------------- */

#define SLAVE_NUM_MAX 8

//Bit definitions of CONTROL register
#define IROE     (1UL << 0)
#define ITOE     (1UL << 1)
#define ITRDY    (1UL << 3)
#define IRRDY    (1UL << 4)
#define IE       (1UL << 5)
#define SSO      (1UL << 7)

//Bit definitions of STATUS register
#define ROE      (1UL << 2)
#define TOE      (1UL << 3)
#define TMT      (1UL << 4)
#define TRDY     (1UL << 5)
#define RRDY     (1UL << 6)
#define ERROR    (1UL << 7)


/* Declarations: */
uint32_t wbspi_master_select_slave(WBSPI_RegDef *WBSPI, uint32_t slave_id);
uint32_t wbspi_enable_interrupt(WBSPI_RegDef *WBSPI, uint32_t interrupt_id);
uint32_t wbspi_disable_interrupt(WBSPI_RegDef *WBSPI, uint32_t interrupt_id);
uint32_t wbspi_master_txdata(WBSPI_RegDef *WBSPI, uint32_t txdata);
uint32_t wbspi_master_rxdata(WBSPI_RegDef *WBSPI);
void wbspi_slave_prepare_txdata(WBSPI_RegDef *WBSPI, uint32_t txdata);
uint32_t wbspi_slave_read_data(WBSPI_RegDef *WBSPI);

#endif
