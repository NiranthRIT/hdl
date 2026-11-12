onerror {quit -code 1 -f}
set BreakOnAssertion 2
onbreak {quit -code 1 -f}
if {[file exists work]} {vdel -lib work -all}
vlib work
vmap work work
vcom -2008 ../src/seven_seg.vhd ../src/synchronizer_8bit.vhd ../src/rising_edge_synchronizer.vhd ../src/double_dabble.vhd ../src/memory.vhd ../src/alu.vhd ../src/components.vhd ../src/calculator.vhd ../src/top.vhd src/alu_tb.vhd src/memory_bcd_tb.vhd src/top_tb.vhd
foreach tb {alu_tb memory_bcd_tb top_tb} {
  vsim -voptargs=+acc work.$tb
  run -all
  set complete [string tolower [string trim [examine sim:/$tb/done]]]
  if {$complete ni {true 1}} {
    puts stderr "FAIL $tb did not reach its actual completion signal"
    quit -code 1 -f
  }
  puts "VERIFIED $tb completion signal"
  quit -sim
}
quit -code 0 -f
