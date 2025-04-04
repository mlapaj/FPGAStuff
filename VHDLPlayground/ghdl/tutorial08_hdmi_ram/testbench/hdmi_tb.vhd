library ieee;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.image.all;

entity hdmi_tb is
end hdmi_tb;

architecture test of hdmi_tb is
	component hdmi is
	  port (
		-- Global control --
		clk_i       : in  std_logic; -- global clock, rising edge
		rdy_i       : in  std_logic;
		rstn_i      : in  std_logic; -- global reset, low-active, async
		tmds_clk_p_o: out std_logic;
		tmds_clk_n_o: out std_logic;
		tmds_data_p_o: out std_logic_vector(2 downto 0);
		tmds_data_n_o: out std_logic_vector(2 downto 0);
		-- ram access
		rd_o        : out std_logic;
		addr_o      : out std_logic_vector(15 downto 0);
		data_i      : in std_logic_vector(7 downto 0)
	  );
	end component;

	component z80system_ram is
	  port (
			clk_i       : in std_logic; -- global clock, rising edge
			mreqn_i     : in std_logic;
			rd_i        : in std_logic;
			wr_i        : in std_logic;
			addr_i      : in std_logic_vector(15 downto 0);
			data_i      : in std_logic_vector(7 downto 0);
			data_o      : out std_logic_vector(7 downto 0);
			-- second port
			clkrd_i     : in std_logic;
			rd2_i       : in std_logic;
			addr2_i     : in std_logic_vector(15 downto 0);
			data2_o     : out std_logic_vector(7 downto 0)
	  );
	end component;
	-- testbench signals
	signal tb_mreqn_i     : std_logic := '1';
	signal tb_rd_i        : std_logic := '1';
	signal tb_wr_i        : std_logic := '1';
	signal tb_addr_i      : std_logic_vector(15 downto 0);
	signal tb_data_i      : std_logic_vector(7 downto 0);
	signal tb_data_o      : std_logic_vector(7 downto 0);
	signal tb_clkrd_i     : std_logic;
	signal tb_rd2_i       : std_logic := '1';
	signal tb_addr2_i     : std_logic_vector(15 downto 0);
	signal tb_data2_o     : std_logic_vector(7 downto 0);

	signal tb_clk_o : std_logic := '0';
	signal rstn_o   : std_logic := '0';
	signal rdy_i    :  std_logic := '0';
	constant f_clock_c : natural := 8000000; -- main clock in Hz
	constant t_clock_c : time := (1 sec) / f_clock_c;

	signal tb_clk2_o : std_logic := '0';
	constant f_clock2_c : natural := 72500000; -- main clock in Hz
	constant t_clock2_c : time := (1 sec) / f_clock2_c;
begin
	ram0: z80system_ram port map (tb_clk_o, tb_mreqn_i, tb_rd_i, tb_wr_i, tb_addr_i, tb_data_i, tb_data_o,
									tb_clk2_o, tb_rd2_i, tb_addr2_i, tb_data2_o);
	hdmi0: hdmi port map (clk_i => tb_clk2_o, rdy_i => rdy_i , rstn_i => rstn_o, rd_o => tb_rd2_i, addr_o => tb_addr2_i, data_i => tb_data2_o);

    -- Clock/Reset Generator ------------------------------------------------------------------
    -- -------------------------------------------------------------------------------------------
	rstn_o <= '0', '1' after 4*(t_clock_c/2);
	tb_clk_o <= not tb_clk_o after (t_clock_c/2);
	tb_clk2_o <= not tb_clk_o after (t_clock_c/2);

	rdy_i <= '1';

	process
	begin
		wait;
	end process;


end;
