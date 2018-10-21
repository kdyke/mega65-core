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

entity bus_interface is
  port (
    Clock : in std_logic;
    reset : in std_logic;

    hypervisor_mode : in std_logic := '0';

    monitor_waitstates : out unsigned(7 downto 0);
    monitor_memory_access_address : out unsigned(31 downto 0);

    -- Incoming signals from the current bus master.  Only valid when ready is true.
    memory_access_address_next : in std_logic_vector(19 downto 0);
    memory_access_read_next : in std_logic;
    memory_access_write_next : in std_logic;
    memory_access_wdata_next : in unsigned(7 downto 0);
    memory_access_io_next : in std_logic;
    memory_access_ext_next : in std_logic;
    ack : in std_logic;
    
    bus_read_data : out unsigned(7 downto 0);
    bus_ready : inout std_logic;
    
    rom_writeprotect : in std_logic;
    
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
    vic_ready : in std_logic;
    
    colour_ram_data : in std_logic_vector(7 downto 0);
    colour_ram_ready : in std_logic;
    
    colour_ram_cs_next : inout std_logic := '0';
    charrom_write_cs_next : out std_logic := '0';
    vic_cs_next : inout std_logic := '0';
    vic_cs : inout std_logic := '0';
    
    -- For new DMAgic implementation
    dmagic_cs_next : inout std_logic;
    dmagic_cs : inout std_logic;
    dmagic_rdata : in std_logic_vector(7 downto 0);
    dmagic_io_ready : in std_logic;
    
    ---------------------------------------------------------------------------
    -- Slow device access 4GB address space
    ---------------------------------------------------------------------------
    slow_access_rdata : in unsigned(7 downto 0);
    slow_access_ready : in std_logic := '0';
    
    ---------------------------------------------------------------------------
    -- VIC-III memory banking control
    ---------------------------------------------------------------------------
    viciii_iomode : in std_logic_vector(1 downto 0);

    colourram_at_dc00 : in std_logic

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
    --
    --attribute mark_debug of shadow_write_next: signal is "true";
    --attribute mark_debug of shadow_rdata: signal is "true";
    --
    --attribute mark_debug of reset: signal is "true";
    --attribute keep of bus_read_data : signal is "true";
    --attribute dont_touch of bus_read_data : signal is "true";
    --attribute mark_debug of bus_read_data : signal is "true";
    --attribute mark_debug of bus_ready : signal is "true";
    --attribute mark_debug of ack : signal is "true";
    --attribute mark_debug of dmagic_cs_next : signal is "true";
    --attribute mark_debug of colourram_at_dc00 : signal is "true";
    --attribute mark_debug of sector_buffer_mapped : signal is "true";
    --
    --attribute mark_debug of vic_rdata : signal is "true";
    --attribute mark_debug of vic_ready : signal is "true";
    --attribute mark_debug of vic_cs_next : signal is "true";
    --attribute mark_debug of vic_cs : signal is "true";
    --attribute mark_debug of viciii_iomode : signal is "true";
    --
    --
    --attribute mark_debug of memory_access_wdata_next : signal is "true";
    --attribute mark_debug of io_sel_next : signal is "true";
    --attribute mark_debug of io_sel : signal is "true";
    --attribute mark_debug of io_rdata : signal is "true";
    --attribute mark_debug of vic_cs_next : signal is "true";
    --attribute mark_debug of colour_ram_cs_next : signal is "true";
    --attribute mark_debug of charrom_write_cs_next : signal is "true";
    
end entity bus_interface;

architecture Behavioural of bus_interface is
  
  --attribute keep_hierarchy of Behavioural : architecture is "yes";
  
  signal reset_drive : std_logic := '0';

  -- Shadow RAM control

  signal shadow_try_write_count : unsigned(7 downto 0) := x"00";
  signal shadow_observed_write_count : unsigned(7 downto 0) := x"00";

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
    DMAgicNew,              -- 0x09
    Unmapped                -- 0x0A
    );

  signal bus_device : bus_device_type;
      
  --attribute mark_debug of bus_device: signal is "true";
  --
  --attribute mark_debug of cpu_resolved_memory_access_address_next: signal is "true";
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
  
  process(clock,reset)

    procedure reset_bus_state is
    begin

      wait_states <= (others => '0');
      --bus_ready <= '1';
      bus_device <= Unmapped;
      slow_access_ready_internal <= '0';
      
    end procedure reset_bus_state;

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
      elsif dmagic_cs_next='1' then
        bus_device <= DMAgicNew;
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
      
      if io_sel_next='1' and (viciii_iomode="01" or viciii_iomode="11") and 
        (long_address(19 downto 4) = x"0D7F") then
        report "Preparing to read from a DMAgicRegister";
        bus_device <= DMAgicRegister;
      end if;      

    end bus_access;
            
  begin    

  -- Bus interface state machine update.
    if rising_edge(clock) then
      
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
        reset_bus_state;
        wait_states <= x"00";
      else

        report "CPU state : ack=" & std_logic'image(ack);
        if ack='1' then

          -- Update clocked signals if bus master is moving forward and begin bus access cycle
          system_address <= system_address_next;
          system_read <= system_read_next;
          system_write <= system_write_next;
          system_wdata <= system_wdata_next;
          io_sel <= io_sel_next;
          ext_sel <= ext_sel_next;
          vic_cs <= vic_cs_next;
          dmagic_cs <= dmagic_cs_next;
          
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
    shadow_rdata,ack,
    memory_access_read_next, memory_access_write_next, memory_access_address_next, memory_access_wdata_next, memory_access_io_next,
    memory_access_ext_next,
    rom_writeprotect,
    system_address_next, system_address, bus_device, io_sel_next, ext_sel_next
    )
    
    variable system_address_var : std_logic_vector(19 downto 0);
    variable shadow_write_var : std_logic := '0';
    variable io_sel_next_var : std_logic := '0';
    variable ext_sel_next_var : std_logic := '0';
    
    variable kickstart_write_var : std_logic := '0';
    
    variable pre_resolve_addr_var : unsigned(19 downto 0);
    variable kickstart_cs_var : std_logic;
    variable memory_access_write_var : std_logic;
    
  begin
        
    -- Don't do anything by default...
    kickstart_cs_var := '0';    
    shadow_write_var := '0';
    kickstart_write_var := '0';
    charrom_write_cs_next <= '0';
    memory_access_write_var := '0';
    
    system_address_var := memory_access_address_next;
    io_sel_next_var := memory_access_io_next;
    ext_sel_next_var := memory_access_ext_next;
    memory_access_write_var := memory_access_write_next;
    
    -- Kickstart ROM chip select.
    if (hypervisor_mode='1' and system_address_var(19 downto 14)&"00" = x"F8") then
      kickstart_cs_var := '1';
    else
      kickstart_cs_var := '0';
    end if;
    
		if memory_access_write_next='1' then
      
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
    shadow_write_next <= shadow_write_var;
    
    system_address_next <= system_address_var;
    system_write_next <= memory_access_write_next;
    system_read_next  <= memory_access_read_next;
    system_wdata_next <= std_logic_vector(memory_access_wdata_next);
    
    -- Color ram chip select (next)
    colour_ram_cs_next <= '0';
    if system_address_next(19 downto 16) = x"8" then
      colour_ram_cs_next <= '1';
    end if;
    
    -- Additional colour ram write area on C65 from 0x1f800 to 0x1ffff
    -- We only do this for writes because for reads we just get it from shadow.
    if memory_access_write_next='1' and system_address_next(19 downto 12) = x"1F" and system_address_next(11) = '1' then
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

    dmagic_cs_next <= '0';
    if io_sel_next='1' and viciii_iomode(0)='1' then
      if system_address_next(11 downto 4) = x"71" or 
         system_address_next(11 downto 4) = x"70" then
        dmagic_cs_next <= '1';
      end if;
    end if;
      
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
      bus_read_data <= unsigned(shadow_rdata);
      bus_ready <= shadow_ready;
    elsif(bus_device = Kickstart) then
      bus_read_data <= unsigned(kickstart_rdata);
      bus_ready <= kickstart_ready;
    elsif(bus_device = ColourRAM) then
      bus_read_data <= unsigned(colour_ram_data);
      bus_ready <= colour_ram_ready;
    elsif(bus_device = VICIV) then
      bus_read_data <= unsigned(vic_rdata);
      bus_ready <= vic_ready;
    elsif(bus_device = FastIO) then
      bus_read_data <= unsigned(io_rdata);
      bus_ready <= io_ready;
    elsif bus_device = CPUPort then
      bus_read_data <= x"55";           --cpuport_data;
      bus_ready <= cpu_internal_ready;  --cpuport_ready;
    elsif bus_device=HypervisorRegister then
      bus_read_data <= x"55";
      bus_ready <= cpu_internal_ready; -- TODO - This is temporary until we update internal CPU logic to do this for itself.
    elsif bus_device = DMAgicNew then
      bus_read_data <= unsigned(dmagic_rdata);
      bus_ready <= dmagic_io_ready;
    elsif bus_device = Unmapped then
      bus_read_data <= x"AA";
      bus_ready <= '1';
    else
      bus_read_data <= slow_access_rdata;
      bus_ready <= slow_access_ready_internal;
    end if;
  end process;
    
end Behavioural;

