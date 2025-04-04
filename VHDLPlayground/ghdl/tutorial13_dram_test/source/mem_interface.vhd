library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use STD.textio.all;
use ieee.std_logic_textio.all;

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
	signal temp_wr_data:  std_logic_vector(127 downto 0);
end entity;

architecture basic of DDR3_Memory_Interface_Top is
begin
    process (clk)
    begin
        if (falling_edge(clk)) then
            -- write
            if cmd_en = '1' and cmd = "000" then
                report "write procedure" & to_hstring(wr_data);
                temp_wr_data <= wr_data;
                cmd_ready <= '1';
            elsif cmd_en = '1' and cmd = "001" then
                report "read procedure" & to_hstring(temp_wr_data);
                rd_data <= temp_wr_data;
                rd_data_valid <= '1';
                rd_data_end <= '1';
                cmd_ready <= '1';
            else
                -- report "no procedure";
                rd_data_valid <= '0';
                rd_data_end <= '0';
                wr_data_rdy <=  '0';
                cmd_ready <= '0';
            end if;
        end if;
    end process;

end basic;
