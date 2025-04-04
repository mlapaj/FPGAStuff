# vhdl files
FILES = source/*
VHDLEX = .vhd

# testbench
TESTBENCHFILE = ula_tb
TESTBENCHPATH = testbench/${TESTBENCHFILE}$(VHDLEX)

#GHDL CONFIG
GHDL_CMD = ghdl-mcode
GHDL_FLAGS  = --ieee=synopsys --warn-no-vital-generic --std=08

SIMDIR = simulation
STOP_TIME = 500ns
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean compile run view

compile:
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
	$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE)

run:
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE) --wave=$(SIMDIR)/out.ghw --stop-time=150ms

view:
	$(WAVEFORM_VIEWER) wave.gtkw
#	$(WAVEFORM_VIEWER) $(SIMDIR)/out.ghw

clean:
	rm -rf $(SIMDIR)
