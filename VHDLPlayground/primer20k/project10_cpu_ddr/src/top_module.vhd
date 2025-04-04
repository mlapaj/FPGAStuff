library IEEE;
use ieee.std_logic_1164.all;

entity top_module is
port (
    CLK: in std_logic;
    UART_TXD: out std_logic;
    UART_RXD: in std_logic;
    GPIO: out std_logic;
    RSTN: in std_logic;

    -- JTAG on-chip debugger interface --
    jtag_trst_i : in  std_ulogic; -- low-active TAP reset (optional)
    jtag_tck_i  : in  std_ulogic; -- serial clock
    jtag_tdi_i  : in  std_ulogic; -- serial data input
    jtag_tdo_o  : out std_ulogic; -- serial data output
    jtag_tms_i  : in  std_ulogic; -- mode select


    -- ddr3
    O_ddr_addr_o: out std_logic_vector(13 downto 0);
    O_ddr_ba_o: out std_logic_vector(2 downto 0);
    O_ddr_cs_n_o: out std_logic;
    O_ddr_ras_n_o: out std_logic;
    O_ddr_cas_n_o: out std_logic;
    O_ddr_we_n_o: out std_logic;
    O_ddr_clk_o: out std_logic;
    O_ddr_clk_n_o: out std_logic;
    O_ddr_cke_o: out std_logic;
    O_ddr_odt_o: out std_logic;
    O_ddr_reset_n_o: out std_logic;
    O_ddr_dqm_o: out std_logic_vector(1 downto 0);
    IO_ddr_dq_io: inout std_logic_vector(15 downto 0);
    IO_ddr_dqs_io: inout std_logic_vector(1 downto 0);
    IO_ddr_dqs_n_io: inout std_logic_vector(1 downto 0);
    -- out
    dbg_led : out std_logic

);
end top_module;

architecture basic of top_module is
component neorv32_test_setup_bootloader is
  generic (
    -- adapt these for your setup --
    CLOCK_FREQUENCY   : natural := 27000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE : natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE : natural := 8*1024     -- size of processor-internal data memory in bytes
  );
  port (
    -- Global control --
    clk_i       : in  std_ulogic; -- global clock, rising edge
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
    -- UART0 --
    uart0_txd_o : out std_ulogic; -- UART0 send data
    uart0_rxd_i : in  std_ulogic;  -- UART0 receive data
    -- Wishbone bus interface (available if MEM_EXT_EN = true) --
    wb_tag_o       : out std_ulogic_vector(02 downto 0);
    wb_adr_o       : out std_ulogic_vector(31 downto 0);
    wb_dat_i       : in  std_ulogic_vector(31 downto 0) := (others => 'U');
    wb_dat_o       : out std_ulogic_vector(31 downto 0);
    wb_we_o        : out std_ulogic;
    wb_sel_o       : out std_ulogic_vector(03 downto 0);
    wb_stb_o       : out std_ulogic;
    wb_cyc_o       : out std_ulogic;
    wb_ack_i       : in  std_ulogic := 'L';
    wb_err_i       : in  std_ulogic := 'L';
    -- JTAG on-chip debugger interface --
    jtag_trst_i : in  std_ulogic; -- low-active TAP reset (optional)
    jtag_tck_i  : in  std_ulogic; -- serial clock
    jtag_tdi_i  : in  std_ulogic; -- serial data input
    jtag_tdo_o  : out std_ulogic; -- serial data output
    jtag_tms_i  : in  std_ulogic -- mode select

  );
end component;

component wishbone_mem is
    port (
             clk_i          : in std_logic;
             rstn_i         : in std_logic;
             -- pll lock
             pll_clk        : in std_logic;
             pll_lock        : in std_logic;
             -- Wishbone bus interface (available if MEM_EXT_EN = true) --
             wb_tag_i       : in std_ulogic_vector(02 downto 0);
             wb_adr_i       : in std_ulogic_vector(31 downto 0);
             wb_dat_o       : out  std_ulogic_vector(31 downto 0);
             wb_dat_i       : in std_ulogic_vector(31 downto 0);
             wb_we_i        : in std_ulogic;
             wb_sel_i       : in std_ulogic_vector(03 downto 0);
             wb_stb_i       : in std_ulogic;
             wb_cyc_i       : in std_ulogic;
             wb_ack_o       : out  std_ulogic;
             wb_err_o       : out  std_ulogic;
             -- ddr3 mem
             -- ddr_rst_o: out std_logic;
             O_ddr_addr_o: out std_logic_vector(13 downto 0);
             O_ddr_ba_o: out std_logic_vector(2 downto 0);
             O_ddr_cs_n_o: out std_logic;
             O_ddr_ras_n_o: out std_logic;
             O_ddr_cas_n_o: out std_logic;
             O_ddr_we_n_o: out std_logic;
             O_ddr_clk_o: out std_logic;
             O_ddr_clk_n_o: out std_logic;
             O_ddr_cke_o: out std_logic;
             O_ddr_odt_o: out std_logic;
             O_ddr_reset_n_o: out std_logic;
             O_ddr_dqm_o: out std_logic_vector(1 downto 0);
             IO_ddr_dq_io: inout std_logic_vector(15 downto 0);
             IO_ddr_dqs_io: inout std_logic_vector(1 downto 0);
             IO_ddr_dqs_n_io: inout std_logic_vector(1 downto 0);
             -- debug
             dbg_led : out std_logic
         );
