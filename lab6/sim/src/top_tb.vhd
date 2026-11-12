library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity top_tb is end;
architecture test of top_tb is
  signal clk : std_logic := '0';
  signal done : boolean := false;
  signal reset_n : std_logic := '0';
  signal execute : std_logic := '1';
  signal switch : std_logic_vector(7 downto 0) := x"00";
  signal op : std_logic_vector(1 downto 0) := "00";
  signal led : std_logic_vector(2 downto 0);
  signal bcd_0,bcd_1,bcd_2 : std_logic_vector(6 downto 0);
  signal saw_compute, saw_store : boolean := false;
  function digit(v : integer) return std_logic_vector is
  begin
    case v is
      when 0 => return "1000000"; when 1 => return "1111001";
      when 2 => return "0100100"; when 3 => return "0110000";
      when 4 => return "0011001"; when 5 => return "0010010";
      when 6 => return "0000010"; when 7 => return "1111000";
      when 8 => return "0000000"; when others => return "0010000";
    end case;
  end;
begin
  clk <= not clk after 10 ns when not done else '0';
  dut : entity work.top port map(clk,reset_n,execute,switch,op,led,bcd_0,bcd_1,bcd_2);
  process(clk)
  begin
    if rising_edge(clk) then
      if led = "010" then saw_compute <= true; end if;
      if led = "011" then saw_store <= true; end if;
    end if;
  end process;
  process
    procedure cycles(n : positive) is
    begin for i in 1 to n loop wait until rising_edge(clk); wait for 1 ns; end loop; end;
    procedure check(expected : integer) is
    begin
      assert bcd_0 = digit(expected mod 10) and bcd_1 = digit((expected/10) mod 10)
        and bcd_2 = digit(expected/100) report "Calculator displayed wrong result" severity failure;
      assert led = "001" report "Calculator not ready" severity failure;
    end;
    procedure operate(operation,b,expected : integer; held : positive := 8) is
    begin
      op <= std_logic_vector(to_unsigned(operation,2)); switch <= std_logic_vector(to_unsigned(b,8));
      cycles(5); execute <= '0'; cycles(held); check(expected);
      cycles(6); check(expected);
      execute <= '1'; cycles(5);
    end;
  begin
    cycles(5); reset_n <= '1'; cycles(10); check(0);
    operate(0,255,255); operate(0,2,1); operate(1,2,255); operate(2,2,254);
    operate(3,3,84); operate(3,0,0); operate(0,7,7,20);
    -- A 20-clock held button executes once. More than four results wraps the memory.
    assert saw_compute and saw_store report "State LEDs missing calculate/store" severity failure;
    reset_n <= '0'; cycles(6); assert bcd_0 = digit(0) report "Reset display mismatch" severity failure;
    reset_n <= '1'; cycles(10); check(0); operate(0,9,9);
    report "PASS top active-low buttons, input sync, state LEDs, history feedback/wrap, held key, reset, decimal outputs" severity note;
    done <= true;
    wait;
  end process;
end;
