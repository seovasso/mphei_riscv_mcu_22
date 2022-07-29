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
  logic           zero = 1'b0;
  logic           one = 1'b1;
  
  
  logic [31:0]    apb_prdata_slave;
  logic [31:0]    apb_pwdata_slave;
  logic [31:0]    apb_paddr_slave;

    
  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  // APB Interface
  apb_if    apb( .pclk(clk) );
  apb_if    apb_slave( .pclk(clk) );
  
  // Master
  assign apb.mst_tb.prdata  = apb_prdata;
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  assign apb_psel           = apb.mst_tb.psel;
  assign apb_penable        = apb.mst_tb.penable;
  assign apb_pwrite         = apb.mst_tb.pwrite;
  assign apb_pwdata         = apb.mst_tb.pwdata;
  assign apb_paddr          = apb.mst_tb.paddr;
  
  assign apb_slave.mst_tb.prdata  = apb_prdata_slave;
  assign apb_slave.mst_tb.pready  = 1'b1;
  assign apb_slave.mst_tb.pslverr = 1'b0;
  assign apb_psel_slave           = apb_slave.mst_tb.psel;
  assign apb_penable_slave        = apb_slave.mst_tb.penable;
  assign apb_pwrite_slave         = apb_slave.mst_tb.pwrite;
  assign apb_pwdata_slave         = apb_slave.mst_tb.pwdata;
  assign apb_paddr_slave          = apb_slave.mst_tb.paddr;
  
  wire miso;
  wire mosi;
 
  wire mosi2;
  wire miso2;
  wire clkgen;
  wire clkgen2;
  
  wire selectms;
  wire selectsm;
  
  spi_wrap #(.syncram(0), .twen(0), .prot(0), .slvselen(1)) master(
  
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
    .spii_miso   (miso),
    .spii_mosi   (mosi2),
    .spii_sck    (clkgen2),
    .spii_spisel (selectsm),
    .spii_astart (zero),
    .spii_cstart (zero),
    .spii_ignore (one),
    .spii_io2    (zero),
    .spii_io3    (zero),
    .spio_miso   (miso2),
    .spio_misooen(),
    .spio_mosi   (mosi),
    .spio_mosioen(),
    .spio_sck    (clkgen),
    .spio_sckoen (),
    .spio_enable (),
    .spio_astart (),
    .spio_aready (),
    .spio_io2    (),
    .spio_io2oen (),
    .spio_io3    (),
    .spio_io3oen (),
    .slvsel      (selectms)
  );
  
  spi_wrap #(.syncram(0), .twen(0), .prot(0), .slvselen(1)) slave(
  
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
    .spii_miso   (miso2),
    .spii_mosi   (mosi),
    .spii_sck    (clkgen),
    .spii_spisel (selectms),
    .spii_astart (zero),
    .spii_cstart (zero),
    .spii_ignore (one),
    .spii_io2    (zero),
    .spii_io3    (zero),
    .spio_miso   (miso),
    .spio_misooen(),
    .spio_mosi   (mosi2),
    .spio_mosioen(),
    .spio_sck    (clkgen2),
    .spio_sckoen (),
    .spio_enable (),
    .spio_astart (),
    .spio_aready (),
    .spio_io2    (),
    .spio_io2oen (),
    .spio_io3    (),
    .spio_io3oen (),
    .slvsel      (selectsm)
  );
  
  initial begin
    localparam CM_EN = 24;
    localparam CM_MS = 25;
    localparam CM_ASEL = 14;
    localparam CC_LST = 22;
    localparam CE_LT = 14;
    localparam CM_REV = 26;
    localparam PM = 16;
    apb.mst_tb.init;
    apb_slave.mst_tb.init;
    
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);
    
    apb_slave.mst_tb.write(
    (32'h0000_0000 | 1 << CM_EN | 0 << CM_MS | 1 << PM), 32'h20); 
    apb.mst_tb.write( 
    (32'h0000_0000 | 1 << CM_EN | 1 << CM_MS | 1 << PM), 32'h20); 
    apb.mst_tb.write( 
    (32'hFFFF_FFFF), 32'h38); 
    apb_slave.mst_tb.write( 
    (32'hFFFF_FFFF), 32'h38);     
    
    apb.mst_tb.cyc_wait(20);
    apb.mst_tb.write( 32'h12132431, 32'h30); 
    apb_slave.mst_tb.write( 32'h1700, 32'h30);
    apb.mst_tb.read( apb_prdata, 32'h34);
    //apb.mst_tb.cyc_wait(60);
    //apb_slave.mst_tb.read( apb_prdata_slave, 32'h34);
    //apb.mst_tb.write( 32'h2343_2332, 32'h30); 
    //apb.mst_tb.cyc_wait(200);
    //apb_slave.mst_tb.write( 32'h212_21, 32'h30); 

  end
  
endmodule // tb
