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

entity dmagic is
  port (
    Clock : in std_logic;
    reset : in std_logic;

    -- DMAgic (system) bus interface signals
    memory_access_address_next : out std_logic_vector(19 downto 0) := x"00000";
    memory_access_read_next : out std_logic := '0';
    memory_access_write_next : out std_logic := '0';
    memory_access_wdata_next : out unsigned(7 downto 0) := x"00";
    memory_access_io_next : out std_logic := '0';
    memory_access_ext_next : out std_logic := '0';
    ack : out std_logic := '0';
    bus_ready : in std_logic;
    read_data : in unsigned(7 downto 0);
    dma_req : out std_logic := '0';
    cpu_req : out std_logic := '0';

    -- These are the bus signals connected to the I/O device bus, used
    -- for register accesses.
    io_address_next : in std_logic_vector(7 downto 0);
    io_cs : in std_logic;
    io_read_next : in std_logic;
    io_write_next : in std_logic;
    io_wdata_next : in std_logic_vector(7 downto 0);
    io_data : out std_logic_vector(7 downto 0);
    io_ready : out std_logic

    );
    
    attribute keep_hierarchy : string;
    attribute mark_debug : string;
    attribute dont_touch : string;
    attribute keep : string;
    
    --attribute mark_debug of memory_access_address_next: signal is "true";
    --attribute mark_debug of memory_access_read_next: signal is "true";
    --attribute mark_debug of memory_access_write_next: signal is "true";
    --attribute mark_debug of memory_access_wdata_next: signal is "true";
    --attribute mark_debug of memory_access_io_next: signal is "true";
    --attribute mark_debug of memory_access_ext_next: signal is "true";
    --attribute mark_debug of ack: signal is "true";
    --attribute mark_debug of bus_ready: signal is "true";
    --attribute mark_debug of read_data: signal is "true";
    --attribute mark_debug of dma_req: signal is "true";
    --attribute mark_debug of cpu_req: signal is "true";
    --
    --attribute mark_debug of io_address_next: signal is "true";
    --attribute mark_debug of io_cs: signal is "true";
    --attribute mark_debug of io_read_next: signal is "true";
    --attribute mark_debug of io_write_next: signal is "true";
    --attribute mark_debug of io_wdata_next: signal is "true";
    --attribute mark_debug of io_data: signal is "true";
    --attribute mark_debug of io_ready: signal is "true";
    
end entity dmagic;

architecture Behavioural of dmagic is
  
  attribute keep_hierarchy of Behavioural : architecture is "yes";
  
  -- Microcode data and ALU routing signals follow:

  type dmagic_state_type is (
    DMAgic_Idle,
    DMAgic_CPUAccessRead,
    DMAgic_CPUAccessReadData,
    DMAgic_CPUAccessWrite,
    DMAgic_CPUAccessAck
    );

  signal dmagic_state : dmagic_state_type;
  signal dmagic_state_next : dmagic_state_type;
  
  -- Our PIO address
  signal dmagic_pio_addr : unsigned(19 downto 0);
  
  --attribute mark_debug of dmagic_state : signal is "true";
  --attribute mark_debug of dmagic_state_next : signal is "true";
    
begin
  
  process(clock,reset)
  
  -- This entire implementation is horrible and needs to be redone with both a combinatorial and
  -- clocked section.   There isnt enough control over the signals with it being purely clocked to respond
  -- to the different clock signals as it should be able to.   Right now it's basiclly impossible for
  -- DMAgic and the CPU to use alternate bus cycles properly.
  begin    

  -- DMAgic state machine
    if rising_edge(clock) then
      
      if reset='0' then
        dmagic_state <= DMAgic_Idle;
        dma_req   <= '0';
        cpu_req   <= '0';
        
      else
        --dmagic_state <= dmagic_state_next;
      
        if io_cs='1' and io_read_next='1' then
          if io_address_next=x"10" then
            io_data <= std_logic_vector(dmagic_pio_addr(7 downto 0));
            io_ready <= '1';
          elsif io_address_next=x"11" then
            io_data <= std_logic_vector(dmagic_pio_addr(15 downto 8));
            io_ready <= '1';
          elsif io_address_next=x"12" then
            io_data(3 downto 0) <= std_logic_vector(dmagic_pio_addr(19 downto 16));
            io_data(7 downto 4) <= x"0";
            io_ready <= '1';
          end if;
        end if;
        
        if io_cs='1' and io_write_next='1' then
          if io_address_next=x"10" then
            dmagic_pio_addr(7 downto 0) <= unsigned(io_wdata_next(7 downto 0));
            io_ready <= '1';
          elsif io_address_next=x"11" then
            dmagic_pio_addr(15 downto 8) <= unsigned(io_wdata_next(7 downto 0));
            io_ready <= '1';
          elsif io_address_next=x"12" then
            dmagic_pio_addr(19 downto 16) <= unsigned(io_wdata_next(3 downto 0));
            io_ready <= '1';
          end if;
        end if;
        
        -- Quick and dirty hack
        case dmagic_state is
          when DMAgic_Idle =>
            if io_cs='1' and (io_address_next=x"14" or io_address_next=x"15") then
              io_ready <= '0';
              memory_access_address_next <= std_logic_vector(dmagic_pio_addr);
              memory_access_write_next <= io_write_next;
              memory_access_wdata_next <= unsigned(io_wdata_next);
              cpu_req <= '1';
              ack <= '1';
              if io_write_next='1' then
                dmagic_state <= DMAgic_CPUAccessWrite;
              else
                dmagic_state <= DMAgic_CPUAccessRead;
              end if;
              if io_address_next(0)='1' then              -- Optional auto-increment of pio address
                dmagic_pio_addr <= dmagic_pio_addr + 1;
              end if;
            end if;
          when DMAgic_CPUAccessRead =>
            if bus_ready='1' then
              -- Note: We can't drive ready on the next cycle in the current implementation because
              -- the cpu_req signal won't be dropped until the next cycle, and so it'll take one more
              -- cycle after that for the bus interface to switch back to reading from our I/O port.
              -- If I fix the state machine to be combinatorial then I can probably shave a cycle off
              -- the read access time.
              io_data <= std_logic_vector(read_data);             -- Snapshot read data into our output register so CPU can get it on the next cycle.
              cpu_req <= '0';                                     -- Drop bus request
              dmagic_state <= DMAgic_CPUAccessReadData;
            end if;
          when DMAgic_CPUAccessReadData =>
            if io_cs='1' then                                     -- Wait for bus interface to direct control back to us before we drive ready again.
              --io_ready <= '1';
              dmagic_state <= DMAgic_CPUAccessAck;
            end if;
          when DMAgic_CPUAccessWrite =>
              if bus_ready='1' then
                io_ready <= '1';                  -- We can be ready as of the next cycle
                memory_access_write_next <= '0';  -- Drop write signal
                cpu_req <= '0';                   -- Drop bus request
                dmagic_state <= DMAgic_CPUAccessAck;
              end if;
          when DMAgic_CPUAccessAck =>
            io_ready <= '1';
            if io_cs='0' then --- Wait for CPU to stop talking to us before we go idle so we can't accidentally trigger again.
              dmagic_state <= DMAgic_Idle;
            end if;
          when others => null;
            
        end case;
        
      end if;
      
    end if;                         -- if rising edge of clock
    
  end process;
      
end Behavioural;

