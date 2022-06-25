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

# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../src/tb.sv

set_property top tb [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui