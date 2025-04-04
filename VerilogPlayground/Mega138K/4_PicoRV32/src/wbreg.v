
//wbreg_demo
module wbreg_demo
(
    wb_clk_i, 
    wb_rst_i, 
    arst_i, 
    wb_adr_i, 
    wb_dat_i, 
    wb_dat_o,
    wb_we_i, 
    wb_stb_i, 
    wb_cyc_i, 
    wb_ack_o
);

	// parameters
	parameter ARST_LVL = 1'b0; // asynchronous reset level

	// wishbone signals
	input         wb_clk_i;     // master clock input
	input         wb_rst_i;     // synchronous active high reset
	input         arst_i;       // asynchronous reset
	input  [4:0]  wb_adr_i;     // lower address bits
	input  [31:0] wb_dat_i;     // databus input
	output [31:0] wb_dat_o;     // databus output
	input         wb_we_i;      // write enable input
	input         wb_stb_i;     // stobe/core select signal
	input         wb_cyc_i;     // valid bus cycle input
	output        wb_ack_o;     // bus cycle acknowledge output

	reg    [31:0] wb_dat_o;
	reg           wb_ack_o;

	// registers
	reg  [31:0] reg0; 
	reg  [15:0] reg1;  
	reg  [ 7:0] reg2;

	// generate internal reset
	wire rst_i = arst_i ^ ARST_LVL;

	// generate acknowledge output signal
	always @(posedge wb_clk_i)
	  wb_ack_o <= #1 wb_cyc_i & wb_stb_i & ~wb_ack_o;

	// assign DAT_O
	always @(posedge wb_clk_i)
	begin
        case (wb_adr_i) // synopsys parallel_case
        5'h00: wb_dat_o <= #1 reg0; 
        5'h04: wb_dat_o <= #1 {16'h0, reg1};
        5'h08: wb_dat_o <= #1 {24'h0, reg2};
        default: wb_dat_o <= #1 0;   // reserved
	  endcase
	end

    always @(posedge wb_clk_i)
    begin
        if(wb_stb_i && wb_we_i)
            case (wb_adr_i)
                5'h00 : reg0 <= #1 wb_dat_i[31:0];
                5'h04 : reg1 <= #1 wb_dat_i[15:0];
                5'h08 : reg2 <= #1 wb_dat_i[7:0];
	            default: ;
            endcase
    end

endmodule