`timescale 1ns/1ps
module top_tb;
reg clk;
reg reset_n;
wire clk_out;

top top0 (clk, reset_n, clk_out);

initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
    $display("Starting clock");
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period (100 MHz)
end
initial begin
    #500 $finish;
end
initial begin
    reset_n = 0;
    #10 reset_n = 1;
end
endmodule
