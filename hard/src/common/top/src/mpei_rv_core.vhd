library ieee;
use ieee.std_logic_1164.all;

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
generic (
  slvselsz           : integer range 1 to 32 := 1 ;  -- for spictrl
  NAHBIRQ            : integer               := 32;  -- how it how it calculated: 32 + 32*GRLIB_CONFIG_ARRAY(grlib_amba_inc_nirq); -> config.vhd -> 32 + 32*0;
  SCR1_XLEN          : integer               := 32;  -- for scr Fuses
  SCR1_IRQ_LINES_NUM : integer               := 16;  -- for scr IQR
  SCR1_AHB_WIDTH     : integer               := 32   -- for scr lenght of AHB
);
port(
  clk_i              : in  std_ulogic;
  rstn_i             : in  std_ulogic;
    
  --                 scr1_wrp interface
  --                 what have to output? JTAG, IQR, Fuses, control pin?
    
  --                 spictrl interface
  spi_miso_i         : in  std_ulogic;
  spi_mosi_i         : in  std_ulogic;
  spi_sck_i          : in  std_ulogic;
  spi_spisel_i       : in  std_ulogic;
  spi_astart_i       : in  std_ulogic;
  spi_cstart_i       : in  std_ulogic;
  spi_ignore_i       : in  std_ulogic;
  spi_io2_i          : in  std_ulogic;
  spi_io3_i          : in  std_ulogic;
  spi_miso_o         : out std_ulogic; 
  spi_misooen_o      : out std_ulogic;
  spi_mosi_o         : out std_ulogic;
  spi_mosioen_o      : out std_ulogic;
  spi_sck_o          : out std_ulogic; --???? duplicate pins
  spi_sckoen_o       : out std_ulogic;
  spi_enable_o       : out std_ulogic;
  spi_astart_o       : out std_ulogic;
  spi_aready_o       : out std_ulogic;
  spi_io2_o          : out std_ulogic;
  spi_io2oen_o       : out std_ulogic;
  spi_io3_o          : out std_ulogic;
  spi_io3oen_o       : out std_ulogic;
  spi_slvsel_o       : out std_logic_vector((slvselsz-1) downto 0);
                              
  --                 apbuart interface 
  uart_rxd   	       : in  std_ulogic;
  uart_ctsn   	     : in  std_ulogic;
  uart_extclk	       : in  std_ulogic;
  uart_rtsn   	     : out std_ulogic;
  uart_txd   	       : out std_ulogic;
  uart_scaler	       : out std_logic_vector(31 downto 0);
  uart_txen          : out std_ulogic;
  uart_flow   	     : out std_ulogic;
  uart_rxen          : out std_ulogic;
  uart_txtick        : out std_ulogic;
  uart_rxtick        : out std_ulogic;
    
  --                 gpio interface
  gpio_din           : in  std_logic_vector(31 downto 0);
  gpio_sig_in        : in  std_logic_vector(31 downto 0);
  gpio_sig_en        : in  std_logic_vector(31 downto 0);
  gpio_dout          : out std_logic_vector(31 downto 0);
  gpio_oen           : out std_logic_vector(31 downto 0);
  gpio_val           : out std_logic_vector(31 downto 0);
  gpio_sig_out       : out std_logic_vector(31 downto 0);
    
  --                 gptimer interface
  timr_dhalt         : in  std_ulogic;
  timr_extclk        : in  std_ulogic;
  timr_wdogen        : in  std_ulogic;
  timr_latchv        : in  std_logic_vector(NAHBIRQ-1 downto 0);
  timr_latchd        : in  std_logic_vector(NAHBIRQ-1 downto 0);
  timr_tick          : out std_logic_vector(0 to 7);
  timr_timer1        : out std_logic_vector(31 downto 0);
  timr_wdogn         : out std_ulogic;
  timr_wdog          : out std_ulogic
);
end mpei_rv_core;

architecture mpei_rv_core_arc of mpei_rv_core is

-- inner signal
signal ahbmi     : ahb_mst_in_type;
signal ahbmo     : ahb_mst_out_vector := (others => ahbm_none);

signal ahbsi     : ahb_slv_in_type;
signal ahbso     : ahb_slv_out_vector := (others => ahbs_none);

