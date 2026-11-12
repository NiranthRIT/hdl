-------------------------------------------------------------------------------
-- Lab 3 counter checks. Accelerated cadence, single-clock enables and 9-to-0 wraps.
-- The registered display follows the sum register by one additional clock.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity counter_tb is end;
architecture test of counter_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal segments : std_logic_vector(6 downto 0);
  signal enable_probe : std_logic;
  signal test_complete : std_logic := '0';
  type codes_type is array(0 to 9) of std_logic_vector(6 downto 0);
  constant codes : codes_type := (
    "1000000", "1111001", "0100100", "0110000", "0011001",
    "0010010", "0000010", "1111000", "0000000", "0011000");
begin
  clk <= not clk after 10 ns;
  uut : entity work.top(beh) generic map(max_count=>3) port map(clk,reset,segments);
  timing_probe : entity work.generic_counter(beh) generic map(max_count=>3)
    port map(clk,reset,enable_probe);
  process
    variable expected_digit : integer := 0;
  begin
    wait for 21 ns;
    reset <= '0';
    for i in 1 to 125 loop
      wait until rising_edge(clk);
      wait for 1 ns;
      if i mod 4 = 0 then
        assert enable_probe='1' report "missing enable" severity failure;
      else
        assert enable_probe='0' report "enable wider than one clock" severity failure;
      end if;
      if i < 6 then expected_digit:=0; else expected_digit:=((i-2)/4) mod 10; end if;
      assert segments=codes(expected_digit)
        report "counter/display cycle " & integer'image(i) severity failure;
    end loop;
    reset <= '1';
    wait for 1 ns;
    assert segments=codes(0) and enable_probe='0' report "counter reset" severity failure;
    report "PASS: counter cadence, three decimal wraps, display and reset" severity note;
    test_complete <= '1';
    wait;
  end process;
end test;
