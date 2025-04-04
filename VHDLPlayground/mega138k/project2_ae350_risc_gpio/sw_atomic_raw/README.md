# Intro
This is example of atomic operations using "raw" code without whole BSP support.
See debug scripts for more info.

Also this example contains OpenSBI + Uboot scenario.
OpenSBI starts firstly and switches supervisor mode and jumps to u-boot
Next, Uboot is starting (relocates at the end of ram)
See `oad_opensbi_uboot.gdb` script for more details.
