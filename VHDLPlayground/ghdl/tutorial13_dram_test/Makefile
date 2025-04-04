# vhdl files
FILES = source/top_module.vhd source/mem_interface.vhd testbench/top_module_tb.vhd

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08

SIMDIR = simulation

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean compile run view

compile:
	mkdir -p simulation
	echo "$(T80_FILES)"
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work top_module_tb 
	mkdir -p $(SIMDIR)

run:
	echo "RUN"
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work top_module_tb\
	   	--stop-time=100us --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0 --wave=$(SIMDIR)/out.ghw
# 1000ms
view:
	echo "VIEW"
	$(WAVEFORM_VIEWER) wave.gtkw
#	$(WAVEFORM_VIEWER) $(SIMDIR)/out.ghw

clean:
	rm -rf $(SIMDIR)
