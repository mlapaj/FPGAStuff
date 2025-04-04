/*
 ******************************************************************************************
 * @file		wbspiflash.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Wishbone SPI_Flash Peripheral.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------------ */
#include "wbspiflash.h"
#include <stdio.h>


/* Definitions --------------------------------------------------------------------- */

void SPI_reset(void)
{
	PICO_WBSPI_FLASH->CTRL |= 0x01;         //Reset SPI
	while((PICO_WBSPI_FLASH->CTRL & 0x01)); //Wait until SPI reset complete

	return;
}

//Select the slave mode or master mode
//But need the hardware support
void SPI_set_mode(uint32_t spi_mode)
{
	uint32_t buff = PICO_WBSPI_FLASH->TRANSFMT;
	PICO_WBSPI_FLASH->TRANSFMT = (buff & (~(1UL << 2))) + spi_mode;

	return;
}

//addrLen = SPI_ADDR_LEN_1_BYTE / SPI_ADDR_LEN_2_BYTE / SPI_ADDR_LEN_3_BYTE / SPI_ADDR_LEN_4_BYTE
//addrFmt = ADDRFMT_REGULAR / ADDRFMT_ASDATA
void SPI_set_addr_format(uint8_t addrEn, uint32_t addrLen, uint32_t addrFmt)
{
	uint32_t buff;

	if(0 == addrEn)
	{
		return;
	}
	else
	{
		//Set the address enable && address format
		buff = PICO_WBSPI_FLASH->TRANSCTRL;
		PICO_WBSPI_FLASH->TRANSCTRL = (buff & (~(3UL << 28))) + addrFmt + SPI_ADDREN;

		//Set the width of the address length
		buff = PICO_WBSPI_FLASH->TRANSFMT;
		PICO_WBSPI_FLASH->TRANSFMT  = (buff & (~(3UL << 16))) + addrLen;
	}

	return;
}

void SPI_set_cmd_format(uint8_t cmdEn)
{
	uint32_t buff;

	if(0 == cmdEn)
	{
		return;
	}

	else
	{
		//Open the SPI command phase
		buff = PICO_WBSPI_FLASH->TRANSCTRL;
		PICO_WBSPI_FLASH->TRANSCTRL = (buff & (~(1UL << 30))) + SPI_CMDEN;
	}

	return;
}

//dataMerge takes effect only when data length is 8
void SPI_set_data_format(uint8_t dataBits, uint8_t dataMerge)
{
	uint32_t buff;

	buff = PICO_WBSPI_FLASH->TRANSFMT;
	PICO_WBSPI_FLASH->TRANSFMT = (buff &(~(0xf << 8))) + (((dataBits - 1) & 0xf) << 8);
	if(8 == dataBits)
	{
		buff = PICO_WBSPI_FLASH->TRANSFMT;
		PICO_WBSPI_FLASH->TRANSFMT = (buff &(~(0x1 << 7))) + ((dataMerge & 0x1) << 8);
	}

	return;
}

//mosiDir = SPI_MOSIBIDIR / SPI_MOSIUINDIR
//lsbmsb  = SPI_LSB / SPI_MSB
//cpol    = 0 / 1
//cpha    = 0 / 1
void SPI_set_transfer_format(uint32_t mosiDir, uint32_t lsbmsb, uint32_t cpol, uint32_t cpha)
{
	uint32_t buff;
	uint32_t tmp;

	buff = PICO_WBSPI_FLASH->TRANSFMT;
	tmp = mosiDir + lsbmsb + ((cpol & 0x1) << 1) + (cpha & 0x1);
	PICO_WBSPI_FLASH->TRANSFMT = (buff & (~(0x1b))) + tmp;

	return;
}

