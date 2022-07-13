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
    nbits    : integer range 0 to 32 := 8;			-- GPIO bits
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
    rst           : in  std_ulogic;
    clk           : in  std_ulogic;
    -- APB slave inputs
    apbi_psel     : in  std_ulogic;
    apbi_penable  : in  std_ulogic;
    apbi_paddr    : in  std_logic_vector(31 downto 0);
    apbi_pwrite   : in  std_ulogic;
    apbi_pwdata   : in  std_logic_vector(31 downto 0);
    apbi_testen   : in  std_ulogic;
    apbi_testrst  : in  std_ulogic;
    apbi_scanen   : in  std_ulogic;
    apbi_testoen  : in  std_ulogic;
    -- APB slave outputs
    apbo_prdata   : out std_logic_vector(31 downto 0);
    apbo_pirq     : out std_ulogic;
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
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
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

--signal apbo_pirq : std_ulogic;
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
  gpioi.din     <= gpioi_din;
  gpioi.sig_in  <= gpioi_sig_in;
  gpioi.sig_en  <= gpioi_sig_en;

  gpioo_dout    <= gpioo.dout;
  gpioo_oen     <= gpioo.oen;
  gpioo_val     <= gpioo.val;
  gpioo_sig_out <= gpioo.sig_out;

end;
--     port map (
--       rstn         => rstn,
--       clk          => clk,
--       -- APB signals
--       apbi_psel    => apbi.psel(pindex),
--       apbi_penable => apbi.penable,
--       apbi_paddr   => apbi.paddr,
--       apbi_pwrite  => apbi.pwrite,
--       apbi_pwdata  => apbi.pwdata,
--       apbi_testen  => apbi.testen,
--       apbi_testrst => apbi.testrst,
--       apbi_scanen  => apbi.scanen,
--       apbi_testoen => apbi.testoen,
--       apbo_prdata  => apbo.prdata,
--       apbo_pirq    => apbo.pirq,
--     -- GPIO signals  



-- ctrl_netlist : if netlist /= 0 generate
--   netlc :  grgpio_net
--     port map (
--       rstn         => rstn,
--       clk          => clk,
-- -- APB signals
--       apbi_psel    => apbi.psel(pindex),
--       apbi_penable => apbi.penable,
--       apbi_paddr   => apbi.paddr,
--       apbi_pwrite  => apbi.pwrite,
--       apbi_pwdata  => apbi.pwdata,
--       apbi_testen  => apbi.testen,
--       apbi_testrst => apbi.testrst,
--       apbi_scanen  => apbi.scanen,
--       apbi_testoen => apbi.testoen,
--       apbo_prdata  => apbo.prdata,
--       apbo_pirq    => apbo.pirq,
-- end generate ctrl_netlist;

--   --Signals

-- signal gpti : gptimer_in_type;
-- begin
--   gpio0 : if CFG_GRGPIO_EN /= 0 generate -- GR GPIO unit
--   grgpio0: grgpio
--   generic map( 
--     pindex       => 11, 
--     paddr        => 11, 
--     imask        => CFG_GRGPIO_IMASK, 
--     nbits        => 8)
--   port map( 
--     rstn         => rstn,
--     clk          => clk, 
--     apbi, 
--     apbo(11), 
--     gpioi, 
--     gpioo);
  
--   pio_pads : for i in 0 to 7 generate
--   pio_pad : iopad 
--   generic map (
--     tech         => padtech)
--   port map (
--     gpio(i), 
--     gpioo.dout(i), 
--     gpioo.oen(i), 
--     gpioi.din(i));
--   end generate;