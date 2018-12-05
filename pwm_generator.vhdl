library IEEE;
-- Here you can specify the libraries you want to use:
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pwm_generator is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (21 downto 0);

		pwm		: out	std_logic
	);
end entity pwm_generator;

architecture behaviour of pwm_generator is
   type pwm_generator_state is (BACKWARD, FORWARD, PWM_LOW, OFF);
   signal state, new_state: pwm_generator_state;
begin
   lbl1: process (clk)
   begin
      if (clk'event and clk = '1') then
        if (reset = '0') then
         state <= new_state;
        else
         state <= OFF;
        end if;
    end if;
   end process;

   lbl2: process (state, direction, count_in)
   begin
      case state is
      when OFF =>
        pwm <= '0';
         if  (direction='0') then
            new_state <= BACKWARD;
         elsif (direction='1') then
            new_state <= FORWARD;
          else 
            new_state <= OFF;
         end if;
      when BACKWARD =>
        pwm <= '1';
         if (unsigned(count_in) < 140000) then
            new_state <= BACKWARD;
         else
            new_state <= PWM_LOW;
         end if;
      when FORWARD =>
         pwm <= '1';
         if (unsigned(count_in) < 160000) then
            new_state <= FORWARD;
         else
            new_state <= PWM_LOW;
         end if;
      
      when PWM_LOW =>
         pwm <= '0';
         new_state <= PWM_LOW;
      end case;
   end process;
end behaviour;


