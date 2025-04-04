library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use STD.textio.all;
use ieee.std_logic_textio.all;

entity top is
  port (
    clk_i       : in  std_logic;
    rst_n_i      : in  std_logic;
    out_o       : out  std_logic;
    out_mem_o       : out  std_logic;
-- dram
--		clk_i: in std_logic;

        -- mem
		-- ddr_rst_o: out std_logic;
		O_ddr_addr_o: out std_logic_vector(13 downto 0);
		O_ddr_ba_o: out std_logic_vector(2 downto 0);
		O_ddr_cs_n_o: out std_logic;
		O_ddr_ras_n_o: out std_logic;
		O_ddr_cas_n_o: out std_logic;
		O_ddr_we_n_o: out std_logic;
		O_ddr_clk_o: out std_logic;
		O_ddr_clk_n_o: out std_logic;
		O_ddr_cke_o: out std_logic;
		O_ddr_odt_o: out std_logic;
		O_ddr_reset_n_o: out std_logic;
		O_ddr_dqm_o: out std_logic_vector(1 downto 0);
		IO_ddr_dq_io: inout std_logic_vector(15 downto 0);
		IO_ddr_dqs_io: inout std_logic_vector(1 downto 0);
		IO_ddr_dqs_n_io: inout std_logic_vector(1 downto 0)
  );
end entity;

architecture basic of top is
    signal cnt1 : integer range 0 to 27000000;
    signal sout : std_logic;
    -- controller
    signal memory_clk_i: std_logic;
    --signal pll_lock_i: std_logic;
    signal i: std_logic;
    signal cmd_ready_o: std_logic;
    signal cmd_i: std_logic_vector(2 downto 0);
    signal cmd_en_i: std_logic;
    signal addr_i: std_logic_vector(27 downto 0);
    signal wr_data_rdy_o: std_logic;
    signal wr_data_i: std_logic_vector(127 downto 0);
    signal wr_data_en_i: std_logic;
    signal wr_data_end_i: std_logic;
    signal rd_data_o: std_logic_vector(127 downto 0);
    signal rd_data_valid_o: std_logic;
    signal rd_data_end_o: std_logic;
    signal sr_req_i: std_logic;
    signal ref_req_i: std_logic;
    signal sr_ack_o: std_logic;
    signal ref_ack_o: std_logic;
    signal init_calib_complete_o: std_logic;
    signal clk_x1_o: std_logic;
    --signal burst_i: std_logic;

    -- pll
    signal pll_clkout: std_logic;
    signal pll_lock: std_logic;

    -- aux
    signal mem_test_fail: std_logic; 

component Gowin_rPLL
    port (
        clkout: out std_logic;
        lock: out std_logic;
        reset: in std_logic;
        clkin: in std_logic
    );
end component;


component DDR3_Memory_Interface_Top
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
end component;

    type t_DDRState is (Init, DDR_WriteStart, DDR_WriteWait, DDR_WriteDone, DDR_ReadStart, DDR_ReadWait, DDR_TestFailure);
    signal DDRState : t_DDRState;
    signal test_wr_data:  std_logic_vector(127 downto 0);
    signal test_rd_data:  std_logic_vector(127 downto 0);
    signal test_addr: std_logic_vector(27 downto 0);
    signal test_cnt : integer range 0 to 10;

begin

out_mem_o <= rd_data_o(0);
my_pll : Gowin_rPLL
    port map (
        clkout => pll_clkout,
        lock => pll_lock,
        reset => not rst_n_i,
        clkin => clk_i
    );

