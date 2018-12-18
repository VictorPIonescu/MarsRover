library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mars_rover_tb is
end entity mars_rover_tb;

architecture structural of mars_rover_tb is

component mars_rover is
	port (	clk		: in	std_logic;
            reset		: in	std_logic;
            sensor_l		: in	std_logic;
            sensor_m		: in	std_logic;
            sensor_r		: in	std_logic;
		              
            pwm_l       	: out	std_logic;
            pwm_r       	: out	std_logic;
            
            turn_count_out : out unsigned(1 downto 0)
	);
end component mars_rover;


signal clk, reset, 
    sensor_l, sensor_m, sensor_r,
    pwm_l, pwm_r : std_logic;
signal turn_count_out: unsigned(1 downto 0);

begin
clk <=	 	'1' after 0 ns,
		'0' after 5 ns when clk /= '0' else '1' after 5 ns;
		       
reset <=	'1' after 0 ns,
    '0' after 15 ns;
    
sensor_l <= '1' after 0 ns,
                '0' after 20 ms,            
                '1' after 40 ms,
                '1' after 60 ms,            
                '0' after 80 ms,            
                '1' after 100 ms,
                '1' after 120 ms,
                '0' after 140 ms,
                '1' after 160 ms,
                '1' after 180 ms,
                '1' after 200 ms;     
    sensor_m <= '0' after 0 ns,
                '1' after 20 ms,
                '1' after 40 ms,
                '0' after 60 ms,
                '1' after 80 ms,
                '1' after 100 ms,
                '0' after 120 ms,
                '0' after 140 ms,
                '0' after 160 ms,
                '1' after 180 ms,
                '0' after 200 ms;         
    sensor_r <= '1' after 0 ns,
                '0' after 20 ms,
                '1' after 40 ms,
                '1' after 60 ms,
                '0' after 80 ms,
                '1' after 100 ms,
                '1' after 120 ms,
                '0' after 140 ms,
                '1' after 160 ms,
                '1' after 180 ms,
                '1' after 200 ms; 
            
lb10: mars_rover port map( clk, reset, 
    sensor_l, sensor_m, sensor_r,
    pwm_l, pwm_r,
    turn_count_out);
end architecture structural;

