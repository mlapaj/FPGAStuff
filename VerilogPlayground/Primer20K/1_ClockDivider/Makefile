
all: help 

target: build/impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"
	@echo "make test - run simulation of fifo module"
	@echo "make view - view simulation wave of fifo module"

# Gowin stuff and Flash
clean:
	rm -f -r build/impl build/sim

build/impl/pnr/project.fs:
	mkdir -p build
	cd build && gw_sh ../script.tcl

floorplan:
	floorplanner -d GW2A-18C -dn GW2A-18 -dnv C -p PBGA256\
		-i build/impl/gwsynthesis/project.vg -c src/project.cst -path pnr -cfg build/impl/pnr/device.cfg\
		-pn GW2A-LV18PG256C8/I7 -posp impl/pnr/Project1_Hello_World.db -timing impl/pnr/Project1_Hello_World.timing_paths -place_option 3\
	       	-convert_sdp32_36_to_sdp16_18

flash: build/impl/pnr/project.fs
	openFPGALoader build/impl/pnr/project.fs



#IVERILOG CONFIG
IVERILOG_CMD = iverilog
IVERILOG_FLAGS  =
# GTKWAVE
WAVEFORM_VIEWER = gtkwave
CUR_DIR = $(shell pwd)

# TestBench
TB = tb/top_tb.v
TB_SRC = -l $(CUR_DIR)/src/top.v -l $(CUR_DIR)/src/clock_divider.v
TB_OUT = top_tb
test:
	mkdir -p build/simulation
	@echo "COMPILING"
	cd build/simulation && iverilog $(TB_SRC) $(CUR_DIR)/$(TB) -o $(TB_OUT)
	@echo "RUNNING TEST"
	cd build/simulation && ./$(TB_OUT)

view: test
	 cd build/simulation && $(WAVEFORM_VIEWER) *.vcd --save hello.gtkw --saveonexit --rcvar 'do_initial_zoom_fit yes' --rcvar 'splash_disable yes'
