library ieee;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.image.all;

entity ula_tb is
end ula_tb;

architecture test of ula_tb is
	component ula is
		port (
				 -- Reset --
				 rstn_i: in std_logic;
				 -- Input clock --
				 clk_i: in std_logic;

				 -- Output Z80 clock --
				 clk_cpu_o: out std_logic;

				 -- access to ram
				 mem_mreqn_o: out std_logic;
				 mem_rd_o:    out std_logic;
				 mem_wr_o:    out std_logic;
				 mem_addr_o:  out std_logic_vector(15 downto 0);
				 mem_data_o:  out std_logic_vector(7 downto 0);
				 mem_data_i:  in std_logic_vector(7 downto 0);

				 -- cpu to ram
				 cpu_mreqn_i: in std_logic;
				 cpu_rd_i:    in std_logic;
				 cpu_wr_i:    in std_logic;
				 cpu_addr_i:  in std_logic_vector(15 downto 0);
				 cpu_data_i:  in std_logic_vector(7 downto 0);
				 cpu_data_o:  out std_logic_vector(7 downto 0);

				-- cpu to video
				 vid_mreqn_i: in std_logic;
				 vid_rd_i:    in std_logic;
				 vid_wr_i:    in std_logic;
				 vid_addr_i:  in std_logic_vector(15 downto 0);
				 vid_data_i:  in std_logic_vector(7 downto 0);
				 vid_data_o:  out std_logic_vector(7 downto 0)

			 );
	end component;
	-- testbench signals
	signal tb_clk : std_logic := '0';
	signal rstn   : std_logic := '0'; -- check if really needed
	signal tb_vid_mreqn : std_logic := '0';

	constant f_clock_c : natural := 8000000; -- main clock in Hz
	constant t_clock_c : time := (1 sec) / f_clock_c;

begin
	ula0: ula port map (
				 clk_i       => tb_clk,
				 rstn_i       => rstn,
				 --clk_cpu_o :   out std_logic;
				 --mem_mreqn_o :     out std_logic;
				 --mem_rd_o :        out std_logic;
				 --mem_wr_o :        out std_logic;
				 --mem_addr_o :      out std_logic_vector(15 downto 0);
				 --mem_data_o      =>
				 mem_data_i      => "00000000",
				 cpu_mreqn_i => '0',
				 cpu_rd_i    => '1',
				 cpu_wr_i    => '0',
				 cpu_addr_i  => "0000000011111111",
				 cpu_data_i  => "11111111",
				 --cpu_data_o  =>      '0';
				 vid_mreqn_i => tb_vid_mreqn,
				 vid_rd_i    => '0',
				 vid_wr_i    => '1',
				 vid_addr_i  => "1100000000000011",
				 vid_data_i  => "10000001"
				 --vid_data_o =>      '0';
					   );
    -- Clock/Reset Generator ------------------------------------------------------------------
    -- -------------------------------------------------------------------------------------------
	rstn <= '0', '1' after 4*(t_clock_c/2);
	tb_clk <= not tb_clk after (t_clock_c/2);

    process
	begin
		wait for 15*(t_clock_c/2);
	    tb_vid_mreqn <= '1';
		wait for 30*(t_clock_c/2);
	    tb_vid_mreqn <= '0';
		wait;
	end process;


end;
