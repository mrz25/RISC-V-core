`timescale 1ns / 1ps

module Switch_Controller(
    input  logic        clk,
    input  logic [31:0] sw_addres,
    input  logic [31:0] sw_wdata,
    input  logic [31:0] int_fin_sw_i,
    output logic [31:0] int_req_sw_o = 32'b0,
    input  logic        we_d1,
    input  logic [15:0] sw_16,
    output logic [31:0] out_reg_sw
    );
    logic [31:0] sw_32 = 32'b0;
    
    assign out_reg_sw = sw_32;
    
always_ff @(posedge clk)
    begin
       if(sw_32 != {{16 {1'b0}}, sw_16})
            int_req_sw_o = 32'h20;
       else 
            if(int_fin_sw_i == int_req_sw_o)
                int_req_sw_o = 32'b0;
       sw_32 = {{16 {1'b0}}, sw_16};
    end  

endmodule
