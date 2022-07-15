`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();

  // Clock/reset generation
  logic clk = 1'b0;
  logic rstn = 1'b0;
  logic spii_cstart = 1'b0;
  logic spii_astart = 1'b0;
//  logic d_i = 1'b1;
//  logic d_o;

  logic psel = 1'b0;
  logic penable = 1'b0;
  reg paddr = 32'b10001;
  reg pwdata = 32'b1000000001;
  logic pwrite = 1'b0;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

  spi_wrap uut(
    .clk (clk ) ,
    .rstn(rstn) ,
    .apbi_psel   (psel),
    .apbi_penable(penable),
    .apbi_paddr  (paddr),
    .apbi_pwrite (pwrite),
    .apbi_pwdata (pwdata),
    .apbi_testen (),
    .apbi_testrst(),
    .apbi_scanen (),
    .apbi_testoen(),
    .apbo_prdata (),
    .apbo_pirq   (),
    .spii_miso   (spii_miso),
    .spii_mosi   (spii_mosi),
    .spii_sck    (sck),
    .spii_spisel (),
    .spii_astart (),
    .spii_cstart (),
    .spii_ignore (),
    .spii_io2    (),
    .spii_io3    (),
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
    .slvsel      (slvsel)
  );

//  logic ok = 1;
  initial begin
    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);

    #40 pwrite <= 1;
    #20 penable <= 1;
    #30 psel <= 1;
  end
endmodule // tb
