//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 Education 
//Created Time: 2025-03-26 12:00:34
create_clock -name clk_i -period 20 -waveform {0 10} [get_ports {clk_i}]
create_clock -name jtag_TCK -period 200 -waveform {0 100} [get_ports {tck_i}]
set_clock_groups -exclusive -group [get_clocks {jtag_TCK}] -group [get_clocks {clk_i}]
set_operating_conditions -grade c -model slow -speed 2 -setup -hold
