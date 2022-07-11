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
  
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/stdlib/version.vhd         -library grlib 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/stdlib/config_types.vhd    -library grlib 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/stdlib/config.vhd          -library grlib 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/stdlib/stdlib.vhd          -library grlib 
read_vhdl -vhdl2008    -library grlib ../../../grlib/lib/grlib/stdlib/stdio.vhd 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/stdlib/testlib.vhd         -library grlib 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/util/util.vhd              -library grlib 
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/amba/amba.vhd              -library grlib     
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/amba/devices.vhd           -library grlib     
read_vhdl -vhdl2008    ../../../grlib/lib/grlib/modgen/multlib.vhd         -library grlib 

read_vhdl -vhdl2008    ../../../grlib/lib/techmap/gencomp/gencomp.vhd      -library techmap
read_vhdl -vhdl2008    ../../../grlib/lib/techmap/gencomp/netcomp.vhd      -library techmap
read_vhdl -vhdl2008    ../../../grlib/lib/techmap/maps/techbuf.vhd         -library techmap   
read_vhdl -vhdl2008    ../../../grlib/lib/techmap/maps/grgates.vhd         -library techmap   
read_vhdl -vhdl2008    ../../../grlib/lib/techmap/maps/tap.vhd             -library techmap   
  
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/axi/axi.vhd                -library gaisler    
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/misc.vhd              -library gaisler  
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/uart.vhd              -library gaisler  
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/libdcom.vhd           -library gaisler    
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/net/net.vhd                -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/greth/ethernet_mac.vhd     -library gaisler    
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/greth/greth.vhd            -library gaisler     
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/jtag/jtag.vhd              -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/jtag/libjtagcom.vhd        -library gaisler        
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/jtag/jtagtst.vhd           -library gaisler        
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/jtag/jtagcom2.vhd          -library gaisler        
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spi.vhd                -library gaisler        

read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/ahbctrl.vhd             -library work
read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/apbctrl.vhd             -library work
read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/apbctrlx.vhd            -library work
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spictrl.vhd            -library work
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spictrlx.vhd           -library work
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/apbuart.vhd           -library work
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/grgpio.vhd            -library work
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/gptimer.vhd           -library work

add_files -norecurse ../src/mpei_rv_core_wrp.sv
read_vhdl -vhdl2008  ../src/core_const_pkg.vhd                             -library work
read_vhdl -vhdl2008  ../src/scr1_wrp.vhd                                   -library work  
read_vhdl -vhdl2008  ../src/mpei_rv_core.vhd                               -library work  


# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../src/tb_mpei_rv_core_wrp.sv
add_files -norecurse ../../../sim/apb_if.sv

# set_property top tb_mpei_rv_core_wrp [get_filesets sim_1]
set_property top spictr [get_filesets sim_1]


# launch simulation
launch_simulation
start_gui

# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/version.vhd          -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/config_types.vhd     -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/config.vhd           -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/stdlib.vhd           -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/stdio.vhd            -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/stdlib/testlib.vhd          -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/util/util.vhd               -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/amba.vhd               -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/devices.vhd            -library grlib
# read_vhdl -vhdl2008  ../../../grlib/lib/grlib/modgen/multlib.vhd          -library grlib

# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/arith/arith.vhd           -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/srmmu/mmuconfig.vhd       -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/srmmu/mmuiface.vhd        -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/srmmu/libmmu.vhd          -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/memctrl/memctrl.vhd       -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/misc.vhd             -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/uart.vhd             -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/libdcom.vhd          -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spi.vhd               -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/grdmac/grdmac_pkg.vhd     -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/i2c/i2c.vhd               -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/i2c/i2cmst.vhd            -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/i2c/i2cslv.vhd            -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/net/net.vhd               -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/greth/ethernet_mac.vhd    -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/greth/greth.vhd           -library gaisler
# read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/jtag/jtag.vhd             -library gaisler
 
# read_vhdl -vhdl2008  ../../../grlib/lib/techmap/gencomp/gencomp.vhd       -library techmap
# read_vhdl -vhdl2008  ../../../grlib/lib/techmap/gencomp/netcomp.vhd       -library techmap

# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/greth_pkg.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/eth_rstgen.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/eth_edcl_ahb_mst.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/eth_ahb_mst.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/greth_tx.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/greth_rx.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/core/grethc.vhd
# read_vhdl -vhdl2008    ../../../src/ip_library/Leon3/leon/eth/comp/ethcomp.vhd
