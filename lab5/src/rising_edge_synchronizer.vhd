-------------------------------------------------------------------------------
-- Lab 5. Two synchronizer flops followed by one-clock rising-edge detection.
-- async_in is the active-high button value after inverting the board's KEY0.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_synchronizer is
  port (clk : in std_logic;
        reset : in std_logic;
        async_in : in std_logic;
        pulse : out std_logic);
end entity;

architecture beh of rising_edge_synchronizer is
  signal flop1 : std_logic := '0';
  signal flop2 : std_logic := '0';
  signal previous : std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        flop1 <= '0';
        flop2 <= '0';
        previous <= '0';
      else
        flop1 <= async_in;
        flop2 <= flop1;
        previous <= flop2;
      end if;
    end if;
  end process;
  pulse <= flop2 and not previous;
end architecture;
