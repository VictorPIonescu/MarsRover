library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity turner_right_tb is
end entity turner_right_tb;

architecture structural of turner_right_tb is

component turner_right is
	port (	clk		: in	std_logic;
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

signal clk, reset, 
    sensor_l, sensor_m, sensor_r,
    count_reset, 
    motor_l_reset, motor_l_direction, 
    motor_r_reset, motor_r_direction, turner_right_done: std_logic;
signal count_in: std_logic_vector (21 downto 0);

begin
clk <=	 	'1' after 0 ns,
		'0' after 5 ns when clk /= '0' else '1' after 5 ns;
		
count_in <=  std_logic_vector (to_unsigned(0, 22)) after 0 ns,
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
          
reset <=	'1' after 5 ns,
    '0' after 15 ns;
    
sensor_l <= '0' after 0 ns,
            '1' after 100 ns,
            '1' after 200 ns,
            '0' after 300 ns,
            '0' after 350 ns,
            '1' after 400 ns;
sensor_m <= '0' after 0 ns,
            '0' after 100 ns,
            '0' after 200 ns,
            '0' after 300 ns,
            '0' after 400 ns;
sensor_r <= '0' after 0 ns,
            '0' after 100 ns,
            '0' after 200 ns,
            '1' after 300 ns,
            '1' after 400 ns;
		
lb10: turner_right port map( clk, reset, 
    sensor_l, sensor_m, sensor_r,
    count_in, count_reset,
    motor_l_reset, motor_l_direction, 
    motor_r_reset, motor_r_direction, 
    turner_right_done
                        );
end architecture structural;