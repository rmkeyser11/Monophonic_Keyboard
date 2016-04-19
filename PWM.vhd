----------------------------------------------------------------------------------
-- Company: Mac Keyser and Amanda Roberts
-- Engineer: 
-- 
-- Create Date:    14:54:08 08/12/2014 
-- Design Name: 
-- Module Name:    PWM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Pulse Width Modulator for Digital to Audio conversion.
-- Standard processes for incrementor and comparator as well as a feature that trims the 4 least signfigant 
-- bits off of the input. 
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
 Port ( 	  clk : in  STD_LOGIC;
           LUT_val : in  STD_LOGIC_VECTOR(15 downto 0); --need to adjust the value depending on size of LUT
           PWM_out : out  STD_LOGIC);
end PWM;

architecture Behavioral of PWM is

--Signals

signal count : integer := 0;
constant MAX_COUNT : integer := 4096; 
signal lut_12 :unsigned(11 downto 0);

begin

--convert the output of the sine lookup table from 16 bit signed number to a 12 bit unsigned number
lut_12<=unsigned(Not(lut_val(15))&lut_val(14 downto 4));

--Counter that increments by 3's
counter: process (clk)
begin
if rising_edge(clk) then
	if count = MAX_COUNT - 1 then
		count <= 0;
	else
		count <= count + 3;
	end if;
end if;
end process counter;


--Comparator which compares the output of the sine LUT to the counter and asserts the PWM signal
compare: process (LUT_12, count)
begin
	if LUT_12 > count then
		PWM_out <= '1';
	else PWM_out <= '0';
	end if;
end process compare;


end Behavioral;