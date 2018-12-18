library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity turner_right is
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
end entity turner_right;

architecture behaviour of turner_right is
   type controller_state is (FIND_TURN, TURN_RIGHT, TURNER_DONE, FORWARD, SR); -- for now only a right turn is considered
   signal state, new_state: controller_state;
   signal last_state: controller_state;
begin
   lbl1: process (clk)
   begin
      if (clk'event and clk = '1') then
        if (reset = '1') then -- reset signal is turn signal from line tracker (controller)
         state <= new_state;
        else
         state <= FIND_TURN;
        end if;
    end if;
   end process;
   
   lbl2: process (state, sensor_l, sensor_m, sensor_r, count_in)
   begin
        turner_right_done <= '0';
        -- the default outputs for non-moving states
        count_reset <= '1';
        motor_l_reset <= '1'; -- don't care
        motor_l_direction	<= '1'; -- don't care
        motor_r_reset <= '1'; -- don't care
        motor_r_direction	<= '1'; -- don't care
    case state is
      
      when FIND_TURN =>
        if (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
          new_state <= FORWARD;
        else
          new_state <= SR;  --for now only right turns
        end if;
        
      when TURN_RIGHT =>
        if (not(sensor_l = '1' and sensor_m = '0' and sensor_r = '1')) then -- if not (WBW)
          new_state <= SR;
        else
          new_state <= TURNER_DONE;
        end if;
        
      when TURNER_DONE =>
        turner_right_done <= '1'; 
        
      when FORWARD =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
        if (unsigned(count_in) >= 2000000) then
          new_state <= FIND_TURN;
        elsif (unsigned(count_in) < 2000000) then
          new_state <= state;
        else 
          new_state <= FIND_TURN;
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
      end case;
    end process;
  end behaviour;   