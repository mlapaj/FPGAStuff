library IEEE;
use ieee.std_logic_1164.all;


entity DDR3_Memory_Interface_Top is
    port (
             clk: in std_logic;
             memory_clk: in std_logic;
             pll_lock: in std_logic;
             rst_n: in std_logic;
             cmd_ready: out std_logic;
             cmd: in std_logic_vector(2 downto 0);
             cmd_en: in std_logic;
             addr: in std_logic_vector(27 downto 0);
             wr_data_rdy: out std_logic;
             wr_data: in std_logic_vector(127 downto 0);
             wr_data_en: in std_logic;
             wr_data_end: in std_logic;
             wr_data_mask: in std_logic_vector(15 downto 0);
             rd_data: out std_logic_vector(127 downto 0);
             rd_data_valid: out std_logic;
             rd_data_end: out std_logic;
             sr_req: in std_logic;
             ref_req: in std_logic;
             sr_ack: out std_logic;
             ref_ack: out std_logic;
             init_calib_complete: out std_logic;
             clk_out: out std_logic;
             ddr_rst: out std_logic;
             burst: in std_logic;
                 --- ddr output
             O_ddr_addr: out std_logic_vector(13 downto 0);
             O_ddr_ba: out std_logic_vector(2 downto 0);
             O_ddr_cs_n: out std_logic;
             O_ddr_ras_n: out std_logic;
             O_ddr_cas_n: out std_logic;
             O_ddr_we_n: out std_logic;
             O_ddr_clk: out std_logic;
             O_ddr_clk_n: out std_logic;
             O_ddr_cke: out std_logic;
             O_ddr_odt: out std_logic;
             O_ddr_reset_n: out std_logic;
             O_ddr_dqm: out std_logic_vector(1 downto 0);
             IO_ddr_dq: inout std_logic_vector(15 downto 0);
             IO_ddr_dqs: inout std_logic_vector(1 downto 0);
             IO_ddr_dqs_n: inout std_logic_vector(1 downto 0)
         );

end entity;


architecture basic of DDR3_Memory_Interface_Top is
begin

    clk_out <= memory_clk;
    -- just stub
    rd_data_valid <= '1';
    rd_data <= "00010001001000100011001101000100010101010110011001110111100010001001100100010000000100010001001000010011000101000001010100010110";
    wr_data_rdy <= '1';
    init_calib_complete <= '1';
    cmd_ready <= '1';
    -- process (memory_clk)
    -- begin
    --     if falling_edge(memory_clk) then
    --         report "falling edge memory";
    --     end if;
    -- end process;

end architecture;
