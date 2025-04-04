library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
port (
         -- GPIO
         LED: inout std_logic_vector(2 downto 0);    -- 2:0
         KEY: inout std_logic_vector(2 downto 0);    -- 5:3
                                                     -- CLK
         CLK: in std_logic;
         RSTN: in std_logic;
         -- UART
         UART2_TXD: out std_logic;
         UART2_RXD: in std_logic;
         --- SPI
         FLASH_SPI_CSN: inout std_logic;
         FLASH_SPI_MISO: inout std_logic;
         FLASH_SPI_MOSI: inout std_logic;
         FLASH_SPI_CLK: inout std_logic;
		 FLASH_SPI_HOLDN: inout std_logic;
         FLASH_SPI_WPN: inout std_logic;
         -- DDR3
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
         -- JTAG
		 TCK_IN: in std_logic;
		 TMS_IN: in std_logic;
		 TRST_IN: in std_logic;
		 TDI_IN: in std_logic;
		 TDO_OUT: out std_logic
     );
end top;

architecture basic of top is

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

component Gowin_PLL
    port (
        clkout0: out std_logic;
        clkout1: out std_logic;
        clkout2: out std_logic;
        clkout3: out std_logic;
        clkout4: out std_logic;
        clkin: in std_logic;
        enclk0: in std_logic;
        enclk1: in std_logic;
        enclk2: in std_logic;
        enclk3: in std_logic;
        enclk4: in std_logic
    );
end component;


component Gowin_PLL_DDR3
    port (
        lock: out std_logic;
        clkout0: out std_logic;
        clkout2: out std_logic;
        clkin: in std_logic;
        reset: in std_logic;
        enclk0: in std_logic;
        enclk2: in std_logic
    );
end component;



     signal CORE_CLK : std_logic;
     signal DDR_CLK : std_logic;
     signal AHB_CLK : std_logic;
     signal APB_CLK : std_logic;
     signal RTC_CLK : std_logic;

     signal DDR3_MEMORY_CLK : std_logic;
     signal DDR3_CLK_IN : std_logic;
     signal DDR3_LOCK : std_logic;
     signal DDR3_STOP : std_logic;

-- check
signal ae350_rstn: std_logic; -- AE350 power on and hardware reset in
signal ddr3_rstn: std_logic; -- DDR3 memory reset in
signal ddr3_init_completed: std_logic; -- DDR3 memory initialized completed
signal gpio_rest: std_logic_vector (28 downto 0); -- DDR3 memory initialized completed

begin
PLL: Gowin_PLL
    port map (
        clkout0 => DDR_CLK,
        clkout1 => CORE_CLK,
        clkout2 => AHB_CLK,
        clkout3 => APB_CLK,
        clkout4 => RTC_CLK,
        clkin => CLK,
        enclk0 => '1',
        enclk1 => '1',
        enclk2 => '1',
        enclk3 => '1',
        enclk4 => '1'
    );

PLL_DDR3: Gowin_PLL_DDR3
    port map (
        lock => DDR3_LOCK,
        clkout0 => DDR3_CLK_IN,
        clkout2 => DDR3_MEMORY_CLK,
        clkin => CLK,
        reset => '0',
        enclk0 => '1',
        enclk2 => DDR3_STOP
    );



CPU: RiscV_AE350_SOC_Top
	port map (
		FLASH_SPI_CSN => FLASH_SPI_CSN,
		FLASH_SPI_MISO => FLASH_SPI_MISO,
		FLASH_SPI_MOSI => FLASH_SPI_MOSI,
		FLASH_SPI_CLK => FLASH_SPI_CLK,
		FLASH_SPI_HOLDN => FLASH_SPI_HOLDN,
		FLASH_SPI_WPN => FLASH_SPI_WPN,
		DDR3_MEMORY_CLK => DDR3_MEMORY_CLK,
		DDR3_CLK_IN => DDR3_CLK_IN,
		DDR3_RSTN => RSTN,  -- DDR3_RSTN,
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
		TDO_OE => open, -- TO CHECK
		UART2_TXD => UART2_TXD,
		UART2_RTSN => open,
		UART2_RXD => UART2_RXD,
		UART2_CTSN => '0', -- TO CHECK
		UART2_DCDN => '0', -- TO CHECK
		UART2_DSRN => '0', -- TO CHECK
		UART2_RIN => '0', -- TO CHECK
		UART2_DTRN => open,
		UART2_OUT1N => open,
		UART2_OUT2N => open,
		--GPIO => GPIO,
        GPIO(31 downto 3) => gpio_rest,
        GPIO(2 downto 0) => LED,
		-- CORE0_WFI_MODE => 'Z', -- TO CHECK
		RTC_WAKEUP => open, -- TO CHECK
		CORE_CLK => CORE_CLK,
		DDR_CLK => DDR_CLK,
		AHB_CLK => AHB_CLK,
		APB_CLK => APB_CLK,
		RTC_CLK => RTC_CLK,
		POR_RSTN => DDR3_INIT, -- todo: key debounce was used
		HW_RSTN => DDR3_INIT -- todo: key debounce was used
	);

end basic;
