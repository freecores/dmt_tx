/* *****************************************************************
 *
 *  This file is part of the
 *
 *   Tone Order and Constellation Encoder Core.
 *  
 *  Copyright (C) 2007 Guenter Dannoritzer
 *
 *   This source is free software; you can redistribute it
 *   and/or modify it under the terms of the 
 *             GNU General Public License
 *   as published by the Free Software Foundation; 
 *   either version 3 of the License,
 *   or (at your option) any later version.
 *
 *   This source is distributed in the hope 
 *   that it will be useful, but WITHOUT ANY WARRANTY;
 *   without even the implied warranty of MERCHANTABILITY
 *   or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the
 *   GNU General Public License along with this source.
 *   If not, see <http://www.gnu.org/licenses/>.
 *
 * *****************************************************************/

module tb_const_encoder();

parameter TW              = 10;

`include "parameters.vh"


reg                 clk;
reg                 reset;
wire                fast_ready_o;
reg                 we_fast_data_i;
reg   [DW-1:0]      fast_data_i;
wire                inter_ready_o;
reg                 we_inter_data_i;
reg   [DW-1:0]      inter_data_i;

reg                 we_conf_i;
reg   [CONFAW-1:0]  addr_i;
reg   [CONFDW-1:0]  conf_data_i;
wire  [CNUMW-1:0]   carrier_num_o;
wire  [CONSTW-1:0]  x_o;
wire  [CONSTW-1:0]  y_o;

//
// instantiate the DUT
// 
const_encoder dut ( .clk(clk),
                    .reset(reset),
                    .fast_ready_o(fast_ready_o),
                    .we_fast_data_i(we_fast_data_i),
                    .fast_data_i(fast_data_i),
                    .inter_ready_o(inter_ready_o),
                    .we_inter_data_i(we_inter_data_i),
                    .inter_data_i(inter_data_i),
                    .addr_i(addr_i),
                    .we_conf_i(we_conf_i),
                    .conf_data_i(conf_data_i),
                    .xy_ready_o(xy_ready_o),
                    .carrier_num_o(carrier_num_o),
                    .x_o(x_o),
                    .y_o(y_o));


initial begin
  clk = 0;
  we_fast_data_i = 0;
  we_inter_data_i = 0;
  we_conf_i = 0;
  reset = 0;
end

always begin
  #TW clk = ~clk;
end

//
// dump signals
//
initial begin
  $dumpfile("tb_const_enc.vcd");
  $dumpvars;
end


//
// main test
// 
                  
initial begin

  $monitor($time, " reset: ", reset);
  
  apply_reset;

  //
  // write configuration
  //
  write_config(BIT_LOAD_ST_ADR, 2);
  write_config(BIT_LOAD_ST_ADR+1, 3);
  write_config(BIT_LOAD_ST_ADR+2, 4);
  write_config(BIT_LOAD_ST_ADR+3, 5);

  write_config(C_NUM_ST_ADR,    48);
  write_config(C_NUM_ST_ADR+1,  49);
  write_config(C_NUM_ST_ADR+2,  50);
  write_config(C_NUM_ST_ADR+3,  51);
  
  
  write_config(USED_C_ADR, 4);
  write_config(F_BITS_ADR, 7);
  
  //
  // check written configuration
  //
  check_config(BIT_LOAD_ST_ADR,   2);
  check_config(BIT_LOAD_ST_ADR+1, 3);
  check_config(BIT_LOAD_ST_ADR+2, 4);
  check_config(BIT_LOAD_ST_ADR+3, 5);

  check_config(C_NUM_ST_ADR,    48);
  check_config(C_NUM_ST_ADR+1,  49);
  check_config(C_NUM_ST_ADR+2,  50);
  check_config(C_NUM_ST_ADR+3,  51);

  check_config(USED_C_ADR, 4);
  check_config(F_BITS_ADR, 7);
  
  #1000 $finish();

end // main test


// //////////////////////////////////////////////////////////////////// 
// 
// bus functional models
// 
// //////////////////////////////////////////////////////////////////// 

task apply_reset;
  begin
    reset = 0;
    #20
    reset = 1;
    @(posedge clk);
    reset = 0;
  end
endtask
  
//
// write data to the configuration registers
//
task write_config(input [CONFAW-1:0] addr, input[CONFDW-1:0] data);
  begin
    
    addr_i = addr;
    conf_data_i = data;
    @(negedge clk);
    we_conf_i = 1;
    @(negedge clk);
    we_conf_i = 0;
    
  end
endtask

//
// check the written configuration
//
task check_config(input [CONFAW-1:0] addr, input [CONFDW-1:0] exp_data);
  begin

    if(addr >= 0 && addr < C_NUM_ST_ADR) begin
    
      if(dut.BitLoading[addr] !== exp_data) begin
        $display("ERROR! => BitLoading does not match @ %x!", addr);  
        $display("          Got: %d expected: %d", 
                  dut.BitLoading[addr], exp_data);
      end
      
    end
    else if(addr >= C_NUM_ST_ADR && addr < USED_C_ADR) begin

      if(dut.CarrierNumber[addr-C_NUM_ST_ADR] !== exp_data) begin
        $display("ERROR! => CarrierNumber does not match @ %x!", addr);  
        $display("          Got: %d expected: %d", 
                  dut.CarrierNumber[addr-C_NUM_ST_ADR], exp_data);
      end
      
    end
    else if(addr == USED_C_ADR) begin
      
      if(dut.UsedCarrier !== exp_data) begin
        $display("ERROR! => UsedCarrier does not match @ %x!", addr);  
        $display("          Got: %d expected: %d", 
                  dut.UsedCarrier, exp_data);
      end
    
    end
    else if(addr == F_BITS_ADR) begin
      
      if(dut.FastBits !== exp_data) begin
        $display("ERROR! => FastBits does not match @ %x!", addr);  
        $display("          Got: %d expected: %d", 
                  dut.FastBits, exp_data);
      end

    end
  end
endtask


endmodule
