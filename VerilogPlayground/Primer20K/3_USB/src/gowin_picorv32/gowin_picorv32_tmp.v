//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.01
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Tue Apr  1 14:45:47 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Gowin_PicoRV32_Top your_instance_name(
		.wbuart_tx(wbuart_tx), //output wbuart_tx
		.wbuart_rx(wbuart_rx), //input wbuart_rx
		.gpio_io(gpio_io), //inout [31:0] gpio_io
		.slv_ext_stb_o(slv_ext_stb_o), //output slv_ext_stb_o
		.slv_ext_we_o(slv_ext_we_o), //output slv_ext_we_o
		.slv_ext_cyc_o(slv_ext_cyc_o), //output slv_ext_cyc_o
		.slv_ext_ack_i(slv_ext_ack_i), //input slv_ext_ack_i
		.slv_ext_adr_o(slv_ext_adr_o), //output [31:0] slv_ext_adr_o
		.slv_ext_wdata_o(slv_ext_wdata_o), //output [31:0] slv_ext_wdata_o
		.slv_ext_rdata_i(slv_ext_rdata_i), //input [31:0] slv_ext_rdata_i
		.slv_ext_sel_o(slv_ext_sel_o), //output [3:0] slv_ext_sel_o
		.hrdata(hrdata), //input [31:0] hrdata
		.hresp(hresp), //input [1:0] hresp
		.hready(hready), //input hready
		.haddr(haddr), //output [31:0] haddr
		.hwrite(hwrite), //output hwrite
		.hsize(hsize), //output [2:0] hsize
		.hburst(hburst), //output [2:0] hburst
		.hwdata(hwdata), //output [31:0] hwdata
		.hsel(hsel), //output hsel
		.htrans(htrans), //output [1:0] htrans
		.irq_in(irq_in), //input [31:20] irq_in
		.jtag_TDI(jtag_TDI), //input jtag_TDI
		.jtag_TDO(jtag_TDO), //output jtag_TDO
		.jtag_TCK(jtag_TCK), //input jtag_TCK
		.jtag_TMS(jtag_TMS), //input jtag_TMS
		.clk_in(clk_in), //input clk_in
		.resetn_in(resetn_in) //input resetn_in
	);

//--------Copy end-------------------