//transMode = SPI_TRANSMODE_WRnRD     / SPI_TRANSMODE_WRONLY   / SPI_TRANSMODE_RDONLY    /
//            SPI_TRANSMODE_WR_RD     / SPI_TRANSMODE_RD_WR    / SPI_TRANSMODE_WR_DMY_RD /
//            SPI_TRANSMODE_RD_DMY_WR / SPI_TRANSMODE_NONEDATA / SPI_TRANSMODE_DMY_WR    /
//            SPI_TRANSMODE_DMY_RD
//dualQuad  = SPI_REGULAR / SPI_DUAL / SPI_QUAD
//dummyCnt  = 1 / 2 / 3 / 4
void SPI_set_trans_ctrl(uint32_t transMode, uint32_t dualQuad, uint32_t dummyCnt)
{
	uint32_t buff = PICO_WBSPI_FLASH->TRANSCTRL;

	PICO_WBSPI_FLASH->TRANSCTRL = buff & (~((0xf << 24) + (0x3 << 22) + (0x3 << 9)));
	PICO_WBSPI_FLASH->TRANSCTRL += transMode;
	PICO_WBSPI_FLASH->TRANSCTRL += dualQuad;
	PICO_WBSPI_FLASH->TRANSCTRL += (((dummyCnt - 1) & 0x3) << 9);

	return;
}

void SPI_set_token(uint8_t tokenEn, uint8_t tokenValue)
{
	uint32_t buff = PICO_WBSPI_FLASH->TRANSCTRL;

	if(0 == tokenEn)
	{
		return;
	}
	else
	{
		PICO_WBSPI_FLASH->TRANSCTRL = (buff & (~((1 << 21) + (1 << 11)))) + (1 << 21) + ((tokenValue & 0x1) << 11);
	}
}

void SPI_tx_fifo_reset(void)
{
	PICO_WBSPI_FLASH->CTRL |= (0x1 << 2);    //Reset TX FIFO
	while((PICO_WBSPI_FLASH->CTRL & 0x2)) ;  //Wait TX FIFO reset complete
}

void SPI_rx_fifo_reset(void)
{
	PICO_WBSPI_FLASH->CTRL |= (0x1 << 1);    //Reset RX FIFO
	while((PICO_WBSPI_FLASH->CTRL & 0x1)) ;  //Wait RX FIFO reset complete
}

uint8_t spi_get_fifo_depth(uint8_t fifo_depth_config)
{
	uint8_t fifo_depth = 1;

	for(int i = 0; i < fifo_depth_config+1; i++)
	{
		fifo_depth *= 2;
	}

	return fifo_depth;
}

void SPI_set_tx_threshold(uint8_t tx_threshold)
{
	uint32_t buff;
	buff = PICO_WBSPI_FLASH->CONFIG;
	uint8_t tx_fifo_depth_config = (buff & 0x3f) >> 4;
	uint8_t tx_fifo_depth = spi_get_fifo_depth(tx_fifo_depth_config);

	if(tx_threshold > tx_fifo_depth)
	{
		printf("Error : TX threshold should not be set larger than TX FIFO depth!\r\n");
	}
	else
	{
		PICO_WBSPI_FLASH->CTRL &= (~(0x1f << 16));
		PICO_WBSPI_FLASH->CTRL |= ((tx_threshold) << 16);
	}

	return;
}

void SPI_set_rx_threshold(uint8_t rx_threshold)
{
	uint32_t buff;
	buff = PICO_WBSPI_FLASH->CONFIG;
	uint8_t rx_fifo_depth_config = (buff & 0x03);
	uint8_t rx_fifo_depth = spi_get_fifo_depth(rx_fifo_depth_config);

	if(rx_threshold > rx_fifo_depth)
	{
		printf("RX threshold should not be set larger than RX FIFO depth!\r\n");
	}
	else
	{
		PICO_WBSPI_FLASH->CTRL &= (~(0x1f << 8));
		PICO_WBSPI_FLASH->CTRL |= ((rx_threshold) << 8);
	}

	return;
}

