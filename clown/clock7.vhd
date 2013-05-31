--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 13.1
--  \   \         Application : xaw2vhdl
--  /   /         Filename : pal_clock.vhd
-- /___/   /\     Timestamp : 07/03/2011 22:42:49
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-intstyle /home/ben/prog/vhdl/pal/ipcore_dir/pal_clock.xaw -st pal_clock.vhd
--Design Name: pal_clock
--Device: xc3s500e-4vq100
--
-- Module pal_clock
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- Period Jitter (unit interval) for block DCM_SP_INST = 0.05 UI
-- Period Jitter (Peak-to-Peak) for block DCM_SP_INST = 0.76 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity clock7 is
   port ( CLKIN_IN  : in    std_logic; 
          CLKFX_OUT : out   std_logic);
end clock7;

architecture BEHAVIORAL of clock7 is
   signal CLKFB_IN  : std_logic;
   signal CLKFX_BUF : std_logic;
   signal CLK0_BUF  : std_logic;
   signal GND_BIT   : std_logic;
begin
   GND_BIT <= '0';
   CLKFX_BUFG_INST : BUFG
      port map (I=>CLKFX_BUF,
                O=>CLKFX_OUT);
   
   CLK0_BUFG_INST : BUFG
      port map (I=>CLK0_BUF,
                O=>CLKFB_IN);
   
   DCM_SP_INST : DCM_SP
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.0,
            CLKFX_DIVIDE => 25,
            CLKFX_MULTIPLY => 7,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 20.0,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>CLKFB_IN,
                CLKIN=>CLKIN_IN,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>GND_BIT,
                CLKDV=>open,
                CLKFX=>CLKFX_BUF,
                CLKFX180=>open,
                CLK0=>CLK0_BUF,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>open,
                PSDONE=>open,
                STATUS=>open);
   
end BEHAVIORAL;