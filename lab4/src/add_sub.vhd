-------------------------------------------------------------------------------
-- CPET-343 Lab 4 - 3-bit add/subtract top level for Dr. Kaputa's pin map.
-- KEY buttons are physically active-low. Reset is the active-high SW0 switch.
-- A button selects the operation; changing synchronized operands updates result.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity add_sub is
  port (clk : in std_logic; reset : in std_logic;
        a : in std_logic_vector(2 downto 0);
        b : in std_logic_vector(2 downto 0);
        add_btn : in std_logic; sub_btn : in std_logic;
        a_bcd : out std_logic_vector(6 downto 0);
        b_bcd : out std_logic_vector(6 downto 0);
        result_bcd : out std_logic_vector(6 downto 0));
end entity;

architecture structural of add_sub is
  signal reset_sync : std_logic;
  signal a_sync : std_logic_vector(2 downto 0);
  signal b_sync : std_logic_vector(2 downto 0);
  signal add_sync, sub_sync : std_logic;
  signal add_en, sub_en : std_logic;
  signal subtract : std_logic := '0';
  signal result : std_logic_vector(3 downto 0);
begin
  reset_input : entity work.reset_synchronizer(beh)
    port map (clk => clk, async_reset => reset, sync_reset => reset_sync);
  a_input : entity work.synchronizer_3bit(beh)
    port map (clk => clk, reset => reset_sync, async_in => a, sync_out => a_sync);
  b_input : entity work.synchronizer_3bit(beh)
    port map (clk => clk, reset => reset_sync, async_in => b, sync_out => b_sync);
  add_input : entity work.rising_edge_synchronizer(beh)
    port map (clk => clk, reset => reset_sync, async_in => not add_btn,
              sync_out => add_sync, edge_out => add_en);
  sub_input : entity work.rising_edge_synchronizer(beh)
    port map (clk => clk, reset => reset_sync, async_in => not sub_btn,
              sync_out => sub_sync, edge_out => sub_en);

  operation_select : process(clk, reset_sync)
  begin
    if reset_sync = '1' then
      subtract <= '0';
    elsif rising_edge(clk) then
      if add_en = '1' then
        subtract <= '0';
      elsif sub_en = '1' then
        subtract <= '1';
      end if;
    end if;
  end process;

  arithmetic : entity work.generic_add_sub(beh)
    generic map (bits => 3)
    port map (a => a_sync, b => b_sync, subtract => subtract, result => result);
  display_a : entity work.seven_seg(beh)
    port map (bcd => '0' & a_sync, segments => a_bcd);
  display_b : entity work.seven_seg(beh)
    port map (bcd => '0' & b_sync, segments => b_bcd);
  display_result : entity work.seven_seg(beh)
    port map (bcd => result, segments => result_bcd);
end architecture;
