----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2024 09:59:37 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider is
    generic(factor : integer);
    port(
        CLKIN : in std_logic;
        CLKOUT : out std_logic
    );
end clock_divider;

architecture Behavioral of clock_divider is
signal CLKINT : std_logic := '1';
begin

process(CLKIN) is
variable COUNT : integer range 0 to factor-1 := 0;
begin
    if CLKIN = '1' and CLKIN'EVENT then
        if COUNT = factor - 1 then
            COUNT := 0;
            CLKINT <= not CLKINT;
        else
            COUNT := COUNT + 1;
        end if;
     end if;
end process;
    CLKOUT <= CLKINT;
end Behavioral;
