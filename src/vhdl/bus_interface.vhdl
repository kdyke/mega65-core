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
    writeP : in boolean;
    gated_exrom : in std_logic; 
    gated_game : in std_logic;
    map_en : in std_logic;
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
    
    resolved_address : out unsigned(19 downto 0)
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

attribute keep_hierarchy of Behavioural : architecture is "yes";

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
  variable map_exp : std_logic;
  
  begin  -- resolve_long_address

    -- Now apply C64-style $01 lines first, because MAP and $D030 take precedence
    map_io := '0';
    map_exp := '0';
    
    lhc(4) := gated_exrom;
    lhc(3) := gated_game;
    lhc(2 downto 0) := std_logic_vector(cpuport_value(2 downto 0));
    lhc(2) := lhc(2) or (not cpuport_ddr(2));
    lhc(1) := lhc(1) or (not cpuport_ddr(1));
    lhc(0) := lhc(0) or (not cpuport_ddr(0));
    
    if(writeP) then
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
            map_exp := '1';
            map_io := '0';
          end if;        
        end if;      
      end if;

      -- C64 KERNEL
      if ((blocknum=14) or (blocknum=15)) then
        if ((gated_exrom='1') and (gated_game='0')) then
          -- ULTIMAX mode external ROM
          map_exp := '1';
        elsif (lhc(1)='1') and (writeP=false) then
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
          (writeP=false)
        )
      then
        -- ULTIMAX mode or cartridge external ROM
        map_exp := '1';
      end if;
      
      -- C64 BASIC
      if ((blocknum=10) or blocknum=11) and (lhc(0)='1') and (lhc(1)='1') and (writeP=false) then
        nonmapped_page(19 downto 16) := x"2";
      end if;
    
      if (((blocknum=10) or (blocknum=11)) -- $A000-$BFFF cartridge ROM
        and ((gated_exrom='0') and (gated_game='0'))) and (writeP=false)
      then
        -- ULTIMAX mode or cartridge external ROM
        map_exp := '1';
      end if;

      -- Expose remaining address space to cartridge port in ultimax mode
      if (gated_exrom='1') and (gated_game='0') and (hypervisor_mode='0') then
        if (blocknum=1) then
          -- $1000 - $1FFF Ultimax mode
          map_exp := '1';
        end if;
        if (blocknum=2 ) then
          -- $2000 - $2FFF Ultimax mode
          -- XXX $3000-$3FFf is a copy of $F000-$FFFF from the cartridge so
          -- that the VIC-II can see it. On the M65, the Hypervisor has to copy
          -- it down. Not yet implemented, and won't be perfectly compatible.
          map_exp := '1';
        end if;
        if ((blocknum=4) or (blocknum=5)) then
          -- $4000 - $5FFF Ultimax mode
          map_exp := '1';
        end if;
        if ((blocknum=6) or (blocknum=7)) then
          -- $6000 - $7FFF Ultimax mode
          map_exp := '1';
        end if;
        if (blocknum=12) then
          -- $C000 - $CFFF Ultimax mode
          map_exp := '1';
        end if;
      end if;

      if map_exp = '1' then
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

    io_sel_resolved <= map_io;
    ext_sel_resolved <= map_exp;
    resolved_address <= temp_address;
  end process;

end Behavioural;

use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.debugtools.all;
use work.cputypes.all;
use work.victypes.all;

entity bus_interface is
  port (
    Clock : in std_logic;
    reset : in std_logic;
    exrom : in std_logic;
    game : in std_logic;

    hypervisor_mode : in std_logic := '0';

    dat_offset : in unsigned(15 downto 0);
    dat_bitplane_addresses : in sprite_vector_eight;
    
    monitor_waitstates : out unsigned(7 downto 0);
    monitor_memory_access_address : out unsigned(31 downto 0);

    -- Incoming signals from the CPU.  Only valid when ready is true.
    cpu_memory_access_address_next : in unsigned(19 downto 0);
    cpu_memory_access_read_next : in std_logic;
    cpu_memory_access_write_next : in std_logic;
    cpu_memory_access_resolve_address_next : std_logic;
    cpu_memory_access_wdata_next : in unsigned(7 downto 0);
    cpu_memory_read_data : out unsigned(7 downto 0);
    cpu_proceed : in std_logic;
    cpu_map_en_next : in std_logic;
    rom_writeprotect : in std_logic;
    cpuport_ddr : in unsigned(7 downto 0);
    cpuport_value : in unsigned(7 downto 0);
    
    memory_ready_out : out std_logic;

    -- Temporary external shadow ram bus
    system_address_out : out std_logic_vector(19 downto 0);
    system_wdata_next : out  std_logic_vector(7 downto 0)  := (others => '0');

    shadow_write_next : out std_logic := '0';
    shadow_rdata : in std_logic_vector(7 downto 0)  := (others => '0');

    kickstart_write_next : out std_logic := '0';
    kickstart_rdata : in std_logic_vector(7 downto 0)  := (others => '0');
        
    cpu_leds : out std_logic_vector(3 downto 0);
    
    ---------------------------------------------------------------------------
    -- fast IO port (clocked at core clock). 1MB address space
    ---------------------------------------------------------------------------
    fastio_addr : inout std_logic_vector(19 downto 0);
    fastio_addr_fast : out std_logic_vector(19 downto 0);
    fastio_read : inout std_logic := '0';
    fastio_write : inout std_logic := '0';
    fastio_wdata : out std_logic_vector(7 downto 0);
    fastio_rdata : in std_logic_vector(7 downto 0);
    io_sel_next_out : out std_logic := '0';
    io_sel_out : inout std_logic := '0';
    ext_sel_next_out : out std_logic := '0';
    ext_sel_out : inout std_logic := '0';
    
    sector_buffer_mapped : in std_logic;
    fastio_vic_rdata : in std_logic_vector(7 downto 0);
    fastio_colour_ram_rdata : in std_logic_vector(7 downto 0);
    colour_ram_cs : out std_logic := '0';
    charrom_write_cs : out std_logic := '0';

    ---------------------------------------------------------------------------
    -- Slow device access 4GB address space
    ---------------------------------------------------------------------------
    slow_access_request_toggle : out std_logic := '0';
    slow_access_ready_toggle : in std_logic;

    slow_access_address : out unsigned(19 downto 0) := (others => '1');
    slow_access_write : out std_logic := '0';
    slow_access_wdata : out unsigned(7 downto 0);
    slow_access_rdata : in unsigned(7 downto 0);
    
    ---------------------------------------------------------------------------
    -- VIC-III memory banking control
    ---------------------------------------------------------------------------
    viciii_iomode : in std_logic_vector(1 downto 0);

    colourram_at_dc00 : in std_logic;
    rom_at_e000 : in std_logic;
    rom_at_c000 : in std_logic;
    rom_at_a000 : in std_logic;
    rom_at_8000 : in std_logic

    );
    
    attribute keep_hierarchy : string;
    attribute mark_debug : string;
    attribute dont_touch : string;
    attribute keep : string;
    
    --attribute mark_debug of fastio_rdata: signal is "true";
    --attribute mark_debug of fastio_wdata: signal is "true";
    --attribute mark_debug of fastio_write: signal is "true";
    --
    --attribute mark_debug of ext_sel_next_out: signal is "true";
    --attribute mark_debug of io_sel_next_out: signal is "true";
    --attribute mark_debug of ext_sel_out: signal is "true";
    --attribute mark_debug of io_sel_out: signal is "true";
    --
    --attribute mark_debug of  system_wdata_next: signal is "true";
    --
    --attribute mark_debug of kickstart_rdata: signal is "true";
    --attribute mark_debug of kickstart_write_next: signal is "true";
    --
    --attribute mark_debug of system_address_out: signal is "true";
    --attribute mark_debug of shadow_write_next: signal is "true";
    --attribute mark_debug of shadow_rdata: signal is "true";
    --
    --attribute mark_debug of reset: signal is "true";
    --attribute keep of cpu_memory_read_data : signal is "true";
    --attribute dont_touch of cpu_memory_read_data : signal is "true";
    --attribute mark_debug of cpu_memory_read_data : signal is "true";
    --attribute mark_debug of cpu_proceed : signal is "true";
    --
    --attribute mark_debug of cpu_memory_access_wdata_next : signal is "true";
    
