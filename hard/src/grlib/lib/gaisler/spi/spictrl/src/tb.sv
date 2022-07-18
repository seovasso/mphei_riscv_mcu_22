`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic           clk = 1'b0;
  logic           rstn = 1'b0;
  logic [31:0]    apb_prdata_master;
  logic [31:0]    apb_pwdata_master;
  logic [31:0]    apb_paddr_master;
  logic           astart = 1'b0;
  logic           cstart = 1'b0;
  logic           ignore = 1'b0;
  logic           io2 = 1'b0;
  logic           io3 = 1'b0;
  logic [31:0]    apb_prdata_slave;
  logic [31:0]    apb_pwdata_slave;
  logic [31:0]    apb_paddr_slave;
  
  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  // APB Interface
  apb_if    apb( .pclk(clk) );

  // Заглушка, пока нет APB slave
  assign apb.mst_tb.prdata  = apb_prdata_master;
  assign apb.mst_tb.prdata  = apb_prdata_slave;
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  assign apb_psel           = apb.mst_tb.psel;
  assign apb_penable        = apb.mst_tb.penable;
  assign apb_pwrite         = apb.mst_tb.pwrite;
  assign apb_pwdata         = apb.mst_tb.pwdata;
  assign apb_paddr          = apb.mst_tb.paddr;

 
  spi_wrap master(
  
    .clk (clk ) ,
    .rstn(rstn) ,
    .apbi_psel   (apb_psel),
    .apbi_penable(apb_penable),
    .apbi_paddr  (apb_paddr_master),
    .apbi_pwrite (apb_pwrite_master),
    .apbi_pwdata (apb_pwdata_master),
    .apbi_testen (),
    .apbi_testrst(),
    .apbi_scanen (),
    .apbi_testoen(),
    .apbo_prdata (apb_prdata_master),
    .apbo_pirq   (),
    .spii_miso   (spii_miso_master),
    .spii_mosi   (spii_mosi_master),
    .spii_sck    (clk),
    .spii_spisel (spiselect),
    .spii_astart (astart),
    .spii_cstart (cstart),
    .spii_ignore (ignore),
    .spii_io2    (io2),
    .spii_io3    (io3),
    .spio_miso   (spio_miso_master),
    .spio_misooen(),
    .spio_mosi   (spio_mosi_master),
    .spio_mosioen(),
    .spio_sck    (clk),
    .spio_sckoen (),
    .spio_enable (),
    .spio_astart (),
    .spio_aready (),
    .spio_io2    (),
    .spio_io2oen (),
    .spio_io3    (),
    .spio_io3oen (),
    .slvsel      ()
  );

  spi_wrap slave(
    .clk (clk ) ,
    .rstn(rstn) ,
    .apbi_psel   (apb_psel),
    .apbi_penable(apb_penable),
    .apbi_paddr  (apb_paddr_slave),
    .apbi_pwrite (apb_pwrite_slave),
    .apbi_pwdata (apb_pwdata_slave),
    .apbi_testen (),
    .apbi_testrst(),
    .apbi_scanen (),
    .apbi_testoen(),
    .apbo_prdata (apb_prdata_slave),
    .apbo_pirq   (),
    .spii_miso   (spio_miso_master),
    .spii_mosi   (spio_mosi_master),
    .spii_sck    (clk),
    .spii_spisel (spiselect),
    .spii_astart (astart),
    .spii_cstart (cstart),
    .spii_ignore (ignore),
    .spii_io2    (io2),
    .spii_io3    (io3),
    .spio_miso   (spio_miso),
    .spio_misooen(),
    .spio_mosi   (spio_mosi),
    .spio_mosioen(),
    .spio_sck    (clk),
    .spio_sckoen (),
    .spio_enable (),
    .spio_astart (),
    .spio_aready (),
    .spio_io2    (),
    .spio_io2oen (),
    .spio_io3    (),
    .spio_io3oen (),
    .slvsel      ()
  );

  initial begin

    apb.mst_tb.init;
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);

   // APB transaction
    apb.mst_tb.cyc_wait(20);
     apb.mst_tb.read( apb_prdata, 32'h00);
    apb.mst_tb.write( 32'h20000, 32'h00);     // wite(data, addr(bytes)
    apb.mst_tb.read( apb_prdata, 32'h00); 
  end
  
endmodule // tb
