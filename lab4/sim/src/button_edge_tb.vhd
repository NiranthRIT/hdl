-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - verify the synchronized one-clock press pulse separately.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity button_edge_tb is end entity;
architecture test of button_edge_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal press, synced, pulse : std_logic := '0';
  signal done : boolean := false;
begin
  clk <= not clk after 10 ns when not done else '0';
  dut : entity work.rising_edge_synchronizer(beh)
    port map (clk, reset, press, synced, pulse);
  stimulus : process
    variable pulses : natural;
  begin
    wait for 51 ns; reset <= '0'; wait for 40 ns;
    for press_number in 1 to 3 loop
      press <= '1'; pulses := 0;
      for cycle in 1 to 8 loop
        wait until rising_edge(clk); wait for 1 ns;
        if pulse='1' then pulses:=pulses+1; end if;
      end loop;
      assert pulses=1 report "Held button must produce exactly one pulse" severity failure;
      assert synced='1' report "Press did not synchronize" severity failure;
      press <= '0';
      for cycle in 1 to 8 loop
        wait until rising_edge(clk); wait for 1 ns;
        assert pulse='0' report "Release must not produce a rising-edge pulse" severity failure;
      end loop;
      assert synced='0' report "Release did not synchronize" severity failure;
    end loop;
    reset <= '1'; wait for 1 ns;
    assert synced='0' and pulse='0' report "Reset must clear button state" severity failure;
    report "PASS: three presses each produce exactly one one-clock pulse; no pulse on release" severity note;
    done <= true; wait;
  end process;
end architecture;
