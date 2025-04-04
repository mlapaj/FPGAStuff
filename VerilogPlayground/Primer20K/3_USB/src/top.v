module top
(
    output wire uart_txd,
    input  wire uart_rxd,

    input clk_i,
    input rst_n_i,

    input ulpi_clk_i,
    input [7:0] ulpi_data_i,
    output [7:0] ulpi_data_o,
    input  ulpi_dir_i,
    input  ulpi_nxt_i,
    output ulpi_stp_o,
    output ulpi_rst_o,
    output dbg_o
);

assign ulpi_rst_o = 1'b1;
assign dbg_o = ulpi_clk_i;

wire [7:0] data_i;
wire [7:0] data_o;


usb_cdc_top u_usb
(
    // Inputs
    .clk_i(ulpi_clk_i),
    .rst_i(~rst_n_i),
    .ulpi_data_out_i(ulpi_data_i),
    .ulpi_dir_i(ulpi_dir_i),
    .ulpi_nxt_i(ulpi_nxt_i),
    .tx_i(uart_rxd),

    .ulpi_data_in_o(ulpi_data_o),
    .ulpi_stp_o(ulpi_stp_o),
    .rx_o(uart_txd)
);


endmodule
