----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2022 20:57:02
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--========================================
--ENTITY DECLARATION
--========================================
entity top is
    GENERIC(
        addr_bits : INTEGER := 19;
        data_bits : INTEGER := 36
    );
  Port (
        Clk    : IN STD_LOGIC;
        WRITE     : IN STD_LOGIC;
        READ      : IN STD_LOGIC;
        BURST     : IN STD_LOGIC;
        Data_write      : IN STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);
        Address  : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0); 
        Data_read     : OUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0)
  );
end top;

architecture Behavioral of top is

--========================================
--SRAM CONTROLER COMPONENT
--========================================

component Sram_ctrl is
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
        Burst     : IN STD_LOGIC;
        
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
end component;

--========================================
--SRAM COMPONENT
--========================================

component mt55l512y36f IS
    GENERIC (
        -- Constant parameters
        addr_bits : INTEGER := 19;
        data_bits : INTEGER := 36;

        -- Timing parameters for -10 (100 Mhz)
        tKHKH    : TIME    := 10.0 ns;
        tKHKL    : TIME    :=  2.5 ns;
        tKLKH    : TIME    :=  2.5 ns;
        tKHQV    : TIME    :=  5.0 ns;
        tAVKH    : TIME    :=  2.0 ns;
        tEVKH    : TIME    :=  2.0 ns;
        tCVKH    : TIME    :=  2.0 ns;
        tDVKH    : TIME    :=  2.0 ns;
        tKHAX    : TIME    :=  0.5 ns;
        tKHEX    : TIME    :=  0.5 ns;
        tKHCX    : TIME    :=  0.5 ns;
        tKHDX    : TIME    :=  0.5 ns
    );

    -- Port Declarations
    PORT (
        Dq        : INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);   -- Data I/O
        Addr      : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);   -- Address
        Lbo_n     : IN    STD_LOGIC;                                   -- Burst Mode
        Clk       : IN    STD_LOGIC;                                   -- Clk
        Cke_n     : IN    STD_LOGIC;                                   -- Cke#
        Ld_n      : IN    STD_LOGIC;                                   -- Adv/Ld#
        Bwa_n     : IN    STD_LOGIC;                                   -- Bwa#
        Bwb_n     : IN    STD_LOGIC;                                   -- BWb#
        Bwc_n     : IN    STD_LOGIC;                                   -- Bwc#
        Bwd_n     : IN    STD_LOGIC;                                   -- BWd#
        Rw_n      : IN    STD_LOGIC;                                   -- RW#
        Oe_n      : IN    STD_LOGIC;                                   -- OE#
        Ce_n      : IN    STD_LOGIC;                                   -- CE#
        Ce2_n     : IN    STD_LOGIC;                                   -- CE2#
        Ce2       : IN    STD_LOGIC;                                   -- CE2
        Zz        : IN    STD_LOGIC                                    -- Snooze Mode
    );
end component;

--========================================
--SIGNALS
--========================================

signal        Dq_sig        :     STD_LOGIC_VECTOR (36 - 1 DOWNTO 0);          -- Data I/O
signal        Addr_sig      :     STD_LOGIC_VECTOR (19 - 1 DOWNTO 0);          -- Address
signal        Lbo_n_sig     :     STD_LOGIC;                                   -- Burst Mode
signal        Clk_sig       :     STD_LOGIC;                                   -- Clk
signal        Cke_n_sig     :     STD_LOGIC;                                   -- Cke#
signal        Ld_n_sig      :     STD_LOGIC;                                   -- Adv/Ld#
signal        Bwa_n_sig     :     STD_LOGIC;                                   -- Bwa#
signal        Bwb_n_sig     :     STD_LOGIC;                                   -- BWb#
signal        Bwc_n_sig     :     STD_LOGIC;                                   -- Bwc#
signal        Bwd_n_sig     :     STD_LOGIC;                                   -- BWd#
signal        Rw_n_sig      :     STD_LOGIC;                                   -- RW#
signal        Oe_n_sig      :     STD_LOGIC;                                   -- OE#
signal        Ce_n_sig      :     STD_LOGIC;                                   -- CE#
signal        Ce2_n_sig     :     STD_LOGIC;                                   -- CE2#
signal        Ce2_sig       :     STD_LOGIC;                                   -- CE2
signal        Zz_sig        :     STD_LOGIC;                                    -- Snooze Mode


begin

--==================
--sram ctrl port map
--==================
sramCtrl: Sram_ctrl port map(
        --clk
        Clk_in    =>    Clk,
        --USER'S PORTS
        D_in      =>    Data_write,
        Addr_req  =>    Address,
        D_out     =>    Data_read,
        WRITE     =>    Write,
        READ      =>    Read,
        BURST      =>   Burst,
        --SRAM PORTS
        Dq        =>    Dq_sig,
        Addr      =>    Addr_sig,
        Lbo_n     =>    Lbo_n_sig,
        Cke_n     =>    Cke_n_sig,
        Ld_n      =>    Ld_n_sig,
        Bwa_n     =>    Bwa_n_sig,
        Bwb_n     =>    Bwb_n_sig,
        Bwc_n     =>    Bwc_n_sig,
        Bwd_n     =>    Bwd_n_sig,
        Rw_n      =>    Rw_n_sig,
        Oe_n      =>    Oe_n_sig,
        Ce_n      =>    Ce_n_sig,
        Ce2_n     =>    Ce2_n_sig,
        Ce2       =>    Ce2_sig,
        Zz        =>    Zz_sig
);

--==============
--sram port map
--==============
mt: mt55l512y36f port map(
        Dq        =>    Dq_sig,
        Addr      =>    Addr_sig,
        Lbo_n     =>    Lbo_n_sig,
        Clk       =>    Clk,
        Cke_n     =>    Cke_n_sig,
        Ld_n      =>    Ld_n_sig,
        Bwa_n     =>    Bwa_n_sig,
        Bwb_n     =>    Bwb_n_sig,
        Bwc_n     =>    Bwc_n_sig,
        Bwd_n     =>    Bwd_n_sig,
        Rw_n      =>    Rw_n_sig,
        Oe_n      =>    Oe_n_sig,
        Ce_n      =>    Ce_n_sig,
        Ce2_n     =>    Ce2_n_sig,
        Ce2       =>    Ce2_sig,
        Zz        =>    Zz_sig
);


end Behavioral;

--EOF