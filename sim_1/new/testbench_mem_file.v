`timescale 1ns / 1ps

module testbench_mem_file();
        reg clk;
        reg [5:0] adr;
        /*reg [31:0] wd;
        reg we;*/
        wire [31:0] rd;
        
mem64_32 MEMORY_ADD(.clk(clk), .adr(adr), .rd(rd));

initial clk = 0;

always
        #10 clk = ~clk;
        
task READ;
    input [5:0] adr_out;
    begin
        adr = adr_out;
        /*wd = 0;
        we = 0;*/
        #20;
        $display("the contents of the RAM under %d the address: %d", adr, rd);
    end    
endtask

/*task WRITE;
    input [5:0] adr_out;
    input [31:0] wd_out;
    begin
        adr = adr_out;
        wd = wd_out;
        we = 1;
        #20;
        $display("the contents of the RAM under %d the address: %d", adr, rd);
    end    
endtask*/

initial begin
    READ(5);
    READ(3);
    READ(6);
    READ(15);
    /*WRITE(0, 191);
    WRITE(2, 191);
    WRITE(1, 91);
    WRITE(3, 111);
    WRITE(15, 100);*/
end

endmodule
