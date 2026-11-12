-------------------------------------------------------------------------------
-- CPET-343 Lab 5. Sequential entry of two unsigned eight-bit numbers.
-- reset = physical SW0. switch(7 downto 0) = physical SW9 downto SW2.
-- btn = active-low physical KEY0. HEX2..0 show hundreds, tens, ones.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_state_machine is
  port (clk : in std_logic;
        reset : in std_logic;
        switch : in std_logic_vector(7 downto 0);
        btn : in std_logic;
        led : out std_logic_vector(3 downto 0);
        bcd_0 : out std_logic_vector(6 downto 0);
        bcd_1 : out std_logic_vector(6 downto 0);
        bcd_2 : out std_logic_vector(6 downto 0));
end entity;

architecture beh of add_sub_state_machine is
  type state_type is (input_a, input_b, disp_sum, disp_diff);
  signal state : state_type := input_a;
  signal reset_flop1 : std_logic := '0';
  signal reset_sync : std_logic := '0';
  signal switch_sync : std_logic_vector(7 downto 0) := (others => '0');
  signal button_pulse : std_logic := '0';
  signal button_active : std_logic;
  signal a : std_logic_vector(7 downto 0) := (others => '0');
  signal b : std_logic_vector(7 downto 0) := (others => '0');
  signal subtract : std_logic;
  signal result : std_logic_vector(8 downto 0);
  signal display_value : std_logic_vector(8 downto 0);
  signal result_padded : std_logic_vector(11 downto 0);
  signal ones, tens, hundreds : std_logic_vector(3 downto 0);
begin
  -- Synchronize the physical active-high reset switch to the 50 MHz clock.
  process(clk)
  begin
    if rising_edge(clk) then
      reset_flop1 <= reset;
      reset_sync <= reset_flop1;
    end if;
  end process;

  switches : entity work.synchronizer_8bit
    port map(clk => clk, reset => reset_sync,
             async_in => switch, sync_out => switch_sync);
  button_active <= not btn;
  button : entity work.rising_edge_synchronizer
    port map(clk => clk, reset => reset_sync,
             async_in => button_active, pulse => button_pulse);

  process(clk)
  begin
    if rising_edge(clk) then
      if reset_sync = '1' then
        state <= input_a;
        a <= (others => '0');
        b <= (others => '0');
      elsif button_pulse = '1' then
        case state is
          when input_a => a <= switch_sync; state <= input_b;
          when input_b => b <= switch_sync; state <= disp_sum;
          when disp_sum => state <= disp_diff;
          when disp_diff => state <= input_a;
        end case;
      end if;
    end if;
  end process;

  subtract <= '1' when state = disp_diff else '0';
  arithmetic : entity work.generic_add_sub
    generic map(bits => 8)
    port map(a => a, b => b, subtract => subtract, result => result);

  display_value <= '0' & switch_sync when state = input_a or state = input_b
                   else result;
  result_padded <= "000" & display_value;
  decimal_converter : entity work.double_dabble
    port map(result_padded => result_padded, ones => ones,
             tens => tens, hundreds => hundreds);
  units_display : entity work.seven_seg port map(bcd => ones, segments => bcd_0);
  tens_display : entity work.seven_seg port map(bcd => tens, segments => bcd_1);
  hundreds_display : entity work.seven_seg port map(bcd => hundreds, segments => bcd_2);

  with state select led <=
    "0001" when input_a,
    "0010" when input_b,
    "0100" when disp_sum,
    "1000" when disp_diff;
end architecture;
