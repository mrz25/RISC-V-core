`timescale 1ns / 1ps

module mem64_32(
        //input clk,
        input [31:0] adr,
        /*input [31:0] wd,
        input we,*/
        output reg [31:0] rd
    );
    
    reg [9:0] adr_;
    assign adr_ = adr[9:0];
    
    reg [7:0] RAM [0:1023];
    assign rd = {RAM[adr_ + 3], RAM[adr_ + 2], RAM[adr_ + 1], RAM[adr_]};
    
    /*always @ (posedge clk)
        if (we) RAM[adr] <= wd;*/
    
    initial $readmemh ("SeedData1.mem", RAM);
    
endmodule
