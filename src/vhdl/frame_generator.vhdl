--
-- Written by
--    Paul Gardner-Stephen <hld@c64.org>  2018
--
-- *  This program is free software; you can redistribute it and/or modify
-- *  it under the terms of the GNU Lesser General Public License as
-- *  published by the Free Software Foundation; either version 3 of the
-- *  License, or (at your option) any later version.
-- *
-- *  This program is distributed in the hope that it will be useful,
-- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
-- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- *  GNU General Public License for more details.
-- *
-- *  You should have received a copy of the GNU Lesser General Public License
-- *  along with this program; if not, write to the Free Software
-- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-- *  02111-1307  USA.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;

entity frame_generator is
  generic (
    frame_width : integer := 960;
    display_width : integer := 800;  -- 32 cycles of video pipeline
    pipeline_delay : integer := 20;
    frame_height : integer := 625;
    lcd_height : integer := 480;
    display_height : integer := 600;
    vsync_start : integer := 601;
    vsync_end : integer := 606;
    hsync_start : integer := 814;
    hsync_end : integer := 880
    );
  port (
    clock : in std_logic;
    hsync_polarity : in std_logic;
    vsync_polarity : in std_logic;
    hsync : out std_logic := '0';
    hsync_uninverted : out std_logic := '0';
    vsync : out std_logic := '0';
    inframe : out std_logic := '0';

    lcd_vsync : out std_logic := '0';
    lcd_inframe : out std_logic := '0';

    x_zero : out std_logic := '0';
    y_zero : out std_logic := '0';
    
    red_o : out unsigned(7 downto 0) := x"00";
    green_o : out unsigned(7 downto 0) := x"00";
    blue_o : out unsigned(7 downto 0) := x"00"
    
    );

end frame_generator;

architecture brutalist of frame_generator is

  signal x : integer := 0;
  signal x_zero_driver : std_logic := '0';
  signal y_zero_driver : std_logic := '0';
  signal y : integer := 0;
  signal inframe_internal : std_logic := '0';

  signal lcd_inletterbox : std_logic := '0';

  signal vsync_driver : std_logic := '0';
  signal hsync_driver : std_logic := '0';
  signal hsync_uninverted_driver : std_logic := '0';

  
begin

  process (clock) is
  begin

    if rising_edge(clock) then

      vsync <= vsync_driver;
      hsync <= hsync_driver;
      hsync_uninverted <= hsync_uninverted_driver;
      x_zero <= x_zero_driver;
      y_zero <= y_zero_driver;
      
      if x < frame_width then
        x <= x + 1;
        -- make the x_zero signal last a bit longer, to make sure it gets captured.
        if x = 3 then
          x_zero_driver <= '0';
        end if;
      else
        x <= 0;
        x_zero_driver <= '1';
        if y < frame_height then
          y <= y + 1;
          y_zero_driver <= '0';
        else
          y <= 0;
          y_zero_driver <= '1';
        end if;
      end if;

      if x = hsync_start then
        hsync_driver <= hsync_polarity; 
        hsync_uninverted_driver <= '1'; 
      end if;
      if x = hsync_end then
        hsync_driver <= not hsync_polarity;
        hsync_uninverted_driver <= '0';
      end if;
      if y = ( frame_height - lcd_height ) / 2 then
        lcd_inletterbox <= '1';
      end if;
      if y = frame_height - (frame_height - lcd_height ) / 2 then
        lcd_inletterbox <= '0';
      end if;
      if x = pipeline_delay and lcd_inletterbox = '1' then
        lcd_inframe <= '1';
      end if;
      if x = 0 and lcd_inletterbox = '1' then
        lcd_vsync <= '0';
      end if;
      if x = 0 and lcd_inletterbox = '0' then
        lcd_inframe <= '0';
        lcd_vsync <= '1';
      end if;
      if x = 0 and y < display_height then
        inframe <= '1';
      end if;
      if y = vsync_start then
        vsync_driver <= vsync_polarity;
      end if;
      if y = 0 or y = vsync_end then
        vsync_driver <= not vsync_polarity;
      end if;

      -- Colourful pattern inside frame
      if inframe_internal = '1' then
        -- Inside frame, draw a test pattern
        red_o <= to_unsigned(x,8);
        green_o <= to_unsigned(y,8);
        blue_o <= to_unsigned(x+y,8);
      end if;
      
      -- Draw white edge on frame
      if x = 0 and y < display_height then
        inframe <= '1';
        inframe_internal <= '1';
        red_o <= x"FF";
        green_o <= x"FF";
        blue_o <= x"FF";
      end if;
      if ((x = ( display_width + pipeline_delay - 1 ))
          or (y = 0) or (y = (display_height - 1)))
        and (inframe_internal='1') then
        red_o <= x"FF";
        green_o <= x"FF";
        blue_o <= x"FF";
      end if;
      -- Black outside of frame
      if x = display_width + pipeline_delay then
        lcd_inframe <= '0';
        inframe <= '0';
        inframe_internal <= '0';
        red_o <= x"00";
        green_o <= x"00";
        blue_o <= x"00";        
      end if;
    end if;

  end process;
  
end brutalist;
