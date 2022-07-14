module top (

  input        clk_i,
  input        rstn_i,

  input        d_i,
  output logic d_o
);

  always_ff @(posedge clk_i or negedge rstn_i) begin : proc_d_o
    if(~rstn_i) begin
      d_o <= 0;
    end 
    else begin
      d_o <= d_i;
    end
  end

endmodule // top