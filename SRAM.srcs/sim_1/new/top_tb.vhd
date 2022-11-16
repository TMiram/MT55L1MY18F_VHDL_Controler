-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 15.11.2022 20:41:51 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture tb of tb_top is

    component top
        port (Clk        : in std_logic;
              WRITE      : in std_logic;
              READ       : in std_logic;
              BURST      : in std_logic;
              Data_write : in std_logic_vector (36 - 1 downto 0);
              Address    : in std_logic_vector (19 - 1 downto 0);
              Data_read  : out std_logic_vector (36 - 1 downto 0));
    end component;

    signal Clk        : std_logic;
    signal WRITE      : std_logic;
    signal READ       : std_logic;
    signal BURST      : std_logic;
    signal Data_write : std_logic_vector (36 - 1 downto 0);
    signal Address    : std_logic_vector (19 - 1 downto 0);
    signal Data_read  : std_logic_vector (36 - 1 downto 0);

    constant TbPeriod : time := 30 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '1';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top
    port map (Clk        => Clk,
              WRITE      => WRITE,
              READ       => READ,
              BURST      => BURST,
              Data_write => Data_write,
              Address    => Address,
              Data_read  => Data_read);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        WRITE <= '1';
        READ <= '0';
        Data_write <= (others => '1');
        Address <= (others => '0');

        wait for 1 * TbPeriod;
        WRITE <= '1';
        READ <= '0';
        Data_write <= (others => '0');
        Address <= "0000000000000000001" ;
        
        wait for 1 * TbPeriod;
        WRITE <= '0';
        READ <= '1';
        Data_write <= (others => '1');
        Address <= (others => '0');
        
        
        wait for 1 * TbPeriod;
        WRITE <= '0';
        READ <= '1';
        Data_write <= (others => '1');
        Address <= "0000000000000000001" ;
        
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

--EOF