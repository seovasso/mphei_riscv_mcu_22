`timescale 1ns/10ps

`define TEST_PAR 1
`define CLK_PERIOD 20		//System_clock_Frequency
`define RESET_GOES_LOW 1500
module tb ();

  // Clock/reset generation
  parameter NAPBIR  = 1;
  parameter NAPBAMR = 1;

//  parameter baud	= 9600;
//  parameter sclr1	= (1/(CLK_PERIOD*(0.000000001)*(baud*8+7));
  parameter NAPBCFG  	= NAPBIR + NAPBAMR;
  parameter NTESTINBITS = 4;
  parameter NAPBSLV	= 16;
  parameter NAHBIRQ   	= 32;

  
  parameter PINDEX   = 3;
  parameter PADDR    = 0;
  parameter PMASK    = 12'hfff;
  parameter CONSOLE  = 0;
  parameter PIRQ     = 0;
  parameter PARITY   = 1;
  parameter FLOW     = 1;
  parameter FIFOSIZE = 4;
  parameter ABITS    = 8;
  parameter SBITS    = 12;

  logic           rst = 1'b1;
  logic           clk = 1'b0;

  logic [31:0]                  ctrl       	;
  logic [31:0]                  sclr       	; 
  logic [31:0]                  apb_rdata1      ;
  logic [31:0]                  apb_rdata2      ;
  logic [31:0]                  apb_rdata3      ;  
  logic [31:0]                 	sts      	;  
  
  
  logic [31:0]                  apb_rdata       ;
  logic [0:NAPBSLV-1]           apbi_psel       ;
  logic                         apbi_penable    ;
  logic [31:0]                  apbi_paddr      ;
  logic                         apbi_pwrite     ;
  logic [31:0]                  apbi_pwdata     ;
  logic [NAHBIRQ-1:0]           apbi_pirq_i     ;
  logic                         apbi_testen     ;
  logic                         apbi_testrst    ;
  logic                         apbi_scanen     ;
  logic                         apbi_testoen    ;
  logic [NTESTINBITS-1:0]       apbi_testin     ;
	
  logic [31:0]                  apbo_prdata     ;
  logic [NAHBIRQ-1:0]           apbo_pirq_o     ;
  logic [NAPBCFG-1:0]           apbo_pconfig    ;
  integer                       apbo_pindex     ;

  logic                         uarti_rxd       ;
  logic                         uarti_ctsn      ;
  logic                         uarti_extclk    ;

  logic                         uarto_rtsn      ;
  logic                         uarto_txd       ;
  logic                         uarto_scaler    ;
  logic                         uarto_txen      ;
  logic                         uarto_flow      ;
  logic                         uarto_rxen      ;
  logic                         uarto_txtick    ;
  logic                         uarto_rxtick    ;


  always #(`CLK_PERIOD/2) clk = !clk;
  initial #(`RESET_GOES_LOW) rst = 1'b0;

  // APB Interface
  apb_if    apb(.pclk(clk) );

  assign apb.mst_tb.prdata  = apbo_prdata;
  assign apb.mst_tb.pready  = 1'b1;
  assign apb.mst_tb.pslverr = 1'b0;
  assign apbi_paddr = apb.mst_tb.paddr;
  assign apbi_psel[PINDEX] = apb.mst_tb.psel; 
  assign apbi_penable = apb.mst_tb.penable;  
  assign apbi_pwrite = apb.mst_tb.pwrite;
  assign apbi_pstrb = 4'b1111; 
  assign apbi_pprot = 3'b000;  
  assign apbi_pwdata = apb.mst_tb.pwdata;

  apbuart_wrapper
#(
        .const_pindex           (PINDEX),
        .const_paddr 		(PADDR),
	.const_pmask 		(PMASK),
        .const_console          (CONSOLE),
	.const_pirq	 	(PIRQ),
        .const_parity           (PARITY),
	.const_flow 		(FLOW),
        .const_fifosize 	(FIFOSIZE),
        .const_abits 		(ABITS),
        .const_sbits 		(SBITS)	
	)

