--------------------------------------------------------------------------------
-- Company: Engs 31 14X
-- Engineer: Mac Keyser and Amanda Roberts
--
-- Create Date:   10:48:47 08/11/2014
-- Design Name:   
-- Module Name:   O:/Engs31/Keyboard/datapathtb.vhd
-- Project Name:  Keyboard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
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
 
ENTITY datapathtb IS
END datapathtb;
 
ARCHITECTURE behavior OF datapathtb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_setup
    PORT(
         clk : IN  std_logic;
         buttons : IN  std_logic_vector(11 downto 0);
         hold_switch : IN  std_logic;
         Octave_switch : IN  std_logic;
         inc_value : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal buttons : std_logic_vector(11 downto 0) := (others => '0');
   signal hold_switch : std_logic := '0';
   signal Octave_switch : std_logic := '0';

 	--Outputs
   signal inc_value : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_setup PORT MAP (
          clk => clk,
          buttons => buttons,
          hold_switch => hold_switch,
          Octave_switch => Octave_switch,
          inc_value => inc_value
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

      buttons<="000000000001";
			wait for 100 us;
			
		buttons<="000000000000";
			wait for 50 us;
		
		buttons<="000000000010";
		hold_switch<='0';
			wait for 50 us;
	
		hold_switch<='1';
			wait for 50 us;
		
		buttons<="000000000000";
		hold_switch<='1';
			wait for 100 us;
		
		hold_switch<='0';
			wait for clk_period*10;		

      wait;
   end process;

END;
