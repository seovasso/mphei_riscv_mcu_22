# Variables
set PROJECT_NAME def_prj
set DIR_OUTPUT ../work

set COMMON_FILESET src_common
set SIM_FILESET src_sim

# Crate project directory
file mkdir $DIR_OUTPUT

# Crate project
create_project -force $PROJECT_NAME $DIR_OUTPUT/$PROJECT_NAME -part xc7v585tffg1761-1
set_property board_part xilinx.com:kc705:part0:1.6 [current_project]

# add source
create_fileset $COMMON_FILESET
add_files -norecurse ../src/top.sv

read_vhdl -vhdl2008 ../../../../gaisler/arith/arith.vhd           -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/srmmu/mmuconfig.vhd       -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/srmmu/mmuiface.vhd        -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/srmmu/libmmu.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/memctrl/memctrl.vhd       -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/misc/misc.vhd             -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/uart/uart.vhd             -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/uart/libdcom.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/spi/spi.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/grdmac/grdmac_pkg.vhd     -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/i2c/i2c.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/i2c/i2cmst.vhd            -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/i2c/i2cslv.vhd            -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/net/net.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/greth/ethernet_mac.vhd    -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/greth/greth.vhd           -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/jtag/jtag.vhd             -library gaisler

read_vhdl -vhdl2008 ../../../../techmap/gencomp/gencomp.vhd       -library techmap
read_vhdl -vhdl2008 ../../../../techmap/gencomp/netcomp.vhd       -library techmap

read_vhdl -vhdl2008 ../../../../grlib/stdlib/version.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config_types.vhd     -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config.vhd           -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/stdlib.vhd           -library grlib
read_vhdl           ../../../../grlib/stdlib/stdio.vhd            -library grlib
read_vhdl           ../../../../grlib/stdlib/testlib.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../grlib/util/util.vhd               -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/amba.vhd               -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/devices.vhd            -library grlib
read_vhdl -vhdl2008 ../../../../grlib/modgen/multlib.vhd          -library grlib

read_vhdl -vhdl2008 ../../../../grlib/amba/ahbctrl.vhd           -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/apbctrl.vhd           -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/apbctrlx.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../gaisler/spi/spictrl.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/spi/spictrlx.vhd         -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/uart/apbuart.vhd         -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/misc/grgpio.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../../gaisler/misc/gptimer.vhd         -library gaisler
add_files -norecurse ../../../../../../sim/apb_if.sv
# add simulation source

add_files -norecurse ../src/tb.sv
#read_vhdl -vhdl2008 ../grgpio_wrp.vhd   -library work

set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui