`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

module tb ();
//pwm
  // Clock/reset generation
  logic        clk           = 1'b0;
  logic        rstn          = 1'b0;
     
  logic       [2:0]  enable_i      ;
  logic       [31:0] prescaler_i   ;
  logic       [31:0] pwm_period_i  ;
  logic       [31:0] duty_cycle_i  ;

  logic       [31:0] pwm_o         ;

  wire        [2:0]  io            ;
  logic       [2:0]  pado_io       ;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;
  
  top #()
  uut(
    .rstn          (rstn               ),//: in  std_logic;
    .clk           (clk                )//: in  std_logic;

    // .enable_i      (enable_i           ),
    // .prescaler_i   (prescaler_i        ),
    // .pwm_period_i  (pwm_period_i       ),
    // .duty_cycle_i  (duty_cycle_i       )
  );

initial begin
    logic   ok=1;
    apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD); 
    

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    apb.mst_tb.cyc_wait(50);
    $stop();
  end
endmodule // tb