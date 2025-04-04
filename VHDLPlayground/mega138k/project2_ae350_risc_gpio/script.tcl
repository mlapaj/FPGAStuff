# general options
#
set_device -name GW5AST-138B GW5AST-LV138PG484AC1/I0
set_option -vhdl_std vhd2019
set_option -top_module top

# my changes
add_file src/top.vhd
set_file_prop -lib work src/top.vhd
# pll
add_file src/gowin_pll/gowin_pll.vhd
set_file_prop -lib work src/gowin_pll/gowin_pll.vhd
# pll ddr3
add_file src/gowin_pll_ddr3/gowin_pll_DDR3.vhd
set_file_prop -lib work src/gowin_pll_ddr3/gowin_pll_DDR3.vhd
# soc
add_file src/riscv_ae350_soc/riscv_ae350_soc.vhd
set_file_prop -lib work src/riscv_ae350_soc/riscv_ae350_soc.vhd


add_file src/project.cst
add_file src/project.sdc
set_option -use_mspi_as_gpio 1
set_option -use_sspi_as_gpio 1
set_option -use_cpu_as_gpio 1

# synthesis
run syn
run pnr
