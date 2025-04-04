# general options
set_device GW2A-LV18PG256C8/I7
set_option -vhdl_std vhd2008
set_option -top_module top_module

#neorv32
add_file src/core/neorv32_application_image.vhd
set_file_prop -lib neorv32 src/core/neorv32_application_image.vhd
add_file src/core/neorv32_bootloader_image.vhd
set_file_prop -lib neorv32 src/core/neorv32_bootloader_image.vhd
add_file src/core/neorv32_boot_rom.vhd
set_file_prop -lib neorv32 src/core/neorv32_boot_rom.vhd
add_file src/core/neorv32_cfs.vhd
set_file_prop -lib neorv32 src/core/neorv32_cfs.vhd
add_file src/core/neorv32_cpu_alu.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_alu.vhd
add_file src/core/neorv32_cpu_control.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_control.vhd
add_file src/core/neorv32_cpu_cp_bitmanip.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_cp_bitmanip.vhd
add_file src/core/neorv32_cpu_cp_cfu.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_cp_cfu.vhd
add_file src/core/neorv32_cpu_cp_fpu.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_cp_fpu.vhd
add_file src/core/neorv32_cpu_cp_muldiv.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_cp_muldiv.vhd
add_file src/core/neorv32_cpu_cp_shifter.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_cp_shifter.vhd
add_file src/core/neorv32_cpu_decompressor.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_decompressor.vhd
add_file src/core/neorv32_cpu_lsu.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_lsu.vhd
add_file src/core/neorv32_cpu_pmp.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_pmp.vhd
add_file src/core/neorv32_cpu_regfile.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu_regfile.vhd
add_file src/core/neorv32_cpu.vhd
set_file_prop -lib neorv32 src/core/neorv32_cpu.vhd
add_file src/core/neorv32_crc.vhd
set_file_prop -lib neorv32 src/core/neorv32_crc.vhd
add_file src/core/neorv32_dcache.vhd
set_file_prop -lib neorv32 src/core/neorv32_dcache.vhd
add_file src/core/neorv32_debug_dm.vhd
set_file_prop -lib neorv32 src/core/neorv32_debug_dm.vhd
add_file src/core/neorv32_debug_dtm.vhd
set_file_prop -lib neorv32 src/core/neorv32_debug_dtm.vhd
add_file src/core/neorv32_dma.vhd
set_file_prop -lib neorv32 src/core/neorv32_dma.vhd
add_file src/core/neorv32_dmem.entity.vhd
set_file_prop -lib neorv32 src/core/neorv32_dmem.entity.vhd
add_file src/core/neorv32_fifo.vhd
set_file_prop -lib neorv32 src/core/neorv32_fifo.vhd
add_file src/core/neorv32_gpio.vhd
set_file_prop -lib neorv32 src/core/neorv32_gpio.vhd
add_file src/core/neorv32_gptmr.vhd
set_file_prop -lib neorv32 src/core/neorv32_gptmr.vhd
add_file src/core/neorv32_icache.vhd
set_file_prop -lib neorv32 src/core/neorv32_icache.vhd
add_file src/core/neorv32_imem.entity.vhd
set_file_prop -lib neorv32 src/core/neorv32_imem.entity.vhd
add_file src/core/neorv32_intercon.vhd
set_file_prop -lib neorv32 src/core/neorv32_intercon.vhd
add_file src/core/neorv32_mtime.vhd
set_file_prop -lib neorv32 src/core/neorv32_mtime.vhd
add_file src/core/neorv32_neoled.vhd
set_file_prop -lib neorv32 src/core/neorv32_neoled.vhd
add_file src/core/neorv32_onewire.vhd
set_file_prop -lib neorv32 src/core/neorv32_onewire.vhd
add_file src/core/neorv32_package.vhd
set_file_prop -lib neorv32 src/core/neorv32_package.vhd
add_file src/core/neorv32_pwm.vhd
set_file_prop -lib neorv32 src/core/neorv32_pwm.vhd
add_file src/core/neorv32_sdi.vhd
set_file_prop -lib neorv32 src/core/neorv32_sdi.vhd
add_file src/core/neorv32_slink.vhd
set_file_prop -lib neorv32 src/core/neorv32_slink.vhd
add_file src/core/neorv32_spi.vhd
set_file_prop -lib neorv32 src/core/neorv32_spi.vhd
add_file src/core/neorv32_sysinfo.vhd
set_file_prop -lib neorv32 src/core/neorv32_sysinfo.vhd
add_file src/core/neorv32_top.vhd
set_file_prop -lib neorv32 src/core/neorv32_top.vhd
add_file src/core/neorv32_trng.vhd
set_file_prop -lib neorv32 src/core/neorv32_trng.vhd
add_file src/core/neorv32_twi.vhd
set_file_prop -lib neorv32 src/core/neorv32_twi.vhd
add_file src/core/neorv32_uart.vhd
set_file_prop -lib neorv32 src/core/neorv32_uart.vhd
add_file src/core/neorv32_wdt.vhd
set_file_prop -lib neorv32 src/core/neorv32_wdt.vhd
add_file src/core/neorv32_wishbone.vhd
set_file_prop -lib neorv32 src/core/neorv32_wishbone.vhd
add_file src/core/neorv32_xip.vhd
set_file_prop -lib neorv32 src/core/neorv32_xip.vhd
add_file src/core/neorv32_xirq.vhd
set_file_prop -lib neorv32 src/core/neorv32_xirq.vhd
# core memory
add_file src/core/mem/neorv32_dmem.default.vhd
set_file_prop -lib neorv32 src/core/mem/neorv32_dmem.default.vhd
add_file src/core/mem/neorv32_imem.default.vhd
set_file_prop -lib neorv32 src/core/mem/neorv32_imem.default.vhd


# ddr and pll gowin IP
add_file src/ddr3_memory_interface/ddr3_memory_interface.vhd
set_file_prop -lib work src/ddr3_memory_interface/ddr3_memory_interface.vhd
add_file src/gowin_rpll/gowin_rpll.vhd
set_file_prop -lib work src/gowin_rpll/gowin_rpll.vhd


add_file src/neorv32_test_setup_bootloader.vhd
set_file_prop -lib work src/neorv32_test_setup_bootloader.vhd

# my changes
add_file src/top_module.vhd
set_file_prop -lib work src/top_module.vhd
add_file src/wishbone_mem.vhd
set_file_prop -lib work src/wishbone_mem.vhd


add_file src/project3_cpu.cst

# synthesis
run syn
run pnr
