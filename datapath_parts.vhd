----------------------------------------------------------------------------------
-- Company: Engs 31
-- Engineer: Mac Keyser and Amanda Roberts
-- 
-- Create Date:    15:02:19 08/10/2014 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This is the Datapath of the project (minus the LUT and D to A 
-- converter on the output end). It features combinational logic and processes for multiplexer,
-- comparator, Hold register, 65.536 KHz enable generator for LUT, stepsize LUT, and incrementor. 
-- It also has components declared for the controller and the encoder.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity data_setup is
    Port ( clk : in Std_Logic;
			  buttons : in  STD_LOGIC_VECTOR (11 downto 0);
           hold_switch : in  STD_LOGIC;
           Octave_switch : in  STD_LOGIC;
           inc_value : out  STD_LOGIC_VECTOR (15 downto 0);
			  LED : Out STD_LOGIC;
			  LED2 : out std_logic);
end data_setup;

architecture Behavioral of data_setup is

-------------COMPONENT DECLARATIONS----------------------

component controller is
    Port ( Hold : in  STD_LOGIC;
			  octave : in STD_LOGIC;
			  clk : in  STD_LOGIC;
           comp_val : in  STD_LOGIC;
           hold_en : out  STD_LOGIC;
			  oct_on : out  STD_LOGIC;
			  inc_clr : out  STD_LOGIC;
           hold_clr : out  STD_LOGIC;
           mux_en : out  STD_LOGIC);
end component;

component Encoder is
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
			  LED : out STD_LOGIC;
           note : out  STD_LOGIC_VECTOR(3 downto 0));
end component;

--------------SIGNAL DECLRATIONS---------------------------

--Controller Signals
signal comp_val : STD_LOGIC:='0';
signal hold_en : STD_LOGIC;
signal oct_on : STD_LOGIC;
signal hold_clr : STD_LOGIC;
signal inc_clr : STD_LOGIC;
signal mux_en : STD_LOGIC;
signal LED1 : STD_LOGIC;

--Encoder Signals
signal buttondb : STD_LOGIC_VECTOR(11 downto 0);
signal note : STD_LOGIC_VECTOR(3 downto 0);
signal note_sig : unsigned(3 downto 0);

--Datapath Signals
signal note_sig2 : unsigned(3 downto 0);
signal stored : unsigned(3 downto 0):="0000";
signal step : unsigned(8 downto 0):="000000000";				

signal inc : unsigned(15 downto 0):=x"0000";		

-- Signals for the sine wave increment enable, which asserts every 2^16 Hz
constant CLOCK_DIVIDER_VALUE: integer := 1526; 
signal clkdiv : unsigned(10 downto 0):= "00000000000"; 
signal slow_clk : std_logic :='0'; -- sine enable signal

signal c_count : unsigned(15 downto 0) :=x"0000";
signal check : std_logic :='0';
--------------DATAPATH COMBINATIONAL LOGIC-----------------
begin 

buttondb<=buttons;
----Comparator(equals)----
Compare : Process (clk, note_sig)
begin
	if rising_edge(clk) then 
		if note_sig="0000" then
			comp_val<='1';
		else 
			comp_val<='0';
		end if;
	end if;
end process compare;

------Hold function----
Holding : Process (clk, hold_en, hold_clr, mux_en)
begin
	if rising_edge(clk) then
		if hold_clr='1' then
			stored<="0000";
		elsif (hold_en='1') and (hold_clr='0') then
			stored<=note_sig;
		end if;	
	end if;
end process holding;

------Multiplexer----
Mux : process (clk, mux_en, stored, note_sig)
begin
	if mux_en='1' then
		note_sig2<=stored;
	else 								-- mux_en equals 0
		note_sig2<=note_sig;
	end if;
end process mux;

note_sig <= unsigned(note);

----SINE Wave Incrementer Enable----    

Enable: process(clk)
begin
if rising_edge(clk) then
   if clkdiv = CLOCK_DIVIDER_VALUE-1 then 
      slow_clk <= '1';
		clkdiv <= "00000000000";
	else
		clkdiv <= clkdiv + "00000000001";
		slow_clk<='0';
	end if;
end if;
end process enable;

----Incramenter Storage----
step <= "010000011" when note_sig2="0001" and oct_on='0' else
	     "010001011" when note_sig2="0010" and oct_on='0' else
		  "010010011" when note_sig2="0011" and oct_on='0' else
		  "010011100" when note_sig2="0100" and oct_on='0' else
		  "010100101" when note_sig2="0101" and oct_on='0' else
		  "010101111" when note_sig2="0110" and oct_on='0' else
		  "010111001" when note_sig2="0111" and oct_on='0' else
		  "011000100" when note_sig2="1000" and oct_on='0' else
		  "011010000" when note_sig2="1001" and oct_on='0' else
		  "011011100" when note_sig2="1010" and oct_on='0' else
		  "011101001" when note_sig2="1011" and oct_on='0' else
		  "011110111" when note_sig2="1100" and oct_on='0' else
		  "100000110" when note_sig2="0001" and oct_on='1' else
	     "100010101" when note_sig2="0010" and oct_on='1' else
		  "100100110" when note_sig2="0011" and oct_on='1' else
		  "100110111" when note_sig2="0100" and oct_on='1' else
		  "101001010" when note_sig2="0101" and oct_on='1' else
		  "101011101" when note_sig2="0110" and oct_on='1' else
		  "101110010" when note_sig2="0111" and oct_on='1' else
		  "110001000" when note_sig2="1000" and oct_on='1' else
		  "110011111" when note_sig2="1001" and oct_on='1' else
		  "110111000" when note_sig2="1010" and oct_on='1' else
		  "111010010" when note_sig2="1011" and oct_on='1' else
		  "111101110" when note_sig2="1100" and oct_on='1' else
		  "000000000"; 
		
----Incramenter----

--counting
process(clk, slow_clk)
begin
	if rising_edge(clk)then
		if c_count=x"FFFF" then
			check<= not(check);
			c_count<=x"0000";
		elsif slow_clk='1' then
			c_count<=c_count+x"0001";
		end if;
	end if;
end process;
	
--storing

process(clk, inc_clr, slow_clk)
begin
	if rising_edge(clk)then
		if inc_clr='1' then
			inc<=x"0000"; 
		elsif slow_clk='1' then
			inc<=step+inc;
		end if;
	end if;
end process;

inc_value<=std_logic_vector(inc);
LED2<=check;

--------------INSTANTIATIONS------------------------------

--Instantiate Controller
control : controller
	Port Map ( Hold => hold_switch, 			--Mapped to input
			  octave => octave_switch, 		--Mapped to input
			  clk => clk,							--fast clock
           comp_val => comp_val, 
           hold_en => hold_en,
			  oct_on => oct_on,
			  inc_clr => inc_clr,
           hold_clr => hold_clr,
           mux_en => mux_en);

--Instantiate Encoder
Input_encode : Encoder
	Port Map ( clk => clk,
			  c_bt => Buttondb(0),
			  cs_bt => Buttondb(1),
			  d_bt => Buttondb(2),
			  ds_bt => Buttondb(3),
			  e_bt => Buttondb(4),
			  f_bt => Buttondb(5),
			  fs_bt => Buttondb(6),
			  g_bt => Buttondb(7),
			  gs_bt => Buttondb(8),
			  a_bt => Buttondb(9),
			  as_bt => Buttondb(10),
			  b_bt => Buttondb(11),
			  LED=> LED,
           note => note);

end Behavioral;

