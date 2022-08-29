`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

// MUX 
module MUX(a, enable, y);
  input       a     ;
  input       enable;
  output reg  y     ;

  always@ (a or enable)
    if (enable == 1'b1)
      y = 1'bz;
    else
      y = a;

endmodule

// PIO Pads
module IO_Pad (pad_pwm_dout, pad_pwm_oen, pad_pwm_din, pad_io);
  output pad_pwm_dout            ;
  input  pad_pwm_oen, pad_pwm_din;
  inout  pad_io                  ;
  
  MUX U1(.a(pad_pwm_din), .enable(pad_pwm_oen), .y(pad_io));
  assign pad_pwm_dout = pad_io;
  
endmodule

module tb ();
//pwm
  // Clock/reset generation
  logic        clk           = 1'b0;
  logic        rstn          = 1'b0;
     
  logic       [2:0]  enable_i      ;
  logic       [31:0] prescaler_i   ;
  logic       [31:0] pwm_period_i  ;
  logic       [31:0] duty_cycle_i  ;

  wire        [2:0]  io            ;
  logic       [2:0]  pado_io       ;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

generate
  for (genvar i=0; i<2; i++)
  begin : pwm_iopad
  IO_Pad U0(.pad_pwm_dout(gpioi_din[i]), .pad_pwm_oen(gpioo_oen[i]), .pad_pwm_din(gpioo_dout[i]), .pad_io(io[i]));
  assign io[i] = pado_io[i];
  end
endgenerate
  
  top #(
    .rstn          (rstn               ),//: in  std_logic;
    .clk           (clk                ),//: in  std_logic;

    .enable_i      (enable_i           ),
    .prescaler_i   (prescaler_i        ),
    .pwm_period_i  (pwm_period_i       ),
    .duty_cycle_i  (duty_cycle_i       ),
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