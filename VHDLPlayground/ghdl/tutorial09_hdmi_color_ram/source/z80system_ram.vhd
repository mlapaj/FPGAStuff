library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- to speedup
use work.image.all;
use work.palette.all;

entity z80system_ram is
  port (
		clk_i       : in std_logic; -- global clock, rising edge
		mreqn_i     : in std_logic;
		rd_i        : in std_logic;
		wr_i        : in std_logic;
		addr_i      : in std_logic_vector(15 downto 0);
		data_i      : in std_logic_vector(7 downto 0);
		data_o      : out std_logic_vector(7 downto 0);

        -- screen part
        zx_scr_clk_i    : in std_logic;
        zx_scr_rd_i     : in std_logic;
        zx_scr_x_i      : in std_logic_vector(7 downto 0);
        zx_scr_y_i      : in std_logic_vector(7 downto 0);
        zx_scr_rgb_r_o  : out std_logic_vector(7 downto 0);
        zx_scr_rgb_g_o  : out std_logic_vector(7 downto 0);
        zx_scr_rgb_b_o  : out std_logic_vector(7 downto 0)



  );
end entity;

architecture basic of z80system_ram is
signal data_tmp: std_logic_vector(7 downto 0);

begin
    process (zx_scr_clk_i)



		variable addr_scr: std_logic_vector(15 downto 0);
		variable data: std_logic_vector(7 downto 0);
		variable col_addr_scr: std_logic_vector(15 downto 0);
		variable col: std_logic_vector(7 downto 0);
		variable ink: std_logic_vector(2 downto 0);
        variable bright: std_logic;
		variable paper: std_logic_vector(2 downto 0);
		variable tmp_bit: std_logic;
	begin
		if (falling_edge(zx_scr_clk_i)) then
            if (zx_scr_rd_i = '0')  then
				addr_scr := "000" & zx_scr_y_i(7) &
									zx_scr_y_i(6) &
									zx_scr_y_i(2) &
									zx_scr_y_i(1) &
									zx_scr_y_i(0) &
									zx_scr_y_i(5) &
									zx_scr_y_i(4) &
									zx_scr_y_i(3) &
									zx_scr_x_i(7 downto 3);
				report "This is x " & to_hstring(zx_scr_x_i) & " and y " & to_hstring(zx_scr_y_i) &
				" addr: " & to_hstring(addr_scr) & " bit " & to_hstring(zx_scr_x_i(2 downto 0));
                report "read2 from addr " & to_hstring(addr_scr);
				if (unsigned(addr_scr) >= 0) and (unsigned(addr_scr) < 6911) then
					report "reading2 from ram[" & to_hstring(addr_scr) & "]=" &
					to_hstring(rom_image(to_integer(unsigned(addr_scr))));
					data := rom_image(to_integer(unsigned(addr_scr)));
					tmp_bit := data(7-to_integer(unsigned(zx_scr_x_i(2 downto 0))));
					-- fetch attribute addr

					col_addr_scr := x"1800" or ("000000" & zx_scr_y_i(7 downto 3) & zx_scr_x_i(7 downto 3));
					-- original addr is 5800 - substract ROM 16384 section
					report "Attr x " & to_hstring(zx_scr_x_i) & " and y " & to_hstring(zx_scr_y_i) &
					" addr: " & to_hstring(col_addr_scr);
					col := rom_image(to_integer(unsigned(col_addr_scr)));
                    ink := col(2 downto 0);
                    paper := col(5 downto 3);
                    bright := col(6);

					-- add color handling
					if (tmp_bit = '1') then
                        if (bright = '0') then
                            zx_scr_rgb_r_o <= palette_0(to_integer(unsigned(ink)))(7 downto 0);
                            zx_scr_rgb_g_o <= palette_0(to_integer(unsigned(ink)))(15 downto 8);
                            zx_scr_rgb_b_o <= palette_0(to_integer(unsigned(ink)))(23 downto 16);
                        else
                            zx_scr_rgb_r_o <= palette_1(to_integer(unsigned(ink)))(7 downto 0);
                            zx_scr_rgb_g_o <= palette_1(to_integer(unsigned(ink)))(15 downto 8);
                            zx_scr_rgb_b_o <= palette_1(to_integer(unsigned(ink)))(23 downto 16);
                        end if;
					else
                        if (bright = '0') then
                            zx_scr_rgb_r_o <= palette_0(to_integer(unsigned(paper)))(7 downto 0);
                            zx_scr_rgb_g_o <= palette_0(to_integer(unsigned(paper)))(15 downto 8);
                            zx_scr_rgb_b_o <= palette_0(to_integer(unsigned(paper)))(23 downto 16);
                        else
                            zx_scr_rgb_r_o <= palette_1(to_integer(unsigned(paper)))(7 downto 0);
                            zx_scr_rgb_g_o <= palette_1(to_integer(unsigned(paper)))(15 downto 8);
                            zx_scr_rgb_b_o <= palette_1(to_integer(unsigned(paper)))(23 downto 16);
                        end if;
					end if;
				else
					zx_scr_rgb_r_o <= "ZZZZZZZZ";
					zx_scr_rgb_g_o <= "ZZZZZZZZ";
					zx_scr_rgb_b_o <= "ZZZZZZZZ";
				end if;
			end if;
        end if;
	end process;

end;
