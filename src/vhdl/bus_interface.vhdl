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
    ext_sel_resolved <= map_ext;
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
    system_address : inout std_logic_vector(19 downto 0);
    system_wdata : out  std_logic_vector(7 downto 0)  := (others => '0');
    system_write : out std_logic;
    system_read : out std_logic;
    
    shadow_write_next : out std_logic := '0';
    shadow_rdata : in std_logic_vector(7 downto 0)  := (others => '0');

    kickstart_cs_next : inout std_logic := '0';
    kickstart_rdata : in std_logic_vector(7 downto 0)  := (others => '0');
        
    cpu_leds : out std_logic_vector(3 downto 0);
    
    ---------------------------------------------------------------------------
    -- fast IO port (clocked at core clock). 1MB address space
    ---------------------------------------------------------------------------
    io_rdata : in std_logic_vector(7 downto 0);
    io_sel_next : inout std_logic := '0';
    io_sel : inout std_logic := '0';
    ext_sel_next : inout std_logic := '0';
    ext_sel : out std_logic := '0';
    
    sector_buffer_mapped : in std_logic;
    vic_rdata : in std_logic_vector(7 downto 0);
    colour_ram_data : in std_logic_vector(7 downto 0);

    colour_ram_cs_next : inout std_logic := '0';
    charrom_write_cs_next : out std_logic := '0';
    vic_cs_next : inout std_logic := '0';
    vic_cs : inout std_logic := '0';
    
    ---------------------------------------------------------------------------
    -- Slow device access 4GB address space
    ---------------------------------------------------------------------------
    slow_access_rdata : in unsigned(7 downto 0);
    slow_access_ready : in std_logic := '0';
    
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
    --attribute mark_debug of ext_sel_next: signal is "true";
    --attribute mark_debug of io_sel_next: signal is "true";
    --attribute mark_debug of ext_sel: signal is "true";
    --attribute mark_debug of io_sel: signal is "true";
    --
    --attribute mark_debug of  system_wdata_next: signal is "true";
    --
    --attribute mark_debug of kickstart_rdata: signal is "true";
    --attribute mark_debug of kickstart_cs_next: signal is "true";
    --
    --attribute mark_debug of system_address_next: signal is "true";
    --attribute mark_debug of system_read_next: signal is "true";
    --attribute mark_debug of system_write_next: signal is "true";
    --attribute mark_debug of system_wdata_next: signal is "true";
    --
    --attribute mark_debug of system_address: signal is "true";
    --attribute mark_debug of system_read: signal is "true";
    --attribute mark_debug of system_write: signal is "true";
    --attribute mark_debug of system_wdata: signal is "true";
    
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
    --attribute mark_debug of vic_cs_next : signal is "true";
    --attribute mark_debug of vic_cs : signal is "true";
    --attribute mark_debug of viciii_iomode : signal is "true";
    
    --
    --attribute mark_debug of cpu_memory_access_wdata_next : signal is "true";
    --attribute mark_debug of io_sel_next : signal is "true";
    --attribute mark_debug of io_sel : signal is "true";
    --attribute mark_debug of io_rdata : signal is "true";
    --attribute mark_debug of memory_ready_out : signal is "true";
    --attribute mark_debug of vic_cs_next : signal is "true";
    --attribute mark_debug of colour_ram_cs_next : signal is "true";
    --attribute mark_debug of charrom_write_cs_next : signal is "true";
    
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

  signal io_sel_resolved : std_logic;
  signal ext_sel_resolved : std_logic;
  
  -- IO has one waitstate for reading, 0 for writing
  -- XXX An extra wait state seems to be necessary when reading from dual-port
  -- memories like colour ram.
  constant ioread_48mhz : unsigned(7 downto 0) := x"01";
  constant colourread_48mhz : unsigned(7 downto 0) := x"02";
  constant iowrite_48mhz : unsigned(7 downto 0) := x"00";
  constant shadow_48mhz :  unsigned(7 downto 0) := x"00";

  -- Most of these are really just constants and are here to made things appear
  -- consistent.
  signal shadow_ready : std_logic := '1';
  signal kickstart_ready : std_logic := '1';
  signal colour_ram_ready : std_logic := '1';
  signal vic_ready : std_logic := '1';
  signal cpu_internal_ready : std_logic := '1';
  signal io_ready : std_logic := '0';
  
  -- Number of pending wait states
  signal wait_states : unsigned(7 downto 0) := x"00"; -- This will now be a counter.
  signal wait_states_next : unsigned(7 downto 0); -- This will now be a counter.
  signal slow_access_ready_internal : std_logic;
  
