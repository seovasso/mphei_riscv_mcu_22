`timescale 10ns/10ns

`define CLK_PERIOD 2
`define RESET_GOES_HIGH 15
`define TEST_CODE 0000_0005

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
  
  
  spi_wrap #(.syncram(0), .prot(0), .slvselen(1), .fdepth(3)) master(
  
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
    .slvsel_wrap (selectms)
  );
  
  spi_wrap #(.syncram(0), .prot(0), .slvselen(1), .fdepth(3)) slave(
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
    .spii_spisel (zero),
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
    .slvsel_wrap (selectsm)
  );
  
   logic [31:0] WIRE3;
   logic [31:0] BITRATE;
   logic [31:0] SPI_MODE;
   logic [31:0] hran = 32'h0000_0000;

        
 generate
    case (32'h`TEST_CODE)
    32'h0000_0000 : begin
        assign BITRATE = 100;
        assign SPI_MODE = 0;
        assign WIRE3 = 0;
    end
    32'h0000_0001 : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 0;
        assign WIRE3 = 0;
    end
    32'h0000_0002 : begin
        assign BITRATE = 2500;
        assign SPI_MODE = 0;
        assign WIRE3 = 0;
    end
    32'h0000_0003 : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 1;
        assign WIRE3 = 0;
    end
    32'h0000_0004 : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 2;
        assign WIRE3 = 0;
    end
    32'h0000_0005 : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 3;
        assign WIRE3 = 0;
    end 
    32'h0000_0006 : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 0;
        assign WIRE3 = 1;
    end
    default : begin
        assign BITRATE = 1000;
        assign SPI_MODE = 0;
        assign WIRE3 = 0;
        end
    endcase
  endgenerate
  
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
    
     case (BITRATE)
     32'd100 : begin
        assign hran = (hran | 1 << 16 | 1 << 17 | 1 << 18 | 1 << 27);
        end
        32'd1000 :begin 
            assign hran = (hran | 1 << 16 | 1 << 17 | 1 << 19);
        end
        32'd2500 :begin 
            assign hran = (hran | 1 << 13);
        end
        default: begin
            assign hran = (hran | 1 << 16 | 1 << 17 | 1 << 19);;
        end
      endcase

    if (SPI_MODE == 0) begin
        assign hran = (hran | 0 << 29 | 0 << 28);
    end else if (SPI_MODE == 1) begin
        assign hran = (hran | 0 << 29 | 1 << 28);
    end else if (SPI_MODE == 2) begin
        assign hran = (hran | 1 << 29 | 0 << 28);
    end else if (SPI_MODE == 3) begin
        assign hran = (hran | 1 << 29 | 1 << 28);
    end

    if (WIRE3 == 0) begin
        apb_slave.mst_tb.write(
        (hran | 1 << CM_EN | 0 << CM_MS), 32'h20); 
        apb.mst_tb.write( 
        (hran | 1 << CM_EN | 1 << CM_MS), 32'h20);   
    end
    if (WIRE3 == 1) begin
        apb_slave.mst_tb.write(
        (hran | 1 << CM_EN | 0 << CM_MS | 1 << 15), 32'h20); 
        apb.mst_tb.write( 
        (hran | 1 << CM_EN | 1 << CM_MS | 1 << 15), 32'h20);   
    end
    
    #1000 for (int i = 1; i <= 8; i++) begin
        apb.mst_tb.write($random, 32'h30); 
        apb_slave.mst_tb.write($random, 32'h30);
        if (i == 8)
            apb.mst_tb.write(32'h0000_0000 | 1 << 22, 32'h2C);
            apb_slave.mst_tb.write(32'h0000_0000 | 1 << 22, 32'h2C);
        apb.mst_tb.cyc_wait(200);
    end

  end
endmodule 
