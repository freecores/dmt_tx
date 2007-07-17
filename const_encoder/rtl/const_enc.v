

module const_encoder( 
                clk,
                reset,
                input_ready_o,
                we_data_i,
                data_i,
                addr_i,
                we_conf_i,
                conf_data_i,
                xy_ready_o,
                bin_num_o,
                x_o,
                y_o);

input   clk;
input   reset;
output  input_ready_o;
input   we_data_i;
input   data_i;
input   addr_i;
input   we_conf_i;
input   conf_data_i;
output  xy_ready_o;
output  bin_num_o;
output  x_o;
output  y_o;



endmodule
