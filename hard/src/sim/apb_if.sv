interface apb_if 
   #(PDATAW=32) 
    (input pclk); 



   logic [    PDATAW-1:0] paddr  ;
   logic                  psel   ;
   logic                  penable;
   logic                  pwrite ;
   logic [PDATAW/8 -1: 0] pstrb  ;
   logic [           2:0] pprot  ;
   logic [    PDATAW-1:0] pwdata ;
   logic                  pready ;
   logic [    PDATAW-1:0] prdata ;
   logic                  pslverr;

   modport mst (
                  input    pclk,
                  output   paddr   ,
                  output   psel    ,
                  output   penable ,
                  output   pwrite  ,
                  output   pstrb   ,
                  output   pprot   ,
                  output   pwdata  ,
                  input    pready  ,
                  input    prdata  , 
                  input    pslverr 
               );

   // synopsys translate_off
   modport mst_tb (
                     input    pclk,
                     output   paddr   ,
                     output   psel    ,
                     output   penable ,
                     output   pwrite  ,
                     output   pstrb   ,
                     output   pprot   ,
                     output   pwdata  ,
                     input    pready  ,
                     input    prdata  , 
                     input    pslverr ,
                     import   init,
                     import   write_arr,
                     import   write,
                     import   cyc_wait,
                     import   mon,
                     import   read,
                     import get_arr
               );
   // synopsys translate_on
   
   modport slv (
                  input pclk,
                  input   paddr   ,
                  input   psel    ,
                  input   penable ,
                  input   pwrite  ,
                  input   pstrb   ,
                  input   pprot   ,
                  input   pwdata  ,
                  output  pready  ,
                  output  prdata  , 
                  output  pslverr 
               );
   // synopsys translate_off
   modport slv_tb (
                        input pclk,
                        input   paddr   ,
                        input   psel    ,
                        input   penable ,
                        input   pwrite  ,
                        input   pstrb   ,
                        input   pprot   ,
                        input   pwdata  ,
                        output  pready  ,
                        output  prdata  , 
                        output  pslverr ,
                        import mon
               );
   // synopsys translate_on








   /*------------------------------------------------------------------------------
   --  TASKS FOR TESTING
   ------------------------------------------------------------------------------*/

      
      // synopsys translate_off
    
    
      task automatic write_arr(input bit [PDATAW-1:0] data_arr[$],input bit [PDATAW-1:0] addr_arr[$],input bit [PDATAW/8 -1:0] strb_arr[$] = {}, int wait_seed = 0);
         while(addr_arr.size()) begin
            cyc_wait($urandom_range(wait_seed));
            if(strb_arr.size()==0) write(data_arr.pop_front(),addr_arr.pop_front());
            else                   write(data_arr.pop_front(),addr_arr.pop_front(),strb_arr.pop_front());
         end
      endtask 

      task automatic init();
         pwdata   <= '0;
         paddr    <= '0;
         pwrite   <=  0;
         psel     <=  0;
         pstrb    <= '0;
         pprot    <= '0;
         penable  <=  0;
      endtask

      // simple apb transaction
      task automatic write(bit [PDATAW-1:0] data,[PDATAW-1:0] addr,bit [PDATAW/8 -1:0] strb=4'hF);
         pwdata   <=  data;
         paddr    <=  addr;
         pwrite   <=  1;
         psel     <=  1;
         pstrb    <=  strb;
         pprot    <= '1;
         penable  <=  0;

         @(posedge pclk);

         penable  <= 1; 
        
         do @(posedge pclk); while(!(pready));

         pwdata   <= '0;
         paddr    <= '0;
         pwrite   <= '0;
         psel     <=  0;
         pstrb    <= '0;
         pprot    <= '0;
         penable  <=  0;
      endtask

      task automatic read(output bit [PDATAW-1:0] data,input bit [PDATAW-1:0] addr);
         paddr    <= addr;
         pwrite   <= 0;
         psel     <= 1;
         pstrb    <= '1;
         penable  <= 0;

         @(posedge pclk);

         penable  <= 1; 
        
         do @(posedge pclk) data = prdata; while(!(pready));

         paddr    <= '0;
         pwrite   <= '0;
         psel     <=  0;
         penable  <=  0;
      endtask


      // receive axis packet
      task automatic get_arr(ref bit [PDATAW-1:0] data_arr[$],input bit [PDATAW-1:0] addr_arr[$],bit clr_data_arr=1);
         bit [PDATAW-1:0] tmp;
         if(clr_data_arr) data_arr = {};
         while(addr_arr.size()) begin
            read(tmp,addr_arr.pop_front());
            data_arr.push_back(tmp);
         end
      endtask

   

   // just insert wait cycles
   task automatic cyc_wait(int cycles = 1);
      repeat(cycles) @(posedge pclk);
   endtask

   // simple      monitor                                                                 // verbose
   task automatic mon(string src="APB_SLV",ref string log_buf[$],input bit [1:0] verbose=2'b01); // 00 - verbose off , 01 - to console   
                                                                                          // 10 - add strs to buf, 11 - clear buf, than logging
      if(verbose==2'b11) log_buf = {};
      while(1) begin
         do @(posedge pclk); while(!(psel && penable && pready));                                                           
         case (verbose)
            2'b01: begin
               if(pwrite)
                  $display("TIME:%g ns : %9s  pwdata=%8h, paddr=%8h, pstrb=%4b",$time, src, pwdata, paddr, pstrb);
               else
                  $display("TIME:%g ns : %9s  prdata=%8h, paddr=%8h",$time, src, prdata, paddr);
            end
            2'b11,2'b10: begin
               if(pwrite)
                  log_buf.push_back($sformatf("TIME:%g ns : %9s  pwdata=%8h, paddr=%8h, pstrb=%4b",$time, src, pwdata, paddr, pstrb));
               else
                  log_buf.push_back($sformatf("TIME:%g ns : %9s  prdata=%8h, paddr=%8h",$time, src, prdata, paddr));
            end
         endcase
      end
   endtask
   
   // synopsys translate_on
   
endinterface