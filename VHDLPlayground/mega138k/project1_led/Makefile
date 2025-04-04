all: clean target flash

target: impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"
	@echo "make test - run simulation of fifo module"
	@echo "make view - view simulation wave of fifo module"

#######################
# Gowin stuff and Flash
#######################
clean:
	rm -f -r impl sim

impl/pnr/project.fs:
	gw_sh script.tcl
	
floorplan:
	floorplanner -d GW5AST-138B -dn GW5AST-138 -dnv B -p PBGA484A -i impl/gwsynthesis/project.vg -c src/project.cst -path pnr -cfg impl/pnr/device.cfg\
		-pn GW5AST-LV138PG484AC1/I0 -posp impl/pnr/Project1_Hello_World.db -timing impl/pnr/Project1_Hello_World.timing_paths -place_option 3\
	       	-convert_sdp32_36_to_sdp16_18

flash: impl/pnr/project.fs
	openFPGALoader -b tangmega138k impl/pnr/project.fs


###########
# TestBench
###########
TB_FILES = src/hello.vhd tb/hello_tb.vhd
#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08
WAVEFORM_VIEWER = gtkwave
SIMDIR = sim

test:
	mkdir -p simulation
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(TB_FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work hello_tb
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work hello_tb\
	   	--stop-time=100us --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0 --wave=$(SIMDIR)/hello.ghw
view: test
	 $(WAVEFORM_VIEWER) $(SIMDIR)/hello.ghw --save hello.gtkw --saveonexit
