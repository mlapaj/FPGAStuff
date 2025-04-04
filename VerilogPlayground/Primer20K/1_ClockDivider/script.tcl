# general options
set_device -name GW2A-18C GW2A-LV18PG256C8/I7
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
