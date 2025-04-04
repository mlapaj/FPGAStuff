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

wire [31:0] gpio;

assign led = gpio[1:0];
assign key = gpio[3:2];

RiscV_AE350_SOC_Top CPU(
    .TCK_IN(tck_in), //input tck_in
    .TMS_IN(tms_in), //input tms_in
    .TRST_IN(trst_in), //input trst_in
    .TDI_IN(tdi_in), //input tdi_in
    .TDO_OUT(tdo_out), //output tdo_out
    .TDO_OE(), //output tdo_oe - we are not using it
    .APB_PRDATA(apb_prdata), //input [31:0] APB_PRDATA
    .APB_PREADY(apb_pready), //input APB_PREADY
    .APB_PSLVERR(), //input APB_PSLVERR
    .APB_PADDR(apb_paddr), //output [31:0] APB_PADDR
    .APB_PENABLE(apb_psel), //output APB_PENABLE
    .APB_PSEL(apb_penable), //output APB_PSEL
    .APB_PWDATA(apb_pwdata), //output [31:0] APB_PWDATA
    .APB_PWRITE(apb_pwrite), //output APB_PWRITE
    .APB_PPROT(), //output [2:0] APB_PPROT
    .APB_PSTRB(), //output [3:0] APB_PSTRB
    .APB_PCLK(apb_pclk), //output APB_PCLK
    .APB_PRSTN(), //output APB_PRSTN
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
    .POR_RSTN(rst_n_i), //input por_rstn
    .HW_RSTN(rst_n_i) //input hw_rstn
);

endmodule
