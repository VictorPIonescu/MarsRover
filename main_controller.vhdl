library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main_controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		line_finder_done_in		: in	std_logic;
		line_finder_done_out		: out	std_logic
	);
end entity main_controller;

architecture behaviour of main_controller is
  begin
   process (clk, line_finder_done_in)
   begin
      if (clk'event and clk = '1') then
        if (reset = '0') then
         line_finder_done_out <= line_finder_done_in;
        else
         line_finder_done_out <= '0';
        end if;
    end if;
   end process;
end behaviour;