void spi_flash_init(void)
{
	uint32_t buff;

	PICO_WBSPI_FLASH->CTRL |= 0x01;         //Reset SPI
	while((PICO_WBSPI_FLASH->CTRL & 0x01)); //Wait until SPI reset complete

	buff = PICO_WBSPI_FLASH->CONFIG;
	uint8_t tx_fifo_depth_config = (buff & 0x3f) >> 4;
	uint8_t tx_fifo_depth = spi_get_fifo_depth(tx_fifo_depth_config);
	uint8_t rx_fifo_depth_config = (buff & 0x03);
	uint8_t rx_fifo_depth = spi_get_fifo_depth(rx_fifo_depth_config);

	while((PICO_WBSPI_FLASH->STATUS & 0x01)); //Wait until SPI active finish

	buff = (2 << 16) +(7 << 8) + (0 << 7);

	//AddrLen = 3; DataLen = 8 DataMerge = 0
	//Other fields reset to 0 while spi_default_modes connected to 0
	PICO_WBSPI_FLASH->TRANSFMT = buff;

	PICO_WBSPI_FLASH->CTRL |= (0x1 << 2);    				//Reset TX FIFO
	while((PICO_WBSPI_FLASH->CTRL & 0x2)) ;  				//Wait TX FIFO reset complete
	PICO_WBSPI_FLASH->CTRL  |= ((tx_fifo_depth/2) << 16);  	//Set TX threshold as half of TX FIFO depth

	PICO_WBSPI_FLASH->CTRL |= (0x1 << 1);    				//Reset RX FIFO
	while((PICO_WBSPI_FLASH->CTRL & 0x1)) ;  				//Wait RX FIFO reset complete
	PICO_WBSPI_FLASH->CTRL  |= ((rx_fifo_depth/2) << 8);  	//Set RX threshold as half of RX FIFO depth

	PICO_WBSPI_FLASH->INTREN &= 0x00000000;    				//Close all the interrupt
	PICO_WBSPI_FLASH->TIMING &= (~(0xff));
	PICO_WBSPI_FLASH->TIMING |= (0x3);     					//Set the SPI Interface Timing Register (0x40)
	                                   	   	   	   	   	   	//to set SCLK_DIV to 4, which divide the spi_clk into
	                                   	   	   	   	   	   	//((4+1)*2) = 10 as SCLK

	return;
}

//command -> address -> data
void spi_flash_read(uint8_t rd_len, uint32_t cmd, uint32_t address,uint8_t *read_buffer)
{
	PICO_WBSPI_FLASH->TRANSCTRL = (1 << 30) +     	 //Enable command
								  (1 << 29) +        //Open the address
								  (2 << 24) +        //Transmit mode = 2 (read only)
								  (0 << 22) +        //Dual mode 0 regular mode
								  ((rd_len-1) << 0); //Set read transmit byte count

	PICO_WBSPI_FLASH->ADDR = address;
	PICO_WBSPI_FLASH->CMD  = cmd;

	for(uint8_t i = 0; i < rd_len; i++)
	{
		*read_buffer = PICO_WBSPI_FLASH->DATA;
		read_buffer++;
		while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<15));
	}

	while((PICO_WBSPI_FLASH->STATUS & 0x01)); 		//Wait until SPI controller active finish
}

//The consequence of sending
//command -> address -> data
void spi_flash_write(uint8_t wr_len, uint32_t cmd, uint32_t address,uint8_t *write_buffer)
{
	spi_flash_write_cmd(WRITE_ENABLE);
	spi_flash_read_status();

	PICO_WBSPI_FLASH->TRANSCTRL = (1 << 30) +        	//Enable command
								  (1 << 29) + 		 	//Enable address
								  (1 << 24) +        	//Transmit mode = 1 (write only)
								  (0 << 22) +         	//Dual mode
								  ((wr_len-1) << 12); 	//Set read transmit byte count

	PICO_WBSPI_FLASH->ADDR = address;
	PICO_WBSPI_FLASH->CMD  = cmd;
	for(uint8_t i = 0; i < wr_len; i++)
	{
		PICO_WBSPI_FLASH->DATA = (uint32_t)(*write_buffer);
		write_buffer++;

		//Check the status of TX FIFO
		while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));
	}

	while((PICO_WBSPI_FLASH->STATUS & 0x01)); 			//Wait until SPI controller active finish
	spi_flash_write_cmd(WRITE_DISENABLE);
	spi_flash_read_status();
}

//Change the mode of SPI flash
void change_mode_spi_flash()
{
	uint32_t i;

	//Read SPI memory access register 0x50
	i = PICO_WBSPI_FLASH ->MEMCTRL;

	//Write back to SPI flash register
	PICO_WBSPI_FLASH ->MEMCTRL = i;

	//Wait the memCtrlChg become 0
	while(PICO_WBSPI_FLASH ->MEMCTRL & (0x01 <<8 ));

}

