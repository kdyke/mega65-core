-- This VHDL was converted from Verilog using the
-- Icarus Verilog VHDL Code Generator 11.0 (devel) ()

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module uart_monitor (monitor/monitor_top.v:8)
entity uart_monitor is
  port (
    activity : out std_logic;
    bit_rate_divisor : out unsigned(15 downto 0);
    clear_matrix_mode_toggle : out std_logic;
    clock : in std_logic;
    fastio_read : in std_logic;
    fastio_write : in std_logic;
    force_single_step : in std_logic;
    key_scancode : out unsigned(15 downto 0);
    key_scancode_toggle : out std_logic;
    monitor_a : in unsigned(7 downto 0);
    monitor_arg1 : in unsigned(7 downto 0);
    monitor_arg2 : in unsigned(7 downto 0);
    monitor_b : in unsigned(7 downto 0);
    monitor_char : in unsigned(7 downto 0);
    monitor_char_busy : out std_logic;
    monitor_char_out : out unsigned(7 downto 0);
    monitor_char_toggle : in std_logic;
    monitor_char_valid : out std_logic;
    monitor_cpu_state : in unsigned(15 downto 0);
    monitor_hyper_trap : out std_logic;
    monitor_hypervisor_mode : in std_logic;
    monitor_ibytes : in unsigned(3 downto 0);
    monitor_instruction : in unsigned(7 downto 0);
    monitor_interrupt_inhibit : in std_logic;
    monitor_irq_inhibit : out std_logic;
    monitor_map_enables_high : in unsigned(3 downto 0);
    monitor_map_enables_low : in unsigned(3 downto 0);
    monitor_map_offset_high : in unsigned(11 downto 0);
    monitor_map_offset_low : in unsigned(11 downto 0);
    monitor_mem_address : out unsigned(19 downto 0);
    monitor_mem_attention_granted : in std_logic;
    monitor_mem_attention_request : out std_logic;
    monitor_mem_map_en : out std_logic;
    monitor_mem_rdata : in unsigned(7 downto 0);
    monitor_mem_read : out std_logic;
    monitor_mem_resolve_address : out std_logic;
    monitor_mem_setpc : out std_logic;
    monitor_mem_stage_trace_mode : out std_logic;
    monitor_mem_trace_mode : out std_logic;
    monitor_mem_trace_toggle : out std_logic;
    monitor_mem_wdata : out unsigned(7 downto 0);
    monitor_mem_write : out std_logic;
    monitor_memory_access_address : in unsigned(31 downto 0);
    monitor_opcode : in unsigned(7 downto 0);
    monitor_p : in unsigned(7 downto 0);
    monitor_pc : in unsigned(15 downto 0);
    monitor_proceed : in std_logic;
    monitor_request_reflected : in std_logic;
    monitor_roms : in unsigned(7 downto 0);
    monitor_sp : in unsigned(15 downto 0);
    monitor_waitstates : in unsigned(7 downto 0);
    monitor_watch : out unsigned(23 downto 0);
    monitor_watch_match : in std_logic;
    monitor_x : in unsigned(7 downto 0);
    monitor_y : in unsigned(7 downto 0);
    monitor_z : in unsigned(7 downto 0);
    pixclock : in std_logic;
    protected_hardware_in : in unsigned(7 downto 0);
    reset : in std_logic;
    reset_out : out std_logic;
    rx : in std_logic;
    secure_mode_from_cpu : in std_logic;
    secure_mode_from_monitor : out std_logic;
    terminal_emulator_ack : in std_logic;
    terminal_emulator_ready : in std_logic;
    tx : out std_logic;
    uart_char : in unsigned(7 downto 0);
    uart_char_valid : in std_logic
  );
end entity; 

-- Generated from Verilog module uart_monitor (monitor/monitor_top.v:8)
architecture from_verilog of uart_monitor is
  signal key_scancode_Reg : unsigned(15 downto 0);
  signal key_scancode_toggle_Reg : std_logic;
  signal monitor_mem_stage_trace_mode_Reg : std_logic;
  signal tmp_s103 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:115
  signal tmp_s107 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:116
  signal tmp_s11 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:91
  signal tmp_s110 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:117
  signal tmp_s117 : unsigned(3 downto 0);  -- Temporary created at monitor/monitor_top.v:150
  signal tmp_s121 : unsigned(2 downto 0);  -- Temporary created at monitor/monitor_top.v:151
  signal tmp_s124 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:160
  signal tmp_s128 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:162
  signal tmp_s134 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:165
  signal tmp_s138 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:167
  signal tmp_s144 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:174
  signal tmp_s148 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:176
  signal tmp_s15 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:92
  signal tmp_s154 : unsigned(15 downto 0);  -- Temporary created at monitor/monitor_top.v:175
  signal tmp_s164 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:223
  signal tmp_s168 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:223
  signal tmp_s172 : signed(31 downto 0);  -- Temporary created at monitor/monitor_top.v:223
  signal tmp_s19 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:93
  signal tmp_s23 : unsigned(15 downto 0);  -- Temporary created at monitor/monitor_top.v:94
  signal tmp_s27 : unsigned(15 downto 0);  -- Temporary created at monitor/monitor_top.v:95
  signal tmp_s3 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:89
  signal tmp_s31 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:96
  signal tmp_s35 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:97
  signal tmp_s39 : unsigned(15 downto 0);  -- Temporary created at monitor/monitor_top.v:98
  signal tmp_s43 : unsigned(3 downto 0);  -- Temporary created at monitor/monitor_top.v:99
  signal tmp_s44 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:99
  signal tmp_s49 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:100
  signal tmp_s53 : unsigned(1 downto 0);  -- Temporary created at monitor/monitor_top.v:101
  signal tmp_s57 : std_logic;  -- Temporary created at monitor/monitor_top.v:102
  signal tmp_s61 : std_logic;  -- Temporary created at monitor/monitor_top.v:103
  signal tmp_s65 : std_logic;  -- Temporary created at monitor/monitor_top.v:104
  signal tmp_s69 : std_logic;  -- Temporary created at monitor/monitor_top.v:105
  signal tmp_s7 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:90
  signal tmp_s73 : std_logic;  -- Temporary created at monitor/monitor_top.v:106
  signal tmp_s77 : std_logic;  -- Temporary created at monitor/monitor_top.v:107
  signal tmp_s81 : unsigned(3 downto 0);  -- Temporary created at monitor/monitor_top.v:110
  signal tmp_s82 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:110
  signal tmp_s87 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:111
  signal tmp_s91 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:112
  signal tmp_s95 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:113
  signal tmp_s99 : unsigned(7 downto 0);  -- Temporary created at monitor/monitor_top.v:114
  signal cpu_address_next : unsigned(15 downto 0);  -- Declared at monitor/monitor_top.v:129
  signal cpu_di : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:130
  signal cpu_do : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:131
  signal cpu_state_rdata : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:136
  signal cpu_state_write : std_logic;  -- Declared at monitor/monitor_top.v:137
  signal cpu_state_write_index : unsigned(3 downto 0);  -- Declared at monitor/monitor_top.v:138
  signal cpu_write_next : std_logic;  -- Declared at monitor/monitor_top.v:132
  signal ctrl_read : std_logic;  -- Declared at monitor/monitor_top.v:143
  signal ctrl_write : std_logic;  -- Declared at monitor/monitor_top.v:144
  signal history_rdata_hi : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:122
  signal history_rdata_lo : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:121
  signal history_read_address_hi : unsigned(12 downto 0);  -- Declared at monitor/monitor_top.v:125
  signal history_read_address_lo : unsigned(13 downto 0);  -- Declared at monitor/monitor_top.v:124
  signal history_read_index : unsigned(9 downto 0);  -- Declared at monitor/monitor_top.v:127
  signal history_wdata : unsigned(191 downto 0);  -- Declared at monitor/monitor_top.v:86
  signal history_write : std_logic;  -- Declared at monitor/monitor_top.v:160
  signal history_write_index : unsigned(9 downto 0);  -- Declared at monitor/monitor_top.v:119
  signal monitor_do : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:135
  signal ram_do : unsigned(7 downto 0);  -- Declared at monitor/monitor_top.v:134
  signal ram_write : std_logic;  -- Declared at monitor/monitor_top.v:142
  signal reset_internal : std_logic;  -- Declared at monitor/monitor_top.v:140
  signal reset_out_internal : std_logic;  -- Declared at monitor/monitor_top.v:141
  signal LPM_q_s127 : std_logic;
  signal LPM_q_s131 : std_logic;
  signal LPM_q_s132 : unsigned(127 downto 0);
  signal LPM_q_s137 : std_logic;
  signal LPM_q_s141 : std_logic;
  signal LPM_q_s142 : unsigned(63 downto 0);
  signal LPM_q_s147 : std_logic;
  signal LPM_q_s151 : std_logic;
  signal LPM_q_s152 : unsigned(6 downto 0);
  signal LPM_q_s157 : unsigned(63 downto 0);
  signal LPM_q_s158 : unsigned(11 downto 0);
  signal LPM_q_s160 : unsigned(4 downto 0);
  signal LPM_q_s162 : unsigned(7 downto 0);
  signal LPM_q_s167 : std_logic;
  signal LPM_q_s171 : std_logic;
  signal LPM_q_s175 : std_logic;
  
  component asym_ram_sdp is
    port (
      addrA : in unsigned(3 downto 0);
      addrB : in unsigned(6 downto 0);
      clkA : in std_logic;
      clkB : in std_logic;
      diA : in unsigned(63 downto 0);
      doB : out unsigned(7 downto 0);
      enaA : in std_logic;
      enaB : in std_logic;
      weA : in std_logic
    );
  end component;
  
  component asym_ram_sdp1 is
    port (
      addrA : in unsigned(9 downto 0);
      addrB : in unsigned(13 downto 0);
      clkA : in std_logic;
      clkB : in std_logic;
      diA : in unsigned(127 downto 0);
      doB : out unsigned(7 downto 0);
      enaA : in std_logic;
      enaB : in std_logic;
      weA : in std_logic
    );
  end component;
  
  component asym_ram_sdp2 is
    port (
      addrA : in unsigned(9 downto 0);
      addrB : in unsigned(12 downto 0);
      clkA : in std_logic;
      clkB : in std_logic;
      diA : in unsigned(63 downto 0);
      doB : out unsigned(7 downto 0);
      enaA : in std_logic;
      enaB : in std_logic;
      weA : in std_logic
    );
  end component;
  
  component monitor_bus is
    port (
      clk : in std_logic;
      cpu_address : in unsigned(15 downto 0);
      cpu_state : in unsigned(7 downto 0);
      cpu_write : in std_logic;
      ctrl : in unsigned(7 downto 0);
      ctrl_read : out std_logic;
      ctrl_write : out std_logic;
      history_hi : in unsigned(7 downto 0);
      history_lo : in unsigned(7 downto 0);
      mem : in unsigned(7 downto 0);
      ram_write : out std_logic;
      read_data : out unsigned(7 downto 0)
    );
  end component;
  
  component cpu6502 is
    port (
      address : buffer unsigned(15 downto 0);
      address_next : out unsigned(15 downto 0);
      clk : in std_logic;
      cpu_int : out std_logic;
      cpu_state : out unsigned(7 downto 0);
      data_i : in unsigned(7 downto 0);
      data_o : out unsigned(7 downto 0);
      data_o_next : out unsigned(7 downto 0);
      irq : in std_logic;
      nmi : in std_logic;
      ready : in std_logic;
      reset : in std_logic;
      sync : buffer std_logic;
      t : out unsigned(2 downto 0);
      write : out std_logic;
      write_next : buffer std_logic
    );
  end component;
  
  component monitor_ctrl is
    port (
      activity : out std_logic;
      address : in unsigned(4 downto 0);
      bit_rate_divisor : out unsigned(15 downto 0);
      clear_matrix_mode_toggle : out std_logic;
      clk : in std_logic;
      cpu_state : in unsigned(7 downto 0);
      cpu_state_write : out std_logic;
      cpu_state_write_index : out unsigned(3 downto 0);
      di : in unsigned(7 downto 0);
      do : out unsigned(7 downto 0);
      history_read_index : out unsigned(9 downto 0);
      history_write : buffer std_logic;
      history_write_index : out unsigned(9 downto 0);
      map_enables_high : in unsigned(3 downto 0);
      map_enables_low : in unsigned(3 downto 0);
      map_offset_high : in unsigned(11 downto 0);
      map_offset_low : in unsigned(11 downto 0);
      mem_address : out unsigned(19 downto 0);
      mem_attention_granted : in std_logic;
      mem_attention_request : out std_logic;
      mem_map_en : out std_logic;
      mem_rdata : in unsigned(7 downto 0);
      mem_read : out std_logic;
      mem_resolve_address : out std_logic;
      mem_wdata : out unsigned(7 downto 0);
      mem_write : out std_logic;
      monitor_char_busy : out std_logic;
      monitor_char_in : in unsigned(7 downto 0);
      monitor_char_out : out unsigned(7 downto 0);
      monitor_char_toggle : in std_logic;
      monitor_char_valid : out std_logic;
      monitor_hyper_trap : out std_logic;
      monitor_hypervisor_mode : in std_logic;
      monitor_irq_inhibit : out std_logic;
      monitor_mem_trace_mode : out std_logic;
      monitor_mem_trace_toggle : out std_logic;
      monitor_p : in unsigned(7 downto 0);
      monitor_pc : in unsigned(15 downto 0);
      monitor_watch : out unsigned(23 downto 0);
      monitor_watch_match : in std_logic;
      pixclk : in std_logic;
      protected_hardware : in unsigned(7 downto 0);
      read : in std_logic;
      reset : in std_logic;
      reset_out : out std_logic;
      rx : in std_logic;
      secure_mode_from_cpu : in std_logic;
      secure_mode_from_monitor : out std_logic;
      set_pc : out std_logic;
      terminal_emulator_ack : in std_logic;
      terminal_emulator_ready : in std_logic;
      tx : out std_logic;
      uart_char : in unsigned(7 downto 0);
      uart_char_valid : in std_logic;
      write : in std_logic
    );
  end component;
  signal activity_Readable : std_logic;  -- Needed to connect outputs
  signal bit_rate_divisor_Readable : unsigned(15 downto 0);  -- Needed to connect outputs
  signal clear_matrix_mode_toggle_Readable : std_logic;  -- Needed to connect outputs
  signal mem_address_Readable : unsigned(19 downto 0);  -- Needed to connect outputs
  signal mem_attention_request_Readable : std_logic;  -- Needed to connect outputs
  signal mem_map_en_Readable : std_logic;  -- Needed to connect outputs
  signal mem_read_Readable : std_logic;  -- Needed to connect outputs
  signal mem_resolve_address_Readable : std_logic;  -- Needed to connect outputs
  signal mem_wdata_Readable : unsigned(7 downto 0);  -- Needed to connect outputs
  signal mem_write_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_char_busy_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_char_out_Readable : unsigned(7 downto 0);  -- Needed to connect outputs
  signal monitor_char_valid_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_hyper_trap_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_irq_inhibit_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_mem_trace_mode_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_mem_trace_toggle_Readable : std_logic;  -- Needed to connect outputs
  signal monitor_watch_Readable : unsigned(23 downto 0);  -- Needed to connect outputs
  signal secure_mode_from_monitor_Readable : std_logic;  -- Needed to connect outputs
  signal set_pc_Readable : std_logic;  -- Needed to connect outputs
  signal tx_Readable : std_logic;  -- Needed to connect outputs
  
  component monitormem is
    port (
      addr : in unsigned(11 downto 0);
      clk : in std_logic;
      di : in unsigned(7 downto 0);
      do : out unsigned(7 downto 0);
      we : in std_logic
    );
  end component;
begin
  key_scancode <= key_scancode_Reg;
  key_scancode_toggle <= key_scancode_toggle_Reg;
  monitor_mem_stage_trace_mode <= monitor_mem_stage_trace_mode_Reg;
  tmp_s3 <= monitor_p;
  tmp_s7 <= monitor_a;
  tmp_s11 <= monitor_x;
  tmp_s15 <= monitor_y;
  tmp_s19 <= monitor_z;
  tmp_s23 <= monitor_pc;
  tmp_s27 <= monitor_cpu_state;
  tmp_s31 <= monitor_waitstates;
  tmp_s35 <= monitor_b;
  tmp_s39 <= monitor_sp;
  tmp_s57 <= fastio_read;
  tmp_s61 <= fastio_write;
  tmp_s65 <= monitor_proceed;
  tmp_s69 <= monitor_mem_attention_granted;
  tmp_s73 <= monitor_request_reflected;
  tmp_s77 <= monitor_interrupt_inhibit;
  tmp_s91 <= monitor_opcode;
  tmp_s95 <= monitor_arg1;
  tmp_s99 <= monitor_arg2;
  tmp_s103 <= monitor_instruction;
  tmp_s107 <= monitor_roms;
  reset_internal <= not reset;
  reset_out <= not reset_out_internal;
  tmp_s43 <= monitor_map_offset_low(8 + 3 downto 8);
  tmp_s44 <= monitor_map_enables_low & tmp_s43;
  tmp_s49 <= monitor_map_offset_low(0 + 7 downto 0);
  tmp_s53 <= monitor_ibytes(0 + 1 downto 0);
  tmp_s81 <= monitor_map_offset_high(8 + 3 downto 8);
  tmp_s82 <= monitor_map_enables_high & tmp_s81;
  tmp_s87 <= monitor_map_offset_high(0 + 7 downto 0);
  tmp_s117 <= cpu_address_next(0 + 3 downto 0);
  history_read_address_lo <= history_read_index & tmp_s117;
  tmp_s121 <= cpu_address_next(0 + 2 downto 0);
  history_read_address_hi <= history_read_index & tmp_s121;
  LPM_q_s127 <= tmp_s124(0);
  LPM_q_s131 <= tmp_s128(0);
  LPM_q_s132 <= history_wdata(0 + 127 downto 0);
  LPM_q_s137 <= tmp_s134(0);
  LPM_q_s141 <= tmp_s138(0);
  LPM_q_s142 <= history_wdata(128 + 63 downto 128);
  LPM_q_s147 <= tmp_s144(0);
  LPM_q_s151 <= tmp_s148(0);
  LPM_q_s152 <= cpu_address_next(0 + 6 downto 0);
  LPM_q_s157 <= tmp_s154 & monitor_cpu_state & monitor_memory_access_address;
  LPM_q_s158 <= cpu_address_next(0 + 11 downto 0);
  LPM_q_s160 <= cpu_address_next(0 + 4 downto 0);
  LPM_q_s162 <= monitor_cpu_state(8 + 7 downto 8);
  LPM_q_s167 <= tmp_s164(0);
  LPM_q_s171 <= tmp_s168(0);
  LPM_q_s175 <= tmp_s172(0);
  history_wdata <= tmp_s110 & tmp_s107 & tmp_s103 & tmp_s99 & tmp_s95 & tmp_s91 & tmp_s87 & tmp_s82 & tmp_s77 & tmp_s73 & tmp_s69 & tmp_s65 & tmp_s61 & tmp_s57 & tmp_s53 & tmp_s49 & tmp_s44 & tmp_s39 & tmp_s35 & tmp_s31 & tmp_s27 & tmp_s23 & tmp_s19 & tmp_s15 & tmp_s11 & tmp_s7 & tmp_s3;
  
  -- Generated from instantiation at monitor/monitor_top.v:173
  cpustateram: asym_ram_sdp
    port map (
      addrA => cpu_state_write_index,
      addrB => LPM_q_s152,
      clkA => clock,
      clkB => clock,
      diA => LPM_q_s157,
      doB => cpu_state_rdata,
      enaA => LPM_q_s147,
      enaB => LPM_q_s151,
      weA => cpu_state_write
    );
  
  -- Generated from instantiation at monitor/monitor_top.v:159
  historyram0: asym_ram_sdp1
    port map (
      addrA => history_write_index,
      addrB => history_read_address_lo,
      clkA => clock,
      clkB => clock,
      diA => LPM_q_s132,
      doB => history_rdata_lo,
      enaA => LPM_q_s127,
      enaB => LPM_q_s131,
      weA => history_write
    );
  
  -- Generated from instantiation at monitor/monitor_top.v:164
  historyram1: asym_ram_sdp2
    port map (
      addrA => history_write_index,
      addrB => history_read_address_hi,
      clkA => clock,
      clkB => clock,
      diA => LPM_q_s142,
      doB => history_rdata_hi,
      enaA => LPM_q_s137,
      enaB => LPM_q_s141,
      weA => history_write
    );
  
  -- Generated from instantiation at monitor/monitor_top.v:218
  monitorbus: monitor_bus
    port map (
      clk => clock,
      cpu_address => cpu_address_next,
      cpu_state => cpu_state_rdata,
      cpu_write => cpu_write_next,
      ctrl => monitor_do,
      ctrl_read => ctrl_read,
      ctrl_write => ctrl_write,
      history_hi => history_rdata_hi,
      history_lo => history_rdata_lo,
      mem => ram_do,
      ram_write => ram_write,
      read_data => cpu_di
    );
  
  -- Generated from instantiation at monitor/monitor_top.v:223
  monitorcpu: cpu6502
    port map (
      address_next => cpu_address_next,
      clk => clock,
      data_i => cpu_di,
      data_o_next => cpu_do,
      irq => LPM_q_s171,
      nmi => LPM_q_s167,
      ready => LPM_q_s175,
      reset => reset_internal,
      write_next => cpu_write_next
    );
  activity <= activity_Readable;
  bit_rate_divisor <= bit_rate_divisor_Readable;
  clear_matrix_mode_toggle <= clear_matrix_mode_toggle_Readable;
  monitor_mem_address <= mem_address_Readable;
  monitor_mem_attention_request <= mem_attention_request_Readable;
  monitor_mem_map_en <= mem_map_en_Readable;
  monitor_mem_read <= mem_read_Readable;
  monitor_mem_resolve_address <= mem_resolve_address_Readable;
  monitor_mem_wdata <= mem_wdata_Readable;
  monitor_mem_write <= mem_write_Readable;
  monitor_char_busy <= monitor_char_busy_Readable;
  monitor_char_out <= monitor_char_out_Readable;
  monitor_char_valid <= monitor_char_valid_Readable;
  monitor_hyper_trap <= monitor_hyper_trap_Readable;
  monitor_irq_inhibit <= monitor_irq_inhibit_Readable;
  monitor_mem_trace_mode <= monitor_mem_trace_mode_Readable;
  monitor_mem_trace_toggle <= monitor_mem_trace_toggle_Readable;
  monitor_watch <= monitor_watch_Readable;
  secure_mode_from_monitor <= secure_mode_from_monitor_Readable;
  monitor_mem_setpc <= set_pc_Readable;
  tx <= tx_Readable;
  
  -- Generated from instantiation at monitor/monitor_top.v:184
  monitorctrl: monitor_ctrl
    port map (
      activity => activity_Readable,
      address => LPM_q_s160,
      bit_rate_divisor => bit_rate_divisor_Readable,
      clear_matrix_mode_toggle => clear_matrix_mode_toggle_Readable,
      clk => clock,
      cpu_state => LPM_q_s162,
      cpu_state_write => cpu_state_write,
      cpu_state_write_index => cpu_state_write_index,
      di => cpu_do,
      do => monitor_do,
      history_read_index => history_read_index,
      history_write => history_write,
      history_write_index => history_write_index,
      map_enables_high => monitor_map_enables_high,
      map_enables_low => monitor_map_enables_low,
      map_offset_high => monitor_map_offset_high,
      map_offset_low => monitor_map_offset_low,
      mem_address => mem_address_Readable,
      mem_attention_granted => monitor_mem_attention_granted,
      mem_attention_request => mem_attention_request_Readable,
      mem_map_en => mem_map_en_Readable,
      mem_rdata => monitor_mem_rdata,
      mem_read => mem_read_Readable,
      mem_resolve_address => mem_resolve_address_Readable,
      mem_wdata => mem_wdata_Readable,
      mem_write => mem_write_Readable,
      monitor_char_busy => monitor_char_busy_Readable,
      monitor_char_in => monitor_char,
      monitor_char_out => monitor_char_out_Readable,
      monitor_char_toggle => monitor_char_toggle,
      monitor_char_valid => monitor_char_valid_Readable,
      monitor_hyper_trap => monitor_hyper_trap_Readable,
      monitor_hypervisor_mode => monitor_hypervisor_mode,
      monitor_irq_inhibit => monitor_irq_inhibit_Readable,
      monitor_mem_trace_mode => monitor_mem_trace_mode_Readable,
      monitor_mem_trace_toggle => monitor_mem_trace_toggle_Readable,
      monitor_p => monitor_p,
      monitor_pc => monitor_pc,
      monitor_watch => monitor_watch_Readable,
      monitor_watch_match => monitor_watch_match,
      pixclk => pixclock,
      protected_hardware => protected_hardware_in,
      read => ctrl_read,
      reset => reset_internal,
      reset_out => reset_out_internal,
      rx => rx,
      secure_mode_from_cpu => secure_mode_from_cpu,
      secure_mode_from_monitor => secure_mode_from_monitor_Readable,
      set_pc => set_pc_Readable,
      terminal_emulator_ack => terminal_emulator_ack,
      terminal_emulator_ready => terminal_emulator_ready,
      tx => tx_Readable,
      uart_char => uart_char,
      uart_char_valid => uart_char_valid,
      write => ctrl_write
    );
  
  -- Generated from instantiation at monitor/monitor_top.v:179
  monitormem_inst: monitormem
    port map (
      addr => LPM_q_s158,
      clk => clock,
      di => cpu_do,
      do => ram_do,
      we => ram_write
    );
  tmp_s110 <= X"00";
  tmp_s124 <= X"00000001";
  tmp_s128 <= X"00000001";
  tmp_s134 <= X"00000001";
  tmp_s138 <= X"00000001";
  tmp_s144 <= X"00000001";
  tmp_s148 <= X"00000001";
  tmp_s154 <= X"0000";
  tmp_s164 <= X"00000000";
  tmp_s168 <= X"00000000";
  tmp_s172 <= X"00000001";
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 4
--   ADDRWIDTHB = 7
--   RATIO = 8
--   SIZEA = 16
--   SIZEB = 128
--   WIDTHA = 64
--   WIDTHB = 8
--   log2RATIO = 3
--   maxSIZE = 128
--   maxWIDTH = 64
--   minWIDTH = 8
entity asym_ram_sdp is
  port (
    addrA : in unsigned(3 downto 0);
    addrB : in unsigned(6 downto 0);
    clkA : in std_logic;
    clkB : in std_logic;
    diA : in unsigned(63 downto 0);
    doB : out unsigned(7 downto 0);
    enaA : in std_logic;
    enaB : in std_logic;
    weA : in std_logic
  );
end entity; 

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 4
--   ADDRWIDTHB = 7
--   RATIO = 8
--   SIZEA = 16
--   SIZEB = 128
--   WIDTHA = 64
--   WIDTHB = 8
--   log2RATIO = 3
--   maxSIZE = 128
--   maxWIDTH = 64
--   minWIDTH = 8
architecture from_verilog of asym_ram_sdp is
  function log2 (
    value : signed(31 downto 0)
  ) 
  return signed;
  
  type RAM_Type is array (127 downto 0) of unsigned(7 downto 0);
  signal RAM : RAM_Type;  -- Declared at monitor/asym_ram_sdp.v:48
  signal readB : unsigned(7 downto 0);  -- Declared at monitor/asym_ram_sdp.v:49
  
  -- Generated from function log2 at monitor/asym_ram_sdp.v:24
  function log2 (
    value : signed(31 downto 0)
  ) 
  return signed is
    variable log2_Result : signed(31 downto 0);
    variable res : signed(31 downto 0);
    variable shifted : unsigned(31 downto 0);
  begin
    if value < X"00000002" then
      log2_Result := value;
    else
      shifted := unsigned(value - X"00000001");
      res := X"00000000";
      while shifted > X"00000000" loop
        shifted := shifted srl 1;
        res := res + X"00000001";
      end loop;
      log2_Result := res;
    end if;
    return log2_Result;
  end function;
begin
  doB <= readB;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:51)
  process (clkB) is
  begin
    if rising_edge(clkB) then
      if enaB = '1' then
        readB <= RAM(To_Integer(Resize(addrB, 9)));
      end if;
    end if;
  end process;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:58)
  process (clkB) is
    variable i : signed(31 downto 0);
    variable lsbaddr : unsigned(2 downto 0);
  begin
    if rising_edge(clkB) then
      i := X"00000000";
      while unsigned(i) < X"00000008" loop
        lsbaddr := Resize(unsigned(i), 3);
        if enaA = '1' then
          if weA = '1' then
            RAM(To_Integer(Resize(addrA & lsbaddr, 9))) <= diA(To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111") + 7 downto To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111"));
          end if;
        end if;
        i := i + X"00000001";
      end loop;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 10
--   ADDRWIDTHB = 14
--   RATIO = 16
--   SIZEA = 1024
--   SIZEB = 16384
--   WIDTHA = 128
--   WIDTHB = 8
--   log2RATIO = 4
--   maxSIZE = 16384
--   maxWIDTH = 128
--   minWIDTH = 8
entity asym_ram_sdp1 is
  port (
    addrA : in unsigned(9 downto 0);
    addrB : in unsigned(13 downto 0);
    clkA : in std_logic;
    clkB : in std_logic;
    diA : in unsigned(127 downto 0);
    doB : out unsigned(7 downto 0);
    enaA : in std_logic;
    enaB : in std_logic;
    weA : in std_logic
  );
end entity; 

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 10
--   ADDRWIDTHB = 14
--   RATIO = 16
--   SIZEA = 1024
--   SIZEB = 16384
--   WIDTHA = 128
--   WIDTHB = 8
--   log2RATIO = 4
--   maxSIZE = 16384
--   maxWIDTH = 128
--   minWIDTH = 8
architecture from_verilog of asym_ram_sdp1 is
  type RAM_Type is array (16383 downto 0) of unsigned(7 downto 0);
  signal RAM : RAM_Type;  -- Declared at monitor/asym_ram_sdp.v:48
  signal readB : unsigned(7 downto 0);  -- Declared at monitor/asym_ram_sdp.v:49
begin
  doB <= readB;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:51)
  process (clkB) is
  begin
    if rising_edge(clkB) then
      if enaB = '1' then
        readB <= RAM(To_Integer(Resize(addrB, 16)));
      end if;
    end if;
  end process;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:58)
  process (clkB) is
    variable i : signed(31 downto 0);
    variable lsbaddr : unsigned(3 downto 0);
  begin
    if rising_edge(clkB) then
      i := X"00000000";
      while unsigned(i) < X"00000010" loop
        lsbaddr := Resize(unsigned(i), 4);
        if enaA = '1' then
          if weA = '1' then
            RAM(To_Integer(Resize(addrA & lsbaddr, 16))) <= diA(To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111") + 7 downto To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111"));
          end if;
        end if;
        i := i + X"00000001";
      end loop;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 10
--   ADDRWIDTHB = 13
--   RATIO = 8
--   SIZEA = 1024
--   SIZEB = 8192
--   WIDTHA = 64
--   WIDTHB = 8
--   log2RATIO = 3
--   maxSIZE = 8192
--   maxWIDTH = 64
--   minWIDTH = 8
entity asym_ram_sdp2 is
  port (
    addrA : in unsigned(9 downto 0);
    addrB : in unsigned(12 downto 0);
    clkA : in std_logic;
    clkB : in std_logic;
    diA : in unsigned(63 downto 0);
    doB : out unsigned(7 downto 0);
    enaA : in std_logic;
    enaB : in std_logic;
    weA : in std_logic
  );
end entity; 

-- Generated from Verilog module asym_ram_sdp (monitor/asym_ram_sdp.v:5)
--   ADDRWIDTHA = 10
--   ADDRWIDTHB = 13
--   RATIO = 8
--   SIZEA = 1024
--   SIZEB = 8192
--   WIDTHA = 64
--   WIDTHB = 8
--   log2RATIO = 3
--   maxSIZE = 8192
--   maxWIDTH = 64
--   minWIDTH = 8
architecture from_verilog of asym_ram_sdp2 is
  type RAM_Type is array (8191 downto 0) of unsigned(7 downto 0);
  signal RAM : RAM_Type;  -- Declared at monitor/asym_ram_sdp.v:48
  signal readB : unsigned(7 downto 0);  -- Declared at monitor/asym_ram_sdp.v:49
begin
  doB <= readB;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:51)
  process (clkB) is
  begin
    if rising_edge(clkB) then
      if enaB = '1' then
        readB <= RAM(To_Integer(Resize(addrB, 15)));
      end if;
    end if;
  end process;
  
  -- Generated from always process in asym_ram_sdp (monitor/asym_ram_sdp.v:58)
  process (clkB) is
    variable i : signed(31 downto 0);
    variable lsbaddr : unsigned(2 downto 0);
  begin
    if rising_edge(clkB) then
      i := X"00000000";
      while unsigned(i) < X"00000008" loop
        lsbaddr := Resize(unsigned(i), 3);
        if enaA = '1' then
          if weA = '1' then
            RAM(To_Integer(Resize(addrA & lsbaddr, 15))) <= diA(To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111") + 7 downto To_Integer(Resize(signed(Resize((((unsigned(i) + X"00000001") * X"00000008") - X"0000000000000001"), 34)), 34) - "0000000000000000000000000000000111"));
          end if;
        end if;
        i := i + X"00000001";
      end loop;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module monitor_bus (monitor/monitor_bus.v:8)
entity monitor_bus is
  port (
    clk : in std_logic;
    cpu_address : in unsigned(15 downto 0);
    cpu_state : in unsigned(7 downto 0);
    cpu_write : in std_logic;
    ctrl : in unsigned(7 downto 0);
    ctrl_read : out std_logic;
    ctrl_write : out std_logic;
    history_hi : in unsigned(7 downto 0);
    history_lo : in unsigned(7 downto 0);
    mem : in unsigned(7 downto 0);
    ram_write : out std_logic;
    read_data : out unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module monitor_bus (monitor/monitor_bus.v:8)
architecture from_verilog of monitor_bus is
  signal ctrl_read_Reg : std_logic;
  signal ctrl_write_Reg : std_logic;
  signal ram_write_Reg : std_logic;
  signal read_data_Reg : unsigned(7 downto 0);
  signal read_select : unsigned(2 downto 0);  -- Declared at monitor/monitor_bus.v:12
  signal read_select_reg : unsigned(2 downto 0);  -- Declared at monitor/monitor_bus.v:13
begin
  ctrl_read <= ctrl_read_Reg;
  ctrl_write <= ctrl_write_Reg;
  ram_write <= ram_write_Reg;
  read_data <= read_data_Reg;
  
  -- Generated from always process in monitor_bus (monitor/monitor_bus.v:16)
  process (cpu_address, cpu_write) is
  begin
    read_select <= "000";
    ram_write_Reg <= '0';
    ctrl_write_Reg <= '0';
    ctrl_read_Reg <= '0';
    -- Generated from casez statement at monitor/monitor_bus.v:22
    if ((cpu_address(9) = 'Z') or (cpu_address(9) = '0')) and ((cpu_address(10) = 'Z') or (cpu_address(10) = '0')) and ((cpu_address(11) = 'Z') or (cpu_address(11) = '0')) and ((cpu_address(12) = 'Z') or (cpu_address(12) = '0')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '0')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '0')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '0')) then
      read_select <= "001";
      ram_write_Reg <= cpu_write;
    elsif ((cpu_address(12) = 'Z') or (cpu_address(12) = '1')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '1')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '1')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '0')) then
      read_select <= "101";
    elsif ((cpu_address(4) = 'Z') or (cpu_address(4) = '0')) and ((cpu_address(12) = 'Z') or (cpu_address(12) = '0')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '0')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '0')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '1')) then
      read_select <= "010";
    elsif ((cpu_address(3) = 'Z') or (cpu_address(3) = '0')) and ((cpu_address(4) = 'Z') or (cpu_address(4) = '1')) and ((cpu_address(12) = 'Z') or (cpu_address(12) = '0')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '0')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '0')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '1')) then
      read_select <= "011";
    elsif ((cpu_address(12) = 'Z') or (cpu_address(12) = '1')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '0')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '0')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '1')) then
      read_select <= "100";
      ctrl_write_Reg <= cpu_write;
      ctrl_read_Reg <= not cpu_write;
    elsif ((cpu_address(12) = 'Z') or (cpu_address(12) = '1')) and ((cpu_address(13) = 'Z') or (cpu_address(13) = '1')) and ((cpu_address(14) = 'Z') or (cpu_address(14) = '1')) and ((cpu_address(15) = 'Z') or (cpu_address(15) = '1')) then
      read_select <= "001";
    else
      read_select <= "000";
    end if;
  end process;
  
  -- Generated from always process in monitor_bus (monitor/monitor_bus.v:35)
  process (clk) is
  begin
    if rising_edge(clk) then
      read_select_reg <= read_select;
    end if;
  end process;
  
  -- Generated from always process in monitor_bus (monitor/monitor_bus.v:41)
  process (read_select_reg, mem, history_lo, history_hi, ctrl, cpu_state) is
  begin
    case read_select_reg is
      when "000" =>
        read_data_Reg <= X"00";
      when "001" =>
        read_data_Reg <= mem;
      when "010" =>
        read_data_Reg <= history_lo;
      when "011" =>
        read_data_Reg <= history_hi;
      when "100" =>
        read_data_Reg <= ctrl;
      when "101" =>
        read_data_Reg <= cpu_state;
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module cpu6502 (6502/6502_top.v:25)
entity cpu6502 is
  port (
    address : buffer unsigned(15 downto 0);
    address_next : out unsigned(15 downto 0);
    clk : in std_logic;
    cpu_int : out std_logic;
    cpu_state : out unsigned(7 downto 0);
    data_i : in unsigned(7 downto 0);
    data_o : out unsigned(7 downto 0);
    data_o_next : out unsigned(7 downto 0);
    irq : in std_logic;
    nmi : in std_logic;
    ready : in std_logic;
    reset : in std_logic;
    sync : buffer std_logic;
    t : out unsigned(2 downto 0);
    write : out std_logic;
    write_next : buffer std_logic
  );
end entity; 

-- Generated from Verilog module cpu6502 (6502/6502_top.v:25)
architecture from_verilog of cpu6502 is
  signal write_Reg : std_logic;
  signal tmp_s10 : std_logic;  -- Temporary created at 6502/6502_top.v:139
  signal tmp_s100 : unsigned(3 downto 0);  -- Temporary created at 6502/6502_top.v:199
  signal tmp_s102 : std_logic;  -- Temporary created at 6502/6502_top.v:199
  signal tmp_s107 : std_logic;  -- Temporary created at 6502/6502_top.v:201
  signal tmp_s109 : std_logic;  -- Temporary created at 6502/6502_top.v:201
  signal tmp_s12 : std_logic;  -- Temporary created at 6502/6502_top.v:139
  signal tmp_s23 : std_logic;  -- Temporary created at 6502/6502_top.v:153
  signal tmp_s26 : std_logic;  -- Temporary created at 6502/6502_top.v:155
  signal tmp_s36 : std_logic;  -- Temporary created at 6502/6502_top.v:165
  signal tmp_s44 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:185
  signal tmp_s47 : unsigned(28 downto 0);  -- Temporary created at 6502/6502_top.v:185
  signal tmp_s48 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:185
  signal tmp_s50 : std_logic;  -- Temporary created at 6502/6502_top.v:185
  signal tmp_s54 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:186
  signal tmp_s57 : unsigned(29 downto 0);  -- Temporary created at 6502/6502_top.v:186
  signal tmp_s58 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:186
  signal tmp_s60 : std_logic;  -- Temporary created at 6502/6502_top.v:186
  signal tmp_s72 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:194
  signal tmp_s75 : unsigned(28 downto 0);  -- Temporary created at 6502/6502_top.v:194
  signal tmp_s76 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_top.v:194
  signal tmp_s78 : std_logic;  -- Temporary created at 6502/6502_top.v:194
  signal tmp_s83 : std_logic;  -- Temporary created at 6502/6502_top.v:198
  signal tmp_s85 : std_logic;  -- Temporary created at 6502/6502_top.v:198
  signal tmp_s86 : std_logic;  -- Temporary created at 6502/6502_top.v:198
  signal tmp_s88 : unsigned(3 downto 0);  -- Temporary created at 6502/6502_top.v:198
  signal tmp_s90 : std_logic;  -- Temporary created at 6502/6502_top.v:198
  signal tmp_s95 : std_logic;  -- Temporary created at 6502/6502_top.v:199
  signal tmp_s97 : std_logic;  -- Temporary created at 6502/6502_top.v:199
  signal tmp_s98 : std_logic;  -- Temporary created at 6502/6502_top.v:199
  signal abh : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:63
  signal abh_next : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:61
  signal abl : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:64
  signal abl_next : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:62
  signal adh_sel : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:32
  signal adl_abl : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:57
  signal adl_sel : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:33
  signal alu_a : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:39
  signal alu_b : unsigned(1 downto 0);  -- Declared at 6502/6502_top.v:40
  signal alu_c : unsigned(1 downto 0);  -- Declared at 6502/6502_top.v:41
  signal alu_carry_out : std_logic;  -- Declared at 6502/6502_top.v:92
  signal alu_carry_out_last : std_logic;  -- Declared at 6502/6502_top.v:117
  signal alu_half_carry_out : std_logic;  -- Declared at 6502/6502_top.v:92
  signal alu_op : unsigned(3 downto 0);  -- Declared at 6502/6502_top.v:38
  signal alu_out : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:84
  signal alu_overflow_out : std_logic;  -- Declared at 6502/6502_top.v:117
  signal alua : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:81
  signal alub : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:82
  signal alucs : std_logic;  -- Declared at 6502/6502_top.v:83
  signal branch_page_cross : std_logic;  -- Declared at 6502/6502_top.v:86
  signal db_in : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:54
  signal db_out : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:55
  signal db_sel : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:34
  signal dec_add : std_logic;  -- Declared at 6502/6502_top.v:91
  signal dec_sub : std_logic;  -- Declared at 6502/6502_top.v:91
  signal decimal_cycle : std_logic;  -- Declared at 6502/6502_top.v:103
  signal decimal_extra_cycle : std_logic;  -- Declared at 6502/6502_top.v:105
  signal dor : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:68
  signal intg : std_logic;  -- Declared at 6502/6502_top.v:107
  signal ir : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:67
  signal ir_dec : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:180
  signal ir_next : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:88
  signal last_fetch_addr : unsigned(15 downto 0);  -- Declared at 6502/6502_top.v:222
  signal load_a : std_logic;  -- Declared at 6502/6502_top.v:42
  signal load_abh : std_logic;  -- Declared at 6502/6502_top.v:46
  signal load_abl : std_logic;  -- Declared at 6502/6502_top.v:47
  signal load_flag_decode : unsigned(14 downto 0);  -- Declared at 6502/6502_top.v:51
  signal load_flags : unsigned(3 downto 0);  -- Declared at 6502/6502_top.v:50
  signal load_s : std_logic;  -- Declared at 6502/6502_top.v:45
  signal load_x : std_logic;  -- Declared at 6502/6502_top.v:43
  signal load_y : std_logic;  -- Declared at 6502/6502_top.v:44
  signal nmig : std_logic;  -- Declared at 6502/6502_top.v:108
  signal onecycle : std_logic;  -- Declared at 6502/6502_top.v:101
  signal pc_hold : std_logic;  -- Declared at 6502/6502_top.v:110
  signal pc_inc : std_logic;  -- Declared at 6502/6502_top.v:49
  signal pch : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:65
  signal pchs : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:99
  signal pchs_sel : std_logic;  -- Declared at 6502/6502_top.v:36
  signal pcl : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:66
  signal pcl_carry : std_logic;  -- Declared at 6502/6502_top.v:97
  signal pcls : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:96
  signal pcls_sel : std_logic;  -- Declared at 6502/6502_top.v:37
  signal ready_i : std_logic;  -- Declared at 6502/6502_top.v:94
  signal reg_a : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:72
  signal reg_p : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:76
  signal reg_s : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:75
  signal reg_x : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:73
  signal reg_y : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:74
  signal resp : std_logic;  -- Declared at 6502/6502_top.v:109
  signal sb : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:58
  signal sb_n : std_logic;  -- Declared at 6502/6502_top.v:215
  signal sb_sel : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:35
  signal sb_z : std_logic;  -- Declared at 6502/6502_top.v:214
  signal t_next : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:31
  signal taken_branch : std_logic;  -- Declared at 6502/6502_top.v:87
  signal tnext_mc : unsigned(2 downto 0);  -- Declared at 6502/6502_top.v:30
  signal twocycle : std_logic;  -- Declared at 6502/6502_top.v:102
  signal vector_lo : unsigned(7 downto 0);  -- Declared at 6502/6502_top.v:114
  signal write_allowed : std_logic;  -- Declared at 6502/6502_top.v:104
  signal write_cycle : std_logic;  -- Declared at 6502/6502_top.v:48
  signal LO_s29 : std_logic;
  signal LO_s35 : std_logic;
  signal LO_s39 : std_logic;
  signal LO_s53 : std_logic;
  signal LO_s63 : std_logic;
  signal LO_s67 : std_logic;
  signal LO_s69 : std_logic;
  signal LO_s71 : std_logic;
  signal LO_s81 : std_logic;
  signal LO_s117 : std_logic;
  signal LPM_q_s4 : unsigned(2 downto 0);
  signal LPM_q_s30 : std_logic;
  signal LPM_q_s32 : std_logic;
  signal LPM_q_s40 : std_logic;
  signal LPM_q_s42 : unsigned(2 downto 0);
  signal LPM_q_s64 : std_logic;
  
  function Reduce_OR(X : std_logic_vector) return std_logic is
    variable R : std_logic := '0';
  begin
    for I in X'Range loop
      R := X(I) or R;
    end loop;
    return R;
  end function;
  signal LPM_q_s118 : std_logic;
  
  component a_reg is
    port (
      carry_in : in std_logic;
      clk : in std_logic;
      dec_add : in std_logic;
      dec_in : in unsigned(7 downto 0);
      dec_sub : in std_logic;
      half_carry_in : in std_logic;
      load_a : in std_logic;
      reg_a : out unsigned(7 downto 0)
    );
  end component;
  
  component adh_abh_reg is
    port (
      abh : out unsigned(7 downto 0);
      abh_next : out unsigned(7 downto 0);
      adh_sel : in unsigned(2 downto 0);
      alu : in unsigned(7 downto 0);
      clk : in std_logic;
      data_i : in unsigned(7 downto 0);
      load_abh : in std_logic;
      pchs : in unsigned(7 downto 0);
      ready : in std_logic
    );
  end component;
  
  component adh_pch_reg is
    port (
      adh_sel : in unsigned(2 downto 0);
      alu : in unsigned(7 downto 0);
      clk : in std_logic;
      data_i : in unsigned(7 downto 0);
      pch : out unsigned(7 downto 0);
      pch_carry : out std_logic;
      pchs : out unsigned(7 downto 0);
      pchs_sel : in std_logic;
      pcl_carry : in std_logic;
      ready : in std_logic
    );
  end component;
  
  component adl_abl_reg is
    port (
      abl : out unsigned(7 downto 0);
      abl_next : out unsigned(7 downto 0);
      adl_abl : out unsigned(7 downto 0);
      adl_sel : in unsigned(2 downto 0);
      alu : in unsigned(7 downto 0);
      clk : in std_logic;
      data_i : in unsigned(7 downto 0);
      load_abl : in std_logic;
      pcls : in unsigned(7 downto 0);
      ready : in std_logic;
      reg_s : in unsigned(7 downto 0);
      vector_lo : in unsigned(7 downto 0)
    );
  end component;
  
  component adl_pcl_reg is
    port (
      adl_sel : in unsigned(2 downto 0);
      alu : in unsigned(7 downto 0);
      clk : in std_logic;
      pc_inc : in std_logic;
      pcl : out unsigned(7 downto 0);
      pcl_carry : out std_logic;
      pcls : out unsigned(7 downto 0);
      pcls_sel : in std_logic;
      ready : in std_logic;
      reg_s : in unsigned(7 downto 0)
    );
  end component;
  
  component alu_unit is
    port (
      a : in unsigned(7 downto 0);
      alu_carry_out_last : out std_logic;
      alu_out : out unsigned(7 downto 0);
      b : in unsigned(7 downto 0);
      c_in : in std_logic;
      carry_out : out std_logic;
      clk : in std_logic;
      dec_add : in std_logic;
      half_carry_out : out std_logic;
      op : in unsigned(3 downto 0);
      overflow_out : out std_logic;
      ready : in std_logic
    );
  end component;
  
  component alua_mux is
    port (
      alu_a : in unsigned(2 downto 0);
      alua : out unsigned(7 downto 0);
      clk : in std_logic;
      ir_dec : in unsigned(7 downto 0);
      ready : in std_logic;
      sb : in unsigned(7 downto 0)
    );
  end component;
  
  component alub_mux is
    port (
      adl : in unsigned(7 downto 0);
      alu_b : in unsigned(1 downto 0);
      alub : out unsigned(7 downto 0);
      clk : in std_logic;
      db : in unsigned(7 downto 0);
      ready : in std_logic
    );
  end component;
  
  component aluc_mux is
    port (
      alu_c : in unsigned(1 downto 0);
      carry : in std_logic;
      carrys : out std_logic;
      last_carry : in std_logic
    );
  end component;
  
  component branch_control is
    port (
      ir : in unsigned(2 downto 0);
      reg_p : in unsigned(7 downto 0);
      taken_branch : out std_logic
    );
  end component;
  
  component db_in_mux is
    port (
      alua_highbit : in std_logic;
      data_i : in unsigned(7 downto 0);
      db_in : out unsigned(7 downto 0);
      db_sel : in unsigned(2 downto 0);
      reg_a : in unsigned(7 downto 0)
    );
  end component;
  
  component db_out_mux is
    port (
      db_out : out unsigned(7 downto 0);
      db_sel : in unsigned(2 downto 0);
      pch : in unsigned(7 downto 0);
      pcl : in unsigned(7 downto 0);
      reg_a : in unsigned(7 downto 0);
      reg_p : in unsigned(7 downto 0);
      sb : in unsigned(7 downto 0)
    );
  end component;
  
  component decoder3to8 is
    port (
      index : in unsigned(2 downto 0);
      outbits : out unsigned(7 downto 0)
    );
  end component;
  
  component clocked_reg8 is
    port (
      clk : in std_logic;
      ready : in std_logic;
      register_in : in unsigned(7 downto 0);
      register_out : out unsigned(7 downto 0)
    );
  end component;
  
  component flags_decode is
    port (
      load_flags : in unsigned(3 downto 0);
      load_flags_decode : out unsigned(14 downto 0)
    );
  end component;
  
  component interrupt_control is
    port (
      clk : in std_logic;
      intg : out std_logic;
      irq : in std_logic;
      load_i : in std_logic;
      nmi : in std_logic;
      nmig : out std_logic;
      reg_p : in unsigned(7 downto 0);
      reset : in std_logic;
      resp : out std_logic;
      t : in unsigned(2 downto 0);
      tnext_mc : in unsigned(2 downto 0);
      vector_lo : out unsigned(7 downto 0)
    );
  end component;
  signal t_Readable : unsigned(2 downto 0);  -- Needed to connect outputs
  
  component ir_next_mux is
    port (
      data_i : in unsigned(7 downto 0);
      intg : in std_logic;
      ir : in unsigned(7 downto 0);
      ir_next : out unsigned(7 downto 0);
      sync : in std_logic
    );
  end component;
  signal sync_Readable : std_logic;  -- Needed to connect outputs
  
  component clocked_reset_reg8 is
    port (
      clk : in std_logic;
      ready : in std_logic;
      register_in : in unsigned(7 downto 0);
      register_out : out unsigned(7 downto 0);
      reset : in std_logic
    );
  end component;
  
  component microcode is
    port (
      adh_sel : out unsigned(2 downto 0);
      adl_sel : out unsigned(2 downto 0);
      alu_a : out unsigned(2 downto 0);
      alu_b : out unsigned(1 downto 0);
      alu_c : out unsigned(1 downto 0);
      alu_op : out unsigned(3 downto 0);
      clk : in std_logic;
      db_sel : out unsigned(2 downto 0);
      ir : in unsigned(7 downto 0);
      load_a : out std_logic;
      load_abh : out std_logic;
      load_abl : out std_logic;
      load_flags : out unsigned(3 downto 0);
      load_s : out std_logic;
      load_x : out std_logic;
      load_y : out std_logic;
      pc_inc : out std_logic;
      pchs_sel : out std_logic;
      pcls_sel : out std_logic;
      ready : in std_logic;
      sb_sel : out unsigned(2 downto 0);
      t : in unsigned(2 downto 0);
      tnext : out unsigned(2 downto 0);
      write_cycle : out std_logic
    );
  end component;
  
  component p_reg is
    port (
      carry : in std_logic;
      clk : in std_logic;
      db_in : in unsigned(7 downto 0);
      intg : in std_logic;
      ir5 : in std_logic;
      load_b : in std_logic;
      load_flag_decode : in unsigned(14 downto 0);
      overflow : in std_logic;
      ready : in std_logic;
      reg_p : out unsigned(7 downto 0);
      reset : in std_logic;
      sb_n : in std_logic;
      sb_z : in std_logic
    );
  end component;
  
  component predecode is
    port (
      active : in std_logic;
      ir_next : in unsigned(7 downto 0);
      onecycle : out std_logic;
      twocycle : out std_logic
    );
  end component;
  
  component sb_mux is
    port (
      alu : in unsigned(7 downto 0);
      db : in unsigned(7 downto 0);
      pch : in unsigned(7 downto 0);
      reg_a : in unsigned(7 downto 0);
      reg_s : in unsigned(7 downto 0);
      reg_x : in unsigned(7 downto 0);
      reg_y : in unsigned(7 downto 0);
      sb : out unsigned(7 downto 0);
      sb_sel : in unsigned(2 downto 0)
    );
  end component;
  
  component timing_ctrl is
    port (
      alu_carry_out : in std_logic;
      branch_page_cross : in std_logic;
      clk : in std_logic;
      decimal_cycle : in std_logic;
      decimal_extra_cycle : buffer std_logic;
      intg : in std_logic;
      load_sbz : in std_logic;
      onecycle : in std_logic;
      pc_hold : out std_logic;
      ready : in std_logic;
      reset : in std_logic;
      sync : buffer std_logic;
      t : out unsigned(2 downto 0);
      t_next : out unsigned(2 downto 0);
      taken_branch : in std_logic;
      tnext_mc : in unsigned(2 downto 0);
      twocycle : in std_logic;
      write_allowed : out std_logic
    );
  end component;
begin
  write <= write_Reg;
  cpu_int <= intg;
  ready_i <= ready or write_next;
  tmp_s10 <= not resp;
  tmp_s12 <= write_cycle and tmp_s10;
  write_next <= tmp_s12 and write_allowed;
  data_o <= dor;
  data_o_next <= db_out;
  cpu_state <= ir;
  branch_page_cross <= alu_carry_out xor tmp_s23;
  tmp_s26 <= not intg;
  LO_s29 <= sync and tmp_s26;
  LO_s35 <= sync and ready_i;
  tmp_s36 <= not pc_hold;
  LO_s39 <= pc_inc and tmp_s36;
  LO_s53 <= tmp_s50 and ready_i;
  LO_s63 <= tmp_s60 and ready_i;
  LO_s67 <= load_x and ready_i;
  LO_s69 <= load_y and ready_i;
  LO_s71 <= load_s and ready_i;
  LO_s81 <= tmp_s78 and ready_i;
  tmp_s86 <= tmp_s83 and tmp_s85;
  dec_add <= tmp_s86 and tmp_s90;
  tmp_s98 <= tmp_s95 and tmp_s97;
  dec_sub <= tmp_s98 and tmp_s102;
  decimal_cycle <= tmp_s107 and tmp_s109;
  LO_s117 <= sync and ready_i;
  LPM_q_s4 <= ir(5 + 2 downto 5);
  address <= abh & abl;
  address_next <= abh_next & abl_next;
  tmp_s23 <= alua(7);
  LPM_q_s30 <= load_flag_decode(14);
  LPM_q_s32 <= load_flag_decode(3);
  LPM_q_s40 <= alua(7);
  LPM_q_s42 <= ir(4 + 2 downto 4);
  tmp_s44 <= tmp_s47 & alu_a;
  tmp_s50 <= '1' when tmp_s44 /= tmp_s48 else '0';
  tmp_s54 <= tmp_s57 & alu_b;
  tmp_s60 <= '1' when tmp_s54 /= tmp_s58 else '0';
  LPM_q_s64 <= reg_p(0);
  tmp_s72 <= tmp_s75 & db_sel;
  tmp_s78 <= '1' when tmp_s72 /= tmp_s76 else '0';
  tmp_s83 <= reg_p(3);
  tmp_s85 <= load_flag_decode(10);
  tmp_s90 <= '1' when alu_op = tmp_s88 else '0';
  tmp_s95 <= reg_p(3);
  tmp_s97 <= load_flag_decode(10);
  tmp_s102 <= '1' when alu_op = tmp_s100 else '0';
  tmp_s107 <= reg_p(3);
  tmp_s109 <= load_flag_decode(10);
  sb_z <= not Reduce_OR(std_logic_vector(sb));
  sb_n <= sb(7);
  LPM_q_s118 <= ir(5);
  
  -- Generated from instantiation at 6502/6502_top.v:189
  a_reg_inst: a_reg
    port map (
      carry_in => alu_carry_out,
      clk => clk,
      dec_add => dec_add,
      dec_in => sb,
      dec_sub => dec_sub,
      half_carry_in => alu_half_carry_out,
      load_a => load_a,
      reg_a => reg_a
    );
  
  -- Generated from instantiation at 6502/6502_top.v:178
  adh_abh_reg_inst: adh_abh_reg
    port map (
      abh => abh,
      abh_next => abh_next,
      adh_sel => adh_sel,
      alu => alu_out,
      clk => clk,
      data_i => data_i,
      load_abh => load_abh,
      pchs => pchs,
      ready => ready_i
    );
  
  -- Generated from instantiation at 6502/6502_top.v:177
  adh_pch_reg_inst: adh_pch_reg
    port map (
      adh_sel => adh_sel,
      alu => alu_out,
      clk => clk,
      data_i => data_i,
      pch => pch,
      pchs => pchs,
      pchs_sel => pchs_sel,
      pcl_carry => pcl_carry,
      ready => ready_i
    );
  
  -- Generated from instantiation at 6502/6502_top.v:168
  adl_abl_reg_inst: adl_abl_reg
    port map (
      abl => abl,
      abl_next => abl_next,
      adl_abl => adl_abl,
      adl_sel => adl_sel,
      alu => alu_out,
      clk => clk,
      data_i => data_i,
      load_abl => load_abl,
      pcls => pcls,
      ready => ready_i,
      reg_s => reg_s,
      vector_lo => vector_lo
    );
  
  -- Generated from instantiation at 6502/6502_top.v:165
  adl_pcl_reg_inst: adl_pcl_reg
    port map (
      adl_sel => adl_sel,
      alu => alu_out,
      clk => clk,
      pc_inc => LO_s39,
      pcl => pcl,
      pcl_carry => pcl_carry,
      pcls => pcls,
      pcls_sel => pcls_sel,
      ready => ready_i,
      reg_s => reg_s
    );
  
  -- Generated from instantiation at 6502/6502_top.v:117
  alu_inst: alu_unit
    port map (
      a => alua,
      alu_carry_out_last => alu_carry_out_last,
      alu_out => alu_out,
      b => alub,
      c_in => alucs,
      carry_out => alu_carry_out,
      clk => clk,
      dec_add => dec_add,
      half_carry_out => alu_half_carry_out,
      op => alu_op,
      overflow_out => alu_overflow_out,
      ready => ready_i
    );
  
  -- Generated from instantiation at 6502/6502_top.v:185
  alua_mux_inst: alua_mux
    port map (
      alu_a => alu_a,
      alua => alua,
      clk => clk,
      ir_dec => ir_dec,
      ready => LO_s53,
      sb => sb
    );
  
  -- Generated from instantiation at 6502/6502_top.v:186
  alub_mux_inst: alub_mux
    port map (
      adl => adl_abl,
      alu_b => alu_b,
      alub => alub,
      clk => clk,
      db => db_in,
      ready => LO_s63
    );
  
  -- Generated from instantiation at 6502/6502_top.v:187
  aluc_mux_inst: aluc_mux
    port map (
      alu_c => alu_c,
      carry => LPM_q_s64,
      carrys => alucs,
      last_carry => alu_carry_out_last
    );
  
  -- Generated from instantiation at 6502/6502_top.v:132
  branch_control_inst: branch_control
    port map (
      ir => LPM_q_s4,
      reg_p => reg_p,
      taken_branch => taken_branch
    );
  
  -- Generated from instantiation at 6502/6502_top.v:171
  db_in_mux_inst: db_in_mux
    port map (
      alua_highbit => LPM_q_s40,
      data_i => data_i,
      db_in => db_in,
      db_sel => db_sel,
      reg_a => reg_a
    );
  
  -- Generated from instantiation at 6502/6502_top.v:172
  db_out_mux_inst: db_out_mux
    port map (
      db_out => db_out,
      db_sel => db_sel,
      pch => pch,
      pcl => pcl,
      reg_a => reg_a,
      reg_p => reg_p,
      sb => sb
    );
  
  -- Generated from instantiation at 6502/6502_top.v:182
  dec3to8: decoder3to8
    port map (
      index => LPM_q_s42,
      outbits => ir_dec
    );
  
  -- Generated from instantiation at 6502/6502_top.v:194
  do_reg: clocked_reg8
    port map (
      clk => clk,
      ready => LO_s81,
      register_in => db_out,
      register_out => dor
    );
  
  -- Generated from instantiation at 6502/6502_top.v:128
  flags_decode_inst: flags_decode
    port map (
      load_flags => load_flags,
      load_flags_decode => load_flag_decode
    );
  t <= t_Readable;
  
  -- Generated from instantiation at 6502/6502_top.v:157
  interrupt_control_inst: interrupt_control
    port map (
      clk => clk,
      intg => intg,
      irq => irq,
      load_i => LPM_q_s30,
      nmi => nmi,
      nmig => nmig,
      reg_p => reg_p,
      reset => reset,
      resp => resp,
      t => t_Readable,
      tnext_mc => tnext_mc,
      vector_lo => vector_lo
    );
  sync <= sync_Readable;
  
  -- Generated from instantiation at 6502/6502_top.v:134
  ir_next_mux_inst: ir_next_mux
    port map (
      data_i => data_i,
      intg => intg,
      ir => ir,
      ir_next => ir_next,
      sync => sync_Readable
    );
  
  -- Generated from instantiation at 6502/6502_top.v:163
  ir_reg: clocked_reset_reg8
    port map (
      clk => clk,
      ready => LO_s35,
      register_in => ir_next,
      register_out => ir,
      reset => reset
    );
  
  -- Generated from instantiation at 6502/6502_top.v:120
  mc_inst: microcode
    port map (
      adh_sel => adh_sel,
      adl_sel => adl_sel,
      alu_a => alu_a,
      alu_b => alu_b,
      alu_c => alu_c,
      alu_op => alu_op,
      clk => clk,
      db_sel => db_sel,
      ir => ir_next,
      load_a => load_a,
      load_abh => load_abh,
      load_abl => load_abl,
      load_flags => load_flags,
      load_s => load_s,
      load_x => load_x,
      load_y => load_y,
      pc_inc => pc_inc,
      pchs_sel => pchs_sel,
      pcls_sel => pcls_sel,
      ready => ready_i,
      sb_sel => sb_sel,
      t => t_next,
      tnext => tnext_mc,
      write_cycle => write_cycle
    );
  
  -- Generated from instantiation at 6502/6502_top.v:217
  p_reg_inst: p_reg
    port map (
      carry => alu_carry_out,
      clk => clk,
      db_in => db_in,
      intg => intg,
      ir5 => LPM_q_s118,
      load_b => LO_s117,
      load_flag_decode => load_flag_decode,
      overflow => alu_overflow_out,
      ready => ready_i,
      reg_p => reg_p,
      reset => reset,
      sb_n => sb_n,
      sb_z => sb_z
    );
  
  -- Generated from instantiation at 6502/6502_top.v:155
  predecode_inst: predecode
    port map (
      active => LO_s29,
      ir_next => data_i,
      onecycle => onecycle,
      twocycle => twocycle
    );
  
  -- Generated from instantiation at 6502/6502_top.v:193
  s_reg: clocked_reg8
    port map (
      clk => clk,
      ready => LO_s71,
      register_in => sb,
      register_out => reg_s
    );
  
  -- Generated from instantiation at 6502/6502_top.v:174
  sb_mux_inst: sb_mux
    port map (
      alu => alu_out,
      db => db_in,
      pch => pch,
      reg_a => reg_a,
      reg_s => reg_s,
      reg_x => reg_x,
      reg_y => reg_y,
      sb => sb,
      sb_sel => sb_sel
    );
  
  -- Generated from instantiation at 6502/6502_top.v:160
  timing: timing_ctrl
    port map (
      alu_carry_out => alu_carry_out,
      branch_page_cross => branch_page_cross,
      clk => clk,
      decimal_cycle => decimal_cycle,
      decimal_extra_cycle => decimal_extra_cycle,
      intg => intg,
      load_sbz => LPM_q_s32,
      onecycle => onecycle,
      pc_hold => pc_hold,
      ready => ready_i,
      reset => reset,
      sync => sync,
      t => t,
      t_next => t_next,
      taken_branch => taken_branch,
      tnext_mc => tnext_mc,
      twocycle => twocycle,
      write_allowed => write_allowed
    );
  
  -- Generated from instantiation at 6502/6502_top.v:191
  x_reg: clocked_reg8
    port map (
      clk => clk,
      ready => LO_s67,
      register_in => sb,
      register_out => reg_x
    );
  
  -- Generated from instantiation at 6502/6502_top.v:192
  y_reg: clocked_reg8
    port map (
      clk => clk,
      ready => LO_s69,
      register_in => sb,
      register_out => reg_y
    );
  tmp_s100 <= X"4";
  tmp_s47 <= "00000000000000000000000000000";
  tmp_s48 <= X"00000000";
  tmp_s57 <= "000000000000000000000000000000";
  tmp_s58 <= X"00000000";
  tmp_s75 <= "00000000000000000000000000000";
  tmp_s76 <= X"00000000";
  tmp_s88 <= X"0";
  
  -- Generated from always process in cpu6502 (6502/6502_top.v:144)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready_i = '1' then
        write_Reg <= write_next;
      end if;
    end if;
  end process;
  
  -- Generated from always process in cpu6502 (6502/6502_top.v:223)
  process (clk) is
  begin
    if rising_edge(clk) then
      if (sync and ready_i) = '1' then
        if last_fetch_addr = address then
          report "Halting, branch to self detected: " & integer'image(To_Integer(last_fetch_addr)) & "   A: " & integer'image(To_Integer(reg_a)) & " X: " & integer'image(To_Integer(reg_x)) & " Y: " & integer'image(To_Integer(reg_y)) & " S: " & integer'image(To_Integer(reg_s)) & " P: " & integer'image(To_Integer(reg_p)) & " ";
          report "SIMULATION FINISHED" severity failure;
        end if;
        if (unsigned'("0000000000000000000000000000000") & pc_hold) = X"00000000" then
          last_fetch_addr <= address;
        end if;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module a_reg (6502/6502_reg.v:51)
entity a_reg is
  port (
    carry_in : in std_logic;
    clk : in std_logic;
    dec_add : in std_logic;
    dec_in : in unsigned(7 downto 0);
    dec_sub : in std_logic;
    half_carry_in : in std_logic;
    load_a : in std_logic;
    reg_a : out unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module a_reg (6502/6502_reg.v:51)
architecture from_verilog of a_reg is
  signal reg_a_Reg : unsigned(7 downto 0);
  signal dec_out : unsigned(7 downto 0);  -- Declared at 6502/6502_reg.v:54
  signal LPM_q_s0 : unsigned(3 downto 0);
  signal LPM_q_s6 : unsigned(3 downto 0);
  signal LPM_d0_s14 : unsigned(3 downto 0);
  signal LPM_d1_s14 : unsigned(3 downto 0);
  
  component decadj_half_adder is
    port (
      carry_in : in std_logic;
      dec_add : in std_logic;
      dec_in : in unsigned(3 downto 0);
      dec_out : out unsigned(3 downto 0);
      dec_sub : in std_logic;
      half : in std_logic
    );
  end component;
begin
  reg_a <= reg_a_Reg;
  LPM_q_s0 <= dec_in(0 + 3 downto 0);
  LPM_q_s6 <= dec_in(4 + 3 downto 4);
  dec_out <= LPM_d1_s14 & LPM_d0_s14;
  
  -- Generated from instantiation at 6502/6502_reg.v:57
  high: decadj_half_adder
    port map (
      carry_in => carry_in,
      dec_add => dec_add,
      dec_in => LPM_q_s6,
      dec_out => LPM_d1_s14,
      dec_sub => dec_sub,
      half => '1'
    );
  
  -- Generated from instantiation at 6502/6502_reg.v:56
  low: decadj_half_adder
    port map (
      carry_in => half_carry_in,
      dec_add => dec_add,
      dec_in => LPM_q_s0,
      dec_out => LPM_d0_s14,
      dec_sub => dec_sub,
      half => '0'
    );
  
  -- Generated from always process in a_reg (6502/6502_reg.v:59)
  process (clk) is
  begin
    if rising_edge(clk) then
      if load_a = '1' then
        reg_a_Reg <= dec_out;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module decadj_half_adder (6502/6502_alu.v:27)
entity decadj_half_adder is
  port (
    carry_in : in std_logic;
    dec_add : in std_logic;
    dec_in : in unsigned(3 downto 0);
    dec_out : out unsigned(3 downto 0);
    dec_sub : in std_logic;
    half : in std_logic
  );
end entity; 

-- Generated from Verilog module decadj_half_adder (6502/6502_alu.v:27)
architecture from_verilog of decadj_half_adder is
  signal tmp_s2 : std_logic;  -- Temporary created at 6502/6502_alu.v:34
  signal tmp_s6 : std_logic;  -- Temporary created at 6502/6502_alu.v:36
  signal tmp_s8 : std_logic;  -- Temporary created at 6502/6502_alu.v:36
  signal add_adj : std_logic;  -- Declared at 6502/6502_alu.v:31
  signal correction_factor : unsigned(3 downto 0);  -- Declared at 6502/6502_alu.v:29
  signal sub_adj : std_logic;  -- Declared at 6502/6502_alu.v:31
  signal LPM_d0_s13 : unsigned(3 downto 0);
  signal LPM_q_s13 : unsigned(3 downto 0);
begin
  add_adj <= dec_add and carry_in;
  tmp_s2 <= not carry_in;
  sub_adj <= dec_sub and tmp_s2;
  tmp_s6 <= add_adj or sub_adj;
  correction_factor <= sub_adj & add_adj & tmp_s6 & tmp_s8;
  dec_out <= dec_in + correction_factor;
  tmp_s8 <= '0';
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module adh_abh_reg (6502/6502_reg.v:175)
entity adh_abh_reg is
  port (
    abh : out unsigned(7 downto 0);
    abh_next : out unsigned(7 downto 0);
    adh_sel : in unsigned(2 downto 0);
    alu : in unsigned(7 downto 0);
    clk : in std_logic;
    data_i : in unsigned(7 downto 0);
    load_abh : in std_logic;
    pchs : in unsigned(7 downto 0);
    ready : in std_logic
  );
end entity; 

-- Generated from Verilog module adh_abh_reg (6502/6502_reg.v:175)
architecture from_verilog of adh_abh_reg is
  signal abh_Reg : unsigned(7 downto 0);
  signal abh_next_Reg : unsigned(7 downto 0);
  signal adh_abh : unsigned(7 downto 0);  -- Declared at 6502/6502_reg.v:179
begin
  abh <= abh_Reg;
  abh_next <= abh_next_Reg;
  
  -- Generated from always process in adh_abh_reg (6502/6502_reg.v:181)
  process (adh_sel, data_i, pchs, alu) is
  begin
    case adh_sel is
      when "000" =>
        adh_abh <= data_i;
      when "010" =>
        adh_abh <= pchs;
      when "001" =>
        adh_abh <= alu;
      when "011" =>
        adh_abh <= X"00";
      when "100" =>
        adh_abh <= X"01";
      when "101" =>
        adh_abh <= X"ff";
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in adh_abh_reg (6502/6502_reg.v:193)
  process (load_abh, ready, adh_abh, abh_Reg) is
  begin
    if (load_abh = '1') and (ready = '1') then
      abh_next_Reg <= adh_abh;
    else
      abh_next_Reg <= abh_Reg;
    end if;
  end process;
  
  -- Generated from always process in adh_abh_reg (6502/6502_reg.v:201)
  process (clk) is
  begin
    if rising_edge(clk) then
      if (load_abh = '1') and (ready = '1') then
        abh_Reg <= adh_abh;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module adh_pch_reg (6502/6502_reg.v:140)
entity adh_pch_reg is
  port (
    adh_sel : in unsigned(2 downto 0);
    alu : in unsigned(7 downto 0);
    clk : in std_logic;
    data_i : in unsigned(7 downto 0);
    pch : out unsigned(7 downto 0);
    pch_carry : out std_logic;
    pchs : out unsigned(7 downto 0);
    pchs_sel : in std_logic;
    pcl_carry : in std_logic;
    ready : in std_logic
  );
end entity; 

-- Generated from Verilog module adh_pch_reg (6502/6502_reg.v:140)
architecture from_verilog of adh_pch_reg is
  signal pch_Reg : unsigned(7 downto 0);
  signal pch_carry_Reg : std_logic;
  signal pchs_Reg : unsigned(7 downto 0);
  signal adh_pchs : unsigned(7 downto 0);  -- Declared at 6502/6502_reg.v:145
  signal pchs_in : unsigned(8 downto 0);  -- Declared at 6502/6502_reg.v:144
begin
  pch <= pch_Reg;
  pch_carry <= pch_carry_Reg;
  pchs <= pchs_Reg;
  
  -- Generated from always process in adh_pch_reg (6502/6502_reg.v:147)
  process is
    variable Verilog_Assign_Tmp_2 : unsigned(8 downto 0);
  begin
    if (unsigned'("0000000000000000000000000000000") & pchs_sel) = X"00000000" then
      pchs_in <= Resize(pch_Reg, 9) + (unsigned'(X"00") & pcl_carry);
    else
      pchs_in <= Resize(adh_pchs, 9);
    end if;
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_reg.v:153)
    Verilog_Assign_Tmp_2 := pchs_in;
    pchs_Reg <= Verilog_Assign_Tmp_2(0 + 7 downto 0);
    pch_carry_Reg <= Verilog_Assign_Tmp_2(8);
    wait on pchs_sel, pch_Reg, pcl_carry, adh_pchs, pchs_in;
  end process;
  
  -- Generated from always process in adh_pch_reg (6502/6502_reg.v:157)
  process (adh_sel, data_i, alu) is
  begin
    case adh_sel is
      when "000" =>
        adh_pchs <= data_i;
      when "001" =>
        adh_pchs <= alu;
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in adh_pch_reg (6502/6502_reg.v:165)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        pch_Reg <= pchs_Reg;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module adl_abl_reg (6502/6502_reg.v:211)
entity adl_abl_reg is
  port (
    abl : out unsigned(7 downto 0);
    abl_next : out unsigned(7 downto 0);
    adl_abl : out unsigned(7 downto 0);
    adl_sel : in unsigned(2 downto 0);
    alu : in unsigned(7 downto 0);
    clk : in std_logic;
    data_i : in unsigned(7 downto 0);
    load_abl : in std_logic;
    pcls : in unsigned(7 downto 0);
    ready : in std_logic;
    reg_s : in unsigned(7 downto 0);
    vector_lo : in unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module adl_abl_reg (6502/6502_reg.v:211)
architecture from_verilog of adl_abl_reg is
  signal abl_Reg : unsigned(7 downto 0);
  signal abl_next_Reg : unsigned(7 downto 0);
  signal adl_abl_Reg : unsigned(7 downto 0);
begin
  abl <= abl_Reg;
  abl_next <= abl_next_Reg;
  adl_abl <= adl_abl_Reg;
  
  -- Generated from always process in adl_abl_reg (6502/6502_reg.v:217)
  process (adl_sel, data_i, pcls, reg_s, alu, vector_lo) is
  begin
    case adl_sel is
      when "000" =>
        adl_abl_Reg <= data_i;
      when "001" =>
        adl_abl_Reg <= pcls;
      when "010" =>
        adl_abl_Reg <= reg_s;
      when "011" =>
        adl_abl_Reg <= alu;
      when "100" =>
        adl_abl_Reg <= vector_lo;
      when "101" =>
        adl_abl_Reg <= vector_lo(1 + 6 downto 1) & '1';
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in adl_abl_reg (6502/6502_reg.v:229)
  process (load_abl, ready, adl_abl_Reg, abl_Reg) is
  begin
    if (load_abl = '1') and (ready = '1') then
      abl_next_Reg <= adl_abl_Reg;
    else
      abl_next_Reg <= abl_Reg;
    end if;
  end process;
  
  -- Generated from always process in adl_abl_reg (6502/6502_reg.v:238)
  process (clk) is
  begin
    if rising_edge(clk) then
      if (load_abl = '1') and (ready = '1') then
        abl_Reg <= adl_abl_Reg;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module adl_pcl_reg (6502/6502_reg.v:106)
entity adl_pcl_reg is
  port (
    adl_sel : in unsigned(2 downto 0);
    alu : in unsigned(7 downto 0);
    clk : in std_logic;
    pc_inc : in std_logic;
    pcl : out unsigned(7 downto 0);
    pcl_carry : out std_logic;
    pcls : out unsigned(7 downto 0);
    pcls_sel : in std_logic;
    ready : in std_logic;
    reg_s : in unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module adl_pcl_reg (6502/6502_reg.v:106)
architecture from_verilog of adl_pcl_reg is
  signal pcl_Reg : unsigned(7 downto 0);
  signal pcl_carry_Reg : std_logic;
  signal pcls_Reg : unsigned(7 downto 0);
  signal adl_pcls : unsigned(7 downto 0);  -- Declared at 6502/6502_reg.v:109
  signal pcls_in : unsigned(8 downto 0);  -- Declared at 6502/6502_reg.v:110
begin
  pcl <= pcl_Reg;
  pcl_carry <= pcl_carry_Reg;
  pcls <= pcls_Reg;
  
  -- Generated from always process in adl_pcl_reg (6502/6502_reg.v:112)
  process is
    variable Verilog_Assign_Tmp_1 : unsigned(8 downto 0);
  begin
    if (unsigned'("0000000000000000000000000000000") & pcls_sel) = X"00000000" then
      pcls_in <= Resize(pcl_Reg, 9) + (unsigned'(X"00") & pc_inc);
    else
      pcls_in <= Resize(adl_pcls, 9);
    end if;
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_reg.v:118)
    Verilog_Assign_Tmp_1 := pcls_in;
    pcls_Reg <= Verilog_Assign_Tmp_1(0 + 7 downto 0);
    pcl_carry_Reg <= Verilog_Assign_Tmp_1(8);
    wait on pcls_sel, pcl_Reg, pc_inc, adl_pcls, pcls_in;
  end process;
  
  -- Generated from always process in adl_pcl_reg (6502/6502_reg.v:121)
  process (adl_sel, reg_s, alu) is
  begin
    case adl_sel is
      when "010" =>
        adl_pcls <= reg_s;
      when "011" =>
        adl_pcls <= alu;
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in adl_pcl_reg (6502/6502_reg.v:129)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        pcl_Reg <= pcls_Reg;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module alu_unit (6502/6502_alu.v:71)
entity alu_unit is
  port (
    a : in unsigned(7 downto 0);
    alu_carry_out_last : out std_logic;
    alu_out : out unsigned(7 downto 0);
    b : in unsigned(7 downto 0);
    c_in : in std_logic;
    carry_out : out std_logic;
    clk : in std_logic;
    dec_add : in std_logic;
    half_carry_out : out std_logic;
    op : in unsigned(3 downto 0);
    overflow_out : out std_logic;
    ready : in std_logic
  );
end entity; 

-- Generated from Verilog module alu_unit (6502/6502_alu.v:71)
architecture from_verilog of alu_unit is
  signal alu_carry_out_last_Reg : std_logic;
  signal alu_out_Reg : unsigned(7 downto 0);
  signal carry_out_Reg : std_logic;
  signal tmp_s1 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal tmp_s10 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal tmp_s3 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal tmp_s4 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal tmp_s7 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal tmp_s9 : std_logic;  -- Temporary created at 6502/6502_alu.v:87
  signal add_out : unsigned(7 downto 0);  -- Declared at 6502/6502_alu.v:80
  signal adder_carry_out : std_logic;  -- Declared at 6502/6502_alu.v:83
  signal c : std_logic;  -- Declared at 6502/6502_alu.v:78
  signal tmp : unsigned(7 downto 0);  -- Declared at 6502/6502_alu.v:81
  
  component alu_adder is
    port (
      add_cin : in std_logic;
      add_in1 : in unsigned(7 downto 0);
      add_in2 : in unsigned(7 downto 0);
      add_out : out unsigned(7 downto 0);
      carry_out : out std_logic;
      dec_add : in std_logic;
      half_carry_out : out std_logic
    );
  end component;
  signal half_carry_out_Readable : std_logic;  -- Needed to connect outputs
  
  function Reduce_OR(X : std_logic_vector) return std_logic is
    variable R : std_logic := '0';
  begin
    for I in X'Range loop
      R := X(I) or R;
    end loop;
    return R;
  end function;
begin
  alu_carry_out_last <= alu_carry_out_last_Reg;
  alu_out <= alu_out_Reg;
  carry_out <= carry_out_Reg;
  tmp_s4 <= tmp_s1 xnor tmp_s3;
  tmp_s10 <= tmp_s7 xor tmp_s9;
  overflow_out <= tmp_s4 and tmp_s10;
  tmp_s1 <= a(7);
  tmp_s3 <= b(7);
  tmp_s7 <= a(7);
  tmp_s9 <= add_out(7);
  half_carry_out <= half_carry_out_Readable;
  
  -- Generated from instantiation at 6502/6502_alu.v:85
  add_u: alu_adder
    port map (
      add_cin => c_in,
      add_in1 => a,
      add_in2 => b,
      add_out => add_out,
      carry_out => adder_carry_out,
      dec_add => dec_add,
      half_carry_out => half_carry_out_Readable
    );
  
  -- Generated from always process in alu_unit (6502/6502_alu.v:89)
  process is
    variable Verilog_Assign_Tmp_0 : unsigned(8 downto 0);
  begin
    case op is
      when X"1" =>
        c <= '0';
        tmp <= a or b;
      when X"2" =>
        tmp <= a and b;
        wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:99)
        c <= Reduce_OR(std_logic_vector(tmp));
      when X"3" =>
        c <= '0';
        tmp <= a xor b;
      when X"0" =>
        c <= adder_carry_out;
        tmp <= add_out;
      when X"4" =>
        c <= adder_carry_out;
        tmp <= add_out;
      when X"5" =>
        Verilog_Assign_Tmp_0 := c_in & a;
        c <= Verilog_Assign_Tmp_0(0);
        tmp <= Verilog_Assign_Tmp_0(1 + 7 downto 1);
      when X"f" =>
        c <= '0';
        tmp <= a;
      when others =>
        null;
    end case;
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:127)
    alu_out_Reg <= tmp;
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:128)
    carry_out_Reg <= c;
    wait on op, a, b, tmp, adder_carry_out, add_out, c_in, c;
  end process;
  
  -- Generated from always process in alu_unit (6502/6502_alu.v:133)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        alu_carry_out_last_Reg <= carry_out_Reg;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module alu_adder (6502/6502_alu.v:60)
entity alu_adder is
  port (
    add_cin : in std_logic;
    add_in1 : in unsigned(7 downto 0);
    add_in2 : in unsigned(7 downto 0);
    add_out : out unsigned(7 downto 0);
    carry_out : out std_logic;
    dec_add : in std_logic;
    half_carry_out : out std_logic
  );
end entity; 

-- Generated from Verilog module alu_adder (6502/6502_alu.v:60)
architecture from_verilog of alu_adder is
  signal dec_carry_out : std_logic;  -- Declared at 6502/6502_alu.v:63
  signal dec_half_carry_out : std_logic;  -- Declared at 6502/6502_alu.v:65
  signal LPM_q_s0 : unsigned(3 downto 0);
  signal LPM_q_s2 : unsigned(3 downto 0);
  signal LPM_q_s8 : unsigned(3 downto 0);
  signal LPM_q_s10 : unsigned(3 downto 0);
  signal LPM_d0_s16 : unsigned(3 downto 0);
  signal LPM_d1_s16 : unsigned(3 downto 0);
  
  component alu_half_adder is
    port (
      add_cin : in std_logic;
      add_in1 : in unsigned(3 downto 0);
      add_in2 : in unsigned(3 downto 0);
      add_out : out unsigned(3 downto 0);
      carry_out : out std_logic;
      dec_add : in std_logic;
      dec_carry_out : out std_logic;
      half : in std_logic
    );
  end component;
  signal add_cin_Readable : std_logic;  -- Needed to connect outputs
  signal carry_out_Readable : std_logic;  -- Needed to connect outputs
begin
  LPM_q_s0 <= add_in1(0 + 3 downto 0);
  LPM_q_s2 <= add_in2(0 + 3 downto 0);
  LPM_q_s8 <= add_in1(4 + 3 downto 4);
  LPM_q_s10 <= add_in2(4 + 3 downto 4);
  add_out <= LPM_d1_s16 & LPM_d0_s16;
  half_carry_out <= add_cin_Readable;
  carry_out <= carry_out_Readable;
  
  -- Generated from instantiation at 6502/6502_alu.v:66
  high: alu_half_adder
    port map (
      add_cin => add_cin_Readable,
      add_in1 => LPM_q_s8,
      add_in2 => LPM_q_s10,
      add_out => LPM_d1_s16,
      carry_out => carry_out_Readable,
      dec_add => dec_add,
      dec_carry_out => dec_carry_out,
      half => '1'
    );
  
  -- Generated from instantiation at 6502/6502_alu.v:65
  low: alu_half_adder
    port map (
      add_cin => add_cin,
      add_in1 => LPM_q_s0,
      add_in2 => LPM_q_s2,
      add_out => LPM_d0_s16,
      carry_out => half_carry_out,
      dec_add => dec_add,
      dec_carry_out => dec_half_carry_out,
      half => '0'
    );
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module alu_half_adder (6502/6502_alu.v:41)
entity alu_half_adder is
  port (
    add_cin : in std_logic;
    add_in1 : in unsigned(3 downto 0);
    add_in2 : in unsigned(3 downto 0);
    add_out : out unsigned(3 downto 0);
    carry_out : out std_logic;
    dec_add : in std_logic;
    dec_carry_out : out std_logic;
    half : in std_logic
  );
end entity; 

-- Generated from Verilog module alu_half_adder (6502/6502_alu.v:41)
architecture from_verilog of alu_half_adder is
  signal add_out_Reg : unsigned(3 downto 0);
  signal carry_out_Reg : std_logic;
  signal dec_carry_out_Reg : std_logic;
  signal add_tmp : unsigned(4 downto 0);  -- Declared at 6502/6502_alu.v:47
  signal greater_than_nine : std_logic;  -- Declared at 6502/6502_alu.v:45
begin
  add_out <= add_out_Reg;
  carry_out <= carry_out_Reg;
  dec_carry_out <= dec_carry_out_Reg;
  
  -- Generated from always process in alu_half_adder (6502/6502_alu.v:49)
  process is
  begin
    add_tmp <= (Resize(add_in1, 5) + Resize(add_in2, 5)) + (unsigned'(X"0") & add_cin);
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:52)
    greater_than_nine <= add_tmp(3) and (add_tmp(2) or add_tmp(1));
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:53)
    carry_out_Reg <= add_tmp(4) or (dec_add and greater_than_nine);
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:54)
    dec_carry_out_Reg <= greater_than_nine;
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_alu.v:55)
    add_out_Reg <= add_tmp(0 + 3 downto 0);
    wait on add_in1, add_in2, add_cin, add_tmp, dec_add, greater_than_nine;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module alua_mux (6502/6502_mux.v:45)
entity alua_mux is
  port (
    alu_a : in unsigned(2 downto 0);
    alua : out unsigned(7 downto 0);
    clk : in std_logic;
    ir_dec : in unsigned(7 downto 0);
    ready : in std_logic;
    sb : in unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module alua_mux (6502/6502_mux.v:45)
architecture from_verilog of alua_mux is
  signal alua_Reg : unsigned(7 downto 0);
  signal aluas : unsigned(7 downto 0);  -- Declared at 6502/6502_mux.v:52
begin
  alua <= alua_Reg;
  
  -- Generated from always process in alua_mux (6502/6502_mux.v:55)
  process (alu_a, sb, ir_dec) is
  begin
    case alu_a is
      when "001" =>
        aluas <= X"00";
      when "010" =>
        aluas <= sb;
      when "011" =>
        aluas <= not sb;
      when "100" =>
        aluas <= ir_dec;
      when "101" =>
        aluas <= not ir_dec;
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in alua_mux (6502/6502_mux.v:68)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        alua_Reg <= aluas;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module alub_mux (6502/6502_mux.v:78)
entity alub_mux is
  port (
    adl : in unsigned(7 downto 0);
    alu_b : in unsigned(1 downto 0);
    alub : out unsigned(7 downto 0);
    clk : in std_logic;
    db : in unsigned(7 downto 0);
    ready : in std_logic
  );
end entity; 

-- Generated from Verilog module alub_mux (6502/6502_mux.v:78)
architecture from_verilog of alub_mux is
  signal alub_Reg : unsigned(7 downto 0);
  signal alubs : unsigned(7 downto 0);  -- Declared at 6502/6502_mux.v:85
begin
  alub <= alub_Reg;
  
  -- Generated from always process in alub_mux (6502/6502_mux.v:88)
  process (alu_b, db, adl) is
  begin
    case alu_b is
      when "01" =>
        alubs <= db;
      when "10" =>
        alubs <= not db;
      when "11" =>
        alubs <= adl;
      when others =>
        null;
    end case;
  end process;
  
  -- Generated from always process in alub_mux (6502/6502_mux.v:97)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        alub_Reg <= alubs;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module aluc_mux (6502/6502_mux.v:108)
entity aluc_mux is
  port (
    alu_c : in unsigned(1 downto 0);
    carry : in std_logic;
    carrys : out std_logic;
    last_carry : in std_logic
  );
end entity; 

-- Generated from Verilog module aluc_mux (6502/6502_mux.v:108)
architecture from_verilog of aluc_mux is
  signal carrys_Reg : std_logic;
begin
  carrys <= carrys_Reg;
  
  -- Generated from always process in aluc_mux (6502/6502_mux.v:114)
  process (alu_c, carry, last_carry) is
  begin
    case alu_c is
      when "00" =>
        carrys_Reg <= '0';
      when "01" =>
        carrys_Reg <= '1';
      when "10" =>
        carrys_Reg <= carry;
      when "11" =>
        carrys_Reg <= last_carry;
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module branch_control (6502/6502_timing.v:219)
entity branch_control is
  port (
    ir : in unsigned(2 downto 0);
    reg_p : in unsigned(7 downto 0);
    taken_branch : out std_logic
  );
end entity; 

-- Generated from Verilog module branch_control (6502/6502_timing.v:219)
architecture from_verilog of branch_control is
  signal taken_branch_Reg : std_logic;
  
  function Boolean_To_Logic(B : Boolean) return std_logic is
  begin
    if B then
      return '1';
    else
      return '0';
    end if;
  end function;
begin
  taken_branch <= taken_branch_Reg;
  
  -- Generated from always process in branch_control (6502/6502_timing.v:221)
  process (ir, reg_p) is
    variable Verilog_Case_Ex : unsigned(1 downto 0);
  begin
    taken_branch_Reg <= '0';
    Verilog_Case_Ex := ir(2) & ir(1);
    case Verilog_Case_Ex is
      when "00" =>
        taken_branch_Reg <= Boolean_To_Logic(reg_p(7) = ir(0));
      when "01" =>
        taken_branch_Reg <= Boolean_To_Logic(reg_p(6) = ir(0));
      when "10" =>
        taken_branch_Reg <= Boolean_To_Logic(reg_p(0) = ir(0));
      when "11" =>
        taken_branch_Reg <= Boolean_To_Logic(reg_p(1) = ir(0));
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module db_in_mux (6502/6502_mux.v:126)
entity db_in_mux is
  port (
    alua_highbit : in std_logic;
    data_i : in unsigned(7 downto 0);
    db_in : out unsigned(7 downto 0);
    db_sel : in unsigned(2 downto 0);
    reg_a : in unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module db_in_mux (6502/6502_mux.v:126)
architecture from_verilog of db_in_mux is
  signal db_in_Reg : unsigned(7 downto 0);
begin
  db_in <= db_in_Reg;
  
  -- Generated from always process in db_in_mux (6502/6502_mux.v:133)
  process (db_sel, reg_a, alua_highbit, data_i) is
  begin
    case db_sel is
      when "001" =>
        db_in_Reg <= X"00";
      when "010" =>
        db_in_Reg <= reg_a;
      when "111" =>
        db_in_Reg <= alua_highbit & alua_highbit & alua_highbit & alua_highbit & alua_highbit & alua_highbit & alua_highbit & alua_highbit;
      when others =>
        db_in_Reg <= data_i;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module db_out_mux (6502/6502_mux.v:150)
entity db_out_mux is
  port (
    db_out : out unsigned(7 downto 0);
    db_sel : in unsigned(2 downto 0);
    pch : in unsigned(7 downto 0);
    pcl : in unsigned(7 downto 0);
    reg_a : in unsigned(7 downto 0);
    reg_p : in unsigned(7 downto 0);
    sb : in unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module db_out_mux (6502/6502_mux.v:150)
architecture from_verilog of db_out_mux is
  signal db_out_Reg : unsigned(7 downto 0);
begin
  db_out <= db_out_Reg;
  
  -- Generated from always process in db_out_mux (6502/6502_mux.v:159)
  process (db_sel, reg_a, sb, pcl, pch, reg_p) is
  begin
    case db_sel is
      when "010" =>
        db_out_Reg <= reg_a;
      when "011" =>
        db_out_Reg <= sb;
      when "100" =>
        db_out_Reg <= pcl;
      when "101" =>
        db_out_Reg <= pch;
      when "110" =>
        db_out_Reg <= reg_p;
      when "001" =>
        db_out_Reg <= X"00";
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module decoder3to8 (6502/6502_alu.v:141)
entity decoder3to8 is
  port (
    index : in unsigned(2 downto 0);
    outbits : out unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module decoder3to8 (6502/6502_alu.v:141)
architecture from_verilog of decoder3to8 is
  signal outbits_Reg : unsigned(7 downto 0);
begin
  outbits <= outbits_Reg;
  
  -- Generated from always process in decoder3to8 (6502/6502_alu.v:143)
  process (index) is
  begin
    case index is
      when "000" =>
        outbits_Reg <= X"01";
      when "001" =>
        outbits_Reg <= X"02";
      when "010" =>
        outbits_Reg <= X"04";
      when "011" =>
        outbits_Reg <= X"08";
      when "100" =>
        outbits_Reg <= X"10";
      when "101" =>
        outbits_Reg <= X"20";
      when "110" =>
        outbits_Reg <= X"40";
      when "111" =>
        outbits_Reg <= X"80";
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module clocked_reg8 (6502/6502_reg.v:25)
entity clocked_reg8 is
  port (
    clk : in std_logic;
    ready : in std_logic;
    register_in : in unsigned(7 downto 0);
    register_out : out unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module clocked_reg8 (6502/6502_reg.v:25)
architecture from_verilog of clocked_reg8 is
  signal register_out_Reg : unsigned(7 downto 0);
begin
  register_out <= register_out_Reg;
  
  -- Generated from always process in clocked_reg8 (6502/6502_reg.v:27)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        register_out_Reg <= register_in;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module flags_decode (6502/6502_mux.v:197)
entity flags_decode is
  port (
    load_flags : in unsigned(3 downto 0);
    load_flags_decode : out unsigned(14 downto 0)
  );
end entity; 

-- Generated from Verilog module flags_decode (6502/6502_mux.v:197)
architecture from_verilog of flags_decode is
  signal load_flags_decode_Reg : unsigned(14 downto 0);
begin
  load_flags_decode <= load_flags_decode_Reg;
  
  -- Generated from always process in flags_decode (6502/6502_mux.v:198)
  process (load_flags) is
  begin
    case load_flags is
      when X"0" =>
        load_flags_decode_Reg <= "000000000000000";
      when X"1" =>
        load_flags_decode_Reg <= "010001010110001";
      when X"2" =>
        load_flags_decode_Reg <= "001000000001000";
      when X"4" =>
        load_flags_decode_Reg <= "000000100000000";
      when X"5" =>
        load_flags_decode_Reg <= "000000001000000";
      when X"6" =>
        load_flags_decode_Reg <= "000000000000010";
      when X"7" =>
        load_flags_decode_Reg <= "000100000000000";
      when X"b" =>
        load_flags_decode_Reg <= "000000000001000";
      when X"9" =>
        load_flags_decode_Reg <= "001000000001100";
      when X"3" =>
        load_flags_decode_Reg <= "001010000001100";
      when X"a" =>
        load_flags_decode_Reg <= "010001000000000";
      when X"8" =>
        load_flags_decode_Reg <= "100000100000000";
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module interrupt_control (6502/6502_timing.v:153)
entity interrupt_control is
  port (
    clk : in std_logic;
    intg : out std_logic;
    irq : in std_logic;
    load_i : in std_logic;
    nmi : in std_logic;
    nmig : out std_logic;
    reg_p : in unsigned(7 downto 0);
    reset : in std_logic;
    resp : out std_logic;
    t : in unsigned(2 downto 0);
    tnext_mc : in unsigned(2 downto 0);
    vector_lo : out unsigned(7 downto 0)
  );
end entity; 

-- Generated from Verilog module interrupt_control (6502/6502_timing.v:153)
architecture from_verilog of interrupt_control is
  signal intg_Reg : std_logic;
  signal nmig_Reg : std_logic;
  signal resp_Reg : std_logic;
  signal vector_lo_Reg : unsigned(7 downto 0);
  signal intp : std_logic;  -- Declared at 6502/6502_timing.v:159
  signal nmil : std_logic;  -- Declared at 6502/6502_timing.v:158
begin
  intg <= intg_Reg;
  nmig <= nmig_Reg;
  resp <= resp_Reg;
  vector_lo <= vector_lo_Reg;
  
  -- Generated from always process in interrupt_control (6502/6502_timing.v:161)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        resp_Reg <= '1';
      else
        if Resize(t, 32) = X"00000000" then
          resp_Reg <= '0';
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in interrupt_control (6502/6502_timing.v:170)
  process (clk) is
  begin
    if rising_edge(clk) then
      intp <= irq;
    end if;
  end process;
  
  -- Generated from always process in interrupt_control (6502/6502_timing.v:178)
  process (clk) is
  begin
    if rising_edge(clk) then
      if (nmi and (not nmil)) = '1' then
        nmig_Reg <= '1';
      end if;
      nmil <= nmi;
      if ((reset = '1') or (Resize(t, 32) = X"00000000")) or (tnext_mc = "100") then
        if (((intp and (not reg_p(2))) or nmig_Reg) or reset) = '1' then
          intg_Reg <= '1';
        end if;
      else
        if load_i = '1' then
          intg_Reg <= '0';
          if intg_Reg = '1' then
            nmig_Reg <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in interrupt_control (6502/6502_timing.v:203)
  process (resp_Reg, nmig_Reg, intg_Reg) is
  begin
    if (unsigned'("0000000000000000000000000000000") & resp_Reg) = X"00000001" then
      vector_lo_Reg <= X"fc";
    else
      if (nmig_Reg and intg_Reg) = '1' then
        vector_lo_Reg <= X"fa";
      else
        vector_lo_Reg <= X"fe";
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module ir_next_mux (6502/6502_mux.v:173)
entity ir_next_mux is
  port (
    data_i : in unsigned(7 downto 0);
    intg : in std_logic;
    ir : in unsigned(7 downto 0);
    ir_next : out unsigned(7 downto 0);
    sync : in std_logic
  );
end entity; 

-- Generated from Verilog module ir_next_mux (6502/6502_mux.v:173)
architecture from_verilog of ir_next_mux is
  signal ir_next_Reg : unsigned(7 downto 0);
begin
  ir_next <= ir_next_Reg;
  
  -- Generated from always process in ir_next_mux (6502/6502_mux.v:180)
  process (sync, intg, data_i, ir) is
  begin
    if sync = '1' then
      if intg = '1' then
        ir_next_Reg <= X"00";
      else
        ir_next_Reg <= data_i;
      end if;
    else
      ir_next_Reg <= ir;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module clocked_reset_reg8 (6502/6502_reg.v:37)
entity clocked_reset_reg8 is
  port (
    clk : in std_logic;
    ready : in std_logic;
    register_in : in unsigned(7 downto 0);
    register_out : out unsigned(7 downto 0);
    reset : in std_logic
  );
end entity; 

-- Generated from Verilog module clocked_reset_reg8 (6502/6502_reg.v:37)
architecture from_verilog of clocked_reset_reg8 is
  signal register_out_Reg : unsigned(7 downto 0);
begin
  register_out <= register_out_Reg;
  
  -- Generated from always process in clocked_reset_reg8 (6502/6502_reg.v:39)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        register_out_Reg <= X"00";
      else
        if ready = '1' then
          register_out_Reg <= register_in;
        end if;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module microcode (6502/6502_ucode.v:25)
entity microcode is
  port (
    adh_sel : out unsigned(2 downto 0);
    adl_sel : out unsigned(2 downto 0);
    alu_a : out unsigned(2 downto 0);
    alu_b : out unsigned(1 downto 0);
    alu_c : out unsigned(1 downto 0);
    alu_op : out unsigned(3 downto 0);
    clk : in std_logic;
    db_sel : out unsigned(2 downto 0);
    ir : in unsigned(7 downto 0);
    load_a : out std_logic;
    load_abh : out std_logic;
    load_abl : out std_logic;
    load_flags : out unsigned(3 downto 0);
    load_s : out std_logic;
    load_x : out std_logic;
    load_y : out std_logic;
    pc_inc : out std_logic;
    pchs_sel : out std_logic;
    pcls_sel : out std_logic;
    ready : in std_logic;
    sb_sel : out unsigned(2 downto 0);
    t : in unsigned(2 downto 0);
    tnext : out unsigned(2 downto 0);
    write_cycle : out std_logic
  );
end entity; 

-- Generated from Verilog module microcode (6502/6502_ucode.v:25)
architecture from_verilog of microcode is
  signal i : unsigned(12 downto 0) := "0000000000000";  -- Declared at 6502/6502_ucode.v:36
  type mc_Type is array (2047 downto 0) of unsigned(42 downto 0);
  signal mc : mc_Type;  -- Declared at 6502/6502_ucode.v:33
  signal mc_out : unsigned(42 downto 0);  -- Declared at 6502/6502_ucode.v:32
begin
  tnext <= mc_out(0 + 2 downto 0);
  adh_sel <= mc_out(5 + 2 downto 5);
  adl_sel <= mc_out(10 + 2 downto 10);
  db_sel <= mc_out(32 + 2 downto 32);
  sb_sel <= mc_out(36 + 2 downto 36);
  alu_a <= mc_out(16 + 2 downto 16);
  alu_b <= mc_out(20 + 1 downto 20);
  alu_op <= mc_out(24 + 3 downto 24);
  alu_c <= mc_out(22 + 1 downto 22);
  load_a <= mc_out(28);
  load_x <= mc_out(29);
  load_y <= mc_out(30);
  load_s <= mc_out(31);
  load_abh <= mc_out(3);
  load_abl <= mc_out(13);
  load_flags <= mc_out(39 + 3 downto 39);
  write_cycle <= mc_out(35);
  pc_inc <= mc_out(8);
  pchs_sel <= mc_out(15);
  pcls_sel <= mc_out(14);
  
  -- Generated from initial process in microcode (6502/6502_ucode.v:39)
  process is
  begin
    wait for 0 ns;  -- Read target of blocking assignment (6502/6502_ucode.v:43)
    while Resize(i, 32) < X"00000800" loop
      mc(0) <= "0000000000000000000000000000000000000000111";
      wait for 0 ns;  -- Read target of blocking assignment (6502/6502_ucode.v:43)
      i <= i + "0000000000001";
      wait for 0 ns;  -- Read target of blocking assignment (6502/6502_ucode.v:43)
    end loop;
    mc(2) <= "0000111110100000000001100100010100110001000";
    mc(3) <= "0000111110000000000001100100010110010001000";
    mc(4) <= "0000111111000000000001100100010110010001000";
    mc(5) <= "0000100000010000000000000000011000010101000";
    mc(6) <= "1000111000000000000000100010011010010101001";
    mc(0) <= "0000111000000000000000000001110110000001000";
    mc(1) <= "0000111000000000000000000000010010101001000";
    mc(10) <= "0000001000000000000000100100010000101101000";
    mc(11) <= "0000111000000000000001100010010110001101000";
    mc(12) <= "0000111000000000000010100010010110001101000";
    mc(13) <= "0000111000000000000000000000010110000001001";
    mc(8) <= "0000000000000000000000100100010010001001000";
    mc(9) <= "0010100001100010001000000000010010101001000";
    mc(15) <= "0010000001000000000000000000010010101001000";
    mc(42) <= "0000111000000000000000000000010000101101001";
    mc(40) <= "0000000000000000000000100100010010001001000";
    mc(41) <= "0010100001100010001000000000010010101001000";
    mc(47) <= "0010000001000000000000000000010010101001000";
    mc(72) <= "0000000000000000000000100100010010101001000";
    mc(73) <= "0010100001100010001000000000010010101001000";
    mc(79) <= "0010000001000000000000000000010010101001000";
    mc(106) <= "0000111000000000000000100010010010101001000";
    mc(107) <= "0000111000000000000000000000010110100001001";
    mc(104) <= "0000000000000000000000100100010010001001000";
    mc(105) <= "0010100001100010001000000000010010101001000";
    mc(111) <= "0010000001000000000000000000010010101001000";
    mc(138) <= "0000110000000000000000100010010000101101000";
    mc(139) <= "0000010000000000000010100100010110001101000";
    mc(140) <= "0000111000000000000000100010010110000001010";
    mc(141) <= "0000111000000000000110000000000010000101001";
    mc(136) <= "0000000000000000000000100100010010001001000";
    mc(137) <= "0010100001100010001000000000010010101001000";
    mc(143) <= "0010000001000000000000000000010010101001000";
    mc(170) <= "0000001000000000000000100100010010101001000";
    mc(171) <= "0000111000000000000000000000010110001101001";
    mc(168) <= "0000000000000000000000100100010010001001000";
    mc(169) <= "0010100001100010001000000000010010101001000";
    mc(175) <= "0010000001000000000000000000010010101001000";
    mc(202) <= "0000010000000000000000100100010010101001000";
    mc(203) <= "0000111000000000000000100010010110100001010";
    mc(204) <= "0000111000000000000110000000000010000101001";
    mc(200) <= "0000000000000000000000100100010010001001000";
    mc(201) <= "0010100001100010001000000000010010101001000";
    mc(207) <= "0010000001000000000000000000010010101001000";
    mc(234) <= "0000001000000000000000100100010010101001000";
    mc(235) <= "0000111000000000000000100010010110100001010";
    mc(236) <= "0000111000000000000110000000000010000101001";
    mc(232) <= "0000000000000000000000100100010010001001000";
    mc(233) <= "0010100001100010001000000000010010101001000";
    mc(239) <= "0010000001000000000000000000010010101001000";
    mc(266) <= "0000001000000000000000100100010000101101000";
    mc(267) <= "0000111000000000000001100010010110001101000";
    mc(268) <= "0000111000000000000010100010010110001101000";
    mc(269) <= "0000111000000000000000000000010110000001001";
    mc(264) <= "0000000000000000000000100100010010001001000";
    mc(265) <= "0010100001100010010000000000010010101001000";
    mc(271) <= "0010000001000000000000000000010010101001000";
    mc(298) <= "0000111000000000000000000000010000101101001";
    mc(296) <= "0000000000000000000000100100010010001001000";
    mc(297) <= "0010100001100010010000000000010010101001000";
    mc(303) <= "0010000001000000000000000000010010101001000";
    mc(328) <= "0000000000000000000000100100010010101001000";
    mc(329) <= "0010100001100010010000000000010010101001000";
    mc(335) <= "0010000001000000000000000000010010101001000";
    mc(362) <= "0000111000000000000000100010010010101001000";
    mc(363) <= "0000111000000000000000000000010110100001001";
    mc(360) <= "0000000000000000000000100100010010001001000";
    mc(361) <= "0010100001100010010000000000010010101001000";
    mc(367) <= "0010000001000000000000000000010010101001000";
    mc(394) <= "0000110000000000000000100010010000101101000";
    mc(395) <= "0000010000000000000010100100010110001101000";
    mc(396) <= "0000111000000000000000100010010110000001010";
    mc(397) <= "0000111000000000000110000000000010000101001";
    mc(392) <= "0000000000000000000000100100010010001001000";
    mc(393) <= "0010100001100010010000000000010010101001000";
    mc(399) <= "0010000001000000000000000000010010101001000";
    mc(426) <= "0000001000000000000000100100010010101001000";
    mc(427) <= "0000111000000000000000000000010110001101001";
    mc(424) <= "0000000000000000000000100100010010001001000";
    mc(425) <= "0010100001100010010000000000010010101001000";
    mc(431) <= "0010000001000000000000000000010010101001000";
    mc(458) <= "0000010000000000000000100100010010101001000";
    mc(459) <= "0000111000000000000000100010010110100001010";
    mc(460) <= "0000111000000000000110000000000010000101001";
    mc(456) <= "0000000000000000000000100100010010001001000";
    mc(457) <= "0010100001100010010000000000010010101001000";
    mc(463) <= "0010000001000000000000000000010010101001000";
    mc(490) <= "0000001000000000000000100100010010101001000";
    mc(491) <= "0000111000000000000000100010010110100001010";
    mc(492) <= "0000111000000000000110000000000010000101001";
    mc(488) <= "0000000000000000000000100100010010001001000";
    mc(489) <= "0010100001100010010000000000010010101001000";
    mc(495) <= "0010000001000000000000000000010010101001000";
    mc(290) <= "0000111000000000000000000000010000101101001";
    mc(288) <= "1010000000000000000000100100010010001001000";
    mc(289) <= "1011100001100000010000000000010010101001000";
    mc(354) <= "0000111000000000000000100010010010101001000";
    mc(355) <= "0000111000000000000000000000010110100001001";
    mc(352) <= "1010000000000000000000100100010010001001000";
    mc(353) <= "1011100001100000010000000000010010101001000";
    mc(522) <= "0000001000000000000000100100010000101101000";
    mc(523) <= "0000111000000000000001100010010110001101000";
    mc(524) <= "0000111000000000000010100010010110001101000";
    mc(525) <= "0000111000000000000000000000010110000001001";
    mc(520) <= "0000000000000000000000100100010010001001000";
    mc(521) <= "0010100001100010011000000000010010101001000";
    mc(527) <= "0010000001000000000000000000010010101001000";
    mc(554) <= "0000111000000000000000000000010000101101001";
    mc(552) <= "0000000000000000000000100100010010001001000";
    mc(553) <= "0010100001100010011000000000010010101001000";
    mc(559) <= "0010000001000000000000000000010010101001000";
    mc(584) <= "0000000000000000000000100100010010101001000";
    mc(585) <= "0010100001100010011000000000010010101001000";
    mc(591) <= "0010000001000000000000000000010010101001000";
    mc(618) <= "0000111000000000000000100010010010101001000";
    mc(619) <= "0000111000000000000000000000010110100001001";
    mc(616) <= "0000000000000000000000100100010010001001000";
    mc(617) <= "0010100001100010011000000000010010101001000";
    mc(623) <= "0010000001000000000000000000010010101001000";
    mc(650) <= "0000110000000000000000100010010000101101000";
    mc(651) <= "0000010000000000000010100100010110001101000";
    mc(652) <= "0000111000000000000000100010010110000001010";
    mc(653) <= "0000111000000000000110000000000010000101001";
    mc(648) <= "0000000000000000000000100100010010001001000";
    mc(649) <= "0010100001100010011000000000010010101001000";
    mc(655) <= "0010000001000000000000000000010010101001000";
    mc(682) <= "0000001000000000000000100100010010101001000";
    mc(683) <= "0000111000000000000000000000010110001101001";
    mc(680) <= "0000000000000000000000100100010010001001000";
    mc(681) <= "0010100001100010011000000000010010101001000";
    mc(687) <= "0010000001000000000000000000010010101001000";
    mc(714) <= "0000010000000000000000100100010010101001000";
    mc(715) <= "0000111000000000000000100010010110100001010";
    mc(716) <= "0000111000000000000110000000000010000101001";
    mc(712) <= "0000000000000000000000100100010010001001000";
    mc(713) <= "0010100001100010011000000000010010101001000";
    mc(719) <= "0010000001000000000000000000010010101001000";
    mc(746) <= "0000001000000000000000100100010010101001000";
    mc(747) <= "0000111000000000000000100010010110100001010";
    mc(748) <= "0000111000000000000110000000000010000101001";
    mc(744) <= "0000000000000000000000100100010010001001000";
    mc(745) <= "0010100001100010011000000000010010101001000";
    mc(751) <= "0010000001000000000000000000010010101001000";
    mc(778) <= "0000001000000000000000100100010000101101000";
    mc(779) <= "0000111000000000000001100010010110001101000";
    mc(780) <= "0000111000000000000010100010010110001101000";
    mc(781) <= "0000111000000000000000000000010110000001001";
    mc(776) <= "0000000000000000000000100100010010001001000";
    mc(777) <= "0011100001100010000100000000010010101001000";
    mc(783) <= "0010000001000000000000000000010010101001000";
    mc(810) <= "0000111000000000000000000000010000101101001";
    mc(808) <= "0000000000000000000000100100010010001001000";
    mc(809) <= "0011100001100010000100000000010010101001000";
    mc(815) <= "0010000001000000000000000000010010101001000";
    mc(840) <= "0000000000000000000000100100010010101001000";
    mc(841) <= "0011100001100010000100000000010010101001000";
    mc(847) <= "0010000001000000000000000000010010101001000";
    mc(874) <= "0000111000000000000000100010010010101001000";
    mc(875) <= "0000111000000000000000000000010110100001001";
    mc(872) <= "0000000000000000000000100100010010001001000";
    mc(873) <= "0011100001100010000100000000010010101001000";
    mc(879) <= "0010000001000000000000000000010010101001000";
    mc(906) <= "0000110000000000000000100010010000101101000";
    mc(907) <= "0000010000000000000010100100010110001101000";
    mc(908) <= "0000111000000000000000100010010110000001010";
    mc(909) <= "0000111000000000000110000000000010000101001";
    mc(904) <= "0000000000000000000000100100010010001001000";
    mc(905) <= "0011100001100010000100000000010010101001000";
    mc(911) <= "0010000001000000000000000000010010101001000";
    mc(938) <= "0000001000000000000000100100010010101001000";
    mc(939) <= "0000111000000000000000000000010110001101001";
    mc(936) <= "0000000000000000000000100100010010001001000";
    mc(937) <= "0011100001100010000100000000010010101001000";
    mc(943) <= "0010000001000000000000000000010010101001000";
    mc(970) <= "0000010000000000000000100100010010101001000";
    mc(971) <= "0000111000000000000000100010010110100001010";
    mc(972) <= "0000111000000000000110000000000010000101001";
    mc(968) <= "0000000000000000000000100100010010001001000";
    mc(969) <= "0011100001100010000100000000010010101001000";
    mc(975) <= "0010000001000000000000000000010010101001000";
    mc(1002) <= "0000001000000000000000100100010010101001000";
    mc(1003) <= "0000111000000000000000100010010110100001010";
    mc(1004) <= "0000111000000000000110000000000010000101001";
    mc(1000) <= "0000000000000000000000100100010010001001000";
    mc(1001) <= "0011100001100010000100000000010010101001000";
    mc(1007) <= "0010000001000000000000000000010010101001000";
    mc(1034) <= "0000001000000000000000100100010000101101000";
    mc(1035) <= "0000111000000000000001100010010110001101000";
    mc(1036) <= "0000111000000000000010100010010110001101000";
    mc(1037) <= "0000000101100000000000000000010110000001001";
    mc(1032) <= "0000000000000000000000000000010010001001000";
    mc(1033) <= "0000000000000000000000000000010010101001000";
    mc(1058) <= "0000010101100000000000000000010000101101001";
    mc(1056) <= "0000000000000000000000000000010010001001000";
    mc(1057) <= "0000000000000000000000000000010010101001000";
    mc(1066) <= "0000000101100000000000000000010000101101001";
    mc(1064) <= "0000000000000000000000000000010010001001000";
    mc(1065) <= "0000000000000000000000000000010010101001000";
    mc(1074) <= "0000001101100000000000000000010000101101001";
    mc(1072) <= "0000000000000000000000000000010010001001000";
    mc(1073) <= "0000000000000000000000000000010010101001000";
    mc(1122) <= "0000111000000000000000100010010010101001000";
    mc(1123) <= "0000010101100000000000000000010110100001001";
    mc(1120) <= "0000000000000000000000000000010010001001000";
    mc(1121) <= "0000000000000000000000000000010010101001000";
    mc(1130) <= "0000111000000000000000100010010010101001000";
    mc(1131) <= "0000000101100000000000000000010110100001001";
    mc(1128) <= "0000000000000000000000000000010010001001000";
    mc(1129) <= "0000000000000000000000000000010010101001000";
    mc(1138) <= "0000111000000000000000100010010010101001000";
    mc(1139) <= "0000001101100000000000000000010110100001001";
    mc(1136) <= "0000000000000000000000000000010010001001000";
    mc(1137) <= "0000000000000000000000000000010010101001000";
    mc(1162) <= "0000110000000000000000100010010000101101000";
    mc(1163) <= "0000010000000000000010100100010110001101000";
    mc(1164) <= "0000000101100000000000100010010110000001010";
    mc(1165) <= "0000000101100000000110000000000010000101001";
    mc(1160) <= "0000000000000000000000000000010010001001000";
    mc(1161) <= "0000000000000000000000000000010010101001000";
    mc(1186) <= "0000001000000000000000100100010010101001000";
    mc(1187) <= "0000010101100000000000000000010110001101001";
    mc(1184) <= "0000000000000000000000000000010010001001000";
    mc(1185) <= "0000000000000000000000000000010010101001000";
    mc(1194) <= "0000001000000000000000100100010010101001000";
    mc(1195) <= "0000000101100000000000000000010110001101001";
    mc(1192) <= "0000000000000000000000000000010010001001000";
    mc(1193) <= "0000000000000000000000000000010010101001000";
    mc(1202) <= "0000010000000000000000100100010010101001000";
    mc(1203) <= "0000001101100000000000000000010110001101001";
    mc(1200) <= "0000000000000000000000000000010010001001000";
    mc(1201) <= "0000000000000000000000000000010010101001000";
    mc(1226) <= "0000010000000000000000100100010010101001000";
    mc(1227) <= "0000000101100000000000100010010110100001010";
    mc(1228) <= "0000000101100000000110000000000010000101001";
    mc(1224) <= "0000000000000000000000000000010010001001000";
    mc(1225) <= "0000000000000000000000000000010010101001000";
    mc(1258) <= "0000001000000000000000100100010010101001000";
    mc(1259) <= "0000000101100000000000100010010110100001010";
    mc(1260) <= "0000000101100000000110000000000010000101001";
    mc(1256) <= "0000000000000000000000000000010010001001000";
    mc(1257) <= "0000000000000000000000000000010010101001000";
    mc(1280) <= "0010110000001000000000000000010010101001000";
    mc(1281) <= "0000111000000000000000000000010010101001000";
    mc(1290) <= "0000001000000000000000100100010000101101000";
    mc(1291) <= "0000111000000000000001100010010110001101000";
    mc(1292) <= "0000111000000000000010100010010110001101000";
    mc(1293) <= "0000111000000000000000000000010110000001001";
    mc(1288) <= "0010110000000010000000000000010010001001000";
    mc(1289) <= "0000111000000000000000000000010010101001000";
    mc(1296) <= "0010110000000100000000000000010010101001000";
    mc(1297) <= "0000111000000000000000000000010010101001000";
    mc(1352) <= "0010110000000010000000000000010010101001000";
    mc(1353) <= "0000111000000000000000000000010010101001000";
    mc(1314) <= "0000111000000000000000000000010000101101001";
    mc(1312) <= "0010110000001000000000000000010010001001000";
    mc(1313) <= "0000111000000000000000000000010010101001000";
    mc(1322) <= "0000111000000000000000000000010000101101001";
    mc(1320) <= "0010110000000010000000000000010010001001000";
    mc(1321) <= "0000111000000000000000000000010010101001000";
    mc(1330) <= "0000111000000000000000000000010000101101001";
    mc(1328) <= "0010110000000100000000000000010010001001000";
    mc(1329) <= "0000111000000000000000000000010010101001000";
    mc(1378) <= "0000111000000000000000100010010010101001000";
    mc(1379) <= "0000111000000000000000000000010110100001001";
    mc(1376) <= "0010110000001000000000000000010010001001000";
    mc(1377) <= "0000111000000000000000000000010010101001000";
    mc(1386) <= "0000111000000000000000100010010010101001000";
    mc(1387) <= "0000111000000000000000000000010110100001001";
    mc(1384) <= "0010110000000010000000000000010010001001000";
    mc(1385) <= "0000111000000000000000000000010010101001000";
    mc(1394) <= "0000111000000000000000100010010010101001000";
    mc(1395) <= "0000111000000000000000000000010110100001001";
    mc(1392) <= "0010110000000100000000000000010010001001000";
    mc(1393) <= "0000111000000000000000000000010010101001000";
    mc(1418) <= "0000110000000000000000100010010000101101000";
    mc(1419) <= "0000010000000000000010100100010110001101000";
    mc(1420) <= "0000111000000000000000100010010110000001010";
    mc(1421) <= "0000111000000000000110000000000010000101001";
    mc(1416) <= "0010110000000010000000000000010010001001000";
    mc(1417) <= "0000111000000000000000000000010010101001000";
    mc(1442) <= "0000001000000000000000100100010010101001000";
    mc(1443) <= "0000111000000000000000000000010110001101001";
    mc(1440) <= "0010110000001000000000000000010010001001000";
    mc(1441) <= "0000111000000000000000000000010010101001000";
    mc(1450) <= "0000001000000000000000100100010010101001000";
    mc(1451) <= "0000111000000000000000000000010110001101001";
    mc(1448) <= "0010110000000010000000000000010010001001000";
    mc(1449) <= "0000111000000000000000000000010010101001000";
    mc(1458) <= "0000010000000000000000100100010010101001000";
    mc(1459) <= "0000111000000000000000000000010110001101001";
    mc(1456) <= "0010110000000100000000000000010010001001000";
    mc(1457) <= "0000111000000000000000000000010010101001000";
    mc(1482) <= "0000010000000000000000100100010010101001000";
    mc(1483) <= "0000111000000000000000100010010110100001010";
    mc(1484) <= "0000111000000000000110000000000010000101001";
    mc(1480) <= "0010110000000010000000000000010010001001000";
    mc(1481) <= "0000111000000000000000000000010010101001000";
    mc(1506) <= "0000001000000000000000100100010010101001000";
    mc(1507) <= "0000111000000000000000100010010110100001010";
    mc(1508) <= "0000111000000000000110000000000010000101001";
    mc(1504) <= "0010110000001000000000000000010010001001000";
    mc(1505) <= "0000111000000000000000000000010010101001000";
    mc(1514) <= "0000001000000000000000100100010010101001000";
    mc(1515) <= "0000111000000000000000100010010110100001010";
    mc(1516) <= "0000111000000000000110000000000010000101001";
    mc(1512) <= "0010110000000010000000000000010010001001000";
    mc(1513) <= "0000111000000000000000000000010010101001000";
    mc(1522) <= "0000010000000000000000100100010010101001000";
    mc(1523) <= "0000111000000000000000100010010110100001010";
    mc(1524) <= "0000111000000000000110000000000010000101001";
    mc(1520) <= "0010110000000100000000000000010010001001000";
    mc(1521) <= "0000111000000000000000000000010010101001000";
    mc(1536) <= "0000010000000000000001000100010010101001000";
    mc(1537) <= "1001100001100000000010000000010010101001000";
    mc(1543) <= "0010000001000000000000000000010010101001000";
    mc(1546) <= "0000001000000000000000100100010000101101000";
    mc(1547) <= "0000111000000000000001100010010110001101000";
    mc(1548) <= "0000111000000000000010100010010110001101000";
    mc(1549) <= "0000111000000000000000000000010110000001001";
    mc(1544) <= "0000000000000000000001000100010010001001000";
    mc(1545) <= "1001100001100000000010000000010010101001000";
    mc(1551) <= "0010000001000000000000000000010010101001000";
    mc(1570) <= "0000111000000000000000000000010000101101001";
    mc(1568) <= "0000010000000000000001000100010010001001000";
    mc(1569) <= "1001100001100000000010000000010010101001000";
    mc(1575) <= "0010000001000000000000000000010010101001000";
    mc(1578) <= "0000111000000000000000000000010000101101001";
    mc(1576) <= "0000000000000000000001000100010010001001000";
    mc(1577) <= "1001100001100000000010000000010010101001000";
    mc(1583) <= "0010000001000000000000000000010010101001000";
    mc(1608) <= "0000000000000000000001000100010010101001000";
    mc(1609) <= "1001100001100000000010000000010010101001000";
    mc(1615) <= "0010000001000000000000000000010010101001000";
    mc(1634) <= "0000111000000000000000100010010010101001000";
    mc(1635) <= "0000111000000000000000000000010110100001001";
    mc(1632) <= "0000010000000000000001000100010010001001000";
    mc(1633) <= "1001100001100000000010000000010010101001000";
    mc(1639) <= "0010000001000000000000000000010010101001000";
    mc(1642) <= "0000111000000000000000100010010010101001000";
    mc(1643) <= "0000111000000000000000000000010110100001001";
    mc(1640) <= "0000000000000000000001000100010010001001000";
    mc(1641) <= "1001100001100000000010000000010010101001000";
    mc(1647) <= "0010000001000000000000000000010010101001000";
    mc(1674) <= "0000110000000000000000100010010000101101000";
    mc(1675) <= "0000010000000000000010100100010110001101000";
    mc(1676) <= "0000111000000000000000100010010110000001010";
    mc(1677) <= "0000111000000000000110000000000010000101001";
    mc(1672) <= "0000000000000000000001000100010010001001000";
    mc(1673) <= "1001100001100000000010000000010010101001000";
    mc(1679) <= "0010000001000000000000000000010010101001000";
    mc(1706) <= "0000001000000000000000100100010010101001000";
    mc(1707) <= "0000111000000000000000000000010110001101001";
    mc(1704) <= "0000000000000000000001000100010010001001000";
    mc(1705) <= "1001100001100000000010000000010010101001000";
    mc(1711) <= "0010000001000000000000000000010010101001000";
    mc(1738) <= "0000010000000000000000100100010010101001000";
    mc(1739) <= "0000111000000000000000100010010110100001010";
    mc(1740) <= "0000111000000000000110000000000010000101001";
    mc(1736) <= "0000000000000000000001000100010010001001000";
    mc(1737) <= "1001100001100000000010000000010010101001000";
    mc(1743) <= "0010000001000000000000000000010010101001000";
    mc(1770) <= "0000001000000000000000100100010010101001000";
    mc(1771) <= "0000111000000000000000100010010110100001010";
    mc(1772) <= "0000111000000000000110000000000010000101001";
    mc(1768) <= "0000000000000000000001000100010010001001000";
    mc(1769) <= "1001100001100000000010000000010010101001000";
    mc(1775) <= "0010000001000000000000000000010010101001000";
    mc(1792) <= "0000001000000000000001000100010010101001000";
    mc(1793) <= "1001100001100000000010000000010010101001000";
    mc(1799) <= "0010000001000000000000000000010010101001000";
    mc(1826) <= "0000111000000000000000000000010000101101001";
    mc(1824) <= "0000001000000000000001000100010010001001000";
    mc(1825) <= "1001100001100000000010000000010010101001000";
    mc(1831) <= "0010000001000000000000000000010010101001000";
    mc(1890) <= "0000111000000000000000100010010010101001000";
    mc(1891) <= "0000111000000000000000000000010110100001001";
    mc(1888) <= "0000001000000000000001000100010010001001000";
    mc(1889) <= "1001100001100000000010000000010010101001000";
    mc(1895) <= "0010000001000000000000000000010010101001000";
    mc(1802) <= "0000001000000000000000100100010000101101000";
    mc(1803) <= "0000111000000000000001100010010110001101000";
    mc(1804) <= "0000111000000000000010100010010110001101000";
    mc(1805) <= "0000111000000000000000000000010110000001001";
    mc(1800) <= "0000000000000000000001000100010010001001000";
    mc(1801) <= "0011100001100010100100000000010010101001000";
    mc(1807) <= "0010000001000000000000000000010010101001000";
    mc(1834) <= "0000111000000000000000000000010000101101001";
    mc(1832) <= "0000000000000000000001000100010010001001000";
    mc(1833) <= "0011100001100010100100000000010010101001000";
    mc(1839) <= "0010000001000000000000000000010010101001000";
    mc(1864) <= "0000000000000000000001000100010010101001000";
    mc(1865) <= "0011100001100010100100000000010010101001000";
    mc(1871) <= "0010000001000000000000000000010010101001000";
    mc(1898) <= "0000111000000000000000100010010010101001000";
    mc(1899) <= "0000111000000000000000000000010110100001001";
    mc(1896) <= "0000000000000000000001000100010010001001000";
    mc(1897) <= "0011100001100010100100000000010010101001000";
    mc(1903) <= "0010000001000000000000000000010010101001000";
    mc(1930) <= "0000110000000000000000100010010000101101000";
    mc(1931) <= "0000010000000000000010100100010110001101000";
    mc(1932) <= "0000111000000000000000100010010110000001010";
    mc(1933) <= "0000111000000000000110000000000010000101001";
    mc(1928) <= "0000000000000000000001000100010010001001000";
    mc(1929) <= "0011100001100010100100000000010010101001000";
    mc(1935) <= "0010000001000000000000000000010010101001000";
    mc(1962) <= "0000001000000000000000100100010010101001000";
    mc(1963) <= "0000111000000000000000000000010110001101001";
    mc(1960) <= "0000000000000000000001000100010010001001000";
    mc(1961) <= "0011100001100010100100000000010010101001000";
    mc(1967) <= "0010000001000000000000000000010010101001000";
    mc(1994) <= "0000010000000000000000100100010010101001000";
    mc(1995) <= "0000111000000000000000100010010110100001010";
    mc(1996) <= "0000111000000000000110000000000010000101001";
    mc(1992) <= "0000000000000000000001000100010010001001000";
    mc(1993) <= "0011100001100010100100000000010010101001000";
    mc(1999) <= "0010000001000000000000000000010010101001000";
    mc(2026) <= "0000001000000000000000100100010010101001000";
    mc(2027) <= "0000111000000000000000100010010110100001010";
    mc(2028) <= "0000111000000000000110000000000010000101001";
    mc(2024) <= "0000000000000000000001000100010010001001000";
    mc(2025) <= "0011100001100010100100000000010010101001000";
    mc(2031) <= "0010000001000000000000000000010010101001000";
    mc(130) <= "0000110000000000000001100100010010101001100";
    mc(131) <= "0000101011100000000000100100110110001001011";
    mc(128) <= "0000111000000000000110000001010010000101000";
    mc(129) <= "0000111000000000000000000000010010101001000";
    mc(386) <= "0000110000000000000001100100010010101001100";
    mc(387) <= "0000101011100000000000100100110110001001011";
    mc(384) <= "0000111000000000000110000001010010000101000";
    mc(385) <= "0000111000000000000000000000010010101001000";
    mc(642) <= "0000110000000000000001100100010010101001100";
    mc(643) <= "0000101011100000000000100100110110001001011";
    mc(640) <= "0000111000000000000110000001010010000101000";
    mc(641) <= "0000111000000000000000000000010010101001000";
    mc(898) <= "0000110000000000000001100100010010101001100";
    mc(899) <= "0000101011100000000000100100110110001001011";
    mc(896) <= "0000111000000000000110000001010010000101000";
    mc(897) <= "0000111000000000000000000000010010101001000";
    mc(1154) <= "0000110000000000000001100100010010101001100";
    mc(1155) <= "0000101011100000000000100100110110001001011";
    mc(1152) <= "0000111000000000000110000001010010000101000";
    mc(1153) <= "0000111000000000000000000000010010101001000";
    mc(1410) <= "0000110000000000000001100100010010101001100";
    mc(1411) <= "0000101011100000000000100100110110001001011";
    mc(1408) <= "0000111000000000000110000001010010000101000";
    mc(1409) <= "0000111000000000000000000000010010101001000";
    mc(1666) <= "0000110000000000000001100100010010101001100";
    mc(1667) <= "0000101011100000000000100100110110001001011";
    mc(1664) <= "0000111000000000000110000001010010000101000";
    mc(1665) <= "0000111000000000000000000000010010101001000";
    mc(1922) <= "0000110000000000000001100100010010101001100";
    mc(1923) <= "0000101011100000000000100100110110001001011";
    mc(1920) <= "0000111000000000000110000001010010000101000";
    mc(1921) <= "0000111000000000000000000000010010101001000";
    mc(50) <= "0000111000000000000000000000010000101101000";
    mc(51) <= "0000110000000000000000100100000010001000000";
    mc(52) <= "1001100101100000000001100100000010001000001";
    mc(48) <= "0000100000000000000000000000010010001001000";
    mc(49) <= "0000111000000000000000000000010010101001000";
    mc(80) <= "0000000001000000000000100100010010001001000";
    mc(81) <= "1001100001100010000000000000010010101001000";
    mc(114) <= "0000111000000000000000100010010010101001000";
    mc(115) <= "0000111000000000000000000000010110100001000";
    mc(116) <= "0000110000000000000000100100000010001000000";
    mc(117) <= "1001100101100000000001100100000010001000001";
    mc(112) <= "0000100000000000000000000000010010001001000";
    mc(113) <= "0000111000000000000000000000010010101001000";
    mc(178) <= "0000001000000000000000100100010010101001000";
    mc(179) <= "0000111000000000000000000000010110001101000";
    mc(180) <= "0000110000000000000000100100000010001000000";
    mc(181) <= "1001100101100000000001100100000010001000001";
    mc(176) <= "0000100000000000000000000000010010001001000";
    mc(177) <= "0000111000000000000000000000010010101001000";
    mc(242) <= "0000001000000000000000100100010010101001000";
    mc(243) <= "0000111000000000000000100010010110100001000";
    mc(244) <= "0000111000000000000110000000000010000101000";
    mc(245) <= "0000110000000000000000100100000010001000000";
    mc(246) <= "1001100101100000000001100100000010001000001";
    mc(240) <= "0000100000000000000000000000010010001001000";
    mc(241) <= "0000111000000000000000000000010010101001000";
    mc(306) <= "0000111000000000000000000000010000101101000";
    mc(307) <= "0000110000000000000000100100000010001000000";
    mc(308) <= "1001100101100000000101100100000010001000001";
    mc(304) <= "0000100000000000000000000000010010001001000";
    mc(305) <= "0000111000000000000000000000010010101001000";
    mc(336) <= "0000000001000000000000100100010010001001000";
    mc(337) <= "1001100001100010000100000000010010101001000";
    mc(370) <= "0000111000000000000000100010010010101001000";
    mc(371) <= "0000111000000000000000000000010110100001000";
    mc(372) <= "0000110000000000000000100100000010001000000";
    mc(373) <= "1001100101100000000101100100000010001000001";
    mc(368) <= "0000100000000000000000000000010010001001000";
    mc(369) <= "0000111000000000000000000000010010101001000";
    mc(434) <= "0000001000000000000000100100010010101001000";
    mc(435) <= "0000111000000000000000000000010110001101000";
    mc(436) <= "0000110000000000000000100100000010001000000";
    mc(437) <= "1001100101100000000101100100000010001000001";
    mc(432) <= "0000100000000000000000000000010010001001000";
    mc(433) <= "0000111000000000000000000000010010101001000";
    mc(498) <= "0000001000000000000000100100010010101001000";
    mc(499) <= "0000111000000000000000100010010110100001000";
    mc(500) <= "0000111000000000000110000000000010000101000";
    mc(501) <= "0000110000000000000000100100000010001000000";
    mc(502) <= "1001100101100000000101100100000010001000001";
    mc(496) <= "0000100000000000000000000000010010001001000";
    mc(497) <= "0000111000000000000000000000010010101001000";
    mc(562) <= "0000111000000000000000000000010000101101000";
    mc(563) <= "0000110000000000000000100100000010001000000";
    mc(564) <= "1001100101100000101001100100000010001000001";
    mc(560) <= "0000100000000000000000000000010010001001000";
    mc(561) <= "0000111000000000000000000000010010101001000";
    mc(592) <= "0000000001000000000000100100010010001001000";
    mc(593) <= "1001100001100010101000000000010010101001000";
    mc(626) <= "0000111000000000000000100010010010101001000";
    mc(627) <= "0000111000000000000000000000010110100001000";
    mc(628) <= "0000110000000000000000100100000010001000000";
    mc(629) <= "1001100101100000101001100100000010001000001";
    mc(624) <= "0000100000000000000000000000010010001001000";
    mc(625) <= "0000111000000000000000000000010010101001000";
    mc(690) <= "0000001000000000000000100100010010101001000";
    mc(691) <= "0000111000000000000000000000010110001101000";
    mc(692) <= "0000110000000000000000100100000010001000000";
    mc(693) <= "1001100101100000101001100100000010001000001";
    mc(688) <= "0000100000000000000000000000010010001001000";
    mc(689) <= "0000111000000000000000000000010010101001000";
    mc(754) <= "0000001000000000000000100100010010101001000";
    mc(755) <= "0000111000000000000000100010010110100001000";
    mc(756) <= "0000111000000000000110000000000010000101000";
    mc(757) <= "0000110000000000000000100100000010001000000";
    mc(758) <= "1001100101100000101001100100000010001000001";
    mc(752) <= "0000100000000000000000000000010010001001000";
    mc(753) <= "0000111000000000000000000000010010101001000";
    mc(818) <= "0000111000000000000000000000010000101101000";
    mc(819) <= "0000110000000000000000100100000010001000000";
    mc(820) <= "1001100101100000101101100100000010001000001";
    mc(816) <= "0000100000000000000000000000010010001001000";
    mc(817) <= "0000111000000000000000000000010010101001000";
    mc(848) <= "0000000001000000000000100100010010001001000";
    mc(849) <= "1001100001100010101100000000010010101001000";
    mc(882) <= "0000111000000000000000100010010010101001000";
    mc(883) <= "0000111000000000000000000000010110100001000";
    mc(884) <= "0000110000000000000000100100000010001000000";
    mc(885) <= "1001100101100000101101100100000010001000001";
    mc(880) <= "0000100000000000000000000000010010001001000";
    mc(881) <= "0000111000000000000000000000010010101001000";
    mc(946) <= "0000001000000000000000100100010010101001000";
    mc(947) <= "0000111000000000000000000000010110001101000";
    mc(948) <= "0000110000000000000000100100000010001000000";
    mc(949) <= "1001100101100000101101100100000010001000001";
    mc(944) <= "0000100000000000000000000000010010001001000";
    mc(945) <= "0000111000000000000000000000010010101001000";
    mc(1010) <= "0000001000000000000000100100010010101001000";
    mc(1011) <= "0000111000000000000000100010010110100001000";
    mc(1012) <= "0000111000000000000110000000000010000101000";
    mc(1013) <= "0000110000000000000000100100000010001000000";
    mc(1014) <= "1001100101100000101101100100000010001000001";
    mc(1008) <= "0000100000000000000000000000010010001001000";
    mc(1009) <= "0000111000000000000000000000010010101001000";
    mc(192) <= "0110111000000000000000000000010010001001000";
    mc(193) <= "0000111000000000000000000000010010101001000";
    mc(448) <= "0110111000000000000000000000010010001001000";
    mc(449) <= "0000111000000000000000000000010010101001000";
    mc(704) <= "0101111000000000000000000000010010001001000";
    mc(705) <= "0000111000000000000000000000010010101001000";
    mc(960) <= "0101111000000000000000000000010010001001000";
    mc(961) <= "0000111000000000000000000000010010101001000";
    mc(1472) <= "0111111000000000000000000000010010001001000";
    mc(1473) <= "0000111000000000000000000000010010101001000";
    mc(1728) <= "0100111000000000000000000000010010001001000";
    mc(1729) <= "0000111000000000000000000000010010101001000";
    mc(1984) <= "0100111000000000000000000000010010001001000";
    mc(1985) <= "0000111000000000000000000000010010101001000";
    mc(1104) <= "0010001001100010000000000000010010001001000";
    mc(1105) <= "0000111000000000000000000000010010101001000";
    mc(1216) <= "0010010001100010000000000000010010001001000";
    mc(1217) <= "0000111000000000000000000000010010101001000";
    mc(1232) <= "0000001001110000000000000000010010001001000";
    mc(1233) <= "0000111000000000000000000000010010101001000";
    mc(1344) <= "0010000001101000000000000000010010001001000";
    mc(1345) <= "0000111000000000000000000000010010101001000";
    mc(1360) <= "0010000001100100000000000000010010001001000";
    mc(1361) <= "0000111000000000000000000000010010101001000";
    mc(1488) <= "0010011001100100000000000000010010001001000";
    mc(1489) <= "0000111000000000000000000000010010101001000";
    mc(1088) <= "0000010000100000000001000100010010001001000";
    mc(1089) <= "0010100001101000000000000000010010101001000";
    mc(1616) <= "0000001000100000000001000100010010001001000";
    mc(1617) <= "0010100001100100000000000000010010101001000";
    mc(1600) <= "0000010000100000000000100100010010001001000";
    mc(1601) <= "0010100001101000000010000000010010101001000";
    mc(1856) <= "0000001000100000000000100100010010001001000";
    mc(1857) <= "0010100001100100000010000000010010101001000";
    mc(1586) <= "0000111000000000000000000000010000101101000";
    mc(1587) <= "0000111000000000000000100100000010001000000";
    mc(1588) <= "0010100101100000000001100100000010001000001";
    mc(1584) <= "0000111000000000000000000000010010001001000";
    mc(1585) <= "0000111000000000000000000000010010101001000";
    mc(1650) <= "0000111000000000000000100010010010101001000";
    mc(1651) <= "0000111000000000000000000000010110100001000";
    mc(1652) <= "0000111000000000000000100100000010001000000";
    mc(1653) <= "0010100101100000000001100100000010001000001";
    mc(1648) <= "0000111000000000000000000000010010001001000";
    mc(1649) <= "0000111000000000000000000000010010101001000";
    mc(1714) <= "0000001000000000000000100100010010101001000";
    mc(1715) <= "0000111000000000000000000000010110001101000";
    mc(1716) <= "0000111000000000000000100100000010001000000";
    mc(1717) <= "0010100101100000000001100100000010001000001";
    mc(1712) <= "0000111000000000000000000000010010001001000";
    mc(1713) <= "0000111000000000000000000000010010101001000";
    mc(1778) <= "0000001000000000000000100100010010101001000";
    mc(1779) <= "0000111000000000000000100010010110100001000";
    mc(1780) <= "0000111000000000000110000000000010000101000";
    mc(1781) <= "0000111000000000000000100100000010001000000";
    mc(1782) <= "0010100101100000000001100100000010001000001";
    mc(1776) <= "0000111000000000000000000000010010001001000";
    mc(1777) <= "0000111000000000000000000000010010101001000";
    mc(1842) <= "0000111000000000000000000000010000101101000";
    mc(1843) <= "0000110000000000000000100010000010001000000";
    mc(1844) <= "0010100101100000000011100100000010001000001";
    mc(1840) <= "0000111000000000000000000000010010001001000";
    mc(1841) <= "0000111000000000000000000000010010101001000";
    mc(1906) <= "0000111000000000000000100010010010101001000";
    mc(1907) <= "0000111000000000000000000000010110100001000";
    mc(1908) <= "0000110000000000000000100010000010001000000";
    mc(1909) <= "0010100101100000000011100100000010001000001";
    mc(1904) <= "0000111000000000000000000000010010001001000";
    mc(1905) <= "0000111000000000000000000000010010101001000";
    mc(1970) <= "0000001000000000000000100100010010101001000";
    mc(1971) <= "0000111000000000000000000000010110001101000";
    mc(1972) <= "0000110000000000000000100010000010001000000";
    mc(1973) <= "0010100101100000000011100100000010001000001";
    mc(1968) <= "0000111000000000000000000000010010001001000";
    mc(1969) <= "0000111000000000000000000000010010101001000";
    mc(2034) <= "0000001000000000000000100100010010101001000";
    mc(2035) <= "0000111000000000000000100010010110100001000";
    mc(2036) <= "0000111000000000000110000000000010000101000";
    mc(2037) <= "0000110000000000000000100010000010001000000";
    mc(2038) <= "0010100101100000000011100100000010001000001";
    mc(2032) <= "0000111000000000000000000000010010001001000";
    mc(2033) <= "0000111000000000000000000000010010101001000";
    mc(66) <= "0000111111000000000000000000010100010001001";
    mc(64) <= "0000011000100000000001000100010010001001000";
    mc(65) <= "0000100000010000000000000000010010101001000";
    mc(578) <= "0000111101000000000000000000010100010001001";
    mc(576) <= "0000011000100000000001000100010010001001000";
    mc(577) <= "0000100000010000000000000000010010101001000";
    mc(322) <= "0000111000100000000001100010010100010001000";
    mc(323) <= "0000100000110000000010000000010110010001001";
    mc(320) <= "0001110000000000000000000000010010001001000";
    mc(321) <= "0000111000000000000000000000010010101001000";
    mc(834) <= "0000111000100000000001100010010100010001000";
    mc(835) <= "0000100000110000000010000000010110010001001";
    mc(832) <= "0010110000000010000000000000010010001001000";
    mc(833) <= "0000111000000000000000000000010010101001000";
    mc(258) <= "0000110010110000000001100010010100110001000";
    mc(259) <= "0000111110100000000000000100010110010001000";
    mc(260) <= "0000111110000000000001100100010110010001000";
    mc(261) <= "0000100000000000000000100100010010001001001";
    mc(256) <= "0000100000010001111000000001110100000001000";
    mc(257) <= "0000111000000000000000000000010010101001000";
    mc(770) <= "0000110000000000000001100010010100110001000";
    mc(771) <= "0000111000000000000011100010010110010001000";
    mc(772) <= "0000100000010000000010100010010110010001000";
    mc(773) <= "0000111000000000000000000001110110000001001";
    mc(768) <= "0000111000000000000000000000010010101001000";
    mc(769) <= "0000111000000000000000000000010010101001000";
    mc(514) <= "0000110000000000000001100010010100110001000";
    mc(515) <= "0000111000000000000011100010010110010001000";
    mc(516) <= "0001111000000000000011100010010110010001000";
    mc(517) <= "0000100000010000000010100010010110010001001";
    mc(512) <= "0000111000000000000000000001110110000001000";
    mc(513) <= "0000111000000000000000000000010010101001000";
    mc(610) <= "0000111000000000000000100010010010101001001";
    mc(608) <= "0000111000000000000000000001110110000001000";
    mc(609) <= "0000111000000000000000000000010010101001000";
    mc(866) <= "0000111000000000000000100010010010101001000";
    mc(867) <= "0000111000000000000000000001110110000001000";
    mc(868) <= "0000111000000000000000100010010010101001001";
    mc(864) <= "0000111000000000000000000001110110000001000";
    mc(865) <= "0000111000000000000000000000010010101001000";
    mc(1872) <= "0000111000000000000000000000010010001001000";
    mc(1873) <= "0000111000000000000000000000010010101001000";
    mc(1026) <= "0000110000000000000001100100010010101001000";
    mc(1027) <= "0000101011100000000000100100110110001001011";
    mc(1024) <= "0000111000000000000110000001010010000101000";
    mc(1025) <= "0000111000000000000000000000010010101001000";
    mc(1746) <= "0000001101100000000000000000010100010001001";
    mc(1744) <= "0000011000100000000001000100010010001001000";
    mc(1745) <= "0000100000010000000000000000010010101001000";
    mc(722) <= "0000010101100000000000000000010100010001001";
    mc(720) <= "0000011000100000000001000100010010001001000";
    mc(721) <= "0000100000010000000000000000010010101001000";
    mc(2002) <= "0000111000100000000001100010010100010001000";
    mc(2003) <= "0000100000110000000010000000010110010001001";
    mc(2000) <= "0010110000000100000000000000010010001001000";
    mc(2001) <= "0000111000000000000000000000010010101001000";
    mc(978) <= "0000111000100000000001100010010100010001000";
    mc(979) <= "0000100000110000000010000000010110010001001";
    mc(976) <= "0010110000001000000000000000010010001001000";
    mc(977) <= "0000111000000000000000000000010010101001000";
    mc(994) <= "0000001000000000000000100100010010101001000";
    mc(995) <= "0000111000000000000000100010110110000001000";
    mc(996) <= "0000111000000000000110000001010010000101000";
    mc(997) <= "0000111000000000000000100010010010101001001";
    mc(992) <= "0000111000000000000000000001110110000001000";
    mc(993) <= "0000111000000000000000000000010010101001000";
    mc(464) <= "0000000000100000000001000100010010001001000";
    mc(465) <= "0010100001100010000000000000010010101001000";
    mc(208) <= "0000000000100000000000100100010010001001000";
    mc(209) <= "0010100001100010000010000000010010101001000";
    mc(146) <= "0000110000000000000000100010010000101101000";
    mc(147) <= "0000010000000000000010100010010110001101000";
    mc(148) <= "0000111000000000000000100010010110000001001";
    mc(144) <= "0000000000000000000000100100010010001001000";
    mc(145) <= "0010100001100010001000000000010010101001000";
    mc(151) <= "0010000001000000000000000000010010101001000";
    mc(402) <= "0000110000000000000000100010010000101101000";
    mc(403) <= "0000010000000000000010100010010110001101000";
    mc(404) <= "0000111000000000000000100010010110000001001";
    mc(400) <= "0000000000000000000000100100010010001001000";
    mc(401) <= "0010100001100010010000000000010010101001000";
    mc(407) <= "0010000001000000000000000000010010101001000";
    mc(658) <= "0000110000000000000000100010010000101101000";
    mc(659) <= "0000010000000000000010100010010110001101000";
    mc(660) <= "0000111000000000000000100010010110000001001";
    mc(656) <= "0000000000000000000000100100010010001001000";
    mc(657) <= "0010100001100010011000000000010010101001000";
    mc(663) <= "0010000001000000000000000000010010101001000";
    mc(914) <= "0000110000000000000000100010010000101101000";
    mc(915) <= "0000010000000000000010100010010110001101000";
    mc(916) <= "0000111000000000000000100010010110000001001";
    mc(912) <= "0000000000000000000000100100010010001001000";
    mc(913) <= "0011100001100010000100000000010010101001000";
    mc(919) <= "0010000001000000000000000000010010101001000";
    mc(1170) <= "0000110000000000000000100010010000101101000";
    mc(1171) <= "0000010000000000000010100010010110001101000";
    mc(1172) <= "0000000101100000000000100010010110000001001";
    mc(1168) <= "0000000000000000000000000000010010001001000";
    mc(1169) <= "0000000000000000000000000000010010101001000";
    mc(1426) <= "0000110000000000000000100010010000101101000";
    mc(1427) <= "0000010000000000000010100010010110001101000";
    mc(1428) <= "0000111000000000000000100010010110000001001";
    mc(1424) <= "0010110000000010000000000000010010001001000";
    mc(1425) <= "0000111000000000000000000000010010101001000";
    mc(1682) <= "0000110000000000000000100010010000101101000";
    mc(1683) <= "0000010000000000000010100010010110001101000";
    mc(1684) <= "0000111000000000000000100010010110000001001";
    mc(1680) <= "0000000000000000000001000100010010001001000";
    mc(1681) <= "1001100001100000000010000000010010101001000";
    mc(1687) <= "0010000001000000000000000000010010101001000";
    mc(1938) <= "0000110000000000000000100010010000101101000";
    mc(1939) <= "0000010000000000000010100010010110001101000";
    mc(1940) <= "0000111000000000000000100010010110000001001";
    mc(1936) <= "0000000000000000000001000100010010001001000";
    mc(1937) <= "0011100001100010100100000000010010101001000";
    mc(1943) <= "0010000001000000000000000000010010101001000";
    mc(802) <= "0000111100100000000000000000010000101101001";
    mc(800) <= "0000000000000000000000000000010010001001000";
    mc(801) <= "0000000000000000000000000000010010101001000";
    mc(930) <= "0000001000000000000000100100010010101001000";
    mc(931) <= "0000111100100000000000000000010110001101001";
    mc(928) <= "0000000000000000000000000000010010001001000";
    mc(929) <= "0000000000000000000000000000010010101001000";
    mc(1250) <= "0000111000000000000000100010010010101001000";
    mc(1251) <= "0000111100100000000000000000010110100001001";
    mc(1248) <= "0000000000000000000000000000010010001001000";
    mc(1249) <= "0000000000000000000000000000010010101001000";
    mc(1266) <= "0000001000000000000000100100010010101001000";
    mc(1267) <= "0000111100100000000000100010010110100001010";
    mc(1268) <= "0000111100100000000110000000000010000101001";
    mc(1264) <= "0000000000000000000000000000010010001001000";
    mc(1265) <= "0000000000000000000000000000010010101001000";
    mc(1096) <= "0000000000000000000000100100010010101001000";
    mc(1097) <= "1011100001100000010000000000010010101001000";
    mc(418) <= "0000001000000000000000100100010010101001000";
    mc(419) <= "0000111000000000000000000000010110001101001";
    mc(416) <= "1010000000000000000000100100010010001001000";
    mc(417) <= "1011100001100000010000000000010010101001000";
    mc(482) <= "0000001000000000000000100100010010101001000";
    mc(483) <= "0000111000000000000000100010010110100001010";
    mc(484) <= "0000111000000000000110000000000010000101001";
    mc(480) <= "1010000000000000000000100100010010001001000";
    mc(481) <= "1011100001100000010000000000010010101001000";
    mc(162) <= "0000111000000000000000000000010000101101000";
    mc(163) <= "0000000000000000000000100110000010001000000";
    mc(164) <= "0000100101100000010000000000000010001000001";
    mc(160) <= "0000000000000000000000000100010010001001000";
    mc(161) <= "1011100000000000010000000000010010101001000";
    mc(226) <= "0000111000000000000000100010010010101001000";
    mc(227) <= "0000111000000000000000000000010110100001000";
    mc(228) <= "0000000000000000000000100110000010001000000";
    mc(229) <= "0000100101100000010000000000000010001000001";
    mc(224) <= "0000000000000000000000000100010010001001000";
    mc(225) <= "1011100000000000010000000000010010101001000";
    mc(34) <= "0000111000000000000000000000010000101101000";
    mc(35) <= "0000000000000000000000100100000010001000000";
    mc(36) <= "0000100101100000001000000000000010001000001";
    mc(32) <= "0000000000000000000000000100010010001001000";
    mc(33) <= "1011100000000000010000000000010010101001000";
    mc(98) <= "0000111000000000000000100010010010101001000";
    mc(99) <= "0000111000000000000000000000010110100001000";
    mc(100) <= "0000000000000000000000100100000010001000000";
    mc(101) <= "0000100101100000001000000000000010001000001";
    mc(96) <= "0000000000000000000000000100010010001001000";
    mc(97) <= "1011100000000000010000000000010010101001000";
    mc(58) <= "0000111000000000000000000000010000101101000";
    mc(59) <= "0000111000000000000000101010000010001000000";
    mc(60) <= "0000100101100000010000000000000010001000001";
    mc(56) <= "0000111000000000000000000000010010001001000";
    mc(57) <= "0000111000000000000000000000010010101001000";
    mc(186) <= "0000111000000000000000000000010000101101000";
    mc(187) <= "0000111000000000000000101010000010001000000";
    mc(188) <= "0000100101100000010000000000000010001000001";
    mc(184) <= "0000111000000000000000000000010010001001000";
    mc(185) <= "0000111000000000000000000000010010101001000";
    mc(314) <= "0000111000000000000000000000010000101101000";
    mc(315) <= "0000111000000000000000101010000010001000000";
    mc(316) <= "0000100101100000010000000000000010001000001";
    mc(312) <= "0000111000000000000000000000010010001001000";
    mc(313) <= "0000111000000000000000000000010010101001000";
    mc(442) <= "0000111000000000000000000000010000101101000";
    mc(443) <= "0000111000000000000000101010000010001000000";
    mc(444) <= "0000100101100000010000000000000010001000001";
    mc(440) <= "0000111000000000000000000000010010001001000";
    mc(441) <= "0000111000000000000000000000010010101001000";
    mc(570) <= "0000111000000000000000000000010000101101000";
    mc(571) <= "0000111000000000000000101010000010001000000";
    mc(572) <= "0000100101100000010000000000000010001000001";
    mc(568) <= "0000111000000000000000000000010010001001000";
    mc(569) <= "0000111000000000000000000000010010101001000";
    mc(698) <= "0000111000000000000000000000010000101101000";
    mc(699) <= "0000111000000000000000101010000010001000000";
    mc(700) <= "0000100101100000010000000000000010001000001";
    mc(696) <= "0000111000000000000000000000010010001001000";
    mc(697) <= "0000111000000000000000000000010010101001000";
    mc(826) <= "0000111000000000000000000000010000101101000";
    mc(827) <= "0000111000000000000000101010000010001000000";
    mc(828) <= "0000100101100000010000000000000010001000001";
    mc(824) <= "0000111000000000000000000000010010001001000";
    mc(825) <= "0000111000000000000000000000010010101001000";
    mc(954) <= "0000111000000000000000000000010000101101000";
    mc(955) <= "0000111000000000000000101010000010001000000";
    mc(956) <= "0000100101100000010000000000000010001000001";
    mc(952) <= "0000111000000000000000000000010010001001000";
    mc(953) <= "0000111000000000000000000000010010101001000";
    mc(1082) <= "0000111000000000000000000000010000101101000";
    mc(1083) <= "0000111000000000000000101000000010001000000";
    mc(1084) <= "0000100101100000001000000000000010001000001";
    mc(1080) <= "0000111000000000000000000000010010001001000";
    mc(1081) <= "0000111000000000000000000000010010101001000";
    mc(1210) <= "0000111000000000000000000000010000101101000";
    mc(1211) <= "0000111000000000000000101000000010001000000";
    mc(1212) <= "0000100101100000001000000000000010001000001";
    mc(1208) <= "0000111000000000000000000000010010001001000";
    mc(1209) <= "0000111000000000000000000000010010101001000";
    mc(1338) <= "0000111000000000000000000000010000101101000";
    mc(1339) <= "0000111000000000000000101000000010001000000";
    mc(1340) <= "0000100101100000001000000000000010001000001";
    mc(1336) <= "0000111000000000000000000000010010001001000";
    mc(1337) <= "0000111000000000000000000000010010101001000";
    mc(1466) <= "0000111000000000000000000000010000101101000";
    mc(1467) <= "0000111000000000000000101000000010001000000";
    mc(1468) <= "0000100101100000001000000000000010001000001";
    mc(1464) <= "0000111000000000000000000000010010001001000";
    mc(1465) <= "0000111000000000000000000000010010101001000";
    mc(1594) <= "0000111000000000000000000000010000101101000";
    mc(1595) <= "0000111000000000000000101000000010001000000";
    mc(1596) <= "0000100101100000001000000000000010001000001";
    mc(1592) <= "0000111000000000000000000000010010001001000";
    mc(1593) <= "0000111000000000000000000000010010101001000";
    mc(1722) <= "0000111000000000000000000000010000101101000";
    mc(1723) <= "0000111000000000000000101000000010001000000";
    mc(1724) <= "0000100101100000001000000000000010001000001";
    mc(1720) <= "0000111000000000000000000000010010001001000";
    mc(1721) <= "0000111000000000000000000000010010101001000";
    mc(1850) <= "0000111000000000000000000000010000101101000";
    mc(1851) <= "0000111000000000000000101000000010001000000";
    mc(1852) <= "0000100101100000001000000000000010001000001";
    mc(1848) <= "0000111000000000000000000000010010001001000";
    mc(1849) <= "0000111000000000000000000000010010101001000";
    mc(1978) <= "0000111000000000000000000000010000101101000";
    mc(1979) <= "0000111000000000000000101000000010001000000";
    mc(1980) <= "0000100101100000001000000000000010001000001";
    mc(1976) <= "0000111000000000000000000000010010001001000";
    mc(1977) <= "0000111000000000000000000000010010101001000";
    mc(122) <= "0000111000000000000000000000010000101101000";
    mc(123) <= "0000110000000000000001001000010010001001000";
    mc(124) <= "0000110000000000010001100100010010101001101";
    mc(125) <= "0000101011100000000000100100110110001001011";
    mc(120) <= "0000111000000000000110000001010010000101000";
    mc(121) <= "0000111000000000000000000000010010101001000";
    mc(250) <= "0000111000000000000000000000010000101101000";
    mc(251) <= "0000110000000000000001001000010010001001000";
    mc(252) <= "0000110000000000010001100100010010101001101";
    mc(253) <= "0000101011100000000000100100110110001001011";
    mc(248) <= "0000111000000000000110000001010010000101000";
    mc(249) <= "0000111000000000000000000000010010101001000";
    mc(378) <= "0000111000000000000000000000010000101101000";
    mc(379) <= "0000110000000000000001001000010010001001000";
    mc(380) <= "0000110000000000010001100100010010101001101";
    mc(381) <= "0000101011100000000000100100110110001001011";
    mc(376) <= "0000111000000000000110000001010010000101000";
    mc(377) <= "0000111000000000000000000000010010101001000";
    mc(506) <= "0000111000000000000000000000010000101101000";
    mc(507) <= "0000110000000000000001001000010010001001000";
    mc(508) <= "0000110000000000010001100100010010101001101";
    mc(509) <= "0000101011100000000000100100110110001001011";
    mc(504) <= "0000111000000000000110000001010010000101000";
    mc(505) <= "0000111000000000000000000000010010101001000";
    mc(634) <= "0000111000000000000000000000010000101101000";
    mc(635) <= "0000110000000000000001001000010010001001000";
    mc(636) <= "0000110000000000010001100100010010101001101";
    mc(637) <= "0000101011100000000000100100110110001001011";
    mc(632) <= "0000111000000000000110000001010010000101000";
    mc(633) <= "0000111000000000000000000000010010101001000";
    mc(762) <= "0000111000000000000000000000010000101101000";
    mc(763) <= "0000110000000000000001001000010010001001000";
    mc(764) <= "0000110000000000010001100100010010101001101";
    mc(765) <= "0000101011100000000000100100110110001001011";
    mc(760) <= "0000111000000000000110000001010010000101000";
    mc(761) <= "0000111000000000000000000000010010101001000";
    mc(890) <= "0000111000000000000000000000010000101101000";
    mc(891) <= "0000110000000000000001001000010010001001000";
    mc(892) <= "0000110000000000010001100100010010101001101";
    mc(893) <= "0000101011100000000000100100110110001001011";
    mc(888) <= "0000111000000000000110000001010010000101000";
    mc(889) <= "0000111000000000000000000000010010101001000";
    mc(1018) <= "0000111000000000000000000000010000101101000";
    mc(1019) <= "0000110000000000000001001000010010001001000";
    mc(1020) <= "0000110000000000010001100100010010101001101";
    mc(1021) <= "0000101011100000000000100100110110001001011";
    mc(1016) <= "0000111000000000000110000001010010000101000";
    mc(1017) <= "0000111000000000000000000000010010101001000";
    mc(1146) <= "0000111000000000000000000000010000101101000";
    mc(1147) <= "0000110000000000000000101000010010001001000";
    mc(1148) <= "0000110000000000010001100100010010101001101";
    mc(1149) <= "0000101011100000000000100100110110001001011";
    mc(1144) <= "0000111000000000000110000001010010000101000";
    mc(1145) <= "0000111000000000000000000000010010101001000";
    mc(1274) <= "0000111000000000000000000000010000101101000";
    mc(1275) <= "0000110000000000000000101000010010001001000";
    mc(1276) <= "0000110000000000010001100100010010101001101";
    mc(1277) <= "0000101011100000000000100100110110001001011";
    mc(1272) <= "0000111000000000000110000001010010000101000";
    mc(1273) <= "0000111000000000000000000000010010101001000";
    mc(1402) <= "0000111000000000000000000000010000101101000";
    mc(1403) <= "0000110000000000000000101000010010001001000";
    mc(1404) <= "0000110000000000010001100100010010101001101";
    mc(1405) <= "0000101011100000000000100100110110001001011";
    mc(1400) <= "0000111000000000000110000001010010000101000";
    mc(1401) <= "0000111000000000000000000000010010101001000";
    mc(1530) <= "0000111000000000000000000000010000101101000";
    mc(1531) <= "0000110000000000000000101000010010001001000";
    mc(1532) <= "0000110000000000010001100100010010101001101";
    mc(1533) <= "0000101011100000000000100100110110001001011";
    mc(1528) <= "0000111000000000000110000001010010000101000";
    mc(1529) <= "0000111000000000000000000000010010101001000";
    mc(1658) <= "0000111000000000000000000000010000101101000";
    mc(1659) <= "0000110000000000000000101000010010001001000";
    mc(1660) <= "0000110000000000010001100100010010101001101";
    mc(1661) <= "0000101011100000000000100100110110001001011";
    mc(1656) <= "0000111000000000000110000001010010000101000";
    mc(1657) <= "0000111000000000000000000000010010101001000";
    mc(1786) <= "0000111000000000000000000000010000101101000";
    mc(1787) <= "0000110000000000000000101000010010001001000";
    mc(1788) <= "0000110000000000010001100100010010101001101";
    mc(1789) <= "0000101011100000000000100100110110001001011";
    mc(1784) <= "0000111000000000000110000001010010000101000";
    mc(1785) <= "0000111000000000000000000000010010101001000";
    mc(1914) <= "0000111000000000000000000000010000101101000";
    mc(1915) <= "0000110000000000000000101000010010001001000";
    mc(1916) <= "0000110000000000010001100100010010101001101";
    mc(1917) <= "0000101011100000000000100100110110001001011";
    mc(1912) <= "0000111000000000000110000001010010000101000";
    mc(1913) <= "0000111000000000000000000000010010101001000";
    mc(2042) <= "0000111000000000000000000000010000101101000";
    mc(2043) <= "0000110000000000000000101000010010001001000";
    mc(2044) <= "0000110000000000010001100100010010101001101";
    mc(2045) <= "0000101011100000000000100100110110001001011";
    mc(2040) <= "0000111000000000000110000001010010000101000";
    mc(2041) <= "0000111000000000000000000000010010101001000";
    mc(16) <= "0000111000000000000000000000010010101001000";
    mc(17) <= "0000111000000000000000000000010010101001000";
    mc(272) <= "0000111000000000000000000000010010101001000";
    mc(273) <= "0000111000000000000000000000010010101001000";
    mc(528) <= "0000111000000000000000000000010010101001000";
    mc(529) <= "0000111000000000000000000000010010101001000";
    mc(784) <= "0000111000000000000000000000010010101001000";
    mc(785) <= "0000111000000000000000000000010010101001000";
    mc(1040) <= "0000111000000000000000000000010010101001000";
    mc(1041) <= "0000111000000000000000000000010010101001000";
    mc(1552) <= "0000111000000000000000000000010010101001000";
    mc(1553) <= "0000111000000000000000000000010010101001000";
    mc(1808) <= "0000111000000000000000000000010010101001000";
    mc(1809) <= "0000111000000000000000000000010010101001000";
    mc(546) <= "0000111000000000000000000000010010101001001";
    mc(544) <= "0000111000000000000000000000010010001001000";
    mc(545) <= "0000111000000000000000000000010010101001000";
    mc(674) <= "0000111000000000000000000000010010101001000";
    mc(675) <= "0000111000000000000000000000010010001001001";
    mc(672) <= "0000111000000000000000000000010010001001000";
    mc(673) <= "0000111000000000000000000000010010101001000";
    mc(1698) <= "0000111000000000000000000000010010101001000";
    mc(1699) <= "0000111000000000000000000000010010001001001";
    mc(1696) <= "0000111000000000000000000000010010001001000";
    mc(1697) <= "0000111000000000000000000000010010101001000";
    mc(1954) <= "0000111000000000000000000000010010101001000";
    mc(1955) <= "0000111000000000000000000000010010001001001";
    mc(1952) <= "0000111000000000000000000000010010001001000";
    mc(1953) <= "0000111000000000000000000000010010101001000";
    mc(25) <= "0000111000000000000000000000010010101001000";
    mc(153) <= "0000111000000000000000000000010010101001000";
    mc(281) <= "0000111000000000000000000000010010101001000";
    mc(409) <= "0000111000000000000000000000010010101001000";
    mc(537) <= "0000111000000000000000000000010010101001000";
    mc(665) <= "0000111000000000000000000000010010101001000";
    mc(793) <= "0000111000000000000000000000010010101001000";
    mc(921) <= "0000111000000000000000000000010010101001000";
    mc(1049) <= "0000111000000000000000000000010010101001000";
    mc(1177) <= "0000111000000000000000000000010010101001000";
    mc(1305) <= "0000111000000000000000000000010010101001000";
    mc(1433) <= "0000111000000000000000000000010010101001000";
    mc(1561) <= "0000111000000000000000000000010010101001000";
    mc(1689) <= "0000111000000000000000000000010010101001000";
    mc(1817) <= "0000111000000000000000000000010010101001000";
    mc(1945) <= "0000111000000000000000000000010010101001000";
    mc(89) <= "0000111000000000000000000000010010101001000";
    mc(217) <= "0000111000000000000000000000010010101001000";
    mc(345) <= "0000111000000000000000000000010010101001000";
    mc(473) <= "0000111000000000000000000000010010101001000";
    mc(601) <= "0000111000000000000000000000010010101001000";
    mc(729) <= "0000111000000000000000000000010010101001000";
    mc(857) <= "0000111000000000000000000000010010101001000";
    mc(985) <= "0000111000000000000000000000010010101001000";
    mc(1113) <= "0000111000000000000000000000010010101001000";
    mc(1241) <= "0000111000000000000000000000010010101001000";
    mc(1369) <= "0000111000000000000000000000010010101001000";
    mc(1497) <= "0000111000000000000000000000010010101001000";
    mc(1625) <= "0000111000000000000000000000010010101001000";
    mc(1753) <= "0000111000000000000000000000010010101001000";
    mc(1881) <= "0000111000000000000000000000010010101001000";
    mc(2009) <= "0000111000000000000000000000010010101001000";
    mc(738) <= "0000111000000000000000000000010010101001000";
    mc(739) <= "0000111000000000000000000000010010101001000";
    mc(740) <= "0000111000000000000000000000010010001001000";
    mc(741) <= "0000111000000000000000000000010010001001000";
    mc(742) <= "0000111000000000000000000000010010001001000";
    mc(743) <= "0000111000000000000000000000010010001001001";
    mc(736) <= "0000111000000000000000000000010010001001000";
    mc(737) <= "0000111000000000000000000000010010101001000";
    mc(1762) <= "0000111000000000000000000000010010101001000";
    mc(1763) <= "0000111000000000000000000000010010101001001";
    mc(1760) <= "0000111000000000000000000000010010001001000";
    mc(1761) <= "0000111000000000000000000000010010101001000";
    mc(2018) <= "0000111000000000000000000000010010101001000";
    mc(2019) <= "0000111000000000000000000000010010101001001";
    mc(2016) <= "0000111000000000000000000000010010001001000";
    mc(2017) <= "0000111000000000000000000000010010101001000";
    wait;
  end process;
  
  -- Generated from always process in microcode (6502/6502_ucode.v:697)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        mc_out <= mc(To_Integer(Resize(ir & t, 13)));
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module p_reg (6502/6502_reg.v:67)
entity p_reg is
  port (
    carry : in std_logic;
    clk : in std_logic;
    db_in : in unsigned(7 downto 0);
    intg : in std_logic;
    ir5 : in std_logic;
    load_b : in std_logic;
    load_flag_decode : in unsigned(14 downto 0);
    overflow : in std_logic;
    ready : in std_logic;
    reg_p : out unsigned(7 downto 0);
    reset : in std_logic;
    sb_n : in std_logic;
    sb_z : in std_logic
  );
end entity; 

-- Generated from Verilog module p_reg (6502/6502_reg.v:67)
architecture from_verilog of p_reg is
  signal reg_p_Reg : unsigned(7 downto 0);
begin
  reg_p <= reg_p_Reg;
  
  -- Generated from always process in p_reg (6502/6502_reg.v:71)
  process (intg) is
  begin
    reg_p_Reg(4) <= not intg;
    reg_p_Reg(5) <= '1';
  end process;
  
  -- Generated from always process in p_reg (6502/6502_reg.v:77)
  process (clk) is
  begin
    if rising_edge(clk) then
      if ready = '1' then
        if load_flag_decode(2) = '1' then
          reg_p_Reg(0) <= carry;
        else
          if load_flag_decode(1) = '1' then
            reg_p_Reg(0) <= ir5;
          else
            if load_flag_decode(0) = '1' then
              reg_p_Reg(0) <= db_in(0);
            end if;
          end if;
        end if;
        if load_flag_decode(3) = '1' then
          reg_p_Reg(1) <= sb_z;
        else
          if load_flag_decode(4) = '1' then
            reg_p_Reg(1) <= db_in(1);
          end if;
        end if;
        if load_flag_decode(5) = '1' then
          reg_p_Reg(2) <= db_in(2);
        else
          if load_flag_decode(6) = '1' then
            reg_p_Reg(2) <= ir5;
          else
            if load_flag_decode(14) = '1' then
              reg_p_Reg(2) <= '1';
            end if;
          end if;
        end if;
        if load_flag_decode(7) = '1' then
          reg_p_Reg(3) <= db_in(3);
        else
          if load_flag_decode(8) = '1' then
            reg_p_Reg(3) <= ir5;
          end if;
        end if;
        if load_flag_decode(10) = '1' then
          reg_p_Reg(6) <= overflow;
        else
          if load_flag_decode(9) = '1' then
            reg_p_Reg(6) <= db_in(6);
          else
            if load_flag_decode(11) = '1' then
              reg_p_Reg(6) <= '0';
            end if;
          end if;
        end if;
        if load_flag_decode(12) = '1' then
          reg_p_Reg(7) <= sb_n;
        else
          if load_flag_decode(13) = '1' then
            reg_p_Reg(7) <= db_in(7);
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module predecode (6502/6502_timing.v:108)
entity predecode is
  port (
    active : in std_logic;
    ir_next : in unsigned(7 downto 0);
    onecycle : out std_logic;
    twocycle : out std_logic
  );
end entity; 

-- Generated from Verilog module predecode (6502/6502_timing.v:108)
architecture from_verilog of predecode is
  signal onecycle_Reg : std_logic;
  signal twocycle_Reg : std_logic;
begin
  onecycle <= onecycle_Reg;
  twocycle <= twocycle_Reg;
  
  -- Generated from always process in predecode (6502/6502_timing.v:111)
  process (ir_next) is
  begin
    if (ir_next and X"07") = X"03" then
      onecycle_Reg <= active;
    else
      onecycle_Reg <= '0';
    end if;
  end process;
  
  -- Generated from always process in predecode (6502/6502_timing.v:122)
  process (ir_next, active) is
  begin
    -- Generated from casez statement at 6502/6502_timing.v:124
    if ((ir_next(0) = 'Z') or (ir_next(0) = '0')) and ((ir_next(1) = 'Z') or (ir_next(1) = '1')) and ((ir_next(2) = 'Z') or (ir_next(2) = '0')) and ((ir_next(3) = 'Z') or (ir_next(3) = '1')) and ((ir_next(4) = 'Z') or (ir_next(4) = '1')) and ((ir_next(6) = 'Z') or (ir_next(6) = '1')) then
      twocycle_Reg <= '0';
    elsif ((ir_next(0) = 'Z') or (ir_next(0) = '0')) and ((ir_next(1) = 'Z') or (ir_next(1) = '1')) and ((ir_next(2) = 'Z') or (ir_next(2) = '0')) and ((ir_next(3) = 'Z') or (ir_next(3) = '0')) and ((ir_next(4) = 'Z') or (ir_next(4) = '0')) then
      twocycle_Reg <= active;
    elsif ((ir_next(0) = 'Z') or (ir_next(0) = '1')) and ((ir_next(2) = 'Z') or (ir_next(2) = '0')) and ((ir_next(3) = 'Z') or (ir_next(3) = '1')) and ((ir_next(4) = 'Z') or (ir_next(4) = '0')) then
      twocycle_Reg <= active;
    elsif ((ir_next(0) = 'Z') or (ir_next(0) = '0')) and ((ir_next(2) = 'Z') or (ir_next(2) = '0')) and ((ir_next(3) = 'Z') or (ir_next(3) = '0')) and ((ir_next(4) = 'Z') or (ir_next(4) = '0')) and ((ir_next(7) = 'Z') or (ir_next(7) = '1')) then
      twocycle_Reg <= active;
      -- Generated from casez statement at 6502/6502_timing.v:134
      if ((ir_next(1) = 'Z') or (ir_next(1) = '0')) and ((ir_next(5) = 'Z') or (ir_next(5) = '0')) and ((ir_next(6) = 'Z') or (ir_next(6) = '0')) then
        twocycle_Reg <= '0';
      end if;
    elsif ((ir_next(0) = 'Z') or (ir_next(0) = '0')) and ((ir_next(2) = 'Z') or (ir_next(2) = '0')) and ((ir_next(3) = 'Z') or (ir_next(3) = '1')) then
      twocycle_Reg <= active;
      -- Generated from casez statement at 6502/6502_timing.v:142
      if ((ir_next(1) = 'Z') or (ir_next(1) = '0')) and ((ir_next(4) = 'Z') or (ir_next(4) = '0')) and ((ir_next(7) = 'Z') or (ir_next(7) = '0')) then
        twocycle_Reg <= '0';
      end if;
    else
      twocycle_Reg <= '0';
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module sb_mux (6502/6502_mux.v:26)
entity sb_mux is
  port (
    alu : in unsigned(7 downto 0);
    db : in unsigned(7 downto 0);
    pch : in unsigned(7 downto 0);
    reg_a : in unsigned(7 downto 0);
    reg_s : in unsigned(7 downto 0);
    reg_x : in unsigned(7 downto 0);
    reg_y : in unsigned(7 downto 0);
    sb : out unsigned(7 downto 0);
    sb_sel : in unsigned(2 downto 0)
  );
end entity; 

-- Generated from Verilog module sb_mux (6502/6502_mux.v:26)
architecture from_verilog of sb_mux is
  signal sb_Reg : unsigned(7 downto 0);
begin
  sb <= sb_Reg;
  
  -- Generated from always process in sb_mux (6502/6502_mux.v:29)
  process (sb_sel, reg_a, reg_x, reg_y, reg_s, alu, pch, db) is
  begin
    case sb_sel is
      when "000" =>
        sb_Reg <= reg_a;
      when "001" =>
        sb_Reg <= reg_x;
      when "010" =>
        sb_Reg <= reg_y;
      when "011" =>
        sb_Reg <= reg_s;
      when "100" =>
        sb_Reg <= alu;
      when "101" =>
        sb_Reg <= pch;
      when "110" =>
        sb_Reg <= db;
      when "111" =>
        sb_Reg <= X"ff";
      when others =>
        null;
    end case;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module timing_ctrl (6502/6502_timing.v:31)
--   T0 = 0
--   T1 = 1
--   T2 = 2
--   T3 = 3
--   T4 = 4
--   T5 = 5
--   T6 = 6
--   T7 = 7
entity timing_ctrl is
  port (
    alu_carry_out : in std_logic;
    branch_page_cross : in std_logic;
    clk : in std_logic;
    decimal_cycle : in std_logic;
    decimal_extra_cycle : buffer std_logic;
    intg : in std_logic;
    load_sbz : in std_logic;
    onecycle : in std_logic;
    pc_hold : out std_logic;
    ready : in std_logic;
    reset : in std_logic;
    sync : buffer std_logic;
    t : out unsigned(2 downto 0);
    t_next : out unsigned(2 downto 0);
    taken_branch : in std_logic;
    tnext_mc : in unsigned(2 downto 0);
    twocycle : in std_logic;
    write_allowed : out std_logic
  );
end entity; 

-- Generated from Verilog module timing_ctrl (6502/6502_timing.v:31)
--   T0 = 0
--   T1 = 1
--   T2 = 2
--   T3 = 3
--   T4 = 4
--   T5 = 5
--   T6 = 6
--   T7 = 7
architecture from_verilog of timing_ctrl is
  signal t_Reg : unsigned(2 downto 0);
  signal t_next_Reg : unsigned(2 downto 0);
  signal write_allowed_Reg : std_logic;
  signal tmp_s0 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_timing.v:48
  signal tmp_s10 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s13 : unsigned(28 downto 0);  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s14 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s16 : std_logic;  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s18 : std_logic;  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s20 : std_logic;  -- Temporary created at 6502/6502_timing.v:49
  signal tmp_s3 : unsigned(28 downto 0);  -- Temporary created at 6502/6502_timing.v:48
  signal tmp_s4 : unsigned(31 downto 0);  -- Temporary created at 6502/6502_timing.v:48
  signal tmp_s6 : std_logic;  -- Temporary created at 6502/6502_timing.v:48
begin
  t <= t_Reg;
  t_next <= t_next_Reg;
  write_allowed <= write_allowed_Reg;
  decimal_extra_cycle <= tmp_s6 and load_sbz;
  tmp_s18 <= not decimal_cycle;
  tmp_s20 <= tmp_s16 and tmp_s18;
  sync <= tmp_s20 or decimal_extra_cycle;
  pc_hold <= intg or decimal_cycle;
  tmp_s0 <= tmp_s3 & t_Reg;
  tmp_s6 <= '1' when tmp_s0 = tmp_s4 else '0';
  tmp_s10 <= tmp_s13 & t_Reg;
  tmp_s16 <= '1' when tmp_s10 = tmp_s14 else '0';
  tmp_s13 <= "00000000000000000000000000000";
  tmp_s14 <= X"00000001";
  tmp_s3 <= "00000000000000000000000000000";
  tmp_s4 <= X"00000007";
  
  -- Generated from always process in timing_ctrl (6502/6502_timing.v:58)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        t_Reg <= "010";
      else
        if ready = '1' then
          t_Reg <= t_next_Reg;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in timing_ctrl (6502/6502_timing.v:67)
  process (t_Reg, onecycle, sync, twocycle, decimal_cycle, decimal_extra_cycle, tnext_mc, alu_carry_out, taken_branch, branch_page_cross) is
  begin
    t_next_Reg <= t_Reg + "001";
    write_allowed_Reg <= '1';
    if (onecycle and sync) = '1' then
      t_next_Reg <= "001";
    else
      if (twocycle and sync) = '1' then
        t_next_Reg <= "000";
      else
        if decimal_cycle = '1' then
          t_next_Reg <= "111";
        else
          if decimal_extra_cycle = '1' then
            t_next_Reg <= "010";
          end if;
        end if;
      end if;
    end if;
    if tnext_mc = "001" then
      t_next_Reg <= "000";
    else
      if (tnext_mc = "010") and ((unsigned'("0000000000000000000000000000000") & alu_carry_out) = X"00000000") then
        t_next_Reg <= "000";
      else
        if (tnext_mc = "010") and ((unsigned'("0000000000000000000000000000000") & alu_carry_out) = X"00000001") then
          write_allowed_Reg <= '0';
        else
          if (tnext_mc = "100") and ((unsigned'("0000000000000000000000000000000") & taken_branch) = X"00000000") then
            t_next_Reg <= "001";
          else
            if tnext_mc = "011" then
              if (unsigned'("0000000000000000000000000000000") & branch_page_cross) = X"00000001" then
                t_next_Reg <= "000";
              else
                t_next_Reg <= "001";
              end if;
            else
              if (tnext_mc = "101") and ((unsigned'("0000000000000000000000000000000") & alu_carry_out) = X"00000000") then
                t_next_Reg <= "001";
              else
                if (Resize(t_Reg, 32) /= X"00000001") and (tnext_mc = "111") then
                  report "Microcode KIL encountered";
                  report "SIMULATION FINISHED" severity failure;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module monitor_ctrl (monitor/monitor_ctrl.v:52)
entity monitor_ctrl is
  port (
    activity : out std_logic;
    address : in unsigned(4 downto 0);
    bit_rate_divisor : out unsigned(15 downto 0);
    clear_matrix_mode_toggle : out std_logic;
    clk : in std_logic;
    cpu_state : in unsigned(7 downto 0);
    cpu_state_write : out std_logic;
    cpu_state_write_index : out unsigned(3 downto 0);
    di : in unsigned(7 downto 0);
    do : out unsigned(7 downto 0);
    history_read_index : out unsigned(9 downto 0);
    history_write : buffer std_logic;
    history_write_index : out unsigned(9 downto 0);
    map_enables_high : in unsigned(3 downto 0);
    map_enables_low : in unsigned(3 downto 0);
    map_offset_high : in unsigned(11 downto 0);
    map_offset_low : in unsigned(11 downto 0);
    mem_address : out unsigned(19 downto 0);
    mem_attention_granted : in std_logic;
    mem_attention_request : out std_logic;
    mem_map_en : out std_logic;
    mem_rdata : in unsigned(7 downto 0);
    mem_read : out std_logic;
    mem_resolve_address : out std_logic;
    mem_wdata : out unsigned(7 downto 0);
    mem_write : out std_logic;
    monitor_char_busy : out std_logic;
    monitor_char_in : in unsigned(7 downto 0);
    monitor_char_out : out unsigned(7 downto 0);
    monitor_char_toggle : in std_logic;
    monitor_char_valid : out std_logic;
    monitor_hyper_trap : out std_logic;
    monitor_hypervisor_mode : in std_logic;
    monitor_irq_inhibit : out std_logic;
    monitor_mem_trace_mode : out std_logic;
    monitor_mem_trace_toggle : out std_logic;
    monitor_p : in unsigned(7 downto 0);
    monitor_pc : in unsigned(15 downto 0);
    monitor_watch : out unsigned(23 downto 0);
    monitor_watch_match : in std_logic;
    pixclk : in std_logic;
    protected_hardware : in unsigned(7 downto 0);
    read : in std_logic;
    reset : in std_logic;
    reset_out : out std_logic;
    rx : in std_logic;
    secure_mode_from_cpu : in std_logic;
    secure_mode_from_monitor : out std_logic;
    set_pc : out std_logic;
    terminal_emulator_ack : in std_logic;
    terminal_emulator_ready : in std_logic;
    tx : out std_logic;
    uart_char : in unsigned(7 downto 0);
    uart_char_valid : in std_logic;
    write : in std_logic
  );
end entity; 

-- Generated from Verilog module monitor_ctrl (monitor/monitor_ctrl.v:52)
architecture from_verilog of monitor_ctrl is
  signal activity_Reg : std_logic;
  signal clear_matrix_mode_toggle_Reg : std_logic;
  signal cpu_state_write_Reg : std_logic;
  signal do_Reg : unsigned(7 downto 0);
  signal history_read_index_Reg : unsigned(9 downto 0);
  signal history_write_index_Reg : unsigned(9 downto 0);
  signal mem_address_Reg : unsigned(19 downto 0);
  signal mem_attention_request_Reg : std_logic;
  signal mem_map_en_Reg : std_logic;
  signal mem_read_Reg : std_logic;
  signal mem_resolve_address_Reg : std_logic;
  signal mem_wdata_Reg : unsigned(7 downto 0);
  signal mem_write_Reg : std_logic;
  signal monitor_char_busy_Reg : std_logic;
  signal monitor_char_out_Reg : unsigned(7 downto 0);
  signal monitor_char_valid_Reg : std_logic;
  signal monitor_mem_trace_toggle_Reg : std_logic;
  signal monitor_watch_Reg : unsigned(23 downto 0);
  signal secure_mode_from_monitor_Reg : std_logic;
  signal set_pc_Reg : std_logic;
  signal tmp_s2 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:126
  signal tmp_s30 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:471
  signal tmp_s33 : unsigned(15 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:471
  signal tmp_s34 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:471
  signal tmp_s38 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:472
  signal tmp_s41 : unsigned(29 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:472
  signal tmp_s42 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:472
  signal tmp_s5 : unsigned(23 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:126
  signal tmp_s6 : unsigned(31 downto 0);  -- Temporary created at monitor/monitor_ctrl.v:126
  signal bit_rate_divisor_reg : unsigned(15 downto 0);  -- Declared at monitor/monitor_ctrl.v:188
  signal cpu_state_was_hold : std_logic;  -- Declared at monitor/monitor_ctrl.v:146
  signal cpu_state_was_hold_next : std_logic;  -- Declared at monitor/monitor_ctrl.v:148
  signal cpu_state_write_index_next : unsigned(5 downto 0);  -- Declared at monitor/monitor_ctrl.v:149
  signal cpu_state_write_index_reg : unsigned(5 downto 0);  -- Declared at monitor/monitor_ctrl.v:147
  signal flag_break_mask : unsigned(15 downto 0);  -- Declared at monitor/monitor_ctrl.v:294
  signal history_write_continuous : std_logic;  -- Declared at monitor/monitor_ctrl.v:286
  signal map_enable : std_logic;  -- Declared at monitor/monitor_ctrl.v:397
  signal map_index : unsigned(2 downto 0);  -- Declared at monitor/monitor_ctrl.v:399
  signal map_offset : unsigned(11 downto 0);  -- Declared at monitor/monitor_ctrl.v:398
  signal mem_addr_reg : unsigned(31 downto 0);  -- Declared at monitor/monitor_ctrl.v:395
  signal mem_done : std_logic;  -- Declared at monitor/monitor_ctrl.v:457
  signal mem_error : std_logic;  -- Declared at monitor/monitor_ctrl.v:458
  signal mem_read_byte : unsigned(7 downto 0);  -- Declared at monitor/monitor_ctrl.v:459
  signal mem_state : unsigned(1 downto 0);  -- Declared at monitor/monitor_ctrl.v:460
  signal mem_timeout : unsigned(15 downto 0);  -- Declared at monitor/monitor_ctrl.v:461
  signal mem_timer_expired : std_logic;  -- Declared at monitor/monitor_ctrl.v:469
  signal mem_timer_reset : std_logic;  -- Declared at monitor/monitor_ctrl.v:468
  signal mem_trace_reg : unsigned(7 downto 0);  -- Declared at monitor/monitor_ctrl.v:290
  signal monitor_break_addr : unsigned(15 downto 0);  -- Declared at monitor/monitor_ctrl.v:293
  signal monitor_break_en : std_logic;  -- Declared at monitor/monitor_ctrl.v:288
  signal monitor_break_matched : std_logic;  -- Declared at monitor/monitor_ctrl.v:292
  signal monitor_char_sent : std_logic;  -- Declared at monitor/monitor_ctrl.v:591
  signal monitor_char_toggle_last : std_logic;  -- Declared at monitor/monitor_ctrl.v:590
  signal monitor_di : unsigned(7 downto 0);  -- Declared at monitor/monitor_ctrl.v:119
  signal monitor_flag_en : std_logic;  -- Declared at monitor/monitor_ctrl.v:289
  signal monitor_watch_en : std_logic;  -- Declared at monitor/monitor_ctrl.v:287
  signal monitor_watch_matched : std_logic;  -- Declared at monitor/monitor_ctrl.v:291
  signal reset_processing : std_logic := '0';  -- Declared at monitor/monitor_ctrl.v:124
  signal reset_timeout : unsigned(7 downto 0) := "11111111";  -- Declared at monitor/monitor_ctrl.v:123
  signal rx_data : unsigned(7 downto 0);  -- Declared at monitor/monitor_ctrl.v:197
  signal rx_data_ack : std_logic;  -- Declared at monitor/monitor_ctrl.v:199
  signal rx_data_ready : std_logic;  -- Declared at monitor/monitor_ctrl.v:198
  signal tx_data : unsigned(7 downto 0);  -- Declared at monitor/monitor_ctrl.v:194
  signal tx_ready : std_logic;  -- Declared at monitor/monitor_ctrl.v:193
  signal tx_send : std_logic;  -- Declared at monitor/monitor_ctrl.v:192
  signal uart_char_waiting : std_logic;  -- Declared at monitor/monitor_ctrl.v:202
  
  component uart_rx is
    port (
      UART_RX : in std_logic;
      bit_rate_divisor : in unsigned(15 downto 0);
      clk : in std_logic;
      data : out unsigned(7 downto 0);
      data_acknowledge : in std_logic;
      data_ready : out std_logic
    );
  end component;
  
  component UART_TX_CTRL is
    port (
      BIT_TMR_MAX : in unsigned(15 downto 0);
      CLK : in std_logic;
      DATA : in unsigned(7 downto 0);
      READY : out std_logic;
      SEND : in std_logic;
      UART_TX : out std_logic
    );
  end component;
  signal UART_TX_Readable : std_logic;  -- Needed to connect outputs
begin
  activity <= activity_Reg;
  clear_matrix_mode_toggle <= clear_matrix_mode_toggle_Reg;
  cpu_state_write <= cpu_state_write_Reg;
  do <= do_Reg;
  history_read_index <= history_read_index_Reg;
  history_write_index <= history_write_index_Reg;
  mem_address <= mem_address_Reg;
  mem_attention_request <= mem_attention_request_Reg;
  mem_map_en <= mem_map_en_Reg;
  mem_read <= mem_read_Reg;
  mem_resolve_address <= mem_resolve_address_Reg;
  mem_wdata <= mem_wdata_Reg;
  mem_write <= mem_write_Reg;
  monitor_char_busy <= monitor_char_busy_Reg;
  monitor_char_out <= monitor_char_out_Reg;
  monitor_char_valid <= monitor_char_valid_Reg;
  monitor_mem_trace_toggle <= monitor_mem_trace_toggle_Reg;
  monitor_watch <= monitor_watch_Reg;
  secure_mode_from_monitor <= secure_mode_from_monitor_Reg;
  set_pc <= set_pc_Reg;
  monitor_di <= di;
  bit_rate_divisor <= bit_rate_divisor_reg;
  tmp_s2 <= tmp_s5 & reset_timeout;
  reset_out <= '1' when tmp_s2 /= tmp_s6 else '0';
  cpu_state_write_index <= cpu_state_write_index_next(0 + 3 downto 0);
  monitor_mem_trace_mode <= mem_trace_reg(0);
  monitor_flag_en <= mem_trace_reg(1);
  history_write <= mem_trace_reg(2);
  history_write_continuous <= mem_trace_reg(3);
  monitor_irq_inhibit <= mem_trace_reg(4);
  monitor_watch_en <= mem_trace_reg(6);
  monitor_break_en <= mem_trace_reg(7);
  tmp_s30 <= tmp_s33 & mem_timeout;
  mem_timer_expired <= '1' when tmp_s30 = tmp_s34 else '0';
  tmp_s38 <= tmp_s41 & mem_state;
  mem_done <= '1' when tmp_s38 = tmp_s42 else '0';
  
  -- Generated from instantiation at monitor/monitor_ctrl.v:209
  rx_ctrl: uart_rx
    port map (
      UART_RX => rx,
      bit_rate_divisor => bit_rate_divisor_reg,
      clk => pixclk,
      data => rx_data,
      data_acknowledge => rx_data_ack,
      data_ready => rx_data_ready
    );
  tx <= UART_TX_Readable;
  
  -- Generated from instantiation at monitor/monitor_ctrl.v:206
  tx_ctrl: UART_TX_CTRL
    port map (
      BIT_TMR_MAX => bit_rate_divisor_reg,
      CLK => pixclk,
      DATA => tx_data,
      READY => tx_ready,
      SEND => tx_send,
      UART_TX => UART_TX_Readable
    );
  tmp_s33 <= X"0000";
  tmp_s34 <= X"00000000";
  tmp_s41 <= "000000000000000000000000000000";
  tmp_s42 <= X"00000000";
  tmp_s5 <= X"000000";
  tmp_s6 <= X"00000000";
  monitor_hyper_trap <= '1';
  -- Removed one empty process
  
  
  -- Generated from initial process in monitor_ctrl (monitor/monitor_ctrl.v:116)
  process is
  begin
    secure_mode_from_monitor_Reg <= '0';
    wait;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:128)
  process (clk) is
  begin
    if rising_edge(clk) then
      report "reset=" & std_logic'image(reset) & ", reset_processing=" & std_logic'image(reset_processing) & ", reset_timeoud=" & integer'image(To_Integer(reset_timeout));
      if (reset and (not reset_processing)) = '1' then
        reset_processing <= '1';
        reset_timeout <= "11111111";
      else
        if (address = "01011") and (write = '1') then
          reset_timeout <= di;
        else
          if (Resize(reset_timeout, 32) /= X"00000000") and (reset_processing = '1') then
            reset_timeout <= reset_timeout - X"01";
          else
            if (not reset) = '1' then
              reset_processing <= '0';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:155)
  process (reset, cpu_state_write_index_reg, cpu_state, cpu_state_was_hold) is
  begin
    if reset = '1' then
      cpu_state_write_Reg <= '0';
      cpu_state_was_hold_next <= '0';
      cpu_state_write_index_next <= "000000";
    else
      cpu_state_write_Reg <= '0';
      cpu_state_write_index_next <= cpu_state_write_index_reg;
      if cpu_state /= X"10" then
        cpu_state_was_hold_next <= '0';
        if cpu_state_was_hold = '1' then
          cpu_state_write_Reg <= '1';
          cpu_state_write_index_next <= "000000";
        else
          if Resize(cpu_state_write_index_reg, 32) < X"00000010" then
            cpu_state_write_Reg <= '1';
            cpu_state_write_index_next <= cpu_state_write_index_reg + "000001";
          end if;
        end if;
      else
        cpu_state_was_hold_next <= '1';
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:181)
  process (clk) is
  begin
    if rising_edge(clk) then
      cpu_state_write_index_reg <= cpu_state_write_index_next;
      cpu_state_was_hold <= cpu_state_was_hold_next;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:213)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        bit_rate_divisor_reg <= X"0031";
      else
        if write = '1' then
          if address = "01100" then
            bit_rate_divisor_reg(0 + 7 downto 0) <= di;
          end if;
          if address = "01101" then
            bit_rate_divisor_reg(8 + 7 downto 8) <= di;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:227)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        tx_data <= X"ff";
        tx_send <= '0';
      else
        if (address = "01000") and (write = '1') then
          tx_data <= di;
          tx_send <= '1';
        else
          tx_send <= '0';
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:249)
  process (clk) is
  begin
    if rising_edge(clk) then
      if (unsigned'("0000000000000000000000000000000") & uart_char_valid) = X"00000001" then
        uart_char_waiting <= '1';
      end if;
      if (address = "01000") and ((unsigned'("0000000000000000000000000000000") & read) = X"00000001") then
        rx_data_ack <= '1';
        activity_Reg <= not activity_Reg;
      end if;
      if (address = "01001") and ((unsigned'("0000000000000000000000000000000") & read) = X"00000001") then
        uart_char_waiting <= '0';
        activity_Reg <= not activity_Reg;
      else
        if (unsigned'("0000000000000000000000000000000") & rx_data_ready) = X"00000000" then
          rx_data_ack <= '0';
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:272)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        history_read_index_Reg <= "0000000000";
      else
        if write = '1' then
          if address = "00000" then
            history_read_index_Reg(0 + 7 downto 0) <= di;
          end if;
          if address = "00001" then
            history_read_index_Reg(8 + 1 downto 8) <= di(0 + 1 downto 0);
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:305)
  process is
  begin
    wait until rising_edge(clk);
    if reset = '1' then
      history_write_index_Reg <= "0000000000";
      mem_trace_reg <= X"00";
      monitor_watch_matched <= '0';
      monitor_break_matched <= '0';
    else
      if write = '1' then
        if address = "00010" then
          history_write_index_Reg(0 + 7 downto 0) <= di;
          mem_trace_reg(2) <= '0';
        end if;
        if address = "00011" then
          history_write_index_Reg(8 + 1 downto 8) <= di(0 + 1 downto 0);
          mem_trace_reg(2) <= '0';
        end if;
        if address = "01010" then
          clear_matrix_mode_toggle_Reg <= not clear_matrix_mode_toggle_Reg;
        end if;
        if address = "11100" then
          secure_mode_from_monitor_Reg <= di(7);
        end if;
        if address = "00100" then
          mem_trace_reg <= di;
          if (unsigned'("0000000000000000000000000000000") & di(6)) = X"00000000" then
            monitor_watch_matched <= '0';
          end if;
          if (unsigned'("0000000000000000000000000000000") & di(7)) = X"00000000" then
            monitor_break_matched <= '0';
          end if;
        end if;
        if address = "00101" then
          monitor_mem_trace_toggle_Reg <= di(0);
        end if;
        if address = "00110" then
          flag_break_mask(0 + 7 downto 0) <= di;
        end if;
        if address = "00111" then
          flag_break_mask(8 + 7 downto 8) <= di;
        end if;
      else
        if (monitor_watch_match = '1') and (monitor_watch_en = '1') then
          mem_trace_reg(0) <= '1';
          monitor_watch_matched <= '1';
        else
          if (monitor_break_addr = monitor_pc) and (monitor_break_en = '1') then
            mem_trace_reg(0) <= '1';
            monitor_break_matched <= '1';
          else
            if (((monitor_p and flag_break_mask(8 + 7 downto 8)) /= X"00") or (((not monitor_p) and flag_break_mask(0 + 7 downto 0)) /= X"00")) and (monitor_flag_en = '1') then
              mem_trace_reg(0) <= '1';
              monitor_break_matched <= '1';
            else
              if (unsigned'("0000000000000000000000000000000") & history_write) = X"00000001" then
                wait for 0 ns;  -- Read target of blocking assignment (monitor/monitor_ctrl.v:369)
                if Resize(history_write_index_Reg, 32) < X"000003fe" then
                  wait for 0 ns;  -- Read target of blocking assignment (monitor/monitor_ctrl.v:370)
                  history_write_index_Reg <= history_write_index_Reg + "0000000001";
                else
                  if history_write_continuous = '1' then
                    history_write_index_Reg <= "0000000000";
                  else
                    mem_trace_reg(2) <= '0';
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:402)
  process is
  begin
    map_index <= Resize(mem_addr_reg(13 + 1 downto 13), 3);
    if (unsigned'("0000000000000000000000000000000") & mem_addr_reg(15)) = X"00000001" then
      map_enable <= map_enables_high(To_Integer(map_index));
      map_offset <= map_offset_high;
    else
      map_enable <= map_enables_low(To_Integer(map_index));
      map_offset <= map_offset_low;
    end if;
    mem_map_en_Reg <= '0';
    if Resize(mem_addr_reg(16 + 7 downto 16), 12) = X"077" then
      mem_resolve_address_Reg <= '1';
      wait for 0 ns;  -- Read target of blocking assignment (monitor/monitor_ctrl.v:418)
      if map_enable = '1' then
        wait for 0 ns;  -- Read target of blocking assignment (monitor/monitor_ctrl.v:419)
        mem_address_Reg(8 + 11 downto 8) <= map_offset + Resize(mem_addr_reg(8 + 7 downto 8), 12);
        mem_address_Reg(0 + 7 downto 0) <= mem_addr_reg(0 + 7 downto 0);
        mem_map_en_Reg <= '1';
      else
        mem_address_Reg <= Resize(mem_addr_reg(0 + 15 downto 0), 20);
      end if;
    else
      mem_resolve_address_Reg <= '0';
      mem_address_Reg <= mem_addr_reg(0 + 19 downto 0);
    end if;
    wait on mem_addr_reg, map_index, map_enables_high, map_offset_high, map_enables_low, map_offset_low, map_enable, map_offset;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:431)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        mem_addr_reg <= X"00000000";
      else
        if write = '1' then
          if address = "10111" then
            mem_addr_reg <= mem_addr_reg + X"00000001";
          else
            if address = "10000" then
              mem_addr_reg(0 + 7 downto 0) <= di;
            end if;
            if address = "10001" then
              mem_addr_reg(8 + 7 downto 8) <= di;
            end if;
            if address = "10010" then
              mem_addr_reg(16 + 7 downto 16) <= di;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:475)
  process (clk) is
  begin
    if rising_edge(clk) then
      if mem_timer_reset = '1' then
        mem_timeout <= "1111111111111111";
      else
        if (unsigned'("0000000000000000000000000000000") & mem_timer_expired) = X"00000000" then
          mem_timeout <= mem_timeout - X"0001";
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:484)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        mem_error <= '0';
        mem_state <= "00";
        mem_read_Reg <= '0';
        mem_write_Reg <= '0';
        set_pc_Reg <= '0';
      else
        mem_timer_reset <= '0';
        if ((mem_timer_expired = '1') and ((not mem_timer_reset) = '1')) and (Resize(mem_state, 32) /= X"00000000") then
          mem_attention_request_Reg <= '0';
          mem_error <= '1';
          mem_state <= "00";
        else
          case mem_state is
            when "00" =>
              mem_read_Reg <= '0';
              mem_write_Reg <= '0';
              set_pc_Reg <= '0';
              if (address = "10100") and (write = '1') then
                set_pc_Reg <= di(7);
                mem_read_Reg <= '1';
                mem_error <= '0';
                mem_state <= "01";
                mem_timer_reset <= '1';
              else
                if (address = "10101") and (write = '1') then
                  mem_write_Reg <= '1';
                  mem_error <= '0';
                  mem_wdata_Reg <= di;
                  mem_state <= "01";
                  mem_timer_reset <= '1';
                end if;
              end if;
            when "01" =>
              if (unsigned'("0000000000000000000000000000000") & mem_attention_granted) = X"00000000" then
                mem_timer_reset <= '1';
                mem_state <= "10";
                mem_attention_request_Reg <= '1';
              end if;
            when "10" =>
              if (unsigned'("0000000000000000000000000000000") & mem_attention_granted) = X"00000001" then
                mem_read_byte <= mem_rdata;
                mem_attention_request_Reg <= '0';
                mem_timer_reset <= '1';
                mem_state <= "11";
              end if;
            when "11" =>
              if (unsigned'("0000000000000000000000000000000") & mem_attention_granted) = X"00000000" then
                mem_state <= "00";
              end if;
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:558)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        monitor_watch_Reg <= X"000000";
      else
        if write = '1' then
          if address = "11000" then
            monitor_watch_Reg(0 + 7 downto 0) <= di;
          end if;
          if address = "11001" then
            monitor_watch_Reg(8 + 7 downto 8) <= di;
          end if;
          if address = "11010" then
            monitor_watch_Reg(16 + 7 downto 16) <= di;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:576)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        monitor_break_addr <= X"0000";
      else
        if write = '1' then
          if address = "01110" then
            monitor_break_addr(0 + 7 downto 0) <= di;
          end if;
          if address = "01111" then
            monitor_break_addr(8 + 7 downto 8) <= di;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:593)
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        monitor_char_busy_Reg <= '0';
        monitor_char_toggle_last <= monitor_char_toggle;
        monitor_char_sent <= '0';
        monitor_char_valid_Reg <= '0';
      else
        if (address = "11110") and ((unsigned'("0000000000000000000000000000000") & read) = X"00000001") then
          monitor_char_busy_Reg <= '0';
        else
          if monitor_char_toggle_last /= monitor_char_toggle then
            monitor_char_busy_Reg <= '1';
            monitor_char_toggle_last <= monitor_char_toggle;
          end if;
        end if;
        if (address = "11110") and ((unsigned'("0000000000000000000000000000000") & write) = X"00000001") then
          monitor_char_out_Reg <= di;
          monitor_char_valid_Reg <= '1';
          monitor_char_sent <= '1';
        else
          if (terminal_emulator_ack = '1') and (monitor_char_valid_Reg = '1') then
            monitor_char_valid_Reg <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Generated from always process in monitor_ctrl (monitor/monitor_ctrl.v:639)
  process (clk) is
  begin
    if rising_edge(clk) then
      case address is
        when "00100" =>
          do_Reg <= monitor_break_matched & monitor_watch_matched & mem_trace_reg(0 + 5 downto 0);
        when "00101" =>
          do_Reg <= "0000000" & monitor_mem_trace_toggle_Reg;
        when "10000" =>
          do_Reg <= mem_addr_reg(0 + 7 downto 0);
        when "10001" =>
          do_Reg <= mem_addr_reg(8 + 7 downto 8);
        when "10010" =>
          do_Reg <= mem_addr_reg(16 + 7 downto 16);
        when "10011" =>
          do_Reg <= X"00";
        when "10100" =>
          do_Reg <= mem_read_byte;
        when "10110" =>
          do_Reg <= mem_done & mem_error & "000" & monitor_hypervisor_mode & mem_state;
        when "01000" =>
          do_Reg <= rx_data;
        when "01001" =>
          do_Reg <= uart_char;
        when "01010" =>
          do_Reg <= (rx_data_ready and (not rx_data_ack)) & tx_ready & uart_char_waiting & "00000";
        when "11100" =>
          do_Reg <= Resize(secure_mode_from_cpu & "00" & cpu_state_write_index_reg, 8);
        when "11101" =>
          do_Reg <= protected_hardware;
        when "11110" =>
          do_Reg <= monitor_char_in;
        when "11111" =>
          do_Reg <= monitor_char_busy_Reg & (terminal_emulator_ready and (not monitor_char_valid_Reg)) & "000000";
        when others =>
          do_Reg <= X"ff";
      end case;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generated from Verilog module monitormem (monitor/monitor_mem.v:1)
entity monitormem is
  port (
    addr : in unsigned(11 downto 0);
    clk : in std_logic;
    di : in unsigned(7 downto 0);
    do : out unsigned(7 downto 0);
    we : in std_logic
  );
end entity; 

-- Generated from Verilog module monitormem (monitor/monitor_mem.v:1)
architecture from_verilog of monitormem is
  signal do_Reg : unsigned(7 downto 0);
  type ram_Type is array (4095 downto 0) of unsigned(7 downto 0);
  signal ram : ram_Type;  -- Declared at monitor/monitor_mem.v:7
begin
  do <= do_Reg;
  
  -- Generated from initial process in monitormem (monitor/monitor_mem.v:10)
  process is
  begin
    ram(0) <= X"00";
    ram(1) <= X"00";
    ram(2) <= X"00";
    ram(3) <= X"00";
    ram(4) <= X"00";
    ram(5) <= X"00";
    ram(6) <= X"00";
    ram(7) <= X"00";
    ram(8) <= X"00";
    ram(9) <= X"00";
    ram(10) <= X"00";
    ram(11) <= X"00";
    ram(12) <= X"00";
    ram(13) <= X"00";
    ram(14) <= X"00";
    ram(15) <= X"00";
    ram(16) <= X"00";
    ram(17) <= X"00";
    ram(18) <= X"00";
    ram(19) <= X"00";
    ram(20) <= X"00";
    ram(21) <= X"00";
    ram(22) <= X"00";
    ram(23) <= X"00";
    ram(24) <= X"00";
    ram(25) <= X"00";
    ram(26) <= X"00";
    ram(27) <= X"00";
    ram(28) <= X"00";
    ram(29) <= X"00";
    ram(30) <= X"00";
    ram(31) <= X"00";
    ram(32) <= X"00";
    ram(33) <= X"00";
    ram(34) <= X"00";
    ram(35) <= X"00";
    ram(36) <= X"00";
    ram(37) <= X"00";
    ram(38) <= X"00";
    ram(39) <= X"00";
    ram(40) <= X"00";
    ram(41) <= X"00";
    ram(42) <= X"00";
    ram(43) <= X"00";
    ram(44) <= X"00";
    ram(45) <= X"00";
    ram(46) <= X"00";
    ram(47) <= X"00";
    ram(48) <= X"00";
    ram(49) <= X"00";
    ram(50) <= X"00";
    ram(51) <= X"00";
    ram(52) <= X"00";
    ram(53) <= X"00";
    ram(54) <= X"00";
    ram(55) <= X"00";
    ram(56) <= X"00";
    ram(57) <= X"00";
    ram(58) <= X"00";
    ram(59) <= X"00";
    ram(60) <= X"00";
    ram(61) <= X"00";
    ram(62) <= X"00";
    ram(63) <= X"00";
    ram(64) <= X"00";
    ram(65) <= X"00";
    ram(66) <= X"00";
    ram(67) <= X"00";
    ram(68) <= X"00";
    ram(69) <= X"00";
    ram(70) <= X"00";
    ram(71) <= X"00";
    ram(72) <= X"00";
    ram(73) <= X"00";
    ram(74) <= X"00";
    ram(75) <= X"00";
    ram(76) <= X"00";
    ram(77) <= X"00";
    ram(78) <= X"00";
    ram(79) <= X"00";
    ram(80) <= X"00";
    ram(81) <= X"00";
    ram(82) <= X"00";
    ram(83) <= X"00";
    ram(84) <= X"00";
    ram(85) <= X"00";
    ram(86) <= X"00";
    ram(87) <= X"00";
    ram(88) <= X"00";
    ram(89) <= X"00";
    ram(90) <= X"00";
    ram(91) <= X"00";
    ram(92) <= X"00";
    ram(93) <= X"00";
    ram(94) <= X"00";
    ram(95) <= X"00";
    ram(96) <= X"00";
    ram(97) <= X"00";
    ram(98) <= X"00";
    ram(99) <= X"00";
    ram(100) <= X"00";
    ram(101) <= X"00";
    ram(102) <= X"00";
    ram(103) <= X"00";
    ram(104) <= X"00";
    ram(105) <= X"00";
    ram(106) <= X"00";
    ram(107) <= X"00";
    ram(108) <= X"00";
    ram(109) <= X"00";
    ram(110) <= X"00";
    ram(111) <= X"00";
    ram(112) <= X"00";
    ram(113) <= X"00";
    ram(114) <= X"00";
    ram(115) <= X"00";
    ram(116) <= X"00";
    ram(117) <= X"00";
    ram(118) <= X"00";
    ram(119) <= X"00";
    ram(120) <= X"00";
    ram(121) <= X"00";
    ram(122) <= X"00";
    ram(123) <= X"00";
    ram(124) <= X"00";
    ram(125) <= X"00";
    ram(126) <= X"00";
    ram(127) <= X"00";
    ram(128) <= X"00";
    ram(129) <= X"00";
    ram(130) <= X"00";
    ram(131) <= X"00";
    ram(132) <= X"00";
    ram(133) <= X"00";
    ram(134) <= X"00";
    ram(135) <= X"00";
    ram(136) <= X"00";
    ram(137) <= X"00";
    ram(138) <= X"00";
    ram(139) <= X"00";
    ram(140) <= X"00";
    ram(141) <= X"00";
    ram(142) <= X"00";
    ram(143) <= X"00";
    ram(144) <= X"00";
    ram(145) <= X"00";
    ram(146) <= X"00";
    ram(147) <= X"00";
    ram(148) <= X"00";
    ram(149) <= X"00";
    ram(150) <= X"00";
    ram(151) <= X"00";
    ram(152) <= X"00";
    ram(153) <= X"00";
    ram(154) <= X"00";
    ram(155) <= X"00";
    ram(156) <= X"00";
    ram(157) <= X"00";
    ram(158) <= X"00";
    ram(159) <= X"00";
    ram(160) <= X"00";
    ram(161) <= X"00";
    ram(162) <= X"00";
    ram(163) <= X"00";
    ram(164) <= X"00";
    ram(165) <= X"00";
    ram(166) <= X"00";
    ram(167) <= X"00";
    ram(168) <= X"00";
    ram(169) <= X"00";
    ram(170) <= X"00";
    ram(171) <= X"00";
    ram(172) <= X"00";
    ram(173) <= X"00";
    ram(174) <= X"00";
    ram(175) <= X"00";
    ram(176) <= X"00";
    ram(177) <= X"00";
    ram(178) <= X"00";
    ram(179) <= X"00";
    ram(180) <= X"00";
    ram(181) <= X"00";
    ram(182) <= X"00";
    ram(183) <= X"00";
    ram(184) <= X"00";
    ram(185) <= X"00";
    ram(186) <= X"00";
    ram(187) <= X"00";
    ram(188) <= X"00";
    ram(189) <= X"00";
    ram(190) <= X"00";
    ram(191) <= X"00";
    ram(192) <= X"00";
    ram(193) <= X"00";
    ram(194) <= X"00";
    ram(195) <= X"00";
    ram(196) <= X"00";
    ram(197) <= X"00";
    ram(198) <= X"00";
    ram(199) <= X"00";
    ram(200) <= X"00";
    ram(201) <= X"00";
    ram(202) <= X"00";
    ram(203) <= X"00";
    ram(204) <= X"00";
    ram(205) <= X"00";
    ram(206) <= X"00";
    ram(207) <= X"00";
    ram(208) <= X"00";
    ram(209) <= X"00";
    ram(210) <= X"00";
    ram(211) <= X"00";
    ram(212) <= X"00";
    ram(213) <= X"00";
    ram(214) <= X"00";
    ram(215) <= X"00";
    ram(216) <= X"00";
    ram(217) <= X"00";
    ram(218) <= X"00";
    ram(219) <= X"00";
    ram(220) <= X"00";
    ram(221) <= X"00";
    ram(222) <= X"00";
    ram(223) <= X"00";
    ram(224) <= X"00";
    ram(225) <= X"00";
    ram(226) <= X"00";
    ram(227) <= X"00";
    ram(228) <= X"00";
    ram(229) <= X"00";
    ram(230) <= X"00";
    ram(231) <= X"00";
    ram(232) <= X"00";
    ram(233) <= X"00";
    ram(234) <= X"00";
    ram(235) <= X"00";
    ram(236) <= X"00";
    ram(237) <= X"00";
    ram(238) <= X"00";
    ram(239) <= X"00";
    ram(240) <= X"00";
    ram(241) <= X"00";
    ram(242) <= X"00";
    ram(243) <= X"00";
    ram(244) <= X"00";
    ram(245) <= X"00";
    ram(246) <= X"00";
    ram(247) <= X"00";
    ram(248) <= X"00";
    ram(249) <= X"00";
    ram(250) <= X"00";
    ram(251) <= X"00";
    ram(252) <= X"00";
    ram(253) <= X"00";
    ram(254) <= X"00";
    ram(255) <= X"00";
    ram(256) <= X"00";
    ram(257) <= X"00";
    ram(258) <= X"00";
    ram(259) <= X"00";
    ram(260) <= X"00";
    ram(261) <= X"00";
    ram(262) <= X"00";
    ram(263) <= X"00";
    ram(264) <= X"00";
    ram(265) <= X"00";
    ram(266) <= X"00";
    ram(267) <= X"00";
    ram(268) <= X"00";
    ram(269) <= X"00";
    ram(270) <= X"00";
    ram(271) <= X"00";
    ram(272) <= X"00";
    ram(273) <= X"00";
    ram(274) <= X"00";
    ram(275) <= X"00";
    ram(276) <= X"00";
    ram(277) <= X"00";
    ram(278) <= X"00";
    ram(279) <= X"00";
    ram(280) <= X"00";
    ram(281) <= X"00";
    ram(282) <= X"00";
    ram(283) <= X"00";
    ram(284) <= X"00";
    ram(285) <= X"00";
    ram(286) <= X"00";
    ram(287) <= X"00";
    ram(288) <= X"00";
    ram(289) <= X"00";
    ram(290) <= X"00";
    ram(291) <= X"00";
    ram(292) <= X"00";
    ram(293) <= X"00";
    ram(294) <= X"00";
    ram(295) <= X"00";
    ram(296) <= X"00";
    ram(297) <= X"00";
    ram(298) <= X"00";
    ram(299) <= X"00";
    ram(300) <= X"00";
    ram(301) <= X"00";
    ram(302) <= X"00";
    ram(303) <= X"00";
    ram(304) <= X"00";
    ram(305) <= X"00";
    ram(306) <= X"00";
    ram(307) <= X"00";
    ram(308) <= X"00";
    ram(309) <= X"00";
    ram(310) <= X"00";
    ram(311) <= X"00";
    ram(312) <= X"00";
    ram(313) <= X"00";
    ram(314) <= X"00";
    ram(315) <= X"00";
    ram(316) <= X"00";
    ram(317) <= X"00";
    ram(318) <= X"00";
    ram(319) <= X"00";
    ram(320) <= X"00";
    ram(321) <= X"00";
    ram(322) <= X"00";
    ram(323) <= X"00";
    ram(324) <= X"00";
    ram(325) <= X"00";
    ram(326) <= X"00";
    ram(327) <= X"00";
    ram(328) <= X"00";
    ram(329) <= X"00";
    ram(330) <= X"00";
    ram(331) <= X"00";
    ram(332) <= X"00";
    ram(333) <= X"00";
    ram(334) <= X"00";
    ram(335) <= X"00";
    ram(336) <= X"00";
    ram(337) <= X"00";
    ram(338) <= X"00";
    ram(339) <= X"00";
    ram(340) <= X"00";
    ram(341) <= X"00";
    ram(342) <= X"00";
    ram(343) <= X"00";
    ram(344) <= X"00";
    ram(345) <= X"00";
    ram(346) <= X"00";
    ram(347) <= X"00";
    ram(348) <= X"00";
    ram(349) <= X"00";
    ram(350) <= X"00";
    ram(351) <= X"00";
    ram(352) <= X"00";
    ram(353) <= X"00";
    ram(354) <= X"00";
    ram(355) <= X"00";
    ram(356) <= X"00";
    ram(357) <= X"00";
    ram(358) <= X"00";
    ram(359) <= X"00";
    ram(360) <= X"00";
    ram(361) <= X"00";
    ram(362) <= X"00";
    ram(363) <= X"00";
    ram(364) <= X"00";
    ram(365) <= X"00";
    ram(366) <= X"00";
    ram(367) <= X"00";
    ram(368) <= X"00";
    ram(369) <= X"00";
    ram(370) <= X"00";
    ram(371) <= X"00";
    ram(372) <= X"00";
    ram(373) <= X"00";
    ram(374) <= X"00";
    ram(375) <= X"00";
    ram(376) <= X"00";
    ram(377) <= X"00";
    ram(378) <= X"00";
    ram(379) <= X"00";
    ram(380) <= X"00";
    ram(381) <= X"00";
    ram(382) <= X"00";
    ram(383) <= X"00";
    ram(384) <= X"00";
    ram(385) <= X"00";
    ram(386) <= X"00";
    ram(387) <= X"00";
    ram(388) <= X"00";
    ram(389) <= X"00";
    ram(390) <= X"00";
    ram(391) <= X"00";
    ram(392) <= X"00";
    ram(393) <= X"00";
    ram(394) <= X"00";
    ram(395) <= X"00";
    ram(396) <= X"00";
    ram(397) <= X"00";
    ram(398) <= X"00";
    ram(399) <= X"00";
    ram(400) <= X"00";
    ram(401) <= X"00";
    ram(402) <= X"00";
    ram(403) <= X"00";
    ram(404) <= X"00";
    ram(405) <= X"00";
    ram(406) <= X"00";
    ram(407) <= X"00";
    ram(408) <= X"00";
    ram(409) <= X"00";
    ram(410) <= X"00";
    ram(411) <= X"00";
    ram(412) <= X"00";
    ram(413) <= X"00";
    ram(414) <= X"00";
    ram(415) <= X"00";
    ram(416) <= X"00";
    ram(417) <= X"00";
    ram(418) <= X"00";
    ram(419) <= X"00";
    ram(420) <= X"00";
    ram(421) <= X"00";
    ram(422) <= X"00";
    ram(423) <= X"00";
    ram(424) <= X"00";
    ram(425) <= X"00";
    ram(426) <= X"00";
    ram(427) <= X"00";
    ram(428) <= X"00";
    ram(429) <= X"00";
    ram(430) <= X"00";
    ram(431) <= X"00";
    ram(432) <= X"00";
    ram(433) <= X"00";
    ram(434) <= X"00";
    ram(435) <= X"00";
    ram(436) <= X"00";
    ram(437) <= X"00";
    ram(438) <= X"00";
    ram(439) <= X"00";
    ram(440) <= X"00";
    ram(441) <= X"00";
    ram(442) <= X"00";
    ram(443) <= X"00";
    ram(444) <= X"00";
    ram(445) <= X"00";
    ram(446) <= X"00";
    ram(447) <= X"00";
    ram(448) <= X"00";
    ram(449) <= X"00";
    ram(450) <= X"00";
    ram(451) <= X"00";
    ram(452) <= X"00";
    ram(453) <= X"00";
    ram(454) <= X"00";
    ram(455) <= X"00";
    ram(456) <= X"00";
    ram(457) <= X"00";
    ram(458) <= X"00";
    ram(459) <= X"00";
    ram(460) <= X"00";
    ram(461) <= X"00";
    ram(462) <= X"00";
    ram(463) <= X"00";
    ram(464) <= X"00";
    ram(465) <= X"00";
    ram(466) <= X"00";
    ram(467) <= X"00";
    ram(468) <= X"00";
    ram(469) <= X"00";
    ram(470) <= X"00";
    ram(471) <= X"00";
    ram(472) <= X"00";
    ram(473) <= X"00";
    ram(474) <= X"00";
    ram(475) <= X"00";
    ram(476) <= X"00";
    ram(477) <= X"00";
    ram(478) <= X"00";
    ram(479) <= X"00";
    ram(480) <= X"00";
    ram(481) <= X"00";
    ram(482) <= X"00";
    ram(483) <= X"00";
    ram(484) <= X"00";
    ram(485) <= X"00";
    ram(486) <= X"00";
    ram(487) <= X"00";
    ram(488) <= X"00";
    ram(489) <= X"00";
    ram(490) <= X"00";
    ram(491) <= X"00";
    ram(492) <= X"00";
    ram(493) <= X"00";
    ram(494) <= X"00";
    ram(495) <= X"00";
    ram(496) <= X"00";
    ram(497) <= X"00";
    ram(498) <= X"00";
    ram(499) <= X"00";
    ram(500) <= X"00";
    ram(501) <= X"00";
    ram(502) <= X"00";
    ram(503) <= X"00";
    ram(504) <= X"00";
    ram(505) <= X"00";
    ram(506) <= X"00";
    ram(507) <= X"00";
    ram(508) <= X"00";
    ram(509) <= X"00";
    ram(510) <= X"00";
    ram(511) <= X"00";
    ram(512) <= X"78";
    ram(513) <= X"d8";
    ram(514) <= X"a2";
    ram(515) <= X"ff";
    ram(516) <= X"9a";
    ram(517) <= X"a9";
    ram(518) <= X"fe";
    ram(519) <= X"85";
    ram(520) <= X"13";
    ram(521) <= X"a9";
    ram(522) <= X"80";
    ram(523) <= X"85";
    ram(524) <= X"11";
    ram(525) <= X"a9";
    ram(526) <= X"00";
    ram(527) <= X"85";
    ram(528) <= X"04";
    ram(529) <= X"85";
    ram(530) <= X"06";
    ram(531) <= X"a0";
    ram(532) <= X"15";
    ram(533) <= X"20";
    ram(534) <= X"57";
    ram(535) <= X"fd";
    ram(536) <= X"88";
    ram(537) <= X"d0";
    ram(538) <= X"fa";
    ram(539) <= X"a9";
    ram(540) <= X"55";
    ram(541) <= X"a2";
    ram(542) <= X"fe";
    ram(543) <= X"20";
    ram(544) <= X"44";
    ram(545) <= X"fd";
    ram(546) <= X"a9";
    ram(547) <= X"9a";
    ram(548) <= X"a2";
    ram(549) <= X"fe";
    ram(550) <= X"20";
    ram(551) <= X"44";
    ram(552) <= X"fd";
    ram(553) <= X"a9";
    ram(554) <= X"00";
    ram(555) <= X"85";
    ram(556) <= X"17";
    ram(557) <= X"20";
    ram(558) <= X"5b";
    ram(559) <= X"f2";
    ram(560) <= X"a5";
    ram(561) <= X"06";
    ram(562) <= X"d0";
    ram(563) <= X"05";
    ram(564) <= X"2c";
    ram(565) <= X"0a";
    ram(566) <= X"90";
    ram(567) <= X"30";
    ram(568) <= X"57";
    ram(569) <= X"ad";
    ram(570) <= X"0a";
    ram(571) <= X"90";
    ram(572) <= X"29";
    ram(573) <= X"20";
    ram(574) <= X"d0";
    ram(575) <= X"5a";
    ram(576) <= X"2c";
    ram(577) <= X"1f";
    ram(578) <= X"90";
    ram(579) <= X"30";
    ram(580) <= X"43";
    ram(581) <= X"2c";
    ram(582) <= X"04";
    ram(583) <= X"90";
    ram(584) <= X"50";
    ram(585) <= X"03";
    ram(586) <= X"4c";
    ram(587) <= X"93";
    ram(588) <= X"f8";
    ram(589) <= X"10";
    ram(590) <= X"03";
    ram(591) <= X"4c";
    ram(592) <= X"d2";
    ram(593) <= X"f8";
    ram(594) <= X"a5";
    ram(595) <= X"04";
    ram(596) <= X"f0";
    ram(597) <= X"03";
    ram(598) <= X"4c";
    ram(599) <= X"9f";
    ram(600) <= X"f6";
    ram(601) <= X"80";
    ram(602) <= X"d2";
    ram(603) <= X"2c";
    ram(604) <= X"1d";
    ram(605) <= X"90";
    ram(606) <= X"30";
    ram(607) <= X"10";
    ram(608) <= X"a5";
    ram(609) <= X"07";
    ram(610) <= X"d0";
    ram(611) <= X"07";
    ram(612) <= X"70";
    ram(613) <= X"13";
    ram(614) <= X"a9";
    ram(615) <= X"00";
    ram(616) <= X"85";
    ram(617) <= X"06";
    ram(618) <= X"60";
    ram(619) <= X"a9";
    ram(620) <= X"00";
    ram(621) <= X"85";
    ram(622) <= X"07";
    ram(623) <= X"60";
    ram(624) <= X"a5";
    ram(625) <= X"07";
    ram(626) <= X"d0";
    ram(627) <= X"00";
    ram(628) <= X"a9";
    ram(629) <= X"80";
    ram(630) <= X"85";
    ram(631) <= X"07";
    ram(632) <= X"60";
    ram(633) <= X"a5";
    ram(634) <= X"06";
    ram(635) <= X"d0";
    ram(636) <= X"ed";
    ram(637) <= X"a9";
    ram(638) <= X"55";
    ram(639) <= X"a2";
    ram(640) <= X"fe";
    ram(641) <= X"20";
    ram(642) <= X"44";
    ram(643) <= X"fd";
    ram(644) <= X"a9";
    ram(645) <= X"01";
    ram(646) <= X"80";
    ram(647) <= X"e0";
    ram(648) <= X"ad";
    ram(649) <= X"1e";
    ram(650) <= X"90";
    ram(651) <= X"20";
    ram(652) <= X"8c";
    ram(653) <= X"fd";
    ram(654) <= X"80";
    ram(655) <= X"9d";
    ram(656) <= X"ad";
    ram(657) <= X"08";
    ram(658) <= X"90";
    ram(659) <= X"a2";
    ram(660) <= X"00";
    ram(661) <= X"86";
    ram(662) <= X"04";
    ram(663) <= X"4c";
    ram(664) <= X"9d";
    ram(665) <= X"f2";
    ram(666) <= X"ad";
    ram(667) <= X"09";
    ram(668) <= X"90";
    ram(669) <= X"c9";
    ram(670) <= X"20";
    ram(671) <= X"90";
    ram(672) <= X"1d";
    ram(673) <= X"c9";
    ram(674) <= X"7f";
    ram(675) <= X"b0";
    ram(676) <= X"19";
    ram(677) <= X"a6";
    ram(678) <= X"17";
    ram(679) <= X"e0";
    ram(680) <= X"40";
    ram(681) <= X"b0";
    ram(682) <= X"0b";
    ram(683) <= X"95";
    ram(684) <= X"1d";
    ram(685) <= X"e8";
    ram(686) <= X"86";
    ram(687) <= X"17";
    ram(688) <= X"20";
    ram(689) <= X"8c";
    ram(690) <= X"fd";
    ram(691) <= X"4c";
    ram(692) <= X"2d";
    ram(693) <= X"f2";
    ram(694) <= X"a9";
    ram(695) <= X"07";
    ram(696) <= X"20";
    ram(697) <= X"8c";
    ram(698) <= X"fd";
    ram(699) <= X"4c";
    ram(700) <= X"2d";
    ram(701) <= X"f2";
    ram(702) <= X"c9";
    ram(703) <= X"08";
    ram(704) <= X"f0";
    ram(705) <= X"78";
    ram(706) <= X"c9";
    ram(707) <= X"14";
    ram(708) <= X"f0";
    ram(709) <= X"74";
    ram(710) <= X"c9";
    ram(711) <= X"7f";
    ram(712) <= X"f0";
    ram(713) <= X"70";
    ram(714) <= X"c9";
    ram(715) <= X"11";
    ram(716) <= X"f0";
    ram(717) <= X"3b";
    ram(718) <= X"c9";
    ram(719) <= X"f3";
    ram(720) <= X"f0";
    ram(721) <= X"37";
    ram(722) <= X"c9";
    ram(723) <= X"f1";
    ram(724) <= X"f0";
    ram(725) <= X"58";
    ram(726) <= X"c9";
    ram(727) <= X"f7";
    ram(728) <= X"f0";
    ram(729) <= X"29";
    ram(730) <= X"c9";
    ram(731) <= X"91";
    ram(732) <= X"f0";
    ram(733) <= X"50";
    ram(734) <= X"c9";
    ram(735) <= X"93";
    ram(736) <= X"f0";
    ram(737) <= X"0a";
    ram(738) <= X"c9";
    ram(739) <= X"0d";
    ram(740) <= X"f0";
    ram(741) <= X"7b";
    ram(742) <= X"c9";
    ram(743) <= X"0a";
    ram(744) <= X"f0";
    ram(745) <= X"77";
    ram(746) <= X"80";
    ram(747) <= X"ca";
    ram(748) <= X"a2";
    ram(749) <= X"19";
    ram(750) <= X"a9";
    ram(751) <= X"0a";
    ram(752) <= X"20";
    ram(753) <= X"8c";
    ram(754) <= X"fd";
    ram(755) <= X"ca";
    ram(756) <= X"10";
    ram(757) <= X"f8";
    ram(758) <= X"a2";
    ram(759) <= X"19";
    ram(760) <= X"a9";
    ram(761) <= X"91";
    ram(762) <= X"20";
    ram(763) <= X"8c";
    ram(764) <= X"fd";
    ram(765) <= X"ca";
    ram(766) <= X"10";
    ram(767) <= X"f8";
    ram(768) <= X"4c";
    ram(769) <= X"22";
    ram(770) <= X"f2";
    ram(771) <= X"20";
    ram(772) <= X"e7";
    ram(773) <= X"f3";
    ram(774) <= X"4c";
    ram(775) <= X"2d";
    ram(776) <= X"f2";
    ram(777) <= X"a9";
    ram(778) <= X"08";
    ram(779) <= X"85";
    ram(780) <= X"16";
    ram(781) <= X"a9";
    ram(782) <= X"0d";
    ram(783) <= X"20";
    ram(784) <= X"8c";
    ram(785) <= X"fd";
    ram(786) <= X"ad";
    ram(787) <= X"11";
    ram(788) <= X"90";
    ram(789) <= X"38";
    ram(790) <= X"e9";
    ram(791) <= X"01";
    ram(792) <= X"8d";
    ram(793) <= X"11";
    ram(794) <= X"90";
    ram(795) <= X"ad";
    ram(796) <= X"12";
    ram(797) <= X"90";
    ram(798) <= X"e9";
    ram(799) <= X"00";
    ram(800) <= X"8d";
    ram(801) <= X"12";
    ram(802) <= X"90";
    ram(803) <= X"ad";
    ram(804) <= X"13";
    ram(805) <= X"90";
    ram(806) <= X"e9";
    ram(807) <= X"00";
    ram(808) <= X"8d";
    ram(809) <= X"13";
    ram(810) <= X"90";
    ram(811) <= X"4c";
    ram(812) <= X"3d";
    ram(813) <= X"f5";
    ram(814) <= X"a9";
    ram(815) <= X"08";
    ram(816) <= X"85";
    ram(817) <= X"16";
    ram(818) <= X"a9";
    ram(819) <= X"0d";
    ram(820) <= X"20";
    ram(821) <= X"8c";
    ram(822) <= X"fd";
    ram(823) <= X"4c";
    ram(824) <= X"3d";
    ram(825) <= X"f5";
    ram(826) <= X"a6";
    ram(827) <= X"17";
    ram(828) <= X"d0";
    ram(829) <= X"03";
    ram(830) <= X"4c";
    ram(831) <= X"b6";
    ram(832) <= X"f2";
    ram(833) <= X"ca";
    ram(834) <= X"86";
    ram(835) <= X"17";
    ram(836) <= X"a9";
    ram(837) <= X"9e";
    ram(838) <= X"a2";
    ram(839) <= X"fe";
    ram(840) <= X"20";
    ram(841) <= X"44";
    ram(842) <= X"fd";
    ram(843) <= X"4c";
    ram(844) <= X"2d";
    ram(845) <= X"f2";
    ram(846) <= X"a9";
    ram(847) <= X"00";
    ram(848) <= X"8d";
    ram(849) <= X"02";
    ram(850) <= X"90";
    ram(851) <= X"8d";
    ram(852) <= X"03";
    ram(853) <= X"90";
    ram(854) <= X"ad";
    ram(855) <= X"04";
    ram(856) <= X"90";
    ram(857) <= X"09";
    ram(858) <= X"04";
    ram(859) <= X"8d";
    ram(860) <= X"04";
    ram(861) <= X"90";
    ram(862) <= X"4c";
    ram(863) <= X"9f";
    ram(864) <= X"f6";
    ram(865) <= X"20";
    ram(866) <= X"57";
    ram(867) <= X"fd";
    ram(868) <= X"a6";
    ram(869) <= X"17";
    ram(870) <= X"f0";
    ram(871) <= X"e6";
    ram(872) <= X"e0";
    ram(873) <= X"06";
    ram(874) <= X"f0";
    ram(875) <= X"3d";
    ram(876) <= X"a2";
    ram(877) <= X"00";
    ram(878) <= X"b5";
    ram(879) <= X"1d";
    ram(880) <= X"85";
    ram(881) <= X"14";
    ram(882) <= X"e8";
    ram(883) <= X"a0";
    ram(884) <= X"10";
    ram(885) <= X"c9";
    ram(886) <= X"61";
    ram(887) <= X"90";
    ram(888) <= X"02";
    ram(889) <= X"a0";
    ram(890) <= X"01";
    ram(891) <= X"84";
    ram(892) <= X"16";
    ram(893) <= X"c9";
    ram(894) <= X"61";
    ram(895) <= X"90";
    ram(896) <= X"06";
    ram(897) <= X"c9";
    ram(898) <= X"7b";
    ram(899) <= X"b0";
    ram(900) <= X"02";
    ram(901) <= X"29";
    ram(902) <= X"df";
    ram(903) <= X"48";
    ram(904) <= X"20";
    ram(905) <= X"88";
    ram(906) <= X"f5";
    ram(907) <= X"68";
    ram(908) <= X"da";
    ram(909) <= X"a2";
    ram(910) <= X"12";
    ram(911) <= X"dd";
    ram(912) <= X"1c";
    ram(913) <= X"fe";
    ram(914) <= X"f0";
    ram(915) <= X"07";
    ram(916) <= X"ca";
    ram(917) <= X"10";
    ram(918) <= X"f8";
    ram(919) <= X"fa";
    ram(920) <= X"4c";
    ram(921) <= X"22";
    ram(922) <= X"f2";
    ram(923) <= X"8a";
    ram(924) <= X"0a";
    ram(925) <= X"aa";
    ram(926) <= X"7c";
    ram(927) <= X"2f";
    ram(928) <= X"fe";
    ram(929) <= X"a9";
    ram(930) <= X"ff";
    ram(931) <= X"8d";
    ram(932) <= X"0b";
    ram(933) <= X"90";
    ram(934) <= X"4c";
    ram(935) <= X"22";
    ram(936) <= X"f2";
    ram(937) <= X"a2";
    ram(938) <= X"00";
    ram(939) <= X"b5";
    ram(940) <= X"1d";
    ram(941) <= X"dd";
    ram(942) <= X"cd";
    ram(943) <= X"f3";
    ram(944) <= X"d0";
    ram(945) <= X"08";
    ram(946) <= X"e8";
    ram(947) <= X"e0";
    ram(948) <= X"06";
    ram(949) <= X"d0";
    ram(950) <= X"f4";
    ram(951) <= X"4c";
    ram(952) <= X"dc";
    ram(953) <= X"f3";
    ram(954) <= X"a2";
    ram(955) <= X"00";
    ram(956) <= X"b5";
    ram(957) <= X"1d";
    ram(958) <= X"dd";
    ram(959) <= X"d3";
    ram(960) <= X"f3";
    ram(961) <= X"d0";
    ram(962) <= X"08";
    ram(963) <= X"e8";
    ram(964) <= X"e0";
    ram(965) <= X"06";
    ram(966) <= X"d0";
    ram(967) <= X"f4";
    ram(968) <= X"4c";
    ram(969) <= X"d9";
    ram(970) <= X"f3";
    ram(971) <= X"80";
    ram(972) <= X"9f";
    ram(973) <= X"41";
    ram(974) <= X"43";
    ram(975) <= X"43";
    ram(976) <= X"45";
    ram(977) <= X"50";
    ram(978) <= X"54";
    ram(979) <= X"52";
    ram(980) <= X"45";
    ram(981) <= X"4a";
    ram(982) <= X"45";
    ram(983) <= X"43";
    ram(984) <= X"54";
    ram(985) <= X"20";
    ram(986) <= X"e7";
    ram(987) <= X"f3";
    ram(988) <= X"a5";
    ram(989) <= X"07";
    ram(990) <= X"8d";
    ram(991) <= X"1c";
    ram(992) <= X"90";
    ram(993) <= X"8d";
    ram(994) <= X"0a";
    ram(995) <= X"90";
    ram(996) <= X"4c";
    ram(997) <= X"22";
    ram(998) <= X"f2";
    ram(999) <= X"a9";
    ram(1000) <= X"00";
    ram(1001) <= X"a2";
    ram(1002) <= X"03";
    ram(1003) <= X"9d";
    ram(1004) <= X"10";
    ram(1005) <= X"90";
    ram(1006) <= X"95";
    ram(1007) <= X"18";
    ram(1008) <= X"ca";
    ram(1009) <= X"10";
    ram(1010) <= X"f8";
    ram(1011) <= X"a0";
    ram(1012) <= X"10";
    ram(1013) <= X"84";
    ram(1014) <= X"1a";
    ram(1015) <= X"20";
    ram(1016) <= X"5a";
    ram(1017) <= X"f4";
    ram(1018) <= X"a9";
    ram(1019) <= X"0f";
    ram(1020) <= X"8d";
    ram(1021) <= X"13";
    ram(1022) <= X"90";
    ram(1023) <= X"85";
    ram(1024) <= X"1b";
    ram(1025) <= X"a9";
    ram(1026) <= X"f0";
    ram(1027) <= X"8d";
    ram(1028) <= X"12";
    ram(1029) <= X"90";
    ram(1030) <= X"a0";
    ram(1031) <= X"fe";
    ram(1032) <= X"84";
    ram(1033) <= X"1a";
    ram(1034) <= X"20";
    ram(1035) <= X"5a";
    ram(1036) <= X"f4";
    ram(1037) <= X"60";
    ram(1038) <= X"a9";
    ram(1039) <= X"29";
    ram(1040) <= X"a2";
    ram(1041) <= X"ff";
    ram(1042) <= X"20";
    ram(1043) <= X"44";
    ram(1044) <= X"fd";
    ram(1045) <= X"4c";
    ram(1046) <= X"22";
    ram(1047) <= X"f2";
    ram(1048) <= X"fa";
    ram(1049) <= X"20";
    ram(1050) <= X"d8";
    ram(1051) <= X"f5";
    ram(1052) <= X"c0";
    ram(1053) <= X"00";
    ram(1054) <= X"f0";
    ram(1055) <= X"ee";
    ram(1056) <= X"c0";
    ram(1057) <= X"05";
    ram(1058) <= X"b0";
    ram(1059) <= X"ea";
    ram(1060) <= X"a5";
    ram(1061) <= X"08";
    ram(1062) <= X"8d";
    ram(1063) <= X"0c";
    ram(1064) <= X"90";
    ram(1065) <= X"a5";
    ram(1066) <= X"09";
    ram(1067) <= X"8d";
    ram(1068) <= X"0d";
    ram(1069) <= X"90";
    ram(1070) <= X"4c";
    ram(1071) <= X"22";
    ram(1072) <= X"f2";
    ram(1073) <= X"fa";
    ram(1074) <= X"20";
    ram(1075) <= X"b4";
    ram(1076) <= X"f5";
    ram(1077) <= X"20";
    ram(1078) <= X"20";
    ram(1079) <= X"f6";
    ram(1080) <= X"20";
    ram(1081) <= X"b4";
    ram(1082) <= X"f5";
    ram(1083) <= X"da";
    ram(1084) <= X"a2";
    ram(1085) <= X"03";
    ram(1086) <= X"b5";
    ram(1087) <= X"08";
    ram(1088) <= X"95";
    ram(1089) <= X"18";
    ram(1090) <= X"ca";
    ram(1091) <= X"10";
    ram(1092) <= X"f9";
    ram(1093) <= X"fa";
    ram(1094) <= X"20";
    ram(1095) <= X"d8";
    ram(1096) <= X"f5";
    ram(1097) <= X"c0";
    ram(1098) <= X"00";
    ram(1099) <= X"f0";
    ram(1100) <= X"35";
    ram(1101) <= X"c0";
    ram(1102) <= X"03";
    ram(1103) <= X"b0";
    ram(1104) <= X"31";
    ram(1105) <= X"a5";
    ram(1106) <= X"08";
    ram(1107) <= X"a8";
    ram(1108) <= X"20";
    ram(1109) <= X"5a";
    ram(1110) <= X"f4";
    ram(1111) <= X"4c";
    ram(1112) <= X"22";
    ram(1113) <= X"f2";
    ram(1114) <= X"ad";
    ram(1115) <= X"10";
    ram(1116) <= X"90";
    ram(1117) <= X"c5";
    ram(1118) <= X"18";
    ram(1119) <= X"ad";
    ram(1120) <= X"11";
    ram(1121) <= X"90";
    ram(1122) <= X"e5";
    ram(1123) <= X"19";
    ram(1124) <= X"ad";
    ram(1125) <= X"12";
    ram(1126) <= X"90";
    ram(1127) <= X"e5";
    ram(1128) <= X"1a";
    ram(1129) <= X"ad";
    ram(1130) <= X"13";
    ram(1131) <= X"90";
    ram(1132) <= X"e5";
    ram(1133) <= X"1b";
    ram(1134) <= X"b0";
    ram(1135) <= X"19";
    ram(1136) <= X"8c";
    ram(1137) <= X"15";
    ram(1138) <= X"90";
    ram(1139) <= X"2c";
    ram(1140) <= X"16";
    ram(1141) <= X"90";
    ram(1142) <= X"70";
    ram(1143) <= X"46";
    ram(1144) <= X"10";
    ram(1145) <= X"f9";
    ram(1146) <= X"8e";
    ram(1147) <= X"17";
    ram(1148) <= X"90";
    ram(1149) <= X"80";
    ram(1150) <= X"db";
    ram(1151) <= X"4c";
    ram(1152) <= X"21";
    ram(1153) <= X"f5";
    ram(1154) <= X"a9";
    ram(1155) <= X"c1";
    ram(1156) <= X"a2";
    ram(1157) <= X"ff";
    ram(1158) <= X"20";
    ram(1159) <= X"44";
    ram(1160) <= X"fd";
    ram(1161) <= X"60";
    ram(1162) <= X"fa";
    ram(1163) <= X"20";
    ram(1164) <= X"b4";
    ram(1165) <= X"f5";
    ram(1166) <= X"a5";
    ram(1167) <= X"14";
    ram(1168) <= X"c9";
    ram(1169) <= X"73";
    ram(1170) <= X"f0";
    ram(1171) <= X"08";
    ram(1172) <= X"a9";
    ram(1173) <= X"77";
    ram(1174) <= X"85";
    ram(1175) <= X"0a";
    ram(1176) <= X"a9";
    ram(1177) <= X"07";
    ram(1178) <= X"85";
    ram(1179) <= X"0b";
    ram(1180) <= X"20";
    ram(1181) <= X"20";
    ram(1182) <= X"f6";
    ram(1183) <= X"20";
    ram(1184) <= X"d8";
    ram(1185) <= X"f5";
    ram(1186) <= X"c0";
    ram(1187) <= X"00";
    ram(1188) <= X"d0";
    ram(1189) <= X"03";
    ram(1190) <= X"4c";
    ram(1191) <= X"22";
    ram(1192) <= X"f2";
    ram(1193) <= X"c0";
    ram(1194) <= X"03";
    ram(1195) <= X"f0";
    ram(1196) <= X"d5";
    ram(1197) <= X"a5";
    ram(1198) <= X"08";
    ram(1199) <= X"8d";
    ram(1200) <= X"15";
    ram(1201) <= X"90";
    ram(1202) <= X"2c";
    ram(1203) <= X"16";
    ram(1204) <= X"90";
    ram(1205) <= X"70";
    ram(1206) <= X"07";
    ram(1207) <= X"10";
    ram(1208) <= X"f9";
    ram(1209) <= X"8e";
    ram(1210) <= X"17";
    ram(1211) <= X"90";
    ram(1212) <= X"80";
    ram(1213) <= X"e1";
    ram(1214) <= X"a9";
    ram(1215) <= X"66";
    ram(1216) <= X"a2";
    ram(1217) <= X"ff";
    ram(1218) <= X"20";
    ram(1219) <= X"44";
    ram(1220) <= X"fd";
    ram(1221) <= X"4c";
    ram(1222) <= X"22";
    ram(1223) <= X"f2";
    ram(1224) <= X"fa";
    ram(1225) <= X"20";
    ram(1226) <= X"b4";
    ram(1227) <= X"f5";
    ram(1228) <= X"20";
    ram(1229) <= X"20";
    ram(1230) <= X"f6";
    ram(1231) <= X"20";
    ram(1232) <= X"c0";
    ram(1233) <= X"f5";
    ram(1234) <= X"a5";
    ram(1235) <= X"08";
    ram(1236) <= X"85";
    ram(1237) <= X"18";
    ram(1238) <= X"a5";
    ram(1239) <= X"09";
    ram(1240) <= X"85";
    ram(1241) <= X"19";
    ram(1242) <= X"ad";
    ram(1243) <= X"10";
    ram(1244) <= X"90";
    ram(1245) <= X"c5";
    ram(1246) <= X"18";
    ram(1247) <= X"d0";
    ram(1248) <= X"0a";
    ram(1249) <= X"ad";
    ram(1250) <= X"11";
    ram(1251) <= X"90";
    ram(1252) <= X"c5";
    ram(1253) <= X"19";
    ram(1254) <= X"d0";
    ram(1255) <= X"03";
    ram(1256) <= X"4c";
    ram(1257) <= X"22";
    ram(1258) <= X"f2";
    ram(1259) <= X"2c";
    ram(1260) <= X"0a";
    ram(1261) <= X"90";
    ram(1262) <= X"10";
    ram(1263) <= X"fb";
    ram(1264) <= X"ad";
    ram(1265) <= X"08";
    ram(1266) <= X"90";
    ram(1267) <= X"8d";
    ram(1268) <= X"15";
    ram(1269) <= X"90";
    ram(1270) <= X"2c";
    ram(1271) <= X"16";
    ram(1272) <= X"90";
    ram(1273) <= X"70";
    ram(1274) <= X"c3";
    ram(1275) <= X"10";
    ram(1276) <= X"f9";
    ram(1277) <= X"8e";
    ram(1278) <= X"17";
    ram(1279) <= X"90";
    ram(1280) <= X"80";
    ram(1281) <= X"d8";
    ram(1282) <= X"fa";
    ram(1283) <= X"20";
    ram(1284) <= X"c0";
    ram(1285) <= X"f5";
    ram(1286) <= X"20";
    ram(1287) <= X"20";
    ram(1288) <= X"f6";
    ram(1289) <= X"a9";
    ram(1290) <= X"80";
    ram(1291) <= X"8d";
    ram(1292) <= X"14";
    ram(1293) <= X"90";
    ram(1294) <= X"2c";
    ram(1295) <= X"16";
    ram(1296) <= X"90";
    ram(1297) <= X"70";
    ram(1298) <= X"04";
    ram(1299) <= X"30";
    ram(1300) <= X"09";
    ram(1301) <= X"80";
    ram(1302) <= X"f7";
    ram(1303) <= X"a9";
    ram(1304) <= X"42";
    ram(1305) <= X"a2";
    ram(1306) <= X"ff";
    ram(1307) <= X"20";
    ram(1308) <= X"44";
    ram(1309) <= X"fd";
    ram(1310) <= X"4c";
    ram(1311) <= X"22";
    ram(1312) <= X"f2";
    ram(1313) <= X"20";
    ram(1314) <= X"7f";
    ram(1315) <= X"f5";
    ram(1316) <= X"4c";
    ram(1317) <= X"22";
    ram(1318) <= X"f2";
    ram(1319) <= X"a9";
    ram(1320) <= X"01";
    ram(1321) <= X"85";
    ram(1322) <= X"1c";
    ram(1323) <= X"4c";
    ram(1324) <= X"3d";
    ram(1325) <= X"f5";
    ram(1326) <= X"fa";
    ram(1327) <= X"20";
    ram(1328) <= X"93";
    ram(1329) <= X"f5";
    ram(1330) <= X"4c";
    ram(1331) <= X"3d";
    ram(1332) <= X"f5";
    ram(1333) <= X"a9";
    ram(1334) <= X"00";
    ram(1335) <= X"85";
    ram(1336) <= X"1c";
    ram(1337) <= X"fa";
    ram(1338) <= X"20";
    ram(1339) <= X"93";
    ram(1340) <= X"f5";
    ram(1341) <= X"a4";
    ram(1342) <= X"16";
    ram(1343) <= X"a9";
    ram(1344) <= X"3a";
    ram(1345) <= X"20";
    ram(1346) <= X"8c";
    ram(1347) <= X"fd";
    ram(1348) <= X"a2";
    ram(1349) <= X"03";
    ram(1350) <= X"bd";
    ram(1351) <= X"10";
    ram(1352) <= X"90";
    ram(1353) <= X"20";
    ram(1354) <= X"79";
    ram(1355) <= X"fd";
    ram(1356) <= X"ca";
    ram(1357) <= X"10";
    ram(1358) <= X"f7";
    ram(1359) <= X"a9";
    ram(1360) <= X"3a";
    ram(1361) <= X"20";
    ram(1362) <= X"8c";
    ram(1363) <= X"fd";
    ram(1364) <= X"a2";
    ram(1365) <= X"10";
    ram(1366) <= X"8e";
    ram(1367) <= X"14";
    ram(1368) <= X"90";
    ram(1369) <= X"2c";
    ram(1370) <= X"16";
    ram(1371) <= X"90";
    ram(1372) <= X"70";
    ram(1373) <= X"17";
    ram(1374) <= X"10";
    ram(1375) <= X"f9";
    ram(1376) <= X"ad";
    ram(1377) <= X"14";
    ram(1378) <= X"90";
    ram(1379) <= X"20";
    ram(1380) <= X"79";
    ram(1381) <= X"fd";
    ram(1382) <= X"8e";
    ram(1383) <= X"17";
    ram(1384) <= X"90";
    ram(1385) <= X"ca";
    ram(1386) <= X"d0";
    ram(1387) <= X"ea";
    ram(1388) <= X"20";
    ram(1389) <= X"57";
    ram(1390) <= X"fd";
    ram(1391) <= X"88";
    ram(1392) <= X"d0";
    ram(1393) <= X"cd";
    ram(1394) <= X"4c";
    ram(1395) <= X"22";
    ram(1396) <= X"f2";
    ram(1397) <= X"a9";
    ram(1398) <= X"55";
    ram(1399) <= X"a2";
    ram(1400) <= X"ff";
    ram(1401) <= X"20";
    ram(1402) <= X"44";
    ram(1403) <= X"fd";
    ram(1404) <= X"4c";
    ram(1405) <= X"22";
    ram(1406) <= X"f2";
    ram(1407) <= X"a9";
    ram(1408) <= X"78";
    ram(1409) <= X"a2";
    ram(1410) <= X"ff";
    ram(1411) <= X"20";
    ram(1412) <= X"44";
    ram(1413) <= X"fd";
    ram(1414) <= X"60";
    ram(1415) <= X"e8";
    ram(1416) <= X"e4";
    ram(1417) <= X"17";
    ram(1418) <= X"b0";
    ram(1419) <= X"06";
    ram(1420) <= X"b5";
    ram(1421) <= X"1d";
    ram(1422) <= X"c9";
    ram(1423) <= X"20";
    ram(1424) <= X"f0";
    ram(1425) <= X"f5";
    ram(1426) <= X"60";
    ram(1427) <= X"20";
    ram(1428) <= X"d8";
    ram(1429) <= X"f5";
    ram(1430) <= X"c0";
    ram(1431) <= X"00";
    ram(1432) <= X"f0";
    ram(1433) <= X"07";
    ram(1434) <= X"c0";
    ram(1435) <= X"09";
    ram(1436) <= X"b0";
    ram(1437) <= X"2e";
    ram(1438) <= X"20";
    ram(1439) <= X"20";
    ram(1440) <= X"f6";
    ram(1441) <= X"a5";
    ram(1442) <= X"1c";
    ram(1443) <= X"f0";
    ram(1444) <= X"0e";
    ram(1445) <= X"a9";
    ram(1446) <= X"77";
    ram(1447) <= X"8d";
    ram(1448) <= X"12";
    ram(1449) <= X"90";
    ram(1450) <= X"85";
    ram(1451) <= X"0e";
    ram(1452) <= X"a9";
    ram(1453) <= X"07";
    ram(1454) <= X"8d";
    ram(1455) <= X"13";
    ram(1456) <= X"90";
    ram(1457) <= X"85";
    ram(1458) <= X"0f";
    ram(1459) <= X"60";
    ram(1460) <= X"20";
    ram(1461) <= X"d8";
    ram(1462) <= X"f5";
    ram(1463) <= X"c0";
    ram(1464) <= X"00";
    ram(1465) <= X"f0";
    ram(1466) <= X"11";
    ram(1467) <= X"c0";
    ram(1468) <= X"09";
    ram(1469) <= X"b0";
    ram(1470) <= X"0d";
    ram(1471) <= X"60";
    ram(1472) <= X"20";
    ram(1473) <= X"d8";
    ram(1474) <= X"f5";
    ram(1475) <= X"c0";
    ram(1476) <= X"00";
    ram(1477) <= X"f0";
    ram(1478) <= X"05";
    ram(1479) <= X"c0";
    ram(1480) <= X"05";
    ram(1481) <= X"b0";
    ram(1482) <= X"01";
    ram(1483) <= X"60";
    ram(1484) <= X"68";
    ram(1485) <= X"68";
    ram(1486) <= X"a9";
    ram(1487) <= X"78";
    ram(1488) <= X"a2";
    ram(1489) <= X"ff";
    ram(1490) <= X"20";
    ram(1491) <= X"44";
    ram(1492) <= X"fd";
    ram(1493) <= X"4c";
    ram(1494) <= X"22";
    ram(1495) <= X"f2";
    ram(1496) <= X"20";
    ram(1497) <= X"88";
    ram(1498) <= X"f5";
    ram(1499) <= X"a0";
    ram(1500) <= X"00";
    ram(1501) <= X"84";
    ram(1502) <= X"08";
    ram(1503) <= X"84";
    ram(1504) <= X"09";
    ram(1505) <= X"84";
    ram(1506) <= X"0a";
    ram(1507) <= X"84";
    ram(1508) <= X"0b";
    ram(1509) <= X"84";
    ram(1510) <= X"03";
    ram(1511) <= X"e4";
    ram(1512) <= X"17";
    ram(1513) <= X"b0";
    ram(1514) <= X"30";
    ram(1515) <= X"b5";
    ram(1516) <= X"1d";
    ram(1517) <= X"c9";
    ram(1518) <= X"30";
    ram(1519) <= X"90";
    ram(1520) <= X"2a";
    ram(1521) <= X"c9";
    ram(1522) <= X"3a";
    ram(1523) <= X"90";
    ram(1524) <= X"0e";
    ram(1525) <= X"c9";
    ram(1526) <= X"41";
    ram(1527) <= X"90";
    ram(1528) <= X"22";
    ram(1529) <= X"29";
    ram(1530) <= X"df";
    ram(1531) <= X"c9";
    ram(1532) <= X"47";
    ram(1533) <= X"b0";
    ram(1534) <= X"1c";
    ram(1535) <= X"e9";
    ram(1536) <= X"36";
    ram(1537) <= X"80";
    ram(1538) <= X"02";
    ram(1539) <= X"e9";
    ram(1540) <= X"2f";
    ram(1541) <= X"0a";
    ram(1542) <= X"0a";
    ram(1543) <= X"0a";
    ram(1544) <= X"0a";
    ram(1545) <= X"da";
    ram(1546) <= X"a2";
    ram(1547) <= X"04";
    ram(1548) <= X"0a";
    ram(1549) <= X"26";
    ram(1550) <= X"08";
    ram(1551) <= X"26";
    ram(1552) <= X"09";
    ram(1553) <= X"26";
    ram(1554) <= X"0a";
    ram(1555) <= X"26";
    ram(1556) <= X"0b";
    ram(1557) <= X"ca";
    ram(1558) <= X"d0";
    ram(1559) <= X"f4";
    ram(1560) <= X"fa";
    ram(1561) <= X"e8";
    ram(1562) <= X"c8";
    ram(1563) <= X"c4";
    ram(1564) <= X"03";
    ram(1565) <= X"d0";
    ram(1566) <= X"c6";
    ram(1567) <= X"60";
    ram(1568) <= X"da";
    ram(1569) <= X"a2";
    ram(1570) <= X"03";
    ram(1571) <= X"b5";
    ram(1572) <= X"08";
    ram(1573) <= X"95";
    ram(1574) <= X"0c";
    ram(1575) <= X"9d";
    ram(1576) <= X"10";
    ram(1577) <= X"90";
    ram(1578) <= X"ca";
    ram(1579) <= X"10";
    ram(1580) <= X"f6";
    ram(1581) <= X"fa";
    ram(1582) <= X"60";
    ram(1583) <= X"fa";
    ram(1584) <= X"a2";
    ram(1585) <= X"0a";
    ram(1586) <= X"a5";
    ram(1587) <= X"14";
    ram(1588) <= X"c9";
    ram(1589) <= X"69";
    ram(1590) <= X"f0";
    ram(1591) <= X"42";
    ram(1592) <= X"a2";
    ram(1593) <= X"0c";
    ram(1594) <= X"80";
    ram(1595) <= X"3e";
    ram(1596) <= X"fa";
    ram(1597) <= X"e4";
    ram(1598) <= X"17";
    ram(1599) <= X"b0";
    ram(1600) <= X"5e";
    ram(1601) <= X"b5";
    ram(1602) <= X"1d";
    ram(1603) <= X"c9";
    ram(1604) <= X"31";
    ram(1605) <= X"d0";
    ram(1606) <= X"04";
    ram(1607) <= X"a2";
    ram(1608) <= X"00";
    ram(1609) <= X"80";
    ram(1610) <= X"2f";
    ram(1611) <= X"c9";
    ram(1612) <= X"30";
    ram(1613) <= X"d0";
    ram(1614) <= X"04";
    ram(1615) <= X"a2";
    ram(1616) <= X"02";
    ram(1617) <= X"80";
    ram(1618) <= X"1b";
    ram(1619) <= X"c9";
    ram(1620) <= X"43";
    ram(1621) <= X"d0";
    ram(1622) <= X"04";
    ram(1623) <= X"a2";
    ram(1624) <= X"04";
    ram(1625) <= X"80";
    ram(1626) <= X"1b";
    ram(1627) <= X"c9";
    ram(1628) <= X"63";
    ram(1629) <= X"d0";
    ram(1630) <= X"04";
    ram(1631) <= X"a2";
    ram(1632) <= X"06";
    ram(1633) <= X"80";
    ram(1634) <= X"13";
    ram(1635) <= X"c9";
    ram(1636) <= X"6c";
    ram(1637) <= X"d0";
    ram(1638) <= X"04";
    ram(1639) <= X"a2";
    ram(1640) <= X"08";
    ram(1641) <= X"80";
    ram(1642) <= X"03";
    ram(1643) <= X"4c";
    ram(1644) <= X"22";
    ram(1645) <= X"f2";
    ram(1646) <= X"9c";
    ram(1647) <= X"02";
    ram(1648) <= X"90";
    ram(1649) <= X"9c";
    ram(1650) <= X"03";
    ram(1651) <= X"90";
    ram(1652) <= X"80";
    ram(1653) <= X"04";
    ram(1654) <= X"a9";
    ram(1655) <= X"01";
    ram(1656) <= X"85";
    ram(1657) <= X"04";
    ram(1658) <= X"ad";
    ram(1659) <= X"04";
    ram(1660) <= X"90";
    ram(1661) <= X"3d";
    ram(1662) <= X"89";
    ram(1663) <= X"f6";
    ram(1664) <= X"1d";
    ram(1665) <= X"8a";
    ram(1666) <= X"f6";
    ram(1667) <= X"8d";
    ram(1668) <= X"04";
    ram(1669) <= X"90";
    ram(1670) <= X"4c";
    ram(1671) <= X"22";
    ram(1672) <= X"f2";
    ram(1673) <= X"ff";
    ram(1674) <= X"11";
    ram(1675) <= X"e6";
    ram(1676) <= X"04";
    ram(1677) <= X"ef";
    ram(1678) <= X"01";
    ram(1679) <= X"ff";
    ram(1680) <= X"11";
    ram(1681) <= X"ee";
    ram(1682) <= X"0c";
    ram(1683) <= X"ef";
    ram(1684) <= X"00";
    ram(1685) <= X"ff";
    ram(1686) <= X"10";
    ram(1687) <= X"df";
    ram(1688) <= X"00";
    ram(1689) <= X"ff";
    ram(1690) <= X"20";
    ram(1691) <= X"fd";
    ram(1692) <= X"00";
    ram(1693) <= X"ff";
    ram(1694) <= X"02";
    ram(1695) <= X"ad";
    ram(1696) <= X"05";
    ram(1697) <= X"90";
    ram(1698) <= X"49";
    ram(1699) <= X"01";
    ram(1700) <= X"8d";
    ram(1701) <= X"05";
    ram(1702) <= X"90";
    ram(1703) <= X"4c";
    ram(1704) <= X"5a";
    ram(1705) <= X"f7";
    ram(1706) <= X"fa";
    ram(1707) <= X"e4";
    ram(1708) <= X"17";
    ram(1709) <= X"b0";
    ram(1710) <= X"08";
    ram(1711) <= X"b5";
    ram(1712) <= X"1d";
    ram(1713) <= X"a2";
    ram(1714) <= X"10";
    ram(1715) <= X"c9";
    ram(1716) <= X"31";
    ram(1717) <= X"f0";
    ram(1718) <= X"c3";
    ram(1719) <= X"a2";
    ram(1720) <= X"0e";
    ram(1721) <= X"80";
    ram(1722) <= X"bf";
    ram(1723) <= X"fa";
    ram(1724) <= X"e4";
    ram(1725) <= X"17";
    ram(1726) <= X"b0";
    ram(1727) <= X"20";
    ram(1728) <= X"20";
    ram(1729) <= X"d8";
    ram(1730) <= X"f5";
    ram(1731) <= X"c0";
    ram(1732) <= X"00";
    ram(1733) <= X"f0";
    ram(1734) <= X"12";
    ram(1735) <= X"c0";
    ram(1736) <= X"04";
    ram(1737) <= X"d0";
    ram(1738) <= X"0e";
    ram(1739) <= X"a5";
    ram(1740) <= X"08";
    ram(1741) <= X"8d";
    ram(1742) <= X"06";
    ram(1743) <= X"90";
    ram(1744) <= X"a5";
    ram(1745) <= X"09";
    ram(1746) <= X"8d";
    ram(1747) <= X"07";
    ram(1748) <= X"90";
    ram(1749) <= X"a2";
    ram(1750) <= X"14";
    ram(1751) <= X"80";
    ram(1752) <= X"a1";
    ram(1753) <= X"a9";
    ram(1754) <= X"af";
    ram(1755) <= X"a2";
    ram(1756) <= X"ff";
    ram(1757) <= X"20";
    ram(1758) <= X"44";
    ram(1759) <= X"fd";
    ram(1760) <= X"a2";
    ram(1761) <= X"12";
    ram(1762) <= X"80";
    ram(1763) <= X"96";
    ram(1764) <= X"a9";
    ram(1765) <= X"a2";
    ram(1766) <= X"a2";
    ram(1767) <= X"fe";
    ram(1768) <= X"20";
    ram(1769) <= X"44";
    ram(1770) <= X"fd";
    ram(1771) <= X"a0";
    ram(1772) <= X"00";
    ram(1773) <= X"cc";
    ram(1774) <= X"1c";
    ram(1775) <= X"90";
    ram(1776) <= X"b0";
    ram(1777) <= X"37";
    ram(1778) <= X"98";
    ram(1779) <= X"0a";
    ram(1780) <= X"0a";
    ram(1781) <= X"0a";
    ram(1782) <= X"aa";
    ram(1783) <= X"bd";
    ram(1784) <= X"05";
    ram(1785) <= X"70";
    ram(1786) <= X"20";
    ram(1787) <= X"79";
    ram(1788) <= X"fd";
    ram(1789) <= X"20";
    ram(1790) <= X"64";
    ram(1791) <= X"fd";
    ram(1792) <= X"bd";
    ram(1793) <= X"03";
    ram(1794) <= X"70";
    ram(1795) <= X"20";
    ram(1796) <= X"79";
    ram(1797) <= X"fd";
    ram(1798) <= X"bd";
    ram(1799) <= X"02";
    ram(1800) <= X"70";
    ram(1801) <= X"20";
    ram(1802) <= X"79";
    ram(1803) <= X"fd";
    ram(1804) <= X"bd";
    ram(1805) <= X"01";
    ram(1806) <= X"70";
    ram(1807) <= X"20";
    ram(1808) <= X"79";
    ram(1809) <= X"fd";
    ram(1810) <= X"bd";
    ram(1811) <= X"00";
    ram(1812) <= X"70";
    ram(1813) <= X"20";
    ram(1814) <= X"79";
    ram(1815) <= X"fd";
    ram(1816) <= X"a9";
    ram(1817) <= X"3a";
    ram(1818) <= X"20";
    ram(1819) <= X"8c";
    ram(1820) <= X"fd";
    ram(1821) <= X"bd";
    ram(1822) <= X"04";
    ram(1823) <= X"70";
    ram(1824) <= X"20";
    ram(1825) <= X"79";
    ram(1826) <= X"fd";
    ram(1827) <= X"20";
    ram(1828) <= X"57";
    ram(1829) <= X"fd";
    ram(1830) <= X"c8";
    ram(1831) <= X"80";
    ram(1832) <= X"c4";
    ram(1833) <= X"4c";
    ram(1834) <= X"22";
    ram(1835) <= X"f2";
    ram(1836) <= X"a9";
    ram(1837) <= X"90";
    ram(1838) <= X"a2";
    ram(1839) <= X"ff";
    ram(1840) <= X"20";
    ram(1841) <= X"44";
    ram(1842) <= X"fd";
    ram(1843) <= X"4c";
    ram(1844) <= X"22";
    ram(1845) <= X"f2";
    ram(1846) <= X"fa";
    ram(1847) <= X"e4";
    ram(1848) <= X"17";
    ram(1849) <= X"f0";
    ram(1850) <= X"a9";
    ram(1851) <= X"20";
    ram(1852) <= X"d8";
    ram(1853) <= X"f5";
    ram(1854) <= X"c0";
    ram(1855) <= X"00";
    ram(1856) <= X"f0";
    ram(1857) <= X"ea";
    ram(1858) <= X"c0";
    ram(1859) <= X"04";
    ram(1860) <= X"b0";
    ram(1861) <= X"e6";
    ram(1862) <= X"a5";
    ram(1863) <= X"09";
    ram(1864) <= X"c9";
    ram(1865) <= X"03";
    ram(1866) <= X"b0";
    ram(1867) <= X"e0";
    ram(1868) <= X"8d";
    ram(1869) <= X"01";
    ram(1870) <= X"90";
    ram(1871) <= X"a5";
    ram(1872) <= X"08";
    ram(1873) <= X"8d";
    ram(1874) <= X"00";
    ram(1875) <= X"90";
    ram(1876) <= X"20";
    ram(1877) <= X"7b";
    ram(1878) <= X"f7";
    ram(1879) <= X"4c";
    ram(1880) <= X"22";
    ram(1881) <= X"f2";
    ram(1882) <= X"a2";
    ram(1883) <= X"80";
    ram(1884) <= X"ca";
    ram(1885) <= X"d0";
    ram(1886) <= X"fd";
    ram(1887) <= X"a9";
    ram(1888) <= X"ff";
    ram(1889) <= X"8d";
    ram(1890) <= X"02";
    ram(1891) <= X"90";
    ram(1892) <= X"8d";
    ram(1893) <= X"03";
    ram(1894) <= X"90";
    ram(1895) <= X"8d";
    ram(1896) <= X"00";
    ram(1897) <= X"90";
    ram(1898) <= X"8d";
    ram(1899) <= X"01";
    ram(1900) <= X"90";
    ram(1901) <= X"ad";
    ram(1902) <= X"04";
    ram(1903) <= X"90";
    ram(1904) <= X"09";
    ram(1905) <= X"04";
    ram(1906) <= X"8d";
    ram(1907) <= X"04";
    ram(1908) <= X"90";
    ram(1909) <= X"20";
    ram(1910) <= X"7b";
    ram(1911) <= X"f7";
    ram(1912) <= X"4c";
    ram(1913) <= X"22";
    ram(1914) <= X"f2";
    ram(1915) <= X"a9";
    ram(1916) <= X"b5";
    ram(1917) <= X"a2";
    ram(1918) <= X"fe";
    ram(1919) <= X"20";
    ram(1920) <= X"44";
    ram(1921) <= X"fd";
    ram(1922) <= X"a0";
    ram(1923) <= X"ff";
    ram(1924) <= X"c8";
    ram(1925) <= X"b9";
    ram(1926) <= X"10";
    ram(1927) <= X"ff";
    ram(1928) <= X"30";
    ram(1929) <= X"0d";
    ram(1930) <= X"c9";
    ram(1931) <= X"20";
    ram(1932) <= X"b0";
    ram(1933) <= X"22";
    ram(1934) <= X"aa";
    ram(1935) <= X"bd";
    ram(1936) <= X"00";
    ram(1937) <= X"80";
    ram(1938) <= X"20";
    ram(1939) <= X"79";
    ram(1940) <= X"fd";
    ram(1941) <= X"80";
    ram(1942) <= X"ed";
    ram(1943) <= X"29";
    ram(1944) <= X"7f";
    ram(1945) <= X"aa";
    ram(1946) <= X"20";
    ram(1947) <= X"64";
    ram(1948) <= X"fd";
    ram(1949) <= X"8a";
    ram(1950) <= X"80";
    ram(1951) <= X"ea";
    ram(1952) <= X"b5";
    ram(1953) <= X"f7";
    ram(1954) <= X"db";
    ram(1955) <= X"f7";
    ram(1956) <= X"38";
    ram(1957) <= X"f8";
    ram(1958) <= X"13";
    ram(1959) <= X"f8";
    ram(1960) <= X"07";
    ram(1961) <= X"f8";
    ram(1962) <= X"59";
    ram(1963) <= X"f8";
    ram(1964) <= X"fb";
    ram(1965) <= X"f7";
    ram(1966) <= X"d1";
    ram(1967) <= X"f7";
    ram(1968) <= X"0a";
    ram(1969) <= X"aa";
    ram(1970) <= X"7c";
    ram(1971) <= X"60";
    ram(1972) <= X"f7";
    ram(1973) <= X"20";
    ram(1974) <= X"57";
    ram(1975) <= X"fd";
    ram(1976) <= X"ad";
    ram(1977) <= X"05";
    ram(1978) <= X"80";
    ram(1979) <= X"8d";
    ram(1980) <= X"10";
    ram(1981) <= X"90";
    ram(1982) <= X"ad";
    ram(1983) <= X"06";
    ram(1984) <= X"80";
    ram(1985) <= X"8d";
    ram(1986) <= X"11";
    ram(1987) <= X"90";
    ram(1988) <= X"a9";
    ram(1989) <= X"77";
    ram(1990) <= X"8d";
    ram(1991) <= X"12";
    ram(1992) <= X"90";
    ram(1993) <= X"a9";
    ram(1994) <= X"07";
    ram(1995) <= X"8d";
    ram(1996) <= X"13";
    ram(1997) <= X"90";
    ram(1998) <= X"4c";
    ram(1999) <= X"fc";
    ram(2000) <= X"f8";
    ram(2001) <= X"a2";
    ram(2002) <= X"03";
    ram(2003) <= X"20";
    ram(2004) <= X"64";
    ram(2005) <= X"fd";
    ram(2006) <= X"ca";
    ram(2007) <= X"10";
    ram(2008) <= X"fa";
    ram(2009) <= X"80";
    ram(2010) <= X"a9";
    ram(2011) <= X"ad";
    ram(2012) <= X"0f";
    ram(2013) <= X"80";
    ram(2014) <= X"29";
    ram(2015) <= X"03";
    ram(2016) <= X"85";
    ram(2017) <= X"02";
    ram(2018) <= X"a2";
    ram(2019) <= X"00";
    ram(2020) <= X"e4";
    ram(2021) <= X"02";
    ram(2022) <= X"f0";
    ram(2023) <= X"09";
    ram(2024) <= X"bd";
    ram(2025) <= X"12";
    ram(2026) <= X"80";
    ram(2027) <= X"20";
    ram(2028) <= X"79";
    ram(2029) <= X"fd";
    ram(2030) <= X"e8";
    ram(2031) <= X"80";
    ram(2032) <= X"f3";
    ram(2033) <= X"20";
    ram(2034) <= X"5f";
    ram(2035) <= X"fd";
    ram(2036) <= X"e8";
    ram(2037) <= X"e0";
    ram(2038) <= X"04";
    ram(2039) <= X"d0";
    ram(2040) <= X"f8";
    ram(2041) <= X"80";
    ram(2042) <= X"89";
    ram(2043) <= X"a9";
    ram(2044) <= X"16";
    ram(2045) <= X"85";
    ram(2046) <= X"10";
    ram(2047) <= X"a9";
    ram(2048) <= X"0c";
    ram(2049) <= X"85";
    ram(2050) <= X"12";
    ram(2051) <= X"a2";
    ram(2052) <= X"08";
    ram(2053) <= X"80";
    ram(2054) <= X"16";
    ram(2055) <= X"a9";
    ram(2056) <= X"0f";
    ram(2057) <= X"85";
    ram(2058) <= X"10";
    ram(2059) <= X"a9";
    ram(2060) <= X"08";
    ram(2061) <= X"85";
    ram(2062) <= X"12";
    ram(2063) <= X"a2";
    ram(2064) <= X"04";
    ram(2065) <= X"80";
    ram(2066) <= X"0a";
    ram(2067) <= X"a9";
    ram(2068) <= X"00";
    ram(2069) <= X"85";
    ram(2070) <= X"10";
    ram(2071) <= X"a9";
    ram(2072) <= X"00";
    ram(2073) <= X"85";
    ram(2074) <= X"12";
    ram(2075) <= X"a2";
    ram(2076) <= X"08";
    ram(2077) <= X"5a";
    ram(2078) <= X"a0";
    ram(2079) <= X"00";
    ram(2080) <= X"b2";
    ram(2081) <= X"10";
    ram(2082) <= X"39";
    ram(2083) <= X"14";
    ram(2084) <= X"fe";
    ram(2085) <= X"f0";
    ram(2086) <= X"04";
    ram(2087) <= X"b1";
    ram(2088) <= X"12";
    ram(2089) <= X"80";
    ram(2090) <= X"02";
    ram(2091) <= X"a9";
    ram(2092) <= X"2e";
    ram(2093) <= X"20";
    ram(2094) <= X"8c";
    ram(2095) <= X"fd";
    ram(2096) <= X"c8";
    ram(2097) <= X"ca";
    ram(2098) <= X"d0";
    ram(2099) <= X"ec";
    ram(2100) <= X"7a";
    ram(2101) <= X"4c";
    ram(2102) <= X"84";
    ram(2103) <= X"f7";
    ram(2104) <= X"ad";
    ram(2105) <= X"0f";
    ram(2106) <= X"80";
    ram(2107) <= X"29";
    ram(2108) <= X"08";
    ram(2109) <= X"f0";
    ram(2110) <= X"04";
    ram(2111) <= X"a9";
    ram(2112) <= X"57";
    ram(2113) <= X"d0";
    ram(2114) <= X"0d";
    ram(2115) <= X"ad";
    ram(2116) <= X"0f";
    ram(2117) <= X"80";
    ram(2118) <= X"29";
    ram(2119) <= X"04";
    ram(2120) <= X"f0";
    ram(2121) <= X"04";
    ram(2122) <= X"a9";
    ram(2123) <= X"52";
    ram(2124) <= X"d0";
    ram(2125) <= X"02";
    ram(2126) <= X"a9";
    ram(2127) <= X"2d";
    ram(2128) <= X"20";
    ram(2129) <= X"8c";
    ram(2130) <= X"fd";
    ram(2131) <= X"20";
    ram(2132) <= X"64";
    ram(2133) <= X"fd";
    ram(2134) <= X"4c";
    ram(2135) <= X"84";
    ram(2136) <= X"f7";
    ram(2137) <= X"ad";
    ram(2138) <= X"16";
    ram(2139) <= X"90";
    ram(2140) <= X"29";
    ram(2141) <= X"04";
    ram(2142) <= X"f0";
    ram(2143) <= X"ee";
    ram(2144) <= X"a9";
    ram(2145) <= X"48";
    ram(2146) <= X"80";
    ram(2147) <= X"ec";
    ram(2148) <= X"fa";
    ram(2149) <= X"20";
    ram(2150) <= X"d8";
    ram(2151) <= X"f5";
    ram(2152) <= X"c0";
    ram(2153) <= X"00";
    ram(2154) <= X"f0";
    ram(2155) <= X"1c";
    ram(2156) <= X"c0";
    ram(2157) <= X"09";
    ram(2158) <= X"b0";
    ram(2159) <= X"15";
    ram(2160) <= X"a2";
    ram(2161) <= X"03";
    ram(2162) <= X"b5";
    ram(2163) <= X"08";
    ram(2164) <= X"9d";
    ram(2165) <= X"18";
    ram(2166) <= X"90";
    ram(2167) <= X"ca";
    ram(2168) <= X"10";
    ram(2169) <= X"f8";
    ram(2170) <= X"ad";
    ram(2171) <= X"04";
    ram(2172) <= X"90";
    ram(2173) <= X"09";
    ram(2174) <= X"40";
    ram(2175) <= X"8d";
    ram(2176) <= X"04";
    ram(2177) <= X"90";
    ram(2178) <= X"4c";
    ram(2179) <= X"22";
    ram(2180) <= X"f2";
    ram(2181) <= X"20";
    ram(2182) <= X"7f";
    ram(2183) <= X"f5";
    ram(2184) <= X"ad";
    ram(2185) <= X"04";
    ram(2186) <= X"90";
    ram(2187) <= X"29";
    ram(2188) <= X"bf";
    ram(2189) <= X"8d";
    ram(2190) <= X"04";
    ram(2191) <= X"90";
    ram(2192) <= X"4c";
    ram(2193) <= X"22";
    ram(2194) <= X"f2";
    ram(2195) <= X"ad";
    ram(2196) <= X"04";
    ram(2197) <= X"90";
    ram(2198) <= X"29";
    ram(2199) <= X"bf";
    ram(2200) <= X"8d";
    ram(2201) <= X"04";
    ram(2202) <= X"90";
    ram(2203) <= X"09";
    ram(2204) <= X"40";
    ram(2205) <= X"8d";
    ram(2206) <= X"04";
    ram(2207) <= X"90";
    ram(2208) <= X"4c";
    ram(2209) <= X"5a";
    ram(2210) <= X"f7";
    ram(2211) <= X"fa";
    ram(2212) <= X"20";
    ram(2213) <= X"d8";
    ram(2214) <= X"f5";
    ram(2215) <= X"c0";
    ram(2216) <= X"00";
    ram(2217) <= X"f0";
    ram(2218) <= X"1c";
    ram(2219) <= X"c0";
    ram(2220) <= X"05";
    ram(2221) <= X"b0";
    ram(2222) <= X"15";
    ram(2223) <= X"a2";
    ram(2224) <= X"01";
    ram(2225) <= X"b5";
    ram(2226) <= X"08";
    ram(2227) <= X"9d";
    ram(2228) <= X"0e";
    ram(2229) <= X"90";
    ram(2230) <= X"ca";
    ram(2231) <= X"10";
    ram(2232) <= X"f8";
    ram(2233) <= X"ad";
    ram(2234) <= X"04";
    ram(2235) <= X"90";
    ram(2236) <= X"09";
    ram(2237) <= X"80";
    ram(2238) <= X"8d";
    ram(2239) <= X"04";
    ram(2240) <= X"90";
    ram(2241) <= X"4c";
    ram(2242) <= X"22";
    ram(2243) <= X"f2";
    ram(2244) <= X"20";
    ram(2245) <= X"7f";
    ram(2246) <= X"f5";
    ram(2247) <= X"ad";
    ram(2248) <= X"04";
    ram(2249) <= X"90";
    ram(2250) <= X"29";
    ram(2251) <= X"7f";
    ram(2252) <= X"8d";
    ram(2253) <= X"04";
    ram(2254) <= X"90";
    ram(2255) <= X"4c";
    ram(2256) <= X"22";
    ram(2257) <= X"f2";
    ram(2258) <= X"ad";
    ram(2259) <= X"04";
    ram(2260) <= X"90";
    ram(2261) <= X"29";
    ram(2262) <= X"7d";
    ram(2263) <= X"8d";
    ram(2264) <= X"04";
    ram(2265) <= X"90";
    ram(2266) <= X"4c";
    ram(2267) <= X"5a";
    ram(2268) <= X"f7";
    ram(2269) <= X"4c";
    ram(2270) <= X"22";
    ram(2271) <= X"f2";
    ram(2272) <= X"fa";
    ram(2273) <= X"20";
    ram(2274) <= X"93";
    ram(2275) <= X"f5";
    ram(2276) <= X"a5";
    ram(2277) <= X"16";
    ram(2278) <= X"85";
    ram(2279) <= X"18";
    ram(2280) <= X"a5";
    ram(2281) <= X"18";
    ram(2282) <= X"d0";
    ram(2283) <= X"03";
    ram(2284) <= X"4c";
    ram(2285) <= X"22";
    ram(2286) <= X"f2";
    ram(2287) <= X"c6";
    ram(2288) <= X"18";
    ram(2289) <= X"2c";
    ram(2290) <= X"0a";
    ram(2291) <= X"90";
    ram(2292) <= X"30";
    ram(2293) <= X"e7";
    ram(2294) <= X"20";
    ram(2295) <= X"fc";
    ram(2296) <= X"f8";
    ram(2297) <= X"4c";
    ram(2298) <= X"e8";
    ram(2299) <= X"f8";
    ram(2300) <= X"a9";
    ram(2301) <= X"2c";
    ram(2302) <= X"20";
    ram(2303) <= X"8c";
    ram(2304) <= X"fd";
    ram(2305) <= X"a2";
    ram(2306) <= X"03";
    ram(2307) <= X"bd";
    ram(2308) <= X"10";
    ram(2309) <= X"90";
    ram(2310) <= X"20";
    ram(2311) <= X"79";
    ram(2312) <= X"fd";
    ram(2313) <= X"ca";
    ram(2314) <= X"10";
    ram(2315) <= X"f7";
    ram(2316) <= X"20";
    ram(2317) <= X"64";
    ram(2318) <= X"fd";
    ram(2319) <= X"a9";
    ram(2320) <= X"00";
    ram(2321) <= X"8d";
    ram(2322) <= X"14";
    ram(2323) <= X"90";
    ram(2324) <= X"2c";
    ram(2325) <= X"16";
    ram(2326) <= X"90";
    ram(2327) <= X"70";
    ram(2328) <= X"5e";
    ram(2329) <= X"10";
    ram(2330) <= X"f9";
    ram(2331) <= X"ad";
    ram(2332) <= X"14";
    ram(2333) <= X"90";
    ram(2334) <= X"85";
    ram(2335) <= X"5d";
    ram(2336) <= X"8e";
    ram(2337) <= X"17";
    ram(2338) <= X"90";
    ram(2339) <= X"aa";
    ram(2340) <= X"bd";
    ram(2341) <= X"44";
    ram(2342) <= X"fc";
    ram(2343) <= X"48";
    ram(2344) <= X"29";
    ram(2345) <= X"03";
    ram(2346) <= X"85";
    ram(2347) <= X"60";
    ram(2348) <= X"68";
    ram(2349) <= X"4a";
    ram(2350) <= X"4a";
    ram(2351) <= X"48";
    ram(2352) <= X"29";
    ram(2353) <= X"07";
    ram(2354) <= X"85";
    ram(2355) <= X"66";
    ram(2356) <= X"68";
    ram(2357) <= X"4a";
    ram(2358) <= X"4a";
    ram(2359) <= X"4a";
    ram(2360) <= X"85";
    ram(2361) <= X"65";
    ram(2362) <= X"bd";
    ram(2363) <= X"44";
    ram(2364) <= X"fb";
    ram(2365) <= X"aa";
    ram(2366) <= X"bd";
    ram(2367) <= X"8a";
    ram(2368) <= X"fa";
    ram(2369) <= X"85";
    ram(2370) <= X"62";
    ram(2371) <= X"bd";
    ram(2372) <= X"e7";
    ram(2373) <= X"fa";
    ram(2374) <= X"85";
    ram(2375) <= X"63";
    ram(2376) <= X"a2";
    ram(2377) <= X"01";
    ram(2378) <= X"e4";
    ram(2379) <= X"60";
    ram(2380) <= X"f0";
    ram(2381) <= X"2c";
    ram(2382) <= X"a9";
    ram(2383) <= X"00";
    ram(2384) <= X"8d";
    ram(2385) <= X"14";
    ram(2386) <= X"90";
    ram(2387) <= X"2c";
    ram(2388) <= X"16";
    ram(2389) <= X"90";
    ram(2390) <= X"70";
    ram(2391) <= X"1f";
    ram(2392) <= X"10";
    ram(2393) <= X"f9";
    ram(2394) <= X"ad";
    ram(2395) <= X"14";
    ram(2396) <= X"90";
    ram(2397) <= X"95";
    ram(2398) <= X"5d";
    ram(2399) <= X"8e";
    ram(2400) <= X"17";
    ram(2401) <= X"90";
    ram(2402) <= X"e8";
    ram(2403) <= X"e0";
    ram(2404) <= X"02";
    ram(2405) <= X"d0";
    ram(2406) <= X"e3";
    ram(2407) <= X"20";
    ram(2408) <= X"6c";
    ram(2409) <= X"f9";
    ram(2410) <= X"80";
    ram(2411) <= X"de";
    ram(2412) <= X"ad";
    ram(2413) <= X"10";
    ram(2414) <= X"90";
    ram(2415) <= X"85";
    ram(2416) <= X"6b";
    ram(2417) <= X"ad";
    ram(2418) <= X"11";
    ram(2419) <= X"90";
    ram(2420) <= X"85";
    ram(2421) <= X"6c";
    ram(2422) <= X"60";
    ram(2423) <= X"4c";
    ram(2424) <= X"75";
    ram(2425) <= X"f5";
    ram(2426) <= X"a2";
    ram(2427) <= X"00";
    ram(2428) <= X"b5";
    ram(2429) <= X"5d";
    ram(2430) <= X"20";
    ram(2431) <= X"72";
    ram(2432) <= X"fd";
    ram(2433) <= X"e8";
    ram(2434) <= X"e4";
    ram(2435) <= X"60";
    ram(2436) <= X"d0";
    ram(2437) <= X"f6";
    ram(2438) <= X"e0";
    ram(2439) <= X"03";
    ram(2440) <= X"f0";
    ram(2441) <= X"09";
    ram(2442) <= X"20";
    ram(2443) <= X"64";
    ram(2444) <= X"fd";
    ram(2445) <= X"20";
    ram(2446) <= X"5f";
    ram(2447) <= X"fd";
    ram(2448) <= X"e8";
    ram(2449) <= X"80";
    ram(2450) <= X"f3";
    ram(2451) <= X"20";
    ram(2452) <= X"5f";
    ram(2453) <= X"fd";
    ram(2454) <= X"a0";
    ram(2455) <= X"00";
    ram(2456) <= X"a5";
    ram(2457) <= X"62";
    ram(2458) <= X"29";
    ram(2459) <= X"1f";
    ram(2460) <= X"18";
    ram(2461) <= X"69";
    ram(2462) <= X"41";
    ram(2463) <= X"99";
    ram(2464) <= X"67";
    ram(2465) <= X"00";
    ram(2466) <= X"a2";
    ram(2467) <= X"05";
    ram(2468) <= X"66";
    ram(2469) <= X"63";
    ram(2470) <= X"66";
    ram(2471) <= X"62";
    ram(2472) <= X"ca";
    ram(2473) <= X"d0";
    ram(2474) <= X"f9";
    ram(2475) <= X"c8";
    ram(2476) <= X"c0";
    ram(2477) <= X"03";
    ram(2478) <= X"d0";
    ram(2479) <= X"e8";
    ram(2480) <= X"a9";
    ram(2481) <= X"00";
    ram(2482) <= X"99";
    ram(2483) <= X"67";
    ram(2484) <= X"00";
    ram(2485) <= X"a9";
    ram(2486) <= X"67";
    ram(2487) <= X"a2";
    ram(2488) <= X"00";
    ram(2489) <= X"20";
    ram(2490) <= X"44";
    ram(2491) <= X"fd";
    ram(2492) <= X"a5";
    ram(2493) <= X"62";
    ram(2494) <= X"29";
    ram(2495) <= X"01";
    ram(2496) <= X"f0";
    ram(2497) <= X"11";
    ram(2498) <= X"a5";
    ram(2499) <= X"5d";
    ram(2500) <= X"4a";
    ram(2501) <= X"4a";
    ram(2502) <= X"4a";
    ram(2503) <= X"4a";
    ram(2504) <= X"29";
    ram(2505) <= X"07";
    ram(2506) <= X"18";
    ram(2507) <= X"69";
    ram(2508) <= X"30";
    ram(2509) <= X"20";
    ram(2510) <= X"8c";
    ram(2511) <= X"fd";
    ram(2512) <= X"20";
    ram(2513) <= X"d6";
    ram(2514) <= X"f9";
    ram(2515) <= X"20";
    ram(2516) <= X"64";
    ram(2517) <= X"fd";
    ram(2518) <= X"20";
    ram(2519) <= X"5f";
    ram(2520) <= X"fd";
    ram(2521) <= X"a5";
    ram(2522) <= X"60";
    ram(2523) <= X"c9";
    ram(2524) <= X"02";
    ram(2525) <= X"90";
    ram(2526) <= X"7b";
    ram(2527) <= X"a5";
    ram(2528) <= X"5d";
    ram(2529) <= X"29";
    ram(2530) <= X"0f";
    ram(2531) <= X"c9";
    ram(2532) <= X"0f";
    ram(2533) <= X"d0";
    ram(2534) <= X"11";
    ram(2535) <= X"a5";
    ram(2536) <= X"5e";
    ram(2537) <= X"20";
    ram(2538) <= X"69";
    ram(2539) <= X"fd";
    ram(2540) <= X"a9";
    ram(2541) <= X"2c";
    ram(2542) <= X"20";
    ram(2543) <= X"8c";
    ram(2544) <= X"fd";
    ram(2545) <= X"20";
    ram(2546) <= X"6c";
    ram(2547) <= X"f9";
    ram(2548) <= X"a5";
    ram(2549) <= X"5f";
    ram(2550) <= X"80";
    ram(2551) <= X"35";
    ram(2552) <= X"a6";
    ram(2553) <= X"65";
    ram(2554) <= X"f0";
    ram(2555) <= X"09";
    ram(2556) <= X"ca";
    ram(2557) <= X"bd";
    ram(2558) <= X"5e";
    ram(2559) <= X"fa";
    ram(2560) <= X"f0";
    ram(2561) <= X"17";
    ram(2562) <= X"20";
    ram(2563) <= X"8c";
    ram(2564) <= X"fd";
    ram(2565) <= X"a6";
    ram(2566) <= X"60";
    ram(2567) <= X"ca";
    ram(2568) <= X"f0";
    ram(2569) <= X"40";
    ram(2570) <= X"a9";
    ram(2571) <= X"24";
    ram(2572) <= X"20";
    ram(2573) <= X"8c";
    ram(2574) <= X"fd";
    ram(2575) <= X"b5";
    ram(2576) <= X"5d";
    ram(2577) <= X"20";
    ram(2578) <= X"79";
    ram(2579) <= X"fd";
    ram(2580) <= X"ca";
    ram(2581) <= X"d0";
    ram(2582) <= X"f8";
    ram(2583) <= X"80";
    ram(2584) <= X"31";
    ram(2585) <= X"a5";
    ram(2586) <= X"60";
    ram(2587) <= X"c9";
    ram(2588) <= X"03";
    ram(2589) <= X"d0";
    ram(2590) <= X"0a";
    ram(2591) <= X"a5";
    ram(2592) <= X"5e";
    ram(2593) <= X"85";
    ram(2594) <= X"6d";
    ram(2595) <= X"a5";
    ram(2596) <= X"5f";
    ram(2597) <= X"85";
    ram(2598) <= X"6e";
    ram(2599) <= X"80";
    ram(2600) <= X"0c";
    ram(2601) <= X"64";
    ram(2602) <= X"6e";
    ram(2603) <= X"a5";
    ram(2604) <= X"5e";
    ram(2605) <= X"85";
    ram(2606) <= X"6d";
    ram(2607) <= X"10";
    ram(2608) <= X"04";
    ram(2609) <= X"a9";
    ram(2610) <= X"ff";
    ram(2611) <= X"85";
    ram(2612) <= X"6e";
    ram(2613) <= X"18";
    ram(2614) <= X"a5";
    ram(2615) <= X"6b";
    ram(2616) <= X"65";
    ram(2617) <= X"6d";
    ram(2618) <= X"85";
    ram(2619) <= X"6f";
    ram(2620) <= X"a5";
    ram(2621) <= X"6c";
    ram(2622) <= X"65";
    ram(2623) <= X"6e";
    ram(2624) <= X"85";
    ram(2625) <= X"70";
    ram(2626) <= X"20";
    ram(2627) <= X"69";
    ram(2628) <= X"fd";
    ram(2629) <= X"a5";
    ram(2630) <= X"6f";
    ram(2631) <= X"20";
    ram(2632) <= X"79";
    ram(2633) <= X"fd";
    ram(2634) <= X"a5";
    ram(2635) <= X"66";
    ram(2636) <= X"f0";
    ram(2637) <= X"0c";
    ram(2638) <= X"3a";
    ram(2639) <= X"0a";
    ram(2640) <= X"a8";
    ram(2641) <= X"b9";
    ram(2642) <= X"7c";
    ram(2643) <= X"fa";
    ram(2644) <= X"be";
    ram(2645) <= X"7d";
    ram(2646) <= X"fa";
    ram(2647) <= X"20";
    ram(2648) <= X"44";
    ram(2649) <= X"fd";
    ram(2650) <= X"20";
    ram(2651) <= X"57";
    ram(2652) <= X"fd";
    ram(2653) <= X"60";
    ram(2654) <= X"23";
    ram(2655) <= X"28";
    ram(2656) <= X"00";
    ram(2657) <= X"2c";
    ram(2658) <= X"58";
    ram(2659) <= X"00";
    ram(2660) <= X"2c";
    ram(2661) <= X"59";
    ram(2662) <= X"00";
    ram(2663) <= X"29";
    ram(2664) <= X"00";
    ram(2665) <= X"2c";
    ram(2666) <= X"58";
    ram(2667) <= X"29";
    ram(2668) <= X"00";
    ram(2669) <= X"29";
    ram(2670) <= X"2c";
    ram(2671) <= X"59";
    ram(2672) <= X"00";
    ram(2673) <= X"29";
    ram(2674) <= X"2c";
    ram(2675) <= X"5a";
    ram(2676) <= X"00";
    ram(2677) <= X"2c";
    ram(2678) <= X"53";
    ram(2679) <= X"50";
    ram(2680) <= X"29";
    ram(2681) <= X"2c";
    ram(2682) <= X"59";
    ram(2683) <= X"00";
    ram(2684) <= X"61";
    ram(2685) <= X"fa";
    ram(2686) <= X"64";
    ram(2687) <= X"fa";
    ram(2688) <= X"67";
    ram(2689) <= X"fa";
    ram(2690) <= X"69";
    ram(2691) <= X"fa";
    ram(2692) <= X"6d";
    ram(2693) <= X"fa";
    ram(2694) <= X"71";
    ram(2695) <= X"fa";
    ram(2696) <= X"75";
    ram(2697) <= X"fa";
    ram(2698) <= X"60";
    ram(2699) <= X"a0";
    ram(2700) <= X"40";
    ram(2701) <= X"40";
    ram(2702) <= X"40";
    ram(2703) <= X"21";
    ram(2704) <= X"21";
    ram(2705) <= X"41";
    ram(2706) <= X"41";
    ram(2707) <= X"81";
    ram(2708) <= X"01";
    ram(2709) <= X"81";
    ram(2710) <= X"a1";
    ram(2711) <= X"e1";
    ram(2712) <= X"21";
    ram(2713) <= X"21";
    ram(2714) <= X"41";
    ram(2715) <= X"a1";
    ram(2716) <= X"a1";
    ram(2717) <= X"62";
    ram(2718) <= X"62";
    ram(2719) <= X"62";
    ram(2720) <= X"62";
    ram(2721) <= X"62";
    ram(2722) <= X"82";
    ram(2723) <= X"e2";
    ram(2724) <= X"e2";
    ram(2725) <= X"e2";
    ram(2726) <= X"83";
    ram(2727) <= X"83";
    ram(2728) <= X"83";
    ram(2729) <= X"83";
    ram(2730) <= X"83";
    ram(2731) <= X"c4";
    ram(2732) <= X"a8";
    ram(2733) <= X"a8";
    ram(2734) <= X"a8";
    ram(2735) <= X"a8";
    ram(2736) <= X"a8";
    ram(2737) <= X"89";
    ram(2738) <= X"49";
    ram(2739) <= X"6b";
    ram(2740) <= X"6b";
    ram(2741) <= X"6b";
    ram(2742) <= X"6b";
    ram(2743) <= X"4b";
    ram(2744) <= X"0c";
    ram(2745) <= X"8d";
    ram(2746) <= X"cd";
    ram(2747) <= X"2e";
    ram(2748) <= X"ef";
    ram(2749) <= X"ef";
    ram(2750) <= X"ef";
    ram(2751) <= X"ef";
    ram(2752) <= X"ef";
    ram(2753) <= X"ef";
    ram(2754) <= X"6f";
    ram(2755) <= X"6f";
    ram(2756) <= X"6f";
    ram(2757) <= X"6f";
    ram(2758) <= X"6f";
    ram(2759) <= X"91";
    ram(2760) <= X"d1";
    ram(2761) <= X"d1";
    ram(2762) <= X"d1";
    ram(2763) <= X"71";
    ram(2764) <= X"71";
    ram(2765) <= X"71";
    ram(2766) <= X"32";
    ram(2767) <= X"92";
    ram(2768) <= X"92";
    ram(2769) <= X"92";
    ram(2770) <= X"92";
    ram(2771) <= X"92";
    ram(2772) <= X"72";
    ram(2773) <= X"72";
    ram(2774) <= X"72";
    ram(2775) <= X"72";
    ram(2776) <= X"13";
    ram(2777) <= X"13";
    ram(2778) <= X"13";
    ram(2779) <= X"13";
    ram(2780) <= X"33";
    ram(2781) <= X"33";
    ram(2782) <= X"53";
    ram(2783) <= X"53";
    ram(2784) <= X"53";
    ram(2785) <= X"f3";
    ram(2786) <= X"f3";
    ram(2787) <= X"13";
    ram(2788) <= X"13";
    ram(2789) <= X"33";
    ram(2790) <= X"0a";
    ram(2791) <= X"08";
    ram(2792) <= X"0d";
    ram(2793) <= X"2e";
    ram(2794) <= X"46";
    ram(2795) <= X"5a";
    ram(2796) <= X"c4";
    ram(2797) <= X"c8";
    ram(2798) <= X"08";
    ram(2799) <= X"48";
    ram(2800) <= X"40";
    ram(2801) <= X"4d";
    ram(2802) <= X"21";
    ram(2803) <= X"11";
    ram(2804) <= X"2d";
    ram(2805) <= X"02";
    ram(2806) <= X"2a";
    ram(2807) <= X"46";
    ram(2808) <= X"0a";
    ram(2809) <= X"4a";
    ram(2810) <= X"09";
    ram(2811) <= X"0d";
    ram(2812) <= X"11";
    ram(2813) <= X"21";
    ram(2814) <= X"55";
    ram(2815) <= X"3d";
    ram(2816) <= X"5d";
    ram(2817) <= X"61";
    ram(2818) <= X"65";
    ram(2819) <= X"08";
    ram(2820) <= X"58";
    ram(2821) <= X"5c";
    ram(2822) <= X"60";
    ram(2823) <= X"64";
    ram(2824) <= X"45";
    ram(2825) <= X"09";
    ram(2826) <= X"59";
    ram(2827) <= X"5d";
    ram(2828) <= X"61";
    ram(2829) <= X"65";
    ram(2830) <= X"3d";
    ram(2831) <= X"46";
    ram(2832) <= X"00";
    ram(2833) <= X"5c";
    ram(2834) <= X"60";
    ram(2835) <= X"64";
    ram(2836) <= X"46";
    ram(2837) <= X"3c";
    ram(2838) <= X"18";
    ram(2839) <= X"3d";
    ram(2840) <= X"02";
    ram(2841) <= X"00";
    ram(2842) <= X"3c";
    ram(2843) <= X"0c";
    ram(2844) <= X"5c";
    ram(2845) <= X"60";
    ram(2846) <= X"64";
    ram(2847) <= X"01";
    ram(2848) <= X"3d";
    ram(2849) <= X"5d";
    ram(2850) <= X"61";
    ram(2851) <= X"65";
    ram(2852) <= X"85";
    ram(2853) <= X"2d";
    ram(2854) <= X"45";
    ram(2855) <= X"59";
    ram(2856) <= X"22";
    ram(2857) <= X"36";
    ram(2858) <= X"4a";
    ram(2859) <= X"08";
    ram(2860) <= X"08";
    ram(2861) <= X"0c";
    ram(2862) <= X"10";
    ram(2863) <= X"20";
    ram(2864) <= X"85";
    ram(2865) <= X"02";
    ram(2866) <= X"5e";
    ram(2867) <= X"62";
    ram(2868) <= X"66";
    ram(2869) <= X"04";
    ram(2870) <= X"5c";
    ram(2871) <= X"60";
    ram(2872) <= X"64";
    ram(2873) <= X"00";
    ram(2874) <= X"06";
    ram(2875) <= X"06";
    ram(2876) <= X"5e";
    ram(2877) <= X"62";
    ram(2878) <= X"02";
    ram(2879) <= X"4a";
    ram(2880) <= X"03";
    ram(2881) <= X"4b";
    ram(2882) <= X"03";
    ram(2883) <= X"2d";
    ram(2884) <= X"0f";
    ram(2885) <= X"31";
    ram(2886) <= X"15";
    ram(2887) <= X"47";
    ram(2888) <= X"54";
    ram(2889) <= X"31";
    ram(2890) <= X"02";
    ram(2891) <= X"3d";
    ram(2892) <= X"33";
    ram(2893) <= X"31";
    ram(2894) <= X"02";
    ram(2895) <= X"56";
    ram(2896) <= X"54";
    ram(2897) <= X"31";
    ram(2898) <= X"02";
    ram(2899) <= X"05";
    ram(2900) <= X"0d";
    ram(2901) <= X"31";
    ram(2902) <= X"31";
    ram(2903) <= X"0d";
    ram(2904) <= X"53";
    ram(2905) <= X"31";
    ram(2906) <= X"02";
    ram(2907) <= X"3d";
    ram(2908) <= X"13";
    ram(2909) <= X"31";
    ram(2910) <= X"22";
    ram(2911) <= X"26";
    ram(2912) <= X"53";
    ram(2913) <= X"31";
    ram(2914) <= X"02";
    ram(2915) <= X"05";
    ram(2916) <= X"28";
    ram(2917) <= X"01";
    ram(2918) <= X"28";
    ram(2919) <= X"28";
    ram(2920) <= X"0a";
    ram(2921) <= X"01";
    ram(2922) <= X"3e";
    ram(2923) <= X"3d";
    ram(2924) <= X"39";
    ram(2925) <= X"01";
    ram(2926) <= X"3e";
    ram(2927) <= X"5a";
    ram(2928) <= X"0a";
    ram(2929) <= X"01";
    ram(2930) <= X"3e";
    ram(2931) <= X"05";
    ram(2932) <= X"0b";
    ram(2933) <= X"01";
    ram(2934) <= X"01";
    ram(2935) <= X"0b";
    ram(2936) <= X"0a";
    ram(2937) <= X"01";
    ram(2938) <= X"3e";
    ram(2939) <= X"3d";
    ram(2940) <= X"45";
    ram(2941) <= X"01";
    ram(2942) <= X"1c";
    ram(2943) <= X"20";
    ram(2944) <= X"0a";
    ram(2945) <= X"01";
    ram(2946) <= X"3e";
    ram(2947) <= X"05";
    ram(2948) <= X"41";
    ram(2949) <= X"21";
    ram(2950) <= X"2f";
    ram(2951) <= X"03";
    ram(2952) <= X"03";
    ram(2953) <= X"21";
    ram(2954) <= X"2d";
    ram(2955) <= X"3d";
    ram(2956) <= X"32";
    ram(2957) <= X"21";
    ram(2958) <= X"2d";
    ram(2959) <= X"51";
    ram(2960) <= X"27";
    ram(2961) <= X"21";
    ram(2962) <= X"2d";
    ram(2963) <= X"05";
    ram(2964) <= X"11";
    ram(2965) <= X"21";
    ram(2966) <= X"21";
    ram(2967) <= X"11";
    ram(2968) <= X"03";
    ram(2969) <= X"21";
    ram(2970) <= X"2d";
    ram(2971) <= X"3d";
    ram(2972) <= X"16";
    ram(2973) <= X"21";
    ram(2974) <= X"36";
    ram(2975) <= X"4e";
    ram(2976) <= X"2e";
    ram(2977) <= X"21";
    ram(2978) <= X"2d";
    ram(2979) <= X"05";
    ram(2980) <= X"43";
    ram(2981) <= X"00";
    ram(2982) <= X"42";
    ram(2983) <= X"10";
    ram(2984) <= X"4d";
    ram(2985) <= X"00";
    ram(2986) <= X"3f";
    ram(2987) <= X"3d";
    ram(2988) <= X"38";
    ram(2989) <= X"00";
    ram(2990) <= X"3f";
    ram(2991) <= X"5b";
    ram(2992) <= X"27";
    ram(2993) <= X"00";
    ram(2994) <= X"3f";
    ram(2995) <= X"05";
    ram(2996) <= X"12";
    ram(2997) <= X"00";
    ram(2998) <= X"00";
    ram(2999) <= X"12";
    ram(3000) <= X"4d";
    ram(3001) <= X"00";
    ram(3002) <= X"3f";
    ram(3003) <= X"3d";
    ram(3004) <= X"48";
    ram(3005) <= X"00";
    ram(3006) <= X"3b";
    ram(3007) <= X"52";
    ram(3008) <= X"27";
    ram(3009) <= X"00";
    ram(3010) <= X"3f";
    ram(3011) <= X"05";
    ram(3012) <= X"0e";
    ram(3013) <= X"4a";
    ram(3014) <= X"4a";
    ram(3015) <= X"0e";
    ram(3016) <= X"4c";
    ram(3017) <= X"4a";
    ram(3018) <= X"4b";
    ram(3019) <= X"49";
    ram(3020) <= X"1f";
    ram(3021) <= X"0a";
    ram(3022) <= X"57";
    ram(3023) <= X"4c";
    ram(3024) <= X"4c";
    ram(3025) <= X"4a";
    ram(3026) <= X"4b";
    ram(3027) <= X"06";
    ram(3028) <= X"07";
    ram(3029) <= X"4a";
    ram(3030) <= X"4a";
    ram(3031) <= X"07";
    ram(3032) <= X"4c";
    ram(3033) <= X"4a";
    ram(3034) <= X"4b";
    ram(3035) <= X"49";
    ram(3036) <= X"59";
    ram(3037) <= X"4a";
    ram(3038) <= X"58";
    ram(3039) <= X"4b";
    ram(3040) <= X"4d";
    ram(3041) <= X"4a";
    ram(3042) <= X"4d";
    ram(3043) <= X"06";
    ram(3044) <= X"2b";
    ram(3045) <= X"29";
    ram(3046) <= X"2a";
    ram(3047) <= X"2c";
    ram(3048) <= X"2b";
    ram(3049) <= X"29";
    ram(3050) <= X"2a";
    ram(3051) <= X"49";
    ram(3052) <= X"50";
    ram(3053) <= X"29";
    ram(3054) <= X"4f";
    ram(3055) <= X"2c";
    ram(3056) <= X"2b";
    ram(3057) <= X"29";
    ram(3058) <= X"2a";
    ram(3059) <= X"06";
    ram(3060) <= X"08";
    ram(3061) <= X"29";
    ram(3062) <= X"29";
    ram(3063) <= X"08";
    ram(3064) <= X"2b";
    ram(3065) <= X"29";
    ram(3066) <= X"2a";
    ram(3067) <= X"49";
    ram(3068) <= X"17";
    ram(3069) <= X"29";
    ram(3070) <= X"55";
    ram(3071) <= X"2c";
    ram(3072) <= X"2b";
    ram(3073) <= X"29";
    ram(3074) <= X"2a";
    ram(3075) <= X"06";
    ram(3076) <= X"1a";
    ram(3077) <= X"18";
    ram(3078) <= X"1b";
    ram(3079) <= X"1d";
    ram(3080) <= X"1a";
    ram(3081) <= X"18";
    ram(3082) <= X"1c";
    ram(3083) <= X"49";
    ram(3084) <= X"25";
    ram(3085) <= X"18";
    ram(3086) <= X"1e";
    ram(3087) <= X"04";
    ram(3088) <= X"1a";
    ram(3089) <= X"18";
    ram(3090) <= X"1c";
    ram(3091) <= X"06";
    ram(3092) <= X"0c";
    ram(3093) <= X"18";
    ram(3094) <= X"18";
    ram(3095) <= X"0c";
    ram(3096) <= X"1b";
    ram(3097) <= X"18";
    ram(3098) <= X"1c";
    ram(3099) <= X"49";
    ram(3100) <= X"14";
    ram(3101) <= X"18";
    ram(3102) <= X"35";
    ram(3103) <= X"37";
    ram(3104) <= X"1b";
    ram(3105) <= X"18";
    ram(3106) <= X"1c";
    ram(3107) <= X"06";
    ram(3108) <= X"19";
    ram(3109) <= X"44";
    ram(3110) <= X"29";
    ram(3111) <= X"23";
    ram(3112) <= X"19";
    ram(3113) <= X"44";
    ram(3114) <= X"22";
    ram(3115) <= X"49";
    ram(3116) <= X"24";
    ram(3117) <= X"44";
    ram(3118) <= X"30";
    ram(3119) <= X"40";
    ram(3120) <= X"19";
    ram(3121) <= X"44";
    ram(3122) <= X"22";
    ram(3123) <= X"06";
    ram(3124) <= X"09";
    ram(3125) <= X"44";
    ram(3126) <= X"44";
    ram(3127) <= X"09";
    ram(3128) <= X"34";
    ram(3129) <= X"44";
    ram(3130) <= X"22";
    ram(3131) <= X"49";
    ram(3132) <= X"46";
    ram(3133) <= X"44";
    ram(3134) <= X"3a";
    ram(3135) <= X"3c";
    ram(3136) <= X"34";
    ram(3137) <= X"44";
    ram(3138) <= X"22";
    ram(3139) <= X"06";
    ram(3140) <= X"02";
    ram(3141) <= X"52";
    ram(3142) <= X"01";
    ram(3143) <= X"01";
    ram(3144) <= X"02";
    ram(3145) <= X"02";
    ram(3146) <= X"02";
    ram(3147) <= X"02";
    ram(3148) <= X"01";
    ram(3149) <= X"22";
    ram(3150) <= X"01";
    ram(3151) <= X"01";
    ram(3152) <= X"03";
    ram(3153) <= X"03";
    ram(3154) <= X"03";
    ram(3155) <= X"03";
    ram(3156) <= X"62";
    ram(3157) <= X"56";
    ram(3158) <= X"0a";
    ram(3159) <= X"63";
    ram(3160) <= X"02";
    ram(3161) <= X"06";
    ram(3162) <= X"06";
    ram(3163) <= X"02";
    ram(3164) <= X"01";
    ram(3165) <= X"0b";
    ram(3166) <= X"01";
    ram(3167) <= X"01";
    ram(3168) <= X"03";
    ram(3169) <= X"07";
    ram(3170) <= X"07";
    ram(3171) <= X"03";
    ram(3172) <= X"03";
    ram(3173) <= X"52";
    ram(3174) <= X"4f";
    ram(3175) <= X"53";
    ram(3176) <= X"02";
    ram(3177) <= X"02";
    ram(3178) <= X"02";
    ram(3179) <= X"02";
    ram(3180) <= X"01";
    ram(3181) <= X"22";
    ram(3182) <= X"01";
    ram(3183) <= X"01";
    ram(3184) <= X"03";
    ram(3185) <= X"03";
    ram(3186) <= X"03";
    ram(3187) <= X"03";
    ram(3188) <= X"62";
    ram(3189) <= X"56";
    ram(3190) <= X"56";
    ram(3191) <= X"63";
    ram(3192) <= X"06";
    ram(3193) <= X"06";
    ram(3194) <= X"06";
    ram(3195) <= X"02";
    ram(3196) <= X"01";
    ram(3197) <= X"0b";
    ram(3198) <= X"01";
    ram(3199) <= X"01";
    ram(3200) <= X"07";
    ram(3201) <= X"07";
    ram(3202) <= X"07";
    ram(3203) <= X"03";
    ram(3204) <= X"01";
    ram(3205) <= X"52";
    ram(3206) <= X"01";
    ram(3207) <= X"01";
    ram(3208) <= X"02";
    ram(3209) <= X"02";
    ram(3210) <= X"02";
    ram(3211) <= X"02";
    ram(3212) <= X"01";
    ram(3213) <= X"22";
    ram(3214) <= X"01";
    ram(3215) <= X"01";
    ram(3216) <= X"03";
    ram(3217) <= X"03";
    ram(3218) <= X"03";
    ram(3219) <= X"03";
    ram(3220) <= X"62";
    ram(3221) <= X"56";
    ram(3222) <= X"5a";
    ram(3223) <= X"63";
    ram(3224) <= X"06";
    ram(3225) <= X"06";
    ram(3226) <= X"06";
    ram(3227) <= X"02";
    ram(3228) <= X"01";
    ram(3229) <= X"0b";
    ram(3230) <= X"01";
    ram(3231) <= X"01";
    ram(3232) <= X"01";
    ram(3233) <= X"07";
    ram(3234) <= X"07";
    ram(3235) <= X"03";
    ram(3236) <= X"01";
    ram(3237) <= X"52";
    ram(3238) <= X"22";
    ram(3239) <= X"63";
    ram(3240) <= X"02";
    ram(3241) <= X"02";
    ram(3242) <= X"02";
    ram(3243) <= X"02";
    ram(3244) <= X"01";
    ram(3245) <= X"22";
    ram(3246) <= X"01";
    ram(3247) <= X"01";
    ram(3248) <= X"4f";
    ram(3249) <= X"03";
    ram(3250) <= X"03";
    ram(3251) <= X"03";
    ram(3252) <= X"62";
    ram(3253) <= X"56";
    ram(3254) <= X"5a";
    ram(3255) <= X"63";
    ram(3256) <= X"06";
    ram(3257) <= X"06";
    ram(3258) <= X"06";
    ram(3259) <= X"02";
    ram(3260) <= X"01";
    ram(3261) <= X"0b";
    ram(3262) <= X"01";
    ram(3263) <= X"01";
    ram(3264) <= X"53";
    ram(3265) <= X"07";
    ram(3266) <= X"07";
    ram(3267) <= X"03";
    ram(3268) <= X"62";
    ram(3269) <= X"52";
    ram(3270) <= X"5e";
    ram(3271) <= X"63";
    ram(3272) <= X"02";
    ram(3273) <= X"02";
    ram(3274) <= X"02";
    ram(3275) <= X"02";
    ram(3276) <= X"01";
    ram(3277) <= X"01";
    ram(3278) <= X"01";
    ram(3279) <= X"07";
    ram(3280) <= X"03";
    ram(3281) <= X"03";
    ram(3282) <= X"03";
    ram(3283) <= X"03";
    ram(3284) <= X"62";
    ram(3285) <= X"56";
    ram(3286) <= X"5a";
    ram(3287) <= X"63";
    ram(3288) <= X"06";
    ram(3289) <= X"06";
    ram(3290) <= X"0a";
    ram(3291) <= X"02";
    ram(3292) <= X"01";
    ram(3293) <= X"0b";
    ram(3294) <= X"01";
    ram(3295) <= X"0b";
    ram(3296) <= X"03";
    ram(3297) <= X"07";
    ram(3298) <= X"07";
    ram(3299) <= X"03";
    ram(3300) <= X"22";
    ram(3301) <= X"52";
    ram(3302) <= X"22";
    ram(3303) <= X"22";
    ram(3304) <= X"02";
    ram(3305) <= X"02";
    ram(3306) <= X"02";
    ram(3307) <= X"02";
    ram(3308) <= X"01";
    ram(3309) <= X"22";
    ram(3310) <= X"01";
    ram(3311) <= X"02";
    ram(3312) <= X"03";
    ram(3313) <= X"03";
    ram(3314) <= X"03";
    ram(3315) <= X"03";
    ram(3316) <= X"62";
    ram(3317) <= X"56";
    ram(3318) <= X"5a";
    ram(3319) <= X"63";
    ram(3320) <= X"06";
    ram(3321) <= X"06";
    ram(3322) <= X"0a";
    ram(3323) <= X"02";
    ram(3324) <= X"01";
    ram(3325) <= X"0b";
    ram(3326) <= X"01";
    ram(3327) <= X"07";
    ram(3328) <= X"07";
    ram(3329) <= X"07";
    ram(3330) <= X"0b";
    ram(3331) <= X"03";
    ram(3332) <= X"22";
    ram(3333) <= X"52";
    ram(3334) <= X"22";
    ram(3335) <= X"02";
    ram(3336) <= X"02";
    ram(3337) <= X"02";
    ram(3338) <= X"02";
    ram(3339) <= X"02";
    ram(3340) <= X"01";
    ram(3341) <= X"22";
    ram(3342) <= X"01";
    ram(3343) <= X"03";
    ram(3344) <= X"03";
    ram(3345) <= X"03";
    ram(3346) <= X"03";
    ram(3347) <= X"03";
    ram(3348) <= X"62";
    ram(3349) <= X"56";
    ram(3350) <= X"5a";
    ram(3351) <= X"63";
    ram(3352) <= X"02";
    ram(3353) <= X"06";
    ram(3354) <= X"06";
    ram(3355) <= X"02";
    ram(3356) <= X"01";
    ram(3357) <= X"0b";
    ram(3358) <= X"01";
    ram(3359) <= X"01";
    ram(3360) <= X"03";
    ram(3361) <= X"07";
    ram(3362) <= X"07";
    ram(3363) <= X"03";
    ram(3364) <= X"22";
    ram(3365) <= X"52";
    ram(3366) <= X"5e";
    ram(3367) <= X"02";
    ram(3368) <= X"02";
    ram(3369) <= X"02";
    ram(3370) <= X"02";
    ram(3371) <= X"02";
    ram(3372) <= X"01";
    ram(3373) <= X"22";
    ram(3374) <= X"01";
    ram(3375) <= X"03";
    ram(3376) <= X"03";
    ram(3377) <= X"03";
    ram(3378) <= X"03";
    ram(3379) <= X"03";
    ram(3380) <= X"62";
    ram(3381) <= X"56";
    ram(3382) <= X"5a";
    ram(3383) <= X"63";
    ram(3384) <= X"23";
    ram(3385) <= X"06";
    ram(3386) <= X"06";
    ram(3387) <= X"02";
    ram(3388) <= X"01";
    ram(3389) <= X"0b";
    ram(3390) <= X"01";
    ram(3391) <= X"01";
    ram(3392) <= X"03";
    ram(3393) <= X"07";
    ram(3394) <= X"07";
    ram(3395) <= X"03";
    ram(3396) <= X"85";
    ram(3397) <= X"00";
    ram(3398) <= X"86";
    ram(3399) <= X"01";
    ram(3400) <= X"5a";
    ram(3401) <= X"a0";
    ram(3402) <= X"00";
    ram(3403) <= X"b1";
    ram(3404) <= X"00";
    ram(3405) <= X"f0";
    ram(3406) <= X"06";
    ram(3407) <= X"20";
    ram(3408) <= X"8c";
    ram(3409) <= X"fd";
    ram(3410) <= X"c8";
    ram(3411) <= X"d0";
    ram(3412) <= X"f6";
    ram(3413) <= X"7a";
    ram(3414) <= X"60";
    ram(3415) <= X"a9";
    ram(3416) <= X"97";
    ram(3417) <= X"a2";
    ram(3418) <= X"fe";
    ram(3419) <= X"20";
    ram(3420) <= X"44";
    ram(3421) <= X"fd";
    ram(3422) <= X"60";
    ram(3423) <= X"a9";
    ram(3424) <= X"20";
    ram(3425) <= X"20";
    ram(3426) <= X"8c";
    ram(3427) <= X"fd";
    ram(3428) <= X"a9";
    ram(3429) <= X"20";
    ram(3430) <= X"4c";
    ram(3431) <= X"8c";
    ram(3432) <= X"fd";
    ram(3433) <= X"48";
    ram(3434) <= X"a9";
    ram(3435) <= X"24";
    ram(3436) <= X"20";
    ram(3437) <= X"8c";
    ram(3438) <= X"fd";
    ram(3439) <= X"68";
    ram(3440) <= X"80";
    ram(3441) <= X"07";
    ram(3442) <= X"48";
    ram(3443) <= X"a9";
    ram(3444) <= X"20";
    ram(3445) <= X"20";
    ram(3446) <= X"8c";
    ram(3447) <= X"fd";
    ram(3448) <= X"68";
    ram(3449) <= X"48";
    ram(3450) <= X"4a";
    ram(3451) <= X"4a";
    ram(3452) <= X"4a";
    ram(3453) <= X"4a";
    ram(3454) <= X"20";
    ram(3455) <= X"82";
    ram(3456) <= X"fd";
    ram(3457) <= X"68";
    ram(3458) <= X"29";
    ram(3459) <= X"0f";
    ram(3460) <= X"09";
    ram(3461) <= X"30";
    ram(3462) <= X"c9";
    ram(3463) <= X"3a";
    ram(3464) <= X"90";
    ram(3465) <= X"02";
    ram(3466) <= X"69";
    ram(3467) <= X"06";
    ram(3468) <= X"2c";
    ram(3469) <= X"0a";
    ram(3470) <= X"90";
    ram(3471) <= X"50";
    ram(3472) <= X"fb";
    ram(3473) <= X"8d";
    ram(3474) <= X"08";
    ram(3475) <= X"90";
    ram(3476) <= X"2c";
    ram(3477) <= X"1d";
    ram(3478) <= X"90";
    ram(3479) <= X"50";
    ram(3480) <= X"08";
    ram(3481) <= X"2c";
    ram(3482) <= X"1f";
    ram(3483) <= X"90";
    ram(3484) <= X"50";
    ram(3485) <= X"fb";
    ram(3486) <= X"8d";
    ram(3487) <= X"1e";
    ram(3488) <= X"90";
    ram(3489) <= X"60";
    ram(3490) <= X"00";
    ram(3491) <= X"00";
    ram(3492) <= X"00";
    ram(3493) <= X"00";
    ram(3494) <= X"00";
    ram(3495) <= X"00";
    ram(3496) <= X"00";
    ram(3497) <= X"00";
    ram(3498) <= X"00";
    ram(3499) <= X"00";
    ram(3500) <= X"00";
    ram(3501) <= X"00";
    ram(3502) <= X"00";
    ram(3503) <= X"00";
    ram(3504) <= X"00";
    ram(3505) <= X"00";
    ram(3506) <= X"00";
    ram(3507) <= X"00";
    ram(3508) <= X"00";
    ram(3509) <= X"00";
    ram(3510) <= X"00";
    ram(3511) <= X"00";
    ram(3512) <= X"00";
    ram(3513) <= X"00";
    ram(3514) <= X"00";
    ram(3515) <= X"00";
    ram(3516) <= X"00";
    ram(3517) <= X"00";
    ram(3518) <= X"00";
    ram(3519) <= X"00";
    ram(3520) <= X"00";
    ram(3521) <= X"00";
    ram(3522) <= X"00";
    ram(3523) <= X"00";
    ram(3524) <= X"00";
    ram(3525) <= X"00";
    ram(3526) <= X"00";
    ram(3527) <= X"00";
    ram(3528) <= X"00";
    ram(3529) <= X"00";
    ram(3530) <= X"00";
    ram(3531) <= X"00";
    ram(3532) <= X"00";
    ram(3533) <= X"00";
    ram(3534) <= X"00";
    ram(3535) <= X"00";
    ram(3536) <= X"00";
    ram(3537) <= X"00";
    ram(3538) <= X"00";
    ram(3539) <= X"00";
    ram(3540) <= X"00";
    ram(3541) <= X"00";
    ram(3542) <= X"00";
    ram(3543) <= X"00";
    ram(3544) <= X"00";
    ram(3545) <= X"00";
    ram(3546) <= X"00";
    ram(3547) <= X"00";
    ram(3548) <= X"00";
    ram(3549) <= X"00";
    ram(3550) <= X"00";
    ram(3551) <= X"00";
    ram(3552) <= X"00";
    ram(3553) <= X"00";
    ram(3554) <= X"00";
    ram(3555) <= X"00";
    ram(3556) <= X"00";
    ram(3557) <= X"00";
    ram(3558) <= X"00";
    ram(3559) <= X"00";
    ram(3560) <= X"00";
    ram(3561) <= X"00";
    ram(3562) <= X"00";
    ram(3563) <= X"00";
    ram(3564) <= X"00";
    ram(3565) <= X"00";
    ram(3566) <= X"00";
    ram(3567) <= X"00";
    ram(3568) <= X"00";
    ram(3569) <= X"00";
    ram(3570) <= X"00";
    ram(3571) <= X"00";
    ram(3572) <= X"00";
    ram(3573) <= X"00";
    ram(3574) <= X"00";
    ram(3575) <= X"00";
    ram(3576) <= X"00";
    ram(3577) <= X"00";
    ram(3578) <= X"00";
    ram(3579) <= X"00";
    ram(3580) <= X"00";
    ram(3581) <= X"00";
    ram(3582) <= X"00";
    ram(3583) <= X"00";
    ram(3584) <= X"4e";
    ram(3585) <= X"56";
    ram(3586) <= X"45";
    ram(3587) <= X"42";
    ram(3588) <= X"44";
    ram(3589) <= X"49";
    ram(3590) <= X"5a";
    ram(3591) <= X"43";
    ram(3592) <= X"4d";
    ram(3593) <= X"52";
    ram(3594) <= X"47";
    ram(3595) <= X"50";
    ram(3596) <= X"72";
    ram(3597) <= X"65";
    ram(3598) <= X"63";
    ram(3599) <= X"61";
    ram(3600) <= X"38";
    ram(3601) <= X"6c";
    ram(3602) <= X"68";
    ram(3603) <= X"63";
    ram(3604) <= X"80";
    ram(3605) <= X"40";
    ram(3606) <= X"20";
    ram(3607) <= X"10";
    ram(3608) <= X"08";
    ram(3609) <= X"04";
    ram(3610) <= X"02";
    ram(3611) <= X"01";
    ram(3612) <= X"21";
    ram(3613) <= X"40";
    ram(3614) <= X"4d";
    ram(3615) <= X"3f";
    ram(3616) <= X"48";
    ram(3617) <= X"52";
    ram(3618) <= X"54";
    ram(3619) <= X"5a";
    ram(3620) <= X"57";
    ram(3621) <= X"42";
    ram(3622) <= X"47";
    ram(3623) <= X"2b";
    ram(3624) <= X"49";
    ram(3625) <= X"23";
    ram(3626) <= X"45";
    ram(3627) <= X"46";
    ram(3628) <= X"53";
    ram(3629) <= X"4c";
    ram(3630) <= X"44";
    ram(3631) <= X"a1";
    ram(3632) <= X"f3";
    ram(3633) <= X"27";
    ram(3634) <= X"f5";
    ram(3635) <= X"35";
    ram(3636) <= X"f5";
    ram(3637) <= X"1b";
    ram(3638) <= X"f2";
    ram(3639) <= X"1b";
    ram(3640) <= X"f2";
    ram(3641) <= X"5a";
    ram(3642) <= X"f7";
    ram(3643) <= X"3c";
    ram(3644) <= X"f6";
    ram(3645) <= X"36";
    ram(3646) <= X"f7";
    ram(3647) <= X"64";
    ram(3648) <= X"f8";
    ram(3649) <= X"a3";
    ram(3650) <= X"f8";
    ram(3651) <= X"02";
    ram(3652) <= X"f5";
    ram(3653) <= X"18";
    ram(3654) <= X"f4";
    ram(3655) <= X"2f";
    ram(3656) <= X"f6";
    ram(3657) <= X"aa";
    ram(3658) <= X"f6";
    ram(3659) <= X"bb";
    ram(3660) <= X"f6";
    ram(3661) <= X"31";
    ram(3662) <= X"f4";
    ram(3663) <= X"8a";
    ram(3664) <= X"f4";
    ram(3665) <= X"c8";
    ram(3666) <= X"f4";
    ram(3667) <= X"e0";
    ram(3668) <= X"f8";
    ram(3669) <= X"4d";
    ram(3670) <= X"45";
    ram(3671) <= X"47";
    ram(3672) <= X"41";
    ram(3673) <= X"36";
    ram(3674) <= X"35";
    ram(3675) <= X"20";
    ram(3676) <= X"53";
    ram(3677) <= X"65";
    ram(3678) <= X"72";
    ram(3679) <= X"69";
    ram(3680) <= X"61";
    ram(3681) <= X"6c";
    ram(3682) <= X"20";
    ram(3683) <= X"4d";
    ram(3684) <= X"6f";
    ram(3685) <= X"6e";
    ram(3686) <= X"69";
    ram(3687) <= X"74";
    ram(3688) <= X"6f";
    ram(3689) <= X"72";
    ram(3690) <= X"0d";
    ram(3691) <= X"0a";
    ram(3692) <= X"62";
    ram(3693) <= X"75";
    ram(3694) <= X"69";
    ram(3695) <= X"6c";
    ram(3696) <= X"64";
    ram(3697) <= X"20";
    ram(3698) <= X"47";
    ram(3699) <= X"49";
    ram(3700) <= X"54";
    ram(3701) <= X"3a";
    ram(3702) <= X"20";
    ram(3703) <= X"6e";
    ram(3704) <= X"65";
    ram(3705) <= X"77";
    ram(3706) <= X"5f";
    ram(3707) <= X"63";
    ram(3708) <= X"70";
    ram(3709) <= X"2c";
    ram(3710) <= X"38";
    ram(3711) <= X"37";
    ram(3712) <= X"38";
    ram(3713) <= X"64";
    ram(3714) <= X"64";
    ram(3715) <= X"66";
    ram(3716) <= X"31";
    ram(3717) <= X"2b";
    ram(3718) <= X"44";
    ram(3719) <= X"49";
    ram(3720) <= X"52";
    ram(3721) <= X"54";
    ram(3722) <= X"59";
    ram(3723) <= X"2c";
    ram(3724) <= X"32";
    ram(3725) <= X"30";
    ram(3726) <= X"31";
    ram(3727) <= X"38";
    ram(3728) <= X"31";
    ram(3729) <= X"31";
    ram(3730) <= X"32";
    ram(3731) <= X"33";
    ram(3732) <= X"2e";
    ram(3733) <= X"31";
    ram(3734) <= X"34";
    ram(3735) <= X"0d";
    ram(3736) <= X"0a";
    ram(3737) <= X"00";
    ram(3738) <= X"0d";
    ram(3739) <= X"0a";
    ram(3740) <= X"2e";
    ram(3741) <= X"00";
    ram(3742) <= X"08";
    ram(3743) <= X"20";
    ram(3744) <= X"08";
    ram(3745) <= X"00";
    ram(3746) <= X"0d";
    ram(3747) <= X"0a";
    ram(3748) <= X"75";
    ram(3749) <= X"53";
    ram(3750) <= X"20";
    ram(3751) <= X"41";
    ram(3752) <= X"64";
    ram(3753) <= X"64";
    ram(3754) <= X"72";
    ram(3755) <= X"65";
    ram(3756) <= X"73";
    ram(3757) <= X"73";
    ram(3758) <= X"20";
    ram(3759) <= X"20";
    ram(3760) <= X"52";
    ram(3761) <= X"64";
    ram(3762) <= X"0d";
    ram(3763) <= X"0a";
    ram(3764) <= X"00";
    ram(3765) <= X"0d";
    ram(3766) <= X"0a";
    ram(3767) <= X"50";
    ram(3768) <= X"43";
    ram(3769) <= X"20";
    ram(3770) <= X"20";
    ram(3771) <= X"20";
    ram(3772) <= X"41";
    ram(3773) <= X"20";
    ram(3774) <= X"20";
    ram(3775) <= X"58";
    ram(3776) <= X"20";
    ram(3777) <= X"20";
    ram(3778) <= X"59";
    ram(3779) <= X"20";
    ram(3780) <= X"20";
    ram(3781) <= X"5a";
    ram(3782) <= X"20";
    ram(3783) <= X"20";
    ram(3784) <= X"42";
    ram(3785) <= X"20";
    ram(3786) <= X"20";
    ram(3787) <= X"53";
    ram(3788) <= X"50";
    ram(3789) <= X"20";
    ram(3790) <= X"20";
    ram(3791) <= X"20";
    ram(3792) <= X"4d";
    ram(3793) <= X"41";
    ram(3794) <= X"50";
    ram(3795) <= X"48";
    ram(3796) <= X"20";
    ram(3797) <= X"4d";
    ram(3798) <= X"41";
    ram(3799) <= X"50";
    ram(3800) <= X"4c";
    ram(3801) <= X"20";
    ram(3802) <= X"4c";
    ram(3803) <= X"41";
    ram(3804) <= X"53";
    ram(3805) <= X"54";
    ram(3806) <= X"2d";
    ram(3807) <= X"4f";
    ram(3808) <= X"50";
    ram(3809) <= X"20";
    ram(3810) <= X"49";
    ram(3811) <= X"6e";
    ram(3812) <= X"20";
    ram(3813) <= X"20";
    ram(3814) <= X"20";
    ram(3815) <= X"20";
    ram(3816) <= X"20";
    ram(3817) <= X"50";
    ram(3818) <= X"20";
    ram(3819) <= X"20";
    ram(3820) <= X"50";
    ram(3821) <= X"2d";
    ram(3822) <= X"46";
    ram(3823) <= X"4c";
    ram(3824) <= X"41";
    ram(3825) <= X"47";
    ram(3826) <= X"53";
    ram(3827) <= X"20";
    ram(3828) <= X"20";
    ram(3829) <= X"20";
    ram(3830) <= X"52";
    ram(3831) <= X"47";
    ram(3832) <= X"50";
    ram(3833) <= X"20";
    ram(3834) <= X"75";
    ram(3835) <= X"53";
    ram(3836) <= X"20";
    ram(3837) <= X"49";
    ram(3838) <= X"4f";
    ram(3839) <= X"20";
    ram(3840) <= X"77";
    ram(3841) <= X"73";
    ram(3842) <= X"20";
    ram(3843) <= X"68";
    ram(3844) <= X"20";
    ram(3845) <= X"52";
    ram(3846) <= X"45";
    ram(3847) <= X"43";
    ram(3848) <= X"41";
    ram(3849) <= X"38";
    ram(3850) <= X"4c";
    ram(3851) <= X"48";
    ram(3852) <= X"43";
    ram(3853) <= X"0d";
    ram(3854) <= X"0a";
    ram(3855) <= X"00";
    ram(3856) <= X"06";
    ram(3857) <= X"05";
    ram(3858) <= X"81";
    ram(3859) <= X"82";
    ram(3860) <= X"83";
    ram(3861) <= X"84";
    ram(3862) <= X"8a";
    ram(3863) <= X"8c";
    ram(3864) <= X"0b";
    ram(3865) <= X"90";
    ram(3866) <= X"11";
    ram(3867) <= X"8d";
    ram(3868) <= X"0e";
    ram(3869) <= X"a1";
    ram(3870) <= X"15";
    ram(3871) <= X"27";
    ram(3872) <= X"80";
    ram(3873) <= X"a3";
    ram(3874) <= X"a4";
    ram(3875) <= X"88";
    ram(3876) <= X"a2";
    ram(3877) <= X"89";
    ram(3878) <= X"a5";
    ram(3879) <= X"26";
    ram(3880) <= X"20";
    ram(3881) <= X"0d";
    ram(3882) <= X"0a";
    ram(3883) <= X"42";
    ram(3884) <= X"61";
    ram(3885) <= X"64";
    ram(3886) <= X"20";
    ram(3887) <= X"62";
    ram(3888) <= X"69";
    ram(3889) <= X"74";
    ram(3890) <= X"20";
    ram(3891) <= X"72";
    ram(3892) <= X"61";
    ram(3893) <= X"74";
    ram(3894) <= X"65";
    ram(3895) <= X"20";
    ram(3896) <= X"64";
    ram(3897) <= X"69";
    ram(3898) <= X"76";
    ram(3899) <= X"69";
    ram(3900) <= X"73";
    ram(3901) <= X"6f";
    ram(3902) <= X"72";
    ram(3903) <= X"0d";
    ram(3904) <= X"0a";
    ram(3905) <= X"00";
    ram(3906) <= X"0d";
    ram(3907) <= X"0a";
    ram(3908) <= X"53";
    ram(3909) <= X"65";
    ram(3910) <= X"74";
    ram(3911) <= X"20";
    ram(3912) <= X"50";
    ram(3913) <= X"43";
    ram(3914) <= X"20";
    ram(3915) <= X"74";
    ram(3916) <= X"69";
    ram(3917) <= X"6d";
    ram(3918) <= X"65";
    ram(3919) <= X"6f";
    ram(3920) <= X"75";
    ram(3921) <= X"74";
    ram(3922) <= X"0d";
    ram(3923) <= X"0a";
    ram(3924) <= X"00";
    ram(3925) <= X"0d";
    ram(3926) <= X"0a";
    ram(3927) <= X"52";
    ram(3928) <= X"65";
    ram(3929) <= X"61";
    ram(3930) <= X"64";
    ram(3931) <= X"20";
    ram(3932) <= X"74";
    ram(3933) <= X"69";
    ram(3934) <= X"6d";
    ram(3935) <= X"65";
    ram(3936) <= X"6f";
    ram(3937) <= X"75";
    ram(3938) <= X"74";
    ram(3939) <= X"0d";
    ram(3940) <= X"0a";
    ram(3941) <= X"00";
    ram(3942) <= X"0d";
    ram(3943) <= X"0a";
    ram(3944) <= X"57";
    ram(3945) <= X"72";
    ram(3946) <= X"69";
    ram(3947) <= X"74";
    ram(3948) <= X"65";
    ram(3949) <= X"20";
    ram(3950) <= X"74";
    ram(3951) <= X"69";
    ram(3952) <= X"6d";
    ram(3953) <= X"65";
    ram(3954) <= X"6f";
    ram(3955) <= X"75";
    ram(3956) <= X"74";
    ram(3957) <= X"0d";
    ram(3958) <= X"0a";
    ram(3959) <= X"00";
    ram(3960) <= X"0d";
    ram(3961) <= X"0a";
    ram(3962) <= X"41";
    ram(3963) <= X"64";
    ram(3964) <= X"64";
    ram(3965) <= X"72";
    ram(3966) <= X"65";
    ram(3967) <= X"73";
    ram(3968) <= X"73";
    ram(3969) <= X"20";
    ram(3970) <= X"70";
    ram(3971) <= X"61";
    ram(3972) <= X"72";
    ram(3973) <= X"73";
    ram(3974) <= X"65";
    ram(3975) <= X"20";
    ram(3976) <= X"65";
    ram(3977) <= X"72";
    ram(3978) <= X"72";
    ram(3979) <= X"6f";
    ram(3980) <= X"72";
    ram(3981) <= X"0d";
    ram(3982) <= X"0a";
    ram(3983) <= X"00";
    ram(3984) <= X"0d";
    ram(3985) <= X"0a";
    ram(3986) <= X"42";
    ram(3987) <= X"61";
    ram(3988) <= X"64";
    ram(3989) <= X"20";
    ram(3990) <= X"69";
    ram(3991) <= X"6e";
    ram(3992) <= X"64";
    ram(3993) <= X"65";
    ram(3994) <= X"78";
    ram(3995) <= X"20";
    ram(3996) <= X"28";
    ram(3997) <= X"6d";
    ram(3998) <= X"75";
    ram(3999) <= X"73";
    ram(4000) <= X"74";
    ram(4001) <= X"20";
    ram(4002) <= X"62";
    ram(4003) <= X"65";
    ram(4004) <= X"20";
    ram(4005) <= X"30";
    ram(4006) <= X"2d";
    ram(4007) <= X"31";
    ram(4008) <= X"30";
    ram(4009) <= X"32";
    ram(4010) <= X"33";
    ram(4011) <= X"29";
    ram(4012) <= X"0d";
    ram(4013) <= X"0a";
    ram(4014) <= X"00";
    ram(4015) <= X"0d";
    ram(4016) <= X"0a";
    ram(4017) <= X"42";
    ram(4018) <= X"61";
    ram(4019) <= X"64";
    ram(4020) <= X"20";
    ram(4021) <= X"66";
    ram(4022) <= X"6c";
    ram(4023) <= X"61";
    ram(4024) <= X"67";
    ram(4025) <= X"20";
    ram(4026) <= X"6d";
    ram(4027) <= X"61";
    ram(4028) <= X"73";
    ram(4029) <= X"6b";
    ram(4030) <= X"0d";
    ram(4031) <= X"0a";
    ram(4032) <= X"00";
    ram(4033) <= X"0d";
    ram(4034) <= X"0a";
    ram(4035) <= X"42";
    ram(4036) <= X"61";
    ram(4037) <= X"64";
    ram(4038) <= X"20";
    ram(4039) <= X"66";
    ram(4040) <= X"69";
    ram(4041) <= X"6c";
    ram(4042) <= X"6c";
    ram(4043) <= X"20";
    ram(4044) <= X"76";
    ram(4045) <= X"61";
    ram(4046) <= X"6c";
    ram(4047) <= X"75";
    ram(4048) <= X"65";
    ram(4049) <= X"0d";
    ram(4050) <= X"0a";
    ram(4051) <= X"00";
    ram(4052) <= X"40";
    ram(4053) <= X"40";
    ram(4054) <= X"00";
    ram(4055) <= X"00";
    ram(4056) <= X"00";
    ram(4057) <= X"00";
    ram(4058) <= X"00";
    ram(4059) <= X"00";
    ram(4060) <= X"00";
    ram(4061) <= X"00";
    ram(4062) <= X"00";
    ram(4063) <= X"00";
    ram(4064) <= X"00";
    ram(4065) <= X"00";
    ram(4066) <= X"00";
    ram(4067) <= X"00";
    ram(4068) <= X"00";
    ram(4069) <= X"00";
    ram(4070) <= X"00";
    ram(4071) <= X"00";
    ram(4072) <= X"00";
    ram(4073) <= X"00";
    ram(4074) <= X"00";
    ram(4075) <= X"00";
    ram(4076) <= X"00";
    ram(4077) <= X"00";
    ram(4078) <= X"00";
    ram(4079) <= X"00";
    ram(4080) <= X"00";
    ram(4081) <= X"00";
    ram(4082) <= X"00";
    ram(4083) <= X"00";
    ram(4084) <= X"00";
    ram(4085) <= X"00";
    ram(4086) <= X"00";
    ram(4087) <= X"00";
    ram(4088) <= X"00";
    ram(4089) <= X"00";
    ram(4090) <= X"d4";
    ram(4091) <= X"ff";
    ram(4092) <= X"00";
    ram(4093) <= X"f2";
    ram(4094) <= X"d5";
    ram(4095) <= X"ff";
    wait;
  end process;
  
  -- Generated from always process in monitormem (monitor/monitor_mem.v:527)
  process is
  begin
    wait until rising_edge(clk);
    if we = '1' then
      ram(To_Integer(Resize(addr, 14))) <= di;
    end if;
    wait for 0 ns;  -- Read target of blocking assignment (monitor/monitor_mem.v:531)
    do_Reg <= ram(To_Integer(Resize(addr, 14)));
  end process;
end architecture;

