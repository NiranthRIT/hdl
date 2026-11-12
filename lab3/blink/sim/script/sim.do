onerror {quit -code 1 -force}
vlib work_blink
vmap work_blink work_blink
vcom -93 -work work_blink ../../src/blink.vhd
vcom -93 -work work_blink ../src/blink_tb.vhd
vsim -voptargs=+acc -wlf blink.wlf work_blink.blink_tb
vcd file blink.vcd
vcd add -r /blink_tb/*
do wave.do
run 500 ns
vcd flush