end entity bus_interface;

architecture Behavioural of bus_interface is
  
  component address_resolver is
    port (
      short_address : in unsigned(19 downto 0);
      writeP : in boolean;
      gated_exrom : in std_logic; 
      gated_game : in std_logic;
      map_en : in std_logic;
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
      resolved_address : out unsigned(19 downto 0)
      );
    
  end component address_resolver;

  attribute keep_hierarchy of Behavioural : architecture is "yes";
  
  signal reset_drive : std_logic := '0';
  signal cartridge_enable : std_logic := '0';
  signal gated_exrom : std_logic := '1'; 
  signal gated_game : std_logic := '1';
  signal force_exrom : std_logic := '1'; 
  signal force_game : std_logic := '1';

  signal dat_bitplane_addresses_drive : sprite_vector_eight;
  signal dat_offset_drive : unsigned(15 downto 0) := to_unsigned(0,16);

  signal last_address : unsigned(19 downto 0)  := (others => '0'); -- FIXME
  signal last_value : unsigned(7 downto 0)  := (others => '0');

  -- Shadow RAM control
  signal system_address : std_logic_vector(19 downto 0);
  signal system_address_next : std_logic_vector(19 downto 0);

  signal  system_wdata : std_logic_vector(7 downto 0)  := (others => '0');
  signal shadow_try_write_count : unsigned(7 downto 0) := x"00";
  signal shadow_observed_write_count : unsigned(7 downto 0) := x"00";
  signal shadow_write : std_logic := '0';

  signal kickstart_cs_next : std_logic;
  
  signal fastio_addr_next : std_logic_vector(19 downto 0);
  
  signal io_sel_resolved : std_logic;
  signal io_sel_next : std_logic;
  signal ext_sel_resolved : std_logic;
  signal ext_sel_next : std_logic;
  signal map_en_next : std_logic;
  signal map_en : std_logic;
  
  signal long_address_read : unsigned(19 downto 0)  := (others => '0');
  signal long_address_write : unsigned(19 downto 0)  := (others => '0');
 
  signal last_fastio_addr : std_logic_vector(19 downto 0)  := (others => '0');
  signal last_write_address : unsigned(19 downto 0)  := (others => '0');
  signal shadow_write_flags : unsigned(3 downto 0) := "0000";
  -- Registers to hold delayed write to hypervisor and related CPU registers
  -- to improve CPU timing closure.
  signal last_write_value : unsigned(7 downto 0)  := (others => '0');
  signal last_write_pending : std_logic := '0';
  signal last_write_fastio : std_logic := '0';

  -- IO has one waitstate for reading, 0 for writing
  -- (Reading incurrs an extra waitstate due to read_data_copy)
  -- XXX An extra wait state seems to be necessary when reading from dual-port
  -- memories like colour ram.
  constant ioread_48mhz : unsigned(7 downto 0) := x"01";
  constant colourread_48mhz : unsigned(7 downto 0) := x"02";
  constant iowrite_48mhz : unsigned(7 downto 0) := x"00";
  constant shadow_48mhz :  unsigned(7 downto 0) := x"00";

  signal shadow_wait_states : unsigned(7 downto 0) := shadow_48mhz;
  signal io_read_wait_states : unsigned(7 downto 0) := ioread_48mhz;
  signal colourram_read_wait_states : unsigned(7 downto 0) := colourread_48mhz;
  signal io_write_wait_states : unsigned(7 downto 0) := iowrite_48mhz;

  -- Interface to slow device address space
  signal slow_access_request_toggle_drive : std_logic := '0';
  signal slow_access_write_drive : std_logic := '0';
  signal slow_access_address_drive : unsigned(19 downto 0) := (others => '1');
  signal slow_access_wdata_drive : unsigned(7 downto 0) := (others => '1');
  signal slow_access_desired_ready_toggle : std_logic := '0';
  signal slow_access_ready_toggle_buffer : std_logic := '0';
  signal slow_access_pending_write : std_logic := '0';
  signal slow_access_data_ready : std_logic := '0';

  -- Number of pending wait states
  signal wait_states : unsigned(7 downto 0) := x"05";
  signal wait_states_non_zero : std_logic := '1';
  
