# general options
set_device GW2A-LV18PG256C8/I7
set_option -vhdl_std vhd2008
set_option -top_module top_module

# files
add_file src/fifo_data.vhd
set_file_prop -lib work src/fifo_data.vhd
add_file src/top_module.vhd
set_file_prop -lib work src/top_module.vhd
add_file src/uart.vhd
set_file_prop -lib work src/uart.vhd
add_file src/fifo_uart.vhd
set_file_prop -lib work src/fifo_uart.vhd

add_file src/ddr3_memory_interface/ddr3_memory_interface.vhd
set_file_prop -lib work src/ddr3_memory_interface/ddr3_memory_interface.vhd
add_file src/gowin_rpll/gowin_rpll.vhd
set_file_prop -lib work src/gowin_rpll/gowin_rpll.vhd

add_file src/project9_ddram_test.cst

# synthesis
run syn
run pnr
