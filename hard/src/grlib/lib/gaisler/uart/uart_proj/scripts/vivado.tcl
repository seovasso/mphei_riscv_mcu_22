# Variables
set PROJECT_NAME            uart_prj
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


read_vhdl -vhdl2008 ../../uart.vhd             	    -library gaisler
read_vhdl -vhdl2008 ../../apbuart.vhd          	    -library gaisler

read_vhdl -vhdl2008 ../../../../grlib/stdlib/version.vhd         -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config_types.vhd    -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/stdlib.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/amba.vhd              -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/devices.vhd           -library grlib


# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../src/tb.sv
add_files -norecurse ../../../../../../sim/apb_if.sv

set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui