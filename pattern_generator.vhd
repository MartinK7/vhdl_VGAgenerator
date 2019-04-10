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
	signal red_next_o_1 : std_logic_vector(3-1 downto 0);
	signal green_next_o_1 : std_logic_vector(3-1 downto 0);
	signal blue_next_o_1 : std_logic_vector(2-1 downto 0);
	
	signal red_next_o_2 : std_logic_vector(3-1 downto 0);
	signal green_next_o_2 : std_logic_vector(3-1 downto 0);
	signal blue_next_o_2 : std_logic_vector(2-1 downto 0);
	
	signal red_next_o_3 : std_logic_vector(3-1 downto 0);
	signal green_next_o_3 : std_logic_vector(3-1 downto 0);
	signal blue_next_o_3 : std_logic_vector(2-1 downto 0);
	
	signal red_next_o_4 : std_logic_vector(3-1 downto 0);
	signal green_next_o_4 : std_logic_vector(3-1 downto 0);
	signal blue_next_o_4 : std_logic_vector(2-1 downto 0);
begin
	
	 red_next_o_1 <= "111" when (x_pos_next_i=0 and y_pos_next_i=0) else selpat_i (7 downto 5);
	 green_next_o_1 <= "111" when (x_pos_next_i=640-1 and y_pos_next_i=480-1) else selpat_i (4 downto 2);
	 blue_next_o_1 <=	selpat_i(1 downto 0);

    red_next_o_2 <= "111" when ((x_pos_next_i<320 and y_pos_next_i<240) or (x_pos_next_i>320 and y_pos_next_i>240)) else "000";
    green_next_o_2 <= "111" when (x_pos_next_i>320) else "000";
    blue_next_o_2 <= "11" when (y_pos_next_i>240) else "00";
	 
	 red_next_o_3 <= "111" when (x_pos_next_i<128 or x_pos_next_i>384) else "000";
    green_next_o_3 <= "111" when (x_pos_next_i>256 and x_pos_next_i<512) else "000";
    blue_next_o_3 <= "11" when ((x_pos_next_i>128 and x_pos_next_i<256) or (x_pos_next_i>512)) else "00";
	 
	 red_next_o_4 <= "111" when (y_pos_next_i<160 or y_pos_next_i>320) else "000";
    green_next_o_4 <= "111" when (y_pos_next_i<160 or y_pos_next_i>320) else "000";
    blue_next_o_4 <= "11" when (y_pos_next_i<160 or y_pos_next_i>320) else "00";
	 
	 red_next_o <= red_next_o_1 when selpat_i(1 downto 0)="00" else 
						red_next_o_2 when selpat_i(1 downto 0)="01" else
						red_next_o_3 when selpat_i(1 downto 0)="10" else 
						red_next_o_4;
						
    green_next_o <= green_next_o_1 when selpat_i(1 downto 0)="00" else 
						  green_next_o_2 when selpat_i(1 downto 0)="01" else
						  green_next_o_3 when selpat_i(1 downto 0)="10" else
						  green_next_o_4;
						  
    blue_next_o <= blue_next_o_1 when selpat_i(1 downto 0)="00" else
						 blue_next_o_2 when selpat_i(1 downto 0)="01" else
						 blue_next_o_3 when selpat_i(1 downto 0)="10" else
						 blue_next_o_4;
end Behavioral;
