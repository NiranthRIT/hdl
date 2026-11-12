-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - combinational active-low hexadecimal display decoder.
-- segments(6 downto 0) = g,f,e,d,c,b,a. 9 uses the previous lab's States pattern.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity seven_seg is
  port (bcd : in std_logic_vector(3 downto 0);
        segments : out std_logic_vector(6 downto 0));
end entity;

architecture beh of seven_seg is
begin
  with bcd select segments <=
    "1000000" when "0000",
    "1111001" when "0001",
    "0100100" when "0010",
    "0110000" when "0011",
    "0011001" when "0100",
    "0010010" when "0101",
    "0000010" when "0110",
    "1111000" when "0111",
    "0000000" when "1000",
    "0011000" when "1001",
    "0001000" when "1010", -- A
    "0000011" when "1011", -- b
    "1000110" when "1100", -- C
    "0100001" when "1101", -- d
    "0000110" when "1110", -- E
    "0001110" when "1111", -- F
    "1111111" when others;
end architecture;
