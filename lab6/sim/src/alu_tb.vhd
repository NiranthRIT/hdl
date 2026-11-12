library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_tb is end;
architecture test of alu_tb is
  signal reset : std_logic := '0';
  signal done : boolean := false;
  signal a,b,result : std_logic_vector(7 downto 0) := x"00";
  signal op : std_logic_vector(1 downto 0) := "00";
begin
  dut : entity work.alu port map(reset,a,b,op,result);
  process
    variable expected : integer;
  begin
    for operation in 0 to 3 loop
      op <= std_logic_vector(to_unsigned(operation,2));
      for av in 0 to 255 loop
        a <= std_logic_vector(to_unsigned(av,8));
        for bv in 0 to 255 loop
          b <= std_logic_vector(to_unsigned(bv,8)); wait for 1 ns;
          case operation is
            when 0 => expected := (av + bv) mod 256;
            when 1 => expected := (av - bv) mod 256;
            when 2 => expected := (av * bv) mod 256;
            when others => if bv = 0 then expected := 0; else expected := av / bv; end if;
          end case;
          assert to_integer(unsigned(result)) = expected report "ALU arithmetic mismatch" severity failure;
        end loop;
      end loop;
    end loop;
    reset <= '1'; a <= x"FF"; b <= x"00"; wait for 1 ns;
    assert result = x"00" report "ALU reset mismatch" severity failure;
    report "PASS ALU 262144 combinations plus reset" severity note;
    done <= true;
    
    wait;
  end process;
end;
