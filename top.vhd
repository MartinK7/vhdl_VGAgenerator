--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Martin Krasl & Marek Raska
-- Date: 2019-03-14 08:04
-- Design: top
-- Description: Generating image data for VGA timing
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------------
-- Entity declaration for top
--------------------------------------------------------------------------------
entity top is
    port (
        -- Global input signals at Nexys2
        clk : in std_logic;                           -- 50MHz crystal
		  
        -- Global output signals at Nexys2 for VGA
		  vgaRed    : out std_logic_vector(3 downto 1); -- RED color
		  vgaGreen  : out std_logic_vector(3 downto 1); -- GREEN color
		  vgaBlue   : out std_logic_vector(3 downto 2); -- BLUE color
		  Hsync     : out std_logic;                    -- HORIZONTAL synchronisation
		  Vsync     : out std_logic;                    -- VERTICAL synchronisation
		  
        -- Global output signals at Nexys2 for Leds
		  Led       : out std_logic_vector(8-1 downto 0);
		  
		  sw        : in std_logic_vector(7 downto 0);
		  btn       : in std_logic_vector(0 downto 0)
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for pattern generator
--------------------------------------------------------------------------------
architecture Behavioral of top is
			signal xposnext   : std_logic_vector(10-1 downto 0); -- ray position horizontal
			signal yposnext   : std_logic_vector(10-1 downto 0); -- ray position vertical
			signal red_next   : std_logic_vector(3-1 downto 0); -- future RED color
			signal green_next : std_logic_vector(3-1 downto 0); -- future GREEN color
			signal blue_next  : std_logic_vector(2-1 downto 0); -- future BLUE color
 			
			signal clk25meg   : std_logic := '0';
begin
		clockdivider : process(clk)
		begin
		  if rising_edge(clk) then
				clk25meg <= not(clk25meg);
			end if;
		end process clockdivider;

    MAIN_VGA_GENERATOR : entity work.vga_generator
        port map (
            clk_i => clk25meg,
            rst_n_i => not(btn(0)),
			   red_next_i => red_next,
			   green_next_i => green_next,
			   blue_next_i => blue_next,
            h_sync_o => Hsync,
            v_sync_o => Vsync,
			   red_o => vgaRed,
			   green_o => vgaGreen,
			   blue_o => vgaBlue,
				x_pos_next_o => xposnext,
				y_pos_next_o => yposnext
        );
    MAIN_PATTERN_GENERATOR : entity work.pattern_generator
        port map (
            x_pos_next_i => xposnext,
            y_pos_next_i => yposnext,
            red_next_o => red_next,
            green_next_o => green_next,
				blue_next_o => blue_next,
				selpat_i => sw
        );
    Led <= sw;
end Behavioral;
