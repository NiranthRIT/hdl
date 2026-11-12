# Lab 5. Stop on compilation/runtime errors instead of ignoring them.
onerror {quit -f -code 1}
onbreak {quit -f -code 1}
set BreakOnAssertion 2
# Launch from sim/script; simulate.bat and open_waves.bat select this directory.
set script_dir [file normalize [pwd]]
cd $script_dir
if {![file exists work]} {vlib work}
vmap work work
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/generic_add_sub.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/add_sub_state_machine.vhd
vcom -93 -work work ../src/add_sub_state_machine_tb.vhd
vsim -voptargs=+acc work.add_sub_state_machine_tb
