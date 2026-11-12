-------------------------------------------------------------------------------
-- Lab 3 decoder checks. Exercise every input and compare to the handout radix.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_checks_tb is end;
architecture test of seven_seg_checks_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal bcd : std_logic_vector(3 downto 0) := "0000";
  signal segments : std_logic_vector(6 downto 0);
  signal test_complete : std_logic := '0';
  type codes_type is array(0 to 15) of std_logic_vector(6 downto 0);
  constant codes : codes_type := (
    "1000000", "1111001", "0100100", "0110000", "0011001",
    "0010010", "0000010", "1111000", "0000000", "0011000",
    "1111111", "1111111", "1111111", "1111111", "1111111", "1111111");
begin
  clk <= not clk after 10 ns;
  uut : entity work.seven_seg(beh) port map(clk, reset, bcd, segments);
  process
  begin
    wait for 21 ns;
    assert segments = codes(0) report "decoder reset" severity failure;
    reset <= '0';
    for i in 0 to 15 loop
      bcd <= std_logic_vector(to_unsigned(i, 4));
      wait until rising_edge(clk);
      wait for 1 ns;
      assert segments = codes(i) report "decoder input " & integer'image(i) severity failure;
    end loop;
    reset <= '1';
    wait for 1 ns;
    assert segments = codes(0) report "decoder repeated reset" severity failure;
    report "PASS: all 16 BCD inputs and reset" severity note;
    test_complete <= '1';
    wait;
  end process;
end test;
