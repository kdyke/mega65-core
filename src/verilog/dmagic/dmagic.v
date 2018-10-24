// For when I want to synthesize and keep the full internal hierarchy
`define EN_SCHEM_KEEP 1
`ifdef EN_SCHEM_KEEP
`define SCHEM_KEEP_HIER (* keep_hierarchy = "yes" *)
`else
`define SCHEM_KEEP_HIER
`endif

//`define MARK_DEBUG 1
`ifdef EN_MARK_DEBUG
`define DBG (* mark_debug = "yes" *)
`else
`define DBG
`endif

/*

Written by
   Kenneth Dyke 2018

*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU Lesser General Public License as
*  published by the Free Software Foundation; either version 3 of the
*  License, or (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU Lesser General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
*  02111-1307  USA.
*/

`SCHEM_KEEP_HIER module dmagic(input clk, input reset, 
                               `DBG output reg [19:0] dmagic_memory_access_address_next, 
                               `DBG output reg dmagic_memory_access_read_next, `DBG output reg dmagic_memory_access_write_next,
                               `DBG output reg [7:0] dmagic_memory_access_wdata_next, 
                               `DBG output reg dmagic_memory_access_io_next, `DBG output reg dmagic_memory_access_ext_next,
                               `DBG output reg dmagic_ack, `DBG input dmagic_bus_ready, `DBG input [7:0] dmagic_read_data,
                               `DBG output reg dmagic_dma_req, `DBG output reg dmagic_cpu_req,
                               
                               `DBG input [7:0] dmagic_io_address_next, `DBG input dmagic_io_cs, `DBG input dmagic_io_ack,
                               `DBG input dmagic_io_read_next, `DBG input dmagic_io_write_next, `DBG input [7:0] dmagic_io_wdata_next,
                               `DBG output reg [7:0] dmagic_io_data, `DBG output reg dmagic_io_ready);

parameter DMAgic_Idle                   = 4'h00, 
          DMAgic_CPUAccessRead          = 4'h01, 
          DMAgic_CPUAccessReadWait      = 4'h02,
          DMAgic_CPUAccessWrite         = 4'h03,
          DMAgic_CPUAccessAck           = 4'h04,
          DMAgic_ReadOptions            = 4'h05,
          DMAgic_ReadOptionArgument     = 4'h06,
          DMAgic_ReadList               = 4'h07,
          DMAgic_Start                  = 4'h08,
          DMAgic_Dispatch               = 4'h09,
          DMAgic_Fill                   = 4'h0A,
          DMAgic_CopyRead               = 4'h0B,
          DMAgic_CopyWrite              = 4'h0C,
          DMAgic_End                    = 4'h0D;
  
`DBG reg [3:0] dmagic_state, dmagic_state_next;

parameter Addr_List   = 2'h00,
          Addr_Src    = 2'h01,
          Addr_Dst    = 2'h02,
          Addr_PIO    = 2'h03;

`DBG reg [1:0] dmagic_addr_sel_next;
`DBG reg [7:0] dmagic_wdata_next;          

parameter Data_Idle                     = 4'h00,
          Data_List0                    = 4'h01,
          Data_List1                    = 4'h02,
          Data_List2                    = 4'h03,
          Data_Status                   = 4'h04,
          Data_Addr0                    = 4'h05,
          Data_Addr1                    = 4'h06,
          Data_Addr2                    = 4'h07,
          Data_Index                    = 4'h08,
          Data_Read                     = 4'h09;

`DBG reg [3:0] dmagic_data_op_next;

`DBG reg [19:0] dmagic_list_addr, dmagic_list_addr_next;
`DBG reg [3:0] dmagic_list_counter;

`DBG reg load_dir_cmd, load_srcdst_opts;

`DBG reg [15:0] dmagic_modulo;
`DBG reg load_mod0, load_mod1;
 
`DBG reg [15:0] dmagic_count;
`DBG wire [15:0] dmagic_count_next;

`DBG reg load_count0, load_count1, update_count;
`DBG reg [7:0] dmagic_cmd;
`DBG reg load_cmd;

// Our PIO address
`DBG reg [19:0] dmagic_pio_addr, dmagic_pio_base_addr;
`DBG reg [7:0] dmagic_pio_index;
`DBG reg load_pio;

`DBG reg increment_index, load_pio_base_addr0, load_pio_base_addr1, load_pio_base_addr2, load_pio_index;
`DBG reg load_list_addr0, load_list_addr1, load_list_addr2, increment_list_addr;

`DBG reg load_src_addr0, load_src_addr1, load_src_addr2, update_src_addr, load_src_opts;  
`DBG wire [19:0] dmagic_src_addr, dmagic_src_io;

`DBG reg load_dst_addr0, load_dst_addr1, load_dst_addr2, update_dst_addr, load_dst_opts;
`DBG wire [19:0] dmagic_dst_addr, dmagic_dst_io;

`DBG reg load_status;
`DBG reg support_f01b;

`DBG reg list_counter_reset, increment_list_counter;

`DBG reg job_is_f018b;

`DBG reg set_job_is_f018a, set_job_is_f018b;
`DBG reg load_wdata_fill, load_wdata_bus;

`DBG reg job_uses_options, set_job_uses_options, clear_job_uses_options;
`DBG reg dmagic_wdata_sel_read;

`DBG reg start_job, start_cpu_write, start_cpu_read;
`DBG reg [15:0] dmagic_serial;

`DBG reg [8:0] tmp_sum;
   
  dmagic_addr_reg src_addr(.clk(clk), .load_addr0(load_src_addr0), .load_addr1(load_src_addr1), .load_addr2(load_src_addr2), .update_addr(update_src_addr), 
                           .load_opts_rdata(load_src_opts), .read_data(dmagic_read_data), .mod_hold(dmagic_read_data[1:0]), .load_mod_hold(load_srcdst_opts),
                           .dir(dmagic_read_data[4]), .load_dir(load_dir_cmd), .addr(dmagic_src_addr), .addr_io(dmagic_src_io));

  dmagic_addr_reg dst_addr(.clk(clk), .load_addr0(load_dst_addr0), .load_addr1(load_dst_addr1), .load_addr2(load_dst_addr2), .update_addr(update_dst_addr), 
                           .load_opts_rdata(load_dst_opts), .read_data(dmagic_read_data), .mod_hold(dmagic_read_data[3:2]), .load_mod_hold(load_srcdst_opts),
                           .dir(dmagic_read_data[5]), .load_dir(load_dir_cmd), .addr(dmagic_dst_addr), .addr_io(dmagic_dst_io));

// DMAgic state machine clocked section.   This process really doesn't do any decision making. That
// all happens in the combinatorial logic.  This is done as a Mealy machine so we can respond to certain
// external signals without needing another clock edge.  This is important so we can do single cycle
// memory accesses for PIO, for example.
always @(posedge clk) 
begin
  
  if (reset == 0) begin
    dmagic_state <= DMAgic_Idle;
    support_f01b <= 0;
    dmagic_serial <= 0;
    job_is_f018b <= 0;
    
  end else begin
    
    dmagic_state <= dmagic_state_next;
          
    // Clocked output data register
    case (dmagic_data_op_next)
      Data_List0:     dmagic_io_data <= dmagic_list_addr[7:0];
      Data_List1:     dmagic_io_data <= dmagic_list_addr[15:8];
      Data_List2:     dmagic_io_data <= {4'h0, dmagic_list_addr[19:16]};
      Data_Status:    dmagic_io_data <= {7'h0, support_f01b};
      Data_Addr0:     dmagic_io_data <= dmagic_pio_base_addr[7:0];
      Data_Addr1:     dmagic_io_data <= dmagic_pio_base_addr[15:8];
      Data_Addr2:     dmagic_io_data <= {4'h0, dmagic_pio_base_addr[19:16]};
      Data_Index:     dmagic_io_data <= dmagic_pio_index;
      Data_Read:      dmagic_io_data <= dmagic_read_data;
      default:
          ;
    endcase

    if (load_pio)
      dmagic_wdata_next <= dmagic_io_wdata_next;
    else if (load_wdata_fill)
      dmagic_wdata_next <= dmagic_src_addr[7:0];
    else if (load_wdata_bus)
      dmagic_wdata_next <= dmagic_read_data;
            
    // Clocked register updates
    if (load_pio)
      dmagic_pio_addr <= dmagic_pio_base_addr + dmagic_pio_index;
      
    if (start_job)
      dmagic_serial <= dmagic_serial + 1;
    
    if (increment_index) begin
      tmp_sum = dmagic_pio_index + 1;
      dmagic_pio_index <= tmp_sum[7:0];
      dmagic_pio_base_addr[19:8] <= dmagic_pio_base_addr[19:8] + tmp_sum[8]; // Increment pio addr by carry
    end else begin
      if (load_pio_base_addr0)
        dmagic_pio_base_addr[7:0] <= dmagic_io_wdata_next;
      if (load_pio_base_addr1)
        dmagic_pio_base_addr[15:8] <= dmagic_io_wdata_next;
      if (load_pio_base_addr2)
        dmagic_pio_base_addr[19:16] <= dmagic_io_wdata_next[3:0];
      if (load_pio_index)
        dmagic_pio_index <= dmagic_io_wdata_next;
    end        

    if (increment_list_addr)
      dmagic_list_addr <= dmagic_list_addr_next;
    else begin
      if (load_list_addr0)
        dmagic_list_addr[7:0] <= dmagic_io_wdata_next;
      if (load_list_addr1)
        dmagic_list_addr[15:8] <= dmagic_io_wdata_next;
      if (load_list_addr2)
        dmagic_list_addr[19:16] <= dmagic_io_wdata_next[3:0];
    end
    
    if (load_status)
      support_f01b <= dmagic_io_wdata_next[0];
    
    if (load_cmd)
      dmagic_cmd <= dmagic_read_data;
    
    if (list_counter_reset)
      dmagic_list_counter <= 0;
    else if (increment_list_counter)
      dmagic_list_counter <= dmagic_list_counter + 1;
    
    if (update_count)
      dmagic_count <= dmagic_count_next;
    else begin
      if (load_count0)
        dmagic_count[7:0] <= dmagic_read_data;
      if (load_count1)
        dmagic_count[15:8] <= dmagic_read_data;
    end
        
    if (load_mod0)
      dmagic_modulo[7:0] <= dmagic_read_data;
    if (load_mod1)
      dmagic_modulo[15:8] <= dmagic_read_data;
        
    if (set_job_is_f018a)
      job_is_f018b <= 0;
    else if (set_job_is_f018b)
      job_is_f018b <= 1;
    
    if (set_job_uses_options)
      job_uses_options <= 1;
    else if (clear_job_uses_options)
      job_uses_options <= 0;
      
  end // !reset
  
end // always(@posedge clk)

always @(*)
begin
  case (dmagic_addr_sel_next)
    Addr_Src: begin
      dmagic_memory_access_address_next = dmagic_src_addr;
      dmagic_memory_access_io_next = dmagic_src_io;
    end
    Addr_Dst: begin
      dmagic_memory_access_address_next = dmagic_dst_addr;
      dmagic_memory_access_io_next = dmagic_dst_io;
    end
    Addr_List: begin
      dmagic_memory_access_address_next = dmagic_list_addr_next;
      dmagic_memory_access_io_next = 0;
    end
    Addr_PIO: begin
      dmagic_memory_access_address_next = dmagic_pio_addr;
      dmagic_memory_access_io_next = 0;
    end
  endcase
end

// We have a fast path for routing dmagic_read_data directly back to wdata so we can do
// back to back reads and writes on alternate cycles if the bus interface lets us.
always @(*)
begin
  if (dmagic_wdata_sel_read)
    dmagic_memory_access_wdata_next = dmagic_read_data;
  else
    dmagic_memory_access_wdata_next = dmagic_wdata_next;
end

always @(*)
begin
  if (increment_list_addr)
    dmagic_list_addr_next = dmagic_list_addr + 1;
  else
    dmagic_list_addr_next = dmagic_list_addr;
end

// Predecremented counter value.
assign dmagic_count_next = dmagic_count - 1;

always @(*)
begin

  // Default control signal states to prevent latches.
  dmagic_state_next = dmagic_state;
  dmagic_dma_req = 0;
  dmagic_cpu_req = 0;
  dmagic_io_ready = 1;
  dmagic_ack = 1;
  
  dmagic_addr_sel_next = Addr_Src;
  dmagic_data_op_next = Data_Idle;
  
  load_pio_base_addr0 = 0;
  load_pio_base_addr1 = 0;
  load_pio_base_addr2 = 0;
  load_pio_index = 0;
  load_pio = 0;
  increment_index = 0;

  load_src_addr0 = 0;
  load_src_addr1 = 0;
  load_src_addr2 = 0;
  update_src_addr = 0;

  load_dst_addr0 = 0;
  load_dst_addr1 = 0;
  load_dst_addr2 = 0;
  update_dst_addr = 0;
  
  load_list_addr0 = 0;
  load_list_addr1 = 0;
  load_list_addr2 = 0;
  increment_list_addr = 0;
  load_status = 0;
  
  list_counter_reset = 0;
  increment_list_counter = 0;

  load_cmd = 0;
  load_dir_cmd = 0;
  
  update_count = 0;
  load_count0 = 0;
  load_count1 = 0;
  
  dmagic_memory_access_write_next = 0;    

  set_job_is_f018a = 0;
  set_job_is_f018b = 0;
  
  clear_job_uses_options = 0;
  set_job_uses_options = 0;
  
  load_wdata_fill = 0;
  dmagic_wdata_sel_read = 0;
  
  load_srcdst_opts = 0;
  load_src_opts = 0;
  load_dst_opts = 0;
  load_wdata_bus = 0;
  start_job = 0;
  start_cpu_write = 0;
  start_cpu_read = 0;
  
  load_mod0 = 0;
  load_mod1 = 0;
  
  if (dmagic_io_cs && dmagic_io_ack) begin
    if (dmagic_io_address_next==8'h00 || dmagic_io_address_next==8'h05 || dmagic_io_address_next==8'h0E) begin
      load_list_addr0 = dmagic_io_write_next;
      dmagic_data_op_next = Data_List0;
      if (dmagic_io_write_next) begin
        if (dmagic_io_address_next==8'h00) begin
          clear_job_uses_options = 1;
          start_job = 1;
        end else if (dmagic_io_address_next==8'h05) begin
          set_job_uses_options = 1;
          start_job = 1;
        end
      end
    end else if (dmagic_io_address_next==8'h01) begin
      load_list_addr1 = dmagic_io_write_next;
      dmagic_data_op_next = Data_List1;
    end else if (dmagic_io_address_next==8'h02) begin
      load_list_addr2 = dmagic_io_write_next;
      dmagic_data_op_next = Data_List2;
    end else if (dmagic_io_address_next==8'h03) begin
      load_status = dmagic_io_write_next;
      dmagic_data_op_next = Data_Status;
    end else if (dmagic_io_address_next==8'h10) begin
      load_pio_base_addr0 = dmagic_io_write_next;
      dmagic_data_op_next = Data_Addr0;
    end else if (dmagic_io_address_next==8'h11) begin
      load_pio_base_addr1 = dmagic_io_write_next;
      dmagic_data_op_next = Data_Addr1;
    end else if (dmagic_io_address_next==8'h12) begin
      load_pio_base_addr2 = dmagic_io_write_next;
      dmagic_data_op_next = Data_Addr2;
    end else if (dmagic_io_address_next==8'h13) begin
      load_pio_index = dmagic_io_write_next;
      dmagic_data_op_next = Data_Index;
    end else if (dmagic_io_address_next==8'h14 || dmagic_io_address_next==8'h15) begin
      load_pio = 1;
      increment_index = dmagic_io_address_next[0];
      if (dmagic_io_write_next)
        start_cpu_write = 1;
      else
        start_cpu_read = 1;
    end
  end
      
  case (dmagic_state)
    DMAgic_Idle: begin
      if (start_job)
        dmagic_state_next = DMAgic_Start;
      else if (start_cpu_write)
        dmagic_state_next = DMAgic_CPUAccessWrite;
      else if (start_cpu_read)
        dmagic_state_next = DMAgic_CPUAccessRead;
      
      // During DMAgic_CPUAccessRead we are driving our output signals with the data we want.  We're waiting
      // to be told the data is available.  We also hold dmagic_io_ready low since the bus interface will sill be
      // feeding the CPU from FastIO (i.e. us) during this cycle and we don't have the data yet.
    end
    DMAgic_CPUAccessRead: begin
      dmagic_addr_sel_next = Addr_PIO;
      dmagic_io_ready = 0;
      dmagic_cpu_req = 1;
      if (dmagic_bus_ready) begin
        dmagic_cpu_req = 0; // Let CPU have the bus again (it should start driving our own address immediately
        dmagic_data_op_next = Data_Read;

        // If CPU has grabbed address bus again and is now sourcing from us again (or will on the next cycle), 
        // proceed directly to Ack state. Otherwise we need to go to DMAgic_CPUReadWait and wait for it to catch up.
        if (dmagic_io_cs && dmagic_io_ack)
          dmagic_state_next = DMAgic_CPUAccessAck;
        else
          dmagic_state_next = DMAgic_CPUAccessReadWait;

      end
    end
    
    DMAgic_CPUAccessReadWait: begin
      dmagic_addr_sel_next = Addr_PIO;
      dmagic_io_ready = 0;
      if (dmagic_io_cs && dmagic_io_ack)              // Wait for bus arbiter to direct control back to us
        dmagic_state_next = DMAgic_CPUAccessAck;
    end
    
    DMAgic_CPUAccessWrite: begin
      dmagic_addr_sel_next = Addr_PIO;
      dmagic_io_ready = 1;  // This is set to 1 to make this act like a posted write.
      dmagic_cpu_req = 1;
      dmagic_memory_access_write_next = 1;
      if (dmagic_bus_ready) begin
        dmagic_cpu_req = 0;                   // Drop bus request
        dmagic_state_next = DMAgic_CPUAccessAck;
      end
    end
    
    DMAgic_CPUAccessAck: begin
      if (dmagic_io_cs==0)  //- Wait for CPU to stop talking to us before we go idle so we can't accidentally trigger again.
        dmagic_state_next = DMAgic_Idle;
    end
    
    // Note: Some states currently don't hold dma_req high even though they probably should.   The reason they don't do it 
    // is mostly to work around the fact that the current bus interface hasn't fully implemented proper ready signal generation
    // that actually pays attention to whether or not the current bus master is actually doing a bus cycle or not.  If I drive
    // dma_req high but don't start a real bus cycle, I'll end up seeing ready set high as soon as I enter the read/write/fill
    // states, which then causes them to jump to the next state one cycle too early.   Once I fix the bus interface module (and
    // the dependent bus modules) to properly generate a ready signal based on there being a real access from the current bus
    // master, I can change the code below to just hold dma_req high for the whole operation.
    
    DMAgic_Start: begin
      //dmagic_dma_req = 1;
      list_counter_reset = 1;
      if (job_uses_options)
        dmagic_state_next = DMAgic_ReadOptions;
      else
        dmagic_state_next = DMAgic_ReadList;
    end
    
    DMAgic_ReadOptions: begin
      dmagic_dma_req = 1;
      dmagic_addr_sel_next = Addr_List;
      if (dmagic_bus_ready) begin
        increment_list_addr = 1;
        if (dmagic_read_data[7]) begin
          load_cmd = 1;    // This will get overwritten anyway, so I use it as temporary storage.
          dmagic_state_next = DMAgic_ReadOptionArgument;
        end else begin
          case (dmagic_read_data)
            8'h00:  dmagic_state_next = DMAgic_ReadList;
            8'h0A:  set_job_is_f018a = 1;
            8'h0B:  set_job_is_f018b = 1;
            default: ;
          endcase
        end
      end
    end
      
    DMAgic_ReadOptionArgument: begin
      dmagic_dma_req = 1;
      dmagic_addr_sel_next = Addr_List;
      if (dmagic_bus_ready) begin
        increment_list_addr = 1;
        dmagic_state_next = DMAgic_ReadOptions;
        
        case (dmagic_cmd)
          default: ;
        endcase
      end
    end
      
    DMAgic_ReadList: begin
      dmagic_dma_req = 1;
      dmagic_addr_sel_next = Addr_List;
      if (dmagic_bus_ready) begin
        increment_list_addr = 1;       // This starts driving the next address on the current cycle to line up with the counter update
        increment_list_counter = 1;    // that happens on the next cycle, and then holds both in sync until the bus is ready again.
        case (dmagic_list_counter)
          0: begin
            load_cmd = 1;
            if (job_is_f018b)
              load_dir_cmd = 1;
          end

          1: load_count0 = 1;
          2: load_count1 = 1;
          3: load_src_addr0 = 1;
          4: load_src_addr1 = 1;
          5: begin
            load_src_addr2 = 1;
            if (job_is_f018b == 0)
              load_src_opts = 1;
          end
          
          6: load_dst_addr0 = 1;
          7: load_dst_addr1 = 1;
          8: begin
            load_dst_addr2 = 1;
            if (job_is_f018b == 0)
              load_dst_opts = 1;
          end
          9: begin
            if (job_is_f018b == 0)
              load_mod0 = 1;
            else
              load_srcdst_opts = 1;
          end
          
          10: begin
            if (job_is_f018b == 0) begin
              load_mod1 = 1;
              dmagic_state_next = DMAgic_Dispatch;
            end else begin
              load_mod0 = 1;
            end
          end
          
          11: begin
            load_mod1 = 1;
            dmagic_state_next = DMAgic_Dispatch;
          end
          
          default: ;
        endcase        
      end
    end
      
    DMAgic_Dispatch: begin
      //dmagic_dma_req = 1;
      case (dmagic_cmd[1:0])
        2'b11: begin
            load_wdata_fill = 1;
            dmagic_state_next = DMAgic_Fill;
        end
        2'b00: begin // copy
          dmagic_state_next = DMAgic_CopyRead;
        end
        default: // nothing else implemented yet.
          dmagic_state_next = DMAgic_End;
      endcase
    end
      
    DMAgic_Fill: begin
      dmagic_dma_req = 1;
      dmagic_addr_sel_next = Addr_Dst;
      dmagic_memory_access_write_next = 1;
      if (dmagic_bus_ready) begin
        update_count = 1;
        update_dst_addr = 1;
        if (dmagic_count == 0) begin
          dmagic_state_next = DMAgic_End;
          dmagic_memory_access_write_next = 0;
        end
      end
    end
    
    DMAgic_CopyRead: begin
      dmagic_dma_req = 1;
      if (dmagic_bus_ready) begin
        update_src_addr = 1;
        load_wdata_bus = 1;  // Make copy of data in case there are write wait states.
        dmagic_addr_sel_next = Addr_Dst;          
        dmagic_memory_access_write_next = 1;
        dmagic_wdata_sel_read = 1; // Enable fast path for this cycle in case there aren't wait states...
        dmagic_state_next = DMAgic_CopyWrite;
      end
    end

    DMAgic_CopyWrite: begin
      dmagic_dma_req = 1;
      dmagic_addr_sel_next = Addr_Dst;          
      dmagic_memory_access_write_next = 1;
      if (dmagic_bus_ready) begin
        update_dst_addr = 1;
        update_count = 1;
        dmagic_addr_sel_next = Addr_Src;
        dmagic_memory_access_write_next = 0;
        if (dmagic_count_next == 0) begin
          dmagic_state_next = DMAgic_End;
          dmagic_memory_access_write_next = 0;
        end else begin
          dmagic_state_next = DMAgic_CopyRead;
        end
      end
    end
        
    DMAgic_End: begin
      //dmagic_dma_req = 1;
      if (dmagic_cmd[2]) begin
        dmagic_state_next = DMAgic_Start;
      end else begin
        dmagic_state_next = DMAgic_Idle;
      end
    end
    
    default:
        dmagic_state_next = DMAgic_Idle;
    
  endcase

end
  
endmodule

`SCHEM_KEEP_HIER module dmagic_addr_reg(input clk, input load_addr0, input load_addr1, input load_addr2, input update_addr, input load_opts_rdata, input [7:0] read_data,
                       input [1:0] mod_hold, input load_mod_hold, input load_dir, input dir, output reg [19:0] addr, output reg addr_io);

`DBG reg [19:0] addr_next;
`DBG reg addr_dir, addr_mod, addr_hold;

always @(posedge clk)
begin
  if (update_addr)
    addr <= addr_next;
  else begin
    if (load_addr0)
      addr[7:0] <= read_data;
    if (load_addr1)
      addr[15:8] <= read_data;
    if (load_addr2) begin
      addr[19:16] <= read_data[3:0];
      addr_io <= read_data[7];
    end
  end
  
  if (load_mod_hold) begin
    addr_mod     <= mod_hold[0];
    addr_hold    <= mod_hold[1];
  end else if (load_opts_rdata) begin
    addr_mod     <= read_data[5];
    addr_hold    <= read_data[4];
  end
  
  if (load_dir)
    addr_dir    <= dir;
  else if (load_opts_rdata)
    addr_dir    <= read_data[6];
  
end

always @(*)
begin
  if (addr_hold)
    addr_next = addr;
  else begin
    if (addr_dir==0)
      addr_next = addr + 1;
    else
      addr_next = addr - 1;
  end
end
                       
endmodule