-- Note that ROM is actually implemented using
-- power-on initialised RAM in the FPGA mapped via our io interface.
  signal accessing_slowram : std_logic;
  signal the_read_address : unsigned(19 downto 0);
  
  signal monitor_mem_trace_toggle_last : std_logic := '0';

  -- Microcode data and ALU routing signals follow:

  signal mem_reading : std_logic := '0';
  signal mem_reading_p : std_logic := '0';
  -- serial monitor is reading data 
  signal monitor_mem_reading : std_logic := '0';

  -- Is CPU free to bus_proceed with processing an instruction?
  signal bus_proceed : std_logic := '1';

  signal read_data_copy : unsigned(7 downto 0);
  
  type memory_source is (
    DMAgicRegister,         -- 0x00
    HypervisorRegister,     -- 0x01
    CPUPort,                -- 0x02
    Shadow,                 -- 0x03
    FastIO,                 -- 0x04
    ColourRAM,              -- 0x05
    VICIV,                  -- 0x06
    Kickstart,              -- 0x07
    SlowRAM,                -- 0x08
    Unmapped                -- 0x09
    );

  signal read_source : memory_source;
    
  signal pre_resolve_memory_access_address : unsigned(19 downto 0);
  signal pre_resolve_memory_access_write : boolean;
  signal post_resolve_memory_access_address_next : unsigned(19 downto 0);
  
  signal memory_access_address_next : unsigned(19 downto 0);
  signal memory_access_read_next : std_logic;
  signal memory_access_write_next : std_logic;
  signal memory_access_resolve_address_next : std_logic;
  signal memory_access_wdata_next : std_logic_vector(7 downto 0);
  
--    attribute mark_debug : string;

  --attribute mark_debug of map_en: signal is "true";
  --
  --attribute mark_debug of read_source: signal is "true";
  --attribute mark_debug of fastio_addr_next: signal is "true";
  --attribute mark_debug of read_data_copy : signal is "true";
  --
  --attribute mark_debug of map_en_next: signal is "true";
  --attribute mark_debug of pre_resolve_memory_access_address: signal is "true";
  --attribute mark_debug of post_resolve_memory_access_address_next: signal is "true";
  --
  --attribute mark_debug of  system_wdata: signal is "true";
  --attribute mark_debug of system_address_next: signal is "true";
  --attribute mark_debug of system_address: signal is "true";
  --
  --attribute mark_debug of memory_access_address_next: signal is "true";
  --attribute mark_debug of memory_access_wdata_next: signal is "true";
  --attribute mark_debug of memory_access_read_next: signal is "true";
  --attribute mark_debug of memory_access_write_next: signal is "true";
  --
  --attribute mark_debug of bus_proceed: signal is "true";
  --attribute mark_debug of memory_access_resolve_address_next: signal is "true";
  --attribute mark_debug of wait_states: signal is "true";
  --attribute mark_debug of wait_states_non_zero: signal is "true";
    
--    attribute mark_debug of colour_ram_cs : signal is "true";
--    attribute mark_debug of colourram_at_dc00 : signal is "true";
--    attribute mark_debug of sector_buffer_mapped : signal is "true";
    
