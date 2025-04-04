# general options
set_device -name GW5AST-138B GW5AST-LV138PG484AC1/I0
set_option -top_module top

# my changes, use ../ to location since script will be running
# in build directory
add_file ../src/top.v
set_file_prop -lib work ../src/top.v
add_file ../src/clock_divider.v
set_file_prop -lib work ../src/clock_divider.v
add_file ../src/project.cst

# synthesis
run syn
run pnr
