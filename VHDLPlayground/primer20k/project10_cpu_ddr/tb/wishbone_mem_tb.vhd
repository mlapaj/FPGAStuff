
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wishbone_mem_tb is
end entity;

architecture basic of wishbone_mem_tb is
    signal gen_clk: std_logic := '0';
    signal gen_pll_clk: std_logic := '0';
    signal gen_rstn: std_logic := '0';
    constant f_pll_clock_c  : natural := 200000000; -- pll clock in Hz
    constant t_pll_clock_c  : time := (1 sec) / f_pll_clock_c;
    constant f_clock_c      : natural := 27000000; -- main clock in Hz
    constant t_clock_c      : time := (1 sec) / f_clock_c;
    component wishbone_mem is
        port (
                 clk_i          : in std_logic;
                 -- pll lock
                 pll_clk        : in std_logic;
                 pll_lock       : in std_logic;
                 rstn_i         : in std_logic;
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
                 wb_err_o       : out  std_ulogic
             );
    end component;
    signal wb_stb : std_logic;
    signal wb_cyc : std_logic;
    signal wb_we : std_logic;
    signal test_cnt : integer range 0 to 10;
    signal wb_adr : std_ulogic_vector(31 downto 0);
    type t_TestState is (TestRead, TestWrite );
    signal TestState : t_TestState;
begin
    gen_clk<= not gen_clk after (t_clock_c/2);
    gen_pll_clk<= not gen_pll_clk after (t_pll_clock_c/2);
    gen_rstn <= '0', '1' after 60*(t_clock_c/2);

    mem0: wishbone_mem port map
    (
        clk_i => gen_clk,
        rstn_i => gen_rstn,
        pll_clk => gen_pll_clk,
        pll_lock => '1',
        wb_tag_i => "000",
        wb_adr_i => wb_adr,
        --wb_dat_0 => '0',
        wb_dat_i => "00010001001000100011001101000100",
        wb_we_i => wb_we,
        wb_sel_i => "0000",
        wb_stb_i => wb_stb,
        wb_cyc_i => wb_cyc
        --wb_ack_o =>
        --wb_err_o =>
    );

    process (gen_clk)
    begin
        if rising_edge(gen_clk) then
            if gen_rstn = '0' then
                test_cnt <= 0;
                wb_stb <= '0';
                wb_cyc <= '0';
                wb_adr <= (others => '0');
                wb_we <= '0';
                TestState <= TestWrite;
            else
                if (TestState = TestRead) then
                    if test_cnt = 0 or test_cnt = 1 or test_cnt = 2 then
                        wb_cyc <= '1';
                        wb_stb <= '1';
                    else
                        wb_cyc <= '0';
                        wb_stb <= '0';
                    end if;
                    if test_cnt = 10 then
                        test_cnt <= 0;
                        wb_adr <= wb_adr + "100";
                        TestState <= TestRead;
                    else
                        test_cnt <= test_cnt + 1;
                    end if;
                elsif (TestState = TestWrite) then
                    if test_cnt = 0 or test_cnt = 1 or test_cnt = 2 then
                        wb_cyc <= '1';
                        wb_stb <= '1';
                        wb_we <= '1';
                    else
                        wb_cyc <= '0';
                        wb_stb <= '0';
                        wb_we <= '0';
                    end if;
                    if test_cnt = 10 then
                        TestState <= TestWrite;
                        test_cnt <= 0;
                        wb_adr <= wb_adr + "100";
                    else
                        test_cnt <= test_cnt + 1;
                    end if;

                end if;
            end if;
        end if;
    end process;
end architecture;
