CC=riscv32-unknown-elf-gcc
#CFLAGS=-matomic -march=rv32i2p0_m2p0_xandes5p0 -fno-builtin -g -Ibsp/config -Ibsp/driver/include -Ibsp/ae350 -Ibsp/lib
CFLAGS=-matomic -march=rv32i2p0_m2p0_d2p0_xandes5p0 -mno-b19758  -fno-builtin -g -Ibsp/config -Ibsp/driver/include -Ibsp/ae350 -Ibsp/lib
##CFLAGS=-fno-builtin -matomic -march=rv32i2p0_m2p0_xandes5p0 -g -Ibsp/config -Ibsp/driver/include -Ibsp/ae350 -Ibsp/lib
all: hello_world hello_world.hex
.PHONY: all

%.o: %.S
	@echo "Compiling ASM file"
	$(CC) -c -o $@ $<  $(CFLAGS)

%.o: %.c
	@echo "Compiling C file"
	$(CC) -c -o $@ $< $(CFLAGS)


hello_world: start.o hello_world.o bsp/lib/uart.o
	@echo "Linking"
	$(CC) -nostartfiles -T"LinkerScript.ld" -lgcc -o $@ $^
hello_world.hex: hello_world
	@echo "Preparing HEX file"
	riscv32-unknown-elf-objcopy -O ihex hello_world hello_world.hex
	@echo "Preparing MAP file"
	riscv32-unknown-elf-objdump -x hello_world > hello_world.map
	riscv32-unknown-elf-objdump -D hello_world > hello_world.dis

clean:
	rm -f bsp/ae350/*.o
	rm -f bsp/lib/*.o
	rm -f *.o hello_world hello_world.hex hello_world.map