begin
  
  address_resolver0 : entity work.address_resolver port map(
    short_address => pre_resolve_memory_access_address,
    writeP => pre_resolve_memory_access_write,
    gated_exrom => gated_exrom,
    gated_game => gated_game,
    map_en => map_en_next,
    cpuport_value => cpuport_value,
    cpuport_ddr => cpuport_ddr,
    viciii_iomode => viciii_iomode,
    sector_buffer_mapped => sector_buffer_mapped,
    colourram_at_dc00 => colourram_at_dc00,
    hypervisor_mode => hypervisor_mode,
    rom_at_e000 => rom_at_e000,
    rom_at_c000 => rom_at_c000,
    rom_at_a000 => rom_at_a000,
    rom_at_8000 => rom_at_8000,
    dat_bitplane_addresses => dat_bitplane_addresses,
    dat_offset_drive => dat_offset_drive,
    io_sel_resolved => io_sel_resolved,
    ext_sel_resolved => ext_sel_resolved,
    resolved_address => post_resolve_memory_access_address_next
  );
  
  process(clock,reset)

    procedure reset_cpu_state is
    begin

      -- Stop memory accesses
      colour_ram_cs <= '0';
      shadow_write <= '0';
      shadow_write_flags(0) <= '1';
      fastio_read <= '0';
      fastio_write <= '0';
      --chipram_we <= '0';        
      --chipram_datain <= x"c0";    

      slow_access_request_toggle_drive <= slow_access_ready_toggle_buffer;
      slow_access_write_drive <= '0';
      slow_access_address_drive <= (others => '1');
      slow_access_wdata_drive <= (others => '1');
      slow_access_desired_ready_toggle <= slow_access_ready_toggle;
      
      wait_states <= (others => '0');
      wait_states_non_zero <= '0';
      mem_reading <= '0';
      
    end procedure reset_cpu_state;

    procedure read_long_address(
      real_long_address : in unsigned(19 downto 0);
      io_sel_next : in std_logic;
      ext_sel_next : in std_logic) is
      variable long_address : unsigned(19 downto 0);
    begin

      last_address <= real_long_address;
      
      -- Stop writing when reading.     
      fastio_write <= '0'; shadow_write <= '0';

      long_address := long_address_read;
      
      report "Reading from long address $" & to_hstring(long_address) severity note;
      mem_reading <= '1';
      
      -- Schedule the memory read from the appropriate source.
      accessing_slowram <= '0';
      slow_access_pending_write <= '0';
      slow_access_write_drive <= '0';
      charrom_write_cs <= '0';

      wait_states <= io_read_wait_states;
      if io_read_wait_states /= x"00" then
        wait_states_non_zero <= '1';
      else
        wait_states_non_zero <= '0';
      end if; 
      
      -- Clear fastio access so that we don't keep reading/writing last IO address
      -- (this is bad when it is $DC0D for example, as it will stop IRQs from
      -- the CIA).
      fastio_addr <= x"FFFFF"; fastio_write <= '0'; fastio_read <= '0';
            
      the_read_address <= long_address;

      shadow_write <= '0';
      shadow_write_flags(1) <= '1';

      report "MEMORY long_address = $" & to_hstring(long_address);
      -- @IO:C64 $0000000 6510/45GS10 CPU port DDR
      -- @IO:C64 $0000001 6510/45GS10 CPU port data
      if io_sel_next='1' and long_address(15 downto 6)&"00" = x"D64" and hypervisor_mode='1' then
        report "Preparing for reading hypervisor register";
        read_source <= HypervisorRegister;
        -- One cycle wait-state on hypervisor registers to remove the register
        -- decode from the critical path of memory access.
        wait_states <= x"01";
        wait_states_non_zero <= '1';
        bus_proceed <= '0';
      elsif (long_address = x"00000") or (long_address = x"00001") then
        report "Preparing to read from a CPUPort";
        read_source <= CPUPort;
        -- One cycle wait-state on hypervisor registers to remove the register
        -- decode from the critical path of memory access.
        wait_states <= x"01";
        wait_states_non_zero <= '1';
        bus_proceed <= '0';
      elsif (io_sel_next='1' and long_address = x"0d0a0") then
        report "Preparing to read from CPU memory expansion controller port";
        read_source <= CPUPort;
        -- One cycle wait-state on hypervisor registers to remove the register
        -- decode from the critical path of memory access.
        wait_states <= x"01";
        wait_states_non_zero <= '1';
        bus_proceed <= '0';
      elsif io_sel_next='0' and ext_sel_next='0' and long_address(19)='0' and long_address(18)='0' then
        -- Reading from chipram
        -- @ IO:C64 $00002-$0FFFF - 64KB RAM
        -- @ IO:C65 $10000-$1FFFF - 64KB RAM
        -- @ IO:C65 $20000-$3FFFF - 128KB ROM (can be used as RAM in M65 mode)
        -- @ IO:C65 $2A000-$2BFFF - 8KB C64 BASIC ROM
        -- @ IO:C65 $2D000-$2DFFF - 4KB C64 CHARACTER ROM
        -- @ IO:C65 $2E000-$2FFFF - 8KB C64 KERNAL ROM
        -- @ IO:C65 $3E000-$3FFFF - 8KB C65 KERNAL ROM
        -- @ IO:C65 $3C000-$3CFFF - 4KB C65 KERNAL/INTERFACE ROM
        -- @ IO:C65 $38000-$3BFFF - 8KB C65 BASIC GRAPHICS ROM
        -- @ IO:C65 $32000-$35FFF - 8KB C65 BASIC ROM
        -- @ IO:C65 $30000-$31FFF - 16KB C65 DOS ROM
        -- @ IO:M65 $40000-$5FFFF - 128KB RAM (in place of C65 cartridge support)
        report "Preparing to read from Shadow";
        read_source <= Shadow;
        wait_states_non_zero <= '0';
        bus_proceed <= '1';
          report "Reading from shadowed chipram address $"
          & to_hstring(long_address(19 downto 0)) severity note;
                                        --Also mapped to 7F2 0000 - 7F3 FFFF
      -- @IO:GS $F8000-$FBFFF 16KB Kickstart/Hypervisor ROM
      elsif io_sel_next='0' and kickstart_cs_next='1' then
        fastio_read <= '0';
        read_source <= Kickstart;
        bus_proceed <= '1';
        wait_states_non_zero <= '0';
        
      elsif io_sel_next='1' or long_address(19 downto 16) = x"8" then
        report "Preparing to read from FastIO";
        read_source <= FastIO;

        fastio_addr <= fastio_addr_next;        
        last_fastio_addr <= fastio_addr_next;
        fastio_read <= '1';
        bus_proceed <= '0';
        
        -- XXX Some fastio (that referencing ioclocked registers) does require
        -- io_wait_states, while some can use fewer waitstates because the
        -- memories involved can be clocked at the CPU clock, and have just 1
        -- wait state due to the dual-port memories.
        -- But for now, just apply the wait state to all fastio addresses.
        wait_states <= io_read_wait_states;
        if io_read_wait_states /= x"00" then
          wait_states_non_zero <= '1';
        else
          wait_states_non_zero <= '0';
        end if;
        
        -- If reading IO page from $D{0,1,2,3}0{0-7}X, then the access is from
        -- the VIC-IV.
        -- If reading IO page from $D{0,1,2,3}{1,2,3}XX, then the access is from
        -- the VIC-IV.
        -- If reading IO page from $D{0,1,2,3}{8,9,a,b}XX, then the access is from
        -- the VIC-IV.
        -- If reading IO page from $D{0,1,2,3}{c,d,e,f}XX, and colourram_at_dc00='1',
        -- then the access is from the VIC-IV.
        -- If reading IO page from $8XXXX, then the access is from the VIC-IV.
        -- We make the distinction to separate reading of VIC-IV
        -- registers from all other IO registers, partly to work around some bugs,
        -- and partly because the banking of the VIC registers is the fiddliest part.

        -- @IO:GS $8xxxx - Colour RAM (32KB or 64KB) -- FIXME
        if long_address(19 downto 16) = x"8" then
          report "VIC 64KB colour RAM access from VIC fastio" severity note;
          report "Preparing to read from ColourRAM";
          read_source <= ColourRAM;
          colour_ram_cs <= '1';
          wait_states <= colourram_read_wait_states;
          if colourram_read_wait_states /= x"00" then
            wait_states_non_zero <= '1';
          else
            wait_states_non_zero <= '0';
          end if;
        end if;
        if long_address(19 downto 12) = x"0D" then
            if long_address(11 downto 10) = "00" then  --   $D{0,1,2,3}{0,1,2,3}XX
              if long_address(11 downto 7) /= "00001" then  -- ! $D.0{8-F}X (FDC, RAM EX)
                report "VIC register from VIC fastio" severity note;
                report "Preparing to read from VICIV";
                read_source <= VICIV;
              end if;            
            end if;

            -- Colour RAM at $D800-$DBFF and optionally $DC00-$DFFF
            if long_address(11)='1' then
              if (long_address(10)='0') or (colourram_at_dc00='1') then
                report "RAM: D800-DBFF/DC00-DFFF colour ram access from VIC fastio" severity note;
                report "Preparing to read from ColourRAM";
                read_source <= ColourRAM;
                colour_ram_cs <= '1';
                wait_states <= colourram_read_wait_states;
                if colourram_read_wait_states /= x"00" then
                  wait_states_non_zero <= '1';
                else
                  wait_states_non_zero <= '0';
                end if;
              end if;
            end if;
        end if;                           -- $DXXXX
      elsif ext_sel_next='1' then
        -- @IO:GS $4000000 - $7FFFFFF Slow Device memory (64MB)
        -- @IO:GS $8000000 - $FEFFFFF Slow Device memory (127MB)
        report "Preparing to read from SlowRAM";
        read_source <= SlowRAM;
        accessing_slowram <= '1';
        slow_access_data_ready <= '0';
        slow_access_address_drive <= long_address(19 downto 0);
        slow_access_write_drive <= '0';
        slow_access_request_toggle_drive <= not slow_access_request_toggle_drive;
        slow_access_desired_ready_toggle <= not slow_access_desired_ready_toggle;
        wait_states <= x"FF";
        wait_states_non_zero <= '1';
        bus_proceed <= '0';
      else
        -- Don't let unmapped memory jam things up
        report "hit unmapped memory -- clearing wait_states" severity note;
        report "Preparing to read from Unmapped";
        read_source <= Unmapped;
        wait_states <= shadow_wait_states;
        if shadow_wait_states /= x"00" then
          wait_states_non_zero <= '1';
        else
          wait_states_non_zero <= '0';
        end if;
        bus_proceed <= '1';
      end if;
      if (viciii_iomode="01" or viciii_iomode="11") and (long_address(19 downto 8) = x"0D7") then
        report "Preparing to read from a DMAgicRegister";
        read_source <= DMAgicRegister;
      end if;      

    end read_long_address;
    
    -- purpose: obtain the byte of memory that has been read
    impure function read_data_complex
      return unsigned is
      variable value : unsigned(7 downto 0);
    begin  -- read_data
      -- CPU hosted IO registers
      report "Read source is " & memory_source'image(read_source);
      case read_source is
        when DMAgicRegister =>
          return x"AA";
        when HypervisorRegister =>
          return x"55";
        when CPUPort =>
          return x"FF";
        when Shadow =>
          report "reading from shadow RAM" severity note;
          return unsigned(shadow_rdata);
        when ColourRAM =>
          report "reading colour RAM fastio byte $" & to_hstring(fastio_vic_rdata) severity note;
          return unsigned(fastio_colour_ram_rdata);
        when VICIV =>
          report "reading VIC fastio byte $" & to_hstring(fastio_vic_rdata) severity note;
          return unsigned(fastio_vic_rdata);
        when FastIO =>
          report "reading normal fastio byte $" & to_hstring(fastio_rdata) severity note;
          return unsigned(fastio_rdata);
        when Kickstart =>
          report "reading kickstart fastio byte $" & to_hstring(kickstart_rdata) severity note;
          return unsigned(kickstart_rdata);
        when SlowRAM =>
          report "reading slow RAM data. Word is $" & to_hstring(slow_access_rdata) severity note;
          return unsigned(slow_access_rdata);
        when Unmapped =>
          report "accessing unmapped memory" severity note;
          return x"A0";                     -- make unmmapped memory obvious
      end case;
    end read_data_complex; 

    procedure write_long_byte(
      real_long_address       : in unsigned(19 downto 0);
      value              : in std_logic_vector(7 downto 0);
      io_sel_next : in std_logic;
      ext_sel_next : in std_logic) is
      variable long_address : unsigned(19 downto 0);
      variable dmagic_write : std_logic;
    begin
      -- Schedule the memory write to the appropriate destination.

      last_value <= unsigned(value); last_address <= real_long_address;
      
      accessing_slowram <= '0';
      slow_access_write_drive <= '0';
      charrom_write_cs <= '0';
      
      -- Get the shadow RAM or ROM address on the bus fast to improve timing.
      shadow_write <= '0';
      shadow_write_flags(1) <= '1';
      
      shadow_write_flags(0) <= '1';
      shadow_write_flags(1) <= '1';
      
      wait_states <= shadow_wait_states;
      if shadow_wait_states /= x"00" then
        wait_states_non_zero <= '1';
      else
        wait_states_non_zero <= '0';
      end if;

      long_address := long_address_write;
      
      last_write_address <= real_long_address;
      last_write_fastio <= '0';
      
      -- Always write to shadow ram if in scope, even if we also write elsewhere.
      -- This ensures that shadow ram is consistent with the shadowed address space
      -- when the CPU reads from shadow ram.
      -- Get the shadow RAM address on the bus fast to improve timing.
      -- system_wdata <= value;
      
      if io_sel_next='0' and ext_sel_next='0' and long_address(19)='0' and long_address(18)='0' then      
        report "writing to chip RAM addr=$" & to_hstring(long_address) severity note;
        --system_address <= system_address_next;
        -- Enforce write protect of 2nd 128KB of memory, if being used as ROM
        if long_address(19 downto 17)="001" then
          shadow_write <= not rom_writeprotect;
        else
          shadow_write <= '1';
        end if;
        fastio_write <= '0';
        -- shadow_try_write_count <= shadow_try_write_count + 1;
        shadow_write_flags(3) <= '1';
        --chipram_address <= long_address(16 downto 0);
        --chipram_we <= '1';
        --chipram_datain <= value;
        --report "writing to chipram..." severity note;
        wait_states <= io_write_wait_states;
        if io_write_wait_states /= x"00" then
          wait_states_non_zero <= '1';
        else
          wait_states_non_zero <= '0';
        end if;

        -- C65 uses $1F800-FFF as colour RAM, so we need to write there, too,
        -- when writing here.
        if long_address(19 downto 12) = x"1F" and long_address(11) = '1' then
          report "writing to colour RAM via $001F8xx" severity note;

          -- And also to colour RAM
          colour_ram_cs <= '1';
          fastio_write <= '1';
          fastio_wdata <= std_logic_vector(value);
          fastio_addr(19 downto 16) <= x"8";
          fastio_addr(15 downto 11) <= (others => '0');
          fastio_addr(10 downto 0) <= std_logic_vector(long_address(10 downto 0));
        end if;
      elsif io_sel_next='1' 
            --or (hypervisor_mode='1' and long_address(19 downto 14)&"00" = x"F8") 
            or long_address(19 downto 16) = x"8"
            or long_address(19 downto 12) = x"7E" then --
        shadow_write <= '0';
        shadow_write_flags(2) <= '1';
        fastio_addr <= fastio_addr_next;
        last_fastio_addr <= fastio_addr_next;
        fastio_write <= '1'; fastio_read <= '0';
        report "raising fastio_write" severity note;
        fastio_wdata <= std_logic_vector(value);
        
        -- Setup delayed write to hypervisor registers
        -- (this removes the fan-out to 64 more registers from being on the
        -- critical path.  The side-effect is that writing to hypervisor
        -- registers (except $D67F) has the effect delayed by one cycle. Should
        -- only matter if you run self-modifying code in these registers from the
        -- hypervisor. If you do that, then you probably deserve to see problems.
        last_write_value <= unsigned(value);
        last_write_pending <= '1';
        last_write_fastio <= '1';
        
        -- @IO:GS $FF7Exxx VIC-IV CHARROM write area
        if long_address(19 downto 12) = x"7E" then
          charrom_write_cs <= '1';
        end if;
        
        if long_address(19 downto 16) = x"8" then
          colour_ram_cs <= '1';
        end if;
        if long_address(15 downto 12) = x"D" then    --   $D{0,1,2,3}XXX
          -- Colour RAM at $D800-$DBFF and optionally $DC00-$DFFF
          if long_address(11)='1' then
            if (long_address(10)='0') or (colourram_at_dc00='1') then
              report "D800-DBFF/DC00-DFFF colour ram access from VIC fastio" severity note;
              colour_ram_cs <= '1';

              -- Write also to CHIP RAM, so that $1F800-FFF works as chipRAM
              -- as well as colour RAM, when accessed via $D800+ portal
              --chipram_address(16 downto 11) <= "111111"; -- $1F8xx
              --chipram_address(10 downto 0) <= long_address(10 downto 0);
              --chipram_we <= '1';
              --chipram_datain <= value;
              --report "writing to chipram..." severity note;
              
            end if;
          end if;
        end if;                         -- $D{0,1,2,3}XXX
        
        wait_states <= io_write_wait_states;
        if io_write_wait_states /= x"00" then
          wait_states_non_zero <= '1';
        else
          wait_states_non_zero <= '0';
        end if;
      elsif ext_sel_next='1' then
        report "writing to slow device memory..." severity note;
        accessing_slowram <= '1';
        shadow_write <= '0';
        fastio_write <= '0';        
        shadow_write_flags(2) <= '1';
        -- We dispatch the write, and then wait for the slow access controller
        -- to acknowledge the write.  The slow access controller is free to
        -- buffer the writes as it wishes to hide latency -- we don't need to worry
        -- about there here, as it only changes the latency for receiving the
        -- write acknowledgement (a similar process can be used for caching reads
        -- from appropriate slow devices, e.g., for expansion memory).
        slow_access_address_drive <= long_address(19 downto 0);
        slow_access_write_drive <= '1';
        slow_access_wdata_drive <= unsigned(value);
        slow_access_pending_write <= '1';
        slow_access_data_ready <= '0';

        -- Tell CPU to wait for response
        slow_access_request_toggle_drive <= not slow_access_request_toggle_drive;
        slow_access_desired_ready_toggle <= not slow_access_desired_ready_toggle;
        wait_states_non_zero <= '1';
        wait_states <= x"FF";
        bus_proceed <= '0';
      else
        -- Don't let unmapped memory jam things up
        shadow_write <= '0';
        null;
      end if;
    end write_long_byte;
        
    variable memory_read_value : unsigned(7 downto 0);

    variable memory_access_address : unsigned(19 downto 0) := x"FFFFF";
    variable memory_access_read : std_logic := '0';
    variable memory_access_write : std_logic := '0';
    variable memory_access_resolve_address : std_logic := '0';
    variable memory_access_wdata : std_logic_vector(7 downto 0) := x"FF";

    variable temp_addr : unsigned(15 downto 0);    
    
  begin    

                                        -- BEGINNING OF MAIN PROCESS FOR CPU
    if rising_edge(clock) then
      
      dat_bitplane_addresses_drive <= dat_bitplane_addresses;
      dat_offset_drive <= dat_offset;
      
      if cartridge_enable='1' then
        gated_exrom <= exrom and force_exrom;
        gated_game <= game and force_game;
      else
        gated_exrom <= force_exrom;
        gated_game <= force_game;
      end if;
      
                                        -- Propagate slow device access interface signals
      slow_access_request_toggle <= slow_access_request_toggle_drive;
      slow_access_address <= slow_access_address_drive;
      slow_access_write <= slow_access_write_drive;
      slow_access_wdata <= slow_access_wdata_drive;
      slow_access_ready_toggle_buffer <= slow_access_ready_toggle;

                                                    -- Copy read memory location to simplify reading from memory.
                                        -- Penalty is +1 wait state for memory other than shadowram.
      read_data_copy <= read_data_complex;
            
      memory_access_read := '0';
      memory_access_write := '0';
      memory_access_resolve_address := '0';
      
      monitor_waitstates <= wait_states;
    
                                        -- report "reset = " & std_logic'image(reset) severity note;
      reset_drive <= reset;
      if reset_drive='0' then
        bus_proceed <= '0';
        wait_states <= x"00";
        wait_states_non_zero <= '0';
      else
                                        -- Honour wait states on memory accesses
                                        -- Clear memory access lines unless we are in a memory wait state
                                        -- XXX replace with single bit test flag for wait_states = 0 to reduce
                                        -- logic depth
        if wait_states_non_zero = '1' then
          report "  $" & to_hstring(wait_states)
            &" memory waitstates remaining.  Fastio_rdata = $"
            & to_hstring(fastio_rdata)
            & ", mem_reading=" & std_logic'image(mem_reading)
            & ", fastio_addr=$" & to_hstring(fastio_addr)
            severity note;
          if (accessing_slowram='1') then
            if slow_access_ready_toggle = slow_access_desired_ready_toggle then
                                        -- Next cycle we can do stuff, provided that the serial monitor
                                        -- isn't asking us to do anything.
              bus_proceed <= '1';
              slow_access_write_drive <= '0';
            else
                                        -- Otherwise keep waiting for slow memory interface
              null;
            end if;           
          else
            if wait_states /= x"01" then
              wait_states <= wait_states - 1;
              wait_states_non_zero <= '1';
            else
              wait_states_non_zero <= '0';
              bus_proceed <= '1';
            end if;
          end if;          
        else
                                        -- End of wait states, so clear memory writing and reading

          colour_ram_cs <= '0';
          fastio_write <= '0';
          slow_access_write_drive <= '0';

          if mem_reading='1' then
--            report "resetting mem_reading (read $" & to_hstring(memory_read_value) & ")" severity note;
            mem_reading <= '0';
            monitor_mem_reading <= '0';
          end if;

          bus_proceed <= '1';
        end if;

        report "CPU state : cpu_proceed=" & std_logic'image(cpu_proceed);
        if cpu_proceed='1' then

          -- Temporarily pick up memory access signals from combinatorial code
          memory_access_address :=  memory_access_address_next;
          memory_access_read := memory_access_read_next;
          memory_access_write := memory_access_write_next;
          memory_access_resolve_address := memory_access_resolve_address_next;
          memory_access_wdata := memory_access_wdata_next;

        end if;
        
        io_sel_out <= io_sel_next;
        ext_sel_out <= ext_sel_next;
        map_en <= map_en_next;

        -- Shouldn't this just always happen?
        system_address <= system_address_next;
        
                                        -- Effect memory accesses.
                                        -- Note that we cannot combine address resolution for read and write,
                                        -- because the resolution of some addresses is dependent on whether
                                        -- the operation is read or write.  ROM accesses are a good example.
                                        -- We delay the memory write until the next cycle to minimise logic depth

                                        -- XXX - Try to fast-route low address lines to shadowram and other memory
                                        -- blocks.
        
                                        -- Mark pages dirty as necessary        
        if memory_access_write='1' then

                                        -- Get the shadow RAM or ROM address on the bus fast to improve timing.
          shadow_write <= '0';
          shadow_write_flags(1) <= '1';
          
          write_long_byte(memory_access_address,memory_access_wdata,io_sel_next,ext_sel_next);
        elsif memory_access_read='1' then 
          report "memory_access_read=1, addres=$"&to_hstring(memory_access_address) severity note;
          read_long_address(memory_access_address,io_sel_next,ext_sel_next);
        end if;
      end if; -- if not reseting
    end if;                         -- if rising edge of clock
  end process;
  
  -- output all monitor values based on current state, not one clock delayed.
  monitor_memory_access_address <= x"000" & memory_access_address_next;
              
  -- alternate (new) combinatorial core memory address generation.
  process (hypervisor_mode,mem_reading,
    viciii_iomode,
    shadow_rdata,bus_proceed,cpu_proceed,
    cpu_memory_access_read_next, cpu_memory_access_write_next, cpu_memory_access_address_next, cpu_memory_access_wdata_next,
     system_wdata,system_address,
    rom_writeprotect,fastio_addr,
    post_resolve_memory_access_address_next,
    system_address_next, read_source, fastio_addr_next, io_sel_next, ext_sel_next
    )
    variable memory_access_address : unsigned(19 downto 0) := x"FFFFF";
    variable memory_access_read : std_logic := '0';
    variable memory_access_write : std_logic := '0';
    variable memory_access_resolve_address : std_logic := '0';
    variable memory_access_wdata : std_logic_vector(7 downto 0) := x"FF";
    
    variable system_address_var : std_logic_vector(19 downto 0);
    variable shadow_write_var : std_logic := '0';
    variable  system_wdata_var : std_logic_vector(7 downto 0) := x"FF";
    variable io_sel_next_var : std_logic := '0';
    variable ext_sel_next_var : std_logic := '0';
    
    variable kickstart_write_var : std_logic := '0';
    
    variable fastio_addr_var : std_logic_vector(19 downto 0);

    variable long_address_read_var : unsigned(19 downto 0) := x"FFFFF";
    variable long_address_write_var : unsigned(19 downto 0) := x"FFFFF";

    variable pre_resolve_addr_var : unsigned(19 downto 0);
    variable map_en_var : std_logic;
    variable kickstart_cs_var : std_logic;
    
    --attribute mark_debug of shadow_write_var : variable is "true";
    --attribute mark_debug of memory_access_resolve_address : variable is "true";
    
  begin
        
    -- Don't do anything by default...
    memory_access_read := '0';
    memory_access_write := '0';
    memory_access_resolve_address := '0';
    kickstart_cs_var := '0';
    
    -- By default, shadow/rom addresses hold previous values
    
    -- These always reset after each cycle though (no feedback loop)
    shadow_write_var := '0';
    kickstart_write_var := '0';
    
    fastio_addr_var := fastio_addr;
    fastio_addr_next <= fastio_addr;
    
    -- By default these hold their old value while CPU is halted
    
    -- TODO - Figure out if we even need this "hold" stuff at this level.  Now that the 
    -- CPU will actually hold addresses constant while it is paused for any reason, this
    -- may be totally redundant and just adds more logic/switching to the address output
    -- path that could be eliminated entirely, and in theory since this is just a passthrough
    -- of the CPU address, *should* be more or less meaningless anyway.
    system_wdata_var :=  system_wdata;
    system_address_next <= system_address;
    system_wdata_next <=  system_wdata;
    
    system_address_var := system_address;

    long_address_write_var := x"FFFFF";
    long_address_read_var := x"FFFFF";

    memory_access_address := x"00000";
    memory_access_wdata := std_logic_vector(cpu_memory_access_wdata_next); --x"00";

    pre_resolve_memory_access_address <= x"00000";
    pre_resolve_memory_access_write <= false;

    -- These hold current value until we are ready to move on?
    io_sel_next <= io_sel_out;
    ext_sel_next <= ext_sel_out;
    
    -- Hold previous value by default?
    map_en_next <= map_en;
    map_en_var := '0';

    if cpu_proceed = '1' then
    
      -- By default read next byte in instruction stream.
      -- TODO - See if the memory address/resolve/etc signals (everything but read/write)
      -- can be pulled out of the cpu_proceed block.
      -- TODO2 - See if the entire conditional can be removed.  It seems like now that the
      -- CPU core is properly holding its bus signals that a lot of this could just be
      -- happening all the time.
      memory_access_read := cpu_memory_access_read_next;
      memory_access_write := cpu_memory_access_write_next;
      memory_access_address := cpu_memory_access_address_next;
      memory_access_resolve_address := cpu_memory_access_resolve_address_next;
      memory_access_wdata := std_logic_vector(cpu_memory_access_wdata_next);
      
      fastio_addr_var := x"FFFFF";

  		system_wdata_var := std_logic_vector(cpu_memory_access_wdata_next);

      pre_resolve_memory_access_write <= memory_access_write = '1';

      map_en_next <= cpu_map_en_next;
      pre_resolve_memory_access_address <= cpu_memory_access_address_next;

		  if memory_access_resolve_address = '1' then
        
		    memory_access_address := post_resolve_memory_access_address_next;
        io_sel_next_var := io_sel_resolved;
        ext_sel_next_var := ext_sel_resolved;
      else
        io_sel_next_var := '0';
        ext_sel_next_var := '0';
      end if;      

      -- TODO - Why is system_address_var even needed any more?  Maybe just for the extra
      -- hold logic we have, but it seems like it should just be memory_access_address if
      -- we fix the later to have the right value all of the time (and to hold properly,
      -- which probably involes making sure the CPU generates the right signals when paused).
	    system_address_var := std_logic_vector(memory_access_address(19 downto 0));
      
      if (hypervisor_mode='1' and memory_access_address(19 downto 14)&"00" = x"F8") then
        kickstart_cs_var := '1';
      end if;
      
  		if memory_access_write='1' then
        
  		  long_address_write_var := memory_access_address;
		        
  		  if memory_access_address(19 downto 17)="001" then
  		    report "writing to ROM. addr=$" & to_hstring(memory_access_address) severity note;
  		    shadow_write_var := not rom_writeprotect;
    		elsif memory_access_address(19 downto 17)="000"then
  		    report "writing to shadow RAM via chipram shadowing. addr=$" & to_hstring(memory_access_address) severity note;
          -- Writes that don't hit I/O go to shadow memory
          if io_sel_next_var='0' then
            shadow_write_var := '1';
          end if;

          -- C65 uses $1F800-FFF as colour RAM, so we need to write there, too,
          -- when writing here.
          if memory_access_address(19 downto 12) = x"1F" and memory_access_address(11) = '1' then
            report "writing to colour RAM via $001F8xx" severity note;

            -- And also to colour RAM
            fastio_addr_var(19 downto 16) := x"8";
            fastio_addr_var(15 downto 11) := (others => '0');
            fastio_addr_var(10 downto 0) := std_logic_vector(memory_access_address(10 downto 0));
          end if;
        end if;
        
        kickstart_write_var := kickstart_cs_var;
        
        -- Fast I/O and charrom write accesses need to drive fastio address bus (for now, at least)
        -- Eventually we should always be able to drive the fastIO address bus signal and rely on chip select
        -- logic to avoid false writes.   The CPU core shouldn't know about *any* of this stuff.
        if io_sel_next_var='1' or memory_access_address(19 downto 12) = x"7E" then
          fastio_addr_var := std_logic_vector(memory_access_address(19 downto 0));
        end if;
        
      elsif memory_access_read='1' then
		   
  		  long_address_read_var := memory_access_address;
		  
        if io_sel_next_var='1' then
           fastio_addr_var := std_logic_vector(memory_access_address(19 downto 0));
        end if;
       
      end if;

      system_address_next <= system_address_var;

      io_sel_next <= io_sel_next_var;
      ext_sel_next <= ext_sel_next_var;
    end if;

    fastio_addr_next <= fastio_addr_var;

    -- Assign outputs to signals that clocked side can see and use...
    memory_access_address_next <= memory_access_address;
    memory_access_read_next <= memory_access_read;
    memory_access_write_next <= memory_access_write;
    memory_access_resolve_address_next <= memory_access_resolve_address;
    memory_access_wdata_next <= memory_access_wdata;

     system_wdata_next <= memory_access_wdata;

    system_address_out <= system_address_next;
    shadow_write_next <= shadow_write_var;
    
    -- FIXME - There's not really a good reason for these to be different.
    long_address_read <= long_address_read_var;
    long_address_write <= long_address_write_var;

    kickstart_write_next <= kickstart_write_var;
    kickstart_cs_next <= kickstart_cs_var;
    
    fastio_addr_fast <= fastio_addr_next;
    io_sel_next_out <= io_sel_next;
    ext_sel_next_out <= ext_sel_next;
    memory_ready_out <= bus_proceed;
    
  end process;

  -- read_data input mux
  process (read_source, shadow_rdata, read_data_copy)
  begin
    if(read_source = Shadow) then
      cpu_memory_read_data <= unsigned(shadow_rdata);
    elsif(read_source = Kickstart) then
      cpu_memory_read_data <= unsigned(kickstart_rdata);
    else
      cpu_memory_read_data <= read_data_copy;
    end if;  
  end process;
  
end Behavioural;

