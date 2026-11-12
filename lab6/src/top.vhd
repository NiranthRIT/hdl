library ieee;
use ieee.std_logic_1164.all;
use work.components.all;
entity top is
  port (clk, reset_n, execute : in std_logic;
        switch : in std_logic_vector(7 downto 0);
        op : in std_logic_vector(1 downto 0);
        led : out std_logic_vector(2 downto 0);
        bcd_0, bcd_1, bcd_2 : out std_logic_vector(6 downto 0));
end top;
architecture rtl of top is
  signal reset_meta, reset_sync_n : std_logic := '0';
  signal reset, execute_pressed : std_logic;
  attribute altera_attribute : string;
  attribute altera_attribute of reset_meta, reset_sync_n : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED";
begin
  process(clk)
  begin
    if rising_edge(clk) then
      reset_meta <= reset_n; reset_sync_n <= reset_meta;
    end if;
  end process;
  reset <= not reset_sync_n;
  execute_pressed <= not execute;
  calculator_block : calculator port map(clk, reset, execute_pressed, switch, op,
                                         led, bcd_0, bcd_1, bcd_2);
end rtl;
