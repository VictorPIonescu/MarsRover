library IEEE;
use IEEE.std_logic_1164.all;
-- Here you can specify the libraries you want to use:



entity input_buffer is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
end entity input_buffer;

architecture behavioural of input_buffer is
  signal l_buffer, m_buffer, r_buffer: std_logic;
begin
  process (clk)
    begin
    if (rising_edge (clk)) then	
		 l_buffer <= sensor_l_in; --first register
		 m_buffer <= sensor_m_in;
		 r_buffer <= sensor_r_in;		 
		end if;
 end process;
 
 process (clk)
    begin
      if (rising_edge (clk)) then	
		 sensor_l_out <= l_buffer; --second register
		 sensor_m_out <= m_buffer;
		 sensor_r_out <= r_buffer;		 
		end if;
 end process;
end architecture behavioural;