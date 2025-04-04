library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_module_tb is
end entity;

architecture test of top_module_tb is

    constant f_memory_clock_c      : natural := 20000000; -- main clock in Hz
    constant t_memory_clock_c        : time := (1 sec) / f_memory_clock_c;

    constant f_module_clock_c      : natural :=  2700000; -- main clock in Hz
    constant t_module_clock_c        : time := (1 sec) / f_module_clock_c;

  -- generators --
  signal memory_clk_gen, module_clk_gen, rst_gen : std_ulogic := '0';

  -- our hero

  component top is
      port (
               clk_i       : in  std_logic;
               rst_n_i      : in  std_logic;
               out_o       : out  std_logic;
               out_mem_o       : out  std_logic;
             -- dram
             -- clk_i: in std_logic;
             -- mem
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
               IO_ddr_dqs_n_io: inout std_logic_vector(1 downto 0)
           );
  end component;

begin

  -- Clock/Reset Generator ------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  memory_clk_gen <= not memory_clk_gen after (t_memory_clock_c/2);
  module_clk_gen <= not module_clk_gen after (t_module_clock_c/2);
  rst_gen <= '0', '1' after 60*(t_module_clock_c/2);

  tb_top : top port map (
       clk_i => memory_clk_gen,
       rst_n_i => rst_gen
   );
end test;
