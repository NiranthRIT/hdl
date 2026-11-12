# Launch from sim/script; open_waves.bat selects this directory.
set script_dir [file normalize [pwd]]
cd $script_dir
do compile.do
do wave.do
run -all
if {[string tolower [examine /add_sub_state_machine_tb/done]] ne "true"} {quit -f -code 1}
