--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
--Date        : Tue Nov 15 20:46:19 2022
--Host        : DESKTOP-0DAFOBK running 64-bit major release  (build 9200)
--Command     : generate_target SRAM_CTRL_wrapper.bd
--Design      : SRAM_CTRL_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SRAM_CTRL_wrapper is
end SRAM_CTRL_wrapper;

architecture STRUCTURE of SRAM_CTRL_wrapper is
  component SRAM_CTRL is
  end component SRAM_CTRL;
begin
SRAM_CTRL_i: component SRAM_CTRL
 ;
end STRUCTURE;
