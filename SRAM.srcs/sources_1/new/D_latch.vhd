----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2022 16:57:59
-- Design Name: 
-- Module Name: tristate - Behavioral
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


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
    use UNISIM.VComponents.all;
   
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Dlatch is
GENERIC(
        data_bits : INTEGER := 36
    );
    --no reset port as we don't need it
    Port ( CLK      : in STD_LOGIC;  
           D_in     : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           D_out    : out STD_LOGIC_VECTOR (data_bits-1 downto 0)
           );
end Dlatch;

architecture Behavioral of Dlatch is

begin
main : process (CLK)
begin
    if(falling_edge(CLK)) -- on falling edge as our main component is on falling edge too
    then
        D_out<=D_in;
    end if;
end process;
   
end Behavioral;
