# DE1-SoC 50 MHz oscillator.
create_clock -name clk -period 20.000 [get_ports {clk}]
derive_clock_uncertainty
