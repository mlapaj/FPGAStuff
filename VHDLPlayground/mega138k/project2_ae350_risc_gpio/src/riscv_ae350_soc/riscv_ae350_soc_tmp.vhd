--Copyright (C)2014-2024 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--Tool Version: V1.9.11
--Part Number: GW5AST-LV138PG484AC1/I0
--Device: GW5AST-138
--Device Version: B
--Created Time: Fri Jan 17 14:59:18 2025

--Change the instance name and port connections to the signal names
----------Copy here to design--------

component RiscV_AE350_SOC_Top
	port (
		FLASH_SPI_CSN: inout std_logic;
		FLASH_SPI_MISO: inout std_logic;
		FLASH_SPI_MOSI: inout std_logic;
		FLASH_SPI_CLK: inout std_logic;
		FLASH_SPI_HOLDN: inout std_logic;
		FLASH_SPI_WPN: inout std_logic;
		DDR3_MEMORY_CLK: in std_logic;
		DDR3_CLK_IN: in std_logic;
		DDR3_RSTN: in std_logic;
		DDR3_LOCK: in std_logic;
		DDR3_STOP: out std_logic;
		DDR3_INIT: out std_logic;
		DDR3_BANK: out std_logic_vector(2 downto 0);
		DDR3_CS_N: out std_logic;
		DDR3_RAS_N: out std_logic;
		DDR3_CAS_N: out std_logic;
		DDR3_WE_N: out std_logic;
		DDR3_CK: out std_logic;
		DDR3_CK_N: out std_logic;
		DDR3_CKE: out std_logic;
		DDR3_RESET_N: out std_logic;
		DDR3_ODT: out std_logic;
		DDR3_ADDR: out std_logic_vector(13 downto 0);
		DDR3_DM: out std_logic_vector(1 downto 0);
		DDR3_DQ: inout std_logic_vector(15 downto 0);
		DDR3_DQS: inout std_logic_vector(1 downto 0);
		DDR3_DQS_N: inout std_logic_vector(1 downto 0);
		TCK_IN: in std_logic;
		TMS_IN: in std_logic;
		TRST_IN: in std_logic;
		TDI_IN: in std_logic;
		TDO_OUT: out std_logic;
		TDO_OE: out std_logic;
		SPI_HOLDN: inout std_logic;
		SPI_WPN: inout std_logic;
		SPI_CLK: inout std_logic;
		SPI_CSN: inout std_logic;
		SPI_MISO: inout std_logic;
		SPI_MOSI: inout std_logic;
		UART2_TXD: out std_logic;
		UART2_RTSN: out std_logic;
		UART2_RXD: in std_logic;
		UART2_CTSN: in std_logic;
		UART2_DCDN: in std_logic;
		UART2_DSRN: in std_logic;
		UART2_RIN: in std_logic;
		UART2_DTRN: out std_logic;
		UART2_OUT1N: out std_logic;
		UART2_OUT2N: out std_logic;
		GPIO: inout std_logic_vector(31 downto 0);
		CORE0_WFI_MODE: out std_logic;
		RTC_WAKEUP: out std_logic;
		CORE_CLK: in std_logic;
		DDR_CLK: in std_logic;
		AHB_CLK: in std_logic;
		APB_CLK: in std_logic;
		RTC_CLK: in std_logic;
		POR_RSTN: in std_logic;
		HW_RSTN: in std_logic
	);
end component;

your_instance_name: RiscV_AE350_SOC_Top
	port map (
		FLASH_SPI_CSN => FLASH_SPI_CSN,
		FLASH_SPI_MISO => FLASH_SPI_MISO,
		FLASH_SPI_MOSI => FLASH_SPI_MOSI,
		FLASH_SPI_CLK => FLASH_SPI_CLK,
		FLASH_SPI_HOLDN => FLASH_SPI_HOLDN,
		FLASH_SPI_WPN => FLASH_SPI_WPN,
		DDR3_MEMORY_CLK => DDR3_MEMORY_CLK,
		DDR3_CLK_IN => DDR3_CLK_IN,
		DDR3_RSTN => DDR3_RSTN,
		DDR3_LOCK => DDR3_LOCK,
		DDR3_STOP => DDR3_STOP,
		DDR3_INIT => DDR3_INIT,
		DDR3_BANK => DDR3_BANK,
		DDR3_CS_N => DDR3_CS_N,
		DDR3_RAS_N => DDR3_RAS_N,
		DDR3_CAS_N => DDR3_CAS_N,
		DDR3_WE_N => DDR3_WE_N,
		DDR3_CK => DDR3_CK,
		DDR3_CK_N => DDR3_CK_N,
		DDR3_CKE => DDR3_CKE,
		DDR3_RESET_N => DDR3_RESET_N,
		DDR3_ODT => DDR3_ODT,
		DDR3_ADDR => DDR3_ADDR,
		DDR3_DM => DDR3_DM,
		DDR3_DQ => DDR3_DQ,
		DDR3_DQS => DDR3_DQS,
		DDR3_DQS_N => DDR3_DQS_N,
		TCK_IN => TCK_IN,
		TMS_IN => TMS_IN,
		TRST_IN => TRST_IN,
		TDI_IN => TDI_IN,
		TDO_OUT => TDO_OUT,
		TDO_OE => TDO_OE,
		SPI_HOLDN => SPI_HOLDN,
		SPI_WPN => SPI_WPN,
		SPI_CLK => SPI_CLK,
		SPI_CSN => SPI_CSN,
		SPI_MISO => SPI_MISO,
		SPI_MOSI => SPI_MOSI,
		UART2_TXD => UART2_TXD,
		UART2_RTSN => UART2_RTSN,
		UART2_RXD => UART2_RXD,
		UART2_CTSN => UART2_CTSN,
		UART2_DCDN => UART2_DCDN,
		UART2_DSRN => UART2_DSRN,
		UART2_RIN => UART2_RIN,
		UART2_DTRN => UART2_DTRN,
		UART2_OUT1N => UART2_OUT1N,
		UART2_OUT2N => UART2_OUT2N,
		GPIO => GPIO,
		CORE0_WFI_MODE => CORE0_WFI_MODE,
		RTC_WAKEUP => RTC_WAKEUP,
		CORE_CLK => CORE_CLK,
		DDR_CLK => DDR_CLK,
		AHB_CLK => AHB_CLK,
		APB_CLK => APB_CLK,
		RTC_CLK => RTC_CLK,
		POR_RSTN => POR_RSTN,
		HW_RSTN => HW_RSTN
	);

----------Copy end-------------------
