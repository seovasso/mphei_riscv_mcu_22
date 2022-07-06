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

library work;
use work.core_const_pkg.all;		-- библиотека в которой будут храниться все параметры ( например кол-во мастеров и слейвов у AHBCTRL/APBCTRL )

entity mpei_rv_core is
--generic (
--);
port(
  clk_i  : in std_ulogic;
  rstn_i : in std_ulogic;

  --       SCR1_WRP  
  -- what have to output? JTAG, IQR, Fuses, control pin?

  --       SPICTRL   
  spii   : in  spi_in_type;
  spio   : out spi_out_type;
  slvsel : out std_logic_vector((slvselsz-1) downto 0);
                          
  --       APBURT 
  uarti  : in  uart_in_type;
  uarto  : out uart_out_type;

  --       GPIO 
  gpioi  : in  gpio_in_i_type;
  gpioo  : out gpio_out_type;

  --       GRTIMER 
  gpti   : in  gptimer_in_type;
  gpto   : out gptimer_out_type
);
end mpei_rv_core;

architecture mpei_rv_core_arc of mpei_rv_core is

signal ahbmi          : ahb_mst_out_type;
signal ahbmo          : ahb_mst_out_vector := (others => ahbm_none);

signal ahbsi          : ahb_mst_out_type;
signal ahbso          : ahb_slv_out_vector := (others => ahbs_none);

signal apbi           : apb_slv_in_type;
signal apbo           : apb_slv_out_vector := (others => apb_none);

begin

------------------------------------------------------------------------------------
--                                SCR1_WRP                                        --
------------------------------------------------------------------------------------
u_scr1_wrp : entity work.scr1_wrp
port map(
  -- Control
  pwrup_rst_n     =>                            ,  -- in   std_ulogic; --Power-Up Reset
  rst_n           => rstn_i                     ,  -- in   std_ulogic; --Regular Reset signal
  cpu_rst_n       =>                            ,  -- in   std_ulogic; --CPU Reset (Core Reset)
  test_mode       =>                            ,  -- in   std_ulogic; --Test mode
  test_rst_n      =>                            ,  -- in   std_ulogic; --Test mode's reset
  clk             => clk_i                      ,  -- in   std_ulogic; --System clock
  rtc_clk         =>                            ,  -- in   std_ulogic; --Real-time clock
  sys_rst_n_o     =>                            ,  -- out  std_ulogic; --External System Reset out
                                                    -- (for the processor cluster's components or
                                                    -- external SOC (could be useful in small
                                                    -- SCR-core-centric SOCs))
  sys_rdc_qlfy_o  =>                            ,  -- out  std_ulogic; System-to-External SOC Reset Domain Crossing Qualifier
                                               
  -- Fuses                     
  fuse_mhartid    =>                            ,  -- in std_logic_vector (SCR1_XLEN-1 downto 0); Hart ID
  fuse_idcode     =>                            ,  -- in std_logic_vector (31 downto 0)         ; TAPC IDCODE
                     
  -- IRQ                             
  irq_lines       =>                            ,  -- in std_logic_vector (SCR1_IRQ_LINES_NUM-1 downto 0); IRQ lines to IPIC
  ext_irq         =>                            ,  -- in std_ulogic;                                       External IRQ in
  soft_irq        =>                            ,  -- in std_ulogic;                                       Software IRQ in
                               
  -- JTAG I/F                            
  trst_n          =>                            ,  -- in  std_ulogic;                                 
  tck             =>                            ,  -- in  std_ulogic;                                 
  tms             =>                            ,  -- in  std_ulogic;                                 
  tdi             =>                            ,  -- in  std_ulogic;                                 
  tdo             =>                            ,  -- out std_ulogic;                                 
  tdo_en          =>                            ,  -- out std_ulogic;

  -- Instruction Memory Interface
  msti_imem       => ahbmi                      ,  -- in   ahb_mst_in_type;
  msto_imem       => ahbso(INDEX_AHBM_CPU_IMEM) ,  -- out  ahb_mst_in_type;

  -- Data Memory Interface
  msti_dmem       => ahbmi                      ,  -- in   ahb_mst_in_type;
  msto_dmem       => ahbso(INDEX_AHBM_CPU_DMEM)    -- out  ahb_mst_in_type;
);

