library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Hamming2 is
    Port ( d1, d2   : in STD_LOGIC_VECTOR (7 downto 0);           
           clk, rst : in STD_LOGIC;
           dh       : out STD_LOGIC_VECTOR (3 downto 0);
           start    : in STD_LOGIC;
           ready    : out STD_LOGIC);
end Hamming2;

architecture rtl_mealy of Hamming2 is
    Type STATE is (IDLE,OPERATION);
    signal ps, ns: STATE;
    signal i_reg, i_next   : integer := 0;
    signal r_reg, r_next: STD_LOGIC := '0';
    signal dh_reg, dh_next : unsigned ( 3 downto 0) := "0000";
    
begin
    process(clk, rst)
    begin
        if (clk'event and clk='1') then
            if rst='1' then
                ps <= IDLE;
                i_reg <= 0;
                r_reg <= '0';
                dh_reg <= ( others => '0');
            else
                ps <= ns;
                r_reg <= r_next;
                i_reg <= i_next;
                dh_reg <= dh_next;
            end if;
        end if;
    end process;
    
    process (ps, ns, start, d1, d2, i_reg, dh_reg, r_reg)
    begin
        ns <= ps;
        dh_next <= dh_reg;
        r_next <= r_reg;
        i_next <= i_reg;
        case ps is
            when IDLE => 
                ready <= '1';
                i_next <= 0;
                dh_next <= "0000";
                if start = '1' then
                    ns <= OPERATION;
                end if;
            when OPERATION => 
                ready <= '0';
                i_next <= i_reg + 1; 
                r_next <= ( d1(i_reg) xor d2(i_reg) );    
                if r_reg = '1' and i_reg < 7 then
                    dh_next <= dh_reg + 1;
                    ns <= OPERATION;
                    
                elsif r_reg = '0' and i_reg < 7 then
                    ns <= OPERATION;
                    
                elsif i_reg >= 7 then
                    dh <= std_logic_vector(dh_next);
                    ns <= IDLE;
                end if;             
            end case;
    end process;
end rtl_mealy;
