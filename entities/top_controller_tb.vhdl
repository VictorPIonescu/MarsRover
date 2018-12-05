library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_controller_tb is
end entity top_controller_tb;

architecture structural of top_controller_tb is

component top_controller is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        
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
end component;

signal clk, reset, sensor_l, sensor_m, sensor_r, count_reset, motor_l_reset, motor_l_direction, motor_r_reset, motor_r_direction : std_logic;
signal count_in : std_logic_vector (21 downto 0);

begin
  clk <= '1' after 0 ns,
         '0' after 5 ns when clk /= '0' else '1' after 5 ns;
         
 
  reset <= '1' after 5 ns,
           '0' after 15 ns;
           
  count_in <= std_logic_vector (to_unsigned(0, 22)) after 0 ns,
          std_logic_vector (to_unsigned(2000000, 22)) after 40 ns,
          std_logic_vector (to_unsigned(0, 22)) after 50 ns,
          std_logic_vector (to_unsigned(2000000, 22)) after 90 ns,
          std_logic_vector (to_unsigned(0, 22)) after 100 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 140 ns,
          std_logic_vector (to_unsigned(0, 22)) after 150 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 190 ns,
          std_logic_vector (to_unsigned(0, 22)) after 200 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 240 ns,
          std_logic_vector (to_unsigned(0, 22)) after 250 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 290 ns,
          std_logic_vector (to_unsigned(0, 22)) after 300 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 340 ns,
          std_logic_vector (to_unsigned(0, 22)) after 350 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 390 ns,
          std_logic_vector (to_unsigned(0, 22)) after 400 ns,
          std_logic_vector (to_unsigned(2000010, 22)) after 440 ns;
  
  sensor_l <= '1' after 0 ns,
              '1' after 60 ns,
              '1' after 120 ns;
  sensor_m <= '0' after 0 ns,
              '1' after 60 ns,
              '0' after 120 ns;
  sensor_r <= '1' after 0 ns,
              '1' after 60 ns,
              '1' after 120 ns;
  lbl0: top_controller port map( clk, reset, 
    sensor_l, sensor_m, sensor_r,
    count_in, count_reset,
    motor_l_reset, motor_l_direction, 
    motor_r_reset, motor_r_direction
                        );
end architecture structural;
