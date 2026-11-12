-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - unsigned arithmetic with one guard bit.
-- subtract='0' adds; subtract='1' subtracts modulo 2**(bits+1).
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_add_sub is
  generic (bits : positive := 3);
  port (a : in std_logic_vector(bits-1 downto 0);
        b : in std_logic_vector(bits-1 downto 0);
        subtract : in std_logic;
        result : out std_logic_vector(bits downto 0));
end entity;

architecture beh of generic_add_sub is
  signal a_guard : unsigned(bits downto 0);
  signal b_guard : unsigned(bits downto 0);
begin
  -- Extend BEFORE arithmetic, so 7+7 produces 14 rather than overflowing at 3 bits.
  a_guard <= resize(unsigned(a), bits+1);
  b_guard <= resize(unsigned(b), bits+1);
  result <= std_logic_vector(a_guard - b_guard) when subtract = '1'
            else std_logic_vector(a_guard + b_guard);
end architecture;
