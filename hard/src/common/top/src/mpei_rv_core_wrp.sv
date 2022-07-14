
module mpei_rv_core_wrp #
  (
  parameter slvselsz           = 1,   // for spictrl
  parameter NAHBIRQ            = 32,  // for gptimer
  parameter SCR1_XLEN          = 32,  // for scr Fuses
  parameter SCR1_IRQ_LINES_NUM = 16,  // for scr IQR
  parameter SCR1_AHB_WIDTH     = 32   // for scr lenght of AHB
  )
  (
  input  logic                  clk_i            ,
  input  logic                  rstn_i           ,

  //     scr1_wrp interface
  //     what have to output? JTAG, IQR, Fuses, control pin?

  //     spictrl interface  
  input  logic                  spi_in_miso      ,
  input  logic                  spi_in_mosi      ,
  input  logic                  spi_in_sck       ,
  input  logic                  spi_in_spisel    ,
  input  logic                  spi_in_astart    ,
  input  logic                  spi_in_cstart    ,
  input  logic                  spi_in_ignore    ,
  input  logic                  spi_in_io2       ,
  input  logic                  spi_in_io3       ,
  output logic                  spi_out_miso     ,
  output logic                  spi_out_misooen  ,
  output logic                  spi_out_mosi     ,
  output logic                  spi_out_mosioen  ,
  output logic                  spi_out_sck      ,
  output logic                  spi_out_sckoen   ,
  output logic                  spi_out_enable   ,
  output logic                  spi_out_astart   ,
  output logic                  spi_out_aready   ,
  output logic                  spi_out_io2      ,
  output logic                  spi_out_io2oen   ,
  output logic                  spi_out_io3      ,
  output logic                  spi_out_io3oen   ,
  output logic  [slvselsz-1:0]  spi_out_slvsel   ,
 
  //     apbuart interface 
  input  logic                  uart_in_rxd   	 ,
  input  logic                  uart_in_ctsn   	 ,
  input  logic                  uart_in_extclk	 ,
  output logic                  uart_out_rtsn    ,
  output logic                  uart_out_txd   	 ,
  output logic  [31:0]          uart_out_scaler	 ,
  output logic                  uart_out_txen    ,
  output logic                  uart_out_flow    ,
  output logic                  uart_out_rxen    ,
  output logic                  uart_out_txtick  ,
  output logic                  uart_out_rxtick  ,

  //     gpio interface
  input  logic  [31:0]          gpio_in_din      ,
  input  logic  [31:0]          gpio_in_sig_in   ,
  input  logic  [31:0]          gpio_in_sig_en   ,
  output logic  [31:0]          gpio_out_dout    ,
  output logic  [31:0]          gpio_out_oen     ,
  output logic  [31:0]          gpio_out_val     ,
  output logic  [31:0]          gpio_out_sig_out ,

  //     grtimer interface
  output logic                  timr_in_dhalt    ,
  output logic                  timr_in_extclk   ,
  output logic                  timr_in_wdogen   ,
  output logic  [NAHBIRQ-1:0]   timr_in_latchv   ,
  output logic  [NAHBIRQ-1:0]   timr_in_latchd   ,
  output logic  [0:7]           timr_out_tick    ,
  output logic  [31:0]          timr_out_timer1  ,
  output logic                  timr_out_wdogn   ,
  output logic                  timr_out_wdog    
);

mpei_rv_core #(
  .slvselsz           (slvselsz          ),
  .NAHBIRQ            (NAHBIRQ           ),
  .SCR1_XLEN          (SCR1_XLEN         ),
  .SCR1_IRQ_LINES_NUM (SCR1_IRQ_LINES_NUM),
  .SCR1_AHB_WIDTH     (SCR1_AHB_WIDTH    )
) mpei_rv_core (      
  .clk_i              (clk_i             ),
  .rstn_i             (rstn_i            ),
     
  //  scr1_wrp interface             
     
  //  spictrl interface        
  .spi_in_miso         (spi_in_miso       ),
  .spi_in_mosi         (spi_in_mosi       ),
  .spi_in_sck          (spi_in_sck        ),
  .spi_in_spisel       (spi_in_spisel     ),
  .spi_in_astart       (spi_in_astart     ),
  .spi_in_cstart       (spi_in_cstart     ),
  .spi_in_ignore       (spi_in_ignore     ),
  .spi_in_io2          (spi_in_io2        ),
  .spi_in_io3          (spi_in_io3        ),
  .spi_out_miso        (spi_out_miso      ),
  .spi_out_misooen     (spi_out_misooen   ),
  .spi_out_mosi        (spi_out_mosi      ),
  .spi_out_mosioen     (spi_out_mosioen   ),
  .spi_out_sck         (spi_out_sck       ),
  .spi_out_sckoen      (spi_out_sckoen    ),
  .spi_out_enable      (spi_out_enable    ),
  .spi_out_astart      (spi_out_astart    ),
  .spi_out_aready      (spi_out_aready    ),
  .spi_out_io2         (spi_out_io2       ),
  .spi_out_io2oen      (spi_out_io2oen    ),
  .spi_out_io3         (spi_out_io3       ),
  .spi_out_io3oen      (spi_out_io3oen    ),
  .spi_out_slvsel      (spi_out_slvsel    ),
     
  //  apbuart interface         
  .uart_in_rxd   	     (uart_in_rxd   	  ), 
  .uart_in_ctsn        (uart_in_ctsn      ),  	
  .uart_in_extclk	     (uart_in_extclk	  ), 
  .uart_out_rtsn       (uart_out_rtsn     ),  	
  .uart_out_txd   	   (uart_out_txd   	  ), 
  .uart_out_scaler	   (uart_out_scaler	  ),
  .uart_out_txen       (uart_out_txen     ),
  .uart_out_flow       (uart_out_flow     ), 	
  .uart_out_rxen       (uart_out_rxen     ),
  .uart_out_txtick     (uart_out_txtick   ),
  .uart_out_rxtick     (uart_out_rxtick   ),
     
  //  gpio interface       
  .gpio_in_din         (gpio_in_din       ),
  .gpio_in_sig_in      (gpio_in_sig_in    ),
  .gpio_in_sig_en      (gpio_in_sig_en    ),
  .gpio_out_dout       (gpio_out_dout     ),
  .gpio_out_oen        (gpio_out_oen      ),
  .gpio_out_val        (gpio_out_val      ),
  .gpio_out_sig_out    (gpio_out_sig_out  ),
     
  //  grtimer interface         
  .timr_in_dhalt       (timr_in_dhalt     ),
  .timr_in_extclk      (timr_in_extclk    ),
  .timr_in_wdogen      (timr_in_wdogen    ),
  .timr_in_latchv      (timr_in_latchv    ),
  .timr_in_latchd      (timr_in_latchd    ),
  .timr_out_tick       (timr_out_tick     ),
  .timr_out_timer1     (timr_out_timer1   ),
  .timr_out_wdogn      (timr_out_wdogn    ),
  .timr_out_wdog       (timr_out_wdog     )
);

endmodule 
