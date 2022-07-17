# Variables
set PROJECT_NAME def_prj
set DIR_OUTPUT ../work

set COMMON_FILESET src_common
set SIM_FILESET src_sim

# Crate project directory
file mkdir $DIR_OUTPUT

# Crate project
create_project -force $PROJECT_NAME $DIR_OUTPUT/$PROJECT_NAME -part xc7k325tffg900-2
set_property board_part xilinx.com:kc705:part0:1.6 [current_project]

# add source
create_fileset $COMMON_FILESET
add_files -norecurse ../src/top.sv

read_vhdl -vhdl2008 ../../misc.vhd             -library gaisler

read_vhdl -vhdl2008 ../../../../techmap/gencomp/gencomp.vhd       -library techmap

read_vhdl -vhdl2008 ../../../../grlib/stdlib/version.vhd          -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config_types.vhd     -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/config.vhd           -library grlib
read_vhdl -vhdl2008 ../../../../grlib/stdlib/stdlib.vhd           -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/amba.vhd               -library grlib
read_vhdl -vhdl2008 ../../../../grlib/amba/devices.vhd            -library grlib
add_files -norecurse ../../../../../../sim/apb_if.sv
read_vhdl -vhdl2008 ../../grgpio.vhd    -library work
# add simulation source

add_files -norecurse ../src/tb.sv
read_vhdl -vhdl2008 ../grgpio_wrp.vhd   -library work
read_vhdl -vhdl2008 ../spi2ahb_wrp.vhd   -library work

set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui