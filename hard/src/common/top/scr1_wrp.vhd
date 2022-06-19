
library grlib;
use grlib.stdlib.all;
use grlib.amba.all;

entity scr1_wrp is
  generic (
    SCR1_XLEN           : integer := 32;
    SCR1_IRQ_LINES_NUM  : integer := 16;
    SCR1_AHB_WIDTH      : integer := 32;
  );
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
    msti            : in   ahb_mst_in_vector;

    -- Data Memory Interface
    msto            : in   ahb_mst_out_vector;
  );
end scr1_wrp;

architecture scr1_wrp_arc of scr1_wrp is

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

begin
  
  u_scr1_top_ahb : scr1_top_ahb
  port map (
    -- Control
      pwrup_rst_n     => pwrup_rst_n,                                                         -- Power-Up Reset
      rst_n           => rst_n,                                                         -- Regular Reset signal
      cpu_rst_n       => ,   --etc....                                                      -- CPU Reset (Core Reset)
      test_mode       => ,                                                         -- Test mode
      test_rst_n      => ,                                                         -- Test mode's reset
      clk             => ,                                                         -- System clock
      rtc_clk         => ,                                                         -- Real-time clock
      sys_rst_n_o     => ,                                                         -- External System Reset out
                                                                                   -- (for the processor cluster's components or
                                                                                   -- external SOC (could be useful in small
                                                                                   -- SCR-core-centric SOCs))
      sys_rdc_qlfy_o  => ,                                                         -- System-to-External SOC Reset Domain Crossing Qualifier
      
      -- Fuses
      fuse_mhartid    => ,                                                         -- Hart ID
      fuse_idcode     => ,                                                         -- TAPC IDCODE
      
      -- IRQ
      irq_lines       => ,                                                         -- IRQ lines to IPIC
      ext_irq         => ,                                                         -- External IRQ in
      soft_irq        => ,                                                         -- Software IRQ in
      
      -- -- JTAG I/F
      trst_n          => ,                                    
      tck             => ,                                    
      tms             => ,                                    
      tdi             => ,                                    
      tdo             => ,                                    
      tdo_en          => ,                                    
      
      -- Instruction Memory Interface
      imem_hprot      => msti(0).hprot,                            
      imem_hburst     => msti(0).hburst,                            
      imem_hsize      => ,                            
      imem_htrans     => ,                            
      imem_hmastlock  => ,                                
      imem_haddr      => ,           
      imem_hready     => msto(0).hready,                              
      imem_hrdata     => msto(0).hrdata,              
      imem_hresp      => msto(0).hresp,                                
      
      -- Data Memory Interface
      dmem_hprot      => msti(1).hprot,    -- protection control                       
      dmem_hburst     => msti(1).hburst,   -- burst type                         
      dmem_hsize      => ,                 -- etc...                      
      dmem_htrans     => ,                          
      dmem_hmastlock  => ,                                    
      dmem_haddr      => ,              
      dmem_hwrite     => ,                                    
      dmem_hwdata     => ,             
      dmem_hready     => ,                                    
      dmem_hrdata     => ,              
      dmem_hresp      =>  
  );
  
end architecture scr1_wrp_arc;
