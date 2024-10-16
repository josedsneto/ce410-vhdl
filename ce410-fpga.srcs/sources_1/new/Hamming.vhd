----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 01:00:23 PM
-- Design Name: 
-- Module Name: Hamming - Bhv
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hamming is
    Port ( d1, d2 : in STD_LOGIC_VECTOR (7 downto 0);
           
           clk, rst : in STD_LOGIC;
           
           dh : out STD_LOGIC_VECTOR (3 downto 0);
           
           start : in STD_LOGIC;
           ready: out STD_LOGIC);
end Hamming;

architecture rtl of Hamming is

signal r : STD_LOGIC;

begin
toggle: process (clk, rst, r)
    variable i: integer := 0;
    variable my_dh: integer := 0;
    begin 
        if clk'event and clk='1' then
            if rst = '1' then
                dh <= "0000";
                ready <= '1'; 
            elsif start = '1' then
                r <= ( d1(i) xnor d2(i) );
                if r = '1' then
                    my_dh := my_dh + 1;
                    i := i + 1;
                else
                    i := i + 1;
                end if;
            end if;
        end if;
        dh <= conv_std_logic_vector(my_dh, dh'length);
    end process;
end rtl;

architecture fsm_mealy of Hamming is
    Type STATE is (E0,E1);
    signal ps, ns: STATE;
begin
    process(clk, rst)
        begin
            if (clk'event and clk='1') then
                if rst='1' then
                    ps <= E0;
                else
                    ps <= ns;
                end if;
            end if;
    end process;
    
    process (ps, ns, start)
        variable i: integer range 0 to 8;
        variable dh_temp : integer range 0 to 8;
        variable i_temp: integer range 0 to 8;
        begin
        ns <= E0;
        case ps is
            when E0 => ready <= '1'; --IDLE
                if start = '1' then
                    i := 0;
                    ns <= E1;
                    dh_temp := 0;
                else
                    ns <= E0;
                end if;
            when E1 => ready <= '0';  --OP
                if (d1(i) = d2(i)) then
                    dh_temp := dh_temp + 1;                 
                    dh <= conv_std_logic_vector(dh_temp, dh'length);
                    i_temp := i + 1;
                    i := i_temp;
                else
                    i_temp := i + 1;
                    i := i_temp;
                end if;
                 
                if (i = 7) then
                    ns <= E0;
                else
                    ns <= E1;
                end if;
            end case;
    end process;
end fsm_mealy;