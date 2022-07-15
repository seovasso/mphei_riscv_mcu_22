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
-- Entity: 	spi2ahb_wrp
-- File:	spi2ahb_wrp.vhd
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library grlib, techmap;
use grlib.amba.all;
use techmap.gencomp.all;
library gaisler;
use gaisler.misc.all;

entity spi2ahb_wrp is
  generic (
    hindex   : integer                := 0;
    ahbaddrh : integer                := 0;
    ahbaddrl : integer                := 0;
    ahbmaskh : integer                := 0;
    ahbmaskl : integer                := 0;
    resen    : integer range 0 to 1   := 0;
    pindex   : integer                := 0;
    paddr    : integer                := 0;
    filter   : integer range 2 to 512 := 2;
    cpol     : integer range 0 to 1   := 0;
    cpha     : integer range 0 to 1   := 0;
    pmask    : integer                := 16#fff#;
    oepol    : integer range 0 to 1   := 0;      -- Output enable polarity
    pirq     : integer                := 0
  );

  port (
  rstn     : in  std_logic;
  clk      : in  std_logic;
  -- AHB master interface
  ahbi     : in  ahb_mst_in_type;
  ahbo     : out ahb_mst_out_type;
  apbi     : in  apb_slv_in_type;
  apbo     : out apb_slv_out_type;
  -- SPI signals
  spii     : in  spi_in_type;
  spio     : out spi_out_type;
  --spi_in_type
  miso     : in  std_logic;
  mosi     : in  std_logic;
  sck      : in  std_logic;
  spisel   : in  std_logic;
  astart   : in  std_logic;
  cstart   : in  std_logic;
  ignore   : in  std_logic;
  io2      : in  std_logic;
  io3      : in  std_logic;
  --spi_out_type
  miso     : out std_logic;
  misooen  : out std_logic;
  mosi     : out std_logic;
  mosioen  : out std_logic;
  sck      : out std_logic;
  sckoen   : out std_logic;
  enable   : out std_logic;
  astart   : out std_logic;
  aready   : out std_logic;
  io2      : out std_logic;
  io2oen   : out std_logic;
  io3      : out std_logic;
  io3oen   : out std_logic;
  );
end entity spi2ahb_wrp;

architecture rtl of spi2ahb_wrp is
  component spi2ahb
    generic (
      hindex   : integer                := 0;
      ahbaddrh : integer                := 0;
      ahbaddrl : integer                := 0;
      ahbmaskh : integer                := 0;
      ahbmaskl : integer                := 0;
      resen    : integer range 0 to 1   := 0;
      pindex   : integer                := 0;
      paddr    : integer                := 0;
      filter   : integer range 2 to 512 := 2;
      cpol     : integer range 0 to 1   := 0;
      cpha     : integer range 0 to 1   := 0;
      pmask    : integer                := 16#fff#;
      oepol    : integer range 0 to 1   := 0;      -- Output enable polarity
      pirq     : integer                := 0
    );
    port (
      rstn     : in  std_logic;
      clk      : in  std_logic;
      -- AHB master interface
      ahbi     : in  ahb_mst_in_type;
      ahbo     : out ahb_mst_out_type;
      apbi     : in  apb_slv_in_type;
      apbo     : out apb_slv_out_type;
      -- SPI signals
      spii     : in  spi_in_type;
      spio     : out spi_out_type;
    );
  end component
  
  signal rstn    : std_logic;
  -- AMBA signals
  signal apbi    : apb_slv_in_type;
  signal apbo    : apb_slv_out_vector;
  signal ahbmi   : ahb_mst_in_type;
  signal ahbmo   : ahb_mst_out_vector;
  -- SPI signals
  signal spislvi : spi_in_type;
  signal spislvo : spi_out_type;

  begin
    u_spi2ahb : spi2ahb
    generic map(
      hindex   => hindex  ,
      ahbaddrh => ahbaddrh,
      ahbaddrl => ahbaddrl,
      ahbmaskh => ahbmaskh,
      ahbmaskl => ahbmaskl,
      resen    => resen   ,
      pindex   => pindex  ,
      paddr    => paddr   ,
      filter   => filter  ,
      cpol     => cpol    ,
      cpha     => cpha    ,
      pmask    => pmask   ,
      oepol    => oepol   ,
      pirq     => pirq    ,
    )
    port map(
      rstn => rstn, 
      clk  => clk ,

      ahbi => ahbi,
      ahbo => ahbo,
      apbi => apbi,
      apbo => apbo,
  
      spii => spii,
      spio => spio,
    );

    rstn         <=  rstn       ;
    --spi_in_type 
    spii.miso    <= spii_miso   ;
    spii.mosi    <= spii_mosi   ;
    spii.sck     <= spii_sck    ;
    spii.spisel  <= spii_spisel ;
    spii.astart  <= spii_astart ;
    spii.cstart  <= spii_cstart ;
    spii.ignore  <= spii_ignore ;
    spii.io2     <= spii_io2    ;
    spii.io3     <= spii_io3    ;
    --spi_out_type
    spio_miso    <= spio.miso   ;
    spio_misooen <= spio.misooen;
    spio_mosi    <= spio.mosi   ;
    spio_mosioen <= spio.mosioen;
    spio_sck     <= spio.sck    ;
    spio_sckoen  <= spio.sckoen ;
    spio_enable  <= spio.enable ;
    spio_astart  <= spio.astart ;
    spio_aready  <= spio.aready ;
    spio_io2     <= spio.io2    ;
    spio_io2oen  <= spio.io2oen ;
    spio_io3     <= spio.io3    ;
    spio_io3oen  <= spio.io3oen ;

  end;


