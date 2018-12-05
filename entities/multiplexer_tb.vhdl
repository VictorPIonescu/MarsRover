library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplexer_tb is
end entity multiplexer_tb;

architecture structural of multiplexer_tb is
  component multiplexer is
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
end component multiplexer;

signal clk, line_finder_done, 
       count_reset_finder, 
       motor_l_reset_finder, motor_l_direction_finder, 
       motor_r_reset_finder, motor_r_direction_finder,
       count_reset_tracker,
       motor_l_reset_tracker, motor_l_direction_tracker,
       motor_r_reset_tracker, motor_r_direction_tracker,
       count_reset,
       motor_l_reset, motor_l_direction,
       motor_r_reset, motor_r_direction : std_logic;
       
       
begin
  clk <= '1' after 0 ns,
         '0' after 5 ns when clk /= '0' else '1' after 5 ns;
           
        line_finder_done          <= '0' after 0 ns;
        
        count_reset_finder		      <= '0' after 0 ns,
                                     '1' after 100 ns;
		    motor_l_reset_finder		    <= '0' after 0 ns,
                                     '1' after 100 ns;
		    motor_l_direction_finder	 <= '0' after 0 ns,
                                     '1' after 100 ns;
		    motor_r_reset_finder		    <= '0' after 0 ns,
                                     '1' after 100 ns;
		    motor_r_direction_finder	 <= '0' after 0 ns,
                                     '1' after 100 ns;
		    
		    count_reset_tracker		     <= '0' after 0 ns;
		    motor_l_reset_tracker		   <= '0' after 0 ns;
		    motor_l_direction_tracker	<= '0' after 0 ns;
		    motor_r_reset_tracker		   <= '0' after 0 ns;
		    motor_r_direction_tracker	<= '0' after 0 ns;
  
  lbl0: multiplexer port map (clk, line_finder_done, 
       count_reset_finder, 
       motor_l_reset_finder, motor_l_direction_finder, 
       motor_r_reset_finder, motor_r_direction_finder,
       count_reset_tracker,
       motor_l_reset_tracker, motor_l_direction_tracker,
       motor_r_reset_tracker, motor_r_direction_tracker,
       count_reset,
       motor_l_reset, motor_l_direction,
       motor_r_reset, motor_r_direction);
end architecture structural;