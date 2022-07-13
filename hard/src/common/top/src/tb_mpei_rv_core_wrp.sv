`timescale 1ns/10ps

//`include "scr1_top_ahb.sv"

`define Nword 32

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

module tb_mpei_rv_core_wrp ();

parameter slvselsz           = 1 ;  // for spictrl
parameter NAHBIRQ            = 32;  // for gptimer
parameter SCR1_XLEN          = 32;  // for scr Fuses
parameter SCR1_IRQ_LINES_NUM = 16;  // for scr IQR
parameter SCR1_AHB_WIDTH     = 32;  // for scr lenght of AHB

// Clock/reset generation & 
logic                clk_i         ;
logic                rstn_i        ;
              
logic                spi_miso_i    ;
logic                spi_mosi_i    ;
logic                spi_sck_i     ;
logic                spi_spisel_i  ;
logic                spi_astart_i  ;
logic                spi_cstart_i  ;
logic                spi_ignore_i  ;
logic                spi_io2_i     ;
logic                spi_io3_i     ;
logic                spi_miso_o    ;
logic                spi_misooen_o ;
logic                spi_mosi_o    ;
logic                spi_mosioen_o ;
logic                spi_sck_o     ;
logic                spi_sckoen_o  ;
logic                spi_enable_o  ;
logic                spi_astart_o  ;
logic                spi_aready_o  ;
logic                spi_io2_o     ;
logic                spi_io2oen_o  ;
logic                spi_io3_o     ;
logic                spi_io3oen_o  ;
logic [slvselsz-1:0] spi_slvsel_o  ;
         
logic                uart_rxd      ;
logic                uart_ctsn     ;
logic                uart_extclk   ;
logic                uart_rtsn     ;
logic                uart_txd      ;
logic [31:0]         uart_scaler   ;
logic                uart_txen     ;
logic                uart_flow     ;
logic                uart_rxen     ;
logic                uart_txtick   ;
logic                uart_rxtick   ;
             
logic [31:0]         gpio_din      ;
logic [31:0]         gpio_sig_in   ;
logic [31:0]         gpio_sig_en   ;
logic [31:0]         gpio_dout     ;
logic [31:0]         gpio_oen      ;
logic [31:0]         gpio_val      ;
logic [31:0]         gpio_sig_out  ;
               
logic                timr_dhalt    ;
logic                timr_extclk   ;
logic                timr_wdogen   ;
logic [NAHBIRQ-1:0]  timr_latchv   ;
logic [NAHBIRQ-1:0]  timr_latchd   ;
logic [0:7]          timr_tick     ;
logic [31:0]         timr_timer1   ;
logic                timr_wdogn    ;
logic                timr_wdog     ;

mpei_rv_core_wrp #(
  .slvselsz           (slvselsz          ),
  .NAHBIRQ            (NAHBIRQ           ),
  .SCR1_XLEN          (SCR1_XLEN         ),
  .SCR1_IRQ_LINES_NUM (SCR1_IRQ_LINES_NUM),
  .SCR1_AHB_WIDTH     (SCR1_AHB_WIDTH    )
) DUT (      
  .clk_i              (clk_i        ),
  .rstn_i             (rstn_i       ),

  //  scr1_wrp interface        

  //  spictrl interface   
  .spi_miso_i         (spi_miso_i   ),
  .spi_mosi_i         (spi_mosi_i   ),
  .spi_sck_i          (spi_sck_i    ),
  .spi_spisel_i       (spi_spisel_i ),
  .spi_astart_i       (spi_astart_i ),
  .spi_cstart_i       (spi_cstart_i ),
  .spi_ignore_i       (spi_ignore_i ),
  .spi_io2_i          (spi_io2_i    ),
  .spi_io3_i          (spi_io3_i    ),
  .spi_miso_o         (spi_miso_o   ),
  .spi_misooen_o      (spi_misooen_o),
  .spi_mosi_o         (spi_mosi_o   ),
  .spi_mosioen_o      (spi_mosioen_o),
  .spi_sck_o          (spi_sck_o    ),
  .spi_sckoen_o       (spi_sckoen_o ),
  .spi_enable_o       (spi_enable_o ),
  .spi_astart_o       (spi_astart_o ),
  .spi_aready_o       (spi_aready_o ),
  .spi_io2_o          (spi_io2_o    ),
  .spi_io2oen_o       (spi_io2oen_o ),
  .spi_io3_o          (spi_io3_o    ),
  .spi_io3oen_o       (spi_io3oen_o ),
  .spi_slvsel_o       (spi_slvsel_o ),

  //  apbuart interface    
  .uart_rxd           (uart_rxd     ), 
  .uart_ctsn          (uart_ctsn    ),  	
  .uart_extclk        (uart_extclk  ), 
  .uart_rtsn          (uart_rtsn    ),  	
  .uart_txd           (uart_txd     ), 
  .uart_scaler        (uart_scaler  ),
  .uart_txen          (uart_txen    ),
  .uart_flow          (uart_flow    ), 	
  .uart_rxen          (uart_rxen    ),
  .uart_txtick        (uart_txtick  ),
  .uart_rxtick        (uart_rxtick  ),

  //  gpio interface  
  .gpio_din           (gpio_din     ),
  .gpio_sig_in        (gpio_sig_in  ),
  .gpio_sig_en        (gpio_sig_en  ),
  .gpio_dout          (gpio_dout    ),
  .gpio_oen           (gpio_oen     ),
  .gpio_val           (gpio_val     ),
  .gpio_sig_out       (gpio_sig_out ),

  //  grtimer interface    
  .timr_dhalt         (timr_dhalt   ),
  .timr_extclk        (timr_extclk  ),
  .timr_wdogen        (timr_wdogen  ),
  .timr_latchv        (timr_latchv  ),
  .timr_latchd        (timr_latchd  ),
  .timr_tick          (timr_tick    ),
  .timr_timer1        (timr_timer1  ),
  .timr_wdogn         (timr_wdogn   ),
  .timr_wdog          (timr_wdog    )
);

logic ok = 1;

//all hierarchical path from top
//tb_mpei_rv_core_wrp.mpei_rv_core_wrp.mpei_rv_core.scr1_wrp.scr1_top_ahb.scr1_tcm.scr1_dp_memory.ram_block

// tcm initialization
initial begin
  $readmemb ( "./firmware_scr1.bin" , scr1_top_ahb.scr1_tcm.scr1_dp_memory.ram_block, 0, Nword-1 );
end

// initial initialization
initial begin
  clk_i  = 1'b0;
  rstn_i = 1'b0;
end

always  #(`CLK_PERIOD/2)    clk_i  = !clk_i;
initial #(`RESET_GOES_HIGH) rstn_i = 1'b1;

initial begin
  $display("TEST STARTED");
  // we wait start
  #(`RESET_GOES_HIGH);
  #(`CLK_PERIOD);

  if (ok == 1) $display("TEST PASSED");
  else         $display("TEST FAILED");
  $stop();
end

endmodule