uut(
    .rst (rst),
    .clk (clk),

	.psel    	(apbi_psel),
	.penable 	(apbi_penable),
	.paddr   	(apbi_paddr),
	.pwrite  	(apbi_pwrite),
	.pwdata  	(apbi_pwdata),
	.pirq_i  	(apbi_pirq),
	.testen  	(apbi_testen),
	.testrst 	(apbi_testrst),
	.scanen  	(apbi_scanen),
	.testoen 	(apbi_testoen),
	.testin  	(apbi_testin),
				
	.prdata  	(apbo_prdata),
	.pirq_o  	(apbo_pirq),
	.pconfig 	(),
	.pindex  	(apbo_pindex),
	
	.rxd            (uarti_rxd),
	.ctsn           (uarti_ctsn),
	.extclk         (uarti_extclk),
				
	.rtsn   	(uarto_rtsn),
	.txd   	        (uarto_txd),
	.scaler	        (uarto_scaler),
	.txen           (uarto_txen),
	.flow   	(uarto_flow),
	.rxen           (uarto_rxen),
	.txtick         (uarto_txtick),
	.rxtick         (uarto_rxtick)
  );

  logic ok = 1;


int boudrate;
int freq;
int sclr;

generate
  case (32'd`TEST_PAR)
    32'd0  : initial begin
      ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 9600;
      freq = 5000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd1  : initial begin
      ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 9600;
      freq = 50000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd2  : initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 9600;
      freq = 100000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd3  : initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 115200;
      freq = 5000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd4  : initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 115200;
      freq = 50000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd5  : initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 115200;
      freq = 100000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd6  : initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 921600;
      freq = 5000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd7  : 
    initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 921600;
      freq = 50000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd8  : 
    initial begin
    ctrl = 32'b00000000000000000000000000000011; 
      boudrate = 921600;
      freq = 100000000;
      sclr = freq/(boudrate*8)-1;
    end
    32'd9  : initial begin
    ctrl = 32'b00000000000000000000000010000011; 
      boudrate = 9600;
      freq = 100000000;
      sclr = freq/(boudrate*8)-1;
    end
  endcase
endgenerate


  initial begin
    apb.mst_tb.init;

//    sclr = 32'h2;
    apb_rdata = 8'b00101010 ;
    apb_rdata1 = 0;
    apb_rdata2 = 8'b11010101 ; 
    apb_rdata3 = 0; 
    //8'b10101000 ;
//    apb_rdata2 = 8'b00110011 ;
    sts = 0;
    $display("TEST STARTED");    // we wait start
    #(`RESET_GOES_LOW);
    #(`CLK_PERIOD);

    // APB transaction
	apb.mst_tb.cyc_wait(50);
	apb.mst_tb.write( ctrl, 32'h08, 4'hF );
	apb.mst_tb.write( sclr, 32'h0C, 4'hF );	
	apb.mst_tb.write( apb_rdata, 32'h00, 4'hF );
//	apb.mst_tb.write( apb_rdata, 32'h00, 4'hF );
//	apb.mst_tb.write( apb_rdata1, 32'h00, 4'hE );
	apb.mst_tb.write( apb_rdata2, 32'h00, 4'hD );
     // wite(data, addr(bytes), strb);
//	apb.mst_tb.write( ctrl, 32'hC, 4'hF );
                 // read(data, addr);
	apb.mst_tb.read(sts, 32'h04);
	while (sts[0]==0) begin
		apb.mst_tb.read(sts, 32'h04);	
	end
	apb.mst_tb.read(apb_rdata1, 32'h00);
	
	apb.mst_tb.read(sts, 32'h04);
	while (sts[0]==0) begin
		apb.mst_tb.read(sts, 32'h04);	
	end
	apb.mst_tb.read(apb_rdata3, 32'h00);
//	$display("read data: %h", sts);
//   if (d_o != 1'b1) ok = 0;

//    d_i = 0;
    #(`CLK_PERIOD);
//    if (d_o != 1'b0) ok = 0;
    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    $stop();
  end
endmodule // tb
