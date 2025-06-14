----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2024 10:29:19 PM
-- Design Name: 
-- Module Name: Square_driver - Behavioral
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

entity Triangle_driver is
    generic(size : integer := 100;
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
        MOV_CLK: in std_logic;
        RESET_POS: in std_logic
    );
end Triangle_driver;

architecture Behavioral of Triangle_driver is

constant step : integer := 1;

signal coordX : integer := (screenW / 2)-size;
signal coordY : integer := (screenH / 2)-(size/2);

begin

process (HCOUNT, VCOUNT, D_enable) is
begin
    if D_enable = '1' then
        if VCOUNT-coordY >= 0 and VCOUNT-coordY < size then
            if HCOUNT-coordX >= 0 and HCOUNT-coordX < size then
                if (HCOUNT-coordX)+(VCOUNT-coordY)>=size-1 then
                    R <= (others => '1');
                    G <= (others => '1');
                    B <= (others => '0');
                else
                    R <= (others => '0');
                    G <= (others => '0');
                    B <= (others => '0');
                end if;
            elsif HCOUNT-coordX >= size and HCOUNT-coordX < size*2 then
                if VCOUNT-coordY >= (HCOUNT-coordX)-size then
                    R <= (others => '1');
                    G <= (others => '1');
                    B <= (others => '0');
                else
                    R <= (others => '0');
                    G <= (others => '0');
                    B <= (others => '0');
                end if;
            else
                R <= (others => '0');
                G <= (others => '0');
                B <= (others => '0');
            end if;
         else
            R <= (others => '0');
            G <= (others => '0');
            B <= (others => '0');
         end if;
     else
        R <= (others => '0');
        G <= (others => '0');
        B <= (others => '0');
    end if;
end process;

process (MOV_CLK, RESET_POS) is
begin
    if (MOV_CLK='1' and MOV_CLK'EVENT) then
        if RESET_POS = '1' then
            coordX <= (screenW / 2) - size;
            coordY <= (screenH / 2) - (size/2);
        else
            if UP='1' and DOWN='0' then
                if coordY >= step then
                    coordY <= coordY - step;
                end if;
            elsif DOWN='1' and UP='0' then
                if coordY+size < screenH-step then
                    coordY <= coordY + step;
                end if;
            end if;
            
            if LEFT='1' and RIGHT='0' then
                if coordX >= step then
                    coordX <= coordX - step;
                end if;
            elsif RIGHT='1' and LEFT='0' then
                if coordX+(size*2) < screenW-step then
                    coordX <= coordX + step;
                end if;
            end if;
        end if;
    end if;
end process;

end Behavioral;
