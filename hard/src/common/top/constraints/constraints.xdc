
create_clock -period 10.000 -name sys_clk_i   [get_ports clk_i      ]
create_clock -period 40.000 -name sys_clk_div [get_pin   clk_w_reg[1]/Q]
create_clock -period 40.000 -name jtag_clk    [get_ports jtag_tck   ]

# Set two clocks as asynchronous
set_clock_groups -asynchronous -group sys_clk_i -group sys_clk_div -group jtag_clk

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_IBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_i_IBUF   ]

# CONTROL interface
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP37} [get_ports clk_i            ]
set_property -dict {IOSTANDARD LVCMOS15 PACKAGE_PIN AP18} [get_ports rstn_i           ]
      
# JATG interface      
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AK32} [get_ports jtag_tdi         ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AJ32} [get_ports jtag_tms         ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AK33} [get_ports jtag_tck         ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AJ33} [get_ports jtag_tdo         ]

# # SPI interface
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP42} [get_ports gpio_inout[0]    ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN40} [get_ports gpio_inout[1]    ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN41} [get_ports gpio_inout[2]    ]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP42} [get_ports spi_in_miso      ]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN40} [get_ports spi_out_mosi     ]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN41} [get_ports spi_out_sck      ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AL32} [get_ports spi_out_slvsel   ]
    
# UART interface    
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AY40} [get_ports uart_in_rxd      ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AY39} [get_ports uart_out_txd     ]
    
# GPIO interface    
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AR40} [get_ports gpio_inout[0]    ]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AR42} [get_ports gpio_inout[1]    ]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP40} [get_ports gpio_inout[2]    ]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP41} [get_ports gpio_inout[3]    ]

# TIMER interface
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AT39} [get_ports timr_out_one_tick]
