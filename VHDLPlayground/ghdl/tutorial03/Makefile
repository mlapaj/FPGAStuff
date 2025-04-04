# vhdl files
T80_FILES = source/T80/T80_Pack.vhd source/T80/GBse.vhd source/T80/T80.vhd source/T80/T8080se.vhd source/T80/T80_ALU.vhd source/T80/T80_MCode.vhd source/T80/T80_Reg.vhd source/T80/T80a.vhd source/T80/T80as.vhd source/T80/T80pa.vhd source/T80/T80s.vhd source/T80/T80se.vhd source/T80/T80sed.vhd
FILES = source/z80system_rom_image.vhd source/z80system.vhd source/z80system_rom.vhd source/z80system_ram.vhd testbench/z80system_tb.vhd
#GHDL CONFIG
GHDL_CMD = ghdl-gcc
GHDL_FLAGS  = --ieee=synopsys -fexplicit  --std=08 

SIMDIR = simulation

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean compile run view

compile: 
	mkdir -p simulation
	echo "$(T80_FILES)"
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation --work=t80lib $(T80_FILES)
# Use option -P to specify where libraries other than ‘WORK’ are placed. 
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work $(FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work z80system_tb
	mkdir -p $(SIMDIR)

run: 	
	echo "RUN"
	date
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation -P=simulation --work=work z80system_tb\
	   	--stop-time=1000ms --ieee-asserts=disable  --assert-level=error --max-stack-alloc=0
#--wave=$(SIMDIR)/out.ghw 
	date
view:
	echo "VIEW"
	$(WAVEFORM_VIEWER) $(SIMDIR)/out.ghw

clean:
	rm -rf $(SIMDIR)
