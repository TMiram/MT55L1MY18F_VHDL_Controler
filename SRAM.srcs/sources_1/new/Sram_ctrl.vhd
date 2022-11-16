----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2022 15:08:53
-- Design Name: 
-- Module Name: Sram_ctrl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

--========================================================
--Beggining of libraries
--========================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

LIBRARY ieee;
    USE ieee.std_logic_1164.all;
    USE ieee.std_logic_unsigned.all;
--end of libraries    
    
    
--========================================================
--Beggining of entity
--========================================================
entity Sram_ctrl is
    GENERIC(
        addr_bits : INTEGER := 19;
        data_bits : INTEGER := 36
    );
    Port (         
        Clk_in    : IN STD_LOGIC;
        
    --USER'S PINS (on USER's side)
    
        --USER's data (read and write) and address PINS
        D_in      : IN STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);
        Addr_req  : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);
        D_out     : OUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);

        
        --STATE MACHINE control PINS
        WRITE     : IN STD_LOGIC;
        READ      : IN STD_LOGIC;
        BURST      : IN STD_LOGIC;
        
    --PINS for SRAM SIGNALS (on SRAM side)
    
        --DATA and Address PINS
        Dq        : INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);    -- Data I/O
        Addr      : OUT    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);   -- Address
        
        --Control PINS
        Lbo_n     : OUT    STD_LOGIC;                                   -- Burst Mode
        Cke_n     : OUT    STD_LOGIC;                                   -- Cke#
        Ld_n      : OUT    STD_LOGIC;                                   -- Adv/Ld#
        Bwa_n     : OUT    STD_LOGIC;                                   -- Bwa#
        Bwb_n     : OUT    STD_LOGIC;                                   -- BWb#
        Bwc_n     : OUT    STD_LOGIC;                                   -- Bwc#
        Bwd_n     : OUT    STD_LOGIC;                                   -- BWd#
        Rw_n      : OUT    STD_LOGIC;                                   -- RW#
        Oe_n      : OUT    STD_LOGIC;                                   -- OE#
        Ce_n      : OUT    STD_LOGIC;                                   -- CE#
        Ce2_n     : OUT    STD_LOGIC;                                   -- CE2#
        Ce2       : OUT    STD_LOGIC;                                   -- CE2
        Zz        : OUT    STD_LOGIC                                    --(sleep mode)
            );
end Sram_ctrl;
--END of Entity

--========================================================
--Beggining of architecture
--========================================================
 architecture Behavioral of Sram_ctrl is

--======================
--COMPONENTS DECLARATION
--======================
    
    --IOBUFF generic component : TRISTATE
component tristate 
    port (
       STATE        : in STD_LOGIC; --0 is WRITE ; 1 is READ
       DATA_WRITE   : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
       DATA_READ    : out STD_LOGIC_VECTOR (data_bits-1 downto 0);
       DATA_IO      : inout STD_LOGIC_VECTOR (data_bits-1 downto 0)
    );
    end component;

--==============================
-- END OF COMPONENTS DECLARATION
--==============================


        --CONSTANTS  AND SIGNALS DECLARATION
constant    zero_sig             : STD_LOGIC := '0';

signal      D_in_sig_delay_one    : STD_LOGIC_VECTOR(data_bits - 1 DOWNTO 0); -- DLatch for input data to match the state signal delay
signal      D_in_sig_delay_two    : STD_LOGIC_VECTOR(data_bits - 1 DOWNTO 0); -- DLatch for input data to match the state signal delay
signal      D_out_sig_delay       : STD_LOGIC_VECTOR(data_bits - 1 DOWNTO 0); -- DLatch for input data to match the state signal delay

signal      Addr_sig_delay_one   : STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0); -- signal for latches 

--delaying these signals 3 times
signal      control_sig_delay_one: STD_LOGIC_VECTOR (4 DOWNTO 0);

signal      state_signal         : STD_LOGIC;

--for burst mode:
signal      previous_state_read  : STD_LOGIC := '0';
signal      previous_state_write : STD_LOGIC := '0';

        --END OF CONSTANTS AND SIGNALS DECLARATION
        
--BEGINNING
begin   

    --TRISTATE COMPONENT GENERATION
TRI: tristate port map (
       STATE        => state_signal,
       DATA_WRITE   => D_in_sig_delay_two,
       DATA_READ    => D_out_sig_delay,
       DATA_IO      => Dq
    );
    
--INITIALIZING CONSTANT SIGNALS (no need to delay as they are constants)
Bwa_n <= zero_sig;
Bwb_n <= zero_sig;
Bwc_n <= zero_sig;
Bwd_n <= zero_sig;
Zz    <= zero_sig;
Lbo_n <= zero_sig;
Cke_n <= zero_sig;
Oe_n  <= zero_sig;  --not sure about that one


--===============
-- MAIN PROCESS
--===============

main : process (CLK_in)
begin
    if( falling_edge(Clk_in))
    then
    
        if(READ = '1')                  --READ (read=1, write=0 or 1)
        then
            Addr <= Addr_req;
            --state read
            D_in_sig_delay_one         <= D_in;
            D_in_sig_delay_two         <= D_in_sig_delay_one;
            state_signal           <= '1';
            D_out<=D_out_sig_delay;        
               
            --delaying control signals 1 time
            Ld_n     <=  '0';--Ld_n                   <= '0';
            Rw_n     <=  '1';--Rw_n                   <= '1';
            Ce_n     <=  '0';--Ce_n                   <= '0';
            Ce2_n    <=  '0';--Ce2_n                  <= '0';
            Ce2      <=  '1';--Ce2                    <= '1';
            
        
        elsif(WRITE = '1')              --WRITE (read=0, write=1)
        then
            Addr <= Addr_req;
            --state write
            D_in_sig_delay_one         <= D_in;
            D_in_sig_delay_two         <= D_in_sig_delay_one;
            state_signal               <= '0';
            
                        --delaying control signals 1 time
            Ld_n     <=  '0';--Ld_n                   <= '0';
            Rw_n     <=  '0';--Rw_n                   <= '1';
            Ce_n     <=  '0';--Ce_n                   <= '0';
            Ce2_n    <=  '0';--Ce2_n                  <= '0';
            Ce2      <=  '1';--Ce2                    <= '1';
            
            
          
        else                            --DESELECT (read and write =0)
            Addr <= Addr_req; 
            --state deselect          
            Ld_n     <=  '0';--Ld_n                   <= '0';
            Rw_n     <=  '0';--Rw_n                   <= '1';
            Ce_n     <=  '1';--Ce_n                   <= '0';
            Ce2_n    <=  '1';--Ce2_n                  <= '0';
            Ce2      <=  '0';--Ce2                    <= '1';
        
        end if;
        
      
        
    

        
    --D-LATCH to memorize previous states on READ and WRITE pins
    previous_state_read  <= READ;
    previous_state_write <= WRITE;
    
    end if;
end process;
--====================
-- END OF MAIN PROCESS
--====================

end Behavioral;
--========================================================
--end of of architecture
--========================================================

--EOF
