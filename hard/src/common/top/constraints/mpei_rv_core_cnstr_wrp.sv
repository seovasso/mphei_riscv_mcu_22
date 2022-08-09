
module mpei_rv_core_cnstr_wrp #
  (
  parameter slvselsz           = 1,   // for spictrl
  parameter NAHBIRQ            = 32,  // for gptimer
  parameter SCR1_XLEN          = 32,  // for scr Fuses
  parameter SCR1_IRQ_LINES_NUM = 16,  // for scr IQR
  parameter SCR1_AHB_WIDTH     = 32   // for scr lenght of AHB
  )
  (
  //     scr1_wrp interface
  input  logic                  clk_i            ,
  input  logic                  rstn_i           ,
           
  //     JTAG interface 
  input  logic                  jtag_tck         ,
  input  logic                  jtag_tms         ,
  input  logic                  jtag_tdi         ,
  output logic                  jtag_tdo         ,
 
  //     apbuart interface 
  input  logic                  uart_in_rxd   	 ,
  output logic                  uart_out_txd   	 
);

// logic clk_w;

// always @(posedge clk_i) begin
//   if (rstn_i) begin
//     clk_w = 0;
//   end else begin
//     clk_w = clk_w + 1;
//   end
// end


mpei_rv_core_cnstr #(
  .slvselsz            (slvselsz          ),
  .NAHBIRQ             (NAHBIRQ           ),
  .SCR1_XLEN           (SCR1_XLEN         ),
  .SCR1_IRQ_LINES_NUM  (SCR1_IRQ_LINES_NUM),
  .SCR1_AHB_WIDTH      (SCR1_AHB_WIDTH    )
) mpei_rv_core_cnstr (   

  //  scr1_wrp interface             
  .pwrup_rst_n         (rstn_i            ),
  .rst_n               (rstn_i            ),
  .cpu_rst_n           (rstn_i            ),
  .test_mode           (0                 ),
  .test_rst_n          (1                 ),
  .clk                 (clk_i             ),
  .rtc_clk             (clk_i             ),

  //  JTAG interface
  .jtag_trst_n         (rstn_i            ),
  .jtag_tck            (jtag_tck          ),
  .jtag_tms            (jtag_tms          ),
  .jtag_tdi            (jtag_tdi          ),
  .jtag_tdo            (jtag_tdo          ),
  .jtag_tdo_en         (                  ),

  //  spictrl interface        
  .spi_in_miso         (                  ),
  .spi_in_mosi         (                  ),
  .spi_in_sck          (                  ),
  .spi_in_spisel       (                  ),
  .spi_in_astart       (                  ),
  .spi_in_cstart       (                  ),
  .spi_in_ignore       (                  ),
  .spi_in_io2          (                  ),
  .spi_in_io3          (                  ),
  .spi_out_miso        (                  ),
  .spi_out_misooen     (                  ),
  .spi_out_mosi        (                  ),
  .spi_out_mosioen     (                  ),
  .spi_out_sck         (                  ),
  .spi_out_sckoen      (                  ),
  .spi_out_enable      (                  ),
  .spi_out_astart      (                  ),
  .spi_out_aready      (                  ),
  .spi_out_io2         (                  ),
  .spi_out_io2oen      (                  ),
  .spi_out_io3         (                  ),
  .spi_out_io3oen      (                  ),
  .spi_out_slvsel      (                  ),
     
  //  apbuart interface                   
  .uart_in_rxd   	     (uart_in_rxd       ),  
  .uart_in_ctsn        (                  ),  	
  .uart_in_extclk	     (                  ), 
  .uart_out_rtsn       (                  ),  	
  .uart_out_txd   	   (uart_out_txd      ), 
  .uart_out_scaler	   (                  ),
  .uart_out_txen       (                  ),
  .uart_out_flow       (                  ), 	
  .uart_out_rxen       (                  ),
  .uart_out_txtick     (                  ),
  .uart_out_rxtick     (                  ),
     
  //  gpio interface                      
  .gpio_in_din         (                  ),
  .gpio_in_sig_in      (                  ),
  .gpio_in_sig_en      (                  ),
  .gpio_out_dout       (                  ),
  .gpio_out_oen        (                  ),
  .gpio_out_val        (                  ),
  .gpio_out_sig_out    (                  ),
     
  //  grtimer interface                   
  .timr_in_dhalt       (                  ),
  .timr_in_extclk      (                  ),
  .timr_in_wdogen      (                  ),
  .timr_in_latchv      (                  ),
  .timr_in_latchd      (                  ),
  .timr_out_tick       (                  ),
  .timr_out_timer1     (                  ),
  .timr_out_wdogn      (                  ),
  .timr_out_wdog       (                  )
);

endmodule 
