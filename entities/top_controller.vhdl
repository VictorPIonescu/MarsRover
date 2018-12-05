library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (21 downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);
end entity top_controller;

architecture behavioural of top_controller is
component controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (21 downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);
end component controller;

component line_finder is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (21 downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic;
		
		line_finder_done : out std_logic
	);
end component line_finder;

component multiplexer is
  port( clk: in std_logic; 
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

component main_controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		line_finder_done_in		: in	std_logic;
		line_finder_done_out		: out	std_logic
	);
end component main_controller;

signal line_finder_done_in_s, line_finder_done_out_s: std_logic;
signal 	count_reset_finder,
        motor_l_reset_finder, 
        motor_l_direction_finder,
		    motor_r_reset_finder,
		    motor_r_direction_finder,
		    count_reset_tracker,
		    motor_l_reset_tracker,
		    motor_l_direction_tracker,
		    motor_r_reset_tracker,
		    motor_r_direction_tracker: std_logic;
begin		    
		    lbl0: line_finder port map(clk => clk, reset => reset,
		                               sensor_l => sensor_l, sensor_m => sensor_m, sensor_r => sensor_r, --inputs
		                               count_in => count_in,
		                               count_reset => count_reset_finder, --goes to the multiplexer
		                               motor_l_reset => motor_l_reset_finder, 
                                   motor_l_direction => motor_l_direction_finder,
		                               motor_r_reset => motor_r_reset_finder,
		                               motor_r_direction => motor_r_direction_finder,
		                               line_finder_done => line_finder_done_in_s -- goes to the top-controller
		                                );
		                               
		     lbl1: controller port map(clk, reset,
		                                sensor_l, sensor_m, sensor_r, --inputs  
		                                count_in,
		                                count_reset_tracker,-- goes to the mulitplexer
		                                motor_l_reset_tracker,
		                                motor_l_direction_tracker,
		                                motor_r_reset_tracker,
		                                motor_r_direction_tracker);
		                                
		     lbl2: multiplexer port map(clk, line_finder_done_out_s, --determines if tracker or finder
		       
		                                count_reset_finder,     --finder inputs
                                    motor_l_reset_finder, 
                                    motor_l_direction_finder,
		                                motor_r_reset_finder,
		                                motor_r_direction_finder,
		                                
		                                count_reset_tracker,    --tracker inputs
		                                motor_l_reset_tracker,
		                                motor_l_direction_tracker,
		                                motor_r_reset_tracker,
		                                motor_r_direction_tracker,
		                                
		                                count_reset,            --outputs
		                                motor_l_reset,
		                                motor_l_direction,
		                                
		                                motor_r_reset,
		                                motor_r_direction);
		                                
        lbl3: main_controller port map(clk, reset,
                                      line_finder_done_in_s,
                                    line_finder_done_out_s);
end architecture behavioural;                                     		                                                
		                                