library ieee;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_1164.all;
entity z80system_ram_tb is
	end z80system_ram_tb;

architecture test of z80system_ram_tb is
	component z80system_ram is
		port (
				 clk_i       : in std_logic; -- global clock, rising edge
				 mreqn_i     : in std_logic;
				 rd_i        : in std_logic;
				 wr_i        : in std_logic;
				 addr_i      : in std_logic_vector(15 downto 0);
				 data_i      : in std_logic_vector(7 downto 0);
				 data_o      : out std_logic_vector(7 downto 0)
			 );
	end component;

	signal TB_CLK: std_logic := '0';
	signal TB_MREQN_I: std_logic := '1';
	signal TB_RD_I: std_logic := '1';
	signal TB_WR_I: std_logic := '1';
	signal TB_ADDR_I: std_logic_vector(15 downto 0) := "0011111111111111";
	signal TB_RDWR:   std_logic_vector(4 downto 0) := "00000";
	signal TB_RD_TEST: std_logic := '0';
	signal TB_DATA_I: std_logic_vector(7 downto 0) := "00000000";
	constant f_clock_c        : natural := 8000000; -- main clock in Hz
	constant t_clock_c        : time := (1 sec) / f_clock_c;

begin
	dut: z80system_ram port map (TB_CLK, TB_MREQN_I, TB_RD_I, TB_WR_I, TB_ADDR_I, TB_DATA_I);

    -- Clock/Reset Generator ------------------------------------------------------------------
    -- -------------------------------------------------------------------------------------------
	TB_CLK <= not TB_CLK after (t_clock_c/2);


	process (TB_CLK)
	begin
		if (unsigned(TB_RDWR) < 3) and TB_RD_TEST = '0' then
			if rising_edge(TB_CLK) then
				TB_WR_I <= '0';
				TB_MREQN_I <= '0';
				TB_ADDR_I <= TB_ADDR_I + '1';
				TB_DATA_I <= TB_DATA_I + '1';
				TB_RDWR <= TB_RDWR + '1';
			elsif falling_edge(TB_CLK) then
				TB_WR_I <= '1';
				TB_MREQN_I <= '1';
			end if;
		elsif (unsigned(TB_RDWR) < 3) and TB_RD_TEST = '1' then
			if rising_edge(TB_CLK) then
				TB_RD_I <= '0';
				TB_MREQN_I <= '0';
				TB_ADDR_I <= TB_ADDR_I + '1';
				TB_RDWR <= TB_RDWR + '1';
			elsif falling_edge(TB_CLK) then
				TB_RD_I <= '1';
				TB_MREQN_I <= '1';
			end if;
		elsif (unsigned(TB_RDWR) >= 3) then
			TB_RDWR <= (others => '0');
			TB_RD_TEST <= not TB_RD_TEST;
			TB_ADDR_I <= "0011111111111111";
		end if;

	end process;
end;
