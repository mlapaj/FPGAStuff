# general options
#
set_device -name GW5AST-138B GW5AST-LV138PG484AC1/I0
set_option -vhdl_std vhd2019
set_option -top_module hello

# my changes
add_file src/hello.vhd
set_file_prop -lib work src/hello.vhd


add_file src/project.cst

# synthesis
run syn
run pnr
