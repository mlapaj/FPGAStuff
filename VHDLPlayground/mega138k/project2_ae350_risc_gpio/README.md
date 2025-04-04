# Simple RISC GPIO UART Example

This example uses RISC hard IP core.

Features:

- Simple GPIO control using register - switching GPIO direction to output/input

- Usage of BSP taken from Gowin AE350 examples. UART is used

## Connections

SDRAM interface is used to connect JTAG and UART.

IO_LOC  "UART2_TXD"           C20;
IO_LOC  "UART2_RXD"           D20;



IO_LOC "TMS_IN"     B13;    //5
IO_LOC "TCK_IN"     C13;    //6
IO_LOC "TRST_IN"    A14;    //7
IO_LOC "TDO_OUT"    A13;    //8
IO_LOC "TDI_IN"     B16;    //9

## Building bitstream

You will need to have configured gowin EDA commercial for it.

Since I`m using command line tools provided by Gowin, you will need to specify EDA path by: setting enviornement variable:

```bash
export GOWIN_IDE=/dir/.../IDE/bin
export GOWIN_PROGRAMMER=/dir/.../Programmer/bin

```

Next build everything by:

```bash
make clean all
```

It will automatically write bitstream to SRAM.



## Software:

For software compilation, I have used a toolchain provided by andes

See: [Releases · andestech/Andes-Development-Kit · GitHub](https://github.com/andestech/Andes-Development-Kit/releases)

I have used: [nds32le-elf-mculib-v5.txz](https://github.com/andestech/Andes-Development-Kit/releases/download/ast-v5_3_0-release-linux/nds32le-elf-mculib-v5.txz)

In sw directory type `make` to build.



## Loading SW on board

I`m using JLINK to load software on board.

To run this test, you will need to load software on board. Since I`ll be working mostly with software, I'm loading software to DDR memory and starting instead adding it to bitstream.

I'm using J-Link debugger. So first thing is to start JLinkGDBServer:

```bash
JLinkGDBServerExe  -select USB=0 -device RISC-V -endian little -if JTAG -speed 4000 -noir -LocalhostOnly -nologtofile -port 2331 -SWOPort 2332 -TelnetPort 2333
```

Next, since there are some dependency issues with andes gdb, I'm using gdb-multiarch:

```bash
db-multiarch 
(gdb) file hello_world
(gdb)target remote localhost:2331
(gdb) mon reset
(gdb) restore hello_world
Restoring section .text (0x10000 to 0x14158)
Restoring section .rodata (0x14158 to 0x141b2)
Restoring section .eh_frame (0x151b4 to 0x151b8)
Restoring section .init_array (0x151b8 to 0x151c0)
Restoring section .fini_array (0x151c0 to 0x151c4)
Restoring section .data (0x151c8 to 0x15700)
Restoring section .sdata (0x15700 to 0x15714)
(gdb) continue
```

After this, you should get your SW working. 



## Result

You should attach LED PMOD delivered with your board to left PMOD connector on your TANG MEGA NEO board



Also you should connect UART and connect using 9600 bauds.

You will get `Hello World` string on your UART.



## Notes

This is simple-and-stupid example. Do not expect bulletproof example. Some things may not work. **Use this at your own risk***.
