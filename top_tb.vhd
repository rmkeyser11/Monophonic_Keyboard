--------------------------------------------------------------------------------
-- Company: Mac Keyser and Amanda Roberts
-- Engineer:
--
-- Create Date:   14:20:00 08/13/2014
-- Design Name:   
-- Module Name:   O:/Engs31/Keyboard/top_tb.vhd
-- Project Name:  Keyboard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_level
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_level
    PORT(
         buttons : IN  std_logic_vector(11 downto 0);
         clk : IN  std_logic;
         octave_switch : IN  std_logic;
         hold_switch : IN  std_logic;
         serial_pwm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal buttons : std_logic_vector(11 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal octave_switch : std_logic := '0';
   signal hold_switch : std_logic := '0';

 	--Outputs
   signal serial_pwm : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_level PORT MAP (
          buttons => buttons,
          clk => clk,
          octave_switch => octave_switch,
          hold_switch => hold_switch,
          serial_pwm => serial_pwm
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
wait for clk_period*10;

      buttons<="000000000001";
--			wait for 10000 us;
--			
--		buttons<="000000000000";
--			wait for 50 us;
--		
--		buttons<="000000000010";
--		hold_switch<='0';
--			wait for 50 us;
--	
--		hold_switch<='1';
--			wait for 50 us;
--		
--		buttons<="000000000000";
--		hold_switch<='1';
--			wait for 100 us;
--		
--		hold_switch<='0';
--			wait for clk_period*10;		

      wait;
   end process;

END;
