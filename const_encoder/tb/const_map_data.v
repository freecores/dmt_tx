
module const_map_2bit;

`include "parameters.vh"

reg signed [CONSTW-1:0] re [0:3];
reg signed [CONSTW-1:0] im [0:3];


initial begin : init_2bit
  re[0] = 1; im[0] = 1;
  re[1] = 1; im[1] = -1;
  re[2] = -1; im[2] = 1;
  re[3] = -1; im[3] = -1;
end


endmodule
