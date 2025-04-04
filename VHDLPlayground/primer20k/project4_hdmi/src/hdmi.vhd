library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library t80lib;
use t80lib.all;

use STD.textio.all;
use ieee.std_logic_textio.all;


entity z80system is
  port (
    -- Global control --
    clk_i       : in  std_logic; -- global clock, rising edge
    rstn_i      : in  std_logic; -- global reset, low-active, async
    tmds_clk_p_o: out std_logic;
    tmds_clk_n_o: out std_logic;
    tmds_data_p_o: out std_logic_vector(2 downto 0);
    tmds_data_n_o: out std_logic_vector(2 downto 0)
  );
end entity;


architecture basic of z80system is
    -- HDMI signals and constants
    -- see: https://projectf.io/posts/video-timings-vga-720p-1080p/#hd-1280x720-60-hz
	constant PX_WIDTH                : integer := 1280;
	constant PX_FRONT_PORCH          : integer := 110;
	constant PX_SYNC_PULSE           : integer := 40;
	constant PX_BACK_PORCH           : integer := 220;
	constant LINE_HEIGHT             : integer := 720;
	constant LINE_FRONT_PORCH : integer := 5;
	constant LINE_SYNC_PULSE : integer := 5;
	constant LINE_BACK_PORCH : integer := 20;
    -- counters
	signal counterX : integer range 0 to (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE + PX_BACK_PORCH + 1);
	signal counterY : integer range 0 to (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE + LINE_BACK_PORCH + 1);
    -- out signals
    signal blank_n: std_logic;
    signal pll_out: std_logic;
    signal rgb_vs_i: std_logic;
    signal rgb_hs_i: std_logic;
    signal rgb_de_i: std_logic;
    signal rgb_r_i: std_logic_vector(7 downto 0);
    signal rgb_g_i: std_logic_vector(7 downto 0);
    signal rgb_b_i: std_logic_vector(7 downto 0);
    -- DVI TX component created by Gowin
    component DVI_TX_Top
        port (
            I_rst_n: in std_logic;
            I_rgb_clk: in std_logic;
            I_rgb_vs: in std_logic;
            I_rgb_hs: in std_logic;
            I_rgb_de: in std_logic;
            I_rgb_r: in std_logic_vector(7 downto 0);
            I_rgb_g: in std_logic_vector(7 downto 0);
            I_rgb_b: in std_logic_vector(7 downto 0);
            O_tmds_clk_p: out std_logic;
            O_tmds_clk_n: out std_logic;
            O_tmds_data_p: out std_logic_vector(2 downto 0);
            O_tmds_data_n: out std_logic_vector(2 downto 0)
        );
    end component;
    -- PLL component created by Gowin
    component Gowin_rPLL
        port (
            clkout: out std_logic;
            clkin: in std_logic
        );
    end component;


begin


hdmi0: DVI_TX_Top
	port map (
		I_rst_n => rstn_i,
		I_rgb_clk => pll_out,
		I_rgb_vs => rgb_vs_i,
		I_rgb_hs => rgb_hs_i,
		I_rgb_de => blank_n,
		I_rgb_r => rgb_r_i,
		I_rgb_g => rgb_g_i,
		I_rgb_b => rgb_b_i,
		O_tmds_clk_p => tmds_clk_p_o,
		O_tmds_clk_n => tmds_clk_n_o,
		O_tmds_data_p => tmds_data_p_o,
		O_tmds_data_n => tmds_data_n_o
	);


pll: Gowin_rPLL
    port map (
        clkout => pll_out,
        clkin => clk_i
    );

-- image generation primitive logic
rgb_r_i <= "00000000";
rgb_g_i <= "11111111" and blank_n;
rgb_b_i <= "00000000";
rgb_de_i <= '0';

-- image generation
process (pll_out)
begin
    if (falling_edge(pll_out)) then
		if counterX = (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE + PX_BACK_PORCH - 1) then
			counterX <= 0;
			if counterY = (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE + LINE_BACK_PORCH - 1) then
				counterY <= 0;
			else
				counterY <= counterY + 1;
			end if; 
		else
			counterX <= counterX + 1;
		end if; 

		if counterX < PX_WIDTH AND counterY < LINE_HEIGHT then
			blank_n <= '1';
		else
			blank_n <= '0';
		end if;

		if counterX >= (PX_WIDTH + PX_FRONT_PORCH) AND counterX < (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE) then
			rgb_hs_i <= '1';
		else
			rgb_hs_i <= '0';
		end if;

		if counterY >= (LINE_HEIGHT + LINE_FRONT_PORCH) AND counterY < (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE) then
			rgb_vs_i <= '1';
		else
			rgb_vs_i <= '0';
		end if;
    end if;
end process;

end architecture;