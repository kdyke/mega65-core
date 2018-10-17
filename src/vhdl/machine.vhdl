--
-- Written by
--    Paul Gardner-Stephen <hld@c64.org>  2013-2014
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:37 12/10/2013 
-- Design Name: 
-- Module Name:    container - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.victypes.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity machine is
  generic (cpufrequency : integer := 50);
  Port ( pixelclock : in STD_LOGIC;
         cpuclock : in std_logic;
         clock50mhz : in std_logic;
         clock30 : in std_logic;
         clock33 : in std_logic;
         clock40 : in std_logic;
         clock200 : in std_logic;
         ioclock : std_logic;
         uartclock : std_logic;
         btnCpuReset : in  STD_LOGIC;
         reset_out : out std_logic;
         irq : in  STD_LOGIC;
         nmi : in  STD_LOGIC;
         restore_key : in std_logic;
         cpu_exrom : in std_logic;
         cpu_game : in std_logic;

         no_kickstart : in std_logic;
         
         flopled : out std_logic;
         flopmotor : out std_logic;

         buffereduart_rx : in std_logic;
         buffereduart_tx : out std_logic := '1';
         buffereduart_ringindicate : in std_logic;
         buffereduart2_rx : in std_logic;
         buffereduart2_tx : out std_logic := '1';
         
         slow_access_rdata : in unsigned(7 downto 0);
         slow_access_ready : in std_logic := '0';

         slow_access_request : out std_logic := '0';         
         slow_access_write : out std_logic := '0';         
         slow_access_address : out unsigned(19 downto 0);
         slow_access_wdata : out unsigned(7 downto 0);
         cart_access_count : in unsigned(7 downto 0) := x"00";

         sector_buffer_mapped : inout std_logic;
         
         ----------------------------------------------------------------------
         -- VGA output
         ----------------------------------------------------------------------
         vsync : out  STD_LOGIC;
         hsync : out  STD_LOGIC;
         lcd_hsync : out std_logic;
         lcd_vsync : out std_logic;
         lcd_display_enable : out std_logic;
         lcd_pixel_strobe : out std_logic;
         vgared : out  UNSIGNED (7 downto 0);
         vgagreen : out  UNSIGNED (7 downto 0);
         vgablue : out  UNSIGNED (7 downto 0);
         hdmi_scl : inout std_logic := '1';
         hdmi_sda : inout std_logic := 'Z';

         -------------------------------------------------------------------------
         -- CIA1 ports for keyboard and joysticks
         -------------------------------------------------------------------------
         porta_pins : inout  std_logic_vector(7 downto 0);
         portb_pins : inout  std_logic_vector(7 downto 0);
         keyleft : in std_logic;
         keyup : in std_logic;
         keyboard_column8 : out std_logic;
         caps_lock_key : in std_logic;
         fa_left : in std_logic;
         fa_right : in std_logic;
         fa_up : in std_logic;
         fa_down : in std_logic;
         fa_fire : in std_logic;
         fb_left : in std_logic;
         fb_right : in std_logic;
         fb_up : in std_logic;
         fb_down : in std_logic;
         fb_fire : in std_logic;
         fa_potx : in std_logic;
         fa_poty : in std_logic;
         fb_potx : in std_logic;
         fb_poty : in std_logic;
         pot_drain : buffer std_logic;
         pot_via_iec : buffer std_logic;
         
         ----------------------------------------------------------------------
         -- CBM floppy serial port
         ----------------------------------------------------------------------
         iec_clk_en : out std_logic;
         iec_data_en : out std_logic;
         iec_data_o : out std_logic;
         iec_reset : out std_logic;
         iec_clk_o : out std_logic;
         iec_atn_o : out std_logic;
         iec_data_external : in std_logic;
         iec_clk_external : in std_logic;
         
         -------------------------------------------------------------------------
         -- Lines for the SDcard interface itself
         -------------------------------------------------------------------------
         cs_bo : out std_logic;
         sclk_o : out std_logic;
         mosi_o : out std_logic;
         miso_i : in  std_logic;

         ----------------------------------------------------------------------
         -- Floppy drive interface
         ----------------------------------------------------------------------
         f_density : out std_logic := '1';
         f_motor : out std_logic := '1';
         f_select : out std_logic := '1';
         f_stepdir : out std_logic := '1';
         f_step : out std_logic := '1';
         f_wdata : out std_logic := '1';
         f_wgate : out std_logic := '1';
         f_side1 : out std_logic := '1';
         f_index : in std_logic;
         f_track0 : in std_logic;
         f_writeprotect : in std_logic;
         f_rdata : in std_logic;
         f_diskchanged : in std_logic;

         
         ---------------------------------------------------------------------------
         -- Lines for other devices that we handle here
         ---------------------------------------------------------------------------
         aclMISO : in std_logic;
         aclMOSI : out std_logic;
         aclSS : out std_logic;
         aclSCK : out std_logic;
         aclInt1 : in std_logic;
         aclInt2 : in std_logic;
         
         ampPWM_l : out std_logic;
         ampPWM_r : out std_logic;
         ampSD : out std_logic;

         micData0 : in std_logic;
         micData1 : in std_logic;
         micClk : out std_logic;
         micLRSel : out std_logic;

         -- I2S audio channels
         i2s_master_clk : out std_logic := '0';
         i2s_master_sync : out std_logic := '0';
         i2s_slave_clk : in std_logic := '0';
         i2s_slave_sync : in std_logic := '0';
         pcm_modem_clk : out std_logic := '0';
         pcm_modem_sync : out std_logic := '0';
         pcm_modem_clk_in : in std_logic := '0';
         pcm_modem_sync_in : in std_logic := '0';
         i2s_headphones_data_out : out std_logic := '0';
         i2s_headphones_data_in : in std_logic := '0';
         i2s_speaker_data_out : out std_logic := '0';
         pcm_modem1_data_in : in std_logic := '0';
         pcm_modem2_data_in : in std_logic := '0';
         pcm_modem1_data_out : out std_logic := '0';
         pcm_modem2_data_out : out std_logic := '0';
         i2s_bt_data_in : in std_logic := '0';
         i2s_bt_data_out : out std_logic := '0';    
         
         tmpSDA : inout std_logic;
         tmpSCL : inout std_logic;
         tmpInt : in std_logic;
         tmpCT : in std_logic;

         i2c1SDA : inout std_logic;
         i2c1SCL : inout std_logic;

         lcdpwm : inout std_logic := '1';
         touchSDA : inout std_logic := '1';
         touchSCL : inout std_logic := '1';
         
         ---------------------------------------------------------------------------
         -- IO lines to the ethernet controller
         ---------------------------------------------------------------------------
         eth_mdio : inout std_logic;
         eth_mdc : out std_logic;
         eth_reset : out std_logic;
         eth_rxd : in unsigned(1 downto 0);
         eth_txd : out unsigned(1 downto 0);
         eth_txen : out std_logic;
         eth_rxdv : in std_logic;
         eth_rxer : in std_logic;
         eth_interrupt : in std_logic;
         
         fpga_temperature : in std_logic_vector(11 downto 0);
         
         ----------------------------------------------------------------------
         -- PS/2 adapted USB keyboard & joystick connector.
         -- (For using a keyrah adapter to connect to the keyboard.)
         ----------------------------------------------------------------------
         ps2data : in std_logic;
         ps2clock : in std_logic;

         ----------------------------------------------------------------------
         -- PMOD interface for keyboard, joystick, expansion port etc board.
         ----------------------------------------------------------------------
         pmod_clock : in std_logic;
         pmod_start_of_sequence : in std_logic;
         pmod_data_in : in std_logic_vector(3 downto 0);
         pmod_data_out : out std_logic_vector(1 downto 0);
         pmoda : inout std_logic_vector(7 downto 0);

         uart_rx : inout std_logic;
         uart_tx : out std_logic;
                  
         ----------------------------------------------------------------------
         -- Debug interfaces on Nexys4 board
         ----------------------------------------------------------------------
         led : out std_logic_vector(15 downto 0);
         sw : in std_logic_vector(15 downto 0);
         btn : in std_logic_vector(4 downto 0);

         UART_TXD : out std_logic;
         RsRx : in std_logic;
         
         sseg_ca : out std_logic_vector(7 downto 0);
         sseg_an : out std_logic_vector(7 downto 0)
         );
end machine;

