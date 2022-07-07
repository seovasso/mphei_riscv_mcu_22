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

entity vhdl2verilog is
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
	
    port(
    rstn   : in std_ulogic;
    clk    : in std_ulogic;

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
    apbo_pirq     : out std_ulogic;
	
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
end entity vhdl2verilog;