end component;


component Gowin_rPLL
    port (
             clkout: out std_logic;
             lock: out std_logic;
             reset: in std_logic;
             clkin: in std_logic
         );
end component;

-- ddr signals
signal wb_tag_o: std_ulogic_vector(02 downto 0);
signal wb_adr_o: std_ulogic_vector(31 downto 0);
signal wb_dat_i: std_ulogic_vector(31 downto 0);
signal wb_dat_o: std_ulogic_vector(31 downto 0);
signal wb_we_o:  std_ulogic;
signal wb_sel_o: std_ulogic_vector(03 downto 0);
signal wb_stb_o: std_ulogic;
signal wb_cyc_o: std_ulogic;
signal wb_ack_i: std_ulogic;
signal wb_err_i: std_ulogic;

-- pll
signal pll_clkout: std_logic;
signal pll_lock: std_logic;
begin
    my_pll : Gowin_rPLL
    port map (
                 clkout => pll_clkout,
                 lock => pll_lock,
                 reset => not RSTN,
                 clkin => CLK
             );


    neorv32: neorv32_test_setup_bootloader port map
    (
        clk_i => CLK,
        rstn_i => RSTN,
        uart0_rxd_i => UART_RXD,
        uart0_txd_o => UART_TXD,
        gpio_o(0) => GPIO,
        jtag_trst_i => jtag_trst_i, -- low-active TAP reset (optional)
        jtag_tck_i  => jtag_tck_i,  -- serial clock
        jtag_tdi_i  => jtag_tdi_i,  -- serial data input
        jtag_tdo_o  => jtag_tdo_o,  -- serial data output
        jtag_tms_i  => jtag_tms_i,  -- mode select
        wb_tag_o  => wb_tag_o,
        wb_adr_o  => wb_adr_o,
        wb_dat_i  => wb_dat_i,
        wb_dat_o  => wb_dat_o,
        wb_we_o   => wb_we_o,
        wb_sel_o  => wb_sel_o,
        wb_stb_o  => wb_stb_o,
        wb_cyc_o  => wb_cyc_o,
        wb_ack_i  => wb_ack_i,
        wb_err_i  => wb_err_i
    );

    wb_mem: wishbone_mem port map
    (
        clk_i => CLK,
        rstn_i => RSTN,
        pll_clk => pll_clkout,
        pll_lock => pll_lock,
        wb_adr_i => wb_adr_o,
        wb_sel_i => wb_sel_o,
        wb_cyc_i => wb_cyc_o,
        wb_dat_i => wb_dat_o,
        wb_dat_o => wb_dat_i,
        wb_stb_i => wb_stb_o,
        wb_tag_i => wb_tag_o,
        wb_ack_o => wb_ack_i,
        wb_we_i  => wb_we_o,
        O_ddr_addr_o => O_ddr_addr_o,
        O_ddr_ba_o => O_ddr_ba_o,
        O_ddr_cs_n_o => O_ddr_cs_n_o,
        O_ddr_ras_n_o => O_ddr_ras_n_o,
        O_ddr_cas_n_o => O_ddr_cas_n_o,
        O_ddr_we_n_o => O_ddr_we_n_o,
        O_ddr_clk_o => O_ddr_clk_o,
        O_ddr_clk_n_o => O_ddr_clk_n_o,
        O_ddr_cke_o => O_ddr_cke_o,
        O_ddr_odt_o => O_ddr_odt_o,
        O_ddr_reset_n_o => O_ddr_reset_n_o,
        O_ddr_dqm_o => O_ddr_dqm_o,
        IO_ddr_dq_io => IO_ddr_dq_io,
        IO_ddr_dqs_io => IO_ddr_dqs_io,
        IO_ddr_dqs_n_io => IO_ddr_dqs_n_io,
        dbg_led => dbg_led
    );



end basic;
