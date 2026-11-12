# Match the handout's readable operands, controls and red BCD displays.
radix define BCD {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    "7'b0001000" "A" -color "red",
    "7'b0000011" "b" -color "red",
    "7'b1000110" "C" -color "red",
    "7'b0100001" "d" -color "red",
    "7'b0000110" "E" -color "red",
    "7'b0001110" "F" -color "red",
    -default default
}
add wave -color Green /add_sub_tb/clk /add_sub_tb/reset
add wave -radix unsigned -color Yellow /add_sub_tb/a /add_sub_tb/dut/a_sync
add wave -radix unsigned -color Cyan /add_sub_tb/b /add_sub_tb/dut/b_sync
add wave -radix unsigned /add_sub_tb/dut/result
add wave -color Yellow /add_sub_tb/add_btn /add_sub_tb/dut/add_sync /add_sub_tb/dut/add_en
add wave -color Cyan /add_sub_tb/sub_btn /add_sub_tb/dut/sub_sync /add_sub_tb/dut/sub_en
add wave /add_sub_tb/dut/subtract
add wave -radix BCD -color Red /add_sub_tb/a_bcd /add_sub_tb/b_bcd /add_sub_tb/result_bcd
configure wave -timelineunits ns
wave zoom full
