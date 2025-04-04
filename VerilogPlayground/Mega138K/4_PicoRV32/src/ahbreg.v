
//ahbreg_demo
module ahbreg_demo
(
    input             hclk,
    input             hresetn,
    input      [31:0] haddr,
    input       [1:0] htrans,
    input             hwrite,
    input             hsize,
    input             hburst,
    input      [31:0] hwdata,
    input             hsel,
    input             hready_in,
    output            hready,
    output reg [31:0] hrdata,
    output      [1:0] hresp
);

parameter RESP_OK = 2'b0;
wire          cmd_valid;
reg    [15:0] addr_reg;
reg           cmd_wr;

reg    [31:0] reg0;
reg    [31:0] reg1;

//cmd addr
assign  cmd_valid = hready_in && hsel && htrans[1] && (haddr[31:28] == 4'h8);
assign  hready    = 1'b1;
assign  hresp     = RESP_OK;


//store addr & cmd_wr
always@(posedge hclk or negedge hresetn)
begin
    if(!hresetn) begin
        addr_reg <= 16'b0;
        cmd_wr   <= 1'b0;
    end
    else if(cmd_valid) begin
        addr_reg <= haddr[15:0];
        cmd_wr   <= hwrite;
    end
    else begin
        addr_reg <= 16'b0;
        cmd_wr   <= 1'b0;
    end
end

//read from regs
always@(*)
begin
    case({cmd_wr,addr_reg})
        17'h0_0000: hrdata = reg0;
        17'h0_0004: hrdata = reg1;
        default:    hrdata = 32'b0;
    endcase
end

//write to regs
always@(posedge hclk or negedge hresetn)
begin
    if(!hresetn) begin
        reg0 <= 32'b0;
        reg1 <= 32'b0;
    end
    else if((addr_reg == 16'h0000) && cmd_wr) begin
        reg0 <= hwdata;
    end
    else if((addr_reg == 16'h0004) && cmd_wr) begin
        reg1 <= hwdata;
    end
end

endmodule