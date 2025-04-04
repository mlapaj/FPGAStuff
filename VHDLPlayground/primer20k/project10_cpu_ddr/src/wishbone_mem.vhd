
library IEEE;
use ieee.std_logic_1164.all;

entity wishbone_mem is
    port (
             clk_i          : in std_logic;
             rstn_i         : in std_logic;
             -- pll lock
             pll_clk        : in std_logic;
             pll_lock        : in std_logic;
             -- Wishbone bus interface (available if MEM_EXT_EN = true) --
             wb_tag_i       : in std_ulogic_vector(02 downto 0);
             wb_adr_i       : in std_ulogic_vector(31 downto 0);
             wb_dat_o       : out  std_ulogic_vector(31 downto 0);
             wb_dat_i       : in std_ulogic_vector(31 downto 0);
             wb_we_i        : in std_ulogic;
             wb_sel_i       : in std_ulogic_vector(03 downto 0);
             wb_stb_i       : in std_ulogic;
             wb_cyc_i       : in std_ulogic;
             wb_ack_o       : out  std_ulogic;
             wb_err_o       : out  std_ulogic;
             -- ddr3 mem
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
             IO_ddr_dqs_n_io: inout std_logic_vector(1 downto 0);
             -- debug
             dbg_led : out std_logic
         );
end entity;


architecture basic of wishbone_mem is
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

    -- ddr misc signals
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
    -- signal sr_req_i: std_logic;
    -- signal ref_req_i: std_logic;
    -- signal sr_ack_o: std_logic;
    -- signal ref_ack_o: std_logic;
    signal init_calib_complete_o: std_logic;
    signal clk_x1_o: std_logic;


    type t_WBState is (WB_Init, WB_Ready, WB_Read, WB_Read2, WB_Write, WB_Write2 );
    signal WBState : t_WBState := WB_Init;
    signal read_data: std_logic_vector(127 downto 0);
    signal send_ack : std_logic;
    signal inputFF: std_logic;
    signal io_stb_cnt: integer range 0 to 2;
    signal io_rd_cnt: integer range 0 to 2;
    signal io_wb_cnt: integer range 0 to 2;
    type t_DDRState is (DDR_Init, DDR_Ready, DDR_ReadWait, DDR_ReadWait2,  DDR_WriteWait , DDR_WriteWait2);
    signal DDRState : t_DDRState := DDR_Init;

    signal inputFF2: std_logic;
    signal wb_stb_stable: std_logic;

    signal ddr_offset: std_logic_vector(1 downto 0);
    signal wr_data_mask: std_logic_vector(15 downto 0);

begin
    --dbg_led <= '1';
    my_ddr : DDR3_Memory_Interface_Top
    port map (
                 clk => clk_i,
                 memory_clk => pll_clk,
                 pll_lock => pll_lock,
                 rst_n => rstn_i,
                 cmd_ready => cmd_ready_o,
                 cmd => cmd_i,
                 cmd_en => cmd_en_i,
                 addr => addr_i,
                 wr_data_rdy => wr_data_rdy_o,
                 wr_data => wr_data_i,
                 wr_data_en => wr_data_en_i,
                 wr_data_end => wr_data_end_i,
                 wr_data_mask => wr_data_mask,
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




    process (clk_i)
    begin
        if rising_edge(clk_i) then
            inputFF  <= send_ack;
            wb_ack_o <= inputFF;
            --wb_ack_o <= send_ack;
        end if;
    end process;

    process (clk_x1_o)
    begin
        if rising_edge(clk_x1_o) then
            --inputFF2  <= wb_stb_i;
            --wb_stb_stable <= inputFF2;
            wb_stb_stable <= wb_stb_i;
        end if;
    end process;

    process (clk_x1_o)
        variable tmp_send_ack: std_logic;
        variable wr_ddr_offset: std_logic_vector(1 downto 0);

    begin
        if rising_edge(clk_x1_o) then
            if DDRState = DDR_Init then
                cmd_en_i <= '0';
                wr_data_end_i <= '0';
                wr_data_en_i <= '0';
                send_ack <= '0';
                DDRState <= DDR_Ready;
                wb_dat_o <= (others => '0');
                tmp_send_ack := '0';
                wr_data_mask <= "0000000000000000";
                report "ddr init";
            elsif DDRState = DDR_Ready then
                if (wb_ack_o = '1') then
                    send_ack <= '0';
                    tmp_send_ack := '0';
                end if;
                if (wb_stb_stable = '1') and (wb_cyc_i = '1') and (wb_we_i = '0') and cmd_ready_o = '1' and (wb_ack_o = '0') and (tmp_send_ack = '0')  then
                    cmd_i <= "001";
                    cmd_en_i <= '1';
                    addr_i  <= to_stdlogicvector(wb_adr_i(27 downto 4)) & "0000";
                    ddr_offset <= to_stdlogicvector(wb_adr_i(3 downto 2));
                    DDRState <= DDR_ReadWait;
                    -- should we use send_ack or wb_ack_here ?
                elsif (wb_stb_stable = '1') and (wb_cyc_i = '1') and (wb_we_i = '1')
                       and wb_ack_o = '0' and tmp_send_ack = '0' and cmd_ready_o = '1' and wr_data_rdy_o = '1' then
                    cmd_i <= "000";
                    cmd_en_i <= '1';
                    addr_i  <= to_stdlogicvector(wb_adr_i(27 downto 4)) & "0000";
                    wr_ddr_offset := to_stdlogicvector(wb_adr_i(3 downto 2));
                    if (wr_ddr_offset = "00") then
                        wr_data_i <=  (31 downto 0 => wb_dat_i, others => '0');
                        wr_data_mask <= not "0000000000001111";
                    elsif (wr_ddr_offset = "01") then
                        wr_data_i <=  (63 downto 32 => wb_dat_i, others => '0');
                        wr_data_mask <= not "0000000011110000";
                    elsif (wr_ddr_offset = "10") then
                        wr_data_i <=  (95 downto 64 => wb_dat_i, others => '0');
                        wr_data_mask <= not "0000111100000000";
                    elsif (wr_ddr_offset = "11") then
                        wr_data_mask <= not "1111000000000000";
                        wr_data_i <=  (127 downto 96 => wb_dat_i, others => '0');
                    end if;
                    wr_data_en_i <= '1';
                    wr_data_end_i <= '1';
                    DDRState <= DDR_WriteWait;
                end if;
                -- check if send ack is ok
            elsif DDRState = DDR_ReadWait then
                cmd_en_i <= '0';
                 if rd_data_valid_o = '1' then
                     if (ddr_offset = "00") then
                         wb_dat_o <= to_stdulogicvector(rd_data_o(31 downto 0));
                     elsif (ddr_offset = "01") then
                         wb_dat_o <= to_stdulogicvector(rd_data_o(63 downto 32));
                     elsif (ddr_offset = "10") then
                         wb_dat_o <= to_stdulogicvector(rd_data_o(95 downto 64));
                     elsif (ddr_offset = "11") then
                         wb_dat_o <= to_stdulogicvector(rd_data_o(127 downto 96));
                     end if;
                    --wb_dat_o <= (others => '1');
                    send_ack  <= '1';
                    tmp_send_ack := '1';
                    DDRState <= DDR_Ready;
                end if;
            elsif DDRState = DDR_WriteWait then
                cmd_en_i <= '0';
                wr_data_en_i <= '0';
                wr_data_end_i <= '0';
                DDRState <= DDR_Ready;
                tmp_send_ack := '1';
                send_ack  <= '1';
            end if;
        end if;
end process;
end architecture;

