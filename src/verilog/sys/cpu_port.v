//`define EN_MARK_DEBUG
`ifdef EN_MARK_DEBUG
`define MARK_DEBUG (* mark_debug = "true", dont_touch = "true" *)
`else
`define MARK_DEBUG
`endif

module cpu_port(input clk, input reset, input ready, 
                `MARK_DEBUG input cs, `MARK_DEBUG input addr, `MARK_DEBUG input bus_write, `MARK_DEBUG input [7:0] data_i, 
                `MARK_DEBUG output reg [7:0] data_o, `MARK_DEBUG output reg cpuport_ready,
                `MARK_DEBUG output reg [7:0] cpuport_ddr, `MARK_DEBUG output reg [7:0] cpuport_value);

reg load_ddr;
reg load_value;

always @(posedge clk)
begin
  if(reset)
    cpuport_ddr <= 8'hFF;
  else if(load_ddr)
    cpuport_ddr <= data_i;
  
  if(reset)
    cpuport_value <= 8'h3F;
  else if(load_value)
    cpuport_value <= data_i;
end

always @(posedge clk)
begin
  case(addr)
    0: data_o <= cpuport_ddr;
    1: data_o <= cpuport_value;
  endcase
  cpuport_ready <= cs;
end

always @(*)
begin
  load_ddr = 0;
  load_value = 0;
  
  if(cs & ready & bus_write) begin
    case(addr)
      0: load_ddr = 1;
      1: load_value = 1;
    endcase
  end
end

endmodule