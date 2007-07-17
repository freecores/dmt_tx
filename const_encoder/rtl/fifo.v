
module fifo(
          clk,
          reset,
          empty_o,
          full_o,
          one_available_o,
          two_available_o,
          we_i,
          data_i,
          re_i,
          data_o);

parameter DWIDTH = 8;
parameter AWIDTH = 4;
        
input                 clk;
input                 reset;
output                empty_o;
output                full_o;
output                one_available_o;
output                two_available_o;
input                 we_i;
input   [DWIDTH-1:0]  data_i;
input                 re_i;
output  [DWIDTH-1:0]  data_o;




//
// local reg/wires
// 
reg [AWIDTH-1:0]  read_ptr;
reg [AWIDTH-1:0]  write_ptr;
reg [AWIDTH:0]    fill_ctr;

wire              dp_we_i;
wire              dp_re_i;

//
// instantiate the dual port ram
//
generic_dpram #(.aw(AWIDTH),
                .dw(DWIDTH)
               )
              dpram ( .rclk(clk),
                      .rrst(reset),
                      .rce(ce),
                      .oe(dp_re_i),
                      .raddr(read_ptr),
                      .do(data_o),
                    
                      .wclk(clk),
                      .wrst(reset),
                      .wce(ce),
                      .we(dp_we_i),
                      .waddr(write_ptr),
                      .di(data_i));


//
// control logic
// 
assign ce = 1'b1;

assign one_available_o = (fill_ctr > 1'b0) ? 1'b1 : 1'b0;
assign two_available_o = (fill_ctr > 1'b1) ? 1'b1 : 1'b0;
assign empty_o = |fill_ctr ? 1'b0 : 1'b1;
assign full_o = fill_ctr[AWIDTH] ? 1'b1 : 1'b0;

// make sure a write only happens to dp_ram when not full
assign dp_we_i = ~full_o ? we_i : 1'b0;
// make sure a read only happens to the dp_ram when not empty
assign dp_re_i = ~empty_o ? re_i : 1'b0;

//
// fill counter
// 
always @(posedge clk or posedge reset) begin
  if(reset) begin
    fill_ctr <= 0;
  end
  else begin
    if(dp_we_i) begin
      fill_ctr <= fill_ctr + 1;
    end

    if(dp_re_i) begin
      fill_ctr <= fill_ctr - 1;
    end
  end
end

// 
// read pointer
// 
always @(posedge clk or posedge reset) begin
  if(reset) begin
    read_ptr <= 0;
  end
  else begin
    if(dp_re_i) begin
      read_ptr <= read_ptr + 1;
    end
  end
end

// 
// write pointer
//
always @(posedge clk or posedge reset) begin
  if(reset) begin
    write_ptr <= 0;
  end
  else begin
    if(dp_we_i) begin
      write_ptr <= write_ptr + 1;
    end
  end
end


endmodule
