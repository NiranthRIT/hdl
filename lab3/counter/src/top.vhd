-------------------------------------------------------------------------------
-- Lab 3 counter. Uses the professor's generic counter and behavioral adder.
-- max_count=49,999,999 gives one enable pulse per second at 50 MHz.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  generic (max_count : integer := 49999999);
  port (clk : in std_logic; reset : in std_logic;
        seven_seg_out : out std_logic_vector(6 downto 0));
end top;

architecture beh of top is
  signal enable : std_logic;
  signal digit : std_logic_vector(3 downto 0) := "0000";
  signal sum_sig : std_logic_vector(3 downto 0);
begin
  timing : entity work.generic_counter(beh)
    generic map(max_count => max_count)
    port map(clk => clk, reset => reset, output => enable);
  increment : entity work.generic_adder_beh(beh)
    generic map(bits => 4)
    port map(a => digit, b => "0001", cin => '0', sum => sum_sig, cout => open);

  sum_register : process(clk, reset)
  begin
    if reset = '1' then
      digit <= "0000";
    elsif rising_edge(clk) then
      if enable = '1' then
        if digit = "1001" then
          digit <= "0000";
        else
          digit <= sum_sig;
        end if;
      end if;
    end if;
  end process;

  display : entity work.seven_seg(beh)
    port map(clk => clk, reset => reset, bcd => digit, seven_seg_out => seven_seg_out);
end beh;
