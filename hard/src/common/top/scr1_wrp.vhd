
library grlib;
use grlib.stdlib.all;
use grlib.amba.all;

entity scr1_wrp is
  port (
    -- Control
    pwrup_rst_n     : in   std_ulogic;                                           -- Power-Up Reset
    rst_n           : in   std_ulogic;                                           -- Regular Reset signal
    cpu_rst_n       : in   std_ulogic;                                           -- CPU Reset (Core Reset)
    test_mode       : in   std_ulogic;                                           -- Test mode
    test_rst_n      : in   std_ulogic;                                           -- Test mode's reset
    clk             : in   std_ulogic;                                           -- System clock
    rtc_clk         : in   std_ulogic;                                           -- Real-time clock
    sys_rst_n_o     : out  std_ulogic;                                           -- External System Reset out
                                                                                 -- (for the processor cluster's components or
                                                                                 -- external SOC (could be useful in small
                                                                                 -- SCR-core-centric SOCs))
    sys_rdc_qlfy_o  : out  std_ulogic;                                           -- System-to-External SOC Reset Domain Crossing Qualifier
    
    -- Fuses
    fuse_mhartid    : in   std_logic_vector   (SCR1_XLEN-1 downto 0);            -- Hart ID
    fuse_idcode     : in   std_logic_vector   (31 downto 0);                     -- TAPC IDCODE
    
    -- IRQ
    irq_lines       : in   std_logic_vector   (SCR1_IRQ_LINES_NUM-1 downto 0);   -- IRQ lines to IPIC
    ext_irq         : in   std_ulogic;                                           -- External IRQ in
    soft_irq        : in   std_ulogic;                                           -- Software IRQ in
    
    -- JTAG I/F
    trst_n          : in   std_ulogic;                                   
    tck             : in   std_ulogic;                                   
    tms             : in   std_ulogic;                                   
    tdi             : in   std_ulogic;                                   
    tdo             : out  std_ulogic;                                   
    tdo_en          : out  std_ulogic;

    -- Instruction Memory Interface
    msti_imem       : in   ahb_mst_in_type;
    msto_imem       : out  ahb_mst_in_type;

    -- Data Memory Interface
    msti_dmem       : in   ahb_mst_in_type;
    msto_dmem       : out  ahb_mst_in_type;
  );
end scr1_wrp;

architecture scr1_wrp_arc of scr1_wrp is

  constant SCR1_XLEN           : integer := 32;
  constant SCR1_IRQ_LINES_NUM  : integer := 16;
  constant SCR1_AHB_WIDTH      : integer := 32;

  component scr1_top_ahb is
    port(
      -- Control
      pwrup_rst_n     : in   std_ulogic;                                           -- Power-Up Reset
      rst_n           : in   std_ulogic;                                           -- Regular Reset signal
      cpu_rst_n       : in   std_ulogic;                                           -- CPU Reset (Core Reset)
      test_mode       : in   std_ulogic;                                           -- Test mode
      test_rst_n      : in   std_ulogic;                                           -- Test mode's reset
      clk             : in   std_ulogic;                                           -- System clock
      rtc_clk         : in   std_ulogic;                                           -- Real-time clock
      sys_rst_n_o     : out  std_ulogic;                                           -- External System Reset out
                                                                                   -- (for the processor cluster's components or
                                                                                   -- external SOC (could be useful in small
                                                                                   -- SCR-core-centric SOCs))
      sys_rdc_qlfy_o  : out  std_ulogic;                                           -- System-to-External SOC Reset Domain Crossing Qualifier
      
      -- Fuses
      fuse_mhartid    : in   std_logic_vector   (SCR1_XLEN-1 downto 0);            -- Hart ID
      fuse_idcode     : in   std_logic_vector   (31 downto 0);                     -- TAPC IDCODE
      
      -- IRQ
      irq_lines       : in   std_logic_vector   (SCR1_IRQ_LINES_NUM-1 downto 0);   -- IRQ lines to IPIC
      ext_irq         : in   std_ulogic;                                           -- External IRQ in
      soft_irq        : in   std_ulogic;                                           -- Software IRQ in
      
      -- JTAG I/F
      trst_n          : in   std_ulogic;                                   
      tck             : in   std_ulogic;                                   
      tms             : in   std_ulogic;                                   
      tdi             : in   std_ulogic;                                   
      tdo             : out  std_ulogic;                                   
      tdo_en          : out  std_ulogic;                                   
      
      -- Instruction Memory Interface
      imem_hprot      : out  std_logic_vector   (3 downto 0);                             
      imem_hburst     : out  std_logic_vector   (2 downto 0);                             
      imem_hsize      : out  std_logic_vector   (2 downto 0);                             
      imem_htrans     : out  std_logic_vector   (1 downto 0);                             
      imem_hmastlock  : out  std_ulogic;                                   
      imem_haddr      : out  std_logic_vector   (SCR1_AHB_WIDTH-1 downto 0);              
      imem_hready     : in   std_ulogic                                   
      imem_hrdata     : in   std_logic_vector   (SCR1_AHB_WIDTH-1 downto 0);              
      imem_hresp      : in   std_ulogic;                                   
      
      -- Data Memory Interface
      dmem_hprot      : out  std_logic_vector   (3 downto 0);                             
      dmem_hburst     : out  std_logic_vector   (2 downto 0);                             
      dmem_hsize      : out  std_logic_vector   (2 downto 0);                             
      dmem_htrans     : out  std_logic_vector   (1 downto 0);                             
      dmem_hmastlock  : out  std_ulogic;                                  
      dmem_haddr      : out  std_logic_vector   (SCR1_AHB_WIDTH-1 downto 0);              
      dmem_hwrite     : out  std_ulogic;                                   
      dmem_hwdata     : out  std_logic_vector   (SCR1_AHB_WIDTH-1 downto 0);              
      dmem_hready     : in   std_ulogic;                                   
      dmem_hrdata     : in   std_logic_vector   (SCR1_AHB_WIDTH-1 downto 0);              
      dmem_hresp      : in   std_ulogic;                                 
    );
  end component

  signal imem_hresp   : std_ulogic;
  signal dmem_hresp   : std_ulogic;

