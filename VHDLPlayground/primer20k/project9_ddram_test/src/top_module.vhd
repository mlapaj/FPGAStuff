library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


use STD.textio.all;
use ieee.std_logic_textio.all;

use work.fifo_data.all;

entity top_module is
  port (
    clk_i       : in  std_logic;
    rst_n_i      : in  std_logic;
    out_o       : out  std_logic;
    out_mem_o       : out  std_logic;
    uart_tx_o       : out  std_logic;
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

architecture basic of top_module is
    signal cnt1 : integer range 0 to 27000000;
    signal prev_sout : std_logic;
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

    -- rstn
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

    type t_DDRState is (Init, DDR_WriteStart, DDR_WriteWait, DDR_ReadStart,
                        DDR_ReadWait, DDR_TestFailure, DDR_Verify,
                        DDR_VerifyWait, DDR_VerifyNext
                    );
    signal DDRState : t_DDRState;
    signal test_wr_data:  std_logic_vector(127 downto 0);
    signal test_rd_data:  std_logic_vector(127 downto 0);
    signal test_addr: std_logic_vector(27 downto 0);
    signal test_cnt : integer range 0 to 200;

    component uart is
        generic (
            baud                : positive := 9600;
            clock_frequency     : positive := 27000000
        );
        port (
            clock               :   in      std_logic;
            reset               :   in      std_logic;
            data_stream_in      :   in      std_logic_vector(7 downto 0);
            data_stream_in_stb  :   in      std_logic;
            data_stream_in_ack  :   out     std_logic;
            data_stream_out     :   out     std_logic_vector(7 downto 0);
            data_stream_out_stb :   out     std_logic;
            tx                  :   out     std_logic;
            rx                  :   in      std_logic
        );
    end component uart;

    component fifo_uart is
        port (
                 clock_i:    in  std_logic;
                 reset_n_i:  in  std_logic;
                 empty_o:    out std_logic;
                 data_in:    in  byte_array_type;
                 data_valid: in  std_logic;
                 out_val:    out std_logic_vector(7 downto 0);
                 out_valid:  out std_logic;
                 out_ready:  in  std_logic
             );
    end component;

    signal tmp_val : std_logic_vector(7 downto 0);
    signal out_valid : std_logic;
    signal tmp_out_ready: std_logic;
    signal fifo_data_valid: std_logic;
    signal tmp_data : byte_array_type;
    signal verif_rd_data:  std_logic_vector(127 downto 0);
    signal verif_data:  std_logic_vector(127 downto 0);
    signal temp_mc_reset : std_logic;
    signal temp_mc_reset_done : std_logic;
    signal cmd_sent: std_logic;
begin


uart0:  uart port map (
            clock               => clk_i,
            reset               => not rst_n_i,
            data_stream_in      => tmp_val,
            data_stream_in_stb  => out_valid,
            data_stream_in_ack  => tmp_out_ready,
            tx                  => uart_tx_o,
            rx                  => '0'
        );

fifo0:  fifo_uart port map (
            clock_i    => clk_i,
            reset_n_i  => rst_n_i,
            out_val    => tmp_val,
            out_valid  => out_valid,
            data_in    => tmp_data,
            data_valid => fifo_data_valid,
            out_ready  => tmp_out_ready
        );
 
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
		burst => '0',

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
    process (clk_x1_o)
    begin
        if rising_edge(clk_x1_o) then
            if temp_mc_reset = '1'  then
                DDRState <= Init;
                temp_mc_reset_done <= '1';
            elsif (init_calib_complete_o='1') then
                temp_mc_reset_done <= '0';
                    -- our test will be done here
                if (DDRState = Init) then
                    addr_i <= (others => '0');
                    test_wr_data <= (others => '0');
                    test_wr_data(0) <= '1';
                    test_cnt <= 0;
                    cmd_en_i <= '0';
                    wr_data_en_i <= '0';
                    wr_data_end_i <= '0';
                    cmd_sent <= '0';
                    DDRState <= DDR_WriteStart;
                    verif_data <= (others => '0');
                    verif_rd_data <= (others => '0');
                    prev_sout <= sout;
                elsif (DDRState = DDR_WriteStart) then
                    if cmd_ready_o = '1' and cmd_sent = '0' then
                        cmd_i <= "000";
                        cmd_en_i <= '1';
                        cmd_sent <= '1';
                    else
                        cmd_en_i <= '0';
                    end if;
                    if wr_data_rdy_o = '1' then
                        wr_data_i <= test_wr_data;
                        wr_data_en_i <= '1';
                        wr_data_end_i <= '1';
                        test_cnt <= 0;
                        DDRState <= DDR_WriteWait;
                    end if;
                elsif (DDRState = DDR_WriteWait) then
                    cmd_en_i <= '0';
                    cmd_sent <= '0';
                    wr_data_en_i <= '0';
                    wr_data_end_i <= '0';
                    test_cnt <= test_cnt + 1;
                    DDRState <= DDR_ReadStart;
                elsif (DDRState = DDR_ReadStart) then
                    if cmd_ready_o = '1' then
                        cmd_i <= "001"; -- to check tomorrow
                        cmd_en_i <= '1';
                        test_cnt <= 0;
                        DDRState <= DDR_ReadWait;
                    end if;
                elsif (DDRState = DDR_ReadWait) then
                    test_cnt <= test_cnt + 1;
                    cmd_en_i <= '0';
                    cmd_sent <= '0';
                    if (rd_data_valid_o = '1') then
                        if (rd_data_o = test_wr_data) then
                            verif_rd_data <= rd_data_o;
                            -- test succed, continue
                            report "next test";
                            test_wr_data <= test_wr_data rol 1;
                            addr_i <= addr_i + "10000"; -- add 16
                            if addr_i > "111011100110101100100110000"  then
                                -- start from the beginning
                                addr_i <= (others => '0');
                                DDRState <= DDR_Verify;
                            else
                                DDRState <= DDR_WriteStart;
                            end if;
                        else
                            report "failure";
                            DDRState <= DDR_TestFailure;
                        end if;
                    -- elsif (test_cnt = 200) then
                    --     test_cnt <= 0;
                    --     report "assert rd data not valid";
                    --     DDRState <= DDR_TestFailure;
                    end if;
                elsif (DDRState = DDR_Verify) then
                    report "verify";
                    if cmd_ready_o = '1' then
                        cmd_i <= "001"; -- to check tomorrow
                        cmd_en_i <= '1';
                        test_cnt <= 0;
                        DDRState <= DDR_VerifyWait;
                    end if;
                elsif (DDRState = DDR_VerifyWait) then
                    report "verify wait";
                    test_cnt <= test_cnt + 1;
                    cmd_en_i <= '0';
                    if (rd_data_valid_o = '1') then
                        verif_data <= rd_data_o;
                        DDRState <= DDR_VerifyNext;
                    -- had to increase count
                    -- got failures
                    -- elsif (test_cnt = 200) then
                    --     test_cnt <= 0;
                    --     report "assert rd data not valid";
                    --     DDRState <= DDR_TestFailure; -- tu sie wywala
                    end if;
                    -- wait until led blinks (1 second)
                elsif (DDRState = DDR_VerifyNext) then
                    --if (prev_sout /= sout) then
                        addr_i <= addr_i + "10000"; -- add 16
                        if addr_i > "111011100110101100100110000"  then
                        -- start from the beginning
                            addr_i <= (others => '0');
                            DDRState <= DDR_WriteStart;
                        else
                            DDRState <= DDR_Verify;
                        end if;
                        prev_sout <= sout;
                    --end if;
                elsif (DDRState = DDR_TestFailure) then
                        -- do nothing
                    DDRState <= DDR_TestFailure;
                end if;
            end if;
        end if;
    end process;


out_o <= sout;

process (clk_i)
begin
    if (rising_edge(clk_i)) then
        if (rst_n_i = '0') then
            cnt1 <= 0;
            sout <= '0';
            fifo_data_valid <= '0';
            temp_mc_reset <= '1';
        else
            if (temp_mc_reset_done = '1') then
                temp_mc_reset <= '0';
            end if;
            cnt1 <= cnt1 + 1;
            -- clear indication that new data is ready for uart
            -- if previous iteration was sending data,
            -- in next (this) iteration, we need to clear register
            fifo_data_valid <= '0';
            if (cnt1 = 2700000) then
                cnt1 <= 0;
                if (DDRState /= DDR_TestFailure) then
                    sout <= not sout;
                    if (DDRState /= DDR_Verify) and (DDRState /= DDR_VerifyWait) and (DDRState /= DDR_VerifyNext) then
                        tmp_data <= to_array("T-" & to_hstring(addr_i(27 downto 0 )) & " "
                                    & to_hstring(test_wr_data) & cr & lf); -- test_wr_data , verif_rd_data
                        fifo_data_valid <= '1';
                    else
                        tmp_data <= to_array("V-" & to_hstring(addr_i(27 downto 0 )) & " "
                                    & to_hstring(verif_data) & cr & lf);
                        fifo_data_valid <= '1';
                    end if;
                else
                    tmp_data <= to_array("F-" & to_hstring(addr_i(27 downto 0 )) & cr & lf);
                    fifo_data_valid <= '1';
                end if;
            end if;
        end if;
    end if;
end process;

end architecture;
