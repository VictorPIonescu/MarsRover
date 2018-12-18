library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mars_rover is 
        port (
            clk		: in	std_logic;
            reset		: in	std_logic;
            sensor_l		: in	std_logic;
            sensor_m		: in	std_logic;
            sensor_r		: in	std_logic;
		              
            pwm_l       	: out	std_logic;
            pwm_r       	: out	std_logic;
            
            turn_count_out : out unsigned(1 downto 0)
        );
end entity mars_rover;

architecture structural of mars_rover is 

  component input_buffer is
    port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
  end component input_buffer;
	
  component top_controller is
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
  end component top_controller;
  
  component counter is
    port (	clk		: in	std_logic;
		reset		: in	std_logic;

		count_out	: out	std_logic_vector (21 downto 0) --------- UPDATE VECTOR LENGTH --------- 
	);
  end component counter;
	
  component pwm_generator is
    port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (21 downto 0); --------- UPDATE VECTOR LENGTH --------- 

		pwm		: out	std_logic
	);
  end component pwm_generator;

  signal sensor_l_out, sensor_m_out, sensor_r_out, -- out signals of input_buffer
          count_reset, motor_l_reset, motor_l_direction, motor_r_reset, motor_r_direction-- out signals of controller
          : std_logic; 

  signal count_out: std_logic_vector (21 downto 0); -- out signals of counter --------- UPDATE VECTOR LENGTH --------- 

-- positional port map = do not write component port names. Order is important!
begin
    L1: input_buffer  port map (clk,
                               sensor_l, sensor_m, sensor_r, -- sensor signals in from mars_rover
                                sensor_l_out, sensor_m_out, sensor_r_out); -- sensor signals out to controller
                                
    L2: top_controller    port map (clk, reset,
                              sensor_l_out, sensor_m_out, sensor_r_out, -- sensor signals from input_buffer
                              count_out, -- count signal in from counter
		                          count_reset, -- reset signal out to counter
                              motor_l_reset, motor_l_direction, motor_r_reset, motor_r_direction, turn_count_out); -- motor signals out to pwm_generators

    L3: counter       port map (clk, count_reset, -- should this be the reset from the mars_rover entity? (check other reset signals too)
				                       count_out); -- count signal out

    L4: pwm_generator port map (clk,
                               motor_l_reset, motor_l_direction, -- reset and direction signals in from controller
				                        count_out, -- count signal in from counter
                                 pwm_l); -- pwm signal out to mars_rover

    L5: pwm_generator port map (clk,
                               motor_r_reset, motor_r_direction, -- reset and direction signals in from controller
				                        count_out, -- count signal in from counter
                                 pwm_r); -- pwm signal out to mars_rover

end architecture structural;
