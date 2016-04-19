----------------------------------------------------------------------------------
-- Company: Engs 31 14X	
-- Engineer: Mac Keyser and Amanda Roberts
-- 
-- Create Date:    11:35:39 08/08/2014 
-- Design Name: 
-- Module Name:    Encoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 12 buttong encoder designed as a 13 state FSM (12 different button 
-- states and 1 waiting state). The Encoder was designed like this In order to only allow 
-- one button to be played at a time. 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encoder is
    Port ( clk : in  STD_LOGIC;
			  c_bt : in  STD_LOGIC;
			  cs_bt : in  STD_LOGIC;
			  d_bt : in  STD_LOGIC;
			  ds_bt : in  STD_LOGIC;
			  e_bt : in  STD_LOGIC;
			  f_bt : in  STD_LOGIC;
			  fs_bt : in  STD_LOGIC;
			  g_bt : in  STD_LOGIC;
			  gs_bt : in  STD_LOGIC;
			  a_bt : in  STD_LOGIC;
			  as_bt : in  STD_LOGIC;
			  b_bt : in  STD_LOGIC;
			  LED : out  STD_LOGIC;
           note : out  STD_LOGIC_VECTOR(3 downto 0));
end Encoder;

architecture Behavioral of Encoder is

type state_type is (waiting,c,c_s,d,d_s,e,f,f_s,g,g_s,a,a_s,b);
signal state, next_state : state_type;

signal note_sig : std_logic_vector(3 downto 0);

begin

Encode_control : process(state,c_bt,cs_bt,d_bt,ds_bt,e_bt,f_bt,fs_bt,g_bt,gs_bt,a_bt,as_bt,b_bt)
begin
	next_state<=state;
	note_sig<="0000";
	LED<='0';
	case state is
		when waiting=>
			note_sig<="0000";
			LED<='0';
			if c_bt = '1' then
				next_state<=c;
			elsif cs_bt = '1' then
				next_state<=c_s;
			elsif d_bt = '1' then
				next_state<=d;
			elsif ds_bt = '1' then
				next_state<=d_s;
			elsif e_bt = '1' then
				next_state<=e;  
			elsif f_bt = '1' then
				next_state<=f;
			elsif fs_bt = '1' then
				next_state<=f_s;
			elsif g_bt = '1' then
				next_state<=g;
			elsif gs_bt = '1' then
				next_state<=g_s;
			elsif a_bt = '1' then
				next_state<=a;
			elsif as_bt = '1' then
				next_state<=a_s;
			elsif b_bt = '1' then
				next_state<=b;
			else
				next_state<=waiting;
			end if;
		when c=>
			LED<='1';
			note_sig<="0001";
			if c_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when c_s=>
			LED<='1';
			note_sig<="0010";
			if cs_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when d=>
			LED<='1';
			note_sig<="0011";
			if d_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when d_s=>
			LED<='1';
			note_sig<="0100";
			if ds_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when e=>
			LED<='1';
			note_sig<="0101";
			if e_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when f=>
			LED<='1';
			note_sig<="0110";
			if f_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when f_s=>
			LED<='1';
			note_sig<="0111";
			if fs_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when g=>
			LED<='1';
			note_sig<="1000";
			if g_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when g_s=>
			LED<='1';
			note_sig<="1001";
			if gs_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when a=>
			LED<='1';
			note_sig<="1010";
			if a_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when a_s=>
			LED<='1';
			note_sig<="1011";
			if as_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
		when b=>
			LED<='1';
			note_sig<="1100";
			if b_bt = '0' then 
				next_state<=waiting;
			else
				next_state<=state;
			end if;
	end case;
end process encode_control;
	
stateshift : process (clk)
begin
	if rising_edge(clk) then
		state<=next_state;
	end if;
end process stateshift;

note<=note_sig;

end Behavioral;

