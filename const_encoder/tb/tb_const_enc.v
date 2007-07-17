

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
