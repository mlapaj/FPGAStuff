library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- to speedup
use work.image.all;

entity z80system_ram is
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
		addr2_i      : in std_logic_vector(15 downto 0);
		data2_o      : out std_logic_vector(7 downto 0)
  );
end entity;

architecture basic of z80system_ram is
signal data_tmp: std_logic_vector(7 downto 0);
begin

    process (clkrd_i)
		variable addr: std_logic_vector(15 downto 0);
	begin
		if (falling_edge(clkrd_i)) then
            if (rd2_i = '0')  then
                addr := addr2_i;
                report "read2 from addr " & to_hstring(addr);
				if (unsigned(addr) > 16383) and (unsigned(addr) < 65536) then
					report "reading2 from ram[" & to_hstring(addr) & "]=" &
					to_hstring(rom_image(to_integer(unsigned(addr))-16384));
					data2_o <= rom_image(to_integer(unsigned(addr))-16384);
				else
					data2_o <= "ZZZZZZZZ";
				end if;
			end if;
        end if;
	end process;

end;
