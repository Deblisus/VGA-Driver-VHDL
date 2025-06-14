----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2024 10:59:30 AM
-- Design Name: 
-- Module Name: Image_driver - Behavioral
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

entity Image_driver is
    generic(
            screenW: integer;
            screenH: integer;
            pixel_size: integer := 1);
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
        CLK : in std_logic;
        MOV_CLK: in std_logic;
        RESET_POS: in std_logic
    );
end Image_driver;

architecture Behavioral of Image_driver is

constant imageW : integer := 230;
constant imageH : integer := 250;

constant imageS : integer := imageW*imageH;

constant step : integer := 1;

component Image_reader is
    generic (     
    IMAGE_SIZE  : integer := 57500;
    IMAGE_FILE_NAME : string :="D:\Poli\An1\DSD\VGA\UTCN230x250.txt"
  );
    port(
    rdaddress: IN integer range 0 to IMAGE_SIZE-1;
    q: OUT std_logic_vector (11 DOWNTO 0);
    CLK: IN std_logic);
end component;

signal addr : integer range 0 to imageS-1 := 0;
signal Colors : std_logic_vector(11 downto 0);

-- Upper left corner of the picture
signal coordX : integer range 0 to screenW-1 := (screenW/2) - ((imageW/2)*pixel_size);
signal coordY : integer range 0 to screenH-1 := (screenH/2) - ((imageH/2)*pixel_size);

begin

IMR: Image_reader port map(rdaddress=>addr, q=>Colors, CLK=>CLK);

process (HCOUNT, VCOUNT, D_enable) is
begin
    if D_enable = '1' then
        if (HCOUNT >= coordX and HCOUNT < coordX+imageW*pixel_size) and (VCOUNT >= coordY and VCOUNT < coordY+imageH*pixel_size) then
            addr <= ((VCOUNT-coordY)/pixel_size)*imageW + ((HCOUNT-coordX)/pixel_size);
            R <= Colors(11 downto 8);
            G <= Colors(7 downto 4);
            B <= Colors(3 downto 0);
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
    if (MOV_CLK='1' and MOV_CLK'EVENT)  then
        if RESET_POS = '1' then
            coordX <= (screenW/2) - ((imageW/2)*pixel_size);
            coordY <= (screenH/2) - ((imageH/2)*pixel_size);
        else
            if UP='1' and DOWN='0' then
                if coordY >= step then
                    coordY <= coordY - step;
                end if;
            elsif DOWN='1' and UP='0' then
                if coordY < screenH-(imageH*pixel_size) - step then
                    coordY <= coordY + step;
                end if;
            end if;
            
            if LEFT='1' and RIGHT='0' then
                if coordX >= step then
                    coordX <= coordX - step;
                end if;
            elsif RIGHT='1' and LEFT='0' then
                if coordX < screenW-(imageW*pixel_size)- step then
                    coordX <= coordX + step;
                end if;
            end if;
        end if;
    end if;
end process;

end Behavioral;
