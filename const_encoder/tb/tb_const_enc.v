/* *****************************************************************
 *
 *  This file is part of Tone Order and Constellation Encoder Core.
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
 *   GNU General Public License along with this program.
 *   If not, see <http://www.gnu.org/licenses/>.
 *
 * *****************************************************************/

module tb_const_encoder();

reg   clk;
reg   reset;
wire  input_ready_o;
reg   we_data_i;


//
// instantiate the DUT
// 
const_encoder dut ( .clk(clk),
                    .reset(reset),
                    .input_ready_o(input_ready_o),
                    .we_data_i(we_data_i),
                    .data_i(data_i),
                    .addr_i(addr_i),
                    .we_conf_i(we_conf_i),
                    .conf_data_i(conf_data_i),
                    .xy_ready_o(xy_ready_o),
                    .bin_num_o(bin_num_o),
                    .x_o(x_o),
                    .y_o(y_o));


                  
initial begin

  $monitor($time, " clk: ", clk, " reset: ", reset);
  
  clk   = 0;
  reset = 0;

  #50 reset = 1;
  #50 reset = 0;

  #1000 $finish();

end
  



endmodule
