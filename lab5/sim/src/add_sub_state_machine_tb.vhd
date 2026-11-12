-------------------------------------------------------------------------------
-- Lab 5 check bench. Includes the four required handout cases.
-- Assertions check the expected simulation results.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_state_machine_tb is
end entity;

architecture arch of add_sub_state_machine_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal switch : std_logic_vector(7 downto 0) := (others => '0');
  signal btn : std_logic := '1';
  signal led : std_logic_vector(3 downto 0);
  signal bcd_0, bcd_1, bcd_2 : std_logic_vector(6 downto 0);
  signal test_number : integer := 0;
  signal test_a, test_b, expected_sum, expected_diff : integer := 0;
  signal done : boolean := false;

  function digit_pattern(n : natural) return std_logic_vector is
  begin
    case n is
      when 0 => return "1000000";
      when 1 => return "1111001";
      when 2 => return "0100100";
      when 3 => return "0110000";
      when 4 => return "0011001";
      when 5 => return "0010010";
      when 6 => return "0000010";
      when 7 => return "1111000";
      when 8 => return "0000000";
      when 9 => return "0011000";
      when others => return "1111111";
    end case;
  end function;
begin
  clk <= not clk after 10 ns when not done else '0';
  uut : entity work.add_sub_state_machine
    port map(clk => clk, reset => reset, switch => switch, btn => btn,
             led => led, bcd_0 => bcd_0, bcd_1 => bcd_1, bcd_2 => bcd_2);

  stimulus : process
    procedure settle is
    begin
      wait for 121 ns;
    end procedure;
    procedure check_display(value : natural) is
    begin
      assert bcd_0 = digit_pattern(value mod 10)
        report "units mismatch for " & integer'image(value) severity failure;
      assert bcd_1 = digit_pattern((value / 10) mod 10)
        report "tens mismatch for " & integer'image(value) severity failure;
      assert bcd_2 = digit_pattern((value / 100) mod 10)
        report "hundreds mismatch for " & integer'image(value) severity failure;
    end procedure;
    procedure press_once(expected_state : std_logic_vector(3 downto 0)) is
    begin
      btn <= '0';
      settle;
      assert led = expected_state report "state did not advance once" severity failure;
      wait for 200 ns;
      assert led = expected_state report "held button advanced more than once" severity failure;
      btn <= '1';
      settle;
    end procedure;
    procedure run_case(number, av, bv, sv, dv : natural) is
    begin
      test_number <= number; test_a <= av; test_b <= bv;
      expected_sum <= sv; expected_diff <= dv;
      reset <= '1'; btn <= '1'; settle;
      assert led = "0001" report "reset must enter input_a" severity failure;
      reset <= '0'; switch <= std_logic_vector(to_unsigned(av,8)); settle;
      check_display(av);
      press_once("0010");
      switch <= std_logic_vector(to_unsigned(bv,8)); settle;
      check_display(bv);
      press_once("0100");
      check_display(sv);
      switch <= x"FF"; settle;
      check_display(sv);
      press_once("1000");
      check_display(dv);
      press_once("0001");
      check_display(255);
      report "PASS case " & integer'image(number) &
        " A=" & integer'image(av) & " B=" & integer'image(bv) &
        " sum=" & integer'image(sv) & " diff=" & integer'image(dv) severity note;
    end procedure;
  begin
    run_case(1,5,2,7,3);
    run_case(2,2,5,7,509);
    run_case(3,200,100,300,100);
    run_case(4,100,200,300,412);
    run_case(5,0,1,1,511);
    run_case(6,255,255,510,0);
    run_case(7,0,0,0,0);
    -- Reset while in each of the other three states, not only input_a.
    switch <= x"55"; settle;
    for states_to_advance in 1 to 3 loop
      press_once("0010");
      if states_to_advance >= 2 then press_once("0100"); end if;
      if states_to_advance = 3 then press_once("1000"); end if;
      reset <= '1'; settle;
      assert led = "0001" report "reset from a non-input_a state failed" severity failure;
      check_display(0);
      reset <= '0'; settle;
      check_display(85);
    end loop;
    report "ALL LAB 5 CHECKS PASSED" severity note;
    done <= true;
    wait;
  end process;
end architecture;
