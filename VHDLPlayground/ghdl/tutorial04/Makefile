# vhdl files
FILES = source/scr_rom_image.vhd source/scr.vhd source/scr_rom.vhd testbench/scr_tb.vhd
#GHDL CONFIG
GHDL_CMD = ghdl-mcode
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08

SIMDIR = simulation

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean compile run view

compile:
	mkdir -p simulation
# Use option -P to specify where libraries other than ‘WORK’ are placed.
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work scr_tb
	mkdir -p $(SIMDIR)

run:
	@echo "RUN"
	@date
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work scr_tb\
	   	--stop-time=50ms --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0
#--wave=$(SIMDIR)/out.ghw
	@date
view:
	echo "VIEW"
	$(WAVEFORM_VIEWER) $(SIMDIR)/out.ghw

clean:
	rm -rf $(SIMDIR)
