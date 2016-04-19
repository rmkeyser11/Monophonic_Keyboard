----------------------------------------------------------------------------------
-- Company: Engs 31 14X
-- Engineer: Amanda Roberts and Mac Keyser
-- 
-- Create Date:    14:55:37 08/10/2014 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Controller for the keyboard. % state finite state machine that controls
-- system behavior up to the Sine Wave LUT.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port ( Hold : in  STD_LOGIC;
		octave : in STD_LOGIC;
		clk : in  STD_LOGIC;
		comp_val : in  STD_LOGIC;
		hold_en : out  STD_LOGIC;
		oct_on : out  STD_LOGIC;
		inc_clr : out  STD_LOGIC;
		hold_clr : out  STD_LOGIC;
		mux_en : out  STD_LOGIC);
end controller;

architecture Behavioral of controller is

type state_type is (waiting, clear, normal, collect, idle);
signal state, next_state : state_type;

--create signals for outputs
signal hold_sig, hclr_sig, mux_sig, oct_sig, iclr_sig : std_logic :='0';

begin
--create a process for the controller
control : process (state, hold, comp_val, octave)
begin
	next_state<=state;
	hold_sig<='0';
	hclr_sig<='0';
	iclr_sig<='0';
	oct_sig<=octave;
	mux_sig<='0';
	case state is 
		when waiting=>
			hold_sig<='1';
			if hold='1' then
				next_state<=collect;
			elsif hold = '0' and comp_val='0' then
				next_state<=normal;
		end if;
		when normal=>
			if hold = '1' then
				next_state <= idle;
			elsif comp_val = '1' then
				next_state <= clear;
			end if;
		when collect=>
			mux_sig <= '1';
			hold_sig <= '1';
			if (hold = '1') and (comp_val = '0') then
				next_state <= idle;
			elsif hold = '0' then
				next_state <= waiting;
			end if;
		when idle=>
			mux_sig <= '1';
			hold_sig <= '0';
			if hold = '0' then
				next_state <= clear;
			end if;
		when clear=>
			hclr_sig <= '1';
			iclr_sig <= '1';
			next_state <= waiting;
	end case;
end process control;

--synchronizing state shifts
stateshift : process (clk)
begin
	if rising_edge(clk) then
		state<=next_state;
	end if;
end process stateshift;

--Assigning signals
	hold_en <= hold_sig;
	oct_on <= oct_sig;
	inc_clr <= iclr_sig;
	hold_clr <=hclr_sig;
	mux_en <= mux_sig;

end Behavioral;