------------------------------------------------------------------------------------
--                                AHBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/ahbctrl.vhd 
u_ahbctrl : entity work.ahbctrl 
generic map (
  defmast     =>                            , -- integer := 0;                          -- default master
  split       =>                            , -- integer := 0;                          -- split support
  rrobin      =>                            , -- integer := 0;                          -- round-robin arbitration
  timeout     =>                            , -- integer range 0 to 255 := 0;           -- HREADY timeout
  ioaddr      =>                            , -- ahb_addr_type := 16#fff#;              -- I/O area MSB address
  iomask      =>                            , -- ahb_addr_type := 16#fff#;              -- I/O area address mask
  cfgaddr     =>                            , -- ahb_addr_type := 16#ff0#;              -- config area MSB address
  cfgmask     =>                            , -- ahb_addr_type := 16#ff0#;              -- config area address mask
  nahbm       =>                            , -- integer range 1 to NAHBMST := NAHBMST; -- number of masters
  nahbs       =>                            , -- integer range 1 to NAHBSLV := NAHBSLV; -- number of slaves
  ioen        =>                            , -- integer range 0 to 15 := 1;            -- enable I/O area
  disirq      =>                            , -- integer range 0 to 1 := 0;             -- disable interrupt routing
  fixbrst     =>                            , -- integer range 0 to 1 := 0;             -- support fix-length bursts
  debug       =>                            , -- integer range 0 to 2 := 2;             -- report cores to console
  fpnpen      =>                            , -- integer range 0 to 1 := 0;             -- full PnP configuration decoding
  icheck      =>                            , -- integer range 0 to 1 := 1;
  devid       =>                            , -- integer := 0;                          -- unique device ID
  enbusmon    =>                            , -- integer range 0 to 1 := 0;             --enable bus monitor
  assertwarn  =>                            , -- integer range 0 to 1 := 0;             --enable assertions for warnings
  asserterr   =>                            , -- integer range 0 to 1 := 0;             --enable assertions for errors
  hmstdisable =>                            , -- integer := 0;                          --disable master checks
  hslvdisable =>                            , -- integer := 0;                          --disable slave checks
  arbdisable  =>                            , -- integer := 0;                          --disable arbiter checks
  mprio       =>                            , -- integer := 0;                          --master with highest priority
  mcheck      =>                            , -- integer range 0 to 2 := 1;             --check memory map for intersects
  ccheck      =>                            , -- integer range 0 to 1 := 1;             --perform sanity checks on pnp config
  acdm        =>                            , -- integer := 0;                          --AMBA compliant data muxing (for hsize > word)
  index       =>                            , -- integer := 0;                          --Index for trace print-out
  ahbtrace    =>                            , -- integer := 0;                          --AHB trace enable
  hwdebug     =>                            , -- integer := 0;                          --Hardware debug
  fourgslv    =>                            , -- integer := 0;                          --1=Single slave with single 4 GB bar
  shadow      =>                            , -- integer range 0 to 1 := 0;             -- Allow memory area shadowing
  unmapslv    =>                            , -- integer := 0;                          -- to redirect unmapped areas to slave, set to 256+bar*32+slv
  ahbendian   =>                              -- integer := GRLIB_ENDIAN
) port map (
  rst         => rstn_i                     , -- in  std_ulogic;
  clk         => clk_i                      , -- in  std_ulogic;
  
  msti        => ahbmi                      , -- out ahb_mst_in_type;      -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
  msto        => ahbmo                      , -- in  ahb_mst_out_vector;	 -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
  
  slvi        => ahbsi --?(INDEX_AHBS_AHB2APB)  , -- out ahb_slv_in_type;      -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL) 
  slvo        => ahbso                      , -- in  ahb_slv_out_vector;   -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL)
  
  testen      =>                            , -- in  std_ulogic := '0';
  testrst     =>                            , -- in  std_ulogic := '1';
  scanen      =>                            , -- in  std_ulogic := '0';
  testoen     =>                            , -- in  std_ulogic := '1';
  testsig     =>                              -- in  std_logic_vector(1+GRLIB_CONFIG_ARRAY(grlib_techmap_testin_extra) downto 0) := (others => '0')
);

