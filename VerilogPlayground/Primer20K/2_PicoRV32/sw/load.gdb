set pagination off
set disassemble-next-line on
target remote localhost:3333
file app.elf
monitor reset halt
restore app.elf
set $pc = start
stepi
c
