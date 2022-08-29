module top (
    input              clk_i          ,
    input              rstn_i         ,

    output      [2:0]  pwm_o          ,
);

pwm #(
    .clk_i (clk_i ),
    .rstn_i(rstn_i),

    .pwm_o (pwm_o),

    // Configuration

    .enable_i    (enable_i    ),
    .prescaler_i (prescaler_i ),
    .pwm_period_i(pwm_period_i),
    .duty_cycle_i(duty_cycle_i)
)

endmodule // top