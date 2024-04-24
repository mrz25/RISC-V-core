`timescale 1ns / 1ps

module testbench_reg_file();
    reg clk;
    reg WE3;
    reg [4:0] A1;
    reg [4:0] A2;
    reg [4:0] A3;
    reg [31:0] WD3;
    wire [31:0] RD1;
    wire [31:0] RD2;

Register_file REGISTER_ADD(.clk(clk), .WE3(WE3), .A1(A1), .A2(A2), .A3(A3), .WD3(WD3), .RD1(RD1), .RD2(RD2));

initial begin
    clk = 0;
    end

always begin
        #10 clk = ~clk;
        end

task OUTPUT;
    input [4:0] A1_in;
    input [4:0] A2_in;
    begin
       A1 = A1_in; 
       A2 = A2_in;            
       #100; 
       for (integer i = 0; i < 32 ; ++i)
            begin  
            WE3 = 1;
            A3 = i;
            WD3 = i;
            @ (posedge clk);
            WE3 = 0;
            @ (posedge clk);
            end
       $display("the contents of the register_file under %d the address: %d", A1, RD1);
       $display("the contents of the register_file under %d the address: %d", A2, RD2);
    end
endtask 

initial begin
    OUTPUT(0, 1);
    OUTPUT(2, 3);
    OUTPUT(4, 5);
    OUTPUT(6, 7);
    OUTPUT(8, 9);
    OUTPUT(10, 11);
    OUTPUT(12, 13);
    OUTPUT(30, 31);
end

endmodule