architecture Behavioral of machine is

  attribute keep : string;
  attribute keep_hierarchy : string;
  attribute mark_debug : string;
  attribute dont_touch : string;

  component uart_monitor is
    port (
      reset : in std_logic;
      reset_out : out std_logic := '1';
      monitor_hyper_trap : out std_logic := '1';
      clock : in std_logic;
      tx : out std_logic;
      rx : in  std_logic;
      bit_rate_divisor : out unsigned(15 downto 0);
      activity : out std_logic;

      protected_hardware_in : in unsigned(7 downto 0);
      uart_char : in unsigned(7 downto 0);
      uart_char_valid : in std_logic;

      monitor_char_out : out unsigned(7 downto 0);
      monitor_char_valid : out std_logic;
      terminal_emulator_ready : in std_logic;
      terminal_emulator_ack : in std_logic;
  
      key_scancode : out unsigned(15 downto 0);
      key_scancode_toggle : out std_logic;

      force_single_step : in std_logic;
  
      fastio_read : in std_logic;
      fastio_write : in std_logic;
  
      monitor_proceed : in std_logic;
      monitor_waitstates : in unsigned(7 downto 0);
      monitor_request_reflected : in std_logic;
      monitor_pc : in unsigned(15 downto 0);
      monitor_cpu_state : in unsigned(15 downto 0);
      monitor_hypervisor_mode : in std_logic;
      monitor_instruction : in unsigned(7 downto 0);
      monitor_watch : out unsigned(23 downto 0) := x"7FFFFF";
      monitor_watch_match : in std_logic;
      monitor_opcode : in unsigned(7 downto 0);
      monitor_ibytes : in std_logic_vector(3 downto 0);
      monitor_arg1 : in unsigned(7 downto 0);
      monitor_arg2 : in unsigned(7 downto 0);
      monitor_memory_access_address : in unsigned(31 downto 0);
      monitor_roms : in std_logic_vector(7 downto 0);
      
      monitor_a : in unsigned(7 downto 0);
      monitor_x : in unsigned(7 downto 0);
      monitor_y : in unsigned(7 downto 0);
      monitor_z : in unsigned(7 downto 0);
      monitor_b : in unsigned(7 downto 0);
      monitor_sp : in unsigned(15 downto 0);
      monitor_p : in unsigned(7 downto 0);
      monitor_map_offset_low : in unsigned(11 downto 0);
      monitor_map_offset_high : in unsigned(11 downto 0);
      monitor_map_enables_low : in std_logic_vector(3 downto 0);
      monitor_map_enables_high : in std_logic_vector(3 downto 0);
      monitor_interrupt_inhibit : in std_logic;

      monitor_char : in unsigned(7 downto 0);
      monitor_char_toggle : in std_logic;
      monitor_char_busy : out std_logic;
      
      monitor_mem_address : out unsigned(23 downto 0);
      monitor_mem_rdata : in unsigned(7 downto 0);
      monitor_mem_wdata : out unsigned(7 downto 0);
      monitor_mem_attention_request : out std_logic := '0';
      monitor_mem_attention_granted : in std_logic;
      monitor_mem_read : out std_logic := '0';
      monitor_mem_write : out std_logic := '0';
      monitor_mem_setpc : out std_logic := '0';
      monitor_irq_inhibit : out std_logic := '0';
      monitor_mem_stage_trace_mode : out std_logic := '0';
      monitor_mem_trace_mode : out std_logic := '0';
      monitor_mem_trace_toggle : out std_logic := '0'
      );
  end component;

  signal pmodb_in_buffer : std_logic_vector(5 downto 0);
  signal pmodb_out_buffer : std_logic_vector(1 downto 0);

  signal fa_up_out : std_logic;
  signal fa_down_out : std_logic;
  signal fa_left_out : std_logic;
  signal fa_right_out : std_logic;
  signal fb_up_out : std_logic;
  signal fb_down_out : std_logic;
  signal fb_left_out : std_logic;
  signal fb_right_out : std_logic;
  
  signal key_scancode : unsigned(15 downto 0);
  signal key_scancode_toggle : std_logic;

  signal xray_mode : std_logic;
  
  signal cpu_hypervisor_mode : std_logic;

  signal reg_isr_out : unsigned(7 downto 0);
  signal imask_ta_out : std_logic;
  
  signal cpu_leds : std_logic_vector(3 downto 0);
  
  signal viciii_iomode : std_logic_vector(1 downto 0);

  signal iomode_set : std_logic_vector(1 downto 0);
  signal iomode_set_toggle : std_logic;

  signal vicii_2mhz : std_logic;
  signal viciii_fast : std_logic;
  signal viciv_fast : std_logic;
  signal speed_gate : std_logic;
  signal speed_gate_enable : std_logic;
  
  signal drive_led : std_logic;
  signal motor : std_logic;
  signal drive_led_out : std_logic;
  
  signal seg_led_data : unsigned(31 downto 0);

  signal reset_io : std_logic;
  signal reset_monitor : std_logic;
  -- Holds reset on for 8 cycles so that reset line entry is used on start up,
  -- instead of implicit startup state.
  -- (Note that uart_monitor actually holds reset low for ~5 usec on power on,
  --  i.e., for much longer than this here provides).
  signal power_on_reset : std_logic_vector(7 downto 0) := (others => '0');
  signal reset_combined : std_logic := '1';
  
  signal io_irq : std_logic;
  signal io_nmi : std_logic;
  signal vic_irq : std_logic;
  signal combinedirq : std_logic;
  signal combinednmi : std_logic;
  signal restore_nmi : std_logic;
  signal hyper_trap : std_logic := '1';
  signal hyper_trap_combined : std_logic := '1';
  signal monitor_hyper_trap : std_logic := '1';
  signal hyper_trap_f011_read : std_logic := '0';
  signal hyper_trap_f011_write : std_logic := '0';

  signal io_rdata : std_logic_vector(7 downto 0);

  signal io_sel_next : std_logic;
  signal ext_sel_next : std_logic;
  signal io_sel : std_logic;
  signal vic_cs : std_logic;
  signal io_ready : std_logic;

  signal dmagic_cs_next : std_logic;
  signal dmagic_io_ready : std_logic;
  signal dmagic_rdata : std_logic_vector(7 downto 0)  := (others => '0');
  
  signal system_address_next : std_logic_vector(19 downto 0);
  signal system_write_next : std_logic;
  signal system_read_next : std_logic;
  signal system_wdata_next : std_logic_vector(7 downto 0)  := (others => '0');

  signal system_address : std_logic_vector(19 downto 0);
  signal system_write : std_logic;
  signal system_read : std_logic;
  signal system_wdata : std_logic_vector(7 downto 0)  := (others => '0');
  
  signal shadow_write_next : std_logic := '0';
  signal shadow_rdata : std_logic_vector(7 downto 0)  := (others => '0');

  --signal kickstart_address_next : std_logic_vector(13 downto 0);
  signal kickstart_cs_next : std_logic := '0';
  signal kickstart_rdata : std_logic_vector(7 downto 0) := (others => '0');
  
  signal vic_rdata : std_logic_vector(7 downto 0);
  signal vic_ready : std_logic;
  
  signal colour_ram_fastio_rdata : std_logic_vector(7 downto 0);

  --signal chipram_we : STD_LOGIC;
  signal chipram_address : unsigned(19 DOWNTO 0);
  signal chipram_data : unsigned(7 DOWNTO 0);
  
  signal rom_at_e000 : std_logic := '0';
  signal rom_at_c000 : std_logic := '0';
  signal rom_at_a000 : std_logic := '0';
  signal rom_at_8000 : std_logic := '0';

  signal colourram_at_dc00 : std_logic := '0';
  signal colour_ram_cs_next : std_logic := '0';
  signal charrom_write_cs_next : std_logic := '0';

  signal monitor_pc : unsigned(15 downto 0);
  signal monitor_hypervisor_mode : std_logic;
  signal monitor_state : unsigned(15 downto 0);
  signal monitor_instruction : unsigned(7 downto 0);
  signal monitor_instructionpc : unsigned(15 downto 0);
  signal monitor_watch : unsigned(23 downto 0);
