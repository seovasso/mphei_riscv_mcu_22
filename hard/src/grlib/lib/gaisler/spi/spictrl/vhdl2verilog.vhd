library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library techmap;
use techmap.gencomp.all;
use techmap.netcomp.all;
library grlib;
use grlib.amba.all;
use grlib.devices.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.spi.all;

entity vhdl2verilog is

    port(
    rstn   : in std_ulogic;
    clk    : in std_ulogic;


