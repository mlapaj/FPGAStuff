module top (input clk_i,
            input reset_n_i,
            output clk_o);
wire reset;
assign reset = !reset_n_i;

clock_divider #(.DIV_FACTOR(10)) u_clock_divider (
    .clk_in(clk_i),
    .reset(reset),
    .clk_out(clk_o)
);

initial begin
    $display("hello world from top module");
end
endmodule
