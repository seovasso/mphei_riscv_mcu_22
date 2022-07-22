`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150
module tb ();
//grgpio
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
  logic        apbi_pirq           ;
  logic        apbi_testen         ;
  logic        apbi_testrst        ;
  logic        apbi_scanen         ;
  logic        apbi_testoen        ;
  logic        apbi_testin         ;
  
  logic [31:0] apbo_prdata         ;
  logic        apbo_pirq           ;
  //logic        apbo_pconfig        ;
  
  logic [31:0] gpioi_din           ;
  logic [31:0] gpioi_sig_in        ;
  logic [31:0] gpioi_sig_en        ;
  
  logic [31:0] gpioo_dout          ;
  logic [31:0] gpioo_oen           ;
  logic [31:0] gpioo_val           ;
  logic [31:0] gpioo_sig_out       ;

  // logic [31:0] apb_prdata_master   ;
  // logic [31:0] apb_pwdata_master   ;
  // logic [31:0] apb_paddr_master    ;
  // logic [31:0] apb_prdata_slave    ;
  // logic [31:0] apb_pwdata_slave    ;

  logic [31:0] apb_rdata           ;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b0;

// APB Interface
  apb_if    apb( .pclk(clk) );
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  
// ��������, ���� ��� APB slave
  //assign apb.mst_tb.prdata  = apb.mst_tb.prdata ;
  //assign apb.mst_tb.prdata  = apb_prdata_slave  ;
  assign apbi_psel           = apb.mst_tb.psel   ;
  assign apbi_penable        = apb.mst_tb.penable;
  assign apbi_pwrite         = apb.mst_tb.pwrite ;
  assign apbi_pwdata         = apb.mst_tb.pwdata ;
  assign apbi_paddr          = apb.mst_tb.paddr  ;
  assign apbi_prdata         = apb.mst_tb.prdata ;
  
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

    .apbi_psel     (apbi_psel          ),//: in  std_ulogic;
    .apbi_penable  (apbi_penable       ),//: in  std_ulogic;
    .apbi_paddr    (apbi_paddr         ),//: in  std_logic_vector(31 downto 0);
    .apbi_pwrite   (apbi_pwrite        ),//: in  std_ulogic;
    .apbi_pwdata   (apbi_pwdata        ),//: in  std_logic_vector(31 downto 0);
    .apbi_pirq     (apbi_pirq          ),
    .apbi_testen   (apbi_testen        ),//: in  std_ulogic;
    .apbi_testrst  (apbi_testrst       ),//: in  std_ulogic;
    .apbi_scanen   (apbi_scanen        ),//: in  std_ulogic;
    .apbi_testoen  (apbi_testoen       ),//: in  std_ulogic;
    .apbi_testin   (apbi_testin        ),

    .apbo_prdata   (apbi_prdata        ),//: out std_logic_vector(31 downto 0);
    //.apbo_pirq     (apbo_pirq          ),//: out std_ulogic;
      
    .gpioi_din     (gpioi_din          ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_in  (gpioi_sig_in       ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_en  (gpioi_sig_en       ),//: in  std_logic_vector(31 downto 0);
      
    .gpioo_dout    (gpioo_dout         ),//: out std_logic_vector(31 downto 0);
    .gpioo_oen     (gpioo_oen          ),//: out std_logic_vector(31 downto 0);
    .gpioo_val     (gpioo_val          ),//: out std_logic_vector(31 downto 0);
    .gpioo_sig_out (gpioo_sig_out      ) //: out std_logic_vector(31 downto 0))
  );

  //spi2ahb
//  parameter hindex   = 0;
//  parameter ahbaddrh = 0;
//  parameter ahbaddrl = 0;
//  parameter ahbmaskh = 0;
//  parameter ahbmaskl = 0;
//  parameter resen    = 0;
//  parameter pindex   = 0;
//  parameter paddr    = 0;
//  parameter filter   = 2;
//  parameter cpol     = 0;
//  parameter cpha     = 0;
//  parameter pmask    = 16'h0;
//  parameter oepol    = 0;//Output enable polarity
//  parameter pirq     = 0

//  logic ahbi    ;
//  logic ahbo    ;
//  logic apbi    ;
//  logic apbo    ;
  
//  logic spii    ;
//  logic spio    ;
  
//  logic miso    ;
//  logic mosi    ;
//  logic sck     ;
//  logic spisel  ;
//  logic astart  ;
//  logic cstart  ;
//  logic ignore  ;
//  logic io2     ;
//  logic io3     ;
  
//  logic miso    ;
//  logic misooen ;
//  logic mosi    ;
//  logic mosioen ;
//  logic sck     ;
//  logic sckoen  ;
//  logic enable  ;
//  logic astart  ;
//  logic aready  ;
//  logic io2     ;
//  logic io2oen  ;
//  logic io3     ;
//  logic io3oen  ;

//  spi2ahb_wrp #(
//    .hindex   (hindex  ),
//    .ahbaddrh (ahbaddrh),
//    .ahbaddrl (ahbaddrl),
//    .ahbmaskh (ahbmaskh),
//    .ahbmaskl (ahbmaskl),
//    .resen    (resen   ),
//    .pindex   (pindex  ),
//    .paddr    (paddr   ),
//    .filter   (filter  ),
//    .cpol     (cpol    ),
//    .cpha     (cpha    ),
//    .pmask    (pmask   ),
//    .oepol    (oepol   ),
//    .pirq     (pirq    )
//  )
//  uut(
//    .rstn     (rstn   ),
//    .clk      (clk    ),
//    //AHB master interface
//    .ahbi     (ahbi   ),
//    .ahbo     (ahbo   ),
//    .apbi     (apbi   ),
//    .apbo     (apbo   ),
//    //SPI signals
//    .spii     (spii   ),
//    .spio     (spio   ),
//    //spi_in_type
//    .miso     (miso   ),
//    .mosi     (mosi   ),
//    .sck      (sck    ),
//    .spisel   (spisel ),
//    .astart   (astart ),
//    .cstart   (cstart ),
//    .ignore   (ignore ),
//    .io2      (io2    ),
//    .io3      (io3    ),
//    //spi_out_type
//    .miso     (miso   ),
//    .misooen  (misooen),
//    .mosi     (mosi   ),
//    .mosioen  (mosioen),
//    .sck      (sck    ),
//    .sckoen   (sckoen ),
//    .enable   (enable ),
//    .astart   (astart ),
//    .aready   (aready ),
//    .io2      (io2    ),
//    .io2oen   (io2oen ),
//    .io3      (io3    ),
//    .io3oen   (io3oen ),
//  );

  // u_grgpio U1(.pindex(pindex),.paddr(paddr),.pmask(pmask).imask(imask),.nbits(nbits))

initial begin
    apb_rdata = 32'h20000;
    apb.mst_tb.init;
    gpioi_din = 32'h1;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD);

    // APB transaction
    apb.mst_tb.cyc_wait(50);
    apb.mst_tb.write( 32'h0BAD_F00D, 32'h4, 4'hF );     // write(data, addr(bytes), strb);
    //apb.mst_tb.read( apb_rdata, 32'h1234_5678);
    //apb.mst_tb.read( apb_rdata, 0);                 // read(data, addr);
    apb.mst_tb.cyc_wait(50);
    apb.mst_tb.write( apb_rdata, 32'h100);     // write(data, addr(bytes))
    apb.mst_tb.cyc_wait(50);
    apb.mst_tb.read( apb_rdata, 32'h200);        // read(data, addr);
    apb.mst_tb.cyc_wait(50);
    apb.mst_tb.write( apb_rdata, 32'h300);

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
