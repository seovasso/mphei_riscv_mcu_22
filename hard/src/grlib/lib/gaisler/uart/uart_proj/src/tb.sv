`timescale 1ns/10ps

`define CLK_PERIOD 10		//System_clock_Frequency
`define RESET_GOES_LOW 150
module tb ();

  // Clock/reset generation
  parameter NAPBIR  =1;
  parameter NAPBAMR =1;

  
  parameter NAPBCFG  = NAPBIR + NAPBAMR;
  parameter NTESTINBITS = 4;
  parameter NAPBSLV	= 16;
  parameter NAHBIRQ   = 32;
  
  parameter PINDEX   = 3;
  parameter PADDR    = 0;
  parameter PMASK    = 12'hfff;
  parameter CONSOLE  = 0;
  parameter PIRQ     = 0;
  parameter PARITY   = 1;
  parameter FLOW     = 1;
  parameter FIFOSIZE = 1;
  parameter ABITS    = 8;
  parameter SBITS    = 12;

  logic           rst = 1'b1;
  logic           clk = 1'b0;

  logic	 [31:0]  					apb_rdata		;
  logic  [0:NAPBSLV-1] 			  	apbi_psel      ;
  logic			 				  	apbi_penable   ;
  logic  [31:0]			  			apbi_paddr     ;
  logic			  					apbi_pwrite    ;
  logic	 [31:0]		  				apbi_pwdata    ;
  logic	 [NAHBIRQ-1:0]		  		apbi_pirq_i    ;
  logic			 					apbi_testen    ;
  logic			 					apbi_testrst   ;
  logic			 					apbi_scanen    ;
  logic			 					apbi_testoen   ;
  logic	 [NTESTINBITS-1:0]		  	apbi_testin    ;
									
  logic	 [31:0]			  			apbo_prdata    ;
  logic	 [NAHBIRQ-1:0]			  	apbo_pirq_o    ;
  logic	 [NAPBCFG-1:0]				apbo_pconfig   ;
  integer			  				apbo_pindex    ;
						
  logic			  uarti_rxd       ;
  logic			  uarti_ctsn      ;
  logic			  uarti_extclk    ;
						
  logic			  uarto_rtsn      ;
  logic			  uarto_txd		  ;
  logic			  uarto_scaler	  ;
  logic			  uarto_txen      ;
  logic			  uarto_flow      ;
  logic			  uarto_rxen      ;
  logic			  uarto_txtick    ;
  logic			  uarto_rxtick    ;
  
  logic			  apb_rdata	      ;  

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
    .const_pindex 	(PINDEX),
    .const_paddr 		(PADDR),
	.const_pmask 		(PMASK),
    .const_console 	(CONSOLE),
	.const_pirq	 	(PIRQ),
    .const_parity 	(PARITY),
	.const_flow 		(FLOW),
    .const_fifosize 	(FIFOSIZE),
	.const_abits 		(ABITS),
    .const_sbits 		(SBITS)	
	)

uut(
    .rst (rst),
    .clk (clk),

	.psel    	(apbi_psel	),
	.penable 	(apbi_penable),
	.paddr   	(apbi_paddr	),
	.pwrite  	(apbi_pwrite ),
	.pwdata  	(apbi_pwdata ),
	.pirq_i  	(apbi_pirq   ),
	.testen  	(apbi_testen ),
	.testrst 	(apbi_testrst),
	.scanen  	(apbi_scanen ),
	.testoen 	(apbi_testoen),
	.testin  	(apbi_testin ),
				
	.prdata  	(apbo_prdata ),
	.pirq_o  	(apbo_pirq),
	.pconfig 	(),
	.pindex  	(apbo_pindex ),
	
	.rxd        (uarti_rxd   ),
	.ctsn       (uarti_ctsn  ),
	.extclk     (uarti_extclk),
				
	.rtsn   	(uarto_rtsn  ),
	.txd   	    (uarto_txd   ),
	.scaler	    (uarto_scaler),
	.txen       (uarto_txen  ),
	.flow   	(uarto_flow  ),
	.rxen       (uarto_rxen  ),
	.txtick     (uarto_txtick),
	.rxtick     (uarto_rxtick)
  );

  logic ok = 1;

  initial begin
    apb_rdata = 32'hFF;
    apb.mst_tb.init;

    $display("TEST STARTED");
    // we wait start
    #(`RESET_GOES_LOW);
    #(`CLK_PERIOD);

    // APB transaction
	apb.mst_tb.cyc_wait(50);
	apb.mst_tb.write( apb_rdata, 32'hF, 4'hF );     // wite(data, addr(bytes), strb);
	apb.mst_tb.read( apb_rdata, 32'hF);                 // read(data, addr);

//   if (d_o != 1'b1) ok = 0;

//    d_i = 0;
    #(`CLK_PERIOD);
//    if (d_o != 1'b0) ok = 0;

    if (ok == 1) $display("TEST PASSED");
    else         $display("TEST FAILED");
    $stop();
  end
endmodule // tb
