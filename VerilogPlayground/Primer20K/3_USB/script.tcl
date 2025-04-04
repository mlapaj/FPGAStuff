# general options
set_device -name GW2A-18C GW2A-LV18PG256C8/I7
set_option -top_module top
#set_option -verilog_std sysv2017
# set_option -print_all_synthesis_warning 1
# set_option -show_all_warn 1
# my changes, use ../ to location since script will be running
# in build directory
set src_dir "../src"
# get all v files from src dir
set v_src_files [glob -nocomplain -directory $src_dir -types f "*.v"]
# get all v files from src/* subdirs
set v_src_sub_files [glob -nocomplain -directory $src_dir -types f -join **/*.v]
# we have got all *.v files from src and src/*/*.v, merge
set v_files [concat $v_src_files $v_src_sub_files]
set v_filtered_files []
# filter out *_tmp.v files (templates created by IP Core gen)
foreach file $v_files {
    if {[string match "*_tmp.v" [file tail $file]]} {
        continue
    }
    lappend v_filtered_files $file
}
# add files to gowin stuff
foreach file $v_filtered_files {
    add_file $file
    set_file_prop -lib work $file
}

add_file ../src/project.cst

# synthesis
run syn
run pnr
