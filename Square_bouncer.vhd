----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/01/2024 12:11:12 AM
-- Design Name: 
-- Module Name: Square_bouncer - Behavioral
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

entity Square_bouncer is
    generic(size : integer := 50;
            screenW: integer;
            screenH: integer);
    port(
        centerX : in integer range size to screenW-size-1;
        centerY : in integer range size to screenH-size-1;
        
        UP : out std_logic;
        DOWN : out std_logic;
        LEFT : out std_logic;
        RIGHT : out std_logic;
        MOV_CLK: in std_logic
    );
end Square_bouncer;

architecture Behavioral of Square_bouncer is

signal UP_IN : std_logic := '1';
signal DOWN_IN : std_logic := '0';
signal LEFT_IN : std_logic := '0';
signal RIGHT_IN : std_logic := '1';

begin

process (centerX, centerY) is
begin
    if centerY = size then
        UP_IN <= '0';
        DOWN_IN <= '1';
    end if;
    if centerY = screenH-size-1 then
        DOWN_IN <= '0';
        UP_IN <= '1';
    end if;

    if centerX = size then
        LEFT_IN <= '0';
        RIGHT_IN <= '1';
    end if;
    if centerX >= screenW-size-1 then
        RIGHT_IN <= '0';
        LEFT_IN <= '1';
    end if;
end process;

UP <= UP_IN;
DOWN <= DOWN_IN;
LEFT <= LEFT_IN;
RIGHT <= RIGHT_IN;

end Behavioral;
