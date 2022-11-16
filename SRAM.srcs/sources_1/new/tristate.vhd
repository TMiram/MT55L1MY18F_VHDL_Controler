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

entity tristate is
GENERIC(
        data_bits : INTEGER := 36
    );
    Port (
           STATE : in STD_LOGIC; --0 is WRITE ; 1 is READ
           DATA_WRITE : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           DATA_READ : out STD_LOGIC_VECTOR (data_bits-1 downto 0);
           DATA_IO : inout STD_LOGIC_VECTOR (data_bits-1 downto 0)
           );
end tristate;

architecture Behavioral of tristate is

component IOBUF
    port (
    I: in std_logic;
    IO: inout std_logic;
    T: in std_logic;
    O: out std_logic
    );
    end component;

begin

--génération de nos N (=data_bits) IOBUF pour avoir un IOBUF sur un bus 
generation: for j in 0 to data_bits-1 generate
    buff : IOBUF port map (
    I => DATA_WRITE(j),
    IO => DATA_IO(j), 
    T => STATE,
    O => DATA_READ(j)  
    );
end generate;
   
end Behavioral;
