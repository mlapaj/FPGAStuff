library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use ieee.math_real.all;

entity scr_tb is
end scr_tb;

architecture test of scr_tb is

  constant f_clock_c        : natural := 8000000; -- main clock in Hz
  constant t_clock_c        : time := (1 sec) / f_clock_c;

  -- generators --
  signal clk_gen, rst_gen : std_ulogic := '0';

  component scr is
	  port (
	           -- Global control --
			   clk_i       : in  std_logic; -- global clock, rising edge
			   rstn_i      : in  std_logic; -- global reset, low-active, async
			   -- Memory access
			   mreqn_o     : out std_logic;
			   rd_o        : out std_logic;
			   addr_o      : out std_logic_vector(15 downto 0);
			   data_i      : in std_logic_vector(7 downto 0);
			   -- Memory access
			   pos_x      : in std_logic_vector(7 downto 0);
			   pos_y      : in std_logic_vector(7 downto 0)
  );
  end component;

  component z80system_rom is
	port (
	-- Global control --
			 clk_i       : in std_logic; -- global clock, rising edge
			 mreqn_i     : in std_logic;
			 rd_i        : in std_logic;
			 addr_i      : in std_logic_vector(15 downto 0);
			 data_o      : out std_logic_vector(7 downto 0)
		 );
  end component;

  signal tb_pos_x    : std_logic_vector(7 downto 0) := "00000000";
  signal tb_pos_y    : std_logic_vector(7 downto 0) := "00000000";
  signal tb_mreqn    : std_logic;
  signal tb_rd       : std_logic;
  signal tb_addr     : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
  signal tb_data     : std_logic_vector(7 downto 0);
  signal cnt         : unsigned(2 downto 0);
begin

  -- Clock/Reset Generator ------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  clk_gen <= not clk_gen after (t_clock_c/2);
  rst_gen <= '0', '1' after 60*(t_clock_c/2);

  -- request for draw particular pixel in screen
  process (clk_gen)
  begin
	  if (rst_gen = '0') then
		  tb_pos_x <= (others => '0');
		  tb_pos_y <= (others => '0');
		  cnt <= "000";
	  elsif (rising_edge(clk_gen)) then
		  if (cnt < 4) then
			  cnt <= cnt + 1;
			  report "increasing counter";
		  else
			  report "handling screen";
			  cnt <= "000";
			  if (unsigned(tb_pos_x) < 255) then
				  tb_pos_x <= (std_logic_vector(unsigned(tb_pos_x)) + 1);
			  else
				  tb_pos_x <= (others => '0');
				  if (unsigned(tb_pos_y) < 191) then
					  tb_pos_y <= (std_logic_vector(unsigned(tb_pos_y)) + 1);
				  else
					  tb_pos_y <= (others => '0');
				  end if;
			  end if;
		  end if;
		end if;
  end process;

  dut_scr : scr port map (
						clk_i => clk_gen,
						rstn_i => rst_gen,
						pos_x => tb_pos_x,
						pos_y => tb_pos_y,
						rd_o => tb_rd,
						mreqn_o => tb_mreqn,
						addr_o => tb_addr,
						data_i => tb_data
					);
  dut_mem: z80system_rom port map (
						clk_i => clk_gen,
						rd_i => tb_rd,
						mreqn_i => tb_mreqn,
						addr_i => tb_addr,
						data_o => tb_data
					);


end test;
