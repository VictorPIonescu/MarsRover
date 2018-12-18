library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplexer is
  port( clk                       : in std_logic;
        sel                       : in unsigned(1 downto 0);       
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
		    
		    count_reset_left		        : in	std_logic;
		    motor_l_reset_left		      : in	std_logic;
		    motor_l_direction_left	   : in	std_logic;
		    motor_r_reset_left		      : in	std_logic;
		    motor_r_direction_left	   : in	std_logic;
		    
		    count_reset_right   	     : in	std_logic;
		    motor_l_reset_right  		   : in	std_logic;
		    motor_l_direction_right  	: in	std_logic;
		    motor_r_reset_right  		   : in	std_logic;
		    motor_r_direction_right  	: in	std_logic;
		    
		    count_reset		             : out	std_logic;

		    motor_l_reset		     	     : out	std_logic;
		    motor_l_direction	        : out	std_logic;

		    motor_r_reset		     	     : out	std_logic;
		    motor_r_direction	        : out	std_logic
		    );
end entity multiplexer;

architecture behaviour of multiplexer is
--  signal count_reset_s, motor_l_reset_s, motor_l_direction_s, motor_r_reset_s, motor_r_direction_s : std_logic;
 begin 
 
 process(sel,
        count_reset_finder,
		    motor_l_reset_finder,
		    motor_l_direction_finder,
		    motor_r_reset_finder,
		    motor_r_direction_finder,		    
		    count_reset_tracker,
		    motor_l_reset_tracker,
		    motor_l_direction_tracker,
		    motor_r_reset_tracker,
		    motor_r_direction_tracker,
		    count_reset_left,
            motor_l_reset_left,
            motor_l_direction_left,
            motor_r_reset_left,
            motor_r_direction_left,
            
            count_reset_right,
            motor_l_reset_right,
            motor_l_direction_right,
            motor_r_reset_right,
            motor_r_direction_right)
   begin
     case sel is
   when "01" => -- line tracker
        count_reset <= count_reset_tracker;
		    motor_l_reset <= motor_l_reset_tracker;
		    motor_l_direction <= motor_l_direction_tracker;
		    motor_r_reset <= motor_r_reset_tracker;
		    motor_r_direction <= motor_r_direction_tracker;
		when "00" => -- finder
		   count_reset <= count_reset_finder;
		    motor_l_reset <= motor_l_reset_finder;
		    motor_l_direction <= motor_l_direction_finder;
		    motor_r_reset <= motor_r_reset_finder;
		    motor_r_direction <= motor_r_direction_finder;
		when "10" => -- turn left
		    count_reset <= count_reset_left;
		    motor_l_reset <= motor_l_reset_left;
		    motor_l_direction <= motor_l_direction_left;
		    motor_r_reset <= motor_r_reset_left;
		    motor_r_direction <= motor_r_direction_left;
		when "11" => -- turn right
		    count_reset <= count_reset_right;
		    motor_l_reset <= motor_l_reset_right;
		    motor_l_direction <= motor_l_direction_right;
		    motor_r_reset <= motor_r_reset_right;
		    motor_r_direction <= motor_r_direction_right;
		when others =>  -- panic
		    count_reset <= count_reset_tracker;
		    motor_l_reset <= motor_l_reset_tracker;
		    motor_l_direction <= motor_l_direction_tracker;
		    motor_r_reset <= motor_r_reset_tracker;
		    motor_r_direction <= motor_r_direction_tracker;
		end case;
--		    count_reset <= count_reset;
--        motor_l_reset <= motor_l_reset;
--        motor_r_reset <= motor_r_reset;
--        motor_l_direction <= motor_l_direction;
--        motor_r_direction <= motor_r_direction;
   end process;
end architecture;
    


