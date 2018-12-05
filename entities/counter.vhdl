library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Here you can specify the libraries you want to use:



entity counter is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;

		count_out	: out	std_logic_vector (21 downto 0) --?? changed to 21
	);
end entity counter;

--changed from here on 19-11-18 (THIJS)
architecture behavioural of counter is
	signal count, new_count : unsigned(21 downto 0); --2*10^6 needs 20 bits, unsigned because of '+'
begin
	process (clk)
	begin
		if (rising_edge (clk)) then	--reset on rising edge, resets the counter
		  if (reset = '1') then
		    count <= (others => '0');
			else
				count <= new_count;
			end if;
			
		end if;
		
	end process;
	
	process (count)
	begin
		  if (count < 2000000) then
		    new_count <= count + 1;
		  else
		    new_count <= count;
			end if;
		
	end process;
  count_out <= std_logic_vector(count); --mapping to the output of the counter
	end architecture behavioural;