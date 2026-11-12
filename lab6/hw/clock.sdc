create_clock -name clk -period 20.000 [get_ports {clk}]
# Switches and pushbuttons enter only through two-flop synchronizers.
set_false_path -from [get_ports {reset_n execute switch[*] op[*]}]
derive_clock_uncertainty
