# general options
set_device -name GW2A-18C GW2A-LV18PG256C8/I7
set_option -top_module top

# my changes, use ../ to location since script will be running
# in build directory
add_file ../src/top.v
set_file_prop -lib work ../src/top.v

add_file ../src/gowin_rpll/gowin_rpll.v
set_file_prop -lib work ../src/gowin_rpll/gowin_rpll.v

add_file ../src/wb.v
set_file_prop -lib work ../src/wb.v

add_file ../src/gowin_picorv32/gowin_picorv32.v
set_file_prop -lib work ../src/gowin_picorv32/gowin_picorv32.v


add_file ../src/project.cst
#add_file ../src/project.sdc

# synthesis
run syn
run pnr
