`include "mpei_rv_core.vhd" //? or mpei_rv_core_expander.vhd

module mpei_rv_top (
  input logic clk_i  ,
  input logic rstn_i ,

  //       SCR1_WRP  
  // what have to output? JTAG, IQR, Fuses, control pin?

  //       SPICTRL   
  spii   : in  spi_in_type;
  spio   : out spi_out_type;
  slvsel : out std_logic_vector((slvselsz-1) downto 0);
                          
  //       APBURT 
  uarti  : in  uart_in_type;
  uarto  : out uart_out_type;

  //       GPIO 
  gpioi  : in  gpio_in_i_type;
  gpioo  : out gpio_out_type;

  //       GRTIER 
  gpti   : in  gptimer_in_type;
  gpto   : out gptimer_out_type  
);

mpei_rv_core mpei_rv_core ( //or mpei_rv_core_expander

);


endmodule 
