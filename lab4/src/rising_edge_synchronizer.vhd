-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - two-flop synchronizer and one-clock rising-edge pulse.
-- async_in is a logical active-high press, after inversion of the DE1-SoC KEY.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_synchronizer is
  port (clk : in std_logic; reset : in std_logic;
        async_in : in std_logic; sync_out : out std_logic;
        edge_out : out std_logic);
end entity;

architecture beh of rising_edge_synchronizer is
  signal flop1 : std_logic := '0';
  signal flop2 : std_logic := '0';
  signal previous : std_logic := '0';
begin
  process(clk, reset)
  begin
    if reset = '1' then
      flop1 <= '0';
      flop2 <= '0';
      previous <= '0';
    elsif rising_edge(clk) then
      flop1 <= async_in;
      flop2 <= flop1;
      previous <= flop2;
    end if;
  end process;
  sync_out <= flop2;
  edge_out <= flop2 and not previous;
end architecture;
