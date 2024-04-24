`timescale 1ns / 1ps

module tb_miriscv_top();

  parameter     HF_CYCLE = 2.5;       // 200 MHz clock
  parameter     RST_WAIT = 10;         // 10 ns reset
  parameter     RAM_SIZE = 4096;       // in 32-bit words

  // clock, reset
  reg clk;
  reg rst_n_i;
  reg [15:0] sw_input_1 = 16'b0;
  reg [15:0] led_output_2;

  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE        ),
    .RAM_INIT_FILE  ( "SeedData1.mem" )
  ) dut (
    .clk_i    ( clk   ),
    .rst_n_i  ( rst_n_i ), 
    .sw_i( sw_input_1 ),
    .led_o( led_output_2 )
  );

  initial begin
    clk   = 1'b0;
    rst_n_i = 1'b0;
    #RST_WAIT;
    rst_n_i = 1'b1;
    #402.5;
    sw_input_1 = 16'b1010111001001010;
    #800;
    sw_input_1 = 16'b1010100000000000;
    #800;
    sw_input_1 = 16'b1111111111111111;
  end
    
  /*always@(*)
    begin
    if(OUT_ == 32'h20)  
        input_1 = 32'b0;
    else 
        if(OUT_ == 32'h80000)
            input_2 = 32'b0;
    end*/
    
  always begin
    #HF_CYCLE;
    clk = ~clk;
  end

endmodule