--  signal monitor_debug_memory_access : std_logic_vector(31 downto 0);
  signal monitor_proceed : std_logic;
  signal monitor_waitstates : unsigned(7 downto 0);
  signal monitor_request_reflected : std_logic;
  signal monitor_watch_match : std_logic;
  signal monitor_mem_address : unsigned(23 downto 0);
  signal monitor_mem_rdata : unsigned(7 downto 0);
  signal monitor_mem_wdata : unsigned(7 downto 0);
  signal monitor_map_offset_low : unsigned(11 downto 0);
  signal monitor_map_offset_high : unsigned(11 downto 0);
  signal monitor_map_enables_low : std_logic_vector(3 downto 0);
  signal monitor_map_enables_high : std_logic_vector(3 downto 0);   
  signal monitor_mem_read : std_logic;
  signal monitor_mem_write : std_logic;
  signal monitor_mem_setpc : std_logic;
  signal monitor_mem_attention_request : std_logic;
  signal monitor_mem_attention_granted : std_logic;
  signal monitor_mem_stage_trace_mode : std_logic;
  signal monitor_irq_inhibit : std_logic;
  signal monitor_mem_trace_mode : std_logic;
  signal monitor_mem_trace_toggle : std_logic;
  signal monitor_memory_access_address : unsigned(31 downto 0);
  signal monitor_char : unsigned(7 downto 0);
  signal monitor_char_toggle : std_logic;
  signal monitor_char_busy : std_logic;
  signal monitor_cpuport : std_logic_vector(2 downto 0);
  signal monitor_roms : std_logic_vector(7 downto 0);
  
  signal monitor_a : unsigned(7 downto 0);
  signal monitor_b : unsigned(7 downto 0);
  signal monitor_interrupt_inhibit : std_logic;
  signal monitor_x : unsigned(7 downto 0);
  signal monitor_y : unsigned(7 downto 0);
  signal monitor_z : unsigned(7 downto 0);
  signal monitor_sp : unsigned(15 downto 0);
  signal monitor_p : unsigned(7 downto 0);
  signal monitor_opcode : unsigned(7 downto 0);
  signal monitor_ibytes : std_logic_vector(3 downto 0);
  signal monitor_arg1 : unsigned(7 downto 0);
  signal monitor_arg2 : unsigned(7 downto 0);

  signal cpuis6502 : std_logic;
  signal cpuspeed : unsigned(7 downto 0);

  signal segled_counter : unsigned(19 downto 0) := (others => '0');

  signal phi0 : std_logic := '0';

  signal pixel_stream : unsigned (7 downto 0);
  signal pixel_red : unsigned (7 downto 0);
  signal pixel_green : unsigned (7 downto 0);
  signal pixel_blue : unsigned (7 downto 0);
  signal pixel_y : unsigned (11 downto 0);
  signal pixel_valid : std_logic;  -- 0-639 across physical display for visual
                                   -- keyboard
  signal pixel_strobe : std_logic;  -- 0-799 across physical display for framepacker
  signal pixel_newframe : std_logic;
  signal pixel_newraster : std_logic;
  signal native_x_640 : integer;
  signal native_y_200 : integer;
  signal native_y_400 : integer;
  signal pixel_x_640 : integer;
  signal pixel_y_scale_200 : unsigned(3 downto 0);
  signal pixel_y_scale_400 : unsigned(3 downto 0);

  signal uart_tx_buffer : std_logic; 
  signal uart_rx_buffer : std_logic;
  signal protected_hardware_sig : unsigned(7 downto 0);
  signal virtualised_hardware_sig : unsigned(7 downto 0);
  signal chipselect_enables : std_logic_vector(7 downto 0);

  -- Matrix Mode signals
  signal scancode_out : std_logic_vector(12 downto 0); 
  signal mm_displayMode : unsigned(1 downto 0):=b"10"; 
  signal bit_rate_divisor : unsigned(15 downto 0);

  signal matrix_fetch_address : unsigned(11 downto 0) := to_unsigned(0,12);
  signal matrix_rdata : unsigned(7 downto 0);

  signal lcd_hsync1 : std_logic := '0';
  signal lcd_vsync1 : std_logic := '0';
  signal hsync_drive1 : std_logic := '0';
  signal vsync_drive1 : std_logic := '0';
  signal lcd_pixel_strobe1 : std_logic := '0';
  signal lcd_display_enable1 : std_logic := '0';

  signal hsync_pal50 : std_logic;
  signal vsync_pal50 : std_logic;
  signal inframe_pal50 : std_logic;
  signal lcd_vsync_pal50 : std_logic;
  signal lcd_inframe_pal50 : std_logic;
  signal x_zero_pal50 : std_logic := '0';
  signal y_zero_pal50 : std_logic := '0';

  signal hsync_ntsc60 : std_logic;
  signal vsync_ntsc60 : std_logic;
  signal inframe_ntsc60 : std_logic;  
  signal lcd_vsync_ntsc60 : std_logic;
  signal lcd_inframe_ntsc60 : std_logic;  
  signal x_zero_ntsc60 : std_logic := '0';
  signal y_zero_ntsc60 : std_logic := '0';

  signal external_frame_x_zero : std_logic := '0';
  signal external_frame_y_zero : std_logic := '0';
  
  signal red_n : unsigned(7 downto 0);
  signal green_n : unsigned(7 downto 0);
  signal blue_n : unsigned(7 downto 0);

  signal vgablue_viciv4 : unsigned(7 downto 0);
  signal vgared_viciv4 : unsigned(7 downto 0);
  signal vgagreen_viciv4 : unsigned(7 downto 0);
  signal vgablue_viciv3 : unsigned(7 downto 0);
  signal vgared_viciv3 : unsigned(7 downto 0);
  signal vgagreen_viciv3 : unsigned(7 downto 0);
  signal vgablue_viciv2 : unsigned(7 downto 0);
  signal vgared_viciv2 : unsigned(7 downto 0);
  signal vgagreen_viciv2 : unsigned(7 downto 0);
  
  signal vgablue_viciv : unsigned(7 downto 0);
  signal vgared_viciv : unsigned(7 downto 0);
  signal vgagreen_viciv : unsigned(7 downto 0);
  signal vgablue_source : unsigned(7 downto 0);
  signal vgared_source : unsigned(7 downto 0);
  signal vgagreen_source : unsigned(7 downto 0);
  signal vgablue_sig : unsigned(7 downto 0);
  signal vgared_sig : unsigned(7 downto 0);
  signal vgagreen_sig : unsigned(7 downto 0);
  signal vgablue_kbd : unsigned(7 downto 0);
  signal vgared_kbd : unsigned(7 downto 0);
  signal vgagreen_kbd : unsigned(7 downto 0);
  signal vgablue_out : unsigned(7 downto 0);
  signal vgared_out : unsigned(7 downto 0);
  signal vgagreen_out : unsigned(7 downto 0);
  signal viciv_outofframe_viciv : std_logic := '0';
  signal viciv_outofframe : std_logic := '0';
  signal viciv_outofframe_1 : std_logic := '0';
  signal viciv_outofframe_2 : std_logic := '0';
  signal viciv_outofframe_3 : std_logic := '0';
  
  signal xcounter : unsigned(13 downto 0);
  signal ycounter : unsigned(11 downto 0); 
  signal uart_txd_sig : std_logic;
  signal display_shift : std_logic_vector(2 downto 0) := "000";
  signal shift_ready : std_logic := '0';
  signal shift_ack : std_logic := '0'; 
  signal matrix_trap : std_logic;  
  signal uart_char : unsigned(7 downto 0);
  signal uart_char_valid : std_logic := '0';
  signal uart_monitor_char : unsigned(7 downto 0);
  signal uart_monitor_char_valid : std_logic := '0';
  signal monitor_char_out : unsigned(7 downto 0);
  signal monitor_char_out_valid : std_logic := '0';
  signal terminal_emulator_ready : std_logic := '0';
  signal terminal_emulator_ack : std_logic := '0';

  signal visual_keyboard_enable : std_logic;
  signal zoom_en_osk : std_logic;
  signal zoom_en_always : std_logic;
  signal keyboard_at_top : std_logic;
  signal alternate_keyboard : std_logic;
  signal osk_x : unsigned(11 downto 0);
  signal osk_y : unsigned(11 downto 0);
  signal osk_key1 : unsigned(7 downto 0);
  signal osk_key2 : unsigned(7 downto 0);
  signal osk_key3 : unsigned(7 downto 0);
  signal osk_key4 : unsigned(7 downto 0);
  
  signal osk_touch1_valid : std_logic := '0';
  signal osk_touch1_x : unsigned(13 downto 0) := to_unsigned(0,14);
  signal osk_touch1_y : unsigned(11 downto 0) := to_unsigned(0,12);
  signal osk_touch1_key : unsigned(7 downto 0) := x"FF";
  signal osk_touch2_valid : std_logic := '0';
  signal osk_touch2_x : unsigned(13 downto 0) := to_unsigned(0,14);
  signal osk_touch2_y : unsigned(11 downto 0) := to_unsigned(0,12);
  signal osk_touch2_key : unsigned(7 downto 0) := x"FF";

  signal secure_mode_flag : std_logic := '0';
  signal matrix_rain_seed : unsigned(15 downto 0);
  signal hsync_drive : std_logic := '0';
  signal vsync_drive : std_logic := '0';
  
  signal all_pause : std_logic := '0';

  signal dat_offset : unsigned(15 downto 0);
  signal dat_bitplane_addresses : sprite_vector_eight;  

  signal pota_x : unsigned(7 downto 0);
  signal pota_y : unsigned(7 downto 0);
  signal potb_x : unsigned(7 downto 0);
  signal potb_y : unsigned(7 downto 0);
  
  signal mouse_debug : unsigned(7 downto 0);
  signal amiga_mouse_enable_a : std_logic;
  signal amiga_mouse_enable_b : std_logic;
  signal amiga_mouse_assume_a : std_logic;
  signal amiga_mouse_assume_b : std_logic;

  -- local debug signals from CPU
  signal system_address_state_dbg_out : std_logic_vector(3 downto 0);
  signal pixelclock_select : std_logic_vector(7 downto 0);
  
  -- New CPU bus interface signals (CPU to arbiter and address resolver)
  signal cpu_memory_access_address_next : unsigned(19 downto 0);
  signal cpu_memory_access_read_next : std_logic;
  signal cpu_memory_access_write_next : std_logic;
  signal cpu_memory_access_resolve_address_next : std_logic;
  signal cpu_memory_access_wdata_next : unsigned(7 downto 0);
  signal cpu_memory_access_io_next : std_logic;
  signal cpu_ack : std_logic;
  signal cpu_read_data : unsigned(7 downto 0);
  signal cpu_ready : std_logic;
  signal cpu_map_en_next : std_logic;

  -- Signals between DMAgic and bus arbiter
  signal dmagic_memory_access_address_next : std_logic_vector(19 downto 0);
  signal dmagic_memory_access_read_next : std_logic;
  signal dmagic_memory_access_write_next : std_logic;
  signal dmagic_memory_access_resolve_address_next : std_logic;
  signal dmagic_memory_access_wdata_next : unsigned(7 downto 0);
  signal dmagic_memory_access_io_next : std_logic;
  signal dmagic_memory_access_ext_next : std_logic;
  signal dmagic_ack : std_logic;
  signal dmagic_read_data : unsigned(7 downto 0);
  signal dmagic_ready : std_logic;
  signal dmagic_dma_req : std_logic;
  signal dmagic_cpu_req : std_logic;

  -- Signals between bus arbiter and bus interface
  signal bus_memory_access_address_next : std_logic_vector(19 downto 0);
  signal bus_memory_access_read_next : std_logic;
  signal bus_memory_access_write_next : std_logic;
  signal bus_memory_access_resolve_address_next : std_logic;
  signal bus_memory_access_wdata_next : unsigned(7 downto 0);
  signal bus_memory_access_io_next : std_logic;
  signal bus_memory_access_ext_next : std_logic;
  signal bus_ack : std_logic;
  signal bus_read_data : unsigned(7 downto 0);
  signal bus_ready : std_logic;

  signal rom_writeprotect : std_logic; -- TEMP
  signal cpuport_ddr : unsigned(7 downto 0); -- FIXME, we don't really need both of these.
  signal cpuport_value : unsigned(7 downto 0);
  
  signal cpu_resolved_memory_access_address_next : std_logic_vector(19 downto 0);
  
  signal dat_bitplane_addresses_drive : sprite_vector_eight;
  signal dat_offset_drive : unsigned(15 downto 0) := to_unsigned(0,16);
  
  signal cartridge_enable : std_logic := '0';
  signal gated_exrom : std_logic := '1'; 
  signal gated_game : std_logic := '1';
  signal force_exrom : std_logic := '1'; 
  signal force_game : std_logic := '1';
  
  signal cpu_io_sel_resolved : std_logic;
  signal cpu_ext_sel_resolved : std_logic;
    
  --attribute keep of cpu_read_data : signal is "true";
  --attribute dont_touch of cpu_read_data : signal is "true";
  --attribute mark_debug of cpu_read_data : signal is "true";
  --
  --attribute mark_debug of btnCpuReset : signal is "true";
  --attribute mark_debug of reset_io : signal is "true";
  --attribute mark_debug of power_on_reset : signal is "true";
  --attribute mark_debug of reset_monitor : signal is "true";
  --attribute mark_debug of reset_combined : signal is "true";
  --
  --attribute mark_debug of shadow_write_next : signal is "true";
  --attribute mark_debug of shadow_wdata_next : signal is "true";
  
