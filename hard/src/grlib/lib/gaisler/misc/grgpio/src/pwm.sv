module pwm (
    input              clk_i       ,
    input              rstn_i      ,
  
    output logic[2:0]  pwm_o       ,

    // Configuration

    input       [2:0]  enable_i    ,
    input  [2:0][31:0] prescaler_i ,
    input  [2:0][31:0] pwm_period_i,
    input  [2:0][31:0] duty_cycle_i
  );

    logic [2:0][31:0] counter;

generate
    for (genvar i=0; i<3; i++)begin: pwm
    
        always_ff @(posedge clk_i or negedge rstn_i) begin : proc_counter
        if(~rstn_i) begin
            counter[i]<=0;
        end 
        else begin
            if (enable_i[i]==1) begin
                if (counter[i]<pwm_period_i[i])
                counter[i]++;
                else
                counter[i]<=0;
            end       
            else begin
                counter[i]<=0;
            end
        end
      end
      
      always @(posedge clk_i or negedge rstn_i) begin : proc_pwm
        if(~rstn_i) begin
            pwm_o[i]<=0;
        end 
        else begin
            if (counter[i]<duty_cycle_i[i])
            pwm_o[i]<=0;
            else
            pwm_o[i]<=1;
        end
      end
    
    end
endgenerate

endmodule // pwm