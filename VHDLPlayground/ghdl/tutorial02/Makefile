# vhdl files
# https://stnolting.github.io/neorv32/ug/
# Some tools (like Lattice Radiant) might require a manual compile order of the VHDL source files to 
# identify the dependencies. The package file neorv32_package.vhd should be analyzed first followed by
#  the memory image files (neorv32_application_imagevhd and neorv32_bootloader_image.vhd) and the
#  entity-only files (neorv32_*mem.entity.vhd). 
#LAPAJ: had to do this manually :/
NEORV32_FILES = source/core/neorv32_package.vhd source/core/neorv32_bus_keeper.vhd source/core/neorv32_busswitch.vhd source/core/neorv32_cfs.vhd source/core/neorv32_cpu.vhd source/core/neorv32_cpu_alu.vhd source/core/neorv32_cpu_bus.vhd source/core/neorv32_cpu_control.vhd source/core/neorv32_cpu_cp_bitmanip.vhd source/core/neorv32_cpu_cp_cfu.vhd source/core/neorv32_cpu_cp_cond.vhd source/core/neorv32_cpu_cp_fpu.vhd source/core/neorv32_cpu_cp_muldiv.vhd source/core/neorv32_cpu_cp_shifter.vhd source/core/neorv32_cpu_decompressor.vhd source/core/neorv32_cpu_regfile.vhd source/core/neorv32_dcache.vhd source/core/neorv32_debug_dm.vhd source/core/neorv32_debug_dtm.vhd source/core/neorv32_dmem.entity.vhd source/core/neorv32_fifo.vhd source/core/neorv32_gpio.vhd source/core/neorv32_gptmr.vhd source/core/neorv32_icache.vhd source/core/neorv32_imem.entity.vhd source/core/neorv32_mtime.vhd source/core/neorv32_neoled.vhd source/core/neorv32_onewire.vhd source/core/neorv32_pwm.vhd source/core/neorv32_sdi.vhd source/core/neorv32_spi.vhd source/core/neorv32_sysinfo.vhd source/core/neorv32_top.vhd source/core/neorv32_trng.vhd source/core/neorv32_twi.vhd source/core/neorv32_uart.vhd source/core/neorv32_wdt.vhd source/core/neorv32_wishbone.vhd source/core/neorv32_xip.vhd source/core/neorv32_xirq.vhd source/core/neorv32_application_image.vhd source/core/neorv32_boot_rom.vhd source/core/neorv32_bootloader_image.vhd source/core/mem/neorv32_dmem.default.vhd source/core/mem/neorv32_imem.default.vhd

#FILES = $(wildcard source/*.vhd)  $(wildcard testbench/*.vhd)
FILES = source/neov32.vhd testbench/uart_rx.simple.vhd testbench/neov32_tb.vhd 
TESTBENCHFILE = neov32_tb
#GHDL CONFIG
GHDL_CMD = ghdl-mcode
GHDL_FLAGS  = 

SIMDIR = simulation
STOP_TIME = 500ns
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean compile run view

compile: 
	mkdir -p simulation
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation --work=neorv32 $(NEORV32_FILES)
# Use option -P to specify where libraries other than ‘WORK’ are placed. 
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work neorv32_tb
	mkdir -p $(SIMDIR)

run: 	
	echo "RUN"
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work neorv32_tb\
	   	--stop-time=10ms --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0
#  	--wave=$(SIMDIR)/out.ghw 
view:
	$(WAVEFORM_VIEWER) $(SIMDIR)/out.ghw

clean:
	rm -rf $(SIMDIR)
