# general options
set script_path [info script]
set script_directory [file dirname $script_path]
set absolute_script_directory [file normalize $script_directory]


set_device -name GW5AST-138B GW5AST-LV138PG484AC1/I0
set_option -top_module top
# to speed up placement
set_option -place_option 2

add_file $absolute_script_directory/src/top.v
set_file_prop -lib work $absolute_script_directory/src/top.v
add_file $absolute_script_directory/src/riscv_ae350_soc/riscv_ae350_soc.v
set_file_prop -lib work $absolute_script_directory/src/riscv_ae350_soc/riscv_ae350_soc.v
add_file $absolute_script_directory/src/gowin_pll_ae350/gowin_pll_ae350.v
set_file_prop -lib work $absolute_script_directory/src/gowin_pll_ae350/gowin_pll_ae350.v
add_file $absolute_script_directory/src/simple_apb_module.v
set_file_prop -lib work $absolute_script_directory/src/simple_apb_module.v


add_file $absolute_script_directory/src/project.cst



# we will use these ports in our project
set_option -use_mspi_as_gpio 1
set_option -use_sspi_as_gpio 1
set_option -use_cpu_as_gpio 1


# synthesis
run syn
run pnr
