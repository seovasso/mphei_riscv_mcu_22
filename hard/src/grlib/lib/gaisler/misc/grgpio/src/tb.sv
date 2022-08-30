`timescale 1ns/10ps

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

// MUX 
module MUX(a, enable, y);
  input       a     ;
  input       enable;
  output reg  y     ;

  always@ (a or enable)
    if (enable == 1'b1)
      y = 1'bz;
    else
      y = a;

endmodule

// PIO Pads
module IO_Pad (pad_gpioo_dout, pad_gpioo_oen, pad_gpioi_din, pad_io);
  output pad_gpioo_dout              ;
  input  pad_gpioo_oen, pad_gpioi_din;
  inout  pad_io                      ;
  
  MUX U1(.a(pad_gpioi_din), .enable(pad_gpioo_oen), .y(pad_io));
  assign pad_gpioo_dout = pad_io;
  
endmodule

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
  parameter pulse    = 1;
  // Clock/reset generation
  logic        clk           = 1'b0;
  logic        rstn          = 1'b0;
     
  logic        apbi_psel           ;
  logic        apbi_penable        ;
  logic [31:0] apbi_paddr          ;
  logic        apbi_pwrite         ;
  logic [31:0] apbi_pwdata         ;
  logic        apbi_pirq           ;
  logic        apbi_testen      = 1'b0  ;
  logic        apbi_testrst     = 1'b0   ;
  logic        apbi_scanen      = 1'b0   ;
  logic        apbi_testoen     = 1'b0  ;
  logic        apbi_testin      = 1'b0   ;
  
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
  wire [nbits-1:0] io              ;
  logic [nbits-1:0] pado_io        ;

  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_HIGH) rstn = 1'b1;

// APB Interface
  apb_if    apb( .pclk(clk) );
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  
  assign apbi_psel           = apb.mst_tb.psel   ;
  assign apbi_penable        = apb.mst_tb.penable;
  assign apbi_pwrite         = apb.mst_tb.pwrite ;
  assign apbi_pwdata         = apb.mst_tb.pwdata ;
  assign apbi_paddr          = apb.mst_tb.paddr  ;
  assign apb.mst_tb.prdata   = apbo_prdata       ;

generate
  for (genvar i=0; i<nbits; i++)
  begin : g_iopad
  IO_Pad U0(.pad_gpioo_dout(gpioi_din[i]), .pad_gpioo_oen(gpioo_oen[i]), .pad_gpioi_din(gpioo_dout[i]), .pad_io(io[i]));
  assign io[i] = pado_io[i];
  end
endgenerate
  
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

    .apbo_prdata   (apbo_prdata        ),//: out std_logic_vector(31 downto 0);
      
    .gpioi_din     (gpioi_din          ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_in  (gpioi_sig_in       ),//: in  std_logic_vector(31 downto 0);
    .gpioi_sig_en  (gpioi_sig_en       ),//: in  std_logic_vector(31 downto 0);
      
    .gpioo_dout    (gpioo_dout         ),//: out std_logic_vector(31 downto 0);
    .gpioo_oen     (gpioo_oen          ),//: out std_logic_vector(31 downto 0);
    .gpioo_val     (gpioo_val          ),//: out std_logic_vector(31 downto 0);
    .gpioo_sig_out (gpioo_sig_out      ) //: out std_logic_vector(31 downto 0))
  );

localparam PORT_DATA_REG      = 32'h0 ;

localparam PORT_OUT_REG       = 32'h04;
localparam PORT_DIR_REG       = 32'h08;
localparam PORT_IMASK_REG     = 32'h0C;

localparam PORT_OUT_REG_OR    = 32'h54;
localparam PORT_DIR_REG_OR    = 32'h58;
localparam PORT_IMASK_REG_OR  = 32'h5C;

localparam PORT_OUT_REG_AND   = 32'h64;
localparam PORT_DIR_REG_AND   = 32'h68;
localparam PORT_IMASK_REG_AND = 32'h6C;

localparam PORT_OUT_REG_XOR   = 32'h74;
localparam PORT_DIR_REG_XOR   = 32'h78;
localparam PORT_IMASK_REG_XOR = 32'h7C;

logic [31:0] read_data ;

initial begin
    integer define = 3;
    logic   ok=1;
    apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_HIGH);
    #(`CLK_PERIOD); 
    
    // Test 1 
    if (define == 1)
    begin
        pado_io = 'z;
        
        apb.mst_tb.cyc_wait(1);
        apb.mst_tb.write( 32'hff, PORT_DIR_REG);
        apb.mst_tb.cyc_wait(1);
        for (int i=0; i<=255; i++)
        begin
            apb.mst_tb.write( i, PORT_OUT_REG);
            apb.mst_tb.cyc_wait(1);
            if (io != i)
            begin
             $display("Test error");
             ok = 0;
            end
         end
        
        apb.mst_tb.write( 32'h0, PORT_DIR_REG);
        apb.mst_tb.cyc_wait(1);
    
        for (int i=0; i<=255; i++)
        begin
            pado_io = i;
            apb.mst_tb.read( read_data, PORT_DATA_REG);
            //apb.mst_tb.read( read_data, PORT_DATA_REG);
            if (read_data[7:0] != pado_io[7:0])
                $display("Test error");
        end
    end
    
    // Test 2
    if (define == 2)
    begin
//    apb.mst_tb.cyc_wait(1);
//    apb.mst_tb.write( 8'b1, 32'h4C);
//    gpioi_sig_in = 8'b1;
        for (int i=0; i<=255; i++)
        begin
            apb.mst_tb.write( i, 32'h4C);
            gpioi_sig_in = i;
            if ((gpioi_sig_in[7:0] != gpioo_dout[7:0])&&(apbi_penable == 1))
                $display("Test error");
        end
    end

//    apb.mst_tb.cyc_wait(1);
//    apb.mst_tb.write( 8'b1, 32'h4C); 
    
    // Test 3
    //Registers OR AND XOR
    if (define == 3)
    begin
        //apb.mst_tb.write( 32'h35, PORT_OUT_REG);
        //apb.mst_tb.cyc_wait(1);
        //apb.mst_tb.write( 8'b11 , PORT_OUT_REG_OR);
        //apb.mst_tb.cyc_wait(5);
        //apb.mst_tb.write( 32'h23, PORT_OUT_REG);
        //apb.mst_tb.cyc_wait(1);
        //apb.mst_tb.write( 8'b11 , PORT_OUT_REG_OR);
//        apb.mst_tb.cyc_wait(5);
//        apb.mst_tb.write( 32'hff, PORT_DIR_REG);
//        apb.mst_tb.cyc_wait(1);
//        apb.mst_tb.write( 1'b1 , PORT_DIR_REG_OR);

//        for (int i=0; i<=255; i++)
//        begin
//            //apb.mst_tb.cyc_wait(5);
//            apb.mst_tb.write( i, PORT_OUT_REG);
//            //apb.mst_tb.cyc_wait(1);
//            apb.mst_tb.write( i , PORT_OUT_REG_OR);
//            if (apbo_prdata[7:0] != gpioo_dout[7:0])
//                $display("Test error");
//        end 
        
        //apb.mst_tb.cyc_wait(5);
        
//        for (int i=0; i<=255; i++)
//        begin
//            //apb.mst_tb.cyc_wait(2);
//            apb.mst_tb.write( i, PORT_DIR_REG);
//            //apb.mst_tb.cyc_wait(1);
//            apb.mst_tb.write( i , PORT_DIR_REG_OR);
//            if (apbo_prdata[7:0] != gpioo_oen[7:0])
//                $display("Test error");
//        end
        
//        apb.mst_tb.cyc_wait(15);
        
//        for (int i=0; i<=255; i++)
//        begin
    //        apb.mst_tb.write( i, PORT_OUT_REG);
    //        //apb.mst_tb.cyc_wait(1);
    //        apb.mst_tb.write( i , PORT_OUT_REG_AND);
    //        if (apbo_prdata[7:0] != gpioo_dout[7:0])
    //          $display("Test error");
//        end

//        apb.mst_tb.cyc_wait(5);

//        for (int i=0; i<=255; i++)
//        begin
//            //apb.mst_tb.cyc_wait(2);
//            apb.mst_tb.write( i, PORT_DIR_REG);
//            //apb.mst_tb.cyc_wait(1);
//            apb.mst_tb.write( i , PORT_DIR_REG_AND);
//            if (apbo_prdata[7:0] != gpioo_oen[7:0])
//                $display("Test error");
//        end
        
//        apb.mst_tb.cyc_wait(15);
        
//        for (int i=0; i<=255; i++)
//        begin
    //        apb.mst_tb.write( i, PORT_OUT_REG);
    //        //apb.mst_tb.cyc_wait(1);
    //        apb.mst_tb.write( i , PORT_OUT_REG_XOR);
    //        if (apbo_prdata[7:0] != gpioo_dout[7:0])
    //          $display("Test error");
//        end

//        apb.mst_tb.cyc_wait(5);

//        for (int i=0; i<=255; i++)
//        begin
//            //apb.mst_tb.cyc_wait(2);
//            apb.mst_tb.write( i, PORT_DIR_REG);
//            //apb.mst_tb.cyc_wait(1);
//            apb.mst_tb.write( i , PORT_DIR_REG_XOR);
//            if (apbo_prdata[7:0] != gpioo_oen[7:0])
//                $display("Test error");
//        end

//        apb.mst_tb.write( 32'h35, PORT_OUT_REG);
//        apb.mst_tb.cyc_wait(1);
//        apb.mst_tb.write( 8'b11 , PORT_OUT_REG_XOR);
//        apb.mst_tb.cyc_wait(5);
//        apb.mst_tb.write( 32'hff, PORT_DIR_REG);
//        apb.mst_tb.cyc_wait(1);
//        apb.mst_tb.write( 8'b01 , PORT_DIR_REG_XOR);
    end
   
    // Test 4
    //Register IMASK
    if (define == 4)
    begin     
        apb.mst_tb.write( 32'h55, PORT_IMASK_REG);
        apb.mst_tb.cyc_wait(1);
        apb.mst_tb.read( read_data , PORT_IMASK_REG);
    end

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    apb.mst_tb.cyc_wait(50);
    $stop();
  end
endmodule // tb
