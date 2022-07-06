# Variables
set PROJECT_NAME            def_prj
set DIR_OUTPUT              ../work

set COMMON_FILESET          src_common
set SIM_FILESET             src_sim

# Crate project directory
file mkdir $DIR_OUTPUT

# Crate project
create_project -force $PROJECT_NAME $DIR_OUTPUT/$PROJECT_NAME -part xc7k325tffg900-2
set_property board_part xilinx.com:kc705:part0:1.6 [current_project]

# add source
create_fileset $COMMON_FILESET
add_files -norecurse ../src/top.sv

read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/arith/arith.vhd           -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/srmmu/mmuconfig.vhd       -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/srmmu/mmuiface.vhd        -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/srmmu/libmmu.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/memctrl/memctrl.vhd       -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/misc/misc.vhd             -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/uart/uart.vhd             -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/uart/libdcom.vhd          -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/spi/spi.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/grdmac/grdmac_pkg.vhd     -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/i2c/i2c.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/i2c/i2cmst.vhd            -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/i2c/i2cslv.vhd            -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/net/net.vhd               -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/greth/ethernet_mac.vhd    -library gaisler
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/greth/greth.vhd           -library gaisler

read_vhdl -vhdl2008 ../../../grlib/lib/techmap/gencomp/gencomp.vhd       -library techmap
read_vhdl -vhdl2008 ../../../grlib/lib/techmap/gencomp/netcomp.vhd       -library techmap

read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/version.vhd          -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/config_types.vhd     -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/config.vhd           -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/stdlib.vhd           -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/stdio.vhd            -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/testlib.vhd          -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/util/util.vhd               -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/amba/amba.vhd               -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/amba/devices.vhd            -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/modgen/multlib.vhd          -library grlib

# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../src/tb.sv

set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui