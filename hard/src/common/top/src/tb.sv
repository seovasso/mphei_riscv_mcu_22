`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic clk = 1'b0;
  logic rstn = 1'b1;
  logic d_i  = 1'b1;
  logic d_o;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b0;
  initial begin
    #200 d_i = 1'b0;
  end

  top uut(
    .clk_i (clk ),
    .rstn_i(rstn),

    .d_i   (d_i),
    .d_o   (d_o) 
  );


endmodule // tb