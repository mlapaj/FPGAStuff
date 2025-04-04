/*
 ******************************************************************************************
 * @file		main.c
 * @author		GowinSemicoductor
 * @device		Gowin_PicoRV32
 * @brief		Main body.
 ******************************************************************************************
 */

/* Includes --------------------------------------------------------------------------- */
#include "config.h"
#include "picorv32.h"
#include "firmware.h"
#include "irq.h"
#include "simpleuart.h"
#include "wbuart.h"
#include "wbgpio.h"
#include "wbspiflash.h"


/* Definitions ------------------------------------------------------------------------ */

//User-defined device
#define DEV_GW5A25_15

//SPI-Flash memory map address
#ifdef DEV_GW5A25_15
#define MEM_MAP_ADDR1	0x10100000 + 0x300000
#define MEM_MAP_ADDR2	0x10610000 + 0x300000
#endif
#ifdef DEV_GW5A138
#define MEM_MAP_ADDR1	0x10600000 - 0x200000
#define MEM_MAP_ADDR2	0x10610000 - 0x200000
#endif
#ifdef DEV_GW5A60_GW2A
#define MEM_MAP_ADDR1	0x10400000
#define MEM_MAP_ADDR2	0x10610000
#endif


//UART
#ifdef USE_WBUART
#define get_char()   wbuart_getc()
#define put_char(c)  wbuart_putc(c)
#else
#define get_char()   uart_getchar()
#define put_char(c)  uart_putchar(c)
#endif

//Open AHB extended interface
//Register Definitions
typedef struct
{
	__IO unsigned int REG0;  //0x00
	__IO unsigned int REG1;  //0x04
} AHBREGDEMO_RegDef;

//Address Definitions
#define AHBREGDEMO_BASE         OPEN_AHB_BASE
#define PICO_AHBREGDEMO        ((AHBREGDEMO_RegDef  *)    AHBREGDEMO_BASE )

//Open WB extended interface
//Register Definitions
typedef struct
{
	__IO unsigned int REG0;  //0x00
	__IO unsigned int REG1;  //0x04
	__IO unsigned int REG2;  //0x08
} WBREGDEMO_RegDef;

//Address Definitions
#define WBREGDEMO0_BASE         OPEN_WB_BASE
#define PICO_WBREGDEMO0        ((WBREGDEMO_RegDef   *)    WBREGDEMO0_BASE )


uint8_t irq00_flag = 0;		//Timer interrupt
uint8_t irq13_flag = 0;		//WBUART interrupt
uint8_t irq20_flag = 0; 	//An external button interrupt
uint8_t irq21_flag = 0; 	//An external button interrupt
//Please see other interrupt in user manual

uint8_t tx_buffer[100] = {0,1,2,3,4,5,6,7,8,9};
uint8_t rx_buffer[100] = {0};

uint32_t timer_count = 0;
uint32_t wbuart_rx_buffer = 0;


/* Declarations: */
void gpio_out_demo(void);
void wbreg_demo(void);
void ahbreg_demo(void);
void uart_rx_demo(void);
void spi_flash_demo(void);


