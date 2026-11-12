onerror {quit -code 1 -f}
onbreak {quit -code 1 -f}
set BreakOnAssertion 2
# Launch ModelSim from this folder before running do sim.do.
set script_dir [file normalize [pwd]]
cd $script_dir
set libdir [file join $script_dir work_[pid]_[clock seconds]]
vlib $libdir
vmap work $libdir
vcom -93 -work work {../../../generic_adder_beh.vhd}
vcom -93 -work work {../../../generic_counter.vhd}
vcom -93 -work work {../../../shared/src/seven_seg.vhd}
vcom -93 -work work {../../src/top.vhd}
vcom -93 -work work {../src/counter_tb.vhd}
vsim -voptargs=+acc work.counter_tb
if {![batch_mode]} {do wave.do}
onerror {quit -code 1 -f}
run 3 us
if {[string trim [examine /counter_tb/test_complete] {'" }] ne "1"} {error "Test did not complete"}
