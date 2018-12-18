library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main_controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

        turn_signal_left : in	std_logic;
		turn_signal_right : in	std_logic;
		line_finder_done		: in	std_logic;
		sel		: out	unsigned(1 downto 0)
	);
end entity main_controller;

architecture behaviour of main_controller is
  begin
   process (clk,
   turn_signal_left,
		turn_signal_right,
		line_finder_done)
   begin
      if (clk'event and clk = '1') then
        if (reset = '0') then
          if (line_finder_done = '0') then
            sel <= "00";
          elsif (turn_signal_left = '1') then
            sel <= "10";
          elsif (turn_signal_right = '1') then
            sel <= "11";
          else 
            sel <= "01";
          end if;
        else
          sel <= "00"; -- reset to line finder
        end if;
    end if;
   end process;
end behaviour;