begin

  monitor_roms <= colourram_at_dc00 & rom_at_e000  & rom_at_c000 & rom_at_a000 & rom_at_8000 & monitor_cpuport;
  slow_access_write   <= system_write;
  slow_access_address <= unsigned(system_address);
  slow_access_wdata   <= unsigned(system_wdata);
  
  ----------------------------------------------------------------------------
  -- IRQ & NMI: If either the hardware buttons on the FPGA board or an IO
  -- device via the IOmapper pull an interrupt line down, then trigger an
  -- interrupt.
  -----------------------------------------------------------------------------
  process(irq,nmi,restore_nmi,io_irq,vic_irq,io_nmi,sw,reset_io,btnCpuReset,
          power_on_reset,reset_monitor,hyper_trap)
  begin
    -- XXX Allow switch 0 to mask IRQs
    combinedirq <= ((irq and io_irq and vic_irq) or sw(0));
    combinednmi <= (nmi and io_nmi and restore_nmi) or sw(14);
    if btnCpuReset='0' then
      report "reset asserted via btnCpuReset";
      reset_combined <= '0';
    elsif reset_io='0' then
      report "reset asserted via reset_io";
      reset_combined <= '0';
    elsif power_on_reset(0)='0' then
      report "reset asserted via power_on_reset(0)";
      reset_combined <= '0';
    elsif reset_monitor='0' then
      report "reset asserted via reset_monitor";
      reset_combined <= '0';
    else
      reset_combined <= '1';
    end if;

    hyper_trap_combined <= hyper_trap and monitor_hyper_trap;
    
  -- report "btnCpuReset = " & std_logic'image(btnCpuReset) & ", reset_io = " & std_logic'image(reset_io) & ", sw(15) = " & std_logic'image(sw(15)) severity note;
  -- report "reset_combined = " & std_logic'image(reset_combined) severity note;
  end process;
    
  process(pixelclock,ioclock)
    variable digit : std_logic_vector(3 downto 0);
  begin
    if rising_edge(ioclock) then
      -- Hold reset low for a while when we first turn on
