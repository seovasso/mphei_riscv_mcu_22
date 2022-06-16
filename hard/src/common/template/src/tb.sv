`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic clk = 1'b0;
  logic rstn = 1'b0;
  logic d_i = 1'b1;
  logic d_o;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  top uut(
    .clk_i (clk ),
    .rstn_i(rstn),

    .d_i   (d_i),
    .d_o   (d_o)
  );

  logic ok = 1;
  initial begin
    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);


    if (d_o != 1'b1) ok = 0;

    d_i = 0;
    #(`CLK_PERIOD);
    if (d_o != 1'b0) ok = 0;

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    $stop();
  end
endmodule // tb
