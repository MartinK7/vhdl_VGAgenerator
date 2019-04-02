--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Martin Krasl
-- Date: 2019-03-14 08:04
-- Design: vga_generator
-- Description: VGA Timing generator
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------------
-- Entity declaration for VGA timing generator
--------------------------------------------------------------------------------
entity vga_generator is
    port (
        -- Entity input signals
        clk_i : in std_logic;
		  rst_n_i : in std_logic;
		  red_next_i    : in std_logic_vector(3-1 downto 0); -- future RED color
		  green_next_i  : in std_logic_vector(3-1 downto 0); -- future GREEN color
		  blue_next_i   : in std_logic_vector(2-1 downto 0); -- future BLUE color

        -- Entity output signals
        h_sinc_o : out std_logic;
        v_sinc_o : out std_logic;
		  red_o    : out std_logic_vector(3-1 downto 0); -- future RED color
		  green_o  : out std_logic_vector(3-1 downto 0); -- future GREEN color
		  blue_o   : out std_logic_vector(2-1 downto 0); -- future BLUE color		  
		  
		  x_pos_next_o  : out std_logic_vector(10-1 downto 0);
		  y_pos_next_o  : out std_logic_vector(10-1 downto 0)
    );
end vga_generator;

--------------------------------------------------------------------------------
-- Architecture declaration for VGA timing generator
--------------------------------------------------------------------------------
architecture Behavioral of vga_generator is
    -- line parameters
	 constant VISIBLE_AREA_PIXELS : integer := 640;
	 constant FRONT_PORCH_PIXELS  : integer := 16;
	 constant SYNC_PULSE_PIXELS   : integer := 96;
	 constant BACK_PORCH_PIXELS   : integer := 48;	 
	 constant TOTAL_PIXELS        : integer := VISIBLE_AREA_PIXELS+FRONT_PORCH_PIXELS+SYNC_PULSE_PIXELS+BACK_PORCH_PIXELS;
	 -- frame parameters
	 constant VISIBLE_AREA_LINES  : integer := 480;
	 constant FRONT_PORCH_LINES   : integer := 10;
	 constant SYNC_PULSE_LINES    : integer := 2;
	 constant BACK_PORCH_LINES    : integer := 33;
	 constant TOTAL_LINES         : integer := VISIBLE_AREA_LINES+FRONT_PORCH_LINES+SYNC_PULSE_LINES+BACK_PORCH_LINES;
	 
    signal pixel_cnt : std_logic_vector(10-1 downto 0);
	 signal line_cnt : std_logic_vector(10-1 downto 0);
    signal pixel_cnt_next : std_logic_vector(10-1 downto 0);
	 signal line_cnt_next : std_logic_vector(10-1 downto 0);
	 signal h_sinc_next : std_logic;
	 signal h_sinc : std_logic;
	 signal v_sinc_next : std_logic;
	 signal v_sinc : std_logic;
	 signal red_next   : std_logic_vector(3-1 downto 0); -- future RED color (masked lines, sync)
	 signal green_next : std_logic_vector(3-1 downto 0); -- future GREEN color (masked lines, sync)
	 signal blue_next  : std_logic_vector(2-1 downto 0); -- future BLUE color (masked lines, sync)
begin

    --------------------------------------------------------------------------------
    -- Registers
    --------------------------------------------------------------------------------
    registers: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_n_i = '0' then             -- synchronous reset
                pixel_cnt <= (others => '0'); -- clear all bits in register
                line_cnt <= (others => '0');  -- clear all bits in register
					 h_sinc <= '1';
					 v_sinc <= '1';
            else
                pixel_cnt <= pixel_cnt_next;  -- update register value
                line_cnt <= line_cnt_next;    -- update register value
					 h_sinc <= h_sinc_next;
					 v_sinc <= v_sinc_next;
					 red_o <= red_next;
					 green_o <= green_next;
					 blue_o <= blue_next;
            end if;
        end if;
    end process registers;
						
    --------------------------------------------------------------------------------
    -- Next-state logic
    --------------------------------------------------------------------------------
    pixel_cnt_next <= (others => '0') when pixel_cnt=TOTAL_PIXELS-1 else
	                   pixel_cnt + 1;
							 
    line_cnt_next <=  (others => '0') when (pixel_cnt=TOTAL_PIXELS-1 and line_cnt=TOTAL_LINES-1) else
                      line_cnt + 1 when (pixel_cnt=TOTAL_PIXELS-1 and line_cnt/=TOTAL_LINES-1) else
							 line_cnt;
							 
	 h_sinc_next <= '0' when pixel_cnt=VISIBLE_AREA_PIXELS+FRONT_PORCH_PIXELS else
	                '1' when pixel_cnt=VISIBLE_AREA_PIXELS+FRONT_PORCH_PIXELS+SYNC_PULSE_PIXELS else
						 h_sinc;
						 
	 v_sinc_next <= '0' when line_cnt=VISIBLE_AREA_LINES+FRONT_PORCH_LINES else
	                '1' when line_cnt=VISIBLE_AREA_LINES+FRONT_PORCH_LINES+SYNC_PULSE_LINES else
						 v_sinc;
						 
	 red_next <= "000" when ((pixel_cnt_next>=VISIBLE_AREA_PIXELS and pixel_cnt_next<TOTAL_PIXELS) or (line_cnt_next>=VISIBLE_AREA_LINES and line_cnt_next<TOTAL_LINES)) else red_next_i;
	 green_next <= "000" when ((pixel_cnt_next>=VISIBLE_AREA_PIXELS and pixel_cnt_next<TOTAL_PIXELS) or (line_cnt_next>=VISIBLE_AREA_LINES and line_cnt_next<TOTAL_LINES)) else green_next_i;
	 blue_next <= "00" when ((pixel_cnt_next>=VISIBLE_AREA_PIXELS and pixel_cnt_next<TOTAL_PIXELS) or (line_cnt_next>=VISIBLE_AREA_LINES and line_cnt_next<TOTAL_LINES)) else blue_next_i;						 

    --------------------------------------------------------------------------------
    -- Output logic
    --------------------------------------------------------------------------------
	 h_sinc_o <= h_sinc;
	 v_sinc_o <= v_sinc;
	 x_pos_next_o <= pixel_cnt_next;
	 y_pos_next_o <= line_cnt_next;
end Behavioral;
