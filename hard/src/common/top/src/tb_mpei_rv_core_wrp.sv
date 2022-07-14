`timescale 1ns/10ps

                            // Change for your system
`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/hard/src/common/top/src/firmware_scr1.bin"
`define MEM_HIERARCH_PATH tb_mpei_rv_core_wrp.DUT.mpei_rv_core.u_scr1_wrp.u_scr1_top_ahb.i_tcm.i_dp_memory.ram_block
`define NWORD 32

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

module tb_mpei_rv_core_wrp ();

parameter slvselsz           = 1 ;  // for spictrl
parameter NAHBIRQ            = 32;  // for gptimer
parameter SCR1_XLEN          = 32;  // for scr Fuses
parameter SCR1_IRQ_LINES_NUM = 16;  // for scr IQR
parameter SCR1_AHB_WIDTH     = 32;  // for scr lenght of AHB

// Clock/reset generation & 
logic                clk_i            ;
logic                rstn_i           ;
               
logic                spi_in_miso      ;
logic                spi_in_mosi      ;
logic                spi_in_sck       ;
logic                spi_in_spisel    ;
logic                spi_in_astart    ;
logic                spi_in_cstart    ;
logic                spi_in_ignore    ;
logic                spi_in_io2       ;
logic                spi_in_io3       ;
logic                spi_out_miso     ;
logic                spi_out_misooen  ;
logic                spi_out_mosi     ;
logic                spi_out_mosioen  ;
logic                spi_out_sck      ;
logic                spi_out_sckoen   ;
logic                spi_out_enable   ;
logic                spi_out_astart   ;
logic                spi_out_aready   ;
logic                spi_out_io2      ;
logic                spi_out_io2oen   ;
logic                spi_out_io3      ;
logic                spi_out_io3oen   ;
logic [slvselsz-1:0] spi_out_slvsel   ;
          
logic                uart_in_rxd   	  ;
logic                uart_in_ctsn     ;
logic                uart_in_extclk	  ;
logic                uart_out_rtsn    ;
logic                uart_out_txd     ;
logic [31:0]         uart_out_scaler  ;
logic                uart_out_txen    ;
logic                uart_out_flow    ;
logic                uart_out_rxen    ;
logic                uart_out_txtick  ;
logic                uart_out_rxtick  ;
             
logic [31:0]         gpio_in_din      ;
logic [31:0]         gpio_in_sig_in   ;
logic [31:0]         gpio_in_sig_en   ;
logic [31:0]         gpio_out_dout    ;
logic [31:0]         gpio_out_oen     ;
logic [31:0]         gpio_out_val     ;
logic [31:0]         gpio_out_sig_out ;
               
logic                timr_in_dhalt    ;
logic                timr_in_extclk   ;
logic                timr_in_wdogen   ;
logic [NAHBIRQ-1:0]  timr_in_latchv   ;
logic [NAHBIRQ-1:0]  timr_in_latchd   ;
logic [0:7]          timr_out_tick    ;
logic [31:0]         timr_out_timer1  ;
logic                timr_out_wdogn   ;
logic                timr_out_wdog    ;

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
  .spi_in_miso           (spi_in_miso     ),
  .spi_in_mosi           (spi_in_mosi     ),
  .spi_in_sck            (spi_in_sck      ),
  .spi_in_spisel         (spi_in_spisel   ),
  .spi_in_astart         (spi_in_astart   ),
  .spi_in_cstart         (spi_in_cstart   ),
  .spi_in_ignore         (spi_in_ignore   ),
  .spi_in_io2            (spi_in_io2      ),
  .spi_in_io3            (spi_in_io3      ),
  .spi_out_miso          (spi_out_miso    ),
  .spi_out_misooen       (spi_out_misooen ),
  .spi_out_mosi          (spi_out_mosi    ),
  .spi_out_mosioen       (spi_out_mosioen ),
  .spi_out_sck           (spi_out_sck     ),
  .spi_out_sckoen        (spi_out_sckoen  ),
  .spi_out_enable        (spi_out_enable  ),
  .spi_out_astart        (spi_out_astart  ),
  .spi_out_aready        (spi_out_aready  ),
  .spi_out_io2           (spi_out_io2     ),
  .spi_out_io2oen        (spi_out_io2oen  ),
  .spi_out_io3           (spi_out_io3     ),
  .spi_out_io3oen        (spi_out_io3oen  ),
  .spi_out_slvsel        (spi_out_slvsel  ),
 
  //  apbuart interface     
  .uart_in_rxd           (uart_in_rxd     ), 
  .uart_in_ctsn          (uart_in_ctsn    ),  	
  .uart_in_extclk        (uart_in_extclk  ), 
  .uart_out_rtsn         (uart_out_rtsn   ),  	
  .uart_out_txd          (uart_out_txd    ), 
  .uart_out_scaler       (uart_out_scaler ),
  .uart_out_txen         (uart_out_txen   ),
  .uart_out_flow         (uart_out_flow   ), 	
  .uart_out_rxen         (uart_out_rxen   ),
  .uart_out_txtick       (uart_out_txtick ),
  .uart_out_rxtick       (uart_out_rxtick ),

  //  gpio interface  
  .gpio_in_din           (gpio_in_din     ),
  .gpio_in_sig_in        (gpio_in_sig_in  ),
  .gpio_in_sig_en        (gpio_in_sig_en  ),
  .gpio_out_dout         (gpio_out_dout   ),
  .gpio_out_oen          (gpio_out_oen    ),
  .gpio_out_val          (gpio_out_val    ),
  .gpio_out_sig_out      (gpio_out_sig_out),

  //  grtimer interface    
  .timr_in_dhalt         (timr_in_dhalt   ),
  .timr_in_extclk        (timr_in_extclk  ),
  .timr_in_wdogen        (timr_in_wdogen  ),
  .timr_in_latchv        (timr_in_latchv  ),
  .timr_in_latchd        (timr_in_latchd  ),
  .timr_out_tick         (timr_out_tick   ),
  .timr_out_timer1       (timr_out_timer1 ),
  .timr_out_wdogn        (timr_out_wdogn  ),
  .timr_out_wdog         (timr_out_wdog   )
);

logic ok = 1;

// tcm initialization
initial begin
  $readmemh (`MEM_PROGRAMM_PATH , `MEM_HIERARCH_PATH, 0, `NWORD-1 );
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
