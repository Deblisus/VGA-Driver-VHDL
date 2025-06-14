
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:12 04/18/2024 
-- Design Name: 
-- Module Name:    FrameCounter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FrameCounter is
    generic(
        HT : integer;
        VT : integer
    );
	port( HCOUNT : out INTEGER range 0 to HT-1;
	      VCOUNT : out INTEGER range 0 to VT-1;
	      CLK: in STD_LOGIC
	);
end FrameCounter;

architecture Behavioral of FrameCounter is



--constant FREQ : integer := 60;
--signal CLK : std_logic := '0';
--constant CLK_FREQ : integer := HT * VT * FREQ;
--constant CLK_PERIOD : time := 1000 ms / CLK_FREQ;

--component clock_divider is
--    generic( factor : integer);
--	port( CLKIN: in std_logic;
--	      CLKOUT : out std_logic);
--end component;

--signal CLK2 : std_logic;

begin

--CLK1: clock_divider generic map(factor => 4) port map(CLKIN => CLK, CLKOUT => CLK2);

--CLK_WORK:process is
--begin
--	CLK <= not CLK;
--	wait for CLK_PERIOD/2;
--end process CLK_WORK;

process(CLK) is
variable HC : integer range 0 to HT-1:= 0;
variable VC : integer range 0 to VT-1:= 0;
begin
	if CLK='1' and CLK'EVENT then
	    if HC = HT-1 then
		  HC := 0;
		  
		  if VC = VT-1 then
		      VC := 0;
		  else
		      VC := VC + 1;
		  end if;
		else
		  HC := HC + 1;
		end if;
	end if;
	
	HCOUNT <= HC;
	VCOUNT <= VC;
end process;


end Behavioral;

