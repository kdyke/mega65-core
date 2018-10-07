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
        map_exp := '1';
      end if;
      
      -- C64 BASIC
      if ((blocknum=10) or blocknum=11) and (lhc(0)='1') and (lhc(1)='1') and (writeP='0') then
        nonmapped_page(19 downto 16) := x"2";
      end if;
    
      if (((blocknum=10) or (blocknum=11)) -- $A000-$BFFF cartridge ROM
        and ((gated_exrom='0') and (gated_game='0'))) and (writeP='0')
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
    resolved_address <= std_logic_vector(temp_address);
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
    cpu_memory_access_resolve_address_next : in std_logic;
    cpu_memory_access_wdata_next : in unsigned(7 downto 0);
    cpu_memory_access_io_next : in std_logic;
    cpu_memory_read_data : out unsigned(7 downto 0);
    cpu_proceed : in std_logic;
    cpu_map_en_next : in std_logic;
    rom_writeprotect : in std_logic;
    cpuport_ddr : in unsigned(7 downto 0);
    cpuport_value : in unsigned(7 downto 0);
    
    memory_ready_out : out std_logic;

    -- These are all inout so the clocked variants can read from them too.
    system_address_next : inout std_logic_vector(19 downto 0); 
    system_wdata_next : inout  std_logic_vector(7 downto 0);
    system_write_next : inout std_logic;
    system_read_next : inout std_logic;

    -- These are the clocked versions
    system_address : out std_logic_vector(19 downto 0);
    system_wdata : out  std_logic_vector(7 downto 0)  := (others => '0');
    system_write : out std_logic;
    system_read : out std_logic;
    
    shadow_write_next : out std_logic := '0';
    shadow_rdata : in std_logic_vector(7 downto 0)  := (others => '0');

    kickstart_write_next : out std_logic := '0';
    kickstart_rdata : in std_logic_vector(7 downto 0)  := (others => '0');
        
    cpu_leds : out std_logic_vector(3 downto 0);
    
    ---------------------------------------------------------------------------
    -- fast IO port (clocked at core clock). 1MB address space
    ---------------------------------------------------------------------------
    io_rdata : in std_logic_vector(7 downto 0);
    io_sel_next_out : out std_logic := '0';
    io_sel_out : inout std_logic := '0';
    ext_sel_next_out : out std_logic := '0';
    ext_sel_out : inout std_logic := '0';
    
    sector_buffer_mapped : in std_logic;
    vic_rdata : in std_logic_vector(7 downto 0);
    fastio_colour_ram_rdata : in std_logic_vector(7 downto 0);
    colour_ram_cs : out std_logic := '0';
    colour_ram_cs_next : inout std_logic := '0';
    charrom_write_cs_next : out std_logic := '0';
    vic_cs_next : inout std_logic := '0';
    
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
    
    --attribute mark_debug of io_rdata: signal is "true";
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
    --attribute mark_debug of system_address_next: signal is "true";
    --attribute mark_debug of system_write_next: signal is "true";
    --attribute mark_debug of system_wdata_next: signal is "true";
    
    --attribute mark_debug of shadow_write_next: signal is "true";
    --attribute mark_debug of shadow_rdata: signal is "true";
    --
    --attribute mark_debug of reset: signal is "true";
    --attribute keep of cpu_memory_read_data : signal is "true";
    --attribute dont_touch of cpu_memory_read_data : signal is "true";
    --attribute mark_debug of cpu_memory_read_data : signal is "true";
    --attribute mark_debug of cpu_proceed : signal is "true";
    --attribute mark_debug of memory_ready_out : signal is "true";
    --attribute mark_debug of vic_rdata : signal is "true";
    --
    --attribute mark_debug of cpu_memory_access_wdata_next : signal is "true";
    
end entity bus_interface;

