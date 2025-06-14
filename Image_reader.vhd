----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2024 11:26:53 PM
-- Design Name: 
-- Module Name: Image_reader - Behavioral
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


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Image_reader is
  generic (     
    IMAGE_SIZE  : integer := 57500;
    IMAGE_FILE_NAME : string :="D:\Poli\An1\DSD\VGA\UTCN230x250.txt"
  );
  port(
    rdaddress: IN integer range 0 to IMAGE_SIZE-1;
    q: OUT std_logic_vector (11 DOWNTO 0);
    CLK: IN std_logic);
end Image_reader;

architecture Behavioral of Image_reader is

TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE) OF std_logic_vector(11 DOWNTO 0);

impure function init_mem(mif_file_name : in string) return mem_type is
    file mif_file : text open read_mode is IMAGE_FILE_NAME;
    variable mif_line : line;
    variable temp_bv : bit_vector(11 downto 0);
    variable temp_mem : mem_type;
begin
    for i in mem_type'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;

signal ram_block: mem_type := init_mem(IMAGE_FILE_NAME);
  

begin

process (rdaddress)
begin
    if CLK='1' and CLK'EVENT then
        q <= ram_block(rdaddress);
    end if;
end process;

end Behavioral;