--      report "power_on_reset(0) = " & std_logic'image(power_on_reset(0)) severity note;
      power_on_reset(7) <= '1';
      power_on_reset(6 downto 0) <= power_on_reset(7 downto 1);

      dat_bitplane_addresses_drive <= dat_bitplane_addresses;
      dat_offset_drive <= dat_offset;

      if cartridge_enable='1' then
        gated_exrom <= cpu_exrom and force_exrom;
        gated_game <= cpu_game and force_game;
      else
        gated_exrom <= force_exrom;
        gated_game <= force_game;
      end if;
      
      led(0) <= irq;
      led(1) <= nmi;
      led(2) <= combinedirq;
      led(3) <= combinednmi;
      led(4) <= io_irq;
      led(5) <= io_nmi;
      led(6) <= '0';
      led(7) <= '0';
      led(8) <= motor;
      led(9) <= drive_led_out;
      led(10) <= cpu_hypervisor_mode;
      led(11) <= hyper_trap;
      led(12) <= hyper_trap_combined;
      led(13) <= monitor_hyper_trap;
      led(14) <= speed_gate;
      led(15) <= speed_gate_enable;

      xray_mode <= sw(1);
      
      segled_counter <= segled_counter + 1;

      sseg_an <= (others => '1');
      sseg_an(to_integer(segled_counter(17 downto 15))) <= '0';

      --if segled_counter(17 downto 15)=0 then
      --  digit := std_logic_vector(monitor_pc(3 downto 0));
      --elsif segled_counter(17 downto 15)=1 then
      --  digit := std_logic_vector(monitor_pc(7 downto 4));
      --elsif segled_counter(17 downto 15)=2 then
      --  digit := std_logic_vector(monitor_pc(11 downto 8));
      --elsif segled_counter(17 downto 15)=3 then
      --  digit := std_logic_vector(monitor_pc(15 downto 12));
      --elsif segled_counter(17 downto 15)=4 then
      --  digit := std_logic_vector(monitor_state(3 downto 0));
      --elsif segled_counter(17 downto 15)=5 then
      --  digit := std_logic_vector(monitor_state(7 downto 4));
      --elsif segled_counter(17 downto 15)=6 then
      --  digit := std_logic_vector(monitor_state(11 downto 8));
      --elsif segled_counter(17 downto 15)=7 then
      --  digit := std_logic_vector(monitor_state(15 downto 12));
      --end if;
      --if segled_counter(17 downto 15)=0 then
      --  digit := std_logic_vector(slowram_addr_reflect(3 downto 0));
      --elsif segled_counter(17 downto 15)=1 then
      --  digit := std_logic_vector(slowram_addr_reflect(7 downto 4));
      --elsif segled_counter(17 downto 15)=2 then
      --  digit := std_logic_vector(slowram_addr_reflect(11 downto 8));
      --elsif segled_counter(17 downto 15)=3 then
      --  digit := std_logic_vector(slowram_addr_reflect(15 downto 12));
      --elsif segled_counter(17 downto 15)=4 then
      --  digit := std_logic_vector(slowram_addr_reflect(19 downto 16));
      --elsif segled_counter(17 downto 15)=5 then
      --  digit := std_logic_vector(slowram_addr_reflect(23 downto 20));
      --elsif segled_counter(17 downto 15)=6 then
      --  digit := '1'&std_logic_vector(slowram_addr_reflect(26 downto 24));
      --elsif segled_counter(17 downto 15)=7 then
      --  digit := std_logic_vector(slowram_datain_reflect(3 downto 0));
      --end if;
      if segled_counter(17 downto 15)=0 then
        digit := std_logic_vector(seg_led_data(3 downto 0));
      elsif segled_counter(17 downto 15)=1 then
        digit := std_logic_vector(seg_led_data(7 downto 4));
      elsif segled_counter(17 downto 15)=2 then
        digit := std_logic_vector(seg_led_data(11 downto 8));
      elsif segled_counter(17 downto 15)=3 then
        digit := std_logic_vector(seg_led_data(15 downto 12));
      elsif segled_counter(17 downto 15)=4 then
        digit := std_logic_vector(seg_led_data(19 downto 16));
      elsif segled_counter(17 downto 15)=5 then
        digit := std_logic_vector(seg_led_data(23 downto 20));
      elsif segled_counter(17 downto 15)=6 then
        digit := std_logic_vector(seg_led_data(27 downto 24));
      elsif segled_counter(17 downto 15)=7 then
        digit := std_logic_vector(seg_led_data(31 downto 28));
      end if;
      
      seg_led_data(31 downto 24) <= cpuspeed;
      if cpuis6502 = '1' then
        seg_led_data(23 downto 16) <= x"65";
      else
        seg_led_data(23 downto 16) <= x"45";
      end if;
      -- XXX temporary debug
      seg_led_data(23 downto 16) <= protected_hardware_sig;
      seg_led_data(15 downto 8) <= uart_char;
      seg_led_data(7 downto 0) <= uart_monitor_char;
      
      -- segments are:
      -- 7 - decimal point
      -- 6 - middle
      -- 5 - upper left
      -- 4 - lower left
      -- 3 - bottom
      -- 2 - lower right
      -- 1 - upper right
      -- 0 - top
      case digit is
        when x"0" => sseg_ca <= "11000000";
        when x"1" => sseg_ca <= "11111001";
        when x"2" => sseg_ca <= "10100100";
        when x"3" => sseg_ca <= "10110000";
        when x"4" => sseg_ca <= "10011001";
        when x"5" => sseg_ca <= "10010010";
        when x"6" => sseg_ca <= "10000010";
        when x"7" => sseg_ca <= "11111000";
        when x"8" => sseg_ca <= "10000000";
        when x"9" => sseg_ca <= "10010000";
        when x"A" => sseg_ca <= "10001000";
        when x"B" => sseg_ca <= "10000011";
        when x"C" => sseg_ca <= "11000110";
        when x"D" => sseg_ca <= "10100001";
        when x"E" => sseg_ca <= "10000110";
        when x"F" => sseg_ca <= "10001110";
        when others => sseg_ca <= "10100001";
      end case; 
      

    end if;
    if rising_edge(pixelclock) then
      
      null;
      
    end if;
  end process;
  
  shadowram0 : entity work.shadowram port map (
    clkA      => cpuclock,
    addressa  => system_address_next,
    wea       => shadow_write_next,
    dia       => system_wdata_next,
    doa       => shadow_rdata,
    clkB      => pixelclock,
    addressb  => chipram_address,
    dob       => chipram_data
    );
  
  kickstartrom : entity work.kickstart port map (
    clk     => cpuclock,
    address => system_address_next(13 downto 0),
    cs      => kickstart_cs_next,
    we      => system_write_next,
    data_o  => kickstart_rdata,
    data_i  =>  system_wdata_next
    );
    
  cpu0: entity work.gs4510
    generic map(
      cpufrequency => cpufrequency)
    port map(
      phi0 => phi0,
      all_pause => all_pause,
      matrix_trap_in=>matrix_trap,
      protected_hardware => protected_hardware_sig,
      virtualised_hardware => virtualised_hardware_sig,
      chipselect_enables => chipselect_enables,
      mathclock => cpuclock,
      clock => cpuclock,
      ioclock => ioclock,
      reset =>reset_combined,
      reset_out => reset_out,
      irq => combinedirq,
      nmi => combinednmi,
      exrom => cpu_exrom,
      game => cpu_game,
      hyper_trap => hyper_trap_combined,
      hyper_trap_f011_read => hyper_trap_f011_read,
      hyper_trap_f011_write => hyper_trap_f011_write,    
      speed_gate => speed_gate,
      speed_gate_enable => speed_gate_enable,
      cpuis6502 => cpuis6502,
      cpuspeed => cpuspeed,
      secure_mode_out => secure_mode_flag,
      matrix_rain_seed => matrix_rain_seed,
      dat_offset => dat_offset,
      dat_bitplane_addresses => dat_bitplane_addresses,

      irq_hypervisor => sw(4 downto 2),    -- JBM
      
      -- Hypervisor signals: we need to tell kickstart memory whether
      -- to map or not, and we also need to be able to set the VIC-III
      -- IO mode.
      cpu_hypervisor_mode => cpu_hypervisor_mode,
      iomode_set => iomode_set,
      iomode_set_toggle => iomode_set_toggle,
      
      no_kickstart => no_kickstart,
      
      reg_isr_out => reg_isr_out,
      imask_ta_out => imask_ta_out,
      
      vicii_2mhz => vicii_2mhz,
      viciii_fast => viciii_fast,
      viciv_fast => viciv_fast,

      monitor_char => monitor_char,
      monitor_char_toggle => monitor_char_toggle,
      monitor_char_busy => monitor_char_busy,

      monitor_proceed => monitor_proceed,
--    monitor_debug_memory_access => monitor_debug_memory_access,
      monitor_request_reflected => monitor_request_reflected,
      monitor_hypervisor_mode => monitor_hypervisor_mode,
      monitor_pc => monitor_pc,
      monitor_watch => monitor_watch,
      monitor_watch_match => monitor_watch_match,
      monitor_opcode => monitor_opcode,
      monitor_ibytes => monitor_ibytes,
      monitor_arg1 => monitor_arg1,
      monitor_arg2 => monitor_arg2,
      monitor_a => monitor_a,
      monitor_b => monitor_b,
      monitor_x => monitor_x,
      monitor_y => monitor_y,
      monitor_z => monitor_z,
      monitor_sp => monitor_sp,
      monitor_p => monitor_p,
      monitor_state => monitor_state,
      monitor_map_offset_low => monitor_map_offset_low,
      monitor_map_offset_high => monitor_map_offset_high,
      monitor_map_enables_low => monitor_map_enables_low,
      monitor_map_enables_high => monitor_map_enables_high,

      monitor_mem_address => monitor_mem_address,
      monitor_mem_rdata => monitor_mem_rdata,
      monitor_mem_wdata => monitor_mem_wdata,
      monitor_mem_read => monitor_mem_read,
      monitor_mem_write => monitor_mem_write,
      monitor_mem_setpc => monitor_mem_setpc,
      monitor_mem_attention_request => monitor_mem_attention_request,
      monitor_mem_attention_granted => monitor_mem_attention_granted,
      monitor_irq_inhibit => monitor_irq_inhibit,
      monitor_mem_trace_mode => monitor_mem_trace_mode,
      monitor_mem_stage_trace_mode => monitor_mem_stage_trace_mode,
      monitor_mem_trace_toggle => monitor_mem_trace_toggle,
      monitor_cpuport => monitor_cpuport,
      
      cpu_leds => cpu_leds,
      
      io_sel_next => io_sel_next,
      ext_sel_next => ext_sel_next,
      
      memory_access_address_next         => cpu_memory_access_address_next,
      memory_access_read_next            => cpu_memory_access_read_next,
      memory_access_write_next           => cpu_memory_access_write_next,  
      memory_access_resolve_address_next => cpu_memory_access_resolve_address_next,
      memory_access_wdata_next           => cpu_memory_access_wdata_next,
      memory_access_io_next              => cpu_memory_access_io_next,
      memory_read_data                   => cpu_read_data,
      cpu_ready                          => cpu_ack,
      map_en_next                        => cpu_map_en_next,
      ready                              => cpu_ready,
      rom_writeprotect                   => rom_writeprotect,
      cpuport_ddr_out => cpuport_ddr,
      cpuport_value_out => cpuport_value,
      
      viciii_iomode => viciii_iomode
      
      );

      address_resolver0 : entity work.address_resolver port map(
        short_address => cpu_memory_access_address_next,
        writeP => cpu_memory_access_write_next,
        gated_exrom => gated_exrom,
        gated_game => gated_game,
        map_en => cpu_map_en_next,
        resolve_address => cpu_memory_access_resolve_address_next,
        io_sel => cpu_memory_access_io_next,
        cpuport_value => cpuport_value,
        cpuport_ddr => cpuport_ddr,
        viciii_iomode => viciii_iomode,
        sector_buffer_mapped => sector_buffer_mapped,
        colourram_at_dc00 => colourram_at_dc00,
        hypervisor_mode => cpu_hypervisor_mode,
        rom_at_e000 => rom_at_e000,
        rom_at_c000 => rom_at_c000,
        rom_at_a000 => rom_at_a000,
        rom_at_8000 => rom_at_8000,
        dat_bitplane_addresses => dat_bitplane_addresses,
        dat_offset_drive => dat_offset_drive,
        io_sel_resolved => cpu_io_sel_resolved,
        ext_sel_resolved => cpu_ext_sel_resolved,
        resolved_address => cpu_resolved_memory_access_address_next
      );
  
      dmagic0: entity work.dmagic
      port map(
          clock => cpuclock,
          reset => reset_combined,
          
          dmagic_memory_access_address_next => dmagic_memory_access_address_next,
          dmagic_memory_access_read_next    => dmagic_memory_access_read_next,
          dmagic_memory_access_write_next   => dmagic_memory_access_write_next,
          dmagic_memory_access_wdata_next   => dmagic_memory_access_wdata_next,
          dmagic_memory_access_io_next      => dmagic_memory_access_io_next,
          dmagic_memory_access_ext_next     => dmagic_memory_access_ext_next,
          dmagic_ack                        => dmagic_ack,
          dmagic_bus_ready                  => dmagic_ready,
          dmagic_read_data                  => dmagic_read_data,
          dmagic_dma_req                    => dmagic_dma_req,
          dmagic_cpu_req                    => dmagic_cpu_req,
          
          dmagic_io_address_next            => system_address_next(7 downto 0),
          dmagic_io_cs                      => dmagic_cs_next,
          dmagic_io_read_next               => system_read_next,
          dmagic_io_write_next              => system_write_next,
          dmagic_io_wdata_next              => system_wdata_next,
          dmagic_io_data                    => dmagic_rdata,
          dmagic_io_ready                   => dmagic_io_ready
          
          );

      arbiter0: entity work.bus_arbiter
      port map(
          clock => cpuclock,
          reset => reset_combined,
          
          -- Signals from CPU (or address resolver) to arbiter
          cpu_memory_access_address_next  => cpu_resolved_memory_access_address_next,
          cpu_memory_access_read_next     => cpu_memory_access_read_next,
          cpu_memory_access_write_next    => cpu_memory_access_write_next,
          cpu_memory_access_wdata_next    => cpu_memory_access_wdata_next,
          cpu_memory_access_io_next       => cpu_io_sel_resolved,
          cpu_memory_access_ext_next      => cpu_ext_sel_resolved,
          cpu_ack                         => cpu_ack,
          cpu_read_data                   => cpu_read_data,
          cpu_ready                       => cpu_ready,

          -- Signals from DMAgic to arbiter
          dmagic_memory_access_address_next  => dmagic_memory_access_address_next,
          dmagic_memory_access_read_next     => dmagic_memory_access_read_next,
          dmagic_memory_access_write_next    => dmagic_memory_access_write_next,
          dmagic_memory_access_wdata_next    => dmagic_memory_access_wdata_next,
          dmagic_memory_access_io_next       => dmagic_memory_access_io_next,
          dmagic_memory_access_ext_next      => dmagic_memory_access_ext_next,
          dmagic_ack                         => dmagic_ack,
          dmagic_read_data                   => dmagic_read_data,
          dmagic_ready                       => dmagic_ready,
          dmagic_dma_req                     => dmagic_dma_req,
          dmagic_cpu_req                     => dmagic_cpu_req,
          
          -- Signals from arbiter to bus interface
          bus_memory_access_address_next  => bus_memory_access_address_next,
          bus_memory_access_read_next     => bus_memory_access_read_next,
          bus_memory_access_write_next    => bus_memory_access_write_next,
          bus_memory_access_wdata_next    => bus_memory_access_wdata_next,
          bus_memory_access_io_next       => bus_memory_access_io_next,
          bus_memory_access_ext_next      => bus_memory_access_ext_next,
          bus_ack                         => bus_ack,
          bus_read_data                   => bus_read_data,
          bus_ready                       => bus_ready
          
          );
          
      bus0: entity work.bus_interface
        port map(
          clock => cpuclock,
          reset =>reset_combined,
          hypervisor_mode => cpu_hypervisor_mode,

          memory_access_address_next             => bus_memory_access_address_next,
          memory_access_read_next                => bus_memory_access_read_next,
          memory_access_write_next               => bus_memory_access_write_next,  
          ack                                    => bus_ack,
          memory_access_wdata_next               => bus_memory_access_wdata_next,
          memory_access_io_next                  => bus_memory_access_io_next,
          memory_access_ext_next                 => bus_memory_access_ext_next,
          bus_read_data                          => bus_read_data,   
          bus_ready                              => bus_ready,

          rom_writeprotect                       => rom_writeprotect,

          monitor_waitstates => monitor_waitstates,
          
          -- FIXME, this should go away really. It's just system_address_next with extra 0's.
          monitor_memory_access_address => monitor_memory_access_address,
      
          slow_access_rdata => slow_access_rdata,
          slow_access_ready => slow_access_ready,
      
          -- At this point I think these all might just be copies of the memory_access_ signals and
          -- so may not be needed any more.
          system_address_next => system_address_next,
          system_read_next    => system_read_next,
          system_write_next   => system_write_next,
          system_wdata_next   => system_wdata_next,
          io_sel_next => io_sel_next,
          ext_sel_next => ext_sel_next,

          system_address => system_address,
          system_read    => system_read,
          system_write   => system_write,
          system_wdata   => system_wdata,
          io_sel => io_sel,
          ext_sel => slow_access_request,
          
          shadow_write_next  => shadow_write_next,          
          shadow_rdata       => shadow_rdata,
      
          kickstart_cs_next  => kickstart_cs_next,
          kickstart_rdata    => kickstart_rdata,
      
          dmagic_io_ready    => dmagic_io_ready,
          dmagic_cs_next     => dmagic_cs_next,
          dmagic_rdata       => dmagic_rdata,
          
          io_rdata => io_rdata,
          sector_buffer_mapped => sector_buffer_mapped,
          vic_rdata => vic_rdata,
          vic_ready => vic_ready,
          colour_ram_data => colour_ram_fastio_rdata,

          colour_ram_cs_next => colour_ram_cs_next,
          charrom_write_cs_next => charrom_write_cs_next,
          vic_cs => vic_cs,
          
          viciii_iomode => viciii_iomode,
      
          colourram_at_dc00 => colourram_at_dc00

          );

  frame50: entity work.frame_generator
    generic map ( frame_width => 960,
                  display_width => 800,
                  frame_height => 625,
                  display_height => 600,
                  vsync_start => 620,
                  vsync_end => 625,
                  hsync_start => 814,
                  hsync_end => 884
                  )                  
    port map ( clock => clock30,
               hsync => hsync_pal50,
               vsync => vsync_pal50,
               x_zero => x_zero_pal50,
               y_zero => y_zero_pal50,
               inframe => inframe_pal50,
               lcd_vsync => lcd_vsync_pal50,
               lcd_inframe => lcd_inframe_pal50
               );

  frame60: entity work.frame_generator
    generic map ( frame_width => 1056,
                  display_width => 800,
                  frame_height => 628,
                  display_height => 600,
                  vsync_start => 624,
                  vsync_end => 628,
                  hsync_start => 840,
                  hsync_end => 968
                  )                  
    port map ( clock => clock40,
               hsync => hsync_ntsc60,
               vsync => vsync_ntsc60,
               x_zero => x_zero_ntsc60,
               y_zero => y_zero_ntsc60,
               inframe => inframe_ntsc60,
               lcd_vsync => lcd_vsync_ntsc60,
               lcd_inframe => lcd_inframe_ntsc60,

               -- Get test pattern
               red_o => red_n,
               green_o => green_n,
               blue_o => blue_n
               );               
  
  pixel0: entity work.pixel_driver
    port map (
      pixelclock_select => pixelclock_select,
      
      clock200 => clock200,
      clock100 => pixelclock,
      clock50 => cpuclock,
      clock40 => clock40,
      clock33 => clock33,
      clock30 => clock30,

      red_i => vgared_source,
      green_i => vgagreen_source,
      blue_i => vgablue_source,

      red_o => vgared_sig,
      green_o => vgagreen_sig,
      blue_o => vgablue_sig,      

      hsync_i => hsync_drive1,
      hsync_o => hsync_drive,
      vsync_i => vsync_drive1,
      vsync_o => vsync_drive,

      lcd_hsync_i => lcd_hsync1,
      lcd_hsync_o => lcd_hsync,
      lcd_vsync_i => lcd_vsync1,
      lcd_vsync_o => lcd_vsync,

      viciv_outofframe_i => viciv_outofframe_viciv,
      viciv_outofframe_o => viciv_outofframe,
      
      lcd_display_enable_i => lcd_display_enable1,
      lcd_display_enable_o => lcd_display_enable,

      lcd_pixel_strobe_i => lcd_pixel_strobe1,
      lcd_pixel_strobe_o => lcd_pixel_strobe

      );
      
      
  viciv0: entity work.viciv
    port map (

      all_pause => all_pause,

      external_frame_x_zero => external_frame_x_zero,
      external_frame_y_zero => external_frame_y_zero,
      
      xcounter_out => xcounter,
      ycounter_out => ycounter,
      pixelclock      => pixelclock,
      cpuclock        => cpuclock,
      ioclock        => ioclock,

      pixelclock_select => pixelclock_select,
      
      irq             => vic_irq,
      reset           => reset_combined,

      led => drive_led,
      motor => motor,
      drive_led_out => drive_led_out,

      xray_mode => xray_mode,

      dat_offset => dat_offset,
      dat_bitplane_addresses => dat_bitplane_addresses,
      
--      vsync           => vsync_drive1,
--      hsync           => hsync_drive1,
--      lcd_vsync => lcd_vsync1,
--      lcd_hsync => lcd_hsync1,
--      lcd_display_enable => lcd_display_enable1,
      lcd_pixel_strobe => pixel_strobe,
      vgared          => vgared_viciv,
      vgagreen        => vgagreen_viciv,
      vgablue         => vgablue_viciv,
      viciv_outofframe => viciv_outofframe_viciv,

      pixel_stream_out => pixel_stream,
      pixel_red_out => pixel_red,
      pixel_green_out => pixel_green,
      pixel_blue_out => pixel_blue,
      pixel_y => pixel_y,
      pixel_valid => pixel_valid,
      pixel_newframe => pixel_newframe,
      pixel_newraster => pixel_newraster,
      native_x_640 => native_x_640,
      native_y_200 => native_y_200,
      native_y_400 => native_y_400,
      pixel_x_640 => pixel_x_640,
      pixel_y_scale_200 => pixel_y_scale_200,
      pixel_y_scale_400 => pixel_y_scale_400,
      
      --chipram_we => chipram_we,
      chipram_address => chipram_address,
      chipram_datain => chipram_data,
      colour_ram_rdata => colour_ram_fastio_rdata,
      colour_ram_cs_next => colour_ram_cs_next,
      charrom_write_cs_next => charrom_write_cs_next,

      -- TODO Clean this up, vic no longer needs two different bus connections.
      fastio_addr     => system_address,
      fastio_read     => system_read,
      fastio_write    => system_write,
      fastio_wdata    => system_wdata,
      vic_cs          => vic_cs,
      vic_rdata       => vic_rdata,
      vic_ready       => vic_ready,
      ack             => bus_ack,
      
      io_sel          => io_sel,
      io_sel_next         => io_sel_next,
      system_wdata_next   => system_wdata_next,
      system_address_next => system_address_next,
      system_write_next   => system_write_next,
      
      viciii_iomode => viciii_iomode,
      iomode_set_toggle => iomode_set_toggle,
      iomode_set => iomode_set,
      vicii_2mhz => vicii_2mhz,
      viciii_fast => viciii_fast,
      viciv_fast => viciv_fast,
      
      colourram_at_dc00 => colourram_at_dc00,
      rom_at_e000 => rom_at_e000,
      rom_at_c000 => rom_at_c000,
      rom_at_a000 => rom_at_a000,
      rom_at_8000 => rom_at_8000      
      );

  mouse0: entity work.mouse_input
    port map (
      clk => ioclock,

      mouse_debug => mouse_debug,
      amiga_mouse_enable_a => amiga_mouse_enable_a,
      amiga_mouse_enable_b => amiga_mouse_enable_b,
      amiga_mouse_assume_a => amiga_mouse_assume_a,
      amiga_mouse_assume_b => amiga_mouse_assume_b,
      
      -- These are the 1351 mouse / C64 paddle inputs and drain control
      pot_drain => pot_drain,
      fa_potx => fa_potx,
      fa_poty => fa_poty,
      fb_potx => fb_potx,
      fb_poty => fb_poty,

      -- To allow auto-detection of Amiga mouses, we need to know what the
      -- rest of the joystick pins are doing
      fa_fire => fa_fire,
      fa_left => fa_left,
      fa_right => fa_right,
      fa_up => fa_up,
      fa_down => fa_down,
      fb_fire => fb_fire,
      fb_left => fb_left,
      fb_right => fb_right,
      fb_up => fb_up,
      fb_down => fb_down,

      fa_up_out => fa_up_out,
      fa_down_out => fa_down_out,
      fa_left_out => fa_left_out,
      fa_right_out => fa_right_out,

      fb_up_out => fb_up_out,
      fb_down_out => fb_down_out,
      fb_left_out => fb_left_out,
      fb_right_out => fb_right_out,
      
      -- We output the four sampled pot values
      pota_x => pota_x,
      pota_y => pota_y,
      potb_x => potb_x,
      potb_y => potb_y
      );
  
  iomapper0: entity work.iomapper
    port map (
      clk => ioclock,
      clock200 => clock200,
      protected_hardware_in => protected_hardware_sig,
      virtualised_hardware_in => virtualised_hardware_sig,
      chipselect_enables => chipselect_enables,
      matrix_mode_trap => matrix_trap,
      hyper_trap => hyper_trap,
      hyper_trap_f011_read => hyper_trap_f011_read,
      hyper_trap_f011_write => hyper_trap_f011_write,
      cpuclock => cpuclock,
      pixelclk => pixelclock,
      clock50mhz => clock50mhz,
      cpu_hypervisor_mode => cpu_hypervisor_mode,
      speed_gate => speed_gate,
      speed_gate_enable => speed_gate_enable,

      buffereduart_rx => buffereduart_rx,
      buffereduart_tx => buffereduart_tx,
      buffereduart_ringindicate => buffereduart_ringindicate,
      buffereduart2_rx => buffereduart2_rx,
      buffereduart2_tx => buffereduart2_tx,
      
      visual_keyboard_enable => visual_keyboard_enable,
      zoom_en_osk => zoom_en_osk,
      zoom_en_always => zoom_en_always,
      keyboard_at_top => keyboard_at_top,
      alternate_keyboard => alternate_keyboard,
      osk_x => osk_x,
      osk_y => osk_y,
      osk_key1 => osk_key1,
      osk_key2 => osk_key2,
      osk_key3 => osk_key3,
      osk_key4 => osk_key4,
      touch_key1 => osk_touch1_key,
      touch_key2 => osk_touch2_key,
            
      uart_char => uart_char,
      uart_char_valid => uart_char_valid,
      
      -- ASCII key from keyboard_complex for feeding UART monitor interface
      -- when using local keyboard
      uart_monitor_char => uart_monitor_char,
      uart_monitor_char_valid => uart_monitor_char_valid,
      mm_displayMode_out => mm_displayMode,
      display_shift_out => display_shift,
      shift_ready_out => shift_ready,
      shift_ack_in => shift_ack,     
      
      fpga_temperature => fpga_temperature,

      restore_key => restore_key,
      
      reg_isr_out => reg_isr_out,
      imask_ta_out => imask_ta_out,    

      key_scancode => key_scancode,
      key_scancode_toggle => key_scancode_toggle,

      cart_access_count => cart_access_count,
      
      uartclock => uartclock,
      phi0 => phi0,
      reset => reset_combined,
      reset_out => reset_io,
      irq => io_irq, -- (but we might like to AND this with the hardware IRQ button)
      nmi => io_nmi, -- (but we might like to AND this with the hardware IRQ button)
      restore_nmi => restore_nmi,
      
      -- For now FastIO is complicated enough to read from that we need an extra
      -- cycle.   FIXME - Have the extra cycle stuff be buried in the places where
      -- we need it, and have proper "ready" signal handling from from the device
      -- we are trying to talk to so the bus interface logic doesn't need to have
      -- special knowledge.  That's just not how hardware should get built.
      
      -- Or probably to really simplify things if I can do the ready signal stuff...
      -- Just run all FastIO devices at 25Mhz instead of 50Mhz.  There's no reason
      -- we need a 50Mhz I/O clock, really.
      address_next => system_address,
      io_sel_next => io_sel,      
      r_next => system_read, 
      w_next => system_write,
      data_i_next => system_wdata, 

      data_o => io_rdata,
      
      colourram_at_dc00 => colourram_at_dc00,
      drive_led => drive_led,
      motor => motor,
      drive_led_out => drive_led_out,
      sw => sw,
      btn => btn,
--    seg_led => seg_led_data,
      viciii_iomode => viciii_iomode,
      sector_buffer_mapped => sector_buffer_mapped,

      -- CPU status for sending to ethernet frame packer
      
    monitor_pc => monitor_pc,
    monitor_opcode => monitor_opcode,
    monitor_arg1 => monitor_arg1,
    monitor_arg2 => monitor_arg2,
    monitor_a => monitor_a,
    monitor_b => monitor_b,
    monitor_x => monitor_x,
    monitor_y => monitor_y,
    monitor_z => monitor_z,
    monitor_sp => monitor_sp,
    monitor_p => monitor_p,
      
    f_density => f_density,
    f_motor => f_motor,
    f_select => f_select,
    f_stepdir => f_stepdir,
    f_step => f_step,
    f_wdata => f_wdata,
    f_wgate => f_wgate,
    f_side1 => f_side1,
    f_index => f_index,
    f_track0 => f_track0,
    f_writeprotect => f_writeprotect,
    f_rdata => f_rdata,
    f_diskchanged => f_diskchanged,
      
      ----------------------------------------------------------------------
      -- CBM floppy  std_logic_vectorerial port
      ----------------------------------------------------------------------
      iec_clk_en => iec_clk_en,
      iec_data_en => iec_data_en,
      iec_data_o => iec_data_o,
      iec_reset => iec_reset,
      iec_clk_o => iec_clk_o,
      iec_atn_o => iec_atn_o,
      iec_data_external => iec_data_external,
      iec_clk_external => iec_clk_external,
      
      porta_pins => porta_pins,
      portb_pins => portb_pins,
      capslock_key => caps_lock_key,
      keyboard_column8_out => keyboard_column8,
      key_left => keyleft,
      key_up => keyup,

      fa_fire => fa_fire,
      fa_up => fa_up_out,
      fa_left => fa_left_out,
      fa_down => fa_down_out,
      fa_right => fa_right_out,
      fa_potx => fa_potx,
      fa_poty => fa_poty,
      
      fb_fire => fb_fire,
      fb_up => fb_up_out,
      fb_left => fb_left_out,
      fb_down => fb_down_out,
      fb_right => fb_right_out,
      fb_potx => fb_potx,
      fb_poty => fb_poty,

      pota_x => pota_x,
      pota_y => pota_y,
      potb_x => potb_x,
      potb_y => potb_y,      
      
      pot_drain => pot_drain,
      pot_via_iec => pot_via_iec,

      mouse_debug => mouse_debug,
      amiga_mouse_enable_a => amiga_mouse_enable_a,
      amiga_mouse_enable_b => amiga_mouse_enable_b,
      amiga_mouse_assume_a => amiga_mouse_assume_a,
      amiga_mouse_assume_b => amiga_mouse_assume_b,
      
      pixel_stream_in => pixel_stream,
      pixel_red_in => pixel_red,
      pixel_green_in => pixel_green,
      pixel_blue_in => pixel_blue,
      pixel_y => pixel_y,
      pixel_valid => pixel_strobe,
      pixel_newframe => pixel_newframe,
      pixel_newraster => pixel_newraster,
      pixel_x_640 => pixel_x_640,

      pmod_clock => pmodb_in_buffer(0),
      pmod_start_of_sequence => pmodb_in_buffer(1),
      pmod_data_in => pmodb_in_buffer(5 downto 2),
      pmod_data_out => pmodb_out_buffer(1 downto 0),
      
      pmoda => pmoda,

      hdmi_sda => hdmi_sda,
      hdmi_scl => hdmi_scl,    

      uart_rx => uart_rx,
      uart_tx => uart_tx,
      
      cs_bo => cs_bo,
      sclk_o => sclk_o,
      mosi_o => mosi_o,
      miso_i => miso_i,
      
      aclMISO => aclMISO,
      aclMOSI => aclMOSI,
      aclSS => aclSS,
      aclSCK => aclSCK,
      aclInt1 => aclInt1,
      aclInt2 => aclInt2,

      -- PDM digital audio output
      ampPWM_l => ampPWM_l,
      ampPWM_r => ampPWM_r,
      ampSD => ampSD,

      -- MEMS microphones
      micData0 => micData0,
      micData1 => micData1,
      micClk => micClk,
      micLRSel => micLRSel,

      -- I2S interfaces for various boards
      i2s_master_clk => i2s_master_clk,
      i2s_master_sync => i2s_master_sync,
      i2s_slave_clk => i2s_slave_clk,
      i2s_slave_sync => i2s_slave_sync,
      pcm_modem_clk => pcm_modem_clk,
      pcm_modem_sync => pcm_modem_sync,
      pcm_modem_clk_in => pcm_modem_clk_in,
      pcm_modem_sync_in => pcm_modem_sync_in,      
      i2s_headphones_data_out => i2s_headphones_data_out,
      i2s_headphones_data_in => i2s_headphones_data_in,
      i2s_speaker_data_out => i2s_speaker_data_out,
      pcm_modem1_data_in => pcm_modem1_data_in,
      pcm_modem2_data_in => pcm_modem2_data_in,
      pcm_modem1_data_out => pcm_modem1_data_out,
      pcm_modem2_data_out => pcm_modem2_data_out,
      i2s_bt_data_in => i2s_bt_data_in,
      i2s_bt_data_out => i2s_bt_data_out,
      
      tmpSDA => tmpSDA,
      tmpSCL => tmpSCL,
      tmpInt => tmpInt,
      tmpCT => tmpCT,

      i2c1SDA => i2c1SDA,
      i2c1SCL => i2c1SCL,

      lcdpwm => lcdpwm,
      touchSDA => touchSDA,
      touchSCL => touchSCL,
      touch1_valid => osk_touch1_valid,
      touch1_x => osk_touch1_x,
      touch1_y => osk_touch1_y,
      touch2_valid => osk_touch2_valid,
      touch2_x => osk_touch2_x,
      touch2_y => osk_touch2_y,
      
      ---------------------------------------------------------------------------
      -- IO lines to the ethernet controller
      ---------------------------------------------------------------------------
      eth_mdio => eth_mdio,
      eth_mdc => eth_mdc,
      eth_reset => eth_reset,
      eth_rxd => eth_rxd,
      eth_txd => eth_txd,
      eth_txen => eth_txen,
      eth_rxdv => eth_rxdv,
      eth_rxer => eth_rxer,
      eth_interrupt => eth_interrupt,
      
      ps2data => ps2data,
      ps2clock => ps2clock,
      
      scancode_out => scancode_out
      );

  matrix_compositor0 : entity work.matrix_rain_compositor port map(
    display_shift_in=>display_shift,
    shift_ready_in => shift_ready,
    shift_ack_out => shift_ack,
    mm_displayMode_in => mm_displayMode,
    monitor_char_in => monitor_char_out,
    monitor_char_valid => monitor_char_out_valid,
    terminal_emulator_ready => terminal_emulator_ready,
    terminal_emulator_ack => terminal_emulator_ack,

    matrix_rdata => matrix_rdata,
    matrix_fetch_address => matrix_fetch_address,
    seed => matrix_rain_seed,

    hsync_in => hsync_drive,
    vsync_in => vsync_drive,
    pixel_x_640 => pixel_x_640,
    pixel_y_scale_200 => pixel_y_scale_200,
    pixel_y_scale_400 => pixel_y_scale_400,
    ycounter_in => ycounter,	
    clk => uartclock,
    pixelclock => pixelclock,
    matrix_mode_enable => protected_hardware_sig(6),--sw(5),
    secure_mode_flag =>  secure_mode_flag,
    vgared_in => vgared_sig,
    vgagreen_in => vgagreen_sig,
    vgablue_in => vgablue_sig,
    vgared_out => vgared_kbd,
    vgagreen_out => vgagreen_kbd,
    vgablue_out => vgablue_kbd
    );

    visual_keyboard0 : entity work.visual_keyboard port map(
    native_x_640 => native_x_640,
    native_y_200 => native_y_200,
    native_y_400 => native_y_400,
    pixel_x_640_in => pixel_x_640,
    pixel_y_scale_200 => pixel_y_scale_200,
    pixel_y_scale_400 => pixel_y_scale_400,
    ycounter_in => ycounter,
    y_start => osk_y,
    x_start => osk_x,
    pixelclock => pixelclock,
    vgared_in => vgared_kbd,
    vgagreen_in => vgagreen_kbd,
    visual_keyboard_enable => visual_keyboard_enable,
    zoom_en_osk => zoom_en_osk,
    zoom_en_always => zoom_en_always,
    keyboard_at_top => keyboard_at_top,
    alternate_keyboard => alternate_keyboard,
    instant_at_top => '0',
    key1 => osk_key1,
    key2 => osk_key2,
    key3 => osk_key3,
    key4 => osk_key4,
    touch1_valid => osk_touch1_valid,
    touch1_x => osk_touch1_x,    
    touch1_y => osk_touch1_y,
    touch1_key => osk_touch1_key,
    touch2_valid => osk_touch2_valid,
    touch2_x => osk_touch2_x,    
    touch2_y => osk_touch2_y,
    touch2_key => osk_touch2_key,

    matrix_fetch_address => matrix_fetch_address,
    matrix_rdata => matrix_rdata,
    
    vgablue_in => vgablue_kbd,
    vgared_out => vgared_out,
    vgagreen_out => vgagreen_out,
    vgablue_out => vgablue_out
    );
  
  -----------------------------------------------------------------------------
  -- UART interface for monitor debugging and loading data
  -----------------------------------------------------------------------------
  monitor0 : uart_monitor port map (
    reset => reset_combined,
    reset_out => reset_monitor,

    monitor_hyper_trap => monitor_hyper_trap,
    clock => uartclock,
    tx       => uart_txd_sig,--uart_txd_sig,
    rx       => RsRx,
    bit_rate_divisor => bit_rate_divisor,

    protected_hardware_in => protected_hardware_sig,
    -- ASCII key from keyboard_complex for feeding UART monitor interface
    -- when using local keyboard
    uart_char => uart_monitor_char,
    uart_char_valid => uart_monitor_char_valid,

    -- output for matrix mode
    monitor_char_out => monitor_char_out,
    monitor_char_valid => monitor_char_out_valid,
    terminal_emulator_ready => terminal_emulator_ready,
    terminal_emulator_ack => terminal_emulator_ack,
    
    force_single_step => sw(11),
    
    fastio_read => system_read,
    fastio_write => system_write,

    key_scancode => key_scancode,
    key_scancode_toggle => key_scancode_toggle,

    monitor_char => monitor_char,
    monitor_char_toggle => monitor_char_toggle,
    monitor_char_busy => monitor_char_busy,
--    monitor_debug_memory_access => monitor_debug_memory_access,
--    monitor_debug_memory_access => (others => '1'),
    monitor_proceed => monitor_proceed,
    monitor_waitstates => monitor_waitstates,
    monitor_request_reflected => monitor_request_reflected,
    monitor_hypervisor_mode => monitor_hypervisor_mode,
    monitor_pc => monitor_pc,
    monitor_cpu_state => monitor_state,
    monitor_instruction => monitor_instruction,
    monitor_watch => monitor_watch,
    monitor_watch_match => monitor_watch_match,
    monitor_opcode => monitor_opcode,
    monitor_ibytes => monitor_ibytes,
    monitor_arg1 => monitor_arg1,
    monitor_arg2 => monitor_arg2,
    monitor_a => monitor_a,
    monitor_b => monitor_b,
    monitor_x => monitor_x,
    monitor_y => monitor_y,
    monitor_z => monitor_z,
    monitor_sp => monitor_sp,
    monitor_p => monitor_p,
    monitor_roms => monitor_roms,
    monitor_interrupt_inhibit => monitor_interrupt_inhibit,
    monitor_map_offset_low => monitor_map_offset_low,
    monitor_map_offset_high => monitor_map_offset_high,
    monitor_map_enables_low => monitor_map_enables_low,
    monitor_map_enables_high => monitor_map_enables_high,
    monitor_memory_access_address => monitor_memory_access_address,
    monitor_mem_address => monitor_mem_address,
    monitor_mem_rdata => monitor_mem_rdata,
    monitor_mem_wdata => monitor_mem_wdata,
    monitor_mem_read => monitor_mem_read,
    monitor_mem_write => monitor_mem_write,
    monitor_mem_setpc => monitor_mem_setpc,
    monitor_mem_attention_request => monitor_mem_attention_request,
    monitor_mem_attention_granted => monitor_mem_attention_granted,
    monitor_irq_inhibit => monitor_irq_inhibit,
    monitor_mem_trace_mode => monitor_mem_trace_mode,
    monitor_mem_stage_trace_mode => monitor_mem_stage_trace_mode,
    monitor_mem_trace_toggle => monitor_mem_trace_toggle
    );

  process (cpuclock) is
  begin
    if rising_edge(cpuclock) then
      pmodb_in_buffer(0) <= pmod_clock;
      pmodb_in_buffer(1) <= pmod_start_of_sequence;
      pmodb_in_buffer(5 downto 2) <= pmod_data_in;
      pmod_data_out <= pmodb_out_buffer;
      flopled <= drive_led_out;
      flopmotor <= motor;
    end if;
  end process;

  process (pixelclock) is
  begin
    if rising_edge(pixelclock) then
      -- Enforce black output outside of frame, so that
      -- compositors can't mess the frame up
      hsync <= hsync_drive;
      vsync <= vsync_drive;
      viciv_outofframe_3 <= viciv_outofframe_2;
      viciv_outofframe_2 <= viciv_outofframe_1;
      viciv_outofframe_1 <= viciv_outofframe;
      if viciv_outofframe_3 = '1' then
        vgared <= (others => '0');
        vgagreen <= (others => '0');
        vgablue <= (others => '0');
      else
        vgared <= vgared_out;
        vgagreen <= vgagreen_out;
        vgablue <= vgablue_out;
      end if;

      -- Create delayed versions of pixels
      -- (we use these for lining up the 100MHz pixel clock edges
      -- better to the 30 or 40MHz video mode pixel clocks)
      vgared_viciv2 <= vgared_viciv;
      vgagreen_viciv2 <= vgagreen_viciv;
      vgablue_viciv2 <= vgablue_viciv;

      vgared_viciv3 <= vgared_viciv2;
      vgagreen_viciv3 <= vgagreen_viciv2;
      vgablue_viciv3 <= vgablue_viciv2;

      vgared_viciv4 <= vgared_viciv3;
      vgagreen_viciv4 <= vgagreen_viciv3;
      vgablue_viciv4 <= vgablue_viciv3;
      
    end if;
  end process;

  process (pixelclock_select,cpuclock) is
  begin
    if pixelclock_select(6)='1' then
      vgared_source <= red_n;
      vgagreen_source <= green_n;
      vgablue_source <= blue_n;
    else
      -- Show VIC-IV output (with optional pixel delay to get edges lining up nicely)
      case pixelclock_select(5 downto 4) is
        when "11" =>
          vgared_source <= vgared_viciv4;
          vgagreen_source <= vgagreen_viciv4;
          vgablue_source <= vgablue_viciv4;
        when "10" =>
          vgared_source <= vgared_viciv3;
          vgagreen_source <= vgagreen_viciv3;
          vgablue_source <= vgablue_viciv3;
        when "01" =>
          vgared_source <= vgared_viciv2;
          vgagreen_source <= vgagreen_viciv2;
          vgablue_source <= vgablue_viciv2;
        when others =>
          vgared_source <= vgared_viciv;
          vgagreen_source <= vgagreen_viciv;
          vgablue_source <= vgablue_viciv;
      end case;
    end if;
    if pixelclock_select(7)='1' then
      -- PAL 50 Hz frame
      hsync_drive1 <= hsync_pal50;
      vsync_drive1 <= not vsync_pal50;
      lcd_hsync1 <= hsync_pal50;
      lcd_vsync1 <= not lcd_vsync_pal50;
      lcd_display_enable1 <= lcd_inframe_pal50;
      lcd_pixel_strobe1 <= clock30;
      external_frame_x_zero <= x_zero_pal50;
      external_frame_y_zero <= y_zero_pal50;
    else
      -- NTSC 60 Hz frame
      hsync_drive1 <= hsync_ntsc60;
      vsync_drive1 <= vsync_ntsc60;
      lcd_hsync1 <= hsync_ntsc60;
      lcd_vsync1 <= lcd_vsync_ntsc60;
      lcd_display_enable1 <= lcd_inframe_ntsc60;
      lcd_pixel_strobe1 <= clock40;
      external_frame_x_zero <= x_zero_ntsc60;
      external_frame_y_zero <= y_zero_ntsc60;
    end if;
  end process;
  
  UART_TXD<=uart_txd_sig; 
  
end Behavioral;

