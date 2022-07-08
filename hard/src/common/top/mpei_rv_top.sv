`include "mpei_rv_core.vhd" 

module 
  (
  parameter slvselsz = 1;  // for spictrl
  parameter NAHBIRQ  = 32; // for gptimer
  )
  mpei_rv_top (
  input  logic                 clk_i      ,
  input  logic                 rstn_i     ,

  //     scr1_wrp interface
  //     what have to output? JTAG, IQR, Fuses, control pin?

  //     spictrl interface  
  input  logic                  miso_i    ,
  input  logic                  mosi_i    ,
  input  logic                  sck_i     ,
  input  logic                  spisel_i  ,
  input  logic                  astart_i  ,
  input  logic                  cstart_i  ,
  input  logic                  ignore_i  ,
  input  logic                  io2_i     ,
  input  logic                  io3_i     ,
  output logic                  miso_o    ,
  output logic                  misooen_o ,
  output logic                  mosi_o    ,
  output logic                  mosioen_o ,
  output logic                  sck_o     ,
  output logic                  sckoen_o  ,
  output logic                  enable_o  ,
  output logic                  astart_o  ,
  output logic                  aready_o  ,
  output logic                  io2_o     ,
  output logic                  io2oen_o  ,
  output logic                  io3_o     ,
  output logic                  io3oen_o  ,
  output logic  [slvselsz-1:0]  slvsel_o  ,

  //     apbuart interface
  input  logic                  rxd   	  ,
  input  logic                  ctsn   	  ,
  input  logic                  extclk	  ,
  output logic                  rtsn   	  ,
  output logic                  txd   	  ,
  output logic  [31:0]          scaler	  ,
  output logic                  txen      ,
  output logic                  flow   	  ,
  output logic                  rxen      ,
  output logic                  txtick    ,
  output logic                  rxtick    ,

  //     gpio interface
  input  logic  [31:0]          din       ,
  input  logic  [31:0]          sig_in    ,
  input  logic  [31:0]          sig_en    ,
  output logic  [31:0]          dout      ,
  output logic  [31:0]          oen       ,
  output logic  [31:0]          val       ,
  output logic  [31:0]          sig_out   ,

  //     grtimer interface
  output logic                  dhalt     ,
  output logic                  extclk    ,
  output logic                  wdogen    ,
  output logic  [NAHBIRQ-1:0]   latchv    ,
  output logic  [NAHBIRQ-1:0]   latchd    ,
  output logic  [0:7]           tick      ,
  output logic  [31:0]          timer1    ,
  output logic                  wdogn     ,
  output logic                  wdog      
);

mpei_rv_core #(
  .slvselsz   (slvselsz),
  .NAHBIRQ    (NAHBIRQ )
) mpei_rv_core ( 
  .clk_i      (clk_i   ),
  .rstn_i     (rstn_i  ),

  //  scr1_wrp interface        

  //  spictrl interface   
  .miso_i     (miso_i  ),
  .mosi_i     (mosi_i  ),
  .sck_i      (sck_i   ),
  .spisel_i   (spisel_i),
  .astart_i   (astart_i),
  .cstart_i   (cstart_i),
  .ignore_i   (ignore_i),
  .io2_i      (io2_i   ),
  .io3_i      (io3_i   ),
  .miso_o     (miso_o  ),
  .misooen_o  (misooen_),
  .mosi_o     (mosi_o  ),
  .mosioen_o  (mosioen_),
  .sck_o      (sck_o   ),
  .sckoen_o   (sckoen_o),
  .enable_o   (enable_o),
  .astart_o   (astart_o),
  .aready_o   (aready_o),
  .io2_o      (io2_o   ),
  .io2oen_o   (io2oen_o),
  .io3_o      (io3_o   ),
  .io3oen_o   (io3oen_o),
  .slvsel_o   (slvsel_o),

  //  apbuart interface    
  .rxd        (rxd     ), 
  .ctsn       (ctsn    ),  	
  .extclk     (extclk  ), 
  .rtsn       (rtsn    ),  	
  .txd        (txd     ), 
  .scaler     (scaler  ),
  .txen       (txen    ),
  .flow       (flow    ), 	
  .rxen       (rxen    ),
  .txtick     (txtick  ),
  .rxtick     (rxtick  ),

  //  gpio interface  
  .din        (din     ),
  .sig_in     (sig_in  ),
  .sig_en     (sig_en  ),
  .dout       (dout    ),
  .oen        (oen     ),
  .val        (val     ),
  .sig_out    (sig_out ),

  //  grtimer interface    
  .dhalt      (dhalt   ),
  .extclk     (extclk  ),
  .wdogen     (wdogen  ),
  .latchv     (latchv  ),
  .latchd     (latchd  ),
  .tick       (tick    ),
  .timer1     (timer1  ),
  .wdogn      (wdogn   ),
  .wdog       (wdog    )
);

endmodule 
