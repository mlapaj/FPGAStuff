library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.z80system_rom_image.all;

entity z80system_rom is
  port (
    -- Global control --
    clk_i       : in std_logic; -- global clock, rising edge
    mreqn_i     : in std_logic;
    rd_i        : in std_logic;
    addr_i      : in std_logic_vector(15 downto 0);
    data_o      : out std_logic_vector(7 downto 0)
  );
end entity;

architecture basic of z80system_rom is
signal data_tmp: std_logic_vector(7 downto 0);
begin
	process (clk_i)
		variable addr : std_logic_vector(15 downto 0);
	begin
		if (falling_edge(clk_i)) then
			if (mreqn_i = '0') then
				addr := addr_i;
			end if;
			if rd_i = '0' and mreqn_i = '0' then
				if (unsigned(addr) < 16384) then
					data_o <= rom_image(to_integer(unsigned(addr)));
					report "read rom[ " & to_hstring(addr) & "] =" & 
					to_hstring(rom_image(to_integer(unsigned(addr))));
				else
					data_o <= "ZZZZZZZZ";
				end if;
			end if;
			if (rd_i = '1') then
				data_o <= "ZZZZZZZZ";
			end if;
		end if;
	end process;
end;
