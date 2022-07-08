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

architecture rtl of vhdl2verilog is
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
	
	begin
	port map (
        rstn         => rstn,
        clk          => clk,
        
        apbi.psel(pindex) =>  apbi_psel,    
        apbi.penable      =>  apbi_penable ,
        apbi.paddr        =>  apbi_paddr   ,
        apbi.pwrite       =>  apbi_pwrite  ,
        apbi.pwdata       =>  apbi_pwdata  ,
        apbi.testen       =>  apbi_testen  ,
        apbi.testrst      =>  apbi_testrst ,
        apbi.scanen       =>  apbi_scanen  ,
        apbi.testoen      =>  apbi_testoen ,
        apbo.prdata       =>  apbo_prdata  ,
        apbo_pirq         =>  apbo_pirq    ,
                              -- SPI signal
        spii.miso         =>  spii_miso    ,
        spii.mosi         =>  spii_mosi    ,
        spii.sck          =>  spii_sck     ,
        spii.spisel       =>  spii_spisel  ,
        spii.astart       =>  spii_astart  ,
        spii.cstart       =>  spii_cstart  ,
        spii.ignore       =>  spii_ignore  ,
        spii.io2          =>  spii_io2     ,
        spii.io3          =>  spii_io3     ,
        spio.miso         =>  spio_miso    ,
        spio.misooen      =>  spio_misooen ,
        spio.mosi         =>  spio_mosi    ,
        spio.mosioen     =>  spio_mosioen ,
        spio.sck          =>  spio_sck     ,
        spio.sckoen       =>  spio_sckoen  ,
        spio.enable       =>  spio_enable  ,
        spio.astart       =>  spio_astart  ,
        spio.aready       =>  spio_aready  ,
        spio.io2          =>  spio_io2     ,
        spio.io2oen       =>  spio_io2oen  ,
        spio.io3   	      =>  spio_io3     ,
        spio.io3oen       =>  spio_io3oen  ,
        slvsel            =>  slvsel);

end architecture rtl;
