`timescale 1ns / 1ps

module Register_file(
    input clk,
    input WE3,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
    );
    reg [31:0] Registers [0:31];
    
    assign RD1 = (A1 != 0) ? Registers[A1] : 32'b0;
    assign RD2 = (A2 != 0) ? Registers[A2] : 32'b0;
    
    always @ (posedge clk)
        /*if (reset)
            for(int i = 0; i < 32; i = i + 1)
                Registers[i] <= 32'b0;*/
        /*else*/ if(WE3)    
            Registers[A3] <= WD3;
endmodule
