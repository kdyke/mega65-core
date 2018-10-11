-- Accelerated 6502-like CPU for the C65GS

--
-- Written by
--    Paul Gardner-Stephen <hld@c64.org>  2013-2014
--
-- * ADC/SBC algorithm derived from  6510core.c - VICE MOS6510 emulation core.
-- *   Written by
-- *    Ettore Perazzoli <ettore@comm2000.it>
-- *    Andreas Boose <viceteam@t-online.de>
-- *
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

-- @IO:C65 $D0A0-$D0FF - Reserved for C65 RAM Expansion Controller.

use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.debugtools.all;
use work.cputypes.all;
use work.victypes.all;

entity address_resolver is

  port (
    short_address : in unsigned(19 downto 0);
    writeP : in std_logic;
    gated_exrom : in std_logic; 
    gated_game : in std_logic;
    map_en : in std_logic;
    resolve_address : in std_logic;
    io_sel : in std_logic;
    cpuport_ddr : in unsigned(7 downto 0);
    cpuport_value : in unsigned(7 downto 0);
    viciii_iomode : in std_logic_vector(1 downto 0);
    sector_buffer_mapped : in std_logic;
    colourram_at_dc00 : in std_logic;
    hypervisor_mode : in std_logic;
    rom_at_e000 : in std_logic;
    rom_at_c000 : in std_logic;
    rom_at_a000 : in std_logic;
    rom_at_8000 : in std_logic;
    dat_bitplane_addresses : in sprite_vector_eight;
    dat_offset_drive : in unsigned(15 downto 0);
    io_sel_resolved : out std_logic;
    ext_sel_resolved : out std_logic;
    
    resolved_address : out std_logic_vector(19 downto 0)
    );

    attribute keep : string;
    attribute keep_hierarchy : string;
    attribute mark_debug : string;

    --attribute mark_debug of map_en: signal is "true";
    --attribute mark_debug of short_address: signal is "true";
    --attribute mark_debug of ext_sel_resolved: signal is "true";
    --attribute mark_debug of io_sel_resolved: signal is "true";
    --attribute mark_debug of resolved_address: signal is "true";

    --attribute mark_debug of cpuport_ddr: signal is "true";
    --attribute mark_debug of cpuport_value: signal is "true";
    --attribute mark_debug of hypervisor_mode: signal is "true";

    --attribute mark_debug of rom_at_e000: signal is "true";
    --attribute mark_debug of rom_at_c000: signal is "true";
    --attribute mark_debug of rom_at_a000: signal is "true";
    --attribute mark_debug of rom_at_8000: signal is "true";

end entity address_resolver;

--purpose: Convert a 16-bit C64 address to native RAM (or I/O or ROM) address
architecture Behavioural of address_resolver is

--attribute keep_hierarchy of Behavioural : architecture is "yes";