-- begin
--   -- AMBA Components are instantiated here
--   ...
--   -- SPI to AHB bridge
--   spibridge : if CFG_SPI2AHB /= 0 generate
--   withapb : if CFG_SPI2AHB_APB /= 0 generate
--   spi2ahb0 : spi2ahb_apb
--     generic map(
--       hindex   => 10,
--       ahbaddrh => CFG_SPI2AHB_ADDRH, 
--       ahbaddrl => CFG_SPI2AHB_ADDRL,
--       ahbmaskh => CFG_SPI2AHB_MASKH, 
--       ahbmaskl => CFG_SPI2AHB_MASKL,
--       resen    => CFG_SPI2AHB_RESEN, 
--       pindex   => 11, 
--       paddr    => 11, 
--       pmask    => 16#fff#,
--       pirq     => 11, 
--       filter   => CFG_SPI2AHB_FILTER, 
--       cpol     => CFG_SPI2AHB_CPOL,
--       cpha     => CFG_SPI2AHB_CPHA
--     )
--     port map (
--       rstn, 
--       clkm, 
--       ahbmi, 
--       ahbmo(10),
--       apbi, 
--       apbo(11), 
--       spislvi, 
--       spislvo
--     );
--   end generate;

--   woapb : if CFG_SPI2AHB_APB = 0 generate
--   spi2ahb0 : spi2ahb
--     generic map(
--       hindex => 10,
--       ahbaddrh => CFG_SPI2AHB_ADDRH, 
--       ahbaddrl => CFG_SPI2AHB_ADDRL,
--       ahbmaskh => CFG_SPI2AHB_MASKH, 
--       ahbmaskl => CFG_SPI2AHB_MASKL,
--       filter => CFG_SPI2AHB_FILTER,
--       cpol => CFG_SPI2AHB_CPOL, 
--       cpha => CFG_SPI2AHB_CPHA
--       )
--     port map (
--       rstn, 
--       clkm, 
--       ahbmi, 
--       ahbmo(10),
--       spislvi, 
--       spislvo
--     );
--   end generate;

--   spislv_miso_pad : iopad 
--   generic map (tech => padtech)
--   port map (
--     miso, 
--     spislvo.miso, 
--     spislvo.misooen, 
--     spislvi.miso
--   );

--   spislvl_mosi_pad : inpad 
--   generic map (tech => padtech)
--   port map (
--     miso, 
--     spislvi.mosi
--   );

--   spislv_sck_pad : inpad 
--   generic map (tech => padtech)
--   port map (
--     sck, 
--     pislvi.sck
--   );

--   spislv_slvsel_pad : iopad 
--   generic map (tech => padtech)
--   port map (
--     sel, 
--     spislvi.spisel
--   );
--   end generate;

--   nospibridge : if CFG_SPI2AHB = 0 or CFG_SPI2AHB_APB = 0 generate
--   apbo(11) <= apb_none;
--   end generate;
-- end;