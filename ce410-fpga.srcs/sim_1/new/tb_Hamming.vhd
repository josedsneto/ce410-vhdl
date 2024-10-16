----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024
-- Design Name: Hamming Testbench
-- Module Name: tb_Hamming - Testbench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench to simulate the Hamming distance FSM
-- 
-- Dependencies: Hamming.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_Hamming IS
END tb_Hamming;

ARCHITECTURE behavior OF tb_Hamming IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Hamming
    PORT(
         d1 : IN  std_logic_vector(7 downto 0);
         d2 : IN  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         start : IN  std_logic;
         dh : OUT  std_logic_vector(0 to 3); --- MUDAMO AQUI
         ready : OUT  std_logic
        );
    END COMPONENT;
    
    -- Inputs
    signal d1 : std_logic_vector(7 downto 0) := (others => '0');
    signal d2 : std_logic_vector(7 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal start : std_logic := '0';

    -- Outputs
    signal dh : std_logic_vector(3 downto 0);
    signal ready : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Hamming PORT MAP (
          d1 => d1,
          d2 => d2,
          clk => clk,
          rst => rst,
          start => start,
          dh => dh,
          ready => ready
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';

        -- Initialize inputs
        d1 <= "10101010";  -- Example input 1
        d2 <= "11110001";  -- Example input 2
        start <= '1';
        wait for clk_period;
        start <= '0';
        
        -- Wait for the FSM to compute
        wait for clk_period * 20;
        
        rst <= '0';

        -- Test another set of inputs
        d1 <= "11001100";  -- Another test case input 1
        d2 <= "00110011";  -- Another test case input 2
        start <= '1';
        wait for clk_period;
        start <= '0';
        
        -- Wait for the FSM to compute
        wait for clk_period * 20;

        -- Add more test cases if necessary

        -- Finish simulation
        wait;
    end process;

END;