/* Functions: */
//Application entry
int __attribute__((optimize("O0"))) main(void)
{
	//Close all interrupt
	mask_irq(0xffffffff);

	//Initializes peripherals
#ifdef USE_WBUART
	wbuart_init(115200);	//Initializes WBUART
#else
	uart_init(115200);		//Initializes SimpleUART
#endif
	spi_flash_init();		//Initializes SPI-Flash
	GPIO_Init(PICO_WBGPIO);	//Initializes GPIO
	
	//Interrupt 0 is timer interrupt,
	//Interrupt 2 is bus misaligned error warning,
	//Interrupt 3 is illegal instruction warning,
	//Interrupt 20 and 21 is two demo interrupt, triggered by two buttons.
	irq_enable_one_bit(0);			//Enable timer interrupt
	irq_enable_one_bit(2);			//Enable bus misaligned exception
	irq_enable_one_bit(3);			//Enable illegal instruction exception

	enable_external_interrupt();	//Enable external interrupt
	enable_timer_interrupt();		//Enable timer interrupt

	enable_interrupt_global();		//Enable global interrupt
	
	printf("\r\n------------------- LAPAY_PicoRV32 Demo ----------------------\r\n");

#if BUILD_MODE == BUILD_LOAD
	printf("\r\nMCU boot from and run in ITCM.\r\n");
#endif

#if BUILD_MODE == BUILD_BURN
	printf("\r\nMCU boot from external flash and run in ITCM.\r\n");
#endif

#if BUILD_MODE == BUILD_XIP
	printf("\r\nMCU boot from and run in external flash.\r\n");
#endif

	printf("\r\n");

	delay(SYSCLKFREQ >> 1);

	wbreg_demo(); 		//Demo the peripheral connected to the MCU through the open Wishbone interface
	ahbreg_demo();		//Demo the peripheral connected to the MCU through the open AHC interface
	spi_flash_demo();	//Demo the SPI flash
	gpio_out_demo(); 	//Demo the GPIO output function with the led on develop board.
	uart_rx_demo(); 	//Demo the wbuart's RX, it wait until you input a byte through the UART terminal, and display the byte back on UART terminal

	stats();			//Print

	GPIO_SetDir(PICO_WBGPIO, 0x0000000f);
	GPIO_WriteData(PICO_WBGPIO, 0xffffffff);	//Reset the gpio's condition

	set_timer(SYSCLKFREQ>>1); 					//Set the timer a non-zero value, this will start the timer automatically.

	//Enable WBUART RX interrupt
	irq_enable_one_bit(13);

	while(1)
	{
		if(irq00_flag == 1)  //Timer interrupt
		{
			printf("\r\nEnter timer interrupt...\r\n");

			//When timer interrupt is triggered, change the led situation, and output a count message through the WBUART,
			//Then set the timer value again and start a new timer counting process.
			irq00_flag = 0;
			GPIO_WriteData(PICO_WBGPIO, ~(timer_count & 0xf));
			printf("Timer interrupt counter : %8d\r\n", timer_count);
			timer_count++;
			if(timer_count == 16)
			{
				irq_disable_one_bit(20);	//Disable external interrupt 20, button 1
				irq_disable_one_bit(21);	//Disable external interrupt 21, button 2
			}
			else if(timer_count == 32)
			{
				irq_enable_one_bit(20);		//Enable external interrupt 20, button 1
				irq_enable_one_bit(21);		//Enable external interrupt 21, button 2
			}

			set_timer(SYSCLKFREQ>>1);  		//This will set the timer interval as 1 second.

			irq_enable_one_bit(0);
		}

		if(irq13_flag == 1)  	//WBUART RX interrupt
		{
			printf("\r\nEnter WBUART RX interrupt...\r\n");

			//When a byte is received, the WBUART interrupt will be triggered
			//Display it on UART terminal and move on.
			irq13_flag = 0;
			wbuart_rx_buffer = wbuart_getc();
			printf("Receive a byte in WBUART RX interrupt : %x\r\n", wbuart_rx_buffer);
			irq_enable_one_bit(13);
		}

		if(irq20_flag == 1)  	//A test interrupt input by a button
		{
			printf("\r\nPress button 1, enter an external interrupt 20...\r\n");

			//When the button is pushed. interrupt 20 will be triggered
			//Display the interrupt information on UART terminal and move on.
			irq20_flag = 0;
			printf("Interrupt 20 is triggered by button 1\r\n");
			irq_enable_one_bit(20);
		}

		if(irq21_flag == 1)		//Another test interrupt also input by a button
		{
			printf("\r\nPress button 2, enter an external interrupt 21...\r\n");

			//Same as interrupt 20
			irq21_flag = 0;
			printf("Interrupt 21 is triggered by button 2\r\n");
			irq_enable_one_bit(21);
		}
	}

	return 0;
}

//SPI-Flash demo
void spi_flash_demo(void)
{
	printf("Wishbone SPI-Flash demo beginning...\r\n");

	uint32_t *memmap_ptr = (uint32_t *)(MEM_MAP_ADDR1);
	uint32_t tmp = 0;

	printf("Read instruction by memory map mode from flash...\r\n");
	for(int i = 0; i < 100; i++)
	{
		tmp = *memmap_ptr;
		printf("%08x ", tmp);
		memmap_ptr++;
	}
	printf("\r\n");

	//Initializes TX buffer
	for(int i = 0; i < 100; i++)
	{
		tx_buffer[i] = i;
	}

	//First read the data from flash
	printf("Read initialized data from flash...\r\n");
	spi_flash_read(100, 0x03, 0x610000, rx_buffer);
	for(int i = 0 ; i< 100; i ++ )
	{
		printf("%02x ", rx_buffer[i]);
	}
	printf("\r\n");

	//And erase the sector
	printf("Erase flash...\r\n");
	spi_flash_sector_erase(0x610000);

	printf("Read data after erase flash...\r\n");
	spi_flash_read(100, 0x03, 0x610000, rx_buffer);
	for(int i = 0 ; i < 100 ; i ++ )
	{
		printf("%02x ", rx_buffer[i]);
	}
	printf("\r\n");

	//Write data to SPI flash
	printf("Page program data...\r\n");
	spi_flash_page_program(100, 0x610000, tx_buffer);

	//Read the data be written
	printf("Read data after page program flash...\r\n");
	spi_flash_read(100, 0x03, 0x610000, rx_buffer);

	for(int i = 0 ; i < 100 ; i ++ )
	{
		printf("%02x ", rx_buffer[i]);
	}
	printf("\r\n");

	memmap_ptr = (uint32_t *)(MEM_MAP_ADDR2);
	uint32_t tmp_word = 0;
	printf("Read data by memory map mode from flash...\r\n");
	for(int i = 0; i < 100; i++)
	{
		tmp_word = *memmap_ptr;
		printf("%08x ", tmp_word);
		memmap_ptr++;
	}
	printf("\r\n");

	printf("Wishbone SPI-Flash demo finished.\r\n");
	printf("\r\n");

	return;
}

