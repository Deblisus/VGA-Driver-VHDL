----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2024 03:34:31 PM
-- Design Name: 
-- Module Name: decoding - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity decoding is
    port(
        CLK : in std_logic;
        RESET_CNT : in std_logic;
        HSYNC : out std_logic;
        VSYNC : out std_logic;
        R:out std_logic_vector(3 downto 0);
        G:out std_logic_vector(3 downto 0);
        B:out std_logic_vector(3 downto 0);
        
        UP: in std_logic;
        DOWN: in std_logic;
        LEFT: in std_logic;
        RIGHT: in std_logic;
        
        SEL: in std_logic_vector(1 downto 0)
    );
end decoding;

architecture Behavioral of decoding is

--constant HA : integer := 800; constant HF : integer := 40; constant HS : integer := 128; constant HB : integer := 88;
--constant HA : integer := 640; constant HF : integer := 16; constant HS : integer := 96; constant HB : integer := 48;
constant HA : integer := 800; constant HF : integer := 56; constant HS : integer := 120; constant HB : integer := 64;
constant HT : integer := HA + HF + HS + HB;

--constant VA : integer := 600; constant VF : integer := 1; constant VS : integer := 4; constant VB : integer := 23;
--constant VA : integer := 480; constant VF : integer := 9; constant VS : integer := 2; constant VB : integer := 29;
constant VA : integer := 600; constant VF : integer := 37; constant VS : integer := 6; constant VB : integer := 23; 
constant VT : integer := VA + VF + VS + VB;

constant CLKD : integer := 1;

component FrameCounter is
    generic(
        HT : integer;
        VT : integer
    );
	port( HCOUNT : out INTEGER range 0 to HT-1;
	      VCOUNT : out INTEGER range 0 to VT-1;
	      CLK: in STD_LOGIC);
end component;

component clock_divider is
    generic( factor : integer);
	port( CLKIN: in std_logic;
	      CLKOUT : out std_logic);
end component;

component debouncer is
    Port ( CLK : in STD_LOGIC;
           But : in STD_LOGIC;
           debounced : out STD_LOGIC);
end component;

component Display_driver is
    generic(
            screenW: integer;
            screenH: integer);
    port(
        HCOUNT : in integer range 0 to screenW-1;
        VCOUNT : in integer range 0 to screenH-1;
        R : out std_logic_vector(3 downto 0);
        G : out std_logic_vector(3 downto 0);
        B : out std_logic_vector(3 downto 0);
        D_enable : std_logic;
        
        UP : in std_logic;
        DOWN : in std_logic;
        LEFT : in std_logic;
        RIGHT : in std_logic;
        CLK: in std_logic;
        MOV_CLK: in std_logic;
        RESET_POS: in std_logic;
        
        SEL: in std_logic_vector(1 downto 0)
    );
end component;

signal CLKINT : std_logic;

signal HC : integer range 0 to HT-1;
signal VC : integer range 0 to VT-1;


signal D_enable : std_logic;


--signal UP_DEB: std_logic := '0';
--signal DOWN_DEB: std_logic := '0';
--signal LEFT_DEB: std_logic := '0';
--signal RIGHT_DEB: std_logic := '0';
signal BUTTON_CLK: std_logic;

begin

CLKA: Clock_divider generic map(factor => CLKD) port map(CLKIN => CLK, CLKOUT => CLKINT);
FC1: FrameCounter generic map(HT=>HT, VT=>VT) port map(HCOUNT=>HC, VCOUNT=>VC, CLK => CLKINT);

--DEBUP: debouncer port map(CLK=>CLKINT, But=>UP, debounced=>UP_DEB);
--DEBDOWN: debouncer port map(CLK=>CLKINT, But=>DOWN, debounced=>DOWN_DEB);
--DEBLEFT: debouncer port map(CLK=>CLKINT, But=>LEFT, debounced=>LEFT_DEB);
--DEBRIGHT: debouncer port map(CLK=>CLKINT, But=>RIGHT, debounced=>RIGHT_DEB);

DSD: Display_driver generic map(screenW=>HA, screenH=>VA) port map(HCOUNT=>HC, VCOUNT=>VC, R=>R, G=>G, B=>B, D_enable=>D_enable, UP=>UP, DOWN=>DOWN, LEFT=>LEFT, RIGHT=>RIGHT, CLK=>CLKINT, MOV_CLK=>BUTTON_CLK, RESET_POS=>RESET_CNT, SEL=>SEL);

BCLK: Clock_divider generic map(factor => 65536) port map(CLKIN=>CLKINT, CLKOUT => BUTTON_CLK);
process(HC) is
begin
    if HC >= HA+HF and HC < HA+HF+HS then
        HSYNC <= '0';
    else 
        HSYNC <= '1';
    end if;
end process;

process(VC) is
begin
    if VC >= VA+VF and VC < VA+VF+VS then
        VSYNC <= '0';
    else 
        VSYNC <= '1';
    end if;
end process;

process(HC, VC) is
begin
    if HC < HA and VC < VA then
        D_enable <= '1';
    else
        D_enable <= '0';
    end if;
end process;

--process(D_enable) is
--begin
--    if D_enable = '1' then
--        R <= (others => '0');
--        G <= (others => '1');
--        B <= (others => '1');
--    else
--        R <= (others => '0');
--        G <= (others => '0');
--        B <= (others => '0');
--    end if;
--end process;

end Behavioral;