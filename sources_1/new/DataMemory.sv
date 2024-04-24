`timescale 1ns / 1ps

module DataMemory(
    input [31:0] A,
    input [31:0] WD,
    input clk,
    input reset,
    input WE,
    //input I,
    output reg [31:0] RD
    );
    
    reg [7:0] DataMemory [0:1023];
    
    always @ (posedge clk)
        if (reset)
            for(int i = 0; i < 1024; i = i + 1)
                DataMemory[i] <= 8'b0;
        else  
        if (A[31:10] == 22'b1001011000000000000000)
            if(WE)    
                begin
                    DataMemory[A[9:0]] <= WD[7:0];
                    DataMemory[A[9:0] + 1] <= WD[15:8];
                    DataMemory[A[9:0] + 2] <= WD[23:16];
                    DataMemory[A[9:0] + 3] <= WD[31:24];
                    //RD <= {{DataMemory[A[9:0] + 3]}, {DataMemory[A[9:0] + 2]}, {DataMemory[A[9:0] + 1]}, {DataMemory[A[9:0]]}};
                end
            /*else
                begin
                    RD <= {{DataMemory[A[9:0] + 3]}, {DataMemory[A[9:0] + 2]}, {DataMemory[A[9:0] + 1]}, {DataMemory[A[9:0]]}};
                end*/
        else
            begin
                
                RD <= 32'b0;
            end
            
     always @(*)
         if (A[31:10] == 22'b1001011000000000000000)
            RD <= {{DataMemory[A[9:0] + 3]}, {DataMemory[A[9:0] + 2]}, {DataMemory[A[9:0] + 1]}, {DataMemory[A[9:0]]}}; 
         else 
            RD <= 32'b0;
endmodule
