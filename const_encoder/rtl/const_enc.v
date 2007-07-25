/* *****************************************************************
 *
 *  This file is part of the
 *  
 *  Tone Order and Constellation Encoder Core.
 *
 *  Description:
 *
 *  The conste_enc module implements the tone ordering and 
 *  constellation encoding as described in ITU G.992.1
 *  
 ********************************************************************* 
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

module const_encoder( 
                clk,
                reset,
                fast_ready_o,
                we_fast_data_i,
                fast_data_i,
                inter_ready_o,
                we_inter_data_i,
                inter_data_i,
                addr_i,
                we_conf_i,
                conf_data_i,
                xy_ready_o,
                carrier_num_o,
                x_o,
                y_o);


`include "parameters.vh"
              
//
// parameter
// 

input                 clk;
input                 reset;
output                fast_ready_o;
input                 we_fast_data_i;
input   [DW-1:0]      fast_data_i;
output                inter_ready_o;
input                 we_inter_data_i;
input   [DW-1:0]      inter_data_i;
input   [CONFAW-1:0]  addr_i;
input                 we_conf_i;
input   [CONFDW-1:0]  conf_data_i;
output                xy_ready_o;
output  [CNUMW-1:0]   carrier_num_o;
output  [CONSTW-1:0]  x_o;
output  [CONSTW-1:0]  y_o;



//
// local wire/regs
//
wire    [DW-1:0]      fast_data_o;
wire    [DW-1:0]      inter_data_o;

reg   [SHIFTW-1:0]    fast_shift_reg;
reg   [SHIFTW-1:0]    inter_shift_reg;
reg   [MAXBITNUM-1:0] const_input_reg;

reg   [CONFDW-1:0]    BitLoading [0:TABLELEN-1];
reg   [CONFDW-1:0]    CarrierNumber [0:TABLELEN-1];
reg   [USEDCREGW-1:0] UsedCarrier;
reg   [FBITSW-1:0]    FastBits;

//
// intantiate the fast path and interleaved path FIFOs
//
fifo  #(.AWIDTH(AW), .DWIDTH(DW))
      fifo_fast ( .clk(clk),
                  .reset(reset),
                  .empty_o(fast_empty_o),
                  .full_o(fast_full_o),
                  .one_available_o(fast_one_available_o),
                  .two_available_o(fast_two_available_o),
                  .we_i(we_fast_i),
                  .data_i(fast_data_i),
                  .re_i(re_fast_i),
                  .data_o(fast_data_o)
                  );

fifo  #(.AWIDTH(AW), .DWIDTH(DW))
      fifo_inter ( .clk(clk),
                  .reset(reset),
                  .empty_o(inter_empty_o),
                  .full_o(inter_full_o),
                  .one_available_o(inter_one_available_o),
                  .two_available_o(inter_two_available_o),
                  .we_i(we_inter_i),
                  .data_i(inter_data_i),
                  .re_i(re_inter_i),
                  .data_o(inter_data_o)
                  );

     
//
// configuration register access
//
always @(posedge clk or posedge reset) begin

  if(reset) begin
    UsedCarrier <= 0;
    FastBits <= 0;

  end
  else begin
    UsedCarrier <= 1;
  end
    
end



endmodule
