`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb  ();

  // Clock/reset generation
  logic           clk = 1'b0;
  logic           rstn = 1'b0;
  logic [31:0]    apb_prdata;
  logic [31:0]    apb_pwdata;
  logic [31:0]    apb_paddr;
  logic           spisel = 1'b1;
  logic           zero = 1'b0;
  logic           one = 1'b1;
  
  logic [31:0]    apb_prdata_slave;
  logic [31:0]    apb_pwdata_slave;
  logic [31:0]    apb_paddr_slave;
  
  
  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  apb_if    apb( .pclk(clk) );
  assign apb.mst_tb.prdata  = apb_prdata;
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  assign apb_psel           = apb.mst_tb.psel;
  assign apb_penable        = apb.mst_tb.penable;
  assign apb_pwrite         = apb.mst_tb.pwrite;
  assign apb_pwdata         = apb.mst_tb.pwdata;
  assign apb_paddr          = apb.mst_tb.paddr;
  
  assign apb.slv_tb.paddr   = apb_prdata_slave;
  assign apb.slv_tb.penable = apb_penable_slave;
  assign apb.slv_tb.pwrite  = apb_pwrite_slave;
  assign apb.slv_tb.pwdata  = apb_pwdata_slave;
  assign apb.slv_tb.psel    = apb_psel_slave;
  assign apb.slv_tb.pstrb   = 1'b0;
  assign apb.slv_tb.pprot   = 1'b0;
  assign apb_pready_slave   = apb.slv_tb.pready;
  assign apb_prdata_slave   = apb.slv_tb.prdata;
  assign apb_pslverr_slave  = apb.slv_tb.pslverr;
 
  spi_wrap #(.syncram(0)) master(
  
    .clk (clk ) ,
    .rstn(rstn) ,
    .apbi_psel   (apb_psel),
    .apbi_penable(apb_penable),
    .apbi_paddr  (apb_paddr),
    .apbi_pwrite (apb_pwrite),
    .apbi_pwdata (apb_pwdata),
    .apbi_testen (),
    .apbi_testrst(),
    .apbi_scanen (),
    .apbi_testoen(),
    .apbo_prdata (apb_prdata),
    .apbo_pirq   (),
    .spii_miso   (),
    .spii_mosi   (zero),
    .spii_sck    (clk),
    .spii_spisel (spisel),
    .spii_astart (zero),
    .spii_cstart (zero),
    .spii_ignore (one),
    .spii_io2    (zero),
    .spii_io3    (zero),
    .spio_miso   (spio_miso),
    .spio_misooen(),
    .spio_mosi   (spio_mosi),
    .spio_mosioen(),
    .spio_sck    (),
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
  
  spi_wrap #(.syncram(0), .twen(0), .prot(1)) slave(
  
    .clk (clk ) ,
    .rstn(rstn) ,
    .apbi_psel   (apb_psel_slave),
    .apbi_penable(apb_penable_slave),
    .apbi_paddr  (apb_paddr_slave),
    .apbi_pwrite (apb_pwrite_slave),
    .apbi_pwdata (apb_pwdata_slave),
    .apbi_testen (),
    .apbi_testrst(),
    .apbi_scanen (),
    .apbi_testoen(),
    .apbo_prdata (apb_prdata_slave),
    .apbo_pirq   (),
    .spii_miso   (spio_miso),
    .spii_mosi   (spio_mosi),
    .spii_sck    (clk),
    .spii_spisel (spisel),
    .spii_astart (zero),
    .spii_cstart (zero),
    .spii_ignore (one),
    .spii_io2    (zero),
    .spii_io3    (zero),
    .spio_miso   (),
    .spio_misooen(),
    .spio_mosi   (),
    .spio_mosioen(),
    .spio_sck    (),
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
  
    localparam CM_EN = 24;
    localparam CM_MS = 25;
    localparam CM_ASEL = 14;
    localparam CM_TW = 15;
    apb.mst_tb.init;

    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);
    
    apb.mst_tb.cyc_wait(20);
    apb.slv_tb.write( 
    (32'h0000_0000 | 1 << CM_EN | 1 << CM_ASEL | 1 << CM_TW)
    ,32'h20); 
    apb.mst_tb.write( 
    (32'h0000_0000 | 1 << CM_EN | 1 << CM_MS | 1 << CM_ASEL | 1 << CM_TW)
    ,32'h20); 
    
    // Master's problems
    apb.mst_tb.cyc_wait(20);
    apb.mst_tb.write( 32'h2421980, 32'h30);     
    
    // Slave's problems
    
    apb.mst_tb.read(apb_prdata_slave, 32'h34);
    
   // apb.mst_tb.read( apb_prdata_master, 32'h00); 
  end
  
endmodule // tb
