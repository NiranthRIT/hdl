create_clock -name clk -period 20.000 [get_ports {clk}]
# Switches and button are asynchronous board inputs. Their first flops are CDC.
# Check Quartus timing and CDC reports for the target build.
