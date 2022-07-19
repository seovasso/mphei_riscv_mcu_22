`timescale 1ns/1ns

`include "mem.sv"

//`define MEM_PROGRAMM_PATH "C:/Users/nmari/eclipse-workspace/scr1_example_project/soft/eclipse/projects/scr1_test_project/Debug/scr1_test_project.bin" //path to C work directory
`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/hard/src/common/top/src/scr1_test_project.bin"                          //path to vivado work directory
//`define MEM_PROGRAMM_PATH "C:/Users/nmari/Documents/GitHub/mphei_riscv_mcu_22/hard/src/common/top/src/firmware_scr1.bin"                              //path to vivado work directory
`define MEM_HIERARCH_PATH tb_mem.DUT.mem  //mem

`define NWORD 32

module tb_mem();

logic in;
logic out;
logic clk;

initial begin
  clk = 1'b0;
  
end

initial forever begin
  #10 clk = ~clk;
end

integer i;
integer data_file; // file handler
integer scan_file;
integer position;

`define NULL 0  
`define SEEK_SET 0

logic [31:0] memtb [500:0];
logic [12263:0] arraytb ;

mem DUT (.in(in), .out(out));

initial begin
  data_file = $fopen(`MEM_PROGRAMM_PATH, "rb");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

`define SIZEOFMEM 10

initial begin

    //scan_file = $fseek(data_file, 0, `SEEK_SET); /* Beginning */

    i = 0;
    scan_file = $fread(memtb, data_file);

    // repeat(`SIZEOFMEM - 5) begin
    //   scan_file = $fread(memtb[i], data_file);
    //   i = i + 1;
    // end

    // repeat (1533) begin
    //   scan_file = $fread(memtb[i], data_file);
    //   i = i + 1;
    // end

    // memtb[i] = $fgetc(data_file);

    // while (memtb[i] != -1) begin
    //   i = i + 1;
    //   memtb[i] = $fgetc(data_file);
    // end
    


    // scan_file = $fscanf(data_file, "%s", arraytb);

    // scan_file = $fseek(data_file, 0, `SEEK_SET); /* Beginning */
    // scan_file = $fscanf(data_file, "%s", memtb[i]);
    // position = $ftell(data_file);
    
    //position = 0;
    //repeat(15000) begin
      //scan_file = $fseek(data_file, position, `SEEK_SET); /* Previous loc */
      //scan_file = $fscanf(data_file, "%s", arraytb);
      //position = $ftell(data_file);
    //  i = i + 1;
    //end
    
    

    //memtb[i] = $fgetc(data_file);

    // repeat(100) begin
    //     i = i + 1;
    //     if (!$feof(data_file)) begin
    //         scan_file = $fscanf(data_file, "%b", arraytb);
    //         //memtb[i] = $fgetc(data_file);
    //     end
    // end

    //$fclose(data_file);
end

// // tcm initialization
// initial begin
//     //$readmemb (`MEM_PROGRAMM_PATH , `MEM_HIERARCH_PATH, 0, `NWORD-1 );
//     $readmemb (`MEM_PROGRAMM_PATH, arraytb);

//     //$writememb(`MEM_PROGRAMM_PATH, `MEM_HIERARCH_PATH);
// end

endmodule