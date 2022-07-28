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
    const_pindex   : integer := 0;
    const_paddr    : integer := 0;
    const_pmask    : integer := 16#fff#;
    const_console  : integer := 0;
    const_pirq     : integer := 0;
    const_parity   : integer := 1;
    const_flow     : integer := 1;
    const_fifosize : integer range 1 to 32 := 1;
    const_abits    : integer := 8;
    const_sbits    : integer range 12 to 32 := 12
	);
 port (
  	rst                     : in  std_logic;
	clk                     : in  std_logic;

------APB input
    psel        			: in  std_logic_vector(0 to NAPBSLV-1);     			-- slave select
    penable     			: in  std_ulogic;                           			-- strobe
    paddr       			: in  std_logic_vector(31 downto 0);        			-- address bus (byte)
    pwrite      			: in  std_ulogic;                           			-- write
    pwdata      			: in  std_logic_vector(31 downto 0);        			-- write data bus
    pirq_i        			: in  std_logic_vector(NAHBIRQ-1 downto 0); 			-- interrupt result bus
    testen      			: in  std_ulogic;                           			-- scan test enable
    testrst     			: in  std_ulogic;                          				-- scan test reset
    scanen      			: in  std_ulogic;                           			-- scan enable
    testoen     			: in  std_ulogic;                           			-- test output enable
    testin      			: in  std_logic_vector(NTESTINBITS-1 downto 0);         -- test vector for syncrams

------APB output
    prdata      			: out std_logic_vector(31 downto 0);        			-- read data bus
    pirq_o        			: out std_logic_vector(NAHBIRQ-1 downto 0); 			-- interrupt bus
	pconfig     			: out apb_config_type;         
	pindex      			: out integer range 0 to NAPBSLV -1;

------UART input	
	rxd   					: in  std_ulogic;
	ctsn   					: in  std_ulogic;
	extclk					: in  std_ulogic;

------UART output	
	rtsn   					: out  std_ulogic;
	txd   					: out  std_ulogic;
	scaler					: out  std_logic_vector(31 downto 0);
	txen     				: out  std_ulogic;
	flow   					: out  std_ulogic;
	rxen     				: out  std_ulogic;
	txtick        			: out  std_ulogic;
	rxtick        			: out  std_ulogic	
	);
 end;

architecture wrap of apbuart_wrapper is
 component apbuart is
 generic(
	pindex   : integer := 0; 
	paddr    : integer := 0; 
	pmask    : integer := 16#fff#; 
	console  : integer := 0; 
	pirq     : integer := 0; 
	parity   : integer := 1; 
	flow     : integer := 1; 
	fifosize : integer range 1 to 32 := 1; 
	abits    : integer := 8; 
	sbits    : integer range 12 to 32 := 12
	); 
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    uarti  : in  uart_in_type;
    uarto  : out uart_out_type
	);
	
end component;

signal rstn : STD_LOGIC;

begin
 UU1:apbuart
	generic map(
		pindex 		=>   const_pindex, 	
		paddr 		=>   const_paddr,
		pmask 		=>   const_pmask, 	
	    console 	=>   const_console, 
	    pirq 		=>   const_pirq, 	 
	    parity 		=>   const_parity, 	
	    flow 		=>   const_flow, 	 
	    fifosize 	=>   const_fifosize,
	    abits 		=>   const_abits, 	
	    sbits 		=>   const_sbits	
)
	port map (
		rst  =>  rstn,
		clk  =>  clk,

------APB input			
		apbi.psel => psel, 
		apbi.penable => penable,  
		apbi.paddr  => paddr,    
		apbi.pwrite  => pwrite,   
		apbi.pwdata  => pwdata,   
		apbi.pirq  => pirq_i,     
		apbi.testen => testen,   
		apbi.testrst => testrst,  
		apbi.scanen => scanen,   
		apbi.testoen => testoen,  
		apbi.testin => testin,  

------APB output				 
		apbo.prdata => prdata,
		apbo.pirq => pirq_o,
		apbo.pconfig => pconfig, 		
		apbo.pindex => pindex,

------UART input			
		uarti.rxd  => rxd,   
		uarti.ctsn  => ctsn,  
		uarti.extclk  => extclk,

------UART output		
		uarto.rtsn  => rtsn,  
		uarto.txd  => txd,   
		uarto.scaler  => scaler,
		uarto.txen  => txen, 
		uarto.flow   => flow,  
		uarto.rxen  => rxen,  
		uarto.txtick  => txtick,
		uarto.rxtick  => rxtick
);

rstn <= not rst;

end architecture wrap;