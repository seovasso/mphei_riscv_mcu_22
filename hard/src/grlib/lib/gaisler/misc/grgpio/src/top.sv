// MUX 
module MUX(a, enable, y);
  input       a     ;
  input       enable;
  output reg  y     ;

  always@ (a or enable)
    if (enable == 1'b0)
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

module top (
  input              clk_i             ,
  input              rstn_i            ,

  output  logic    [2:0]  pwm_io                 
);

  logic       [2:0]  enable_i     =8'b111   ;
  logic  [2:0][31:0] prescaler_i  ={0,0,0};
  logic  [2:0][31:0] pwm_period_i ={32'd255,32'd255,32'd255};
  logic  [2:0][31:0] duty_cycle_i ={32'd32,32'd64,32'd5};

  wire        [2:0]  io                ;
  wire        [2:0]  in_pad            ;
  logic       [2:0]  pwm_o           ;

generate
  for (genvar i=0; i<3; i++)begin : pwm_iopad
  IO_Pad U0(.pad_pwm_dout(in_pad[i]), .pad_pwm_oen(enable_i[i]), .pad_pwm_din(pwm_o[i]), .pad_io(io[i]));
  assign pwm_io[i] = io[i];
  end
endgenerate

pwm #()
uut(
  .clk_i       (clk_i       ),
  .rstn_i      (rstn_i      ),

  .pwm_o       (pwm_o       ),

  // Configuration

  .enable_i    (enable_i    ),
  .prescaler_i (prescaler_i ),
  .pwm_period_i(pwm_period_i),
  .duty_cycle_i(duty_cycle_i)
);

endmodule // top