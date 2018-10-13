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
    DMAgic_CPUAccessReadWait,
    DMAgic_CPUAccessWrite,
    DMAgic_CPUAccessAck
    );

  signal dmagic_state : dmagic_state_type;
  signal dmagic_state_next : dmagic_state_type;

  type dmagic_address_op is (
    Addr_Idle,
    Addr_CPU,
    Addr_Src,
    Addr_Dst
  );
  
  signal dmagic_addr_op_next : dmagic_address_op;
  signal dmagic_write_next : std_logic;
  signal dmagic_wdata_next : unsigned(7 downto 0);  -- FIXME, should be std_logic_vector
  
  type dmagic_iodata_op is (
    Data_Idle,
    Data_Addr0,
    Data_Addr1,
    Data_Addr2,
    Data_Index,
    Data_Read
  );
  
  signal dmagic_data_op_next : dmagic_iodata_op;
  
  -- Our PIO address
  signal dmagic_pio_addr : unsigned(19 downto 0);
  signal dmagic_pio_index : unsigned(7 downto 0);
    
  signal index_increment : std_logic;
  signal load_addr0 : std_logic;
  signal load_addr1 : std_logic;
  signal load_addr2 : std_logic;
  signal load_index : std_logic;

  --attribute mark_debug of dmagic_state : signal is "true";
  --attribute mark_debug of dmagic_state_next : signal is "true";
  --attribute mark_debug of dmagic_pio_addr : signal is "true";
  --attribute mark_debug of dmagic_pio_index : signal is "true";
  --
  --attribute mark_debug of dmagic_addr_op_next : signal is "true";
  --attribute mark_debug of dmagic_write_next : signal is "true";
  --attribute mark_debug of dmagic_wdata_next : signal is "true";
  --attribute mark_debug of dmagic_data_op_next : signal is "true";
  --
  --attribute mark_debug of index_increment : signal is "true";
  --attribute mark_debug of load_addr0 : signal is "true";
  --attribute mark_debug of load_addr1 : signal is "true";
  --attribute mark_debug of load_addr2 : signal is "true";
  --attribute mark_debug of load_index : signal is "true";
  
