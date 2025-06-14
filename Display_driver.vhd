----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2024 07:38:28 PM
-- Design Name: 
-- Module Name: Display_driver - Behavioral
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

entity Display_driver is
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
end Display_driver;


architecture Behavioral of Display_driver is

component Square_driver is
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
end component;

component Image_driver is
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
        CLK: in std_logic;
        MOV_CLK: in std_logic;
        RESET_POS: in std_logic
    );
end component;

component Triangle_driver is
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
end component;

signal R_SQ : std_logic_vector(3 downto 0);
signal G_SQ : std_logic_vector(3 downto 0);
signal B_SQ : std_logic_vector(3 downto 0);
signal D_Enable_SQ: std_logic;
signal UP_SQ: std_logic;
signal DOWN_SQ: std_logic;
signal LEFT_SQ: std_logic;
signal RIGHT_SQ: std_logic;
signal Enable_auto_SQ: std_logic;

signal R_IM : std_logic_vector(3 downto 0);
signal G_IM : std_logic_vector(3 downto 0);
signal B_IM : std_logic_vector(3 downto 0);
signal D_Enable_IM: std_logic;
signal UP_IM: std_logic;
signal DOWN_IM: std_logic;
signal LEFT_IM: std_logic;
signal RIGHT_IM: std_logic;

signal R_TR : std_logic_vector(3 downto 0);
signal G_TR : std_logic_vector(3 downto 0);
signal B_TR : std_logic_vector(3 downto 0);
signal D_Enable_TR: std_logic;
signal UP_TR: std_logic;
signal DOWN_TR: std_logic;
signal LEFT_TR: std_logic;
signal RIGHT_TR: std_logic;

begin

SQD: Square_driver generic map(size=>50, screenW=>screenW, screenH=>screenH) port map(HCOUNT=>HCOUNT, VCOUNT=>VCOUNT, R=>R_SQ, G=>G_SQ, B=>B_SQ, D_enable=>D_enable_SQ, UP=>UP_SQ, DOWN=>DOWN_SQ, LEFT=>LEFT_SQ, RIGHT=>RIGHT_SQ, MOV_CLK=>MOV_CLK, Enable_auto=>Enable_auto_SQ, RESET_POS=>RESET_POS);
IMD: Image_driver generic map(screenW=>screenW, screenH=>screenH, pixel_size=>1) port map(HCOUNT=>HCOUNT, VCOUNT=>VCOUNT, R=>R_IM, G=>G_IM, B=>B_IM, D_enable=>D_enable_IM, UP=>UP_IM, DOWN=>DOWN_IM, LEFT=>LEFT_IM, RIGHT=>RIGHT_IM, CLK=>CLK, MOV_CLK=>MOV_CLK, RESET_POS=>RESET_POS);
TRD: Triangle_driver generic map(size=>100, screenW=>screenW, screenH=>screenH) port map(HCOUNT=>HCOUNT, VCOUNT=>VCOUNT, R=>R_TR, G=>G_TR, B=>B_TR, D_enable=>D_enable_TR, UP=>UP_TR, DOWN=>DOWN_TR, LEFT=>LEFT_TR, RIGHT=>RIGHT_TR, MOV_CLK=>MOV_CLK, RESET_POS=>RESET_POS);


process (SEL, D_Enable, R_SQ, G_SQ, B_SQ, R_IM, G_IM, B_IM, CLK) is
begin
    if SEL = "00" then
        D_Enable_SQ <= D_Enable;
        D_Enable_IM <= '0';
        D_Enable_TR <= '0';
        UP_SQ <= UP; DOWN_SQ <= DOWN; LEFT_SQ <= LEFT; RIGHT_SQ <= RIGHT;
        UP_IM <= '0'; DOWN_IM <= '0'; LEFT_IM <= '0'; RIGHT_IM <= '0';
        UP_TR <= '0'; DOWN_TR <= '0'; LEFT_TR <= '0'; RIGHT_TR <= '0';
        R <= R_SQ;
        G <= G_SQ;
        B <= B_SQ;
        Enable_auto_SQ <= '0';
    elsif SEL = "11" then
        D_Enable_SQ <= D_Enable;
        D_Enable_IM <= '0';
        D_Enable_TR <= '0';
        UP_SQ <= UP; DOWN_SQ <= DOWN; LEFT_SQ <= LEFT; RIGHT_SQ <= RIGHT;
        UP_IM <= '0'; DOWN_IM <= '0'; LEFT_IM <= '0'; RIGHT_IM <= '0';
        UP_TR <= '0'; DOWN_TR <= '0'; LEFT_TR <= '0'; RIGHT_TR <= '0';
        R <= R_SQ;
        G <= G_SQ;
        B <= B_SQ;
        Enable_auto_SQ <= '1';
    elsif SEL = "01" then
        D_Enable_IM <= D_Enable;
        D_Enable_SQ <= '0';
        D_Enable_TR <= '0';
        UP_IM <= UP; DOWN_IM <= DOWN; LEFT_IM <= LEFT; RIGHT_IM <= RIGHT;
        UP_SQ <= '0'; DOWN_SQ <= '0'; LEFT_SQ <= '0'; RIGHT_SQ <= '0';
        UP_TR <= '0'; DOWN_TR <= '0'; LEFT_TR <= '0'; RIGHT_TR <= '0';
        R <= R_IM;
        G <= G_IM;
        B <= B_IM;
        Enable_auto_SQ <= '0';
    elsif SEL = "10" then
        D_Enable_TR <= D_Enable;
        D_Enable_SQ <= '0';
        D_Enable_IM <= '0';
        UP_TR <= UP; DOWN_TR <= DOWN; LEFT_TR <= LEFT; RIGHT_TR <= RIGHT;
        UP_SQ <= '0'; DOWN_SQ <= '0'; LEFT_SQ <= '0'; RIGHT_SQ <= '0';
        UP_IM <= '0'; DOWN_IM <= '0'; LEFT_IM <= '0'; RIGHT_IM <= '0';
        R <= R_TR;
        G <= G_TR;
        B <= B_TR;
        Enable_auto_SQ <= '0';
    end if;
end process;

end Behavioral;
