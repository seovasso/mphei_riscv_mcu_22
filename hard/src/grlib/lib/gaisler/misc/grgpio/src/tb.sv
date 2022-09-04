`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

module tb ();
//pwm
  // Clock/reset generation
  logic        clk_i           = 1'b0;
  logic        rstn_i          = 1'b0;

  logic  [2:0] pwm_io         ;

  always #(`CLK_PERIOD/2) clk_i = !clk_i;
  initial #(`RESET_GOES_HIGH) rstn_i = 1'b1;
  
  top #()
  uut(
    .rstn_i          (rstn_i               ),//: in  std_logic;
    .clk_i           (clk_i                ),//: in  std_logic;

    .pwm_io          (pwm_io               )
  );

initial begin
    logic   ok=1;
    //apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD); 
    

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    //apb.mst_tb.cyc_wait(50);
    $stop();
  end
endmodule // tb