---------------------------------------------------------
-- Прим.: Подключаем библиотеки Gaisler'а
---------------------------------------------------------

library grlib;
use grlib.stdlib.all;
use grlib.amba.all;
use grlib.stdlib.conv_std_logic_vector;

library gaisler;
use gaisler.misc.all;
use gaisler.uart.all;
use gaisler.net.all;
use gaisler.jtag.all;
use gaisler.spi.all;

---------------------------------------------------------
-- Прим.: самописные библиотеки
---------------------------------------------------------

library work;
use work.core_const_pkg.all;		-- библиотека в которой будут храниться все параметры ( например кол-во мастеров и слейвов у AHBCTRL/APBCTRL )

entity mpei_rv_core is
generic (
  ---------------------------------------------------------
  -- Прим.: Здесь перечисляем параметры, которые передаются с 
  -- верхнего уровня иерархии ( Если таких параметров нет,
  --  то необходимо удалить весь generic )
  ---------------------------------------------------------
);
port(
  clk_i,
  rstn_i
  
  ---------------------------------------------------------
  -- Прим.: Здесь перечисляем порты, которые передаются с/в
  -- верхний уровень иерархии
  ---------------------------------------------------------
);
end mpei_rv_core;

architecture mpei_rv_core_arc of mpei_rv_core is

---------------------------------------------------------
-- Прим.: После architecture объявляются сигналы и компоненты для модулей
---------------------------------------------------------

signal ahbmi          : ahb_mst_in_vector;
signal ahbmo          : ahb_mst_out_vector := (others => ahbm_none);

signal ahbsi          : ahb_slv_in_vector;
signal ahbso          : ahb_slv_out_vector := (others => ahbs_none);

signal apbi           : apb_slv_in_type;
signal apbo           : apb_slv_out_vector := (others => apb_none);

begin

---------------------------------------------------------
-- Прим.: После begin  подключаются модули
---------------------------------------------------------

------------------------------------------------------------------------------------
--                                SCR1_WRP                                        --
------------------------------------------------------------------------------------
-- Подключить аналогично AHBCTRL/APBCTRL
u_scr1_wrp : entity work.scr1_wrp
port map(
   ahbi            => ahbmi(INDEX_AHBM_CPU) ,                -- in  ahb_mst_in_type;
   ahbo            => ahbmo(INDEX_AHBM_CPU)                  -- out ahb_mst_out_type
);

------------------------------------------------------------------------------------
--                                AHBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/ahbctrl.vhd 
u_ahbctrl : entity work.ahbctrl 
generic map (
  defmast     => , -- integer := 0;                          -- default master
  split       => , -- integer := 0;                          -- split support
  rrobin      => , -- integer := 0;                          -- round-robin arbitration
  timeout     => , -- integer range 0 to 255 := 0;           -- HREADY timeout
  ioaddr      => , -- ahb_addr_type := 16#fff#;              -- I/O area MSB address
  iomask      => , -- ahb_addr_type := 16#fff#;              -- I/O area address mask
  cfgaddr     => , -- ahb_addr_type := 16#ff0#;              -- config area MSB address
  cfgmask     => , -- ahb_addr_type := 16#ff0#;              -- config area address mask
  nahbm       => , -- integer range 1 to NAHBMST := NAHBMST; -- number of masters
  nahbs       => , -- integer range 1 to NAHBSLV := NAHBSLV; -- number of slaves
  ioen        => , -- integer range 0 to 15 := 1;            -- enable I/O area
  disirq      => , -- integer range 0 to 1 := 0;             -- disable interrupt routing
  fixbrst     => , -- integer range 0 to 1 := 0;             -- support fix-length bursts
  debug       => , -- integer range 0 to 2 := 2;             -- report cores to console
  fpnpen      => , -- integer range 0 to 1 := 0;             -- full PnP configuration decoding
  icheck      => , -- integer range 0 to 1 := 1;
  devid       => , -- integer := 0;                          -- unique device ID
  enbusmon    => , -- integer range 0 to 1 := 0;             --enable bus monitor
  assertwarn  => , -- integer range 0 to 1 := 0;             --enable assertions for warnings
  asserterr   => , -- integer range 0 to 1 := 0;             --enable assertions for errors
  hmstdisable => , -- integer := 0;                          --disable master checks
  hslvdisable => , -- integer := 0;                          --disable slave checks
  arbdisable  => , -- integer := 0;                          --disable arbiter checks
  mprio       => , -- integer := 0;                          --master with highest priority
  mcheck      => , -- integer range 0 to 2 := 1;             --check memory map for intersects
  ccheck      => , -- integer range 0 to 1 := 1;             --perform sanity checks on pnp config
  acdm        => , -- integer := 0;                          --AMBA compliant data muxing (for hsize > word)
  index       => , -- integer := 0;                          --Index for trace print-out
  ahbtrace    => , -- integer := 0;                          --AHB trace enable
  hwdebug     => , -- integer := 0;                          --Hardware debug
  fourgslv    => , -- integer := 0;                          --1=Single slave with single 4 GB bar
  shadow      => , -- integer range 0 to 1 := 0;             -- Allow memory area shadowing
  unmapslv    => , -- integer := 0;                          -- to redirect unmapped areas to slave, set to 256+bar*32+slv
  ahbendian   => , -- integer := GRLIB_ENDIAN
) port map (
  rst         => , -- in  std_ulogic;
  clk         => , -- in  std_ulogic;
  
  msti        => ahbmi, -- out ahb_mst_in_type;              -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
  msto        => ahbmo, -- in  ahb_mst_out_vector;		       -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
  
  slvi        => ahbsi, -- out ahb_slv_in_type;              -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL) 
  slvo        => ahbso, -- in  ahb_slv_out_vector;           -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL)
  
  testen      => , -- in  std_ulogic := '0';
  testrst     => , -- in  std_ulogic := '1';
  scanen      => , -- in  std_ulogic := '0';
  testoen     => , -- in  std_ulogic := '1';
  testsig     =>   -- in  std_logic_vector(1+GRLIB_CONFIG_ARRAY(grlib_techmap_testin_extra) downto 0) := (others => '0')
);

