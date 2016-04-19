--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:46:50 08/13/2014
-- Design Name:   
-- Module Name:   O:/Engs31/Keyboard/pulsetest.vhd
-- Project Name:  Keyboard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PWM
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
USE ieee.numeric_std.ALL;
 
ENTITY pulsetest IS
END pulsetest;
 
ARCHITECTURE behavior OF pulsetest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM
    PORT(
         clk : IN  std_logic;
         LUT_val : IN  std_logic_vector(15 downto 0);
         PWM_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal LUT_val : std_logic_vector(15 downto 0) := x"0000";

 	--Outputs
   signal PWM_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM PORT MAP (
          clk => clk,
          LUT_val => LUT_val,
          PWM_out => PWM_out
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

		Lut_val<=x"FF00";
		wait for 500 ns;
		
		lut_val<=x"FFFF";
		wait for 500 ns;

      wait;
   end process;

END;
