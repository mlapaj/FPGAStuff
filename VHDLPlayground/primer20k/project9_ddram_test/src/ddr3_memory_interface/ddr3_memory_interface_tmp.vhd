--Copyright (C)2014-2023 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: Template file for instantiation
--GOWIN Version: V1.9.9 Beta-4 Education
--Part Number: GW2A-LV18PG256C8/I7
--Device: GW2A-18
--Device Version: C
--Created Time: Tue Nov 28 23:35:53 2023

--Change the instance name and port connections to the signal names
----------Copy here to design--------

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

your_instance_name: DDR3_Memory_Interface_Top
	port map (
		clk => clk_i,
		memory_clk => memory_clk_i,
		pll_lock => pll_lock_i,
		rst_n => rst_n_i,
		cmd_ready => cmd_ready_o,
		cmd => cmd_i,
		cmd_en => cmd_en_i,
		addr => addr_i,
		wr_data_rdy => wr_data_rdy_o,
		wr_data => wr_data_i,
		wr_data_en => wr_data_en_i,
		wr_data_end => wr_data_end_i,
		wr_data_mask => wr_data_mask_i,
		rd_data => rd_data_o,
		rd_data_valid => rd_data_valid_o,
		rd_data_end => rd_data_end_o,
		sr_req => sr_req_i,
		ref_req => ref_req_i,
		sr_ack => sr_ack_o,
		ref_ack => ref_ack_o,
		init_calib_complete => init_calib_complete_o,
		clk_out => clk_out_o,
		ddr_rst => ddr_rst_o,
		burst => burst_i,
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

----------Copy end-------------------
