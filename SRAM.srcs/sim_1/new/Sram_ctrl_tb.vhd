-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 15.11.2022 17:52:37 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_Sram_ctrl is
end tb_Sram_ctrl;

architecture tb of tb_Sram_ctrl is

    component Sram_ctrl
        port (Clk_in   : in std_logic;
              D_in     : in std_logic_vector (36 - 1 downto 0);
              Addr_req : in std_logic_vector (19 - 1 downto 0);
              D_out    : out std_logic_vector (36 - 1 downto 0);
              WRITE    : in std_logic;
              READ     : in std_logic;
              BURST     : in std_logic;
              Dq       : inout std_logic_vector (36 - 1 downto 0);
              Addr     : out std_logic_vector (19 - 1 downto 0);
              Lbo_n    : out std_logic;
              Cke_n    : out std_logic;
              Ld_n     : out std_logic;
              Bwa_n    : out std_logic;
              Bwb_n    : out std_logic;
              Bwc_n    : out std_logic;
              Bwd_n    : out std_logic;
              Rw_n     : out std_logic;
              Oe_n     : out std_logic;
              Ce_n     : out std_logic;
              Ce2_n    : out std_logic;
              Ce2      : out std_logic;
              Zz       : out std_logic);
    end component;

    signal Clk_in   : std_logic;
    signal D_in     : std_logic_vector (36 - 1 downto 0);
    signal Addr_req : std_logic_vector (19 - 1 downto 0);
    signal D_out    : std_logic_vector (36 - 1 downto 0);
    signal WRITE    : std_logic;
    signal READ     : std_logic;
    signal BURST     : std_logic;
    signal Dq       : std_logic_vector (36 - 1 downto 0);
    signal Addr     : std_logic_vector (19 - 1 downto 0);
    signal Lbo_n    : std_logic;
    signal Cke_n    : std_logic;
    signal Ld_n     : std_logic;
    signal Bwa_n    : std_logic;
    signal Bwb_n    : std_logic;
    signal Bwc_n    : std_logic;
    signal Bwd_n    : std_logic;
    signal Rw_n     : std_logic;
    signal Oe_n     : std_logic;
    signal Ce_n     : std_logic;
    signal Ce2_n    : std_logic;
    signal Ce2      : std_logic;
    signal Zz       : std_logic;

    constant TbPeriod : time := 30 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '1';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Sram_ctrl
    port map (Clk_in   => Clk_in,
              D_in     => D_in,
              Addr_req => Addr_req,
              D_out    => D_out,
              WRITE    => WRITE,
              READ     => READ,
              BURST     => BURST,
              Dq       => Dq,
              Addr     => Addr,
              Lbo_n    => Lbo_n,
              Cke_n    => Cke_n,
              Ld_n     => Ld_n,
              Bwa_n    => Bwa_n,
              Bwb_n    => Bwb_n,
              Bwc_n    => Bwc_n,
              Bwd_n    => Bwd_n,
              Rw_n     => Rw_n,
              Oe_n     => Oe_n,
              Ce_n     => Ce_n,
              Ce2_n    => Ce2_n,
              Ce2      => Ce2,
              Zz       => Zz);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk_in is really your main clock signal
    Clk_in <= TbClock;

    stimuli : process
    begin
        
        -- EDIT Adapt initialization as needed
        D_in <= (others => '0');
        Addr_req <= (others => '1');
        WRITE <= '1';
        READ <= '0';

        -- EDIT Add stimuli here
        wait for 2 * TbPeriod;
        
        D_in <= (others => '1');
        Addr_req <= (others => '1');
        WRITE <= '1';
        READ <= '0';
        
        wait for 1 * TbPeriod;
        
        wait for 10 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

--EOF