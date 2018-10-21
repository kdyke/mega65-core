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

entity bus_arbiter is
  port (
    Clock : in std_logic;
    reset : in std_logic;

    -- Incoming signals from the CPU current bus master.
    cpu_memory_access_address_next : in std_logic_vector(19 downto 0);
    cpu_memory_access_read_next : in std_logic;
    cpu_memory_access_write_next : in std_logic;
    cpu_memory_access_wdata_next : in unsigned(7 downto 0);
    cpu_memory_access_io_next : in std_logic;
    cpu_memory_access_ext_next : in std_logic;
    cpu_ack : in std_logic;
    cpu_read_data : out unsigned(7 downto 0);
    cpu_ready : out std_logic;
    
    -- DMAgic bus interface signals
    dmagic_memory_access_address_next : in std_logic_vector(19 downto 0);
    dmagic_memory_access_read_next : in std_logic;
    dmagic_memory_access_write_next : in std_logic;
    dmagic_memory_access_wdata_next : in unsigned(7 downto 0);
    dmagic_memory_access_io_next : in std_logic;
    dmagic_memory_access_ext_next : in std_logic;
    dmagic_ack : in std_logic;
    dmagic_read_data : out unsigned(7 downto 0);
    dmagic_ready : out std_logic;
    dmagic_dma_req : in std_logic;
    dmagic_cpu_req : in std_logic;
    
    -- Interface signals to/from system bus interface
    bus_memory_access_address_next : out std_logic_vector(19 downto 0);
    bus_memory_access_read_next : out std_logic;
    bus_memory_access_write_next : out std_logic;
    bus_memory_access_wdata_next : out unsigned(7 downto 0);
    bus_memory_access_io_next : out std_logic;
    bus_memory_access_ext_next : out std_logic;
    bus_ack : out std_logic;
    bus_read_data : in unsigned(7 downto 0);
    bus_ready : in std_logic
        
    );
    
    attribute keep_hierarchy : string;
    attribute mark_debug : string;
    attribute dont_touch : string;
    attribute keep : string;
    
    --
    --attribute mark_debug of bus_memory_access_address_next: signal is "true";
    --attribute mark_debug of bus_memory_access_io_next: signal is "true";
    --attribute mark_debug of bus_ack: signal is "true";
    --attribute mark_debug of bus_read_data: signal is "true";
    --attribute mark_debug of bus_ready: signal is "true";
    --
    --attribute mark_debug of cpu_ack: signal is "true";
    --attribute mark_debug of cpu_ready: signal is "true";
    --attribute mark_debug of cpu_read_data: signal is "true";
    --attribute mark_debug of cpu_memory_access_address_next: signal is "true";
    --attribute mark_debug of cpu_memory_access_read_next: signal is "true";
    --attribute mark_debug of cpu_memory_access_io_next: signal is "true";
    --
    --attribute mark_debug of dmagic_ack: signal is "true";
    --attribute mark_debug of dmagic_memory_access_address_next: signal is "true";
    --attribute mark_debug of dmagic_ready: signal is "true";
    --attribute mark_debug of dmagic_read_data: signal is "true";
        
end entity bus_arbiter;

architecture Behavioural of bus_arbiter is
  
  --attribute keep_hierarchy of Behavioural : architecture is "yes";
  
  type bus_master_type is (
    CPU,
    DMAgic
    );

  -- bus_master_next always controls who is driving the signals going into the bus interface    
  signal bus_master_next : bus_master_type;
  -- bus_master controls which device is connected to the signals coming back from the bus interface,
  -- and who is driving the ACK signal from the CPU/DMAgic side.
  signal bus_master : bus_master_type;
  --
  
  --attribute mark_debug of bus_master_next: signal is "true";
  --attribute mark_debug of bus_master: signal is "true";
  
