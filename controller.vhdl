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
		motor_r_direction	: out	std_logic
	);
end entity controller;

architecture behaviour of controller is
   type controller_state is (RESET_STATE, F, L, R, SL, SR);
   signal state, new_state: controller_state;
begin
   lbl1: process (clk)
   begin
      if (clk'event and clk = '1') then
        if (reset = '0') then
         state <= new_state;
        else
         state <= RESET_STATE;
        end if;
    end if;
   end process;
   lbl3: process (state, sensor_l, sensor_m, sensor_r, count_in)
   begin
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
      when RESET_STATE =>
        count_reset <= '1';
        motor_l_reset <= '1'; -- don't care
        motor_l_direction	<= '0'; -- don't care
        motor_r_reset <= '1'; -- don't care
        motor_r_direction	<= '0'; -- don't care
        if ((sensor_l = '0' and sensor_r = '0') or (sensor_l = '1' and sensor_r = '1')) then
          new_state <= F;
        elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
          new_state <= L;
        elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
          new_state <= R;
        elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
          new_state <= SL;
        elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
          new_state <= SR;
        else
          new_state <= state;
        end if;
      end case;
      if (state /= RESET_STATE) then
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