------------------------------------------------------------------------------------
--                                APBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/apbctrl.vhd 
u_apbctrl : entity work.apbctrl
generic map (
  hindex      => INDEX_AHBS_AHB2APB         ,  -- integer := 0;                           -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  haddr       => ADDR_APBCTRL               ,  -- integer := 0;                           -- значение ADDR_APBCTRL см. в библиотеке core_const_pkg
  hmask       => 16#fff#                    ,  -- integer := 16#fff#;
  nslaves     => INDEX_APB_ALL              ,  -- integer range 1 to NAPBSLV := NAPBSLV;  -- значение INDEX_APB_ALL см. в библиотеке core_const_pkg
  debug       => 2                          ,  -- integer range 0 to 2 := 2;
  icheck      => 1                          ,  -- integer range 0 to 1 := 1;
  enbusmon    => 0                          ,  -- integer range 0 to 1 := 0;
  asserterr   => 0                          ,  -- integer range 0 to 1 := 0;
  assertwarn  => 0                          ,  -- integer range 0 to 1 := 0;
  pslvdisable => 0                          ,  -- integer := 0;
  mcheck      => 1                          ,  -- integer range 0 to 1 := 1;
  ccheck      => 1                             -- integer range 0 to 1 := 1
) port map (  
  rst         => rstn_i                     ,  -- in  std_ulogic;
  clk         => clk_i                      ,  -- in  std_ulogic;
    
  ahbi        => ahbsi --?(INDEX_AHBS_AHB2APB)  ,  -- in  ahb_slv_in_type;                  -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  ahbo        => ahbso(INDEX_AHBS_AHB2APB)  ,  -- out ahb_slv_out_type;                 -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
    
  apbi        => apbi                       ,  -- out apb_slv_in_type;                  -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
  apbo        => apbo                          -- in  apb_slv_out_vector                -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
);

------------------------------------------------------------------------------------
--                                SPICTRL                                         --
------------------------------------------------------------------------------------
u_spictrl : entity work.spictrl
generic map(
  pindex    =>                         , -- integer               := 0;       slave bus index
  paddr     =>                         , -- integer               := 0;       APB address
  pmask     =>                         , -- integer               := 16#fff#; APB mask
  pirq      =>                         , -- integer               := 0;       interrupt index
  fdepth    =>                         , -- integer range 1 to 7  := 1;       FIFO depth is 2^fdepth
  slvselen  =>                         , -- integer range 0 to 1  := 0;       Slave select register enable
  slvselsz  =>                         , -- integer range 1 to 32 := 1;       Number of slave select signals
  oepol     =>                         , -- integer range 0 to 1  := 0;       Output enable polarity
  odmode    =>                         , -- integer range 0 to 1  := 0;       Support open drain mode, only set if pads are i/o or od pads.
  automode  =>                         , -- integer range 0 to 1  := 0;       Enable automated transfer mode
  acntbits  =>                         , -- integer range 1 to 32 := 32       # Bits in am period counter
  aslvsel   =>                         , -- integer range 0 to 1  := 0;       Automatic slave select
  twen      =>                         , -- integer range 0 to 1  := 1;       Enable three wire mode
  maxwlen   =>                         , -- integer range 0 to 15 := 0;       Maximum word length
  netlist   =>                         , -- integer               := 0;       Use netlist (tech)
  syncram   =>                         , -- integer range 0 to 1  := 1;       Use SYNCRAM for buffers 
  memtech   =>                         , -- integer               := 0;       Memory technology
  ft        =>                         , -- integer range 0 to 2  := 0;       Fault-Tolerance
  scantest  =>                         , -- integer range 0 to 1  := 0;       Scan test support
  syncrst   =>                         , -- integer range 0 to 1  := 0;       Use only sync reset
  automask0 =>                         , -- integer               := 0;       Mask 0 for automated transfers
  automask1 =>                         , -- integer               := 0;       Mask 1 for automated transfers
  automask2 =>                         , -- integer               := 0;       Mask 2 for automated transfers
  automask3 =>                         , -- integer               := 0;       Mask 3 for automated transfers
  ignore    =>                         , -- integer range 0 to 1  := 0;       Ignore samples
  prot      =>                           -- integer range 0 to 2  := 0        Legacy, 1: dual, 2: quad
) port map (
  rstn      => rstn_i                  , --std_ulogic;
  clk       => clk_i                   , --std_ulogic;
  apbi      => apbi                    , --apb_slv_in_type;
  apbo      => apbo(INDEX_APB_SPICTRL) , --apb_slv_out_type;
  spii      => spii                    , --spi_in_type;
  spio      => spio                    , --spi_out_type;
  slvsel    => slvsel                    --std_logic_vector((slvselsz-1) downto 0)
);

