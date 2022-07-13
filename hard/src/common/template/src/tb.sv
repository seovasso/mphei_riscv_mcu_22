`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic           clk = 1'b0;
  logic           rstn = 1'b0;
  logic           d_i = 1'b1;
  logic           d_o;
  logic [31:0]    apb_rdata;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  // APB Interface
  apb_if    apb( .pclk(clk) );

  // Заглушка, пока нет APB slave
  assign apb.mst_tb.prdata  = 32'hDEAD_BEEF;
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;

  top uut(
    .clk_i (clk ),
    .rstn_i(rstn),

    .d_i   (d_i),
    .d_o   (d_o)
  );

  logic ok = 1;

  initial begin
    apb_rdata = 32'h0;
    apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);

    // APB transaction
    apb.mst_tb.cyc_wait(50);
    apb.mst_tb.write( 32'h0BAD_F00D, 32'h1234_5678, 4'hF );     // wite(data, addr(bytes), strb);
    apb.mst_tb.read( apb_rdata, 32'h1234_5678);                 // read(data, addr);

    if (d_o != 1'b1) ok = 0;

    d_i = 0;
    #(`CLK_PERIOD);
    if (d_o != 1'b0) ok = 0;

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    $stop();
  end
endmodule // tb