begin
  
  process(clock,reset)
           
  begin    

  -- Bus interface state machine update.
    if rising_edge(clock) then
      
      bus_master <= bus_master_next;
      
    end if;                         -- if rising edge of clock
  end process;

  -- This is the bus_interface to bus_master "mux".  Note: Because this controls the signals
  -- that provide the data (and ready signal) to the bus master, we also need to have the 
  -- ack signal routed from that bust master back to the bus interface so it knows who to
  -- listen to for who's accepting the data so the bus interface can accept the next bus
  -- master's address.
  process(bus_master, bus_read_data, bus_ready)
  begin
    if bus_master=CPU then
      cpu_ready         <= bus_ready;
      cpu_read_data     <= bus_read_data;
      dmagic_ready      <= '0';
      dmagic_read_data  <= x"FF";
      -- A note on this.  When dmagic is performing a memory access on behalf of the CPU, 
      -- the bus interface would normally need to wait one more clock before the bus master
      -- signal would switch to dmagic's ack signal.  This would cause a single cycle bubble
      -- even though the address signals were already driving dmagic signals below.  There's
      -- no point delaying the ack because the CPU is already waiting.   So, I treat dmagic_cpu_req
      -- as another way to force ACK to true to eliminate the bubble.
      bus_ack           <= cpu_ack or dmagic_cpu_req;
    else
      cpu_ready         <= '0';
      cpu_read_data     <= x"FF";
      dmagic_ready      <= bus_ready;
      dmagic_read_data  <= bus_read_data;
      bus_ack           <= dmagic_ack;
    end if;
  end process;
  
  -- This is the mux that controls the signals being driven to the bus interface, controlled
  -- by the state of bus_master_next
  process(bus_master_next, 
          cpu_memory_access_address_next,
          cpu_memory_access_read_next,
          cpu_memory_access_write_next,
          cpu_memory_access_wdata_next,
          cpu_memory_access_io_next,
          cpu_memory_access_ext_next,
          dmagic_memory_access_address_next,
          dmagic_memory_access_read_next,
          dmagic_memory_access_write_next,
          dmagic_memory_access_wdata_next,
          dmagic_memory_access_io_next,
          dmagic_memory_access_ext_next,
          dmagic_ack)
  begin
    if bus_master_next=CPU then
      bus_memory_access_address_next <= cpu_memory_access_address_next;
      bus_memory_access_read_next    <= cpu_memory_access_read_next;
      bus_memory_access_write_next   <= cpu_memory_access_write_next;
      bus_memory_access_wdata_next   <= cpu_memory_access_wdata_next;
      bus_memory_access_io_next      <= cpu_memory_access_io_next;
      bus_memory_access_ext_next     <= cpu_memory_access_ext_next;
    else
      bus_memory_access_address_next <= dmagic_memory_access_address_next;
      bus_memory_access_read_next    <= dmagic_memory_access_read_next;
      bus_memory_access_write_next   <= dmagic_memory_access_write_next;
      bus_memory_access_wdata_next   <= dmagic_memory_access_wdata_next;
      bus_memory_access_io_next      <= dmagic_memory_access_io_next;
      bus_memory_access_ext_next     <= dmagic_memory_access_ext_next;
    end if;
  end process;         
  
  -- This is the actual arbitration logic that controls who is going to get the bus next.  
  process(bus_master, cpu_ack, dmagic_ack, dmagic_dma_req, dmagic_cpu_req)
  begin
    -- Default is to stick with what we have
    bus_master_next <= bus_master;
    
    -- If DMAgic has the bus bus no longer needs it then we just give it back to the CPU.
    if bus_master=DMAgic then
      if dmagic_ack='1' and dmagic_dma_req='0' and dmagic_cpu_req='0' then
        bus_master_next <= CPU;
      end if;
    else -- The current bus master is the CPU, but DMAgic wants it.
      if dmagic_cpu_req='1' then -- Special DMA cycle performed by DMAgic on behalf of CPU (i.e. flat 20-bit access via PIO)
        bus_master_next <= DMAgic;
      elsif cpu_ack='1' and dmagic_dma_req='1' then     -- CPU is finished w/bus cycle and DMAgic is asking for the bus
        bus_master_next <= DMAgic;
      end if;
    end if;
  end process;
      
end Behavioural;

