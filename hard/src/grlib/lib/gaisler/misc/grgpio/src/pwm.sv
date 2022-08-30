module pwm (
    input              clk_i            ,
    input              rstn_i           ,
  
    output      [2:0]  pwm_o            ,

    // Configuration

    input const   [2:0]  enable_i       =1,
    input const   [31:0] prescaler_i    =682,
    input const   [31:0] pwm_period_i   =2048,
    input const   [31:0] duty_cycle_i   =1365  
);

  always_ff @(posedge clk_i or negedge rstn_i) begin : proc_d_o
    if(~rstn_i) begin
      d_o <= 0;
    end 
    else begin
      d_o <= d_i;
    end
  end

endmodule // pwm