begin
  
  -- HRESP_RETRY 10, HRESP_SPLIT 11 ???
  if msti_imem.hresp = HRESP_OKAY
    then imem_hresp <= '0'; -- HRESP_OKAY  "00"
    else imem_hresp <= '1'; -- HRESP_ERROR "01"
  end if;

  if msti_dmem.hresp = HRESP_OKAY 
    then dmem_hresp <= '0'; -- HRESP_OKAY  "00"
    else dmem_hresp <= '1'; -- HRESP_ERROR "01"
  end if;
  
  --hconfig ???
  constant HCONFIG0 : ahb_config_type := (
    0 => ahb_device_reg ( 
      vendor,             -- amba_vendor_type;  vendor
      device,             -- amba_device_type;  device ID
      0,                  -- amba_cfgver_type;  cfgver, non configurabile
      version,            -- amba_version_type; version
      interrupt),         -- amba_irq_type;     interrupt
    4 => ahb_membar(
      memaddr,            -- ahb_addr_type; addres
      prefetch,           -- std_ulogic;    prefetchable
      cache,              -- std_ulogic;    cacheable
      addrmask),          -- ahb_addr_type; mask
    5 => ahb_iobar(
      memaddr,            -- ahb_addr_type; addres
      addrmask),          -- ahb_addr_type; mask
    6 => ,
    7 => ,
    others => X"00000000"
  );

  constant HCONFIG1 : ahb_config_type := (
    --...
  );

  msto_imem.hconfig <= HCONFIG0;
  msto_dmem.hconfig <= HCONFIG1;

  u_scr1_top_ahb : scr1_top_ahb
  port map (
    -- Control
      pwrup_rst_n     => pwrup_rst_n,                                              -- Power-Up Reset
      rst_n           => rst_n,                                                    -- Regular Reset signal
      cpu_rst_n       => cpu_rst_n,                                                -- CPU Reset (Core Reset)
      test_mode       => test_mode,                                                -- Test mode
      test_rst_n      => test_rst_n,                                               -- Test mode's reset
      clk             => clk,                                                      -- System clock
      rtc_clk         => rtc_clk,                                                  -- Real-time clock
      sys_rst_n_o     => sys_rst_n_o,                                              -- External System Reset out
                                                                                   -- (for the processor cluster's components or
                                                                                   -- external SOC (could be useful in small
                                                                                   -- SCR-core-centric SOCs))
      sys_rdc_qlfy_o  => sys_rdc_qlfy_o,                                           -- System-to-External SOC Reset Domain Crossing Qualifier
      
      -- Fuses
      fuse_mhartid    => fuse_mhartid,                                             -- Hart ID
      fuse_idcode     => fuse_idcode,                                              -- TAPC IDCODE
      
      -- IRQ
      irq_lines       => irq_lines,                                                -- IRQ lines to IPIC
      ext_irq         => ext_irq,                                                  -- External IRQ in
      soft_irq        => soft_irq,                                                 -- Software IRQ in
      
      -- JTAG I/F
      trst_n          => trst_n,                                    
      tck             => tck,                                    
      tms             => tms,                                    
      tdi             => tdi,                                    
      tdo             => tdo,                                    
      tdo_en          => tdo_en,                                    
      
      -- Instruction Memory Interface
      imem_hprot      => msto_imem.hprot,                            
      imem_hburst     => msto_imem.hburst,                            
      imem_hsize      => msto_imem.hsize,                            
      imem_htrans     => msto_imem.htrans,                            
      imem_hmastlock  => msto_imem.hlock,                                
      imem_haddr      => msto_imem.haddr,           
      imem_hready     => msti_imem.hready,                              
      imem_hrdata     => msti_imem.hrdata,              
      imem_hresp      => imem_hresp,                                
      
      -- Data Memory Interface
      dmem_hprot      => msto_dmem.hprot,                          
      dmem_hburst     => msto_dmem.hburst,                          
      dmem_hsize      => msto_dmem.hsize,                       
      dmem_htrans     => msto_dmem.htrans,                          
      dmem_hmastlock  => msto_dmem.hlock,                                    
      dmem_haddr      => msto_dmem.haddr,              
      dmem_hwrite     => msto_dmem.hwrite,                                    
      dmem_hwdata     => msto_dmem.hwdata,             
      dmem_hready     => msti_dmem.hready,                                    
      dmem_hrdata     => msti_dmem.hrdata,              
      dmem_hresp      => dmem_hresp 
  );
  
end architecture scr1_wrp_arc;
