CC=riscv32-unknown-elf-gcc
CFLAGS=-c -march=rv32i_zicsr -matomic -fno-builtin -g  -Ibsp/config -Ibsp/driver/include -Ibsp/ae350 -Ibsp/lib
#CFLAGS=-c -matomic -march=rv32i2p0_m2p0_xandes5p0 -fmessage-length=0 -fomit-frame-pointer -fno-strict-aliasing -Wa,-mno-b19758 -fno-builtin -g  -Ibsp/config -Ibsp/driver/include -Ibsp/ae350 -Ibsp/lib
# all: hello_world hello_world.hex
.PHONY: all

%.o: %.S
	@echo "Compiling ASM file"
	$(CC) -c -o bsp/ae350/start.o bsp/ae350/start.S $(CFLAGS)

%.o: %.c
	@echo "Compiling C file"
	$(CC) -c -o $@ $< $(CFLAGS)


hello_world: hello_world.o bsp/ae350/reset.o bsp/ae350/trap.o bsp/ae350/start.o bsp/ae350/ae350.o bsp/ae350/interrupt.o bsp/lib/uart.o bsp/lib/delay.o bsp/lib/printf.c bsp/ae350/loader.o
	@echo "Linking"
	$(CC) -nostartfiles -T"LinkerScript.ld" -lgcc -o $@ $^
hello_world.hex: hello_world
	@echo "Preparing HEX file"
	riscv32-unknown-elf-objcopy -O ihex hello_world hello_world.hex
	riscv32-unknown-elf-objcopy -O binary hello_world hello_world.bin
	@echo "Preparing MAP file"
	riscv32-unknown-elf-objdump -x hello_world > hello_world.map
	riscv32-unknown-elf-objdump -D hello_world > hello_world.dis

clean:
	rm -f bsp/ae350/*.o
	rm -f bsp/lib/*.o
	rm -f *.o *.bin *.dis  hello_world hello_world.hex hello_world.map
