-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - synchronized active-high switch reset, 50 MHz.
-- Reset synchronizer.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reset_synchronizer is
  port (clk : in std_logic; async_reset : in std_logic;
        sync_reset : out std_logic);
end entity;

architecture beh of reset_synchronizer is
  signal flop1 : std_logic := '1';
  signal flop2 : std_logic := '1';
begin
  -- The reset switch itself is sampled twice, just like the other inputs.
  process(clk)
  begin
    if rising_edge(clk) then
      flop1 <= async_reset;
      flop2 <= flop1;
    end if;
  end process;
  sync_reset <= flop2;
end architecture;
