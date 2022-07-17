library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library techmap;
use techmap.gencomp.all;
use techmap.netcomp.all;
library grlib;
use grlib.amba.all;
use grlib.devices.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.spi.all;

entity spi_wrap is 
    generic(
    -- APB generics
    pindex : integer := 0;                -- slave bus index
    paddr  : integer := 0;                -- APB address
    pmask  : integer := 16#fff#;          -- APB mask
    pirq   : integer := 0;                -- interrupt index

    -- SPI controller configuration
    fdepth    : integer range 1 to 7      := 1;  -- FIFO depth is 2^fdepth
    slvselen  : integer range 0 to 1      := 0;  -- Slave select register enable
    slvselsz  : integer range 1 to 32     := 1;  -- Number of slave select signals
    oepol     : integer range 0 to 1      := 0;  -- Output enable polarity
    odmode    : integer range 0 to 1      := 0;  -- Support open drain mode, only
                                                -- set if pads are i/o or od pads.
    automode  : integer range 0 to 1      := 0;  -- Enable automated transfer mode
    acntbits  : integer range 1 to 32     := 32; -- # Bits in am period counter
    aslvsel   : integer range 0 to 1      := 0;  -- Automatic slave select
    twen      : integer range 0 to 1      := 1;  -- Enable three wire mode
    maxwlen   : integer range 0 to 15     := 0;  -- Maximum word length

    netlist   : integer                   := 0;  -- Use netlist (tech)

    syncram   : integer range 0 to 1      := 1;  -- Use SYNCRAM for buffers
    memtech   : integer                   := 0;  -- Memory technology
    ft        : integer range 0 to 2      := 0;  -- Fault-Tolerance
    scantest  : integer range 0 to 1      := 0;  -- Scan test support
    syncrst   : integer range 0 to 1      := 0;  -- Use only sync reset
    automask0 : integer                   := 0;  -- Mask 0 for automated transfers
    automask1 : integer                   := 0;  -- Mask 1 for automated transfers
    automask2 : integer                   := 0;  -- Mask 2 for automated transfers
    automask3 : integer                   := 0;  -- Mask 3 for automated transfers
    ignore    : integer range 0 to 1      := 0;  -- Ignore samples
    prot      : integer range 0 to 2      := 0   -- 0: Legacy, 1: dual, 2: quad
    );
    port(
      rstn          : in std_ulogic;
      clk           : in std_ulogic;
      -- APB signals
      apbi_psel     : in  std_ulogic;
      apbi_penable  : in  std_ulogic;
      apbi_paddr    : in  std_logic_vector(31 downto 0);
      apbi_pwrite   : in  std_ulogic;
      apbi_pwdata   : in  std_logic_vector(31 downto 0);
      apbi_testen   : in  std_ulogic;
      apbi_testrst  : in  std_ulogic;
      apbi_scanen   : in  std_ulogic;
      apbi_testoen  : in  std_ulogic;
      apbo_prdata   : out std_logic_vector(31 downto 0);
      apbo_pirq     : out std_logic_vector(NAHBIRQ-1 downto 0);
      -- SPI signals
      spii_miso     : in  std_ulogic;
      spii_mosi     : in  std_ulogic;
      spii_sck      : in  std_ulogic;
      spii_spisel   : in  std_ulogic;
      spii_astart   : in  std_ulogic;
      spii_cstart   : in  std_ulogic;
      spii_ignore   : in  std_ulogic;
      spii_io2      : in  std_ulogic;
      spii_io3      : in  std_ulogic;
      spio_miso     : out std_ulogic;
      spio_misooen  : out std_ulogic;
      spio_mosi     : out std_ulogic;
      spio_mosioen  : out std_ulogic;
      spio_sck      : out std_ulogic;
      spio_sckoen   : out std_ulogic;
      spio_enable   : out std_ulogic;
      spio_astart   : out std_ulogic;
      spio_aready   : out std_ulogic;
      spio_io2      : out std_ulogic;
      spio_io2oen   : out std_ulogic;
      spio_io3      : out std_ulogic;
      spio_io3oen   : out std_ulogic;
      slvsel        : out std_logic_vector((slvselsz-1) downto 0));	  
end entity spi_wrap;



