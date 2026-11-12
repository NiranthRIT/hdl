library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;
entity calculator is
  port (clk, reset, execute : in std_logic;
        switch : in std_logic_vector(7 downto 0);
        op : in std_logic_vector(1 downto 0);
        led : out std_logic_vector(2 downto 0);
        bcd_0, bcd_1, bcd_2 : out std_logic_vector(6 downto 0));
end calculator;
architecture rtl of calculator is
  type state_type is (initializing, ready, calculate, store);
  signal state : state_type := initializing;
  signal clear_addr, latest_addr, next_addr : unsigned(1 downto 0) := (others => '0');
  signal mem_addr : std_logic_vector(1 downto 0);
  signal mem_din, mem_dout : std_logic_vector(7 downto 0);
  signal mem_we, execute_edge : std_logic;
  signal switch_sync, op_sync : std_logic_vector(7 downto 0) := (others => '0');
  signal a_reg, b_reg, alu_result, display_result : std_logic_vector(7 downto 0) := (others => '0');
  signal op_reg : std_logic_vector(1 downto 0) := "00";
  signal ones, tens, hundreds, thousands : std_logic_vector(3 downto 0);
begin
  switch_sync_block : synchronizer_8bit port map(clk, reset, switch, switch_sync);
  op_sync_block : synchronizer_8bit port map(clk, reset, "000000" & op, op_sync);
  execute_sync_block : rising_edge_synchronizer port map(clk, reset, execute, execute_edge);
  alu_block : alu port map(reset, a_reg, b_reg, op_reg, alu_result);
  memory_block : memory generic map(addr_width => 2, data_width => 8)
                        port map(clk, mem_we, mem_addr, mem_din, mem_dout);
  mem_addr <= std_logic_vector(clear_addr) when state = initializing else
              std_logic_vector(next_addr) when state = store else std_logic_vector(latest_addr);
  mem_din <= x"00" when state = initializing else alu_result;
  mem_we <= '1' when reset = '0' and (state = initializing or state = store) else '0';
  -- Display mirrors each memory write. ALU input a is always read from memory.
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= initializing; clear_addr <= "00"; latest_addr <= "00"; next_addr <= "01";
        a_reg <= x"00"; b_reg <= x"00"; op_reg <= "00"; display_result <= x"00";
      else
        case state is
          when initializing =>
            if clear_addr = "11" then state <= ready;
            else clear_addr <= clear_addr + 1; end if;
          when ready =>
            if execute_edge = '1' then
              a_reg <= mem_dout; b_reg <= switch_sync; op_reg <= op_sync(1 downto 0);
              next_addr <= latest_addr + 1; state <= calculate;
            end if;
          when calculate => state <= store;
          when store =>
            latest_addr <= next_addr; display_result <= alu_result; state <= ready;
        end case;
      end if;
    end if;
  end process;
  with state select led <= "000" when initializing, "001" when ready,
                           "010" when calculate, "011" when store;
  bcd_block : double_dabble port map("0000" & display_result, ones, tens, hundreds, thousands);
  ones_block : seven_seg port map(ones, bcd_0);
  tens_block : seven_seg port map(tens, bcd_1);
  hundreds_block : seven_seg port map(hundreds, bcd_2);
end rtl;
