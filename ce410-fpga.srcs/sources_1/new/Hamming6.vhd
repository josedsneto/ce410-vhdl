library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Hamming is
    Port ( d1, d2   : in STD_LOGIC_VECTOR (7 downto 0);           
           clk, rst : in STD_LOGIC;
           dh       : out STD_LOGIC_VECTOR (3 downto 0);
           start    : in STD_LOGIC;
           ready    : out STD_LOGIC);
end Hamming;

architecture rtl_mealy of Hamming is
    Type STATE is (IDLE,INC,COMP);
    signal ps, ns: STATE;
    signal i_reg, i_next   : integer := 0;
    signal dh_reg, dh_next : unsigned ( 3 downto 0) := "0000";
    
begin
    process(clk, rst)
    begin
        if rst='1' then
            ps <= IDLE;
            i_reg <= 0;
            dh_reg <= ( others => '0');
        elsif (clk'event and clk='1') then
            ps <= ns;
            i_reg <= i_next;
            dh_reg <= dh_next;
        end if;
    end process;
    
    process (ps, ns, start, d1, d2, i_reg)
    begin
        ns <= ps;
        dh_next <= dh_reg;
        i_next <= i_reg;
        dh <= std_logic_vector(dh_next);
        case ps is
        
            when IDLE => 
                if start = '0' then
                    ns <= IDLE;
                    ready <= '1';           
                else
                    ns <= COMP;
                    ready <= '0';
                end if;
                
            when COMP =>                
                 if d1(i_reg) /= d2(i_reg) then
                    ready <= '0';
                    i_next <= i_reg + 1;
                    dh_next <= dh_reg + 1;
                    ns <= INC;
                 else
                    ready <= '0';
                    i_next <= i_reg + 1;
                    dh_next <= dh_reg;
                    ns <= INC;
                 end if;
            when INC =>
                  if i_reg /= 8 then
                    ready <= '0';              
                    ns <= COMP;
                  else
                    ready <= '1';                
                    ns <= IDLE;
                  end if;        
            end case;
    end process;
end rtl_mealy;
