-------------------------------------------------------------------------------
-- Title      : DMT modulator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dmt_mod.vhd
-- Author     : 
-- Company    : 
-- Created    : 2004-05-17
-- Last update: 2004-06-10
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2004 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2004-05-17  1.0      guenter Created
-------------------------------------------------------------------------------

  library ieee;
  use ieee.std_logic_1164.all;

  entity dmt_mod is
    generic (
      width : integer := 16);           -- data out width
    port (
      clk_i        : in  std_logic;
      rst_i        : in  std_logic;
      data_en_i    : in  std_logic;
      data_i       : in  std_logic_vector(14 downto 0);
      conf_we_i    : in  std_logic;
      bin_addr_i   : in  std_logic_vector(7 downto 0);
      const_size_i : in  std_logic_vector(3 downto 0);
      gain_i       : in  std_logic_vector(11 downto 0);
      tx_clk_i     : in  std_logic;
      rd_en_i      : in  std_logic;
      rd_empty_o   : out std_logic;
      data_o       : out std_logic_vector(width-1 downto 0));

  end dmt_mod;

  architecture arch of dmt_mod is

  begin  -- arch



  end arch;