//Write command to SPI flash
//According to different SPI flash
void spi_flash_write_cmd(uint32_t cmd)
{
	PICO_WBSPI_FLASH->TRANSCTRL = (0 << 30) +   //Disable command
			                	  (1 << 24) + 	//Transmit mode = 1 (write only)
								  (0 << 22) +	//Regular mode
								  (0 << 12); 	//Set transmit byte count is 1

	PICO_WBSPI_FLASH->CMD  = 0x01;	//Start to transfer
	if(cmd == CHIP_ERASE)
	{
		spi_flash_write_cmd(WRITE_ENABLE);
		spi_flash_read_status();
	}

	PICO_WBSPI_FLASH->DATA = cmd;

	//Check the status of TX FIFO
	while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));

	//Check the status of transfer
	while((PICO_WBSPI_FLASH->STATUS & 0x01));
}

//Page program
void spi_flash_page_program(uint8_t wr_len,uint32_t address,uint8_t *write_buffer)
{
	spi_flash_write_cmd(WRITE_ENABLE);
	spi_flash_read_status();

	PICO_WBSPI_FLASH->TRANSCTRL = (1 << 30) + 			//Enable command
								  (1 << 29) + 			//Enable address
								  (1 << 24) +        	//Transmit mode = 1 (write only)
								  (0 << 22) +         	//Dual mode
								  ((wr_len-1) << 12); 	//Set read transmit byte count

	PICO_WBSPI_FLASH->ADDR = address;
	PICO_WBSPI_FLASH->CMD  = 0x02;	//Page program command

	for(uint8_t i = 0; i < wr_len; i++)
	{
		PICO_WBSPI_FLASH->DATA = (uint32_t)(*write_buffer);
		write_buffer++;

		//Check the status of TX FIFO
		while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));
	}

	while((PICO_WBSPI_FLASH->STATUS & 0x01)); 	//Wait until SPI controller active finish
	spi_flash_write_cmd(WRITE_DISENABLE);
	spi_flash_read_status();    				//Wait SPI flash free
}

//Sector erase
void spi_flash_sector_erase(uint32_t address)
{
	spi_flash_write_cmd(WRITE_ENABLE);
	spi_flash_read_status();

	//Little endian and the range of address
	uint8_t temp0;
	uint8_t temp1;
	uint8_t temp2;

	PICO_WBSPI_FLASH->TRANSCTRL = (1 << 30) + 		//Enable command
			                	  (1 << 24) +       //Transmit mode = 1 (write only)
								  (0 << 22) +       //Dual mode
								  (2 << 12); 		//Set address - 3bytes

	temp0 = (address >> 16 &0xFF);					//The address High byte
	temp1 = (address >> 8  &0xFF);					//The address middle byte
	temp2 = (address       &0xFF);					//The address low byte

	PICO_WBSPI_FLASH->CMD  = 0x20; 					//Sector erase command

	PICO_WBSPI_FLASH->DATA = temp0;

	//Check the status of TX FIFO
	while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));

	PICO_WBSPI_FLASH->DATA = temp1;

	//Check the status of TX FIFO
	while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));

	PICO_WBSPI_FLASH->DATA = temp2;

	//Check the status of TX FIFO
	while(PICO_WBSPI_FLASH ->STATUS & (0x1 <<23));

	while((PICO_WBSPI_FLASH->STATUS & 0x01));	//Wait until SPI controller active finish
	spi_flash_write_cmd(WRITE_DISENABLE);
	spi_flash_read_status();    				//Wait SPI flash free
}

void spi_flash_read_status()
{
	uint8_t temp_first;

	PICO_WBSPI_FLASH->TRANSCTRL = (1 << 30) +   //Enable command
			                	  (2 << 24) +   //Transmit mode = 2 (read only)
								  (0 << 22) +   //Dual mode 0 regular mode
								  (0 << 0); 	//Set read 1 byte

   do
   {
	   	PICO_WBSPI_FLASH->CMD  = 0x05;			//Read status
		temp_first  = PICO_WBSPI_FLASH->DATA;
   }
   while(temp_first & 0x01 );					//Select the low bit and wait become 0

   while((PICO_WBSPI_FLASH->STATUS & 0x03)); 	//Wait until SPI controller active finish
}
