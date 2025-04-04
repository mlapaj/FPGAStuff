all: clean target flash

target: impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"

clean:
	rm -f -r impl sim

impl/pnr/project.fs:
	gw_sh script.tcl

flash: impl/pnr/project.fs
	openFPGALoader impl/pnr/project.fs