begin

  process(short_address, writeP, gated_exrom, gated_game, map_en,
          cpuport_value, cpuport_ddr, viciii_iomode, hypervisor_mode,
          sector_buffer_mapped, colourram_at_dc00, 
          dat_bitplane_addresses, dat_offset_drive,
          rom_at_8000, rom_at_a000, rom_at_c000, rom_at_e000 )

  variable temp_address : unsigned(19 downto 0);
  variable nonmapped_page : unsigned(19 downto 12);
  
  variable blocknum : integer;
  variable lhc : std_logic_vector(4 downto 0);
  variable char_access_page : unsigned(19 downto 16);
  variable reg_offset : unsigned(11 downto 0);
  variable map_io : std_logic;
  variable map_ext : std_logic;
  
  begin  -- resolve_long_address

    -- Now apply C64-style $01 lines first, because MAP and $D030 take precedence
    map_io := '0';
    map_ext := '0';
    
    lhc(4) := gated_exrom;
    lhc(3) := gated_game;
    lhc(2 downto 0) := std_logic_vector(cpuport_value(2 downto 0));
    lhc(2) := lhc(2) or (not cpuport_ddr(2));
    lhc(1) := lhc(1) or (not cpuport_ddr(1));
    lhc(0) := lhc(0) or (not cpuport_ddr(0));
    
    if(writeP='1') then
      char_access_page := x"0";
    else
      char_access_page := x"2";
    end if;
    
    -- Examination of the C65 interface ROM reveals that MAP instruction
    -- takes precedence over $01 CPU port when MAP bit is set for a block of RAM.

    -- From https://groups.google.com/forum/#!topic/comp.sys.cbm/C9uWjgleTgc
    -- Port pin (bit)    $A000 to $BFFF       $D000 to $DFFF       $E000 to $FFFF
    -- 2 1 0             Read       Write     Read       Write     Read       Write
    -- --------------    ----------------     ----------------     ----------------
    -- 0 0 0             RAM        RAM       RAM        RAM       RAM        RAM
    -- 0 0 1             RAM        RAM       CHAR-ROM   RAM       RAM        RAM
    -- 0 1 0             RAM        RAM       CHAR-ROM   RAM       KERNAL-ROM RAM
    -- 0 1 1             BASIC-ROM  RAM       CHAR-ROM   RAM       KERNAL-ROM RAM
    -- 1 0 0             RAM        RAM       RAM        RAM       RAM        RAM
    -- 1 0 1             RAM        RAM       I/O        I/O       RAM        RAM
    -- 1 1 0             RAM        RAM       I/O        I/O       KERNAL-ROM RAM
    -- 1 1 1             BASIC-ROM  RAM       I/O        I/O       KERNAL-ROM RAM
    
    -- default is address in = address out
    temp_address := short_address;
    
    -- I/O Space is never mapped.
    if map_en='0' then
      -- IO
      temp_address := short_address;
      nonmapped_page(19 downto 16) := (others => '0');
      nonmapped_page(15 downto 12) := short_address(15 downto 12);
      blocknum := to_integer(short_address(15 downto 12));
      if (blocknum=13) then
        -- IO is always visible in ultimax mode
        if gated_exrom/='1' or gated_game/='0' or hypervisor_mode='1' then
          case lhc(2 downto 0) is
            when "000" => nonmapped_page(19 downto 16) := x"0";  -- WRITE RAM
            when "001" => nonmapped_page(19 downto 16) := char_access_page;  -- WRITE RAM / READ CHARROM
            when "010" => nonmapped_page(19 downto 16) := char_access_page;  -- WRITE RAM / READ CHARROM
            when "011" => nonmapped_page(19 downto 16) := char_access_page;  -- WRITE RAM / READ CHARROM
            when "100" => nonmapped_page(19 downto 16) := x"0";  -- WRITE RAM
            when others =>
              -- All else accesses IO
              -- C64/C65/C65GS I/O is based on which secret knock has been applied
              -- to $D02F
              map_io := '1';
          end case;
        else
          map_io := '1';
        end if;      
      end if;

      if map_io = '1' then
          -- nonmapped_page(23 downto 12) := x"FD3";
          -- nonmapped_page(13 downto 12) := unsigned(viciii_iomode);
          if sector_buffer_mapped='0' and colourram_at_dc00='0' then
            -- Map $DE00-$DFFF IO expansion areas to expansion port
            -- (but only if SD card sector buffer is not mapped, and
            -- 2nd KB of colour RAM is not mapped).
          if (short_address(11 downto 8) = x"E") or (short_address(11 downto 8) = x"F") then
            map_ext := '1';
            map_io := '0';
          end if;        
        end if;      
      end if;

      -- C64 KERNEL
      if ((blocknum=14) or (blocknum=15)) then
        if ((gated_exrom='1') and (gated_game='0')) then
          -- ULTIMAX mode external ROM
          map_ext := '1';
        elsif (lhc(1)='1') and (writeP='0') then
          nonmapped_page(19 downto 16) := x"2";
        end if;        
      end if;        

      -- C64 cartridge ROM LO
      if ((blocknum=8) or (blocknum=9)) and
        (
          (
            ((gated_exrom='1') and (gated_game='0'))
            or
            ((gated_exrom='0') and (lhc(1 downto 0)="11"))
          )
          and
          (writeP='0')
        )
      then
        -- ULTIMAX mode or cartridge external ROM
        map_ext := '1';
      end if;
      
      -- C64 BASIC
      if ((blocknum=10) or blocknum=11) and (lhc(0)='1') and (lhc(1)='1') and (writeP='0') then
        nonmapped_page(19 downto 16) := x"2";
      end if;
    
      if (((blocknum=10) or (blocknum=11)) -- $A000-$BFFF cartridge ROM
        and ((gated_exrom='0') and (gated_game='0'))) and (writeP='0')
      then
        -- ULTIMAX mode or cartridge external ROM
        map_ext := '1';
      end if;

      -- Expose remaining address space to cartridge port in ultimax mode
      if (gated_exrom='1') and (gated_game='0') and (hypervisor_mode='0') then
        if (blocknum=1) then
          -- $1000 - $1FFF Ultimax mode
          map_ext := '1';
        end if;
        if (blocknum=2 ) then
          -- $2000 - $2FFF Ultimax mode
          -- XXX $3000-$3FFf is a copy of $F000-$FFFF from the cartridge so
          -- that the VIC-II can see it. On the M65, the Hypervisor has to copy
          -- it down. Not yet implemented, and won't be perfectly compatible.
          map_ext := '1';
        end if;
        if ((blocknum=4) or (blocknum=5)) then
          -- $4000 - $5FFF Ultimax mode
          map_ext := '1';
        end if;
        if ((blocknum=6) or (blocknum=7)) then
          -- $6000 - $7FFF Ultimax mode
          map_ext := '1';
        end if;
        if (blocknum=12) then
          -- $C000 - $CFFF Ultimax mode
          map_ext := '1';
        end if;
      end if;

      if map_ext = '1' then
          nonmapped_page(19 downto 16) := x"7";  -- temp hack to pick something out of the way
      end if;

      temp_address(19 downto 12) := nonmapped_page;
    end if;
  
    -- $D030 ROM select lines:
    if hypervisor_mode = '0' then
      blocknum := to_integer(short_address(15 downto 12));
      if (blocknum=14 or blocknum=15) and (rom_at_e000='1') then
        temp_address(19 downto 16) := x"3";
      end if;
      if (blocknum=12) and rom_at_c000='1' then
        temp_address(19 downto 16) := x"2";
      end if;
      if (blocknum=10 or blocknum=11) and (rom_at_a000='1') then
        temp_address(19 downto 16) := x"3";
      end if;
      if (blocknum=8 or blocknum=9) and (rom_at_8000='1') then
        temp_address(19 downto 16) := x"3";
      end if;
    end if;

    -- C65 DAT
    -- This seems like it's in the wrong place.   If it's here then DMAgic can't write to 
    -- the DAT, which I'm guessing actually worked on a real C65.
    report "C65 VIC-III DAT: Address before translation is $" & to_hstring(temp_address);
    if map_io='1' and viciii_iomode(0)='1' and temp_address(19 downto 3) & "000" = x"0D040" then
      temp_address(19 downto 17) := (others => '0');
      temp_address(16) := temp_address(0); -- odd/even bitplane bank select
      -- Bit plane address
      -- XXX only uses the address from upper nybl -- doesn't pick based on
      -- odd/even line/frame.
      temp_address(15 downto 13) :=
        dat_bitplane_addresses(to_integer(temp_address(2 downto 0)))(7 downto 5);
      -- Bitplane offset
      temp_address(12 downto 0) := dat_offset_drive(12 downto 0);
      report "C65 VIC-III DAT: Address translated to $" & to_hstring(temp_address);
    end if;

    if resolve_address='1' then
      io_sel_resolved <= map_io;
      ext_sel_resolved <= map_ext;
      resolved_address <= std_logic_vector(temp_address);
    else
      io_sel_resolved <= io_sel;
      ext_sel_resolved <= '0';
      resolved_address <= std_logic_vector(short_address);
    end if;
  end process;

end Behavioural;
