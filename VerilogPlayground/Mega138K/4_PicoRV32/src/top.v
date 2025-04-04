module top
(
    // debug
    input wire tck_i,
    input wire tms_i,
    input wire trst_i,
    input wire tdi_i,
    output wire tdo_o,
    // uart
    output wire uart2_txd,
    input  wire uart2_rxd,
    // clock
    input wire clk_i,
    // module reset
    input wire rst_n_i,
    // gpio
    inout [2:0] led,
    inout [2:0] key
);

wire [31:0] gpio;

assign led = gpio[1:0];
assign key = gpio[3:2];



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


Gowin_PicoRV32_Top your_instance_name(
    .wbuart_tx(uart2_txd), //output wbuart_tx
    .wbuart_rx(uart2_rxd), //input wbuart_rx
    .gpio_io(), //inout [3:0] gpio_io
    .slv_ext_stb_o(slv_ext_stb_o),
    .slv_ext_we_o(slv_ext_we_o),
    .slv_ext_cyc_o(slv_ext_cyc_o),
    .slv_ext_ack_i(slv_ext_ack_i),
    .slv_ext_adr_o(slv_ext_adr_o),
    .slv_ext_wdata_o(slv_ext_wdata_o),
    .slv_ext_rdata_i(slv_ext_rdata_i),
    .slv_ext_sel_o(slv_ext_sel_o),
    .io_spi_clk(), //inout io_spi_clk
    .io_spi_csn(), //inout io_spi_csn
    .io_spi_mosi(), //inout io_spi_mosi
    .io_spi_miso(), //inout io_spi_miso
    .hrdata(hrdata),
    .hresp(hresp),
    .hready(hready),
    .haddr(haddr),
    .hwrite(hwrite),
    .hsize(hsize),
    .hburst(hburst),
    .hwdata(hwdata),
    .hsel(hsel),
    .htrans(htrans),
    .irq_in(12'b0), //input [31:20] irq_in
    .jtag_TDI(tdi_i), //input jtag_TDI
    .jtag_TDO(tdo_o), //output jtag_TDO
    .jtag_TCK(tck_i), //input jtag_TCK
    .jtag_TMS(tms_i), //input jtag_TMS
    .clk_in(clk_i), //input clk_in
    .resetn_in(rst_n_i) //input resetn_in
);

//wbreg_demo instantiation
wbreg_demo wbreg_demo_inst
(
    .wb_clk_i (clk_i),
    .wb_rst_i (~rst_n_i),
    .arst_i   (~rst_n_i),
    .wb_adr_i (slv_ext_adr_o[4:0]),
    .wb_dat_i (slv_ext_wdata_o),
    .wb_dat_o (slv_ext_rdata_i),
    .wb_we_i  (slv_ext_we_o),
    .wb_stb_i (slv_ext_stb_o),
    .wb_cyc_i (slv_ext_cyc_o),
    .wb_ack_o (slv_ext_ack_i)
);

//ahbreg_demo instantiation
ahbreg_demo ahbreg_demo_inst
(
  .hclk      (clk_in),
  .hresetn   (resetn),
  .haddr     (haddr),
  .htrans    (htrans),
  .hwrite    (hwrite),
  .hsize     (hsize),
  .hburst    (hburst),
  .hwdata    (hwdata),
  .hsel      (hsel),
  .hready_in (hready),
  .hready    (hready),
  .hrdata    (hrdata),
  .hresp     (hresp)
);




endmodule
