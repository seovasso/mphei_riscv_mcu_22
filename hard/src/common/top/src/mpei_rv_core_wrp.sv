
module mpei_rv_core_wrp #
  (
  parameter slvselsz           = 1,   // for spictrl
  parameter NAHBIRQ            = 32,  // for gptimer
  parameter SCR1_XLEN          = 32,  // for scr Fuses
  parameter SCR1_IRQ_LINES_NUM = 16,  // for scr IQR
  parameter SCR1_AHB_WIDTH     = 32   // for scr lenght of AHB
  )
  (
  input  logic                  clk_i         ,
  input  logic                  rstn_i        ,

  //     scr1_wrp interface
  //     what have to output? JTAG, IQR, Fuses, control pin?

  //     spictrl interface  
  input  logic                  spi_miso_i    ,
  input  logic                  spi_mosi_i    ,
  input  logic                  spi_sck_i     ,
  input  logic                  spi_spisel_i  ,
  input  logic                  spi_astart_i  ,
  input  logic                  spi_cstart_i  ,
  input  logic                  spi_ignore_i  ,
  input  logic                  spi_io2_i     ,
  input  logic                  spi_io3_i     ,
  output logic                  spi_miso_o    ,
  output logic                  spi_misooen_o ,
  output logic                  spi_mosi_o    ,
  output logic                  spi_mosioen_o ,
  output logic                  spi_sck_o     ,
  output logic                  spi_sckoen_o  ,
  output logic                  spi_enable_o  ,
  output logic                  spi_astart_o  ,
  output logic                  spi_aready_o  ,
  output logic                  spi_io2_o     ,
  output logic                  spi_io2oen_o  ,
  output logic                  spi_io3_o     ,
  output logic                  spi_io3oen_o  ,
  output logic  [slvselsz-1:0]  spi_slvsel_o  ,

  //     apbuart interface
  input  logic                  uart_rxd   	  ,
  input  logic                  uart_ctsn   	,
  input  logic                  uart_extclk	  ,
  output logic                  uart_rtsn     ,
  output logic                  uart_txd   	  ,
  output logic  [31:0]          uart_scaler	  ,
  output logic                  uart_txen     ,
  output logic                  uart_flow   	,
  output logic                  uart_rxen     ,
  output logic                  uart_txtick   ,
  output logic                  uart_rxtick   ,

  //     gpio interface
  input  logic  [31:0]          gpio_din      ,
  input  logic  [31:0]          gpio_sig_in   ,
  input  logic  [31:0]          gpio_sig_en   ,
  output logic  [31:0]          gpio_dout     ,
  output logic  [31:0]          gpio_oen      ,
  output logic  [31:0]          gpio_val      ,
  output logic  [31:0]          gpio_sig_out  ,

  //     grtimer interface
  output logic                  timr_dhalt    ,
  output logic                  timr_extclk   ,
  output logic                  timr_wdogen   ,
  output logic  [NAHBIRQ-1:0]   timr_latchv   ,
  output logic  [NAHBIRQ-1:0]   timr_latchd   ,
  output logic  [0:7]           timr_tick     ,
  output logic  [31:0]          timr_timer1   ,
  output logic                  timr_wdogn    ,
  output logic                  timr_wdog     
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
  .spi_miso_i         (spi_miso_i        ),
  .spi_mosi_i         (spi_mosi_i        ),
  .spi_sck_i          (spi_sck_i         ),
  .spi_spisel_i       (spi_spisel_i      ),
  .spi_astart_i       (spi_astart_i      ),
  .spi_cstart_i       (spi_cstart_i      ),
  .spi_ignore_i       (spi_ignore_i      ),
  .spi_io2_i          (spi_io2_i         ),
  .spi_io3_i          (spi_io3_i         ),
  .spi_miso_o         (spi_miso_o        ),
  .spi_misooen_o      (spi_misooen_o     ),
  .spi_mosi_o         (spi_mosi_o        ),
  .spi_mosioen_o      (spi_mosioen_o     ),
  .spi_sck_o          (spi_sck_o         ),
  .spi_sckoen_o       (spi_sckoen_o      ),
  .spi_enable_o       (spi_enable_o      ),
  .spi_astart_o       (spi_astart_o      ),
  .spi_aready_o       (spi_aready_o      ),
  .spi_io2_o          (spi_io2_o         ),
  .spi_io2oen_o       (spi_io2oen_o      ),
  .spi_io3_o          (spi_io3_o         ),
  .spi_io3oen_o       (spi_io3oen_o      ),
  .spi_slvsel_o       (spi_slvsel_o      ),
     
  //  apbuart interface         
  .uart_rxd           (uart_rxd          ), 
  .uart_ctsn          (uart_ctsn         ),  	
  .uart_extclk        (uart_extclk       ), 
  .uart_rtsn          (uart_rtsn         ),  	
  .uart_txd           (uart_txd          ), 
  .uart_scaler        (uart_scaler       ),
  .uart_txen          (uart_txen         ),
  .uart_flow          (uart_flow         ), 	
  .uart_rxen          (uart_rxen         ),
  .uart_txtick        (uart_txtick       ),
  .uart_rxtick        (uart_rxtick       ),
     
  //  gpio interface       
  .gpio_din           (gpio_din          ),
  .gpio_sig_in        (gpio_sig_in       ),
  .gpio_sig_en        (gpio_sig_en       ),
  .gpio_dout          (gpio_dout         ),
  .gpio_oen           (gpio_oen          ),
  .gpio_val           (gpio_val          ),
  .gpio_sig_out       (gpio_sig_out      ),
     
  //  grtimer interface         
  .timr_dhalt         (timr_dhalt        ),
  .timr_extclk        (timr_extclk       ),
  .timr_wdogen        (timr_wdogen       ),
  .timr_latchv        (timr_latchv       ),
  .timr_latchd        (timr_latchd       ),
  .timr_tick          (timr_tick         ),
  .timr_timer1        (timr_timer1       ),
  .timr_wdogn         (timr_wdogn        ),
  .timr_wdog          (timr_wdog         )
);

endmodule 
