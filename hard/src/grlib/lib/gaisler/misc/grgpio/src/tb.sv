`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();
  parameter pindex   = 0;
  parameter paddr    = 0;
  parameter pmask    = 12'h0;
  parameter imask    = 16'h0;
  parameter nbits    = 8;			
  parameter oepol    = 0;      
  parameter syncrst  = 0;      
  parameter bypass   = 16'h0;
  parameter scantest = 0;
  parameter bpdir    = 16'h0;
  parameter pirq     = 0;
  parameter irqgen   = 0;
  parameter iflagreg = 0;
  parameter bpmode   = 0;
  parameter inpen    = 0;
  parameter doutresv = 0;
  parameter dirresv  = 0;
  parameter bpresv   = 0;
  parameter inpresv  = 0;
  parameter pulse    = 0;
  // Clock/reset generation
  logic        clk           = 1'b0;
  logic        rstn          = 1'b0;   
  logic        apbi_psel           ;
  logic        apbi_penable        ;
  logic [31:0] apbi_paddr          ;
  logic        apbi_pwrite         ;
  logic [31:0] apbi_pwdata         ;
  logic        apbi_testen         ;
  logic        apbi_testrst        ;
  logic        apbi_scanen         ;
  logic        apbi_testoen        ;
  logic [31:0] apbo_prdata         ;
  logic        apbo_pirq           ;
  logic [31:0] gpioi_din           ;
  logic [31:0] gpioi_sig_in        ;
  logic [31:0] gpioi_sig_en        ;
  logic [31:0] gpioo_dout          ;
  logic [31:0] gpioo_oen           ;
  logic [31:0] gpioo_val           ;
  logic [31:0] gpioo_sig_out       ;

  logic [31:0] apb_rdata           ;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

// APB Interface
  apb_if    apb( .pclk(clk) );
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  grgpio_wrp #(
  .pindex   (pindex  ),
  .paddr    (paddr   ),
  .pmask    (pmask   ),
  .imask    (imask   ),
  .nbits    (nbits   ),
  .oepol    (oepol   ),
  .syncrst  (syncrst ),
  .bypass   (bypass  ),
  .scantest (scantest),
  .bpdir    (bpdir   ),
  .pirq     (pirq    ),
  .irqgen   (irqgen  ),
  .iflagreg (iflagreg),
  .bpmode   (bpmode  ),
  .inpen    (inpen   ),
  .doutresv (doutresv),
  .dirresv  (dirresv ),
  .bpresv   (bpresv  ),
  .inpresv  (inpresv ),
  .pulse    (pulse   ) 
  ) 
  uut (
    .rst           (!rstn              ),//: in  std_ulogic;
    .clk           (clk                ),//: in  std_ulogic;

    .apbi_psel     (apb.mst_tb.psel    ),//: in  std_ulogic;
    .apbi_penable  (apb.mst_tb.penable ),//: in  std_ulogic;
    .apbi_paddr    (apb.mst_tb.paddr   ),//: in  std_logic_vector(31 downto 0);
    .apbi_pwrite   (apb.mst_tb.pwrite  ),//: in  std_ulogic;
    .apbi_pwdata   (apb.mst_tb.pwdata  ),//: in  std_logic_vector(31 downto 0);
    .apbi_testen   (0                  ),//: in  std_ulogic;
    .apbi_testrst  (0                  ),//: in  std_ulogic;
    .apbi_scanen   (0                  ),//: in  std_ulogic;
    .apbi_testoen  (0                  ),//: in  std_ulogic;

    .apbo_prdata   (apb.mst_tb.prdata  ),//: out std_logic_vector(31 downto 0);
    .apbo_pirq     (apbo_pirq          ),//: out std_ulogic;
      
    .gpioi_din     (gpioi_din          ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_in  (gpioi_sig_in       ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_en  (gpioi_sig_en       ),//: in  std_logic_vector(31 downto 0);
      
    .gpioo_dout    (gpioo_dout         ),//: out std_logic_vector(31 downto 0);
    .gpioo_oen     (gpioo_oen          ),//: out std_logic_vector(31 downto 0);
    .gpioo_val     (gpioo_val          ),//: out std_logic_vector(31 downto 0);
    .gpioo_sig_out (gpioo_sig_out      ) //: out std_logic_vector(31 downto 0))
  );

  // u_grgpio U1(.pindex(pindex),.paddr(paddr),.pmask(pmask).imask(imask),.nbits(nbits))

initial begin
    apb_rdata = 32'h0;
    apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);

    // APB transaction
    apb.mst_tb.cyc_wait(50);
    // apb.mst_tb.write( 32'h0BAD_F00D, 32'h1234_5678, 4'hF );     // wite(data, addr(bytes), strb);
    apb.mst_tb.read( apb_rdata, 0);                 // read(data, addr);

    // if (d_o != 1'b1) ok = 0;

    // d_i = 0;
    // #(`CLK_PERIOD);
    // if (d_o != 1'b0) ok = 0;

    // if (ok == 1) $display("TEST PASSED");
    // else         $display("TEST FAILED");
    apb.mst_tb.cyc_wait(50);
    $stop();
  end
endmodule // tb
