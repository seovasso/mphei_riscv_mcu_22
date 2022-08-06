# Variables
set PROJECT_NAME            cnstr_prj
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
read_vhdl -vhdl2008 ../../../grlib/lib/gaisler/jtag/jtag.vhd             -library gaisler

read_vhdl -vhdl2008 ../../../grlib/lib/techmap/gencomp/gencomp.vhd       -library techmap
read_vhdl -vhdl2008 ../../../grlib/lib/techmap/gencomp/netcomp.vhd       -library techmap

read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/version.vhd          -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/config_types.vhd     -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/config.vhd           -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/stdlib/stdlib.vhd           -library grlib
read_vhdl           ../../../grlib/lib/grlib/stdlib/stdio.vhd            -library grlib
read_vhdl           ../../../grlib/lib/grlib/stdlib/testlib.vhd          -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/util/util.vhd               -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/amba/amba.vhd               -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/amba/devices.vhd            -library grlib
read_vhdl -vhdl2008 ../../../grlib/lib/grlib/modgen/multlib.vhd          -library grlib

read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/ahbctrl.vhd           -library grlib
read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/apbctrl.vhd           -library grlib
read_vhdl -vhdl2008  ../../../grlib/lib/grlib/amba/apbctrlx.vhd          -library grlib
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spictrl.vhd          -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/spi/spictrlx.vhd         -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/uart/apbuart.vhd         -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/grgpio.vhd          -library gaisler
read_vhdl -vhdl2008  ../../../grlib/lib/gaisler/misc/gptimer.vhd         -library gaisler

add_files -norecurse ../constraints/mpei_rv_core_cnstr_wrp.sv
read_vhdl -vhdl2008  ../src/core_const_pkg.vhd                           -library work
read_vhdl -vhdl2008  ../src/scr1_wrp.vhd                                 -library work  
read_vhdl -vhdl2008  ../constraints/mpei_rv_core_cnstr.vhd               -library work  

add_files -norecurse ../../../scr1/src/top/scr1_dmem_router.sv
add_files -norecurse ../../../scr1/src/top/scr1_imem_router.sv
add_files -norecurse ../../../scr1/src/top/scr1_dp_memory.sv
add_files -norecurse ../../../scr1/src/top/scr1_tcm.sv
add_files -norecurse ../../../scr1/src/top/scr1_timer.sv
add_files -norecurse ../../../scr1/src/top/scr1_dmem_ahb.sv
add_files -norecurse ../../../scr1/src/top/scr1_imem_ahb.sv
add_files -norecurse ../../../scr1/src/top/scr1_top_ahb.sv

add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_hdu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_tdu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_ipic.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_csr.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_exu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_ialu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_idu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_ifu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_lsu.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_mprf.sv
add_files -norecurse ../../../scr1/src/core/pipeline/scr1_pipe_top.sv
add_files -norecurse ../../../scr1/src/core/primitives/scr1_reset_cells.sv
add_files -norecurse ../../../scr1/src/core/primitives/scr1_cg.sv
add_files -norecurse ../../../scr1/src/core/scr1_clk_ctrl.sv
add_files -norecurse ../../../scr1/src/core/scr1_tapc_shift_reg.sv
add_files -norecurse ../../../scr1/src/core/scr1_tapc.sv
add_files -norecurse ../../../scr1/src/core/scr1_tapc_synchronizer.sv
add_files -norecurse ../../../scr1/src/core/scr1_core_top.sv
add_files -norecurse ../../../scr1/src/core/scr1_dm.sv
add_files -norecurse ../../../scr1/src/core/scr1_dmi.sv
add_files -norecurse ../../../scr1/src/core/scr1_scu.sv

add_files -norecurse ../../../scr1/src/includes/scr1_ahb.svh
add_files -norecurse ../../../scr1/src/includes/scr1_arch_description.svh
add_files -norecurse ../../../scr1/src/includes/scr1_arch_types.svh
add_files -norecurse ../../../scr1/src/includes/scr1_csr.svh
add_files -norecurse ../../../scr1/src/includes/scr1_dm.svh
add_files -norecurse ../../../scr1/src/includes/scr1_hdu.svh
add_files -norecurse ../../../scr1/src/includes/scr1_ipic.svh
add_files -norecurse ../../../scr1/src/includes/scr1_memif.svh
add_files -norecurse ../../../scr1/src/includes/scr1_riscv_isa_decoding.svh
add_files -norecurse ../../../scr1/src/includes/scr1_scu.svh
add_files -norecurse ../../../scr1/src/includes/scr1_search_ms1.svh
add_files -norecurse ../../../scr1/src/includes/scr1_tapc.svh
add_files -norecurse ../../../scr1/src/includes/scr1_tdu.svh

# add simulation source
create_fileset $SIM_FILESET
add_files -norecurse ../constraints/tb_mpei_rv_core_cnstr_wrp.sv
add_files -norecurse ../../../sim/apb_if.sv

set_property top tb_mpei_rv_core_cnstr_wrp [get_filesets sim_1]
# set_property top spictr [get_filesets sim_1]

# launch simulation
launch_simulation
start_gui