architecture Behavioural of bus_interface is
  
  component address_resolver is
    port (
      short_address : in unsigned(19 downto 0);
      writeP : in std_logic;
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

  -- Shadow RAM control

  signal shadow_try_write_count : unsigned(7 downto 0) := x"00";
  signal shadow_observed_write_count : unsigned(7 downto 0) := x"00";

  signal kickstart_cs_next : std_logic;
  
  signal io_sel_resolved : std_logic;
  signal io_sel_next : std_logic;
  signal ext_sel_resolved : std_logic;
  signal ext_sel_next : std_logic;
  
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
    
  signal post_resolve_memory_access_address_next : std_logic_vector(19 downto 0);
  
  --attribute mark_debug of read_source: signal is "true";
  --attribute mark_debug of read_data_copy : signal is "true";
  --
  --attribute mark_debug of post_resolve_memory_access_address_next: signal is "true";
  --
  --attribute mark_debug of system_wdata: signal is "true";
  --attribute mark_debug of system_address_next: signal is "true";
  --attribute mark_debug of system_address: signal is "true";
  --
  --attribute mark_debug of bus_proceed: signal is "true";
  --attribute mark_debug of wait_states: signal is "true";
  --attribute mark_debug of wait_states_non_zero: signal is "true";
    
  --attribute mark_debug of colour_ram_cs : signal is "true";
  --attribute mark_debug of colourram_at_dc00 : signal is "true";
  --attribute mark_debug of sector_buffer_mapped : signal is "true";
  --attribute mark_debug of kickstart_cs_next : signal is "true";
  --attribute mark_debug of colour_ram_cs_next : signal is "true";
  --attribute mark_debug of vic_cs_next : signal is "true";
  
begin
  
  address_resolver0 : entity work.address_resolver port map(
    short_address => cpu_memory_access_address_next,
    writeP => cpu_memory_access_write_next,
    gated_exrom => gated_exrom,
    gated_game => gated_game,
    map_en => cpu_map_en_next,
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
      io_sel_next : in std_logic;
      ext_sel_next : in std_logic) is
      variable long_address : unsigned(19 downto 0);
    begin

      -- Stop writing when reading.     

      long_address := unsigned(system_address_next);
      
      report "Reading from long address $" & to_hstring(long_address) severity note;
      mem_reading <= '1';
      
      -- Schedule the memory read from the appropriate source.
      accessing_slowram <= '0';
      slow_access_pending_write <= '0';
      slow_access_write_drive <= '0';

      wait_states <= io_read_wait_states;
      if io_read_wait_states /= x"00" then
        wait_states_non_zero <= '1';
      else
        wait_states_non_zero <= '0';
      end if; 
                  
      the_read_address <= long_address;

      report "MEMORY long_address = $" & to_hstring(long_address);
      -- @IO:C64 $0000000 6510/45GS10 CPU port DDR
      -- @IO:C64 $0000001 6510/45GS10 CPU port data
      if io_sel_next='1' and long_address(11 downto 6)&"00" = x"64" and hypervisor_mode='1' then
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
        -- @IO:GS $F8000-$FBFFF 16KB Kickstart/Hypervisor ROM
      elsif kickstart_cs_next='1' then
        read_source <= Kickstart;
        bus_proceed <= '1';
        wait_states_non_zero <= '0';
      elsif colour_ram_cs_next='1' then
        read_source <= ColourRAM;
        bus_proceed <= '1';
        wait_states_non_zero <= '0';
      elsif vic_cs_next='1' then
        read_source <= VICIV;
        bus_proceed <= '1';
        wait_states_non_zero <= '0';          
      elsif io_sel_next='1' then
        report "Preparing to read from FastIO";
        read_source <= FastIO;
        bus_proceed <= '0';
        --wait_states_non_zero <= '0';          
        
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
        
      elsif long_address(19)='0' and long_address(18)='0' then
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
    -- Eventually this should be able to go away and we'll just have the one mux down
    -- below that differenties between the primary bus interfaces.
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
          report "reading colour RAM fastio byte $" & to_hstring(vic_rdata) severity note;
          return unsigned(fastio_colour_ram_rdata);
        when VICIV =>
          report "reading VIC fastio byte $" & to_hstring(vic_rdata) severity note;
          return unsigned(vic_rdata);
        when FastIO =>
          report "reading normal io byte $" & to_hstring(io_rdata) severity note;
          return unsigned(io_rdata);
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

    -- This function is *almost* ready to die.  It's really only handling updating the clocked fastio
    -- signals (and external memory interface signals) at this point.  If I can move the entire fastio
    -- bus to the "next" variant then this can die completeley.
    procedure write_long_byte(
      value              : in std_logic_vector(7 downto 0);
      io_sel_next : in std_logic;
      ext_sel_next : in std_logic) is
      variable long_address : unsigned(19 downto 0);
      variable dmagic_write : std_logic;
    begin
      -- Schedule the memory write to the appropriate destination.

      accessing_slowram <= '0';
      slow_access_write_drive <= '0';
      
      wait_states <= x"00";
      wait_states_non_zero <= '0';

      long_address := unsigned(system_address_next);
      
      -- Always write to shadow ram if in scope, even if we also write elsewhere.
      -- This ensures that shadow ram is consistent with the shadowed address space
      -- when the CPU reads from shadow ram.
      -- system_wdata <= value;
      
      if io_sel_next='0' and ext_sel_next='0' and long_address(19)='0' and long_address(18)='0' then      
        report "writing to chip RAM addr=$" & to_hstring(long_address) severity note;
        --system_address <= system_address_next;

      elsif io_sel_next='1' then
        --fastio_addr <= fastio_addr_next;
        --fastio_write <= '1'; fastio_read <= '0';
        report "raising fastio_write" severity note;
        --fastio_wdata <= std_logic_vector(value);
        
      elsif ext_sel_next='1' then
        report "writing to slow device memory..." severity note;
        accessing_slowram <= '1';

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
        null;
      end if;
    end write_long_byte;
        
    variable memory_access_read : std_logic := '0';
    variable memory_access_write : std_logic := '0';
  begin    

  -- Bus interface state machine update.
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
      monitor_waitstates <= wait_states;
    
                                        -- report "reset = " & std_logic'image(reset) severity note;
      reset_drive <= reset;
      if reset_drive='0' then
        bus_proceed <= '1';
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
            & to_hstring(io_rdata)
            & ", mem_reading=" & std_logic'image(mem_reading)
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
          slow_access_write_drive <= '0';

          if mem_reading='1' then
            mem_reading <= '0';
            monitor_mem_reading <= '0';
          end if;

          bus_proceed <= '1';
        end if;

        report "CPU state : cpu_proceed=" & std_logic'image(cpu_proceed);
        if cpu_proceed='1' then

          -- Temporarily pick up memory access signals from combinatorial code
          -- Note: This is actually still important because I think it's what
          -- prevents us from getting into an infinite loop with the wait state
          -- stuff.  Eventually I want to get rid of that or have the ready signal
          -- come from the I/O device in question.
          memory_access_read := cpu_memory_access_read_next;
          memory_access_write := cpu_memory_access_write_next;

          -- Update clocked signals if CPU is moving forward.
          system_address <= system_address_next;
          system_read <= system_read_next;
          system_write <= system_write_next;
          system_wdata <= system_wdata_next;
        end if;
        
        io_sel_out <= io_sel_next;
        ext_sel_out <= ext_sel_next;

                                        -- Effect memory accesses.
                                        -- Note that we cannot combine address resolution for read and write,
                                        -- because the resolution of some addresses is dependent on whether
                                        -- the operation is read or write.  ROM accesses are a good example.
                                        -- We delay the memory write until the next cycle to minimise logic depth

                                        -- XXX - Try to fast-route low address lines to shadowram and other memory
                                        -- blocks.
        
                                        -- Mark pages dirty as necessary        
        if memory_access_write='1' then

          write_long_byte(std_logic_vector(cpu_memory_access_wdata_next),io_sel_next,ext_sel_next);
        elsif memory_access_read='1' then 
          report "memory_access_read=1, addres=$"&to_hstring(system_address_next) severity note;
          read_long_address(io_sel_next,ext_sel_next);
        end if;
      end if; -- if not reseting
    end if;                         -- if rising edge of clock
  end process;
  
  -- output all monitor values based on current state, not one clock delayed.
  -- TODO - This should just be whatever the system memory address value is.
  monitor_memory_access_address <= unsigned(x"000" & system_address_next(19 downto 0));

  -- alternate (new) combinatorial core memory address generation.
  process (hypervisor_mode,mem_reading,
    viciii_iomode,
    shadow_rdata,bus_proceed,cpu_proceed,
    cpu_memory_access_read_next, cpu_memory_access_write_next, cpu_memory_access_address_next, cpu_memory_access_wdata_next, cpu_memory_access_io_next,
    rom_writeprotect,
    post_resolve_memory_access_address_next,
    system_address_next, read_source, io_sel_next, ext_sel_next
    )
    
    variable system_address_var : std_logic_vector(19 downto 0);
    variable shadow_write_var : std_logic := '0';
    variable io_sel_next_var : std_logic := '0';
    variable ext_sel_next_var : std_logic := '0';
    
    variable kickstart_write_var : std_logic := '0';
    
    variable pre_resolve_addr_var : unsigned(19 downto 0);
    variable kickstart_cs_var : std_logic;
    
  begin
        
    -- Don't do anything by default...
    kickstart_cs_var := '0';    
    shadow_write_var := '0';
    kickstart_write_var := '0';
    charrom_write_cs_next <= '0';
    
    -- These hold current value until we are ready to move on?
    io_sel_next <= io_sel_out;
    ext_sel_next <= ext_sel_out;
    
	  if cpu_memory_access_resolve_address_next = '1' then        
	    system_address_var := post_resolve_memory_access_address_next;
      io_sel_next_var := io_sel_resolved;
      ext_sel_next_var := ext_sel_resolved;
    else
      system_address_var := std_logic_vector(cpu_memory_access_address_next);
      io_sel_next_var := cpu_memory_access_io_next;
      ext_sel_next_var := '0';
    end if;      

    -- Kickstart ROM chip select.  FIXME - kickstart_write_var shouldn't need to be depdendent on
    -- the chip select logic at this level.
    if (hypervisor_mode='1' and system_address_var(19 downto 14)&"00" = x"F8") then
      kickstart_cs_var := '1';
      kickstart_write_var := cpu_memory_access_write_next;
    else
      kickstart_cs_var := '0';
      kickstart_write_var := '0';
    end if;
    
		if cpu_memory_access_write_next='1' then
      
		  if system_address_var(19 downto 17)="001" then
		    report "writing to ROM. addr=$" & to_hstring(system_address_var) severity note;
		    shadow_write_var := not rom_writeprotect;
  		elsif system_address_var(19 downto 17)="000"then
		    report "writing to shadow RAM via chipram shadowing. addr=$" & to_hstring(system_address_var) severity note;
        -- Writes that don't hit I/O go to shadow memory
        if io_sel_next_var='0' then
          shadow_write_var := '1';
        end if;
      end if;
      
      -- @IO:GS $FF7Exxx VIC-IV CHARROM write area
      if system_address_var(19 downto 12) = x"7E" then
        charrom_write_cs_next <= '1';
      end if;
                      
      kickstart_write_var := kickstart_cs_var;
      
    end if;

    -- FIXME - We shouldn't need both of these.  kickstart_cs_next should be
    -- all that's needed if we plumb both through to the kickstart memory module.
    kickstart_write_next <= kickstart_write_var;
    kickstart_cs_next <= kickstart_cs_var;
    
    -- Drive output signals with current state.
    -- FIXME - Come up with a better standardized naming scheme.
    io_sel_next_out <= io_sel_next;
    ext_sel_next_out <= ext_sel_next;
    memory_ready_out <= bus_proceed;
    shadow_write_next <= shadow_write_var;
    io_sel_next <= io_sel_next_var;
    ext_sel_next <= ext_sel_next_var;    
    
    system_address_next <= system_address_var;
    system_write_next <= cpu_memory_access_write_next;
    system_read_next  <= cpu_memory_access_read_next;
    system_wdata_next <= std_logic_vector(cpu_memory_access_wdata_next);
    
    -- Color ram chip select (next)
    colour_ram_cs_next <= '0';
    if system_address_next(19 downto 16) = x"8" then
      colour_ram_cs_next <= '1';
    end if;
    
    -- Additional colour ram write area on C65 from 0x1f800 to 0x1ffff
    -- We only do this for writes because for reads we just get it from shadow.
    if cpu_memory_access_write_next='1' and system_address_next(19 downto 12) = x"1F" and system_address_next(11) = '1' then
      colour_ram_cs_next <= '1';
    end if;
    -- I/O window to color ram.
    if io_sel_next='1' then    --   $DXXX
      -- Colour RAM at $D800-$DBFF and optionally $DC00-$DFFF
      if system_address_next(11)='1' then
        if (system_address_next(10)='0') or (colourram_at_dc00='1') then
          report "D800-DBFF/DC00-DFFF colour ram access from VIC fastio" severity note;
          colour_ram_cs_next <= '1';
        end if;
      end if;
    end if;                         -- $DXXX
    
    -- If reading IO page from $D0{0-7}X, then the access is from
    -- the VIC-IV.
    -- If reading IO page from $D{1,2,3}XX, then the access is from
    -- the VIC-IV.
    -- If reading IO page from $D{8,9,a,b}XX, then the access is from
    -- the VIC-IV.
    -- If reading IO page from $D{c,d,e,f}XX, and colourram_at_dc00='1',
    -- then the access is from the VIC-IV.
    -- If reading IO page from $8XXXX, then the access is from the VIC-IV.
    -- We make the distinction to separate reading of VIC-IV
    -- registers from all other IO registers, partly to work around some bugs,
    -- and partly because the banking of the VIC registers is the fiddliest part.

    vic_cs_next <= '0';
    if io_sel_next='1' then
      if system_address_next(11 downto 10) = "00" then  --   $D{0,1,2,3}XX
        if system_address_next(11 downto 7) /= "00001" then  -- ! $D.0{8-F}X (FDC, RAM EX)
          report "VIC register from VIC fastio" severity note;
          report "Preparing to read from VICIV";
          vic_cs_next <= '1';
        end if;            
      end if;
    end if;                           -- $DXXX
    
  end process;

  -- read_data input mux
  -- This controls which data is being fed into the CPU (and/or eventually DMAgic) at any given
  -- time.  Because the internal FPGA interfaces are in general clocked instead of asynchronous,
  -- the mux will switch one clock cycle after the address has been driven onto the bus and will
  -- be held until the read finishes.
  process (read_source, shadow_rdata, read_data_copy)
  begin
    if(read_source = Shadow) then
      cpu_memory_read_data <= unsigned(shadow_rdata);
    elsif(read_source = Kickstart) then
      cpu_memory_read_data <= unsigned(kickstart_rdata);
    elsif(read_source = ColourRAM) then
      cpu_memory_read_data <= unsigned(fastio_colour_ram_rdata);
    elsif(read_source = VICIV) then
      cpu_memory_read_data <= unsigned(vic_rdata);
    elsif(read_source = FastIO) then
      cpu_memory_read_data <= unsigned(io_rdata);
    else
      cpu_memory_read_data <= slow_access_rdata;
    end if;  
  end process;
  
end Behavioural;

