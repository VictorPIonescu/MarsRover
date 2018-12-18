library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
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
end entity controller;

architecture behaviour of controller is
   type controller_state is (RESET_STATE, TURNING_RIGHT, TURNING_LEFT, F, L, R, SL, SR);
   signal state, new_state: controller_state;
   signal inter_sensor_l, inter_sensor_m, inter_sensor_r: std_logic;
   signal last_sensor_l, last_sensor_m, last_sensor_r: std_logic;
   signal turn_count, turn_count_inter: unsigned(1 downto 0);-- := (others => '0');
begin
   lbl1: process (clk)
   begin
      if (clk'event and clk = '1') then
        turn_count_out(0) <= not(turn_count(0));
        turn_count_out(1) <= not(turn_count(1));
        if (reset = '0') then
         state <= new_state;
         last_sensor_l <= inter_sensor_l;
         last_sensor_m <= inter_sensor_m;
         last_sensor_r <= inter_sensor_r;
         turn_count <= turn_count_inter;
        else
         state <= RESET_STATE;
         last_sensor_l <= '1';
         last_sensor_m <= '1';
         last_sensor_r <= '1';
        
         turn_count <= "00";         
        end if;
    end if;
   end process;
   lbl3: process (state, sensor_l, sensor_m, sensor_r, count_in)
   begin
      -- save last sensor values as intermediates if (B W B).
     if (sensor_l = '0' and sensor_m = '1' and sensor_r = '0') then
      inter_sensor_l <= sensor_l;
      inter_sensor_m <= sensor_m;
      inter_sensor_r <= sensor_r;
    else 
      -- reset values.
      inter_sensor_l <= '1';
      inter_sensor_m <= '1';
      inter_sensor_r <= '1';
    end if;
    if (turn_count = "01" or turn_count = "10") then -- initialiseren van turn_count_inter, anders is deze undifined
      turn_count_inter <= turn_count;
    else
      turn_count_inter <= "00";
    end if;
   if ((last_sensor_l = '0' and last_sensor_m = '1' and last_sensor_r = '0') and not(sensor_l = '0' and sensor_m = '1' and sensor_r = '0')) then --last:BWB new: not(BWB)
      turn_count_inter <= turn_count + 1;
    end if;
    --default outputs        
        count_reset <= '1';
        motor_l_reset <= '1'; 
        motor_l_direction	<= '0'; -- don't care
        motor_r_reset <= '1'; 
        motor_r_direction	<= '0'; -- don't care
        turn_signal_left <= '0'; 
        turn_signal_right <= '0';
      case state is
      when F =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
      when L =>
        count_reset <= '0';
        motor_l_reset <= '1';
        motor_l_direction	<= '1'; -- don't care
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
      when R =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '1';
        motor_r_direction	<= '0'; -- don't care
      when SL =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '0';
        motor_r_reset <= '0';
        motor_r_direction	<= '0';
      when SR =>
        count_reset <= '0';
        motor_l_reset <= '0';
        motor_l_direction	<= '1';
        motor_r_reset <= '0';
        motor_r_direction	<= '1';
      when TURNING_LEFT =>
        turn_signal_left <= '1';
        if (turn_left_done = '1') then 
          new_state <= RESET_STATE;
        end if;
      when TURNING_RIGHT =>
        turn_signal_right <= '1';
        if (turn_right_done = '1') then 
          new_state <= RESET_STATE;
        end if;
          
      when RESET_STATE =>
        -- WWW, WBW, BWB
        -- also go forward when BWB is seen
        if ((sensor_l = '1' and sensor_r = '1') or (sensor_l = '0' and sensor_m = '1' and sensor_r = '0')) then 
          new_state <= F;
        elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
          new_state <= L;
        elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
          new_state <= R;
        elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
            if (last_sensor_l = '0' and last_sensor_m = '1' and last_sensor_r = '0') then
            new_state <= F;
        else
            new_state <= SL;
        end if;
        elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
            if (last_sensor_l = '0' and last_sensor_m = '1' and last_sensor_r = '0') then
                new_state <= F;
            else
                new_state <= SR;
            end if;
        elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then --"BBB" turn or not to turn\
          case turn_count is
            when "01" =>
              new_state <= TURNING_RIGHT;
            when "10" => 
              new_state <= TURNING_LEFT;
            when others =>
              new_state <= state; -- change to new_state <= F in case of "normal" junction?
            end case;
            turn_count_inter <= "00";            
        else
          new_state <= state;
        end if;
      end case;
      if (not(state = RESET_STATE or state = TURNING_LEFT or state = TURNING_RIGHT)) then
        if (unsigned(count_in) >= 2000000) then
          new_state <= RESET_STATE;
        elsif (unsigned(count_in) < 2000000) then
          new_state <= state;
        else 
          new_state <= RESET_STATE;
        end if;
      end if;
    end process;
  end behaviour;