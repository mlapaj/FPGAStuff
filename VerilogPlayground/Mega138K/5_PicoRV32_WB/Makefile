
all: help

target: build/impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"

# Gowin stuff and Flash
clean:
	rm -f -r build/impl build/sim

build/impl/pnr/project.fs:
	mkdir -p build
	cd build && gw_sh ../script.tcl

floorplan:
	floorplanner -d GW5AST-138B -dn GW5AST-138 -dnv B -p PBGA484A -i build/impl/gwsynthesis/project.vg -c src/project.cst -path pnr -cfg impl/pnr/device.cfg\
		-pn GW5AST-LV138PG484AC1/I0 -posp impl/pnr/Project1_Hello_World.db -timing build/impl/pnr/Project1_Hello_World.timing_paths -place_option 3\
	       	-convert_sdp32_36_to_sdp16_18

flash: build/impl/pnr/project.fs
	# !!!! you will probably need to chagne serial number in the fututre
	# this is because I'm using multiple FTDI devices.
	openFPGALoader --vid 0x403 --pid 0x6010 -b tangmega138k  --ftdi-serial 2025012315  build/impl/pnr/project.fs

