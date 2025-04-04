library ieee;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity hdmi_tb is
end hdmi_tb;

architecture test of hdmi_tb is
	signal tb_clk_o : std_logic := '0';
	signal rstn_o   : std_logic := '0';
	constant f_clock_c : natural := 8000000; -- main clock in Hz
	constant t_clock_c : time := (1 sec) / f_clock_c;
	component hdmi is
	  port (
		-- Global control --
		clk_i       : in  std_logic; -- global clock, rising edge
		rstn_i      : in  std_logic; -- global reset, low-active, async
		tmds_clk_p_o: out std_logic;
		tmds_clk_n_o: out std_logic;
		tmds_data_p_o: out std_logic_vector(2 downto 0);
		tmds_data_n_o: out std_logic_vector(2 downto 0)
	  );
	end component;
begin
	dut: hdmi port map (tb_clk_o, rstn_o);

    -- Clock/Reset Generator ------------------------------------------------------------------
    -- -------------------------------------------------------------------------------------------
	tb_clk_o <= not tb_clk_o after (t_clock_c/2);
	rstn_o <= '0', '1' after 4*(t_clock_c/2);

	process
	begin
		wait;
	end process;


end;
