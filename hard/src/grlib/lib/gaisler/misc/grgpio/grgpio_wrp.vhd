------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2015 - 2022, Cobham Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-----------------------------------------------------------------------------
-- Entity: 	grgpio
-- File:	grgpio.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	Scalable general-purpose I/O port
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.config_types.all;
use grlib.config.all;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
--pragma translate_off
use std.textio.all;
--pragma translate_on

entity grgpio_wrp is
  generic (
    pindex   : integer               := 0;
    paddr    : integer               := 0;
    pmask    : integer               := 16#fff#;
    imask    : integer               := 16#0000#;
    nbits    : integer range 0 to 32 := 8;		-- GPIO bits
    oepol    : integer range 0 to 1  := 0;      -- Output enable polarity
    syncrst  : integer range 0 to 1  := 0;      -- Only synchronous reset
    bypass   : integer               := 16#0000#;
    scantest : integer range 0 to 1  := 0;
    bpdir    : integer               := 16#0000#;
    pirq     : integer               := 0;
    irqgen   : integer               := 0;
    iflagreg : integer range 0 to 1  := 0;
    bpmode   : integer range 0 to 1  := 0;
    inpen    : integer range 0 to 1  := 0;
    doutresv : integer               := 0;
    dirresv  : integer               := 0;
    bpresv   : integer               := 0;
    inpresv  : integer               := 0;
    pulse    : integer range 0 to 1  := 0
  );
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    -- APB slave inputs
    apbi_psel     : in  std_logic;
    apbi_penable  : in  std_logic;
    apbi_paddr    : in  std_logic_vector(31 downto 0);
    apbi_pwrite   : in  std_logic;
    apbi_pwdata   : in  std_logic_vector(31 downto 0);
    apbi_pirq     : in  std_logic_vector(NAHBIRQ-1 downto 0);
    apbi_testen   : in  std_logic;
    apbi_testrst  : in  std_logic;
    apbi_scanen   : in  std_logic;
    apbi_testoen  : in  std_logic;
    apbi_testin   : in  std_logic_vector(NTESTINBITS-1 downto 0);
    -- APB slave outputs
    apbo_prdata   : out std_logic_vector(31 downto 0);
    apbo_pirq     : out std_logic_vector(NAHBIRQ-1 downto 0); -- interrupt bus
    --GPIO slave inputs
    gpioi_din           : in  std_logic_vector(31 downto 0);
    gpioi_sig_in        : in  std_logic_vector(31 downto 0);
    gpioi_sig_en        : in  std_logic_vector(31 downto 0);
    --GPIO slave outputs
    gpioo_dout          : out std_logic_vector(31 downto 0);
    gpioo_oen           : out std_logic_vector(31 downto 0);
    gpioo_val           : out std_logic_vector(31 downto 0);
    gpioo_sig_out       : out std_logic_vector(31 downto 0));
end entity grgpio_wrp;

architecture rtl of grgpio_wrp is
--Components
component grgpio
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    imask    : integer := 16#0000#;
    nbits    : integer := 8;			-- GPIO bits
    oepol    : integer := 0;                    -- Output enable polarity
    syncrst  : integer := 0;                    -- Only synchronous reset
    bypass   : integer := 16#0000#;
    scantest : integer := 0;
    bpdir    : integer := 16#0000#;
    pirq     : integer := 0;
    irqgen   : integer := 0;
    iflagreg : integer range 0 to 1 := 0;
    bpmode   : integer range 0 to 1 := 0;
    inpen    : integer range 0 to 1 := 0;
    doutresv : integer := 0;
    dirresv  : integer := 0;
    bpresv   : integer := 0;
    inpresv  : integer := 0;
    pulse    : integer := 0
  );
  port (
    rst    : in  std_logic;
    clk    : in  std_logic;
    -- APB signals
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    -- GPIO signals
    gpioi  : in  gpio_in_type;
    gpioo  : out gpio_out_type
  );
end component  ;

signal apbi   :  apb_slv_in_type;
signal apbo   :  apb_slv_out_type;

signal gpioi  :  gpio_in_type;
signal gpioo  :  gpio_out_type;

signal rstn : std_logic;
begin
  u_grgpio : grgpio
  generic map(
    pindex   => pindex   ,
    paddr    => paddr    ,
    pmask    => pmask    ,
    imask    => imask    ,
    nbits    => nbits    ,
    oepol    => oepol    , 
    syncrst  => syncrst  , 
    bypass   => bypass   ,
    scantest => scantest ,
    bpdir    => bpdir    ,
    pirq     => pirq     ,
    irqgen   => irqgen   ,
    iflagreg => iflagreg ,
    bpmode   => bpmode   ,
    inpen    => inpen    ,
    doutresv => doutresv ,
    dirresv  => dirresv  ,
    bpresv   => bpresv   ,
    inpresv  => inpresv  ,
    pulse    => pulse    
  )
  port map(
    rst    => rstn  ,
    clk    => clk   ,

    apbi   => apbi  ,
    apbo   => apbo  ,

    gpioi  => gpioi ,
    gpioo  => gpioo 
  );
  rstn          <= not rst;

  apbi.psel (0) <= apbi_psel   ;
  apbi.penable  <= apbi_penable;
  apbi.pwrite   <= apbi_pwrite ;
  apbi.testen   <= apbi_testen ;
  apbi.testrst  <= apbi_testrst;
  apbi.scanen   <= apbi_scanen ;
  apbi.testoen  <= apbi_testoen; 
  apbi.paddr    <= apbi_paddr  ;
  apbi.pwdata   <= apbi_pwdata ;
  apbi.pirq     <= apbi_pirq   ;
  apbi.testin   <= apbi_testin ;
  
  apbo_prdata   <= apbo.prdata;
  apbo_pirq     <= apbo.pirq  ; 

  gpioi.din     <= gpioi_din;
  gpioi.sig_in  <= gpioi_sig_in;
  gpioi.sig_en  <= gpioi_sig_en;

  gpioo_dout    <= gpioo.dout;
  gpioo_oen     <= gpioo.oen;
  gpioo_val     <= gpioo.val;
  gpioo_sig_out <= gpioo.sig_out;

end;