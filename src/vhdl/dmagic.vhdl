--
-- Written by
--    Kenneth Dyke 2018
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
    dmagic_memory_access_address_next : out std_logic_vector(19 downto 0) := x"00000";
    dmagic_memory_access_read_next : out std_logic := '0';
    dmagic_memory_access_write_next : out std_logic := '0';
    dmagic_memory_access_wdata_next : out unsigned(7 downto 0) := x"00";
    dmagic_memory_access_io_next : out std_logic := '0';
    dmagic_memory_access_ext_next : out std_logic := '0';
    dmagic_ack : out std_logic := '0';
    dmagic_bus_ready : in std_logic;
    dmagic_read_data : in unsigned(7 downto 0);
    dmagic_dma_req : out std_logic := '0';
    dmagic_cpu_req : out std_logic := '0';

    -- These are the bus signals connected to the I/O device bus, used
    -- for register accesses.
    dmagic_io_address_next : in std_logic_vector(7 downto 0);
    dmagic_io_cs : in std_logic;
    dmagic_io_read_next : in std_logic;
    dmagic_io_write_next : in std_logic;
    dmagic_io_wdata_next : in std_logic_vector(7 downto 0);
    dmagic_io_data : out std_logic_vector(7 downto 0);
    dmagic_io_ready : out std_logic

    );
    
    attribute keep_hierarchy : string;
    attribute mark_debug : string;
    attribute dont_touch : string;
    attribute keep : string;
    
    --attribute mark_debug of dmagic_memory_access_address_next: signal is "true";
    --attribute mark_debug of dmagic_memory_access_read_next: signal is "true";
    --attribute mark_debug of dmagic_memory_access_write_next: signal is "true";
    --attribute mark_debug of dmagic_memory_access_wdata_next: signal is "true";
    --attribute mark_debug of dmagic_memory_access_io_next: signal is "true";
    --attribute mark_debug of dmagic_memory_access_ext_next: signal is "true";
    --attribute mark_debug of dmagic_ack: signal is "true";
    --attribute mark_debug of dmagic_bus_ready: signal is "true";
    --attribute mark_debug of dmagic_read_data: signal is "true";
    --attribute mark_debug of dmagic_dma_req: signal is "true";
    --attribute mark_debug of dmagic_cpu_req: signal is "true";
    --
    --attribute mark_debug of dmagic_io_address_next: signal is "true";
    --attribute mark_debug of dmagic_io_cs: signal is "true";
    --attribute mark_debug of dmagic_io_read_next: signal is "true";
    --attribute mark_debug of dmagic_io_write_next: signal is "true";
    --attribute mark_debug of dmagic_io_wdata_next: signal is "true";
    --attribute mark_debug of dmagic_io_data: signal is "true";
    --attribute mark_debug of dmagic_io_ready: signal is "true";
    
end entity dmagic;