signal apbi      : apb_slv_in_type;
signal apbo      : apb_slv_out_vector := (others => apb_none);

signal spii      : spi_in_type;
signal spio      : spi_out_type;

signal uarti     : uart_in_type;
signal uarto     : uart_out_type;

signal gpioi     : gpio_in_type;
signal gpioo     : gpio_out_type;

signal gpti      : gptimer_in_type;
signal gpto      : gptimer_out_type;

signal rst_i     : std_ulogic;                                   --inverted signal


begin

-- initialization of inner signal
rst_i <= rstn_i;

------------------------------------------------------------------------------------
--                                SCR1_WRP                                        --
------------------------------------------------------------------------------------
u_scr1_wrp : entity work.scr1_wrp
generic map (
  SCR1_XLEN          => SCR1_XLEN          , 
  SCR1_IRQ_LINES_NUM => SCR1_IRQ_LINES_NUM , 
  SCR1_AHB_WIDTH     => SCR1_AHB_WIDTH      
)
port map(
  -- Control
  pwrup_rst_n        => rstn_i                     ,  -- in   std_ulogic; --Power-Up Reset
  rst_n              => rstn_i                     ,  -- in   std_ulogic; --Regular Reset signal
  cpu_rst_n          => rstn_i                     ,  -- in   std_ulogic; --CPU Reset (Core Reset)
  test_mode          => '0'                        ,  -- in   std_ulogic; --Test mode
  test_rst_n         => '1'                        ,  -- in   std_ulogic; --Test mode's reset
  clk                => clk_i                      ,  -- in   std_ulogic; --System clock
  rtc_clk            => clk_i                      ,  -- in   std_ulogic; --Real-time clock
  sys_rst_n_o        => open                       ,  -- out  std_ulogic; --External System Reset out
                                                       -- (for the processor cluster's components or
                                                       -- external SOC (could be useful in small
                                                       -- SCR-core-centric SOCs))
  sys_rdc_qlfy_o     => open                       ,  -- out  std_ulogic; System-to-External SOC Reset Domain Crossing Qualifier
                                                  
  -- Fuses                        
  fuse_mhartid       => (others => '0')            ,  -- in std_logic_vector (SCR1_XLEN-1 downto 0); Hart ID
  fuse_idcode        => (others => '0')            ,  -- in std_logic_vector (31 downto 0)         ; TAPC IDCODE
                        
  -- IRQ                                
  irq_lines          => ahbmi.hirq(15 downto 0)    ,  -- in std_logic_vector (SCR1_IRQ_LINES_NUM-1 downto 0); IRQ lines to IPIC
  ext_irq            => '0'                        ,  -- in std_ulogic;                                       External IRQ in
  soft_irq           => '0'                        ,  -- in std_ulogic;                                       Software IRQ in
                                  
  -- JTAG I/F                               
  trst_n             => '1'                        ,  -- in  std_ulogic;                                 
  tck                => '0'                        ,  -- in  std_ulogic;                                 
  tms                => '1'                        ,  -- in  std_ulogic;                                 
  tdi                => '1'                        ,  -- in  std_ulogic;                                 
  tdo                => open                       ,  -- out std_ulogic;                                 
  tdo_en             => open                       ,  -- out std_ulogic;
   
  -- Instruction Memory Interface
  msti_imem          => ahbmi                      ,  -- in   ahb_mst_in_type;
  msto_imem          => ahbmo(INDEX_AHBM_CPU_IMEM) ,  -- out  ahb_mst_in_type;
   
  -- Data Memory Interface
  msti_dmem          => ahbmi                      ,  -- in   ahb_mst_in_type;
  msto_dmem          => ahbmo(INDEX_AHBM_CPU_DMEM)    -- out  ahb_mst_in_type;
);