------------------------------------------------------------------------------------
--                                APBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/apbctrl.vhd 
u_apbctrl : entity work.apbctrl
generic map (
  hindex      => INDEX_AHBS_AHB2APB,        -- integer := 0;                           -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  haddr       => ADDR_APBCTRL,              -- integer := 0;                           -- значение ADDR_APBCTRL см. в библиотеке core_const_pkg
  hmask       => 16#fff#,                   -- integer := 16#fff#;
  nslaves     => INDEX_APB_ALL,             -- integer range 1 to NAPBSLV := NAPBSLV;  -- значение INDEX_APB_ALL см. в библиотеке core_const_pkg
  debug       => 2,                         -- integer range 0 to 2 := 2;
  icheck      => 1,                         -- integer range 0 to 1 := 1;
  enbusmon    => 0,                         -- integer range 0 to 1 := 0;
  asserterr   => 0,                         -- integer range 0 to 1 := 0;
  assertwarn  => 0,                         -- integer range 0 to 1 := 0;
  pslvdisable => 0,                         -- integer := 0;
  mcheck      => 1,                         -- integer range 0 to 1 := 1;
  ccheck      => 1                          -- integer range 0 to 1 := 1
) port map (
  rst         => ,                          -- in  std_ulogic;
  clk         => ,                          -- in  std_ulogic;
  
  ahbi        => ahbsi(INDEX_AHBS_AHB2APB), -- in  ahb_slv_in_type;                  -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  ahbo        => ahbso(INDEX_AHBS_AHB2APB), -- out ahb_slv_out_type;                 -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  
  apbi        => apbi,                      -- out apb_slv_in_type;                  -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
  apbo        => apbo                       -- in  apb_slv_out_vector                -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
);

------------------------------------------------------------------------------------
--                                SPICTRL                                         --
------------------------------------------------------------------------------------
-- Подключить аналогично GPIO

------------------------------------------------------------------------------------
--                                APBUART                                         --
------------------------------------------------------------------------------------
-- Подключить аналогично GPIO

------------------------------------------------------------------------------------
--                                GPIO                                            --
------------------------------------------------------------------------------------
-- исходник лежит здесь -  mphei_riscv_mcu_22/hard/src/grlib/lib/gaisler/misc/grgpio.vhd 
u_grgpio : entity work.grgpio
generic map (
  pindex   => INDEX_APB_GPIO   ,
  paddr    => INDEX_APB_GPIO*16,
  pmask    => 16#fff#          ,
  imask    => 16#7FFFFFFF#     , -- Mask for interrupts
  nbits    => 32               , -- GPIO bits
  oepol    => 1                , -- Output enable polarity
  syncrst  => 0                , -- Only synchronous reset
  bypass   => 16#7FFFFFFF#     , -- alternative functions
  scantest => 0                ,
  bpdir    => 0                ,
  pirq     => 0                , -- not used
  irqgen   => 1                ,
  iflagreg => 1                ,
  bpmode   => 1                ,
  inpen    => 1                ,
  doutresv => 0                ,
  dirresv  => 0                ,
  bpresv   => 0                ,
  inpresv  => 0                ,
  pulse    => 0                    
) port map (
  arst     =>                        , --in  std_ulogic;
  rst      =>                        , --in  std_ulogic;
  clk      =>                        , --in  std_ulogic;
  apbi     => apbi                   , --in  apb_slv_in_type;
  apbo     => apbo(INDEX_APB_GPIO)   , --out apb_slv_out_type;                          -- значение INDEX_APB_GPIO см. в библиотеке core_const_pkg
  gpioi    =>                        , --in  gpio_in_i_type;
  gpioo    =>                          --out gpio_out_type
);

------------------------------------------------------------------------------------
--                                GRTIMER                                         --
------------------------------------------------------------------------------------
component grtimer is
  generic (
    pindex:           Integer := 0;
    paddr:            Integer := 0;
    pmask:            Integer := 16#fff#;
    pirq:             Integer := 1;
    sepirq:           Integer := 1;                 -- separate interrupts
    sbits:            Integer := 10;                -- scaler bits
    ntimers:          Integer range 1 to 7 := 2;    -- number of timers
    nbits:            Integer := 32;                -- timer bits
    wdog:             Integer := 0;
    glatch:           Integer := 0;
    gextclk:          Integer := 0;
    gset:             Integer := 0);
  port (
    rst:        in    Std_ULogic;
    clk:        in    Std_ULogic;
    apbi:       in    apb_slv_in_type;
    apbo:       out   apb_slv_out_type;
    gpti:       in    gptimer_in_type;
    gpto:       out   gptimer_out_type);
end component;


end mpei_rv_core_arc;