my_ddr : DDR3_Memory_Interface_Top
	port map (
		clk => clk_i,
		memory_clk => pll_clkout,
		pll_lock => pll_lock,
		rst_n => rst_n_i,
		cmd_ready => cmd_ready_o,
		cmd => cmd_i,
		cmd_en => cmd_en_i,
		addr => addr_i,
		wr_data_rdy => wr_data_rdy_o,
		wr_data => wr_data_i,
		wr_data_en => wr_data_en_i,
		wr_data_end => wr_data_end_i,
		wr_data_mask => "0000000000000000",
		rd_data => rd_data_o,
		rd_data_valid => rd_data_valid_o,
		rd_data_end => rd_data_end_o,
		sr_req => '0',
		ref_req => '0',
		--sr_ack => sr_ack_o,
		--ref_ack => ref_ack_o,
		init_calib_complete => init_calib_complete_o,
		clk_out => clk_x1_o,
		-- ddr_rst => ddr_rst_o,
		burst => '1',

		O_ddr_addr => O_ddr_addr_o,
		O_ddr_ba => O_ddr_ba_o,
		O_ddr_cs_n => O_ddr_cs_n_o,
		O_ddr_ras_n => O_ddr_ras_n_o,
		O_ddr_cas_n => O_ddr_cas_n_o,
		O_ddr_we_n => O_ddr_we_n_o,
		O_ddr_clk => O_ddr_clk_o,
		O_ddr_clk_n => O_ddr_clk_n_o,
		O_ddr_cke => O_ddr_cke_o,
		O_ddr_odt => O_ddr_odt_o,
		O_ddr_reset_n => O_ddr_reset_n_o,
		O_ddr_dqm => O_ddr_dqm_o,
		IO_ddr_dq => IO_ddr_dq_io,
		IO_ddr_dqs => IO_ddr_dqs_io,
		IO_ddr_dqs_n => IO_ddr_dqs_n_io
	);




-- led handling
process (clk_i)



begin
    if (falling_edge(clk_i)) then
        if (rst_n_i = '0') then
            mem_test_fail <= '0';
            addr_i <= (others => '0');
            cmd_i <= (others => '0');
            cmd_en_i <= '0';
            wr_data_i <= (others => '0');
            wr_data_en_i <= '0';
            wr_data_end_i <= '0';
            DDRState <= Init;
            test_wr_data <= (others => '0');
        else
            -- our test will be done here
            if (DDRState = Init) then
                addr_i <= (others => '0');
                test_wr_data <= (others => '0');
                DDRState <= DDR_WriteStart;
                test_cnt <= 0;
                cmd_en_i <= '0';
                wr_data_en_i <= '0';
                wr_data_end_i <= '0';
                test_wr_data <= (others => '0');
            elsif (DDRState = DDR_WriteStart) then
                wr_data_en_i <= '1';
                wr_data_end_i <= '1';
                wr_data_i <= test_wr_data;
                cmd_i <= "000";
                cmd_en_i <= '1';
                test_cnt <= 0;
                DDRState <= DDR_WriteWait;
            elsif (DDRState = DDR_WriteWait) then
                test_cnt <= test_cnt + 1;
                if (test_cnt = 5) then
                    test_cnt <= 0;
                    -- clear stuff on write
                    cmd_en_i <= '0';
                    wr_data_en_i <= '0';
                    wr_data_end_i <= '0';
                    wr_data_i <= (others => '0');
                    DDRState <= DDR_ReadStart;
                end if;
            elsif (DDRState = DDR_ReadStart) then
                cmd_i <= "001"; -- to check tomorrow
                cmd_en_i <= '1';
                test_cnt <= 0;
                DDRState <= DDR_ReadWait;
            elsif (DDRState = DDR_ReadWait) then
                test_cnt <= test_cnt + 1;
                if (test_cnt = 5) then
                    test_cnt <= 0;
                    -- clear stuff on write
                    cmd_en_i <= '0';
                    if (rd_data_valid_o = '1') then
                        if (rd_data_o = test_wr_data) then
                            -- test succed, continue
                            report "next test";
                            test_wr_data <= std_logic_vector( unsigned(test_wr_data) + 1 );
                            DDRState <= DDR_WriteStart;
                        else
                            report "failure";
                            DDRState <= DDR_TestFailure;
                        end if;
                    else
                        report "assert rd data not valid";
                        DDRState <= DDR_TestFailure;
                    end if;
                end if;
            elsif (DDRState = DDR_TestFailure) then
                mem_test_fail <= '1';
            end if;
        end if;
    end if;
end process;


out_o <= sout;

process (clk_i)
begin
    if (falling_edge(clk_i)) then
        if (rst_n_i = '0') then
            cnt1 <= 0;
            -- sout <= '0';
        else
            if (mem_test_fail = '0') then
                cnt1 <= cnt1 + 1;
                if (cnt1 = 27000000) then
                    cnt1 <= 0;
                    sout <= not sout;
                end if;
            end if;
        end if;
    end if;
end process;

end architecture;
