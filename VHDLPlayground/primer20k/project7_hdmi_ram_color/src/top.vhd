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
    -- screen part
    zx_scr_rd_o     : out std_logic;
    zx_scr_x_o      : out std_logic_vector(7 downto 0);
    zx_scr_y_o      : out std_logic_vector(7 downto 0);
    zx_scr_rgb_r_i  : in std_logic_vector(7 downto 0);
    zx_scr_rgb_g_i  : in std_logic_vector(7 downto 0);
    zx_scr_rgb_b_i  : in std_logic_vector(7 downto 0)

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

		-- screen part
		zx_scr_clk_i    : in std_logic;
		zx_scr_rd_i     : in std_logic;
		zx_scr_x_i      : in std_logic_vector(7 downto 0);
		zx_scr_y_i      : in std_logic_vector(7 downto 0);
		zx_scr_rgb_r_o  : out std_logic_vector(7 downto 0);
		zx_scr_rgb_g_o  : out std_logic_vector(7 downto 0);
		zx_scr_rgb_b_o  : out std_logic_vector(7 downto 0)

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
signal pll_out       : std_logic;
signal zx_scr_rd     : std_logic;
signal zx_scr_x      : std_logic_vector(7 downto 0);
signal zx_scr_y      : std_logic_vector(7 downto 0);
signal zx_scr_rgb_r  : std_logic_vector(7 downto 0);
signal zx_scr_rgb_g  : std_logic_vector(7 downto 0);
signal zx_scr_rgb_b  : std_logic_vector(7 downto 0);

begin
     pll0: Gowin_rPLL port map (clkout => pll_out,clkin => clk_i);
     hdmi0: hdmi port map ( clk_i => pll_out, 
                            rdy_i => '1' , 
                            rstn_i => rstn_i, 
                            tmds_clk_p_o => tmds_clk_p_o,
                            tmds_clk_n_o => tmds_clk_n_o,
                            tmds_data_p_o => tmds_data_p_o,
                            tmds_data_n_o => tmds_data_n_o,
                            zx_scr_rd_o => zx_scr_rd,
                            zx_scr_x_o => zx_scr_x,
                            zx_scr_y_o => zx_scr_y,
                            zx_scr_rgb_r_i => zx_scr_rgb_r,
                            zx_scr_rgb_g_i => zx_scr_rgb_g,
                            zx_scr_rgb_b_i => zx_scr_rgb_b

);

     ram0: z80system_ram port map (
                                    clk_i => '0', 
                                    mreqn_i => '1',
                                    rd_i => '1', 
                                    wr_i => '1', 
                                    addr_i => (others => '0'), 
                                    data_i => (others => '0'),
                                    zx_scr_clk_i => pll_out, 
                                    zx_scr_rd_i => zx_scr_rd,
                                    zx_scr_x_i => zx_scr_x,
                                    zx_scr_y_i => zx_scr_y,
                                    zx_scr_rgb_r_o => zx_scr_rgb_r,
                                    zx_scr_rgb_g_o => zx_scr_rgb_g,
                                    zx_scr_rgb_b_o => zx_scr_rgb_b
                                    );


end architecture;
