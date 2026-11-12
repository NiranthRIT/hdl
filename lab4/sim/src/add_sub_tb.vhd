-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - 50 MHz stimulus, all 64 input pairs in each operation.
-- Independent integer scoreboard checks arithmetic and displayed hex patterns.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_tb is end entity;
architecture test of add_sub_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal a, b : std_logic_vector(2 downto 0) := "000";
  signal add_btn, sub_btn : std_logic := '1';
  signal a_bcd, b_bcd, result_bcd : std_logic_vector(6 downto 0);
  signal tests_done : std_logic := '0';
  type segment_table is array(0 to 15) of std_logic_vector(6 downto 0);
  constant hex_segments : segment_table := (
    "1000000", "1111001", "0100100", "0110000",
    "0011001", "0010010", "0000010", "1111000",
    "0000000", "0011000", "0001000", "0000011",
    "1000110", "0100001", "0000110", "0001110");
begin
  clk <= not clk after 10 ns when tests_done = '0' else '0';
  dut : entity work.add_sub(structural)
    port map (clk, reset, a, b, add_btn, sub_btn, a_bcd, b_bcd, result_bcd);

  stimulus : process
    procedure tick(n : positive := 8) is
    begin
      for i in 1 to n loop wait until rising_edge(clk); end loop;
      wait for 1 ns;
    end procedure;
    procedure check_result(av, bv : natural; subtract_mode : boolean) is
      variable expected : integer;
    begin
      if subtract_mode then expected := (integer(av)-integer(bv)) mod 16;
      else expected := (av+bv) mod 16; end if;
      assert a_bcd = hex_segments(av) report "A display mismatch" severity failure;
      assert b_bcd = hex_segments(bv) report "B display mismatch" severity failure;
      assert result_bcd = hex_segments(expected)
        report "Result mismatch a=" & integer'image(av) & " b=" & integer'image(bv)
        & " expected=" & integer'image(expected) severity failure;
    end procedure;
  begin
    tick;
    assert result_bcd = hex_segments(0) report "Reset display mismatch" severity failure;
    reset <= '0'; tick;

    -- A held button must not require another press when the operands change.
    -- These two sweeps cover every possible 3-bit pair for add AND subtract.
    for operation in 0 to 1 loop
      if operation = 0 then add_btn <= '0'; else sub_btn <= '0'; end if;
      tick;
      for av in 0 to 7 loop
        for bv in 0 to 7 loop
          a <= std_logic_vector(to_unsigned(av, 3));
          b <= std_logic_vector(to_unsigned(bv, 3));
          tick;
          check_result(av, bv, operation=1);
        end loop;
      end loop;
      add_btn <= '1'; sub_btn <= '1'; tick;
      check_result(7, 7, operation=1); -- The selected operation persists on release.
    end loop;

    -- Explicit handout underflows, later button changes, reset, and priority.
    a <= "001"; b <= "010"; tick; check_result(1, 2, true);
    a <= "000"; b <= "111"; tick; check_result(0, 7, true);
    add_btn <= '0'; tick; check_result(0, 7, false);
    add_btn <= '1'; tick;
    sub_btn <= '0'; tick; check_result(0, 7, true);
    sub_btn <= '1'; tick;
    add_btn <= '0'; sub_btn <= '0'; tick; check_result(0, 7, false);
    add_btn <= '1'; sub_btn <= '1'; tick;
    reset <= '1'; tick;
    assert a_bcd=hex_segments(0) and b_bcd=hex_segments(0)
      and result_bcd=hex_segments(0) report "Reset did not clear synchronized data" severity failure;
    reset <= '0'; tick; check_result(0, 7, false);

    report "PASS: 128 arithmetic/display combinations, held/released buttons, underflows, operation changes, reset and simultaneous-button priority" severity note;
    tests_done <= '1';
    wait;
  end process;
end architecture;
