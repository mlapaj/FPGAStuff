set logging file mylog.txt
set logging on
set pagination off
set disassemble-next-line on
target extended-remote :3333

file hello_world
monitor reset
monitor reset halt
restore hello_world
set $pc = _start
b hello_world.c:97
c
d 1
x /1xb 0x40000
set $i = 10
while $i <= 17
    eval "set $x%d = 0", $i
    set $i = $i + 1
end
set $pc=0
restore Image.gz binary 0x4000000
restore initramfs.cpio.gz binary 0x5000000
file fw_jump.elf
restore fw_jump.elf
restore u-boot-sbi
restore u-boot.dtb binary 0x200000
#hartId is in a0
#dtb addres in a1
set $a1=0x200000
b *0x400000
c
d 1
file u-boot-sbi
## WARNING: THIS IS TEMPORARY HACK - it removes "fence" instruction before "amoswap.w" in u-boot
## see u-boot/arch/riscv/cpu/start.S
## GCC is adding fence before each amoswap.w. I did not found the way to disable it
## so for now i`m edting this in memory.
## most probably, these ofsets may change and you need to check it by yourself
set {unsigned char[4]} (call_harts_early_init+20) = {0x13, 0x00, 0x00, 0x00}
set {unsigned char[4]} (call_harts_early_init+60) = {0x13, 0x00, 0x00, 0x00}
set {unsigned char[4]} (wait_for_gd_init+16) = {0x13, 0x00, 0x00, 0x00}
set {unsigned char[4]} (wait_for_gd_init+48) = {0x13, 0x00, 0x00, 0x00}
b *0x3FF70000
#b announce_and_cleanup
add-symbol-file u-boot-sbi  0x3FF70000
# unload all symbols - doing by file without filename
file
c
add-symbol-file vmlinux -s .head.text 0x00400000 -s .text 0x00402000 -s .init.data 0x1400000 -s .sdata 0x2000000 -s .sbss 0x20D1000 -s .bss 0x20D3000 -s .rodata 0x1800000

# Kernel
# gdb
# restore Image.gz binary 0x4000000
# uboot:
# base 0x1000000;unzip 0x4000000 0x1000000;booti 0x1000000 - 0x200000
# base 0x1000000;unzip 0x4000000 0x1000000;booti 0x1000000 - 0x200000
# base 0x1000000;unzip 0x4000000 0x1000000;booti 0x1000000 0x6000000 0x200000