architecture rtl of spi_wrap is
component spictrl
  generic (
    -- APB generics
    pindex : integer := 0;                -- slave bus index
    paddr  : integer := 0;                -- APB address
    pmask  : integer := 16#fff#;          -- APB mask
    pirq   : integer := 0;                -- interrupt index

    -- SPI controller configuration
    fdepth    : integer range 1 to 7      := 1;  -- FIFO depth is 2^fdepth
    slvselen  : integer range 0 to 1      := 0;  -- Slave select register enable
    slvselsz  : integer range 1 to 32     := 1;  -- Number of slave select signals
    oepol     : integer range 0 to 1      := 0;  -- Output enable polarity
    odmode    : integer range 0 to 1      := 0;  -- Support open drain mode, only
                                                -- set if pads are i/o or od pads.
    automode  : integer range 0 to 1      := 0;  -- Enable automated transfer mode
    acntbits  : integer range 1 to 32     := 32; -- # Bits in am period counter
    aslvsel   : integer range 0 to 1      := 0;  -- Automatic slave select
    twen      : integer range 0 to 1      := 1;  -- Enable three wire mode
    maxwlen   : integer range 0 to 15     := 0;  -- Maximum word length

    netlist   : integer                   := 0;  -- Use netlist (tech)

    syncram   : integer range 0 to 1      := 1;  -- Use SYNCRAM for buffers
    memtech   : integer                   := 0;  -- Memory technology
    ft        : integer range 0 to 2      := 0;  -- Fault-Tolerance
    scantest  : integer range 0 to 1      := 0;  -- Scan test support
    syncrst   : integer range 0 to 1      := 0;  -- Use only sync reset
    automask0 : integer                   := 0;  -- Mask 0 for automated transfers
    automask1 : integer                   := 0;  -- Mask 1 for automated transfers
    automask2 : integer                   := 0;  -- Mask 2 for automated transfers
    automask3 : integer                   := 0;  -- Mask 3 for automated transfers
    ignore    : integer range 0 to 1      := 0;  -- Ignore samples
    prot      : integer range 0 to 2      := 0   -- 0: Legacy, 1: dual, 2: quad
    );
	  port (
    rstn   : in std_ulogic;
    clk    : in std_ulogic;

    -- APB signals
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;

    -- SPI signals
    spii   : in  spi_in_type;
    spio   : out spi_out_type;
    slvsel : out std_logic_vector((slvselsz-1) downto 0)
    );
    end component;

        signal apbi_int : apb_slv_in_type;
        signal apbo_int : apb_slv_out_type;
        
        signal spii_int : spi_in_type;
        signal spio_int : spi_out_type;  
        
        
    begin
    
    rtlc :  spictrl
     generic map (
        pindex  => pindex,               -- slave bus index
        paddr   => paddr,                -- APB address
        pmask   => pmask,                -- APB mask
        pirq    => pirq,                 -- interrupt index

        -- SPI controller configuration
        fdepth    => fdepth,  -- FIFO depth is 2^fdepth
        slvselen  => slvselen,  -- Slave select register enable
        slvselsz  => slvselsz,   -- Number of slave select signals
        oepol     => oepol   ,   -- Output enable polarity
        odmode    => odmode  ,   -- Support open drain mode, only
                                 -- set if pads are i/o or od pads.
        automode  => automode,   -- Enable automated transfer mode
        acntbits  => acntbits,  -- # Bits in am period counter
        aslvsel   => aslvsel ,   -- Automatic slave select
        twen      => twen    ,   -- Enable three wire mode
        maxwlen   => maxwlen ,   -- Maximum word length
   
        netlist   => netlist ,   -- Use netlist (tech)
        
        syncram   => syncram ,   -- Use SYNCRAM for buffers
        memtech   => memtech ,   -- Memory technology
        ft        => ft      ,   -- Fault-Tolerance
        scantest  => scantest,   -- Scan test support
        syncrst   => syncrst ,   -- Use only sync reset
        automask0 => automask0,  -- Mask 0 for automated transfers
        automask1 => automask1,  -- Mask 1 for automated transfers
        automask2 => automask2,  -- Mask 2 for automated transfers
        automask3 => automask3,  -- Mask 3 for automated transfers
        ignore    => ignore   ,  -- Ignore samples
        prot      => prot)       -- 0: Legacy, 1: dual, 2: quad
    
	  port map (
	  rstn => rstn,
	  clk  => clk,
	  
	  
	  apbi => apbi_int,
	  apbo => apbo_int,
	  spii => spii_int,
	  spio => spio_int);

        -- APB signals
        apbi_int.psel(pindex) <= apbi_psel;
        apbi_int.penable <= apbi_penable;
        apbi_int.paddr   <= apbi_paddr;
        apbi_int.pwrite  <= apbi_pwrite;
        apbi_int.pwdata  <= apbi_pwdata;
        apbi_int.testen  <= apbi_testen;
        apbi_int.testrst <= apbi_testrst;
        apbi_int.scanen  <= apbi_scanen;
        apbi_int.testoen <= apbi_testoen;
        apbo_prdata  <= apbo_int.prdata;
        apbo_pirq    <= apbo_int.pirq;
        -- SPI signals
        spii_int.miso    <= spii_miso;
        spii_int.mosi    <= spii_mosi;
        spii_int.sck     <= spii_sck;
        spii_int.spisel  <= spii_spisel;
        spii_int.astart  <= spii_astart;
        spii_int.cstart  <= spii_cstart;
        spio_miso    <= spio_int.miso;
        spio_misooen <= spio_int.misooen;
        spio_mosi    <= spio_int.mosi;
        spio_mosioen <= spio_int.mosioen;
        spio_sck     <= spio_int.sck;
        spio_sckoen  <= spio_int.sckoen;
        spio_enable  <= spio_int.enable;
        spio_astart  <= spio_int.astart;
        spio_aready  <= spio_int.aready;
    end architecture rtl;
        