------------------------------------------------------------------------------------
--                                APBUART                                         --
------------------------------------------------------------------------------------
u_apbuart : entity work.apbuart
generic map (
  pindex   =>                         , -- integer                := 0; 
  paddr    =>                         , -- integer                := 0;
  pmask    =>                         , -- integer                := 16#fff#;
  console  =>                         , -- integer                := 0; 
  pirq     =>                         , -- integer                := 0;
  parity   =>                         , -- integer                := 1; 
  flow     =>                         , -- integer                := 1;
  fifosize =>                         , -- integer range 1 to 32  := 1;
  abits    =>                         , -- integer                := 8;
  sbits    =>                           -- integer range 12 to 32 := 12);
) port map(
  rst      => rstn_i                  , --in  std_ulogic;
  clk      => clk_i                   , --in  std_ulogic;
  apbi     => apbi                    , --in  apb_slv_in_type;
  apbo     => apbo(INDEX_APB_APBUART) , --out apb_slv_out_type;
  uarti    => uarti                   , --in  uart_in_type;
  uarto    => uarto                     --out uart_out_type
);

------------------------------------------------------------------------------------
--                                GPIO                                            --
------------------------------------------------------------------------------------
-- исходник лежит здесь -  mphei_riscv_mcu_22/hard/src/grlib/lib/gaisler/misc/grgpio.vhd 
u_grgpio : entity work.grgpio
generic map (
  pindex   =>                      , -- integer              := 0;
  paddr    =>                      , -- integer              := 0;
  pmask    =>                      , -- integer              := 16#fff#;
  imask    =>                      , -- integer              := 16#0000#; -- Mask for interrupts
  nbits    =>                      , -- integer              := 16;		   	-- GPIO bits
  oepol    =>                      , -- integer              := 0;        -- Output enable polarity
  syncrst  =>                      , -- integer              := 0;        -- Only synchronous reset
  bypass   =>                      , -- integer              := 16#0000#; -- alternative functions
  scantest =>                      , -- integer              := 0;
  bpdir    =>                      , -- integer              := 16#0000#;
  pirq     =>                      , -- integer              := 0;        -- not used
  irqgen   =>                      , -- integer              := 0;
  iflagreg =>                      , -- integer range 0 to 1 := 0;
  bpmode   =>                      , -- integer range 0 to 1 := 0;
  inpen    =>                      , -- integer range 0 to 1 := 0;
  doutresv =>                      , -- integer              := 0;
  dirresv  =>                      , -- integer              := 0;
  bpresv   =>                      , -- integer              := 0;
  inpresv  =>                      , -- integer              := 0;
  pulse    =>                        -- integer              := 0
) port map (
  rst      => rstn_i               , --in  std_ulogic;
  clk      => clk_i                , --in  std_ulogic;
  apbi     => apbi                 , --in  apb_slv_in_type;
  apbo     => apbo(INDEX_APB_GPIO) , --out apb_slv_out_type; -- значение INDEX_APB_GPIO см. в библиотеке core_const_pkg
  gpioi    => gpioi                , --in  gpio_in_type;
  gpioo    => gpioo                  --out gpio_out_type
);

------------------------------------------------------------------------------------
--                                GRTIMER                                         --
------------------------------------------------------------------------------------
u_grtimer : entity work.grtimer
generic map(
  pindex    =>                         , -- Integer              := 0;
  paddr     =>                         , -- Integer              := 0;
  pmask     =>                         , -- Integer              := 16#fff#;
  pirq      =>                         , -- Integer              := 1;
  sepirq    =>                         , -- Integer              := 1;       -- separate interrupts
  sbits     =>                         , -- Integer              := 10;      -- scaler bits
  ntimers   =>                         , -- Integer range 1 to 7 := 2;       -- number of timers
  nbits     =>                         , -- Integer              := 32;      -- timer bits
  wdog      =>                         , -- Integer              := 0;
  glatch    =>                         , -- Integer              := 0;
  gextclk   =>                         , -- Integer              := 0;
  gset      =>                           -- Integer              := 0
) port map (
  rst       => rstn_i                  , -- Std_ULogic;
  clk       => clk_i                   , -- Std_ULogic;
  apbi      => apbi                    , -- apb_slv_in_type;
  apbo      => apbo(INDEX_APB_GRTIMER) , -- apb_slv_out_type;
  gpti      => gpti                    , -- gptimer_in_type;
  gpto      => gpto                      -- gptimer_out_type;
);


end mpei_rv_core_arc;