architecture Behavioural of dmagic is
  
  -- attribute keep_hierarchy of Behavioural : architecture is "yes";
  
  -- Microcode data and ALU routing signals follow:

  type dmagic_state_type is (
    DMAgic_Idle,                          -- 0x00
    DMAgic_CPUAccessRead,                 -- 0x01
    DMAgic_CPUAccessReadWait,             -- 0x02
    DMAgic_CPUAccessWrite,                -- 0x03
    DMAgic_CPUAccessAck,                  -- 0x04
    DMAgic_ReadOptions,                   -- 0x05
    DMAgic_ReadOptionArgument,            -- 0x06
    DMAgic_ReadList,                      -- 0x07
    DMAgic_Start,                         -- 0x08
    DMAgic_Dispatch,                      -- 0x09
    DMAgic_Fill,                          -- 0x0A
    DMAgic_CopyRead,                      -- 0x0B
    DMAgic_CopyWrite,                     -- 0x0C
    DMAgic_End                            -- 0x0D
    );

  signal dmagic_state : dmagic_state_type;
  signal dmagic_state_next : dmagic_state_type;

  type dmagic_address_sel is (
    Addr_List,
    Addr_Src,
    Addr_Dst
  );
  
  signal dmagic_addr_sel_next : dmagic_address_sel;
  signal dmagic_wdata_next : unsigned(7 downto 0);  -- FIXME, should be std_logic_vector
  
  type dmagic_iodata_op is (
    Data_List0,
    Data_List1,
    Data_List2,
    Data_Status,
    Data_Addr0,
    Data_Addr1,
    Data_Addr2,
    Data_Index,
    Data_Read,
    Data_Idle
  );
  
  signal dmagic_data_op_next : dmagic_iodata_op;
  
  signal dmagic_list_addr : unsigned(19 downto 0);
  signal dmagic_list_addr_next : unsigned(19 downto 0);
  signal dmagic_list_counter : integer range 0 to 12;

  signal dmagic_src_addr : unsigned(19 downto 0);
  signal dmagic_dst_addr : unsigned(19 downto 0);

  signal dmagic_src_addr_next : unsigned(19 downto 0);
  signal dmagic_dst_addr_next : unsigned(19 downto 0);

  signal dmagic_src_dir : std_logic;
  signal dmagic_src_io : std_logic;
  signal dmagic_src_mod : std_logic;
  signal dmagic_src_hold : std_logic;
  signal load_src_opts : std_logic;
    
  signal dmagic_dst_dir : std_logic;
  signal dmagic_dst_io : std_logic;
  signal dmagic_dst_mod : std_logic;
  signal dmagic_dst_hold : std_logic;
  signal load_dst_opts : std_logic;

  signal load_dir_cmd : std_logic;
  signal load_srcdst_opts : std_logic;
  
  signal dmagic_modulo : unsigned(15 downto 0);
  signal load_mod0 : std_logic;
  signal load_mod1 : std_logic;

  signal dmagic_count : unsigned(15 downto 0);
  signal dmagic_count_next : unsigned(15 downto 0);
  signal load_count0 : std_logic;
  signal load_count1 : std_logic;
  signal update_count : std_logic;
  
  signal dmagic_cmd : std_logic_vector(7 downto 0);
  signal load_cmd : std_logic;
  
  -- Our PIO address
  signal dmagic_pio_addr : unsigned(19 downto 0);
  signal dmagic_pio_index : unsigned(7 downto 0);

  signal increment_index : std_logic;
  signal load_pio_addr0 : std_logic;
  signal load_pio_addr1 : std_logic;
  signal load_pio_addr2 : std_logic;
  signal load_pio_index : std_logic;

  signal load_list_addr0 : std_logic;
  signal load_list_addr1 : std_logic;
  signal load_list_addr2 : std_logic;
  signal increment_list_addr : std_logic;
  
  signal load_src_pio : std_logic;
  signal load_src_addr0 : std_logic;
  signal load_src_addr1 : std_logic;
  signal load_src_addr2 : std_logic;
  signal update_src_addr : std_logic;  

  signal load_dst_addr0 : std_logic;
  signal load_dst_addr1 : std_logic;
  signal load_dst_addr2 : std_logic;
  signal update_dst_addr : std_logic;
  
  signal load_status : std_logic;  
  signal support_f01b : std_logic;
  
  signal list_counter_reset : std_logic;
  signal increment_list_counter : std_logic;
  
  signal dmagic_src_skip : unsigned(7 downto 0) := x"01";
  signal dmagic_dst_skip : unsigned(7 downto 0) := x"01";
  signal load_src_skip : std_logic;
  signal load_dst_skip : std_logic;
  signal reset_opts : std_logic;
  
  signal job_is_f018b : std_logic := '0';
  signal set_job_is_f018a : std_logic;
  signal set_job_is_f018b : std_logic;
  signal load_wdata_fill : std_logic;
  signal load_wdata_bus : std_logic;

  signal job_uses_options : std_logic;
  signal set_job_uses_options : std_logic;
  signal clear_job_uses_options : std_logic;
  
  signal dmagic_wdata_sel_read : std_logic;

  signal start_job : std_logic;
  signal start_cpu_write : std_logic;
  signal start_cpu_read : std_logic;
  
  --signal dmagic_serial : unsigned(15 downto 0);
  
  --attribute mark_debug of dmagic_state : signal is "true";  
  --attribute mark_debug of dmagic_state_next : signal is "true";
  --attribute mark_debug of dmagic_data_op_next : signal is "true";  
  --attribute mark_debug of dmagic_list_addr : signal is "true";
  --attribute mark_debug of dmagic_list_addr_next : signal is "true";
  --attribute mark_debug of dmagic_list_counter : signal is "true";  
  --attribute mark_debug of dmagic_src_addr : signal is "true";
  --attribute mark_debug of dmagic_dst_addr : signal is "true";
  --attribute mark_debug of dmagic_src_addr_next : signal is "true";
  --attribute mark_debug of dmagic_dst_addr_next : signal is "true";
  --attribute mark_debug of dmagic_src_dir : signal is "true";
  --attribute mark_debug of dmagic_src_io : signal is "true";
  --attribute mark_debug of dmagic_src_mod : signal is "true";
  --attribute mark_debug of dmagic_src_hold : signal is "true";
  --attribute mark_debug of load_src_opts : signal is "true";
  --attribute mark_debug of dmagic_dst_dir : signal is "true";
  --attribute mark_debug of dmagic_dst_io : signal is "true";
  --attribute mark_debug of dmagic_dst_mod : signal is "true";
  --attribute mark_debug of dmagic_dst_hold : signal is "true";
  --attribute mark_debug of load_dst_opts : signal is "true";
  --attribute mark_debug of load_dir_cmd : signal is "true";
  --attribute mark_debug of load_srcdst_opts : signal is "true";
  --attribute mark_debug of dmagic_modulo : signal is "true";
  --attribute mark_debug of load_mod0 : signal is "true";
  --attribute mark_debug of load_mod1 : signal is "true";  
  --attribute mark_debug of dmagic_count : signal is "true";
  --attribute mark_debug of dmagic_count_next : signal is "true";
  --attribute mark_debug of load_count0 : signal is "true";
  --attribute mark_debug of load_count1 : signal is "true";
  --attribute mark_debug of update_count : signal is "true";
  --attribute mark_debug of dmagic_cmd : signal is "true";
  --attribute mark_debug of load_cmd : signal is "true";
  --attribute mark_debug of dmagic_pio_addr : signal is "true";
  --attribute mark_debug of dmagic_pio_index : signal is "true";
  --attribute mark_debug of increment_index : signal is "true";
  --attribute mark_debug of load_pio_addr0 : signal is "true";
  --attribute mark_debug of load_pio_addr1 : signal is "true";
  --attribute mark_debug of load_pio_addr2 : signal is "true";
  --attribute mark_debug of load_pio_index : signal is "true";
  --attribute mark_debug of load_list_addr0 : signal is "true";
  --attribute mark_debug of load_list_addr1 : signal is "true";
  --attribute mark_debug of load_list_addr2 : signal is "true";
  --attribute mark_debug of increment_list_addr : signal is "true";
  --attribute mark_debug of load_src_pio : signal is "true";
  --attribute mark_debug of load_src_addr0 : signal is "true";
  --attribute mark_debug of load_src_addr1 : signal is "true";
  --attribute mark_debug of load_src_addr2 : signal is "true";
  --attribute mark_debug of update_src_addr : signal is "true";
  --attribute mark_debug of load_dst_addr0 : signal is "true";
  --attribute mark_debug of load_dst_addr1 : signal is "true";
  --attribute mark_debug of load_dst_addr2 : signal is "true";
  --attribute mark_debug of update_dst_addr : signal is "true";
  --attribute mark_debug of load_status : signal is "true";
  --attribute mark_debug of support_f01b : signal is "true";
  --attribute mark_debug of list_counter_reset : signal is "true";
  --attribute mark_debug of increment_list_counter : signal is "true";
  --attribute mark_debug of dmagic_src_skip : signal is "true";
  --attribute mark_debug of dmagic_dst_skip : signal is "true";
  --attribute mark_debug of load_src_skip : signal is "true";
  --attribute mark_debug of load_dst_skip : signal is "true";
  --attribute mark_debug of reset_opts : signal is "true";
  --attribute mark_debug of job_is_f018b : signal is "true";
  --attribute mark_debug of set_job_is_f018a : signal is "true";
  --attribute mark_debug of set_job_is_f018b : signal is "true";
  --attribute mark_debug of load_wdata_fill : signal is "true";
  --attribute mark_debug of load_wdata_bus : signal is "true";
  --attribute mark_debug of job_uses_options : signal is "true";
  --attribute mark_debug of set_job_uses_options : signal is "true";
  --attribute mark_debug of clear_job_uses_options : signal is "true";
  --attribute mark_debug of dmagic_wdata_sel_read : signal is "true";
  --attribute mark_debug of start_job : signal is "true";
  --attribute mark_debug of start_cpu_write : signal is "true";
  --attribute mark_debug of start_cpu_read : signal is "true";
  --attribute mark_debug of dmagic_serial : signal is "true";
  
