library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplexer is
  port( clk                       : in std_logic;
        line_finder_done          : in std_logic;
        
        count_reset_finder		      : in	std_logic;
		    motor_l_reset_finder		    : in	std_logic;
		    motor_l_direction_finder	 : in	std_logic;
		    motor_r_reset_finder		    : in	std_logic;
		    motor_r_direction_finder	 : in	std_logic;
		    
		    count_reset_tracker		     : in	std_logic;
		    motor_l_reset_tracker		   : in	std_logic;
		    motor_l_direction_tracker	: in	std_logic;
		    motor_r_reset_tracker		   : in	std_logic;
		    motor_r_direction_tracker	: in	std_logic;
		    
		    count_reset		             : out	std_logic;

		    motor_l_reset		     	     : out	std_logic;
		    motor_l_direction	        : out	std_logic;

		    motor_r_reset		     	     : out	std_logic;
		    motor_r_direction	        : out	std_logic
		    );
end entity multiplexer;

architecture behaviour of multiplexer is
  signal count_reset_s, motor_l_reset_s, motor_l_direction_s, motor_r_reset_s, motor_r_direction_s : std_logic;
 begin 
 
 process(line_finder_done,
        count_reset_finder,
		    motor_l_reset_finder,
		    motor_l_direction_finder,
		    motor_r_reset_finder,
		    motor_r_direction_finder,		    
		    count_reset_tracker,
		    motor_l_reset_tracker,
		    motor_l_direction_tracker,
		    motor_r_reset_tracker,
		    motor_r_direction_tracker)
   begin
     if (line_finder_done = '1') then
        count_reset_s <= count_reset_tracker;
		    motor_l_reset_s <= motor_l_reset_tracker;
		    motor_l_direction_s <= motor_l_direction_tracker;
		    motor_r_reset_s <= motor_r_reset_tracker;
		    motor_r_direction_s <= motor_r_direction_tracker;
		else
		   count_reset_s <= count_reset_finder;
		    motor_l_reset_s <= motor_l_reset_finder;
		    motor_l_direction_s <= motor_l_direction_finder;
		    motor_r_reset_s <= motor_r_reset_finder;
		    motor_r_direction_s <= motor_r_direction_finder;
		end if;
		count_reset <= count_reset_s;
        motor_l_reset <= motor_l_reset_s;
        motor_r_reset <= motor_r_reset_s;
        motor_l_direction <= motor_l_direction_s;
        motor_r_direction <= motor_r_direction_s;
   end process;
end architecture;
    


