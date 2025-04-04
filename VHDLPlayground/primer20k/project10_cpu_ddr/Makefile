all: clean target flash

target: impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"
	@echo "make test_wishbone_mem - run simulation of wishbone memory module"
	@echo "make test_wishbone_mem_view - view simulation wave wishbone memory module"

clean:
	rm -f -r impl sim

impl/pnr/project.fs:
	gw_sh script.tcl

flash: impl/pnr/project.fs
	openFPGALoader impl/pnr/project.fs

#####################################################
					TestBench
#####################################################
TB_UART_FILES = src/wishbone_mem.vhd tb/wishbone_mem_tb.vhd tb/memory_interface.vhd
#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08
WAVEFORM_VIEWER = gtkwave
SIMDIR = sim

test_wishbone_mem:
	mkdir -p simulation
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(TB_UART_FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work wishbone_mem_tb
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work wishbone_mem_tb\
	   	--stop-time=100us --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0 --wave=$(SIMDIR)/wishbone.ghw
test_wishbone_mem_view: test_wishbone_mem
	 $(WAVEFORM_VIEWER) $(SIMDIR)/wishbone.ghw --save sim_view/wishbone.gtkw --saveonexit