//WBGPIO demo
void gpio_out_demo(void)
{
	unsigned int i = 0;
	uint32_t val = 0x11111111;
    uint32_t cnt = 0;

	printf("Wishbone GPIO output demo beginning...\r\n");
	printf("Please check the LED running status on board\r\n");

	GPIO_SetDir(PICO_WBGPIO, 0x0000000f);
	GPIO_WriteData(PICO_WBGPIO, 0xffffffff);

	while(cnt < 20)
	{
		for(i = 0; i < 4; i++)
		{
			GPIO_WriteData(PICO_WBGPIO, ~val);
			val = val << 1;

		    delay(50000000);
		    cnt++;
		    printf("LED running: %d\r\n", cnt);
		}
		val = 0x11111111;
	}
	val = 0x00000000;
	GPIO_WriteData(PICO_WBGPIO, val);

	printf("Wishbone GPIO output demo finished.\r\n");
	printf("\r\n");

	return;
}

//Open Wishbone interface demo
void wbreg_demo(void)
{
	printf("Open Wishbone interface demo beginning...\r\n");
	printf("Wishbone extension demo, write and read back the three registers on the open Wishbone interface\r\n");

	volatile uint32_t *ptr_reg0 = (uint32_t *)(0x20000000);
	volatile uint16_t *ptr_reg1 = (uint16_t *)(0x20000004);
	volatile uint8_t  *ptr_reg2 = (uint8_t  *)(0x20000008);

	printf("Before write Wishbone demo register:\r\n");
	printf("Reg0: %08x\r\n", *ptr_reg0);
	printf("Reg1: %04x\r\n", *ptr_reg1);
	printf("Reg2: %02x\r\n", *ptr_reg2);

	*ptr_reg0 = (*ptr_reg0) + 0x11111111;
	*ptr_reg1 = (*ptr_reg1) + 0x1111;
	*ptr_reg2 = (*ptr_reg2) + 0x11;

	printf("After write Wishbone demo register:\r\n");
	printf("Reg0: %08x\r\n", *ptr_reg0);
	printf("Reg1: %04x\r\n", *ptr_reg1);
	printf("Reg2: %02x\r\n", *ptr_reg2);
	printf("Open Wishbone interface demo finished.\r\n");
	printf("\r\n");

	return;
}

//Open AHB interface demo
void ahbreg_demo(void)
{
	uint32_t tmp0 = 0x01234567;
	uint32_t tmp1 = 0x89abcdef;
	uint32_t rdbk = 0;

	printf("Open AHB bus interface demo beginning...\r\n");

	PICO_AHBREGDEMO->REG0 = tmp0;
	PICO_AHBREGDEMO->REG1 = tmp1;

	rdbk = PICO_AHBREGDEMO->REG0;
	printf("ahbreg0 is  %08x\r\n", rdbk);

	rdbk = PICO_AHBREGDEMO->REG1;
	printf("ahbreg1 is %08x\r\n", rdbk);

	printf("Open AHB bus interface demo finished.\r\n");
	printf("\r\n");

	return;
}

//WBUART RX Demo
void uart_rx_demo(void)
{
	uint32_t rx_buffer_local = 0;

	printf("Wishbone UART RX demo beginning...\r\n");
	printf("Receive a byte from UART RX port\r\n");

	rx_buffer_local = wbuart_getc();

	printf("received: %x\r\n", rx_buffer_local);
	printf("Wishbone UART RX demo finished.\r\n");
	printf("\r\n");

	return;
}
