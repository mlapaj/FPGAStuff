all: help 

target: impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"
	@echo "make floorplan  - starts floorplanner"

#######################
# Gowin stuff and Flash
#######################
clean:
	rm -f -r impl sim

impl/pnr/project.fs:
	gw_sh script.tcl

floorplan:
	floorplanner -d GW5AST-138B -dn GW5AST-138 -dnv B -p PBGA484A -i impl/gwsynthesis/project.vg -c src/project.cst -path pnr -cfg impl/pnr/device.cfg\
		-pn GW5AST-LV138PG484AC1/I0 -posp impl/pnr/project.db -timing impl/pnr/project.timing_paths -place_option 3\
	       	-convert_sdp32_36_to_sdp16_18

flash: impl/pnr/project.fs
	# currently this is not working, using gowin programmer
	openFPGALoader impl/pnr/project.fs
	#$(GOWIN_PROGRAMMER)/programmer_cli --device GW5AST-138B --fsFile $(PWD)/impl/pnr/project.fs --operation_index 2


