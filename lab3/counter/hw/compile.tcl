# Lab 3 counter. Derived from the professor's blink compile script.
cd [file dirname [file normalize [info script]]]
file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
set project_name counter
project_new $project_name
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files
set_global_assignment -name VHDL_FILE ../../../generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../../generic_adder_beh.vhd
set_global_assignment -name VHDL_FILE ../../../shared/src/seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd
set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AE26 -to {seven_seg_out[0]}
set_location_assignment PIN_AE27 -to {seven_seg_out[1]}
set_location_assignment PIN_AE28 -to {seven_seg_out[2]}
set_location_assignment PIN_AG27 -to {seven_seg_out[3]}
set_location_assignment PIN_AF28 -to {seven_seg_out[4]}
set_location_assignment PIN_AG28 -to {seven_seg_out[5]}
set_location_assignment PIN_AH28 -to {seven_seg_out[6]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {*}
set_global_assignment -name SDC_FILE ../clock.sdc
execute_flow -compile
project_close
