`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic clk = 1'b0;
  logic rstn = 1'b0;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  top uut(
    .clk_i (clk ),
    .rstn_i(rstn),

    .d_i   (1'b1),
    .d_o   () 
  );


endmodule // tb