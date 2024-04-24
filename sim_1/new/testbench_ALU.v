`timescale 0.1ns / 1ps


module testbench_ALU();
    reg [4:0] ALU0p;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Result;
    wire Flag;

lab1_ALU ALU_ADD(.ALU0p(ALU0p), .A(A), .B(B), .Result(Result), .Flag(Flag));

task ALU_add;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00000;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add + b_add))
            $display("Correct %d + %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d + %d = %d", A, B, Result);
    end
    endtask
    
task ALU_sub;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b01000;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add - b_add))
            $display("Correct %d - %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d - %d = %d", A, B, Result);
    end
    endtask
    
task ALU_xor;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00100;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add ^ b_add))
            $display("Correct %d ^ %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d ^ %d = %d", A, B, Result);
    end
    endtask
    
task ALU_or;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00110;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add | b_add))
            $display("Correct %d | %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d | %d = %d", A, B, Result);
    end
    endtask

task ALU_and;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00111;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add & b_add))
            $display("Correct %d & %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d & %d = %d", A, B, Result);
    end
    endtask

task ALU_sra;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b01101;
        A = a_add;
        B = b_add;
        #100;
        if (Result == ($signed(a_add) >>> b_add))
            $display("Correct %d >>> %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d >>> %d = %d", A, B, Result);
    end
    endtask

task ALU_srl;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00101;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add >> b_add))
            $display("Correct %d >> %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d >> %d = %d", A, B, Result);
    end
    endtask

task ALU_sll;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00001;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add << b_add))
            $display("Correct %d << %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d << %d = %d", A, B, Result);
    end
    endtask
    
task ALU_slts;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00010;
        A = a_add;
        B = b_add;
        #10;
        if (Result == ($signed(a_add) < $signed(b_add)))
            $display("Correct %d < %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d < %d = %d", A, B, Result);
    end
    endtask

task ALU_sltu;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b00011;
        A = a_add;
        B = b_add;
        #100;
        if (Result == (a_add < b_add))
            $display("Correct %d < %d = %d", A, B, Result);
        else
            $display("Incorrect + ban %d < %d = %d", A, B, Result);
    end
    endtask
    
task ALU_lts;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11100;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == ($signed(a_add) < $signed(b_add)))
            $display("Correct %d < %d = %d", $signed(a_add), $signed(b_add), Flag);
        else
            $display("Incorrect + ban %d < %d = %d", $signed(a_add), $signed(b_add), Flag);
    end
    endtask

task ALU_ltu;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11110;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == (a_add < b_add))
            $display("Correct %d < %d = %d", a_add, b_add, Flag);
        else
            $display("Incorrect + ban %d < %d = %d", a_add, b_add, Flag);
    end
    endtask

task ALU_ges;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11101;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == ($signed(a_add) >= $signed(b_add)))
            $display("Correct %d >= %d = %d", $signed(a_add), $signed(b_add), Flag);
        else
            $display("Incorrect + ban %d >= %d = %d", $signed(a_add), $signed(a_add), Flag);
    end
    endtask
    
task ALU_geu;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11111;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == (a_add >= b_add))
            $display("Correct %d >= %d = %d", A, B, Flag);
        else
            $display("Incorrect + ban %d >= %d = %d", A, B, Flag);
    end
    endtask
    
task ALU_eq;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11000;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == (a_add == b_add))
            $display("Correct %d == %d = %d", A, B, Flag);
        else
            $display("Incorrect + ban %d == %d = %d", A, B, Flag);
    end
    endtask
    
task ALU_ne;
    input [31:0] a_add, b_add;
    begin
        ALU0p = 5'b11001;
        A = a_add;
        B = b_add;
        #100;
        if (Flag == (a_add != b_add))
            $display("Correct %d != %d = %d", A, B, Flag);
        else
            $display("Incorrect + ban %d != %d = %d", A, B, Flag);
    end
    endtask
    
initial begin
    ALU_add(9, 8);
    ALU_add(8, 5);
    ALU_sub(9, 2);
    ALU_xor(11, 2);
    ALU_or(10, 2);
    ALU_and(8, 2);
    ALU_sra(6, 1);
    ALU_srl(2, 6);
    ALU_sll(6, 2);
    ALU_slts(6, 2);
    ALU_sltu(8, 2);
    ALU_lts(8, 18);
    ALU_ltu(3, 2);
    ALU_ges(-7, 7);
    ALU_geu(9, 2);
    ALU_eq(9, 9);
    ALU_ne(8, 9);
    ALU_lts(100, -10);
    ALU_ges(-10, -10);
    $stop;
end

endmodule
