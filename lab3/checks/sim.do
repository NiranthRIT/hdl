onerror {quit -code 1 -f}
onbreak {quit -code 1 -f}
set BreakOnAssertion 2
# Launch ModelSim from this folder before running do sim.do.
set script_dir [file normalize [pwd]]
cd $script_dir
set libdir [file join $script_dir work_[pid]_[clock seconds]]
vlib $libdir
vmap work $libdir
vcom -93 -work work ../blink/src/blink.vhd
vcom -93 -work work ../generic_counter.vhd
vcom -93 -work work ../generic_adder_beh.vhd
vcom -93 -work work ../shared/src/seven_seg.vhd
vcom -93 -work work ../counter/src/top.vhd
vcom -93 -work work blink_checks_tb.vhd
vcom -93 -work work seven_seg_checks_tb.vhd
vcom -93 -work work ../counter/sim/src/counter_tb.vhd
vsim -voptargs=+acc work.blink_checks_tb
run 500 ns
if {[string trim [examine /blink_checks_tb/test_complete] {'" }] ne "1"} {error "Blink checks did not complete"}
quit -sim
vsim -voptargs=+acc work.seven_seg_checks_tb
run 500 ns
if {[string trim [examine /seven_seg_checks_tb/test_complete] {'" }] ne "1"} {error "BCD checks did not complete"}
quit -sim
vsim -voptargs=+acc work.counter_tb
run 3 us
if {[string trim [examine /counter_tb/test_complete] {'" }] ne "1"} {error "Counter checks did not complete"}
