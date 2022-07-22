library ieee;
use ieee.std_logic_1164.all;

package core_const_pkg is

  ------------------------------------------------------------------------------------
  --                            List AHB bus masters/slaves
  ------------------------------------------------------------------------------------
  constant INDEX_AHBM_CPU_DMEM        : integer    := 0;
  constant INDEX_AHBM_CPU_IMEM        : integer    := 1;
  constant INDEX_AHBM_ALL             : integer    := 2;

  constant INDEX_AHBS_AHB2APB         : integer    := 0;
  constant INDEX_AHBS_ALL             : integer    := 1;
  
  ------------------------------------------------------------------------------------
  --                            List APB bus masters/slaves
  ------------------------------------------------------------------------------------
  constant ADDR_APBCTRL               : integer    := 16#200#;
  constant INDEX_APB_SPICTRL          : integer    := 0;
  constant INDEX_APB_APBUART          : integer    := 1;
  constant INDEX_APB_GPIO             : integer    := 2;
  constant INDEX_APB_GRTIMER          : integer    := 3;
  constant INDEX_APB_ALL              : integer    := 4;

end package core_const_pkg;