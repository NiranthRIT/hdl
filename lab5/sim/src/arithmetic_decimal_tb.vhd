library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic_decimal_tb is
end entity;
architecture arch of arithmetic_decimal_tb is
  signal a,b : std_logic_vector(7 downto 0) := (others => '0');
  signal subtract : std_logic := '0';
  signal result : std_logic_vector(8 downto 0);
  signal padded : std_logic_vector(11 downto 0);
  signal ones,tens,hundreds : std_logic_vector(3 downto 0);
begin
  arithmetic : entity work.generic_add_sub generic map(bits=>8)
    port map(a=>a,b=>b,subtract=>subtract,result=>result);
  padded <= "000" & result;
  converter : entity work.double_dabble
    port map(result_padded=>padded,ones=>ones,tens=>tens,hundreds=>hundreds);
  check_all : process
    variable value : natural;
  begin
    for av in 0 to 255 loop
      for bv in 0 to 255 loop
        a <= std_logic_vector(to_unsigned(av,8));
        b <= std_logic_vector(to_unsigned(bv,8));
        for mode in 0 to 1 loop
          if mode=0 then subtract<='0'; value:=av+bv;
          else subtract<='1'; value:=(av+512-bv) mod 512; end if;
          wait for 1 ns;
          assert to_integer(unsigned(result))=value
            report "arithmetic mismatch" severity failure;
          assert to_integer(unsigned(ones))=value mod 10 and
                 to_integer(unsigned(tens))=(value/10) mod 10 and
                 to_integer(unsigned(hundreds))=value/100
            report "BCD mismatch" severity failure;
        end loop;
      end loop;
    end loop;
    report "PASS all 131072 eight-bit add/subtract and decimal conversions" severity note;
    wait;
  end process;
end architecture;