------------------------------------------------------------------------------------
--                                AHBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/ahbctrl.vhd 
u_ahbctrl : entity grlib.ahbctrl 
generic map (
  defmast     => INDEX_AHBM_CPU_IMEM        , -- integer                    := 0;           -- default master
  split       => 0                          , -- integer                    := 0;           -- split support
  rrobin      => 1                          , -- integer                    := 0;           -- round-robin arbitration
  timeout     => 0                          , -- integer range 0 to 255     := 0;           -- HREADY timeout
  ioaddr      => 16#FFF#                    , -- ahb_addr_type              := 16#fff#;     -- I/O area MSB address
  iomask      => 16#FF0#                    , -- ahb_addr_type              := 16#fff#;     -- I/O area address mask
  cfgaddr     => 16#FF0#                    , -- ahb_addr_type              := 16#ff0#;     -- config area MSB address
  cfgmask     => 16#FF0#                    , -- ahb_addr_type              := 16#ff0#;     -- config area address mask
  nahbm       => NAHBMST                    , -- integer range 1 to NAHBMST := NAHBMST;     -- number of masters
  nahbs       => NAHBSLV                    , -- integer range 1 to NAHBSLV := NAHBSLV;     -- number of slaves
  ioen        => 1                          , -- integer range 0 to 15      := 1;           -- enable I/O area
  disirq      => 0                          , -- integer range 0 to 1       := 0;           -- disable interrupt routing
  fixbrst     => 1                          , -- integer range 0 to 1       := 0;           -- support fix-length bursts
  debug       => 2                          , -- integer range 0 to 2       := 2;           -- report cores to console
  fpnpen      => 0                          , -- integer range 0 to 1       := 0;           -- full PnP configuration decoding
  icheck      => 1                          , -- integer range 0 to 1       := 1;    
  devid       => 0                          , -- integer                    := 0;           -- unique device ID
  enbusmon    => 0                          , -- integer range 0 to 1       := 0;           -- enable bus monitor
  assertwarn  => 0                          , -- integer range 0 to 1       := 0;           -- enable assertions for warnings
  asserterr   => 0                          , -- integer range 0 to 1       := 0;           -- enable assertions for errors
  hmstdisable => 0                          , -- integer                    := 0;           -- disable master checks
  hslvdisable => 0                          , -- integer                    := 0;           -- disable slave checks
  arbdisable  => 0                          , -- integer                    := 0;           -- disable arbiter checks
  mprio       => INDEX_AHBM_CPU_IMEM        , -- integer                    := 0;           -- master with highest priority
  mcheck      => 1                          , -- integer range 0 to 2       := 1;           -- check memory map for intersects
  ccheck      => 1                          , -- integer range 0 to 1       := 1;           -- perform sanity checks on pnp config
  acdm        => 0                          , -- integer                    := 0;           -- AMBA compliant data muxing (for hsize > word)
  index       => 0                          , -- integer                    := 0;           -- Index for trace print-out
  ahbtrace    => 0                          , -- integer                    := 0;           -- AHB trace enable
  hwdebug     => 0                          , -- integer                    := 0;           -- Hardware debug
  fourgslv    => 0                          , -- integer                    := 0;           -- 1=Single slave with single 4 GB bar
  shadow      => 0                          , -- integer range 0 to 1       := 0;           -- Allow memory area shadowing
  unmapslv    => 0                          , -- integer                    := 0;           -- to redirect unmapped areas to slave, set to 256+bar*32+slv
  ahbendian   => GRLIB_ENDIAN                 -- integer                    := GRLIB_ENDIAN
) port map (
  rst         => rst_i                     , -- in  std_ulogic;
  clk         => clk_i                      , -- in  std_ulogic;
  
  msti        => ahbmi                      , -- out ahb_mst_in_type;                       -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
  msto        => ahbmo                      , -- in  ahb_mst_out_vector;	                  -- массив AHB интерфейсов подключенных к мастерам (в нашем случае 1 мастер SCR1_WRP) 
                   
  slvi        => ahbsi                      , -- out ahb_slv_in_type;                       -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL) 
  slvo        => ahbso                      , -- in  ahb_slv_out_vector;                    -- массив AHB интерфейсов подключенных к слейвам  (в нашем случае 1 слейв APBCTRL)
  
  testen      => '0'                        , -- in  std_ulogic := '0';
  testrst     => '1'                        , -- in  std_ulogic := '1';
  scanen      => '0'                        , -- in  std_ulogic := '0';
  testoen     => '1'                        , -- in  std_ulogic := '1';
  testsig     => (others => '0')              -- in  std_logic_vector(1+GRLIB_CONFIG_ARRAY(grlib_techmap_testin_extra) downto 0) := (others => '0')
);

