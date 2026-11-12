-------------------------------------------------------------------------------
-- Lab 3 blink checks. The supplied counter toggles every max_count+1 edges.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity blink_checks_tb is end;
architecture test of blink_checks_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal output : std_logic;
  signal expected : std_logic := '0';
  signal test_complete : std_logic := '0';
begin
  clk <= not clk after 10 ns;
  uut : entity work.blink(beh) generic map(max_count => 4) port map(clk,reset,output);
  process
    variable value : std_logic := '0';
  begin
    wait for 21 ns;
    assert output = '0' report "blink reset" severity failure;
    reset <= '0';
    for i in 1 to 20 loop
      wait until rising_edge(clk);
      if i mod 5 = 0 then value := not value; end if;
      wait for 1 ns;
      assert output = value report "blink edge " & integer'image(i) severity failure;
    end loop;
    reset <= '1';
    wait for 1 ns;
    assert output = '0' report "blink repeated reset" severity failure;
    report "PASS: original blink toggle timing and reset" severity note;
    test_complete <= '1';
    wait;
  end process;
end test;
