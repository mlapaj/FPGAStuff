all: clean target flash

target: impl/pnr/project.fs

.PHONY: all

help:
	@echo "\nHelp:"
	@echo "-----\n"
	@echo "make clean  - clean files"
	@echo "make target - build for Gowin FPGA"
	@echo "make flash  - flash bitstream to FPGA SRAM"
	@echo "make test_fifo_uart - run simulation of fifo module"
	@echo "make test_fifo_uart_view - view simulation wave of fifo module"

clean:
	rm -f -r impl sim

impl/pnr/project.fs:
	gw_sh script.tcl

flash: impl/pnr/project.fs
	openFPGALoader impl/pnr/project.fs

#####################################################
					TestBench
#####################################################
TB_UART_FILES = src/fifo_data.vhd src/fifo_uart.vhd tb/fifo_uart_tb.vhd
#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08
WAVEFORM_VIEWER = gtkwave
SIMDIR = sim

test_fifo_uart:
	mkdir -p simulation
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(TB_UART_FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work fifo_uart_tb
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work fifo_uart_tb\
	   	--stop-time=100us --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0 --wave=$(SIMDIR)/fifo_uart.ghw
test_fifo_uart_view: test_fifo_uart
	 $(WAVEFORM_VIEWER) $(SIMDIR)/fifo_uart.ghw --save sim_view/fifo_uart.gtkw --saveonexit
