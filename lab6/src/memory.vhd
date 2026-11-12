library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memory is
  generic (addr_width : integer := 2; data_width : integer := 4);
  port (clk, we : in std_logic;
        addr : in std_logic_vector(addr_width - 1 downto 0);
        din : in std_logic_vector(data_width - 1 downto 0);
        dout : out std_logic_vector(data_width - 1 downto 0));
end memory;
architecture rtl of memory is
  type ram_type is array (0 to 2**addr_width - 1) of std_logic_vector(data_width - 1 downto 0);
  signal ram : ram_type := (others => (others => '0'));
begin
  process(clk)
  begin
    if rising_edge(clk) and we = '1' then
      ram(to_integer(unsigned(addr))) <= din;
    end if;
  end process;
  dout <= (others => '0') when is_x(addr) else ram(to_integer(unsigned(addr)));
end rtl;
