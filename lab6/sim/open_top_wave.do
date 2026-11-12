onerror {quit -code 1 -f}
onbreak {quit -code 1 -f}
set BreakOnAssertion 2
vsim -voptargs=+acc work.top_tb
add wave -r /top_tb/*
run -all
if {[string tolower [string trim [examine sim:/top_tb/done]]] ni {true 1}} {
  puts stderr "FAIL top_tb did not complete"
  quit -code 1 -f
}
wave zoom full
