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

entity Square_driver is
    generic(size : integer := 50;
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
        Enable_auto: in std_logic;
        RESET_POS: in std_logic
    );
end Square_driver;

architecture Behavioral of Square_driver is

component Square_bouncer is
    generic(size : integer := 50;
            screenW: integer;
            screenH: integer);
    port(
        centerX : in integer range 0 to screenW-1;
        centerY : in integer range 0 to screenH-1;
        
        UP : out std_logic;
        DOWN : out std_logic;
        LEFT : out std_logic;
        RIGHT : out std_logic;
        MOV_CLK: in std_logic
    );
end component;

constant step : integer := 1;

signal centerX : integer := screenW / 2;
signal centerY : integer := screenH / 2;

signal UP_INT: std_logic;
signal DOWN_INT: std_logic;
signal LEFT_INT: std_logic;
signal RIGHT_INT: std_logic;

signal UP_DR: std_logic;
signal DOWN_DR: std_logic;
signal LEFT_DR: std_logic;
signal RIGHT_DR: std_logic;
signal MOV_CLK_DR: std_logic;

begin

MOVD: Square_bouncer generic map(size=>size, screenW=>screenW, screenH=>screenH) port map(centerX=>centerX, centerY=>centerY, UP=>UP_DR, DOWN=>DOWN_DR, LEFT=>LEFT_DR, RIGHT=>RIGHT_DR, MOV_CLK=>MOV_CLK_DR);

process (HCOUNT, VCOUNT, D_enable) is
begin
    if D_enable = '1' then
        if (HCOUNT >= centerX-size and HCOUNT <= centerX+size) and (VCOUNT >= centerY-size and VCOUNT <= centerY+size) then
            R <= (others => '0');
            G <= (others => '1');
            B <= (others => '1');
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

process (Enable_auto) is
begin
    if Enable_auto = '0' then
        MOV_CLK_DR <= '0';
        UP_INT <= UP;
        DOWN_INT <= DOWN;
        LEFT_INT <= LEFT;
        RIGHT_INT <= RIGHT;
    elsif Enable_auto = '1' then
        MOV_CLK_DR <= '1';
        UP_INT <= UP_DR;
        DOWN_INT <= DOWN_DR;
        LEFT_INT <= LEFT_DR;
        RIGHT_INT <= RIGHT_DR;
    end if;
end process;

process (MOV_CLK, UP_INT, DOWN_INT, LEFT_INT, RIGHT_INT, RESET_POS) is
begin
    if (MOV_CLK='1' and MOV_CLK'EVENT) then
        if RESET_POS = '1' then
            centerX <= screenW / 2;
            centerY <= screenH / 2;
        else
            if UP_INT='1' and DOWN_INT='0' then
                if centerY-size >= step then
                    centerY <= centerY - step;
                end if;
            elsif DOWN_INT='1' and UP_INT='0' then
                if centerY+size < screenH-step then
                    centerY <= centerY + step;
                end if;
            end if;
            
            if LEFT_INT='1' and RIGHT_INT='0' then
                if centerX-size >= step then
                    centerX <= centerX - step;
                end if;
            elsif RIGHT_INT='1' and LEFT_INT='0' then
                if centerX+size < screenW-step then
                    centerX <= centerX + step;
                end if;
            end if;
        end if;
    end if;
end process;

end Behavioral;
