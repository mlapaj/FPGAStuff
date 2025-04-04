library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use STD.textio.all;
use ieee.std_logic_textio.all;

entity scr is
	port (
			 -- Global control --
			 clk_i       : in  std_logic; -- global clock, rising edge
			 rstn_i      : in  std_logic; -- global reset, low-active, async
			 -- Memory access
			 mreqn_o     : out std_logic;
			 rd_o        : out std_logic;
			 addr_o      : out std_logic_vector(15 downto 0);
			 data_i      : in std_logic_vector(7 downto 0);
			 -- Screen info
			 pos_x      : in std_logic_vector(7 downto 0);
			 pos_y      : in std_logic_vector(7 downto 0)
		 );
end entity;

architecture basic of scr is
	signal req_mem : std_logic;
	signal cnt : unsigned(2 downto 0);

	signal tmp_pos_x      : std_logic_vector(7 downto 0);
	signal tmp_pos_y      : std_logic_vector(7 downto 0);
begin
	process (clk_i)
		variable addr_scr      : std_logic_vector(15 downto 0);
	begin
		if (rstn_i = '0') then
			tmp_pos_x <= (others => '0');
			tmp_pos_y <= (others => '0');
			cnt <= "000";
			addr_scr := (others => '0');
			req_mem <= '0';
		elsif (rising_edge(clk_i)) then
			if (req_mem = '0') then
				-- change to "010"
				addr_scr := "000" & pos_y(7) & pos_y(6) & pos_y(2) & pos_y(1) &
				pos_y(0) & pos_y(5) & pos_y(4) & pos_y(3) & pos_x(7 downto 3);
				report "This is x " & to_hstring(pos_x) & " and y " & to_hstring(pos_y) &
				" addr:" & to_hstring(addr_scr);
				addr_o <= addr_scr;
				mreqn_o <= '0';
				rd_o <= '0';
				req_mem <= '1';
				cnt <= "000";
				tmp_pos_x <= pos_x;
				tmp_pos_y <= pos_y;
			else
				if (cnt < 3) then
					cnt <= cnt + 1;
					report "waiting for mem";
				else
					report "scr pos [" & to_hstring(tmp_pos_x) & "," & to_hstring(tmp_pos_y) &
					"] addr " & to_hstring(addr_scr) & " mem " & 
					std_logic'image(data_i(to_integer(unsigned(tmp_pos_x(2 downto 0))))) ;
					req_mem <= '0';
					rd_o <= '1';
					mreqn_o <= '1';
				end if;
			end if;
		end if;
	end process;
end architecture;
