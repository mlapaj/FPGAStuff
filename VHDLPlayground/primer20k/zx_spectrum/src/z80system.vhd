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
             O_tmds_clk_p: out std_logic;
             O_tmds_clk_n: out std_logic;
             O_tmds_data_p: out std_logic_vector(2 downto 0);
             O_tmds_data_n: out std_logic_vector(2 downto 0)

         );
end entity;

architecture basic of z80system is
    signal wait_n : std_logic := '1';
    signal int_n : std_logic := '1';
    signal nmi_n : std_logic := '1';
    signal busrq_n : std_logic := '1';
    signal rfsh_n : std_logic;
    signal cpu_ula_addr : std_logic_vector(15 downto 0);
    signal cpu_ula_mreq_n : std_logic;
    signal cpu_ula_rd_n : std_logic;
    signal cpu_ula_wr_n : std_logic;
    signal cpu_ula_d_i : std_logic_vector(7 downto 0);
    signal cpu_ula_d_o : std_logic_vector(7 downto 0);

    signal mem_ula_addr : std_logic_vector(15 downto 0);
    signal mem_ula_mreq_n : std_logic;
    signal mem_ula_rd_n : std_logic;
    signal mem_ula_wr_n : std_logic;
    signal mem_ula_d_i : std_logic_vector(7 downto 0);
    signal mem_ula_d_o : std_logic_vector(7 downto 0);

    signal vid_ula_addr : std_logic_vector(15 downto 0);
    signal vid_ula_rd_n : std_logic;
    signal vid_ula_d_i : std_logic_vector(7 downto 0);
    component T80s is
        generic(
                   Mode    : integer := 0; -- 0 => Z80, 1 => Fast Z80, 2 => 8080, 3 => GB
                   T2Write : integer := 1; -- 0 => WR_n active in T3, /=0 => WR_n active in T2
                   IOWait  : integer := 1  -- 0 => Single cycle I/O, 1 => Std I/O cycle
               );
        port(
                RESET_n : in std_logic;
                CLK     : in std_logic;
                CEN     : in std_logic := '1';
                WAIT_n  : in std_logic := '1';
                INT_n     : in std_logic := '1';
                NMI_n     : in std_logic := '1';
                BUSRQ_n : in std_logic := '1';
                M1_n    : out std_logic;
                MREQ_n  : out std_logic;
                IORQ_n  : out std_logic;
                RD_n    : out std_logic;
                WR_n    : out std_logic;
                RFSH_n  : out std_logic;
                HALT_n  : out std_logic;
                BUSAK_n : out std_logic;
                OUT0    : in  std_logic := '0';  -- 0 => OUT(C),0, 1 => OUT(C),255
                A       : out std_logic_vector(15 downto 0);
                DI      : in std_logic_vector(7 downto 0);
                DO      : out std_logic_vector(7 downto 0)
            );
    end component;

    component z80system_rom is
        port (
        -- Global control --
                 clk_i       : in  std_logic; -- global clock, rising edge
                 mreqn_i     : in std_logic;
                 rd_i        : in std_logic;
                 addr_i      : in std_logic_vector(15 downto 0);
                 data_o        : out std_logic_vector(7 downto 0)
             );
    end component;
    component z80system_ram is
        port (
        -- Global control --
                 clk_i       : in  std_logic; -- global clock, rising edge
                 mreqn_i     : in std_logic;
                 rd_i     : in std_logic;
                 wr_i     : in std_logic;
                 addr_i      : in std_logic_vector(15 downto 0);
                 data_i      : in std_logic_vector(7 downto 0);
                 data_o      : out std_logic_vector(7 downto 0)
             );
    end component;
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
    component ula is
        port (
                 -- Reset --
                 rstn_i: in std_logic;
                 -- Input clock --
                 clk_i: in std_logic;

                 -- Output Z80 clock --
                 clk_cpu_o: out std_logic;

                 -- access to ram
                 mem_mreqn_o: out std_logic;
                 mem_rd_o:    out std_logic;
                 mem_wr_o:    out std_logic;
                 mem_addr_o:  out std_logic_vector(15 downto 0);
                 mem_data_o:  out std_logic_vector(7 downto 0);
                 mem_data_i:  in std_logic_vector(7 downto 0);

                 -- cpu to ram
                 cpu_mreqn_i: in std_logic;
                 cpu_rd_i:    in std_logic;
                 cpu_wr_i:    in std_logic;
                 cpu_addr_i:  in std_logic_vector(15 downto 0);
                 cpu_data_i:  in std_logic_vector(7 downto 0);
                 cpu_data_o:  out std_logic_vector(7 downto 0);

                 -- cpu to video
                 vid_rd_i:    in std_logic;
                 vid_addr_i:  in std_logic_vector(15 downto 0);
                 vid_data_o:  out std_logic_vector(7 downto 0)

             );
    end component;
begin
    cpu: T80s port map (
                           CLK     => clk_i,
                           RESET_n => rstn_i,
                           WAIT_n  => wait_n,
                           INT_n   => int_n,
                           NMI_n   => nmi_n,
                           BUSRQ_n => busrq_n,
                           RFSH_n  => rfsh_n,
                           A       => cpu_ula_addr,
                           MREQ_n  => cpu_ula_mreq_n,
                           DI      => cpu_ula_d_i,
                           DO      => cpu_ula_d_o,
                           RD_n    => cpu_ula_rd_n,
                           WR_n    => cpu_ula_wr_n
                       );

    ula0: ula port map (
                           rstn_i      => rstn_i,
                           clk_i       => clk_i,

                           cpu_mreqn_i => cpu_ula_mreq_n,
                           cpu_rd_i    => cpu_ula_rd_n,
                           cpu_wr_i    => cpu_ula_wr_n,
                           cpu_addr_i  => cpu_ula_addr,
                           cpu_data_i  => cpu_ula_d_o,
                           cpu_data_o  => cpu_ula_d_i,

                           vid_rd_i    => vid_ula_rd_n,
                           vid_addr_i  => vid_ula_addr,
                           vid_data_o  => vid_ula_d_i,

                           mem_mreqn_o => mem_ula_mreq_n,
                           mem_rd_o    => mem_ula_rd_n,
                           mem_wr_o    => mem_ula_wr_n,
                           mem_addr_o  => mem_ula_addr,
                           mem_data_i  => mem_ula_d_o,
                           mem_data_o  => mem_ula_d_i

                       );

    hdmi0: hdmi port map (
                 -- Global control --
                 clk_i  => clk_i,
                 rdy_i  => '1',
                 rstn_i => rstn_i,
                 tmds_clk_p_o => O_tmds_clk_p,
                 tmds_clk_n_o => O_tmds_clk_n,
                 tmds_data_p_o => O_tmds_data_p,
                 tmds_data_n_o => O_tmds_data_n,
                 -- ram access
                 rd_o   => vid_ula_rd_n,
                 addr_o => vid_ula_addr,
                 data_i => vid_ula_d_i
             );
    rom: z80system_rom port map (
                                    clk_i   => clk_i,
                                    addr_i  => mem_ula_addr,
                                    mreqn_i => mem_ula_mreq_n,
                                    data_o  => mem_ula_d_o,
                                    rd_i    => mem_ula_rd_n
                                );
    ram: z80system_ram port map (
                                    clk_i   => clk_i,
                                    addr_i  => mem_ula_addr,
                                    mreqn_i => mem_ula_mreq_n,
                                    data_i  => mem_ula_d_i,
                                    data_o  => mem_ula_d_o,
                                    rd_i    => mem_ula_rd_n,
                                    wr_i    => mem_ula_wr_n
                                );
end architecture;