------------------------------------------------------------------------------------
--                                APBCTRL                                         --
------------------------------------------------------------------------------------
-- исходник лежит здесь - mphei_riscv_mcu_22/hard/src/grlib/lib/grlib/amba/apbctrl.vhd 
u_apbctrl : entity grlib.apbctrl
generic map (
  hindex      => INDEX_AHBS_AHB2APB         ,  -- integer                    := 0;        -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  haddr       => ADDR_APBCTRL               ,  -- integer                    := 0;        -- значение ADDR_APBCTRL см. в библиотеке core_const_pkg
  hmask       => 16#FFF#                    ,  -- integer                    := 16#fff#;
  nslaves     => INDEX_APB_ALL              ,  -- integer range 1 to NAPBSLV := NAPBSLV;  -- значение INDEX_APB_ALL см. в библиотеке core_const_pkg
  debug       => 2                          ,  -- integer range 0 to 2       := 2;
  icheck      => 1                          ,  -- integer range 0 to 1       := 1;
  enbusmon    => 0                          ,  -- integer range 0 to 1       := 0;
  asserterr   => 0                          ,  -- integer range 0 to 1       := 0;
  assertwarn  => 0                          ,  -- integer range 0 to 1       := 0;
  pslvdisable => 0                          ,  -- integer                    := 0;      
  mcheck      => 1                          ,  -- integer range 0 to 1       := 1;
  ccheck      => 1                             -- integer range 0 to 1       := 1
) port map (  
  rst         => rst_i                     ,  -- in  std_ulogic;
  clk         => clk_i                      ,  -- in  std_ulogic;
    
  ahbi        => ahbsi                      ,  -- in  ahb_slv_in_type;                  -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
  ahbo        => ahbso(INDEX_AHBS_AHB2APB)  ,  -- out ahb_slv_out_type;                 -- значение INDEX_AHBS_AHB2APB см. в библиотеке core_const_pkg
    
  apbi        => apbi                       ,  -- out apb_slv_in_type;                  -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
  apbo        => apbo                          -- in  apb_slv_out_vector                -- массив APB интерфейсов подключенных к слейвам  (в нашем случае 4 слейва SPICTRL, APBUART, GPIO, GRTIMER) 
);

------------------------------------------------------------------------------------
--                                SPICTRL                                         --
------------------------------------------------------------------------------------
spii.miso        <=  spi_miso_i    ; 
spii.mosi        <=  spi_mosi_i    ; 
spii.sck         <=  spi_sck_i     ; 
spii.spisel      <=  spi_spisel_i  ; 
spii.astart      <=  spi_astart_i  ; 
spii.cstart      <=  spi_cstart_i  ; 
spii.ignore      <=  spi_ignore_i  ; 
spii.io2         <=  spi_io2_i     ; 
spii.io3         <=  spi_io3_i     ; 
  
spi_miso_o       <=  spio.miso     ;
spi_misooen_o    <=  spio.misooen  ;
spi_mosi_o       <=  spio.mosi     ;
spi_mosioen_o    <=  spio.mosioen  ;
spi_sck_o        <=  spio.sck      ;
spi_sckoen_o     <=  spio.sckoen   ;
spi_enable_o     <=  spio.enable   ;
spi_astart_o     <=  spio.astart   ;
spi_aready_o     <=  spio.aready   ;
spi_io2_o        <=  spio.io2      ;
spi_io2oen_o     <=  spio.io2oen   ;
spi_io3_o        <=  spio.io3      ;
spi_io3oen_o     <=  spio.io3oen   ;

