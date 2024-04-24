`timescale 1ns / 1ps

module testbench_device_connect();
    reg [31:0] SW_in;
    reg clk;
    reg reset;
    wire [31:0] out_command;

device_connection DEVICE_ADD(.clk(clk), .reset(reset), .SW_in(SW_in), .out_command(out_command));

always
#10 clk = ~clk;


initial begin
    SW_in = 7;
    clk = 0;
    @( posedge clk ) reset = 0;
    @( posedge clk ) reset = 1;
    @( posedge clk ) reset = 0;
    #100    
    $display("cheto tam: %d", out_command);
end    

endmodule
