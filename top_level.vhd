----------------------------------------------------------------------------------
-- Company: Engs 31 14X
-- Engineer: Mac Keyser and Amanda roberts
-- 
-- Create Date:    14:59:30 08/12/2014 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This is the highest level module. Instatiated in are 3 components
--		1)The datapath/controller module
--		2)The Sine wave core
--		3)The Digital to analog converter (Pulse Width Modulator)
--There are alo a few other minor features, most noteably LED signals for when the switches 
--are flipped on and the systems on/off switch
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top_level is
    Port ( buttons : in  STD_LOGIC_VECTOR (11 downto 0);
           clk : in  STD_LOGIC;
			  on_off : in STD_LOGIC;
           octave_switch : in  STD_LOGIC;
           hold_switch : in  STD_LOGIC;
           serial_pwm : out  STD_LOGIC;
			  LED1 : out STD_LOGIC;
			  power_switch : out STD_LOGIC;
			  LED2 : out STD_LOGIC;
			  LED_on : out STD_LOGIC;
			  LED_hold : out STD_LOGIC;
			  LED_oct : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

------------COMPONENT DECLARATIONS--------------------

Component data_setup is 
	port   (clk : in Std_Logic;
			  buttons : in  STD_LOGIC_VECTOR (11 downto 0);
           hold_switch : in  STD_LOGIC;
           Octave_switch : in  STD_LOGIC;
           inc_value : out  STD_LOGIC_VECTOR (15 downto 0);
			  LED : out STD_LOGIC;
			  LED2 : out STD_LOGIC);
end component;

COMPONENT top_wave
  PORT (
    clk : IN STD_LOGIC;
    phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    sine : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

component PWM is
    Port ( clk : in  STD_LOGIC;
           LUT_val : in  STD_LOGIC_VECTOR(15 downto 0); --need to adjust the value depending on size of LUT
           PWM_out : out  STD_LOGIC);
end component;

------------SIGNALS-----------------------------------

signal Lut_phase : std_logic_vector(15 downto 0);
signal Lut_out : std_logic_vector(15 downto 0);
signal power_sig : std_logic := '0';

begin

--Turn the speaker off and on
power : process(on_off)
begin
	if on_off = '1' then
		power_sig <= '1';
		LED_on <= '1';
	else power_sig <= '0'; 
		LED_on <= '0';
	end if;
end process power;

power_switch <= power_sig;

--Assert LEDs when switches are activated
LED_hold <= '1' when hold_switch = '1' else '0';
LED_oct <= '1' when octave_switch = '1' else '0';


------------INSTANTIATIONS-----------------------

--Instantiate datapath
start_data : data_setup
port map( clk => clk,
			  buttons => buttons,
           hold_switch => hold_switch,
           Octave_switch => octave_switch,
           inc_value => lut_phase,
			  LED1out => LED1,
			  LED2 => LED2);

--Instantiate Wave LUT
wave_storage : top_wave
  PORT MAP (
    clk => clk,
    phase_in => lut_phase,
    sine => lut_out);

--Instantiate PWM
D_to_A : PWM
port map( clk => clk,
           LUT_val => Lut_out,
           PWM_out => serial_pwm);
			  
end Behavioral;

