library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_finder is
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
end entity line_finder;

architecture behaviour of line_finder is
   type controller_state is (FIND_LINE, PASS_LINE, TURN_LEFT, TURN_RIGHT, LINE_FOUND, F_FIND, F_PASS, SL, SR);
   --signal last_state : controller_state; -- used to determine previous state while we are in F state. -- RE-INTRODUCE????????
   signal state, new_state: controller_state;
   signal inter_sensor_l, inter_sensor_m, inter_sensor_r: std_logic;
   signal last_sensor_l, last_sensor_m, last_sensor_r: std_logic;
   
begin
   lbl1: process (clk)
   begin
      if (clk'event and clk = '1') then
        if (reset = '0') then
          -- apply intermediate values
         state <= new_state;
         last_sensor_l <= inter_sensor_l;
         last_sensor_m <= inter_sensor_m;
         last_sensor_r <= inter_sensor_r;
        else
          -- default states
         state <= FIND_LINE;
         last_sensor_l <= '1';
         last_sensor_m <= '1';
         last_sensor_r <= '1';
        end if;
    end if;
   end process;
   lbl3: process (state, sensor_l, sensor_m, sensor_r, count_in)
   begin
    line_finder_done <= '0';
    -- the default outputs for non-moving states
    count_reset <= '1';
    motor_l_reset <= '1'; -- don't care
    motor_l_direction	<= '1'; -- don't care
    motor_r_reset <= '1'; -- don't care
    motor_r_direction	<= '1'; -- don't care
    
    -- save last sensor values as intermediates if not (W W W).
     if (not(sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then
      inter_sensor_l <= sensor_l;
      inter_sensor_m <= sensor_m;
      inter_sensor_r <= sensor_r;
    else 
      -- else keep last values.
      inter_sensor_l <= last_sensor_l;
      inter_sensor_m <= last_sensor_m;
      inter_sensor_r <= last_sensor_r;
    end if;
      
      case state is
        when F_FIND =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
        if (unsigned(count_in) >= 2000000) then
          new_state <= FIND_LINE;
        elsif (unsigned(count_in) < 2000000) then
          new_state <= state;
        else 
          new_state <= FIND_LINE;
        end if;
        
        when F_PASS =>
          count_reset <= '0';
          motor_l_reset <= '0';
          motor_l_direction	<= '1';
          motor_r_reset <= '0';
          motor_r_direction	<= '0';
          if (unsigned(count_in) >= 2000000) then
            new_state <= PASS_LINE;
          elsif (unsigned(count_in) < 2000000) then
            new_state <= state;
          else 
            new_state <= FIND_LINE;
          end if;  
        
      when SL =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '0';
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
        if (unsigned(count_in) >= 2000000) then
          new_state <= TURN_LEFT;
        elsif (unsigned(count_in) < 2000000) then
          new_state <= state;
        else 
          new_state <= TURN_LEFT;
        end if;
        
      when SR =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '0';
        motor_r_direction	<= '1';
        if (unsigned(count_in) >= 2000000) then
          new_state <= TURN_RIGHT;
        elsif (unsigned(count_in) < 2000000) then
          new_state <= state;
        else 
          new_state <= TURN_RIGHT;
        end if;
        
      when FIND_LINE =>
        if (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
          new_state <= F_FIND;
        elsif (not(sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then
          new_state <= PASS_LINE;
        elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then -- if (WBW) (placed on line)
          new_state <= LINE_FOUND;
        else
          new_state <= FIND_LINE;
        end if;
        
      when PASS_LINE =>
        if (not(sensor_l = '1' and sensor_m = '1' and sensor_r = '1')) then -- if not (WWW)
          new_state <= F_PASS;
        else
          if ((last_sensor_l = '1' and last_sensor_m = '1' and last_sensor_r = '0') 
            or (last_sensor_l = '1' and last_sensor_m = '0' and last_sensor_r = '0')) then -- if (WWB) or (WBB)
            new_state <= TURN_RIGHT;
          else
            new_state <= TURN_LEFT;
          end if;
        end if;
      when TURN_RIGHT =>
        if (not(sensor_l = '1' and sensor_m = '0' and sensor_r = '1')) then -- if not (WBW)
          new_state <= SR;
        else
          new_state <= LINE_FOUND; --if the line is found
        end if;  
      when TURN_LEFT =>
        if (not(sensor_l = '1' and sensor_m = '0' and sensor_r = '1')) then -- if not (WBW)
          new_state <= SL;
        else
          new_state <= LINE_FOUND; --if the line is found
        end if;
      when LINE_FOUND =>
        line_finder_done <= '1';
      end case;
      
      if (not(sensor_l = '0') and not(sensor_l = '1')) then
        new_state <= FIND_LINE;
      end if;
      
    end process;
  end behaviour;