set pagination off
set disassemble-next-line on
target remote localhost:3333
file hello_world
monitor reset halt
restore hello_world
set $pc = _start
stepi
b amoswapw_func
c