begin
  
  process(clock,reset)
  
  variable tmp_sum : unsigned(8 downto 0);
  
  begin    

    -- DMAgic state machine clocked section.   This process really doesn't do any decision making. That
    -- all happens in the combinatorial logic.  This is done as a Mealy machine so we can respond to certain
    -- external signals without needing another clock edge.  This is important so we can so single cycle
    -- memory accesses for PIO, for example.
    if rising_edge(clock) then
      
      if reset='0' then
        dmagic_state <= DMAgic_Idle;
        support_f01b <= '0';
        --dmagic_serial <= x"0000";
        
      else
        
        dmagic_state <= dmagic_state_next;
              
        -- Clocked output data register
        case dmagic_data_op_next is
          when Data_List0 => dmagic_io_data <= std_logic_vector(dmagic_list_addr(7 downto 0));
          when Data_List1 => dmagic_io_data <= std_logic_vector(dmagic_list_addr(15 downto 8));
          when Data_List2 => dmagic_io_data(3 downto 0) <= std_logic_vector(dmagic_list_addr(19 downto 16));
                             dmagic_io_data(7 downto 4) <= x"0";
          when Data_Status=> dmagic_io_data(0) <= support_f01b;
                             dmagic_io_data(7 downto 1) <= "0000000";
          when Data_Addr0 => dmagic_io_data <= std_logic_vector(dmagic_pio_addr(7 downto 0));
          when Data_Addr1 => dmagic_io_data <= std_logic_vector(dmagic_pio_addr(15 downto 8));
          when Data_Addr2 => dmagic_io_data(3 downto 0) <= std_logic_vector(dmagic_pio_addr(19 downto 16));
                             dmagic_io_data(7 downto 4) <= x"0";
          when Data_Index => dmagic_io_data <= std_logic_vector(dmagic_pio_index);
          when Data_Read  => dmagic_io_data <= std_logic_vector(dmagic_read_data);
          when others     => dmagic_io_data <= x"FF";
        end case;

        if load_src_pio='1' then
          dmagic_wdata_next <= unsigned(dmagic_io_wdata_next);
        elsif load_wdata_fill='1' then
          dmagic_wdata_next <= dmagic_src_addr(7 downto 0);
        elsif load_wdata_bus='1' then
          dmagic_wdata_next <= dmagic_read_data;
        end if;
                
        -- Clocked register updates
        if load_src_pio='1' then
          dmagic_src_addr <= dmagic_pio_addr + dmagic_pio_index;
          dmagic_src_io <= '0';
        elsif update_src_addr='1' then
          dmagic_src_addr <= dmagic_src_addr_next;
        else
          if load_src_addr0='1' then
            dmagic_src_addr(7 downto 0) <= dmagic_read_data;
          end if;
          if load_src_addr1='1' then
            dmagic_src_addr(15 downto 8) <= dmagic_read_data;
          end if;
          if load_src_addr2='1' then
            dmagic_src_addr(19 downto 16) <= dmagic_read_data(3 downto 0);
            dmagic_src_io <= std_logic(dmagic_read_data(7));
          end if;
        end if;

        if update_dst_addr='1' then
          dmagic_dst_addr <= dmagic_dst_addr_next;
        else
          if load_dst_addr0='1' then
            dmagic_dst_addr(7 downto 0) <= dmagic_read_data;
          end if;
          if load_dst_addr1='1' then
            dmagic_dst_addr(15 downto 8) <= dmagic_read_data;
          end if;
          if load_dst_addr2='1' then
            dmagic_dst_addr(19 downto 16) <= dmagic_read_data(3 downto 0);
            dmagic_dst_io <= std_logic(dmagic_read_data(7));
          end if;
        end if;

        --if start_job='1' then
        --  dmagic_serial <= dmagic_serial + 1;
        --end if;
        
        if increment_index='1' then
          tmp_sum := '0' & dmagic_pio_index + 1;
          dmagic_pio_index <= tmp_sum(7 downto 0);                
          dmagic_pio_addr(19 downto 8) <= dmagic_pio_addr(19 downto 8) + tmp_sum(8 downto 8);  -- Increment pio addr by carry
        else
          if load_pio_addr0='1' then
            dmagic_pio_addr(7 downto 0) <= unsigned(dmagic_io_wdata_next(7 downto 0));
          end if;
          if load_pio_addr1='1' then
            dmagic_pio_addr(15 downto 8) <= unsigned(dmagic_io_wdata_next(7 downto 0));
          end if;
          if load_pio_addr2='1' then
            dmagic_pio_addr(19 downto 16) <= unsigned(dmagic_io_wdata_next(3 downto 0));
          end if;
          if load_pio_index='1' then
            dmagic_pio_index(7 downto 0) <= unsigned(dmagic_io_wdata_next(7 downto 0));
          end if;
        end if;        

        if increment_list_addr='1' then
          dmagic_list_addr <= dmagic_list_addr_next;
        else
          if load_list_addr0='1' then
            dmagic_list_addr(7 downto 0) <= unsigned(dmagic_io_wdata_next(7 downto 0));
          end if;
          if load_list_addr1='1' then
            dmagic_list_addr(15 downto 8) <= unsigned(dmagic_io_wdata_next(7 downto 0));
          end if;
          if load_list_addr2='1' then
            dmagic_list_addr(19 downto 16) <= unsigned(dmagic_io_wdata_next(3 downto 0));
          end if;
        end if;
        
        if load_status='1' then
          support_f01b <= dmagic_io_wdata_next(0);
        end if;
        
        if load_cmd='1' then
          dmagic_cmd <= std_logic_vector(dmagic_read_data);
        end if;
        
        if list_counter_reset='1' then
          dmagic_list_counter <= 0;
        elsif increment_list_counter='1' then
          dmagic_list_counter <= dmagic_list_counter + 1;
        end if;        
        
        if update_count='1' then
          dmagic_count <= dmagic_count_next;
        else
          if load_count0='1' then
            dmagic_count(7 downto 0) <= dmagic_read_data;
          end if;
          if load_count1='1' then
            dmagic_count(15 downto 8) <= dmagic_read_data;
          end if;
        end if;
        
        if load_srcdst_opts='1' then
          dmagic_src_mod     <= dmagic_read_data(0);
          dmagic_src_hold    <= dmagic_read_data(1);
          dmagic_dst_mod     <= dmagic_read_data(2);
          dmagic_dst_hold    <= dmagic_read_data(3);
        elsif load_src_opts='1' then
          dmagic_src_mod     <= dmagic_read_data(5);
          dmagic_src_hold    <= dmagic_read_data(4);
        elsif load_dst_opts='1' then
          dmagic_dst_mod     <= dmagic_read_data(5);
          dmagic_dst_hold    <= dmagic_read_data(4);
        end if;
        
        if load_dir_cmd='1' then
          dmagic_src_dir    <= dmagic_read_data(4);
          dmagic_dst_dir    <= dmagic_read_data(5);
        else
          if load_src_opts='1' then
            dmagic_src_dir    <= dmagic_read_data(6);
          end if;
          if load_dst_opts='1' then
            dmagic_dst_dir    <= dmagic_read_data(6);
          end if;
        end if;
        
        if load_mod0='1' then
          dmagic_modulo(7 downto 0) <= dmagic_read_data;
        end if;
        if load_mod1='1' then
          dmagic_modulo(15 downto 8) <= dmagic_read_data;
        end if;
        
        if reset_opts='1' then
          dmagic_src_skip <= x"01";
          dmagic_dst_skip <= x"01";
        else
          if load_src_skip='1' then
            dmagic_src_skip <= dmagic_read_data;
          end if;
          if load_dst_skip='1' then
            dmagic_dst_skip <= dmagic_read_data;
          end if;
        end if;
        
        if set_job_is_f018a='1' then
          job_is_f018b <= '0';
        elsif set_job_is_f018b='1' then
          job_is_f018b <= '1';
        end if;
        
        if set_job_uses_options='1' then
          job_uses_options <= '1';
        elsif clear_job_uses_options='1' then
          job_uses_options <= '0';
        end if;
      end if;                       -- !reset
      
    end if;                         -- if rising edge of clock
    
  end process;
  
  -- Bus signal selection
  process(dmagic_addr_sel_next, dmagic_src_addr, dmagic_dst_addr)
  begin
    case dmagic_addr_sel_next is
      when Addr_Src =>
        dmagic_memory_access_address_next <= std_logic_vector(dmagic_src_addr);
        dmagic_memory_access_io_next <= dmagic_src_io;
      when Addr_Dst =>
        dmagic_memory_access_address_next <= std_logic_vector(dmagic_dst_addr);
        dmagic_memory_access_io_next <= dmagic_dst_io;
      when Addr_List =>
        dmagic_memory_access_address_next <= std_logic_vector(dmagic_list_addr_next);
        dmagic_memory_access_io_next <= '0';
      end case;
  end process;
  
  -- We have a fast path for routing dmagic_read_data directly back to wdata so we can do
  -- back to back reads and writes on alternate cycles if the bus interface lets us.
  process(dmagic_wdata_sel_read, dmagic_wdata_next, dmagic_read_data)
  begin
    if dmagic_wdata_sel_read='1' then
      dmagic_memory_access_wdata_next <= dmagic_read_data;
    else
      dmagic_memory_access_wdata_next <= dmagic_wdata_next;
    end if;
  end process;
      
  process(dmagic_dst_hold, dmagic_dst_dir, dmagic_dst_addr, dmagic_dst_skip)
  begin
    if dmagic_dst_hold='1' then
      dmagic_dst_addr_next <= dmagic_dst_addr;
    else
      if dmagic_dst_dir='0' then
        dmagic_dst_addr_next <= dmagic_dst_addr + dmagic_dst_skip;
      else
        dmagic_dst_addr_next <= dmagic_dst_addr - dmagic_dst_skip;
      end if;
    end if;
  end process;

  process(dmagic_src_hold, dmagic_src_dir, dmagic_src_addr, dmagic_src_skip)
  begin
    if dmagic_src_hold='1' then
      dmagic_src_addr_next <= dmagic_src_addr;
    else
      if dmagic_src_dir='0' then
        dmagic_src_addr_next <= dmagic_src_addr + dmagic_src_skip;
      else
        dmagic_src_addr_next <= dmagic_src_addr - dmagic_src_skip;
      end if;
    end if;
  end process;
  
  process(dmagic_list_addr, increment_list_addr)
  begin
    if increment_list_addr='1' then
      dmagic_list_addr_next <= dmagic_list_addr + 1;
    else
      dmagic_list_addr_next <= dmagic_list_addr;
    end if;
  end process;
  
  -- Predecremented counter value.
  dmagic_count_next <= dmagic_count - 1;
  
  -- State machine control
  process(clock,reset,dmagic_io_cs,dmagic_bus_ready,dmagic_state,dmagic_io_address_next,dmagic_io_read_next,
          dmagic_io_write_next,dmagic_read_data, dmagic_cmd,job_is_f018b,job_uses_options)
  begin

    -- Default control signal states to prevent latches.
    dmagic_state_next <= dmagic_state;
    dmagic_dma_req <= '0';
    dmagic_cpu_req <= '0';
    dmagic_io_ready <= '1';
    dmagic_ack <= '1';
    
    dmagic_addr_sel_next <= Addr_Src;
    dmagic_data_op_next <= Data_Idle;
    
    load_pio_addr0 <= '0';
    load_pio_addr1 <= '0';
    load_pio_addr2 <= '0';
    load_pio_index <= '0';
    increment_index <= '0';

    load_src_addr0 <= '0';
    load_src_addr1 <= '0';
    load_src_addr2 <= '0';
    load_src_pio <= '0';
    update_src_addr <= '0';

    load_dst_addr0 <= '0';
    load_dst_addr1 <= '0';
    load_dst_addr2 <= '0';
    update_dst_addr <= '0';
    
    load_list_addr0 <= '0';
    load_list_addr1 <= '0';
    load_list_addr2 <= '0';
    load_status <= '0';
    
    increment_list_addr <= '0';

    list_counter_reset <= '0';
    increment_list_counter <= '0';

    load_cmd <= '0';
    load_dir_cmd <= '0';
    
    update_count <= '0';
    load_count0 <= '0';
    load_count1 <= '0';
    
    dmagic_memory_access_write_next <= '0';    

    set_job_is_f018a <= '0';
    set_job_is_f018b <= '0';
    
    clear_job_uses_options <= '0';
    set_job_uses_options <= '0';
    
    load_wdata_fill <= '0';
    dmagic_wdata_sel_read <= '0';
    
    load_srcdst_opts <= '0';
    load_src_opts <= '0';
    load_dst_opts <= '0';
    reset_opts <= '0';
    load_dst_skip <= '0';
    load_src_skip <= '0';
    load_wdata_bus <= '0';
    start_job <= '0';
    start_cpu_write <= '0';
    start_cpu_read <= '0';
    
    load_mod0 <= '0';
    load_mod1 <= '0';
    
    if dmagic_io_cs='1' then
      if dmagic_io_address_next=x"00" or dmagic_io_address_next=x"05" or dmagic_io_address_next=x"0E" then
        load_list_addr0 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_List0;
        if dmagic_io_write_next='1' then
          if dmagic_io_address_next=x"00" then
            clear_job_uses_options <= '1';
            start_job <= '1';
          elsif dmagic_io_address_next=x"05" then
            set_job_uses_options <= '1';
            start_job <= '1';
          end if;
        end if;
      elsif dmagic_io_address_next=x"01" then
        load_list_addr1 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_List1;
      elsif dmagic_io_address_next=x"02" then
        load_list_addr2 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_List2;
      elsif dmagic_io_address_next=x"03" then
        load_status <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_Status;
      elsif dmagic_io_address_next=x"10" then
        load_pio_addr0 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_Addr0;
      elsif dmagic_io_address_next=x"11" then
        load_pio_addr1 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_Addr1;
      elsif dmagic_io_address_next=x"12" then
        load_pio_addr2 <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_Addr2;
      elsif dmagic_io_address_next=x"13" then
        load_pio_index <= dmagic_io_write_next;
        dmagic_data_op_next <= Data_Index;
      elsif dmagic_io_address_next=x"14" or dmagic_io_address_next=x"15" then
        load_src_pio <= '1';
        increment_index <= dmagic_io_address_next(0);
        if dmagic_io_write_next='1' then
          start_cpu_write <= '1';
        else
          start_cpu_read <= '1';
        end if;
      end if; -- Register Accesses
    end if; -- Chip select enable
        
    case dmagic_state is
      when DMAgic_Idle =>
        if start_job='1' then
          dmagic_state_next <= DMAgic_Start;
        elsif start_cpu_write='1' then
          dmagic_state_next <= DMAgic_CPUAccessWrite;
        elsif start_cpu_read='1' then
          dmagic_state_next <= DMAgic_CPUAccessRead;
        end if;
        
        -- During DMAgic_CPUAccessRead we are driving our output signals with the data we want.  We're waiting
        -- to be told the data is available.  We also hold dmagic_io_ready low since the bus interface will sill be
        -- feeding the CPU from FastIO (i.e. us) during this cycle and we don't have the data yet.
      when DMAgic_CPUAccessRead =>
        dmagic_io_ready <= '0';
        dmagic_cpu_req <= '1';
        if dmagic_bus_ready='1' then
          dmagic_cpu_req <= '0'; -- Let CPU have the bus again (it should start driving our own address immediately
          dmagic_data_op_next <= Data_Read;

          -- If CPU has grabbed address bus again and is now sourcing from us again (or will on the next cycle), 
          -- proceed directly to Ack state. Otherwise we need to go to DMAgic_CPUReadWait and wait for it to catch up.
          if dmagic_io_cs='1' then 
            dmagic_state_next <= DMAgic_CPUAccessAck;
          else
            dmagic_state_next <= DMAgic_CPUAccessReadWait;
          end if;

        end if;
      
      when DMAgic_CPUAccessReadWait =>
        dmagic_io_ready <= '0';
        if dmagic_io_cs='1' then                                     -- Wait for bus arbiter to direct control back to us
          dmagic_state_next <= DMAgic_CPUAccessAck;
        end if;
      
      when DMAgic_CPUAccessWrite =>
        dmagic_io_ready <= '1';                                      -- This could be set to 1 to make this act like a posted write would save a bus cycle on writes.
        dmagic_cpu_req <= '1';
        dmagic_memory_access_write_next <= '1';
        if dmagic_bus_ready='1' then
          dmagic_cpu_req <= '0';                   -- Drop bus request
          dmagic_state_next <= DMAgic_CPUAccessAck;
        end if;
      
      when DMAgic_CPUAccessAck =>        
        if dmagic_io_cs='0' then --- Wait for CPU to stop talking to us before we go idle so we can't accidentally trigger again.
          dmagic_state_next <= DMAgic_Idle;
        end if;
      
      -- Note: Some states currently don't hold dma_req high even though they probably should.   The reason they don't do it 
      -- is mostly to work around the fact that the current bus interface hasn't fully implemented proper ready signal generation
      -- that actually pays attention to whether or not the current bus master is actually doing a bus cycle or not.  If I drive
      -- dma_req high but don't start a real bus cycle, I'll end up seeing ready set high as soon as I enter the read/write/fill
      -- states, which then causes them to jump to the next state one cycle too early.   Once I fix the bus interface module (and
      -- the dependent bus modules) to properly generate a ready signal based on there being a real access from the current bus
      -- master, I can change the code below to just hold dma_req high for the whole operation.
      
      when DMAgic_Start =>
        --dmagic_dma_req <= '1';
        list_counter_reset <= '1';
        if job_uses_options='1' then
          dmagic_state_next <= DMAgic_ReadOptions;
        else
          dmagic_state_next <= DMAgic_ReadList;
        end if;
      
      when DMAgic_ReadOptions =>
        dmagic_dma_req <= '1';
        dmagic_addr_sel_next <= Addr_List;
        if dmagic_bus_ready='1' then
          increment_list_addr <= '1';
          if dmagic_read_data(7)='1' then
            load_cmd <= '1';    -- This will get overwritten anyway, so I use it as temporary storage.
            dmagic_state_next <= DMAgic_ReadOptionArgument;
          else
            case dmagic_read_data is
              when    x"00" =>  dmagic_state_next <= DMAgic_ReadList;
              when    x"0A" =>  set_job_is_f018a <= '1';
              when    x"0B" =>  set_job_is_f018b <= '1';
              when others => null;
            end case;
          end if;
        end if;
        
      when DMAgic_ReadOptionArgument =>
        dmagic_dma_req <= '1';
        dmagic_addr_sel_next <= Addr_List;
        if dmagic_bus_ready='1' then
          increment_list_addr <= '1';
          dmagic_state_next <= DMAgic_ReadOptions;
          
          case dmagic_cmd is
            when x"83" => load_src_skip <= '1';
            when x"85" => load_dst_skip <= '1';
            when others => null;
          end case;
        end if;
        
      when DMAgic_ReadList =>
        dmagic_dma_req <= '1';
        dmagic_addr_sel_next <= Addr_List;
        if dmagic_bus_ready='1' then
          increment_list_addr <= '1';       -- This starts driving the next address on the current cycle to line up with the counter update
          increment_list_counter <= '1';    -- that happens on the next cycle, and then holds both in sync until the bus is ready again.
          case dmagic_list_counter is
            when  0 =>  load_cmd <= '1';
                        if job_is_f018b = '1' then
                          load_dir_cmd <= '1';
                        end if;
            when  1 =>  load_count0 <= '1';
            when  2 =>  load_count1 <= '1';
            when  3 =>  load_src_addr0 <= '1';
            when  4 =>  load_src_addr1 <= '1';
            when  5 =>  load_src_addr2 <= '1';
                        if job_is_f018b='0' then
                          load_src_opts <='1';
                        end if;
            when  6 =>  load_dst_addr0 <= '1';
            when  7 =>  load_dst_addr1 <= '1';
            when  8 =>  load_dst_addr2 <= '1';
                        if job_is_f018b='0' then
                          load_dst_opts <='1';
                        end if;
            when  9 =>  if job_is_f018b='0' then
                          load_mod0 <= '1';
                        else
                          load_srcdst_opts <='1';
                        end if;
            when 10 =>  if job_is_f018b='0' then
                          load_mod1 <= '1';
                          --increment_list_addr <= '0';
                          dmagic_state_next <= DMAgic_Dispatch;
                        else
                          load_mod0 <= '1';
                        end if;
            when 11 =>  load_mod1 <= '1';
                        --increment_list_addr <= '0';
                        dmagic_state_next <= DMAgic_Dispatch;
            when others =>
                        --increment_list_addr <= '0';
          end case;
          
        end if;
        
      when DMAgic_Dispatch =>
        --dmagic_dma_req <= '1';
        case dmagic_cmd(1 downto 0) is
          when "11" => -- fill                  
            load_wdata_fill <= '1';
            dmagic_state_next <= DMAgic_Fill;
          when "00" => -- copy
            dmagic_state_next <= DMAgic_CopyRead;
          when others => -- nothing else implemented yet.
            dmagic_state_next <= DMAgic_End;
        end case;
        
      when DMAgic_Fill =>
        dmagic_dma_req <= '1';
        dmagic_addr_sel_next <= Addr_Dst;
        dmagic_memory_access_write_next <= '1';
        if dmagic_bus_ready='1' then
          update_count <= '1';
          update_dst_addr <= '1';
          if dmagic_count = x"0000" then
            dmagic_state_next <= DMAgic_End;
            dmagic_memory_access_write_next <= '0';
          end if;
        end if;
      
      when DMAgic_CopyRead =>
        dmagic_dma_req <= '1';
        if dmagic_bus_ready='1' then
          update_src_addr <= '1';
          load_wdata_bus <= '1';  -- Make copy of data in case there are write wait states.
          dmagic_addr_sel_next <= Addr_Dst;          
          dmagic_memory_access_write_next <= '1';
          dmagic_wdata_sel_read <= '1'; -- Enable fast path for this cycle in case there aren't wait states...
          dmagic_state_next <= DMAgic_CopyWrite;
        end if;

      when DMAgic_CopyWrite =>
        dmagic_dma_req <= '1';
        dmagic_addr_sel_next <= Addr_Dst;          
        dmagic_memory_access_write_next <= '1';
        if dmagic_bus_ready='1' then
          update_dst_addr <= '1';
          update_count <= '1';
          dmagic_addr_sel_next <= Addr_Src;
          dmagic_memory_access_write_next <= '0';
          if dmagic_count_next = x"0000" then
            dmagic_state_next <= DMAgic_End;
            dmagic_memory_access_write_next <= '0';
          else
            dmagic_state_next <= DMAgic_CopyRead;
          end if;
        end if;
          
      when DMAgic_End =>
        --dmagic_dma_req <= '1';
        if dmagic_cmd(2)='0' then
          reset_opts <= '1';
          dmagic_state_next <= DMAgic_Idle;
        else
          dmagic_state_next <= DMAgic_Start;
        end if;
        
      when others => null;      
      
    end case;

  end process;
  
end Behavioural;
