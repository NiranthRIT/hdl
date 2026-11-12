# CPET-343 Lab 4. Run from this script folder or via simulate.bat.
# A clean library prevents a compile failure from running an old design.
onerror {quit -code 1 -f}
onbreak {quit -code 1 -f}
set script_dir [pwd]
cd $script_dir
if {[file exists work]} {file delete -force work}
vlib work
vmap work work
vcom -2008 ../../src/reset_synchronizer.vhd
vcom -2008 ../../src/synchronizer_3bit.vhd
vcom -2008 ../../src/rising_edge_synchronizer.vhd
vcom -2008 ../../src/generic_add_sub.vhd
vcom -2008 ../../src/seven_seg.vhd
vcom -2008 ../../src/add_sub.vhd
vcom -2008 ../src/add_sub_tb.vhd
vsim -voptargs=+acc work.add_sub_tb
set BreakOnAssertion 2
if {![batch_mode]} {do wave.do}
run -all
if {[examine /add_sub_tb/tests_done] ne "1"} {
  echo "ERROR: simulation did not reach tests_done=1"
  quit -code 1 -f
}
echo "PASS: Lab 4 testbench reached tests_done=1"
if {[batch_mode]} {quit -code 0 -f}
