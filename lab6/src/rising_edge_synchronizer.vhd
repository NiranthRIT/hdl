library ieee;
use ieee.std_logic_1164.all;
entity rising_edge_synchronizer is
  port (clk, reset, input : in std_logic; edge : out std_logic);
end rising_edge_synchronizer;
architecture rtl of rising_edge_synchronizer is
  signal meta, synced, previous : std_logic := '0';
  attribute altera_attribute : string;
  attribute altera_attribute of meta, synced : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED";
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        meta <= '0'; synced <= '0'; previous <= '0';
      else
        meta <= input; synced <= meta; previous <= synced;
      end if;
    end if;
  end process;
  edge <= synced and not previous;
end rtl;
