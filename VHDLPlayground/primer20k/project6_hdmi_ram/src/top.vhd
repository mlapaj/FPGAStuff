library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use STD.textio.all;
use ieee.std_logic_textio.all;
-- lapaj
-- use work.image.all;


entity top is
  port (
    clk_i       : in  std_logic;
    rstn_i      : in  std_logic;
    tmds_clk_p_o: out std_logic;
    tmds_clk_n_o: out std_logic;
    tmds_data_p_o: out std_logic_vector(2 downto 0);
    tmds_data_n_o: out std_logic_vector(2 downto 0)
  );
end entity;


architecture basic of top is

component hdmi is
  port (
    -- Global control --
    clk_i       : in  std_logic; -- global clock, rising edge
    rdy_i       : in  std_logic; -- global clock, rising edge
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
		addr2_i      : in std_logic_vector(15 downto 0);
		data2_o      : out std_logic_vector(7 downto 0)
  );
end component;

-- PLL component created by Gowin
component Gowin_rPLL
    port (
        clkout: out std_logic;
        clkin: in std_logic
    );
end component;




-- signals
signal rd2       : std_logic;
signal addr2     : std_logic_vector(15 downto 0);
signal data2     : std_logic_vector(7 downto 0);
signal pll_out   : std_logic;

begin
     pll0: Gowin_rPLL port map (clkout => pll_out,clkin => clk_i);
     hdmi0: hdmi port map (clk_i => pll_out, rdy_i => '1' , rstn_i => rstn_i, 
                           tmds_clk_p_o => tmds_clk_p_o, tmds_clk_n_o => tmds_clk_n_o,
                           tmds_data_p_o => tmds_data_p_o, tmds_data_n_o => tmds_data_n_o,
                           rd_o => rd2 , addr_o => addr2, data_i => data2);
     ram0: z80system_ram port map (
                                    clk_i => '0', mreqn_i => '1', rd_i => '1', wr_i => '1', 
                                    addr_i => (others => '0'), data_i => (others => '0'),
                                    clkrd_i => pll_out, rd2_i => rd2, addr2_i => addr2, data2_o => data2);


end architecture;
