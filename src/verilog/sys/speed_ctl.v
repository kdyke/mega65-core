// Mega65 CPU speed control module
//
// The basic idea here is to emulate slower clock speeds by modulating the CPU ready signal.

`define EN_MARK_DEBUG
`ifdef EN_MARK_DEBUG
`define MARK_DEBUG (* mark_debug = "true", dont_touch = "true" *)
`else
`define MARK_DEBUG
`endif

module m65_speed_ctrl(input clk, input force_fast, input speed_gate, input speed_gate_enable,
                      input vicii_2mhz, input viciii_fast, input viciv_fast,
                      input hypervisor_mode, `MARK_DEBUG input phi_special, output reg [7:0] cpuspeed,
                      input bus_ready, output reg cpu_ready, output wire phi0);

parameter cpufrequency = 28;
parameter pal1mhz_times_65536 = 64569;
parameter pal2mhz_times_65536 = 64569 * 2;
parameter pal3point5mhz_times_65536 = 225992;
parameter phi_fraction_01pal = pal1mhz_times_65536 / cpufrequency;
parameter phi_fraction_02pal = pal2mhz_times_65536 / cpufrequency;
parameter phi_fraction_04pal = pal3point5mhz_times_65536 / cpufrequency;

reg [16:0] phi_export_counter;
reg [16:0] phi_counter;
reg [16:0] phi_delta;

`MARK_DEBUG reg phi_en;
`MARK_DEBUG reg phi_step;
`MARK_DEBUG reg phi_step_toggle;
reg last_phi16;

assign phi0 = phi_export_counter[16];

always @(posedge clk)
begin
  phi_export_counter = phi_export_counter + phi_fraction_01pal;
  phi_counter = phi_counter + phi_delta;
end

always @(*)
begin
  case(cpuspeed)
    1: phi_delta = phi_fraction_01pal;
    2: phi_delta = phi_fraction_02pal;
    4: phi_delta = phi_fraction_04pal;
    default: phi_delta = 17'h10000;
  endcase
end

always @(posedge clk)
begin
  phi_counter <= phi_counter + phi_delta;
  last_phi16 <= phi_counter[16];
  phi_step_toggle <= ~phi_step_toggle;
end

always @(*)
begin
  if (cpuspeed != 8'h50) begin
    if (last_phi16 != phi_counter[16])
      phi_step = 1;
    else
      phi_step = 0;
  end else begin
    phi_step = 1;
  end
end

always @(*)
begin
  cpu_ready = bus_ready & phi_en;
end

always @(posedge clk)
begin

  // If phi_step is '1' on a clock edge then phi_en is asserted until the CPU can finish the next bus cycle (ready is asserted).
  // This lets us hide internal FPGA wait states while maintaining 1Mhz/3.5Mhz clock pacing.
  if (phi_special) begin  // 25Mhz
    if (phi_step_toggle) begin
      phi_en <= 1;
    end
  end else begin
    if (phi_step)
      phi_en <= 1;
  end

  if(cpu_ready) begin
    if (phi_special)
      phi_en <= phi_step_toggle;
    else
      phi_en <= phi_step;
  end  
end

reg [2:0] cpu_speed;

always @(posedge clk)
begin
  cpu_speed = {vicii_2mhz,viciii_fast,viciv_fast};
  
  if (hypervisor_mode==0 && (speed_gate==1) && (force_fast==0)) begin
    case(cpu_speed)
      3'b100: cpuspeed <= 8'h01; // 1Mhz
      3'b101: cpuspeed <= 8'h01; // 1Mhz
      3'b110: cpuspeed <= 8'h04; // 3.5Mhz
      3'b111: cpuspeed <= 8'h50; // 50Mhz (full speed)
      3'b000: cpuspeed <= 8'h02; // 2Mhz
      3'b001: cpuspeed <= 8'h50; // 50Mhz (full speed)
      3'b010: cpuspeed <= 8'h04; // 3.5Mhz
      3'b011: cpuspeed <= 8'h50; // 50Mhz (full speed)
      default: ;
    endcase
  end else begin
    cpuspeed <= 8'h50;
  end
end

endmodule
