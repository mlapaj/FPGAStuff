module top
(
    // ae-350
    input wire tck_in,
    input wire tms_in,
    input wire trst_in,
    input wire tdi_in,
    output wire tdo_out,
    // ae-350 gpio uart
    output uart2_txd,
    input  uart2_rxd,
    // ae-350 spi flash memory
    inout flash_spi_csn,
    inout flash_spi_miso,
    inout flash_spi_mosi,
    inout flash_spi_clk,
    inout flash_spi_holdn,
    inout flash_spi_wpn,
    // ae-350 ddr3 memory
    output ddr3_init,
    output [2:0] ddr3_bank,
    output ddr3_cs_n,
    output ddr3_ras_n,
    output ddr3_cas_n,
    output ddr3_we_n,
    output ddr3_ck,
    output ddr3_ck_n,
    output ddr3_cke,
    output ddr3_reset_n,
    output ddr3_odt,
    output [13:0] ddr3_addr,
    output [1:0] ddr3_dm,
    inout [15:0] ddr3_dq,
    inout [1:0] ddr3_dqs,
    inout [1:0] ddr3_dqs_n,
    // clock
    input wire clk_i,
    // module reset
    input wire rst_n_i,
    // gpio
    inout [2:0] led,
    inout [2:0] key
);

wire ddr_clk;
wire core_clk;
wire ahb_clk;
wire apb_clk;
wire rtc_clk;
// Gowin_PLL_AE350 instantiation
Gowin_PLL_AE350 PLL_AE350
(
    .clkout0(ddr_clk),          // 100mhz
    .clkout1(core_clk),         // 800mhz
    .clkout2(ahb_clk),          // 100mhz
    .clkout3(apb_clk),          // 100mhz
    .clkout4(rtc_clk),          // 10mhz
    .clkin(clk_i),
    .enclk0(1'b1),
    .enclk1(1'b1),
    .enclk2(1'b1),
    .enclk3(1'b1),
    .enclk4(1'b1)
);


wire ddr3_lock;
wire ddr3_clk_in;
wire ddr3_memory_clk;
wire ddr3_stop;
wire [31:0] gpio;

assign led = gpio[1:0];
assign key = gpio[3:2];

Gowin_PLL_DDR3 PLL_DDR3
(
    .lock(ddr3_lock),
    .clkout0(ddr3_clk_in),          // 50mhz
    .clkout2(ddr3_memory_clk),      // 250mhz
    .clkin(clk_i),
    .reset(1'b0),                   // enforce
    .enclk0(1'b1),
    .enclk2(ddr3_stop)
);

RiscV_AE350_SOC_Top CPU(
    .FLASH_SPI_CSN(flash_spi_csn), //inout flash_spi_csn
    .FLASH_SPI_MISO(flash_spi_miso), //inout flash_spi_miso
    .FLASH_SPI_MOSI(flash_spi_mosi), //inout flash_spi_mosi
    .FLASH_SPI_CLK(flash_spi_clk), //inout flash_spi_clk
    .FLASH_SPI_HOLDN(flash_spi_holdn), //inout flash_spi_holdn
    .FLASH_SPI_WPN(flash_spi_wpn), //inout flash_spi_wpn
    .DDR3_MEMORY_CLK(ddr3_memory_clk), //input ddr3_memory_clk
    .DDR3_CLK_IN(ddr3_clk_in), //input ddr3_clk_in
    .DDR3_RSTN(rst_n_i),  //input ddr3_rstn
    .DDR3_LOCK(ddr3_lock), //input ddr3_lock
    .DDR3_STOP(ddr3_stop), //output ddr3_stop
    .DDR3_INIT(ddr3_init), //output ddr3_init
    .DDR3_BANK(ddr3_bank), //output [2:0] ddr3_bank
    .DDR3_CS_N(ddr3_cs_n), //output ddr3_cs_n
    .DDR3_RAS_N(ddr3_ras_n), //output ddr3_ras_n
    .DDR3_CAS_N(ddr3_cas_n), //output ddr3_cas_n
    .DDR3_WE_N(ddr3_we_n), //output ddr3_we_n
    .DDR3_CK(ddr3_ck), //output ddr3_ck
    .DDR3_CK_N(ddr3_ck_n), //output ddr3_ck_n
    .DDR3_CKE(ddr3_cke), //output ddr3_cke
    .DDR3_RESET_N(ddr3_reset_n), //output ddr3_reset_n
    .DDR3_ODT(ddr3_odt), //output ddr3_odt
    .DDR3_ADDR(ddr3_addr), //output [13:0] ddr3_addr
    .DDR3_DM(ddr3_dm), //output [1:0] ddr3_dm
    .DDR3_DQ(ddr3_dq), //inout [15:0] ddr3_dq
    .DDR3_DQS(ddr3_dqs), //inout [1:0] ddr3_dqs
    .DDR3_DQS_N(ddr3_dqs_n), //inout [1:0] ddr3_dqs_n
    .TCK_IN(tck_in), //input tck_in
    .TMS_IN(tms_in), //input tms_in
    .TRST_IN(trst_in), //input trst_in
    .TDI_IN(tdi_in), //input tdi_in
    .TDO_OUT(tdo_out), //output tdo_out
    .TDO_OE(), //output tdo_oe - we are not using it
    .UART2_TXD(uart2_txd), //output uart2_txd
    .UART2_RTSN(), //output uart2_rtsn
    .UART2_RXD(uart2_rxd), //input uart2_rxd
    .UART2_CTSN(1'b0), //input uart2_ctsn
    .UART2_DCDN(1'b0), //input uart2_dcdn
    .UART2_DSRN(1'b0), //input uart2_dsrn
    .UART2_RIN(1'b0), //input uart2_rin
    .UART2_DTRN(), //output uart2_dtrn
    .UART2_OUT1N(), //output uart2_out1n
    .UART2_OUT2N(), //output uart2_out2n
    .GPIO(gpio), //inout [31:0] gpio
    .CORE_CLK(core_clk), //input core_clk
    .DDR_CLK(ddr_clk), //input ddr_clk
    .AHB_CLK(ahb_clk), //input ahb_clk
    .APB_CLK(apb_clk), //input apb_clk
    .RTC_CLK(rtc_clk), //input rtc_clk
    .POR_RSTN(ddr3_init), //input por_rstn
    .HW_RSTN(ddr3_init) //input hw_rstn
);

endmodule