u_spictrl : entity gaisler.spictrl
generic map(
  pindex    => INDEX_APB_SPICTRL       , -- integer               := 0;       slave bus index
  paddr     => INDEX_APB_SPICTRL*16    , -- integer               := 0;       APB address
  pmask     => 16#FF0#                 , -- integer               := 16#fff#; APB mask
  pirq      => 0                       , -- integer               := 0;       interrupt index
  fdepth    => 1                       , -- integer range 1 to 7  := 1;       FIFO depth is 2^fdepth
  slvselen  => 0                       , -- integer range 0 to 1  := 0;       Slave select register enable
  slvselsz  => 1                       , -- integer range 1 to 32 := 1;       Number of slave select signals
  oepol     => 0                       , -- integer range 0 to 1  := 0;       Output enable polarity
  odmode    => 0                       , -- integer range 0 to 1  := 0;       Support open drain mode, only set if pads are i/o or od pads.
  automode  => 0                       , -- integer range 0 to 1  := 0;       Enable automated transfer mode
  acntbits  => 3                       , -- integer range 1 to 32 := 32       # Bits in am period counter
  aslvsel   => 0                       , -- integer range 0 to 1  := 0;       Automatic slave select
  twen      => 1                       , -- integer range 0 to 1  := 1;       Enable three wire mode
  maxwlen   => 0                       , -- integer range 0 to 15 := 0;       Maximum word length
  netlist   => 0                       , -- integer               := 0;       Use netlist (tech)
  syncram   => 1                       , -- integer range 0 to 1  := 1;       Use SYNCRAM for buffers 
  memtech   => 0                       , -- integer               := 0;       Memory technology
  ft        => 0                       , -- integer range 0 to 2  := 0;       Fault-Tolerance
  scantest  => 0                       , -- integer range 0 to 1  := 0;       Scan test support
  syncrst   => 0                       , -- integer range 0 to 1  := 0;       Use only sync reset
  automask0 => 0                       , -- integer               := 0;       Mask 0 for automated transfers
  automask1 => 0                       , -- integer               := 0;       Mask 1 for automated transfers
  automask2 => 0                       , -- integer               := 0;       Mask 2 for automated transfers
  automask3 => 0                       , -- integer               := 0;       Mask 3 for automated transfers
  ignore    => 0                       , -- integer range 0 to 1  := 0;       Ignore samples
  prot      => 0                         -- integer range 0 to 2  := 0        Legacy, 1: dual, 2: quad
) port map (
  rstn      => rstn_i                  , --std_ulogic;
  clk       => clk_i                   , --std_ulogic;
  apbi      => apbi                    , --apb_slv_in_type;
  apbo      => apbo(INDEX_APB_SPICTRL) , --apb_slv_out_type;
  spii      => spii                    , --spi_in_type;
  spio      => spio                    , --spi_out_type;
  slvsel    => spi_slvsel_o              --std_logic_vector((slvselsz-1) downto 0)
);

------------------------------------------------------------------------------------
--                                APBUART                                         --
------------------------------------------------------------------------------------
uarti.rxd     <=  uart_rxd      ;
uarti.ctsn    <=  uart_ctsn     ;
uarti.extclk  <=  uart_extclk   ;

uart_rtsn     <=  uarto.rtsn    ;
uart_txd      <=  uarto.txd     ;
uart_scaler   <=  uarto.scaler  ;
uart_txen     <=  uarto.txen    ;
uart_flow     <=  uarto.flow    ;
uart_rxen     <=  uarto.rxen    ;
uart_txtick   <=  uarto.txtick  ;
uart_rxtick   <=  uarto.rxtick  ;

u_apbuart : entity gaisler.apbuart
generic map (
  pindex   => INDEX_APB_APBUART       , -- integer                := 0; 
  paddr    => INDEX_APB_APBUART*16    , -- integer                := 0;
  pmask    => 16#FF0#                 , -- integer                := 16#fff#;
  console  => 0                       , -- integer                := 0; 
  pirq     => 0                       , -- integer                := 0;
  parity   => 1                       , -- integer                := 1; 
  flow     => 1                       , -- integer                := 1;
  fifosize => 1                       , -- integer range 1 to 32  := 1;
  abits    => 8                       , -- integer                := 8;
  sbits    => 12                        -- integer range 12 to 32 := 12);
) port map(
  rst      => rst_i                  , --in  std_ulogic;
  clk      => clk_i                   , --in  std_ulogic;
  apbi     => apbi                    , --in  apb_slv_in_type;
  apbo     => apbo(INDEX_APB_APBUART) , --out apb_slv_out_type;
  uarti    => uarti                   , --in  uart_in_type;
  uarto    => uarto                     --out uart_out_type
);

------------------------------------------------------------------------------------
--                                GPIO                                            --
------------------------------------------------------------------------------------
gpioi.din     <=  gpio_din       ; 
gpioi.sig_in  <=  gpio_sig_in    ; 
gpioi.sig_en  <=  gpio_sig_en    ; 
 
