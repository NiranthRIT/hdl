onerror {quit -f -code 1}
quietly WaveActivateNextPane {} 0
add wave /add_sub_state_machine_tb/clk
add wave /add_sub_state_machine_tb/reset
add wave /add_sub_state_machine_tb/btn
add wave -radix unsigned /add_sub_state_machine_tb/test_number
add wave -radix unsigned /add_sub_state_machine_tb/test_a
add wave -radix unsigned /add_sub_state_machine_tb/test_b
add wave -radix unsigned /add_sub_state_machine_tb/switch
add wave /add_sub_state_machine_tb/uut/reset_sync
add wave -radix unsigned /add_sub_state_machine_tb/uut/switch_sync
add wave /add_sub_state_machine_tb/uut/button_pulse
add wave /add_sub_state_machine_tb/uut/state
add wave -radix unsigned /add_sub_state_machine_tb/uut/a
add wave -radix unsigned /add_sub_state_machine_tb/uut/b
add wave -radix unsigned /add_sub_state_machine_tb/uut/result
add wave -radix unsigned /add_sub_state_machine_tb/uut/display_value
add wave -radix unsigned /add_sub_state_machine_tb/uut/ones
add wave -radix unsigned /add_sub_state_machine_tb/uut/tens
add wave -radix unsigned /add_sub_state_machine_tb/uut/hundreds
add wave -radix binary /add_sub_state_machine_tb/led
configure wave -timelineunits ns
update
wave zoom full
