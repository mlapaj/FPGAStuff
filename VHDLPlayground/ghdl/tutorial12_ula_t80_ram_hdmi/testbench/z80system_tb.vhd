library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity z80system_tb is
end z80system_tb;

architecture test of z80system_tb is

  constant f_clock_c        : natural := 8000000; -- main clock in Hz
  constant t_clock_c        : time := (1 sec) / f_clock_c;

  -- generators --
  signal clk_gen, rst_gen : std_ulogic := '0';

  component z80system is
          port (
          -- Global control --
          clk_i       : in  std_ulogic; -- global clock, rising edge
          rstn_i      : in  std_ulogic -- global reset, low-active, async
            );
   end component;

begin

  -- Clock/Reset Generator ------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  clk_gen <= not clk_gen after (t_clock_c/2);
  rst_gen <= '0', '1' after 60*(t_clock_c/2);
  dut: z80system port map (clk_gen, rst_gen);

end test;
