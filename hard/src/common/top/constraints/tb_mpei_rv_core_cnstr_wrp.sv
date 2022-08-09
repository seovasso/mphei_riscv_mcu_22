`timescale 1ns/10ps

                            // Change for your system                      
`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/soft/scr1_example_project/soft/eclipse/projects/scr1_test_project/Debug/scr1_test_project.bin" //path to C work directory
//`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/hard/src/common/top/src/scr1_test_project.bin"                          //path to vivado work directory
//`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/hard/src/common/top/src/firmware_scr1.bin"                              //path to vivado work directory
`define MEM_HIERARCH_PATH tb_mpei_rv_core_cnstr_wrp.DUT.mpei_rv_core_cnstr.u_scr1_wrp.u_scr1_top_ahb.i_tcm.i_dp_memory.ram_block

//`define NWORD 32

`define CLK_PERIOD 10
`define RESET_GOES_HIGH 150

module tb_mpei_rv_core_cnstr_wrp ();

parameter slvselsz           = 4 ;  // for spictrl
parameter NAHBIRQ            = 32;  // for gptimer
parameter SCR1_XLEN          = 32;  // for scr Fuses
parameter SCR1_IRQ_LINES_NUM = 16;  // for scr IQR
parameter SCR1_AHB_WIDTH     = 32;  // for scr lenght of AHB

// Clock/reset generation & 
logic                clk_i            ;
logic                rstn_i           ;
           
logic                jtag_trst_n     ;
logic                jtag_tck        ;
logic                jtag_tms        ;
logic                jtag_tdi        ;
logic                jtag_tdo        ;
logic                jtag_tdo_en     ;

logic                spi_in_miso      = 1;     // not used at this time 
logic                spi_in_mosi      = 1;     // not used at this time
logic                spi_in_sck       = 0;  // established according to the book p.1757 and spi.vhd
logic                spi_in_spisel    = 1;  // established according to the book p.1757 and spi.vhd
logic                spi_in_astart    = 0;  // established according to the book p.1757 and spi.vhd
logic                spi_in_cstart    = 0;  // established according to the book p.1757 and spi.vhd
logic                spi_in_ignore    = 0;
logic                spi_in_io2       = 1;
logic                spi_in_io3       = 1;
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
          
logic                uart_in_rxd   	  ;     // not used at this time
logic                uart_in_ctsn     = 0;  // established according to the book p.----
logic                uart_in_extclk	  = 0;  // established according to the book p.----
logic                uart_out_rtsn    ;
logic                uart_out_txd     ;
logic [31:0]         uart_out_scaler  ;
logic                uart_out_txen    ;
logic                uart_out_flow    ;
logic                uart_out_rxen    ;
logic                uart_out_txtick  ;
logic                uart_out_rxtick  ;
             
logic [31:0]         gpio_in_din      = 32'hABCD_0000;
logic [31:0]         gpio_in_sig_in   = 32'h00AB_CD00;
logic [31:0]         gpio_in_sig_en   ;
logic [31:0]         gpio_out_dout    ;
logic [31:0]         gpio_out_oen     ;
logic [31:0]         gpio_out_val     ;
logic [31:0]         gpio_out_sig_out ;
               
logic                timr_in_dhalt    = 1'b0;
logic                timr_in_extclk   = 1'b0;
logic                timr_in_wdogen   = 1'b0;
logic [NAHBIRQ-1:0]  timr_in_latchv   = 32'h0000_0000;
logic [NAHBIRQ-1:0]  timr_in_latchd   = 32'h0000_0000;
logic [0:7]          timr_out_tick    ;
logic [31:0]         timr_out_timer1  ;
logic                timr_out_wdogn   ;
logic                timr_out_wdog    ;

mpei_rv_core_cnstr_wrp #(
  .slvselsz           (slvselsz          ),
  .NAHBIRQ            (NAHBIRQ           ),
  .SCR1_XLEN          (SCR1_XLEN         ),
  .SCR1_IRQ_LINES_NUM (SCR1_IRQ_LINES_NUM),
  .SCR1_AHB_WIDTH     (SCR1_AHB_WIDTH    )
) DUT (  
  //  scr1_wrp interface       
  .clk_i                 (clk_i           ),
  .rstn_i                (rstn_i          ),
       
  //  JTAG interface
  .jtag_tck              (jtag_tck        ),
  .jtag_tms              (jtag_tms        ),
  .jtag_tdi              (jtag_tdi        ),
  .jtag_tdo              (jtag_tdo        ),
 
  //  apbuart interface     
  .uart_in_rxd           (uart_in_rxd     ),  // UART transfer data to itself !!! (for test)
  .uart_out_txd          (uart_out_txd    ) 
);

logic ok     = 1;

// tcm initialization
`define MEMSIZE 16384
integer data_file;
integer iii;
logic   [31:0] tbmem [`MEMSIZE-1:0];
initial begin 
  //read file
  data_file = $fopen(`MEM_PROGRAMM_PATH, "rb");
  if (data_file == 0) begin //NULL (file didn't open)
    $display("data_file handle was NULL");
    $finish;
  end
  
  //read data from file
  $fread(tbmem, data_file); //$fread(memory, file, start_index_of_memory, needed_count_word_for_write);

  //change byte endianness
  iii = 0;
  repeat(`MEMSIZE) begin
    `MEM_HIERARCH_PATH[iii][31:28] = tbmem[iii][7:4]  ;
    `MEM_HIERARCH_PATH[iii][27:24] = tbmem[iii][3:0]  ;
    `MEM_HIERARCH_PATH[iii][23:20] = tbmem[iii][15:12];
    `MEM_HIERARCH_PATH[iii][19:16] = tbmem[iii][11:8] ;
    `MEM_HIERARCH_PATH[iii][15:12] = tbmem[iii][23:20];
    `MEM_HIERARCH_PATH[iii][11:8]  = tbmem[iii][19:16];
    `MEM_HIERARCH_PATH[iii][7:4]   = tbmem[iii][31:28];
    `MEM_HIERARCH_PATH[iii][3:0]   = tbmem[iii][27:24];
    iii = iii + 1;
  end
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

  gpio_in_sig_en   = 32'h0000_0000;

  #8000 gpio_in_sig_en   = 32'hFFFF_FFFF;

  //if (ok == 1) $display("TEST PASSED");
  //else         $display("TEST FAILED");

  #10000 $stop();
end

endmodule
