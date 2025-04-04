module top
(
    // ae-350
    input wire tck_i,
    input wire tms_i,
    input wire trst_i,
    input wire tdi_i,
    output wire tdo_o,
    // ae-350 gpio uart
    output wire uart2_txd,
    input  wire uart2_rxd,
    // clock
    input wire clk_i,
    // module reset
    input wire rst_n_i
);


//Open Wishbone bus
wire slv_ext_stb_o;
wire slv_ext_we_o;
wire slv_ext_cyc_o;
wire slv_ext_ack_i;
wire [31:0] slv_ext_adr_o;
wire [31:0] slv_ext_wdata_o;
wire [31:0] slv_ext_rdata_i;
wire [3:0] slv_ext_sel_o;

//Open AHB bus
wire [31:0] hrdata;
wire [1:0] hresp;
wire hready;
wire [31:0] haddr;
wire hwrite;
wire [2:0] hsize;
wire [2:0] hburst;
wire [31:0] hwdata;
wire hsel;
wire [1:0] htrans;

wire clk_pll;
wire pll_locked;

Gowin_rPLL u_PLL0(
    .clkout(clk_pll), //output clkout
    .lock(pll_locked), //output lock
    .clkin(clk_i) //input clkin
);



Gowin_PicoRV32_Top u_CPU0(
    .wbuart_tx(uart2_txd), //output wbuart_tx
    .wbuart_rx(uart2_rxd), //input wbuart_rx
    .gpio_io(),
    .slv_ext_stb_o(slv_ext_stb_o),
    .slv_ext_we_o(slv_ext_we_o),
    .slv_ext_cyc_o(slv_ext_cyc_o),
    .slv_ext_ack_i(slv_ext_ack_i),
    .slv_ext_adr_o(slv_ext_adr_o),
    .slv_ext_wdata_o(slv_ext_wdata_o),
    .slv_ext_rdata_i(slv_ext_rdata_i),
    .slv_ext_sel_o(slv_ext_sel_o),
    .irq_in(12'b0), //input [31:20] irq_in
    .jtag_TDI(tdi_i), //input jtag_TDI
    .jtag_TDO(tdo_o), //output jtag_TDO
    .jtag_TCK(tck_i), //input jtag_TCK
    .jtag_TMS(tms_i), //input jtag_TMS
    .clk_in(clk_pll), //input clk_in
    .resetn_in(pll_locked & rst_n_i) //input resetn_in
);

//wbreg_demo instantiation
wb u_WB0
(
    .clk_i(clk_i),
    .rst_i(~rst_n_i),
    .adr_i(slv_ext_adr_o[4:0]),
    .dat_i(slv_ext_wdata_o),
    .dat_o(slv_ext_rdata_i),
    .we_i(slv_ext_we_o),
    .stb_i(slv_ext_stb_o),
    .cyc_i(slv_ext_cyc_o),
    .ack_o(slv_ext_ack_i)
);



endmodule
