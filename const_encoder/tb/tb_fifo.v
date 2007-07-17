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
module tb_fifo;

parameter AWIDTH = 2;
parameter DWIDTH = 8;
parameter TW=10;



//
// to interface the dut
// 
reg                 clk;
reg                 reset;
reg   [DWIDTH-1:0]  data_i;
reg                 re_i;
wire                empty_o;
wire                full_o;
wire                one_available_o;
wire                two_available_o;
reg                 we_i;
reg   [DWIDTH-1:0]  data_i;
reg                 re_i;
wire  [DWIDTH-1:0]  data_o;



//
// instantiate the DUT
//
fifo #(.AWIDTH(AWIDTH), .DWIDTH(DWIDTH))

      dut ( .clk(clk),
            .reset(reset),
            .empty_o(empty_o),
            .full_o(full_o),
            .one_available_o(one_available_o),
            .two_available_o(two_available_o),
            .we_i(we_i),
            .data_i(data_i),
            .re_i(re_i),
            .data_o(data_o));
          

//
// local reg/wires
//
reg [DWIDTH-1:0] got_data;

//
// main tests
// 
          
initial begin
  clk = 0;
  we_i = 0;
  re_i = 0;
  reset = 0;
end

always begin
  #TW clk = ~clk;
end

//
// dump signals
//
initial begin
  $dumpfile("tb_fifo.vcd");
  $dumpvars;
end


initial begin
  $display("Verifing FIFO");

  test_reset;
  check_control(5'b0001);

  write_data(8'haa);
  check_control(5'b0100);

  read_data(got_data);
  check_result(got_data, 8'haa);
  check_control(5'b0001);
  
  // fifo is empty again
  
  // fill it and only expect after the 4th write a full signal
 
  // #1
  write_data(8'h70);
  check_control(5'b0100);
  // #2
  write_data(8'h71);
  check_control(5'b1100);
  // #3
  write_data(8'h72);
  check_control(5'b1100);
  // #4
  write_data(8'h73);
  check_control(5'b1110);
  // fifo full, should not get written
  write_data(8'hab);
  check_control(5'b1110);

  // #1  
  read_data(got_data);
  check_result(got_data, 8'h70);
  check_control(5'b1100);
  // #2  
  read_data(got_data);
  check_result(got_data, 8'h71);
  check_control(5'b1100);
  // #3  
  read_data(got_data);
  check_result(got_data, 8'h72);
  check_control(5'b0100);
  // #4  
  read_data(got_data);
  check_result(got_data, 8'h73);
  check_control(5'b0001);

  //
  // Now test a read/write at the same clock
  //

  //
  // First have one entry in the FIFO and do a read/write
  //

  //
  // Now have an empty FIFO and do the read/write
  //
  
  //
  // Finally fill up the FIFO and to the read/write
  //

  $finish();

end




// =====================================================================
// bus functional models
//
task test_reset;
  begin
  $display("Testing reset");
  reset = 0;
  #10 reset = 1;
  #20 reset = 0;
  
end
endtask


// =====================================================================
// check the expected control line status
//
// exp_ctrl[4:0] == {two_available, one_available, full, empty}
//
task check_control(input [4:0]exp_ctrl);
  begin
  
    $display("# %d expCtrl: %d", $time, exp_ctrl);
  
  if(empty_o !== exp_ctrl[0])
    $display("ERROR! => Expected empty_o == %d, got %d", exp_ctrl[0], empty_o);
  
  if(full_o !== exp_ctrl[1])
    $display("ERROR! => Expected full_o == %d, got %d", exp_ctrl[1], full_o);

  if(one_available_o !== exp_ctrl[2])
    $display("ERROR! => Expected one_available_o == %d, got %d", exp_ctrl[3], one_available_o);
  
  if(two_available_o !== exp_ctrl[3])
    $display("ERROR! => Expected two_available_o == %d, got %d", exp_ctrl[4], two_available_o);

  end
endtask


// =====================================================================
//
// write data to the fifo
// 
task write_data(input [DWIDTH-1:0]data);
  begin
    $display("# %d Writing data", $time);
    @(negedge clk);
    data_i = data;
    we_i = 1;
    @(negedge clk);
    we_i = 0;

  end
endtask

// =====================================================================
//
// read data from the fifo
// 
// 
task read_data(output [DWIDTH-1:0]data);
  begin

    $display("# %d Reading data", $time);
    @(negedge clk);
    re_i = 1;
    @(negedge clk);
    data = data_o;
    re_i = 0;

  end
endtask


// =====================================================================
//
// check result
// 
// 
task check_result(input [DWIDTH-1:0]got, input [DWIDTH-1:0]expected);
  begin
    if(got !== expected)
      $display("ERROR! => Result does not match! Got: %d (%x) expected: %d (%x)", got, got, expected, expected);
  end
endtask

endmodule

