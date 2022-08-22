
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
  input  logic                  clk_i             ,
  input  logic                  rstn_i            ,
              
  //     JTAG interface  
  input  logic                  jtag_tck          ,
  input  logic                  jtag_tms          ,
  input  logic                  jtag_tdi          ,
  output logic                  jtag_tdo          ,
  
  // //     spi interface  
  input  logic                  spi_in_miso       ,
  output logic                  spi_out_mosi      ,
  output logic                  spi_out_sck       ,
  output logic [(slvselsz-1):0] spi_out_slvsel    ,
 
  //     apbuart interface  
  input  logic                  uart_in_rxd   	  ,
  output logic                  uart_out_txd   	  ,
 
  //     gpio interface 
  inout  logic [3:0]            gpio_inout        ,
  
  // VAL i2c
  input logic                   i2ci_scl   ,    
  input logic                   i2ci_sda   ,
  output logic                  i2co_scl   ,
  output logic                  iscloen    ,
  output logic                  i2co_sda   ,
  output logic                  isdaoen    ,
   

  //     timer interface
  output logic                  timr_out_one_tick 
);

logic [1:0] clk_w;

always @(posedge clk_i) begin
  if (!rstn_i) begin
    clk_w = 2'b0;
  end else begin
    clk_w = clk_w + 1'b1;
  end
end

logic [31:0] gpio_in_din   ;           
logic [31:0] gpio_out_dout ;
logic [31:0] gpio_out_oen  ;

assign gpio_in_din = gpio_inout;

generate 
  for (genvar i = 0; i < 4; i = i + 1) begin
    assign gpio_inout[i] = gpio_out_oen[i] ? (gpio_out_dout[i]) : (1'bz);
  end
endgenerate

logic [0:7] timr_out_tick;

assign timr_out_one_tick = timr_out_tick[0];

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
  .clk                 (clk_w[1]          ),
  .rtc_clk             (clk_w[1]          ),

  //  JTAG interface
  .jtag_trst_n         (rstn_i            ),
  .jtag_tck            (jtag_tck          ),
  .jtag_tms            (jtag_tms          ),
  .jtag_tdi            (jtag_tdi          ),
  .jtag_tdo            (jtag_tdo          ),
  .jtag_tdo_en         (                  ),

  //  spictrl interface        
  .spi_in_miso         (spi_in_miso       ),
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
  .spi_out_mosi        (spi_out_mosi      ),
  .spi_out_mosioen     (                  ),
  .spi_out_sck         (spi_out_sck       ),
  .spi_out_sckoen      (                  ),
  .spi_out_enable      (                  ),
  .spi_out_astart      (                  ),
  .spi_out_aready      (                  ),
  .spi_out_io2         (                  ),
  .spi_out_io2oen      (                  ),
  .spi_out_io3         (                  ),
  .spi_out_io3oen      (                  ),
  .spi_out_slvsel      (spi_out_slvsel    ),
     
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
  .gpio_in_din         (gpio_in_din       ),
  .gpio_in_sig_in      (                  ),
  .gpio_in_sig_en      (                  ),
  .gpio_out_dout       (gpio_out_dout     ),
  .gpio_out_oen        (gpio_out_oen      ),
  .gpio_out_val        (                  ),
  .gpio_out_sig_out    (                  ),
     
  //  VAL I2C
  .i2ci_scl (i2c_in_scl),
  .i2ci_sda (i2c_in_sda), 
  .i2co_scl (i2c_out_scl),
  .i2co_sda (i2c_out_sda),
  .iscloen  (scloen),
  .isdaoen  (sdaoen),
     
  //  grtimer interface                   
  .timr_in_dhalt       (                  ),
  .timr_in_extclk      (                  ),
  .timr_in_wdogen      (                  ),
  .timr_in_latchv      (                  ),
  .timr_in_latchd      (                  ),
  .timr_out_tick       (timr_out_tick     ),
  .timr_out_timer1     (                  ),
  .timr_out_wdogn      (                  ),
  .timr_out_wdog       (                  )
);

endmodule 
