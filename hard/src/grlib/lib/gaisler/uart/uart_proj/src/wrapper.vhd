library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.config_types.all;
use grlib.config.all;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.uart.all;
use std.textio.all;


entity apbuart_wrapper is
 generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    console  : integer := 0;
    pirq     : integer := 0;
    parity   : integer := 1;
    flow     : integer := 1;
    fifosize : integer range 1 to 32 := 1;
    abits    : integer := 8;
    sbits    : integer range 12 to 32 := 12);
 port (
  	rst                     : in  std_logic;
	clk                     : in  std_logic;

    psel        			: in  std_logic_vector(0 to NAPBSLV-1);     -- slave select
    penable     			: in  std_ulogic;                           -- strobe
    paddr       			: in  std_logic_vector(31 downto 0);        -- address bus (byte)
    pwrite      			: in  std_ulogic;                           -- write
    pwdata      			: in  std_logic_vector(31 downto 0);        -- write data bus
    pirq        			: in  std_logic_vector(NAHBIRQ-1 downto 0); -- interrupt result bus
    testen      			: in  std_ulogic;                           -- scan test enable
    testrst     			: in  std_ulogic;                          -- scan test reset
    scanen      			: in  std_ulogic;                           -- scan enable
    testoen     			: in  std_ulogic;                           -- test output enable
    testin      			: in  std_logic_vector(NTESTINBITS-1 downto 0);         -- test vector for syncrams

    prdata      			: out std_logic_vector(31 downto 0);        -- read data bus
    pirq        			: out std_logic_vector(NAHBIRQ-1 downto 0); -- interrupt bus
	
	rxd   					: in  std_ulogic;
	ctsn   					: in  std_ulogic;
	extclk					: in  std_ulogic;
	
	rtsn   					: out  std_ulogic;
	txd   					: out  std_ulogic;
	scaler					: out  std_logic_vector(31 downto 0);
	txen     				: out  std_ulogic;
	flow   					: out  std_ulogic;
	rxen     				: out  std_ulogic;
	txtick        			: out  std_ulogic;
	rxtick        			: out  std_ulogic;	
 end apbuart_wrapper;

architecture wrap of apbuart_wrapper is
 component apbuart is
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    uarti  : in  uart_in_type;
    uarto  : out uart_out_type);
end component;
begin
 UU1:apbuart
	port map (
		rst  =>  rst
		clk  =>  clk
			
		apbi => psel 
		apbi => penable  
		apbi => paddr    
		apbi => pwrite   
		apbi => pwdata   
		apbi => pirq     
		apbi => testen   
		apbi => testrst  
		apbi => scanen   
		apbi => testoen  
		apbi => testin  
				 
		apbo => prdata
		apbo => pirq  
		
		uarti  => rxd   
		uarti  => ctsn  
		uarti  => extclk
		
		uarto  => rtsn  
		uarto  => txd   
		uarto  => scaler
		uarto  => txen  
		uarto  => flow  
		uarto  => rxen  
		uarto  => txtick
		uarto  => rxtick

end architecture wrap	