-- Note that ROM is actually implemented using
-- power-on initialised RAM in the FPGA mapped via our io interface.
  
  signal monitor_mem_trace_toggle_last : std_logic := '0';

  -- Microcode data and ALU routing signals follow:

  -- Is CPU free to proceed with processing an instruction?
  signal bus_ready : std_logic := '1';

  type bus_device_type is (
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

  signal bus_device : bus_device_type;
    
  signal post_resolve_memory_access_address_next : std_logic_vector(19 downto 0);
  
  --attribute mark_debug of bus_device: signal is "true";
  --
  --attribute mark_debug of post_resolve_memory_access_address_next: signal is "true";
  --
  --attribute mark_debug of system_wdata: signal is "true";
  --attribute mark_debug of system_address_next: signal is "true";
  --attribute mark_debug of system_address: signal is "true";
  --
  --attribute mark_debug of bus_proceed: signal is "true";
  --attribute mark_debug of wait_states: signal is "true";
    
  --attribute mark_debug of colour_ram_cs : signal is "true";
  --attribute mark_debug of colourram_at_dc00 : signal is "true";
  --attribute mark_debug of sector_buffer_mapped : signal is "true";
  --attribute mark_debug of kickstart_cs_next : signal is "true";
  --attribute mark_debug of colour_ram_cs_next : signal is "true";
  --attribute mark_debug of bus_device : signal is "true";
  --attribute mark_debug of wait_states : signal is "true";
  --attribute mark_debug of wait_states_next : signal is "true";
  --attribute mark_debug of io_ready : signal is "true";
  --attribute mark_debug of cpu_internal_ready : signal is "true";
  
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

      wait_states <= (others => '0');
      bus_ready <= '1';
      bus_device <= Shadow;
      slow_access_ready_internal <= '0';
      
    end procedure reset_cpu_state;

    procedure bus_access(
      io_sel_next : in std_logic;
      ext_sel_next : in std_logic) is
      variable long_address : unsigned(19 downto 0);
    begin

      -- Stop writing when reading.     

      long_address := unsigned(system_address_next);
      
      report "Reading from long address $" & to_hstring(long_address) severity note;
      
      -- Schedule the memory read from the appropriate source.

      report "MEMORY long_address = $" & to_hstring(long_address);
      -- @IO:C64 $0000000 6510/45GS10 CPU port DDR
      -- @IO:C64 $0000001 6510/45GS10 CPU port data
      if io_sel_next='1' and long_address(11 downto 6)&"00" = x"64" and hypervisor_mode='1' then
        report "Preparing for reading hypervisor register";
        bus_device <= HypervisorRegister;
      elsif (long_address = x"00000") or (long_address = x"00001") then
        report "Preparing to read from a CPUPort";
        bus_device <= CPUPort;
      elsif (io_sel_next='1' and long_address = x"0d0a0") then
        report "Preparing to read from CPU memory expansion controller port";
        bus_device <= CPUPort;
        -- @IO:GS $F8000-$FBFFF 16KB Kickstart/Hypervisor ROM
      elsif kickstart_cs_next='1' then
        bus_device <= Kickstart;
      elsif colour_ram_cs_next='1' then
        bus_device <= ColourRAM;
      elsif vic_cs_next='1' then
        bus_device <= VICIV;
      elsif io_sel_next='1' then
        report "Preparing to read from FastIO";
        bus_device <= FastIO;        
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
        bus_device <= Shadow;
          report "Reading from shadowed chipram address $"
          & to_hstring(long_address(19 downto 0)) severity note;
                                        --Also mapped to 7F2 0000 - 7F3 FFFF
      elsif ext_sel_next='1' then
        -- @IO:GS $4000000 - $7FFFFFF Slow Device memory (64MB)
        -- @IO:GS $8000000 - $FEFFFFF Slow Device memory (127MB)
        report "Preparing to read from SlowRAM";
        bus_device <= SlowRAM;
      else
        -- Don't let unmapped memory jam things up
        report "hit unmapped memory -- clearing wait_states" severity note;
        report "Preparing to read from Unmapped";
        bus_device <= Unmapped;
      end if;
      if (viciii_iomode="01" or viciii_iomode="11") and (long_address(19 downto 8) = x"0D7") then
        report "Preparing to read from a DMAgicRegister";
        bus_device <= DMAgicRegister;
      end if;      

    end bus_access;
            
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
      
      -- Update wait states for monitor output and maybe bus timeout detection.
      wait_states <= wait_states_next;
      
      -- Keep a clocked slow access ready to help with timing.  The one extra 50Mhz
      -- cycle of delay to recognize external 1Mhz devices won't hurt anything.
      if(slow_access_ready='1' or wait_states_next >= x"f0") then
        slow_access_ready_internal <= '1';
      else
        slow_access_ready_internal <= '0';
      end if;
      
      monitor_waitstates <= wait_states;
    
      -- CPU ready signal generation.  Basially there's just a one clock delay any time
      -- the CPU address changes.
      -- Currently the same for I/O accesses, so don't duplicate the logic.
      -- Note: This is done as a clocked thing so it takes effect on the following cycle,
      -- which is what we want.  It also looks backwards because it's easier for me to
      -- consider the case where the next address is different from the already clocked one, 
      -- which happens when the CPU is ready to move.  So when they are different, it means
      -- we'll need to wait one cycle (after the next clock edge).  Also, doing it clocked
      -- means we don't have a combinatorial loop.
      if system_address_next /= system_address and system_write_next='0' then
        cpu_internal_ready <= '0';
        io_ready <= '0';
      else
        cpu_internal_ready <= '1';
        io_ready <= '1';
      end if;
    
                                        -- report "reset = " & std_logic'image(reset) severity note;
      reset_drive <= reset;
      if reset_drive='0' then
        wait_states <= x"00";
      else

        report "CPU state : cpu_proceed=" & std_logic'image(cpu_proceed);
        if cpu_proceed='1' then

          -- Update clocked signals if CPU is moving forward.
          system_address <= system_address_next;
          system_read <= system_read_next;
          system_write <= system_write_next;
          system_wdata <= system_wdata_next;
          io_sel <= io_sel_next;
          ext_sel <= ext_sel_next;
          vic_cs <= vic_cs_next;
          
          bus_access(io_sel_next,ext_sel_next);

        end if;
        
      end if; -- if not reseting
    end if;                         -- if rising edge of clock
  end process;
  
  -- output all monitor values based on current state, not one clock delayed.
  -- TODO - This should just be whatever the system memory address value is.
  monitor_memory_access_address <= unsigned(x"000" & system_address_next(19 downto 0));

  -- alternate (new) combinatorial core memory address generation.
  process (hypervisor_mode,
    viciii_iomode,
    shadow_rdata,cpu_proceed,
    cpu_memory_access_read_next, cpu_memory_access_write_next, cpu_memory_access_address_next, cpu_memory_access_wdata_next, cpu_memory_access_io_next,
    rom_writeprotect,
    post_resolve_memory_access_address_next,
    system_address_next, system_address, bus_device, io_sel_next, ext_sel_next
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
    
	  if cpu_memory_access_resolve_address_next = '1' then        
	    system_address_var := post_resolve_memory_access_address_next;
      io_sel_next_var := io_sel_resolved;
      ext_sel_next_var := ext_sel_resolved;
    else
      system_address_var := std_logic_vector(cpu_memory_access_address_next);
      io_sel_next_var := cpu_memory_access_io_next;
      ext_sel_next_var := '0';
    end if;      

    -- Kickstart ROM chip select.
    if (hypervisor_mode='1' and system_address_var(19 downto 14)&"00" = x"F8") then
      kickstart_cs_var := '1';
    else
      kickstart_cs_var := '0';
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
                            
    end if;

    kickstart_cs_next <= kickstart_cs_var;
    
    -- Drive output signals with current state.
    -- FIXME - Come up with a better standardized naming scheme.
    io_sel_next <= io_sel_next_var;
    ext_sel_next <= ext_sel_next_var;    
    memory_ready_out <= bus_ready;
    shadow_write_next <= shadow_write_var;
    
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
    
    if bus_ready='1' then
      wait_states_next <= x"00";
    else
      wait_states_next <= wait_states + 1;
    end if;
    
  end process;

  -- read_data (and ready) input mux
  -- This controls which data is being fed into the CPU (and/or eventually DMAgic) at any given
  -- time.  Because the internal FPGA interfaces are in general clocked instead of asynchronous,
  -- the mux will switch one clock cycle after the address has been driven onto the bus and will
  -- be held until the read finishes. The mux also controls where we source the "ready" signal from.
  process (bus_device, shadow_rdata, shadow_ready, kickstart_rdata, kickstart_ready,
           colour_ram_data, colour_ram_ready, vic_rdata, vic_ready, io_rdata, io_ready,
           slow_access_rdata, slow_access_ready_internal)
  begin
    if(bus_device = Shadow) then
      cpu_memory_read_data <= unsigned(shadow_rdata);
      bus_ready <= shadow_ready;
    elsif(bus_device = Kickstart) then
      cpu_memory_read_data <= unsigned(kickstart_rdata);
      bus_ready <= kickstart_ready;
    elsif(bus_device = ColourRAM) then
      cpu_memory_read_data <= unsigned(colour_ram_data);
      bus_ready <= colour_ram_ready;
    elsif(bus_device = VICIV) then
      cpu_memory_read_data <= unsigned(vic_rdata);
      bus_ready <= io_ready;  -- This is now using same wait states as other I/O
    elsif(bus_device = FastIO) then
      cpu_memory_read_data <= unsigned(io_rdata);
      bus_ready <= io_ready;
    elsif bus_device = CPUPort or bus_device=HypervisorRegister or bus_device=DMAgicRegister then
      cpu_memory_read_data <= x"55";
      bus_ready <= cpu_internal_ready; -- TODO - This is temporary until we update internal CPU logic to do this for itself.
    elsif bus_device = Unmapped then
      cpu_memory_read_data <= x"AA";
      bus_ready <= '1';
    else
      cpu_memory_read_data <= slow_access_rdata;
      bus_ready <= slow_access_ready_internal;
    end if;
  end process;
    
end Behavioural;

