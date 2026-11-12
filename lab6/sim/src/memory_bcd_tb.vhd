library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memory_bcd_tb is end;
architecture test of memory_bcd_tb is
  signal clk : std_logic := '0';
  signal done : boolean := false;
  signal we : std_logic := '0';
  signal addr : std_logic_vector(1 downto 0) := "00";
  signal din,dout : std_logic_vector(7 downto 0) := x"00";
  signal value : std_logic_vector(11 downto 0) := x"000";
  signal ones,tens,hundreds,thousands : std_logic_vector(3 downto 0);
begin
  clk <= not clk after 10 ns when not done else '0';
  ram : entity work.memory generic map(2,8) port map(clk,we,addr,din,dout);
  bcd : entity work.double_dabble port map(value,ones,tens,hundreds,thousands);
  process
  begin
    for n in 0 to 3 loop
      addr <= std_logic_vector(to_unsigned(n,2)); wait for 1 ns;
      assert dout = x"00" report "Memory initial mismatch" severity failure;
    end loop;
    for n in 0 to 3 loop
      addr <= std_logic_vector(to_unsigned(n,2)); din <= std_logic_vector(to_unsigned(n*41+7,8)); we <= '1';
      wait until rising_edge(clk); wait for 1 ns;
    end loop;
    we <= '0';
    for n in 0 to 3 loop
      addr <= std_logic_vector(to_unsigned(n,2)); wait for 1 ns;
      assert to_integer(unsigned(dout)) = n*41+7 report "Memory history mismatch" severity failure;
    end loop;
    addr <= "00"; din <= x"FF"; we <= '1'; wait until rising_edge(clk); wait for 1 ns;
    assert dout = x"FF" report "Memory wrap write mismatch" severity failure;
    we <= '0'; addr <= "01"; wait for 1 ns;
    assert to_integer(unsigned(dout)) = 48 report "Memory other history overwritten" severity failure;
    for n in 0 to 4095 loop
      value <= std_logic_vector(to_unsigned(n,12)); wait for 1 ns;
      assert to_integer(unsigned(ones)) = n mod 10 and
             to_integer(unsigned(tens)) = (n/10) mod 10 and
             to_integer(unsigned(hundreds)) = (n/100) mod 10 and
             to_integer(unsigned(thousands)) = n/1000
        report "Double dabble mismatch" severity failure;
    end loop;
    report "PASS memory stores/history/wrap plus all 4096 BCD inputs" severity note;
    done <= true;
    wait;
  end process;
end;
