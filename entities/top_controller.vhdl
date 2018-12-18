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
		motor_r_direction	: out	std_logic;
		turn_count_out : out unsigned(1 downto 0)
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
		motor_r_direction	: out	std_logic;
		
		turn_signal_left : out std_logic;
		turn_signal_right : out std_logic;
		
		turn_left_done : in std_logic;
		turn_right_done : in std_logic;
		turn_count_out: out unsigned (1 downto 0)
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

component turner_right is
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
		
		turner_right_done : out std_logic
	);
end component turner_right;

component turner_left is
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
		
		turner_left_done : out std_logic
	);
end component turner_left;

component multiplexer is
  port( clk: in std_logic; 
        sel          : in unsigned(1 downto 0);
        
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
end component multiplexer;

component main_controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

    turn_signal_left : in	std_logic;
		turn_signal_right : in	std_logic;
		line_finder_done		: in	std_logic;
		sel		: out	unsigned(1 downto 0)
	);
end component main_controller;

signal  sel : unsigned(1 downto 0);
signal 	count_reset_finder,
        motor_l_reset_finder, 
        motor_l_direction_finder,
		    motor_r_reset_finder,
		    motor_r_direction_finder,
		    line_finder_done,
		    
		    count_reset_tracker,
		    motor_l_reset_tracker,
		    motor_l_direction_tracker,
		    motor_r_reset_tracker,
		    motor_r_direction_tracker,
		    turn_signal_left,
		    turn_signal_right,
		    
		    count_reset_left_turner,
		    motor_l_reset_left_turner,
		    motor_l_direction_left_turner,
		    motor_r_reset_left_turner,
		    motor_r_direction_left_turner,
		    turner_left_done,
		    
		    count_reset_right_turner,
		    motor_l_reset_right_turner,
		    motor_l_direction_right_turner,
		    motor_r_reset_right_turner,
		    motor_r_direction_right_turner,
		    turner_right_done: std_logic;
begin		    
		    lbl0: line_finder port map(clk => clk, reset => reset,
		                               sensor_l => sensor_l, sensor_m => sensor_m, sensor_r => sensor_r, --inputs
		                               count_in => count_in,
		                               count_reset => count_reset_finder, --goes to the multiplexer
		                               motor_l_reset => motor_l_reset_finder, 
                                   motor_l_direction => motor_l_direction_finder,
		                               motor_r_reset => motor_r_reset_finder,
		                               motor_r_direction => motor_r_direction_finder,
		                               line_finder_done => line_finder_done -- goes to the main-controller
		                                );
		                                
		     lbl1: controller port map(clk, reset,
		                                sensor_l, sensor_m, sensor_r, --inputs  
		                                count_in,
		                                count_reset_tracker,-- goes to the mulitplexer
		                                motor_l_reset_tracker,
		                                motor_l_direction_tracker,
		                                motor_r_reset_tracker,
		                                motor_r_direction_tracker,
		                                turn_signal_left, turn_signal_right, -- out signals to mux and turner FSMs
		                                turner_left_done, turner_right_done, turn_count_out);-- input signals from turner FSMs
		                                
		                                
		     lbl3: turner_left port map(clk, turn_signal_left, -- reset signal is turn signal from line tracker (controller)
		                                sensor_l, sensor_m, sensor_r, --inputs  
		                                count_in,
		                                count_reset_left_turner,-- goes to the mulitplexer
		                                motor_l_reset_left_turner,
		                                motor_l_direction_left_turner,
		                                motor_r_reset_left_turner,
		                                motor_r_direction_left_turner,
		                                turner_left_done); -- done signal goes back to line tracker
		                                
		     lbl4: turner_right port map(clk, turn_signal_right, -- reset signal is turn signal from line tracker (controller)
		                                sensor_l, sensor_m, sensor_r, --inputs  
		                                count_in,
		                                count_reset_right_turner,-- goes to the mulitplexer
		                                motor_l_reset_right_turner,
		                                motor_l_direction_right_turner,
		                                motor_r_reset_right_turner,
		                                motor_r_direction_right_turner,
		                                turner_right_done); -- done signal goes back to line tracker
		                                
		     lbl2: multiplexer port map(clk, sel, --determines if tracker or finder
		       
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
		                                
		                                count_reset_left_turner, -- left turner inputs
		                                motor_l_reset_left_turner,
		                                motor_l_direction_left_turner,
		                                motor_r_reset_left_turner,
		                                motor_r_direction_left_turner,
		    
		                                count_reset_right_turner,  -- right turner inputs
		                                motor_l_reset_right_turner,
		                                motor_l_direction_right_turner,
		                                motor_r_reset_right_turner,
		                                motor_r_direction_right_turner,
		                                
		                                count_reset,            --outputs
		                                motor_l_reset,
		                                motor_l_direction,
		                                
		                                motor_r_reset,
		                                motor_r_direction);
		                                
        lbl5: main_controller port map(clk, reset,
                                      turn_signal_left,
		                                  turn_signal_right,
                                      line_finder_done,
                                      sel);
end architecture behavioural;                                     		                                                
		                                