gpio_dout     <=  gpioo.dout     ;
gpio_oen      <=  gpioo.oen      ;
gpio_val      <=  gpioo.val      ;
gpio_sig_out  <=  gpioo.sig_out  ;

u_grgpio : entity gaisler.grgpio
generic map (
  pindex   => INDEX_APB_GPIO       , -- integer              := 0;
  paddr    => INDEX_APB_GPIO*16    , -- integer              := 0;
  pmask    => 16#FF0#              , -- integer              := 16#fff#;
  imask    => 16#7FFFFFFF#         , -- integer              := 16#0000#; -- Mask for interrupts
  nbits    => 31                   , -- integer              := 16;		   	-- GPIO bits
  oepol    => 1                    , -- integer              := 0;        -- Output enable polarity
  syncrst  => 0                    , -- integer              := 0;        -- Only synchronous reset
  bypass   => 16#7FFFFFFF#         , -- integer              := 16#0000#; -- alternative functions
  scantest => 0                    , -- integer              := 0;
  bpdir    => 0                    , -- integer              := 16#0000#;
  pirq     => 0                    , -- integer              := 0;        -- not used
  irqgen   => 1                    , -- integer              := 0;
  iflagreg => 1                    , -- integer range 0 to 1 := 0;
  bpmode   => 1                    , -- integer range 0 to 1 := 0;
  inpen    => 1                    , -- integer range 0 to 1 := 0;
  doutresv => 0                    , -- integer              := 0;
  dirresv  => 0                    , -- integer              := 0;
  bpresv   => 0                    , -- integer              := 0;
  inpresv  => 0                    , -- integer              := 0;
  pulse    => 0                      -- integer              := 0
) port map (
  rst      => rst_i               , --in  std_ulogic;
  clk      => clk_i                , --in  std_ulogic;
  apbi     => apbi                 , --in  apb_slv_in_type;
  apbo     => apbo(INDEX_APB_GPIO) , --out apb_slv_out_type; -- значение INDEX_APB_GPIO см. в библиотеке core_const_pkg
  gpioi    => gpioi                , --in  gpio_in_type;
  gpioo    => gpioo                  --out gpio_out_type
);

------------------------------------------------------------------------------------
--                                GRTIMER                                         --
------------------------------------------------------------------------------------
gpti.dhalt   <=  timr_dhalt   ;
gpti.extclk  <=  timr_extclk  ;
gpti.wdogen  <=  timr_wdogen  ;
gpti.latchv  <=  timr_latchv  ;
gpti.latchd  <=  timr_latchd  ;

timr_tick    <=  gpto.tick    ;    
timr_timer1  <=  gpto.timer1  ;    
timr_wdogn   <=  gpto.wdogn   ;    
timr_wdog    <=  gpto.wdog    ;    

u_grtimer : entity gaisler.gptimer
generic map(
  pindex    => INDEX_APB_GRTIMER       , -- Integer              := 0;
  paddr     => INDEX_APB_GRTIMER*16    , -- Integer              := 0;
  pmask     => 16#FF0#                 , -- Integer              := 16#fff#;
  pirq      => 0                       , -- Integer              := 1;
  sepirq    => 1                       , -- Integer              := 1;       -- separate interrupts
  sbits     => 10                      , -- Integer              := 10;      -- scaler bits
  ntimers   => 2                       , -- Integer range 1 to 7 := 2;       -- number of timers
  nbits     => 32                      , -- Integer              := 32;      -- timer bits
  wdog      => 0                       , -- Integer              := 0;
  glatch    => 0                       , -- Integer              := 0;
  gextclk   => 0                       , -- Integer              := 0;
  gset      => 0                         -- Integer              := 0
) port map (
  rst       => rst_i                  , -- Std_ULogic;
  clk       => clk_i                   , -- Std_ULogic;
  apbi      => apbi                    , -- apb_slv_in_type;
  apbo      => apbo(INDEX_APB_GRTIMER) , -- apb_slv_out_type;
  gpti      => gpti                    , -- gptimer_in_type;
  gpto      => gpto                      -- gptimer_out_type;
);

end mpei_rv_core_arc;
