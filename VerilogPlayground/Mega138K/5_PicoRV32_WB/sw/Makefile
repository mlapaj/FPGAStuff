HOST=riscv-none-elf-
CC=$(HOST)gcc
OBJCOPY=$(HOST)objcopy
CFLAGS=-march=rv32imc_zicsr -mabi=ilp32 -mtune=size -mcmodel=medany -msmall-data-limit=8 -mstrict-align -msave-restore -O0 -fmessage-length=0 -ffunction-sections -fdata-sections -fno-builtin -g3 -Ibsp -Ilib -I.
all: main
.PHONY: all

%.o: %.S
	@echo "Compile ASM [`tput setaf 5`$<`tput sgr0`]"
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c
	@echo "Compile C [`tput setaf 5`$<`tput sgr0`]"
	$(CC) -c -o $@ $< $(CFLAGS)

main: app.elf app.bin app.hex
	@echo "Done"

app.elf: main.o irq.o bsp/wbgpio.o bsp/wbuart.o bsp/wbspiflash.o lib/printf.o lib/firmware.o start.o custom_ops.o
	@echo "Linking"
	$(CC) $(CFLAGS) -nostartfiles -Xlinker -T"sections.lds" -o $@ $^
app.bin: app.elf
	@echo "Generating BIN file"
	$(OBJCOPY) -O binary -j .text -j .data -j.irqsec -j.ldsec -j.btsec "$^"  "$@"
app.hex: app.bin app.elf
	@echo "Generating HEX file"
	xxd -e -g4 -c 4 $< | awk '{print $$2}' > $@

clean:
	rm *.elf
	rm -f bsp/*.o
	rm -f lib/*.o
	rm -f *.o *.dis *.bin hello_world hello_world.hex hello_world.map
