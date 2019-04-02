--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Marek Raska
-- Date: 2019-03-14 08:04
-- Design: pattern_generator
-- Description: Generating image data for VGA timing
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------------
-- Entity declaration for pattern generator
--------------------------------------------------------------------------------
entity pattern_generator is
    port (
        -- Entity input signals
		  x_pos_next_i  : in std_logic_vector(10-1 downto 0); -- future ray position horizontal
		  y_pos_next_i  : in std_logic_vector(10-1 downto 0); -- future ray position vertical                    

        -- Entity output signals
		  red_next_o    : out std_logic_vector(3-1 downto 0); -- future RED color
		  green_next_o  : out std_logic_vector(3-1 downto 0); -- future GREEN color
		  blue_next_o   : out std_logic_vector(2-1 downto 0); -- future BLUE color
		  
		  selpat_i      : in std_logic_vector(8-1 downto 0)   -- PATTERN SELECTOR
		  );
end pattern_generator;

--------------------------------------------------------------------------------
-- Architecture declaration for pattern generator
--------------------------------------------------------------------------------
architecture Behavioral of pattern_generator is
	-- nil
begin
	
	red_next_o <= "111" when (x_pos_next_i=0 and y_pos_next_i=0) else selpat_i(7 downto 5);
	green_next_o <= "111" when (x_pos_next_i=640-1 and y_pos_next_i=480-1) else selpat_i(4 downto 2);
	blue_next_o <=	selpat_i(1 downto 0);
end Behavioral;