begin
  
  process(clock,reset)
  
  variable tmp_sum : unsigned(8 downto 0);
  
  begin    

  -- DMAgic state machine
    if rising_edge(clock) then
      
      if reset='0' then
        dmagic_state <= DMAgic_Idle;
        
      else
        
        dmagic_state <= dmagic_state_next;
      
        -- Address bus output update
        case dmagic_addr_op_next is
          when Addr_Idle => memory_access_write_next <= '0';          
          when Addr_CPU  => memory_access_address_next <= std_logic_vector(dmagic_pio_addr + dmagic_pio_index);
                            memory_access_write_next <= dmagic_write_next;
                            memory_access_wdata_next <= dmagic_wdata_next;
                           
          when others => null;
        end case;
        
        -- Data output register
        case dmagic_data_op_next is
          when Data_Addr0 => io_data <= std_logic_vector(dmagic_pio_addr(7 downto 0));
          when Data_Addr1 => io_data <= std_logic_vector(dmagic_pio_addr(15 downto 8));
          when Data_Addr2 => io_data(3 downto 0) <= std_logic_vector(dmagic_pio_addr(19 downto 16));
                             io_data(7 downto 4) <= x"0";
          when Data_Index => io_data <= std_logic_vector(dmagic_pio_index);
          when Data_Read  => io_data <= std_logic_vector(read_data);
          when others => null;
        end case;
        
        -- Internal register updates
        if index_increment='1' then
          tmp_sum := '0' & dmagic_pio_index + 1;
          dmagic_pio_index <= tmp_sum(7 downto 0);                
          dmagic_pio_addr(19 downto 8) <= dmagic_pio_addr(19 downto 8) + tmp_sum(8 downto 8);  -- Increment pio addr by carry
        else
          if load_addr0='1' then
            dmagic_pio_addr(7 downto 0) <= unsigned(io_wdata_next(7 downto 0));
          elsif load_addr1='1' then
            dmagic_pio_addr(15 downto 8) <= unsigned(io_wdata_next(7 downto 0));
          elsif load_addr2='1' then
            dmagic_pio_addr(19 downto 16) <= unsigned(io_wdata_next(3 downto 0));
          elsif load_index='1' then
            dmagic_pio_index(7 downto 0) <= unsigned(io_wdata_next(7 downto 0));
          end if;
        end if;        
        
      end if;                       -- !reset
      
    end if;                         -- if rising edge of clock
    
  end process;
      
  -- State machine control
  process(clock,reset,io_cs,bus_ready,dmagic_state,io_address_next,io_read_next,io_write_next)
  
  begin

    -- Default control signal states to prevent latches.
    dma_req <= '0';
    cpu_req <= '0';
    io_ready <= '1';
    ack <= '1';
    dmagic_addr_op_next <= Addr_Idle;
    dmagic_data_op_next <= Data_Idle;
    load_addr0 <= '0';
    load_addr1 <= '0';
    load_addr2 <= '0';
    load_index <= '0';
    index_increment <= '0';
    
    dmagic_state_next <= dmagic_state;

    case dmagic_state is
      when DMAgic_Idle =>
        if io_cs='1' then
          if io_address_next=x"10" then
            load_addr0 <= io_write_next;
            dmagic_data_op_next <= Data_Addr0;
          elsif io_address_next=X"11" then
            load_addr1 <= io_write_next;
            dmagic_data_op_next <= Data_Addr1;
          elsif io_address_next=X"12" then
            load_addr2 <= io_write_next;
            dmagic_data_op_next <= Data_Addr2;
          elsif io_address_next=X"13" then
            load_index <= io_write_next;
            dmagic_data_op_next <= Data_Index;
          elsif io_address_next=x"14" or io_address_next=x"15" then
            dmagic_addr_op_next <= Addr_CPU;
            dmagic_wdata_next <= unsigned(io_wdata_next);
            dmagic_write_next <= io_write_next;
            if io_write_next='1' then
              dmagic_state_next <= DMAgic_CPUAccessWrite;
            else
              dmagic_state_next <= DMAgic_CPUAccessRead;
            end if;
            index_increment <= io_address_next(0);
          end if; -- Register Accesses
        end if; -- Chip select enable
        
        -- During DMAgic_CPUAccessRead we are driving our output signals with the data we want.  We're waiting
        -- to be told the data is available.  We also hold io_ready low since the bus interface will sill be
        -- feeding the CPU from FastIO (i.e. us) during this cycle and we don't have the data yet.
      when DMAgic_CPUAccessRead =>
        io_ready <= '0';
        cpu_req <= '1';
        if bus_ready='1' then
          cpu_req <= '0'; -- Let CPU have the bus again (it should start driving our own address immediately
          dmagic_data_op_next <= Data_Read;

          -- If CPU has grabbed address bus again and is now sourcing from us again (or will on the next cycle), 
          -- proceed directly to Ack state. Otherwise we need to go to DMAgic_CPUReadWait and wait for it to catch up.
          if io_cs='1' then 
            dmagic_state_next <= DMAgic_CPUAccessAck;
          else
            dmagic_state_next <= DMAgic_CPUAccessReadWait;
          end if;

        end if;
      when DMAgic_CPUAccessReadWait =>
        io_ready <= '0';
        if io_cs='1' then                                     -- Wait for bus arbiter to direct control back to us
          dmagic_state_next <= DMAgic_CPUAccessAck;
        end if;
      when DMAgic_CPUAccessWrite =>
        io_ready <= '1';                                      -- This could be set to 1 to make this act like a posted write would save a bus cycle on writes.
        cpu_req <= '1';
        if bus_ready='1' then
          cpu_req <= '0';                   -- Drop bus request
          dmagic_state_next <= DMAgic_CPUAccessAck;
        end if;
      when DMAgic_CPUAccessAck =>
        dmagic_addr_op_next <= Addr_Idle; -- Stop driving write request.
        if io_cs='0' then --- Wait for CPU to stop talking to us before we go idle so we can't accidentally trigger again.
          dmagic_state_next <= DMAgic_Idle;
        end if;
      when others => null;
                
    end case;

  end process;
  
end Behavioural;

