`timescale 1ns / 1ps


module Led_Controller(
    input  logic        clk,
    input  logic [31:0] led_addres,
    input  logic [31:0] led_wdata,
    //input  logic [31:0] int_req_led_i,
    //input  logic [31:0] int_fin_led_i,
    //output logic [31:0] int_req_led_o,
    input  logic        we_d0,
    input  logic [3:0]  be_d0,
    output logic [31:0] out_reg_led
    );
    logic [15:0] led_reg;
    assign out_reg_led = {{ 16 {1'b0}} ,led_reg};
    
    /*always_comb
        if(int_fin_led_i != 32'h20)
            int_req_led_o = int_req_led_i;
        else
            int_req_led_o = 32'b0;*/
            
    always @(posedge clk)
        if(we_d0)
            case(be_d0)
                4'b0011:
                    led_reg = led_wdata[15:0];
                4'b1100:
                    led_reg = led_wdata[31:16];
                default:
                    led_reg = led_reg;
            endcase
            
endmodule
