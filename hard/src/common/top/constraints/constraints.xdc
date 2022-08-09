
create_clock -period 10.000 -name sys_clk [get_ports clk_i]
create_clock -period 40.000 -name jtag_clk [get_ports jtag_tck]

# Set two clocks as asynchronous
set_clock_groups -asynchronous -group sys_clk -group jtag_clk

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_IBUF]

set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP37} [get_ports clk_i]
set_property -dict {IOSTANDARD LVCMOS15 PACKAGE_PIN AP18} [get_ports rstn_i]

set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AL32} [get_ports jtag_tck]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AJ33} [get_ports jtag_tms]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AK33} [get_ports jtag_tdi]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN40} [get_ports jtag_tdo]

set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AY40} [get_ports uart_in_rxd]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AY39} [get_ports uart_out_txd]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_i_IBUF]
