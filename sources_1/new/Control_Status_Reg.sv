`timescale 1ns / 1ps

module Control_Status_Reg(
    input clk,
    input [2:0] OP,
    input [31:0] mcause,
    input [31:0] PC,
    input [11:0] A,
    input [31:0] WD,
    
    output reg [31:0] RD,
    output reg [31:0] mepc,
    output reg [31:0] mtvec,
    output reg [31:0] mie
    );
    reg [31:0] buff_pc;
    reg EN_1 = 0;
    reg EN_2 = 0;
    reg EN_3 = 0;
    wire EN_4;
    wire EN_5;
    reg or_mepc;
    reg or_mcause;
    wire OR_OP_1_2;
    
    reg [31:0] buff_1;
    reg [31:0] buff_2;
    reg [31:0] buff_3; //mscratch
    reg [31:0] buff_4;
    reg [31:0] buff_5;
    
    reg [31:0] MUX_WD_4;
    reg [31:0] MUX_WD_5;
   
    assign OR_OP_1_2 = OP[1] | OP[0];
    
    assign EN_4 = OP[2] | or_mepc;
    assign EN_5 = OP[2] | or_mcause;
    
    always @(*)
        begin
            case(A)
                12'h304:
                    begin
                    EN_1 = OR_OP_1_2;
                    EN_2 = 0;     
                    EN_3 = 0;     
                    or_mepc = 0;  
                    or_mcause = 0;
                    end
                12'h305:
                    begin
                    EN_1 = 0;
                    EN_2 = OR_OP_1_2;     
                    EN_3 = 0;     
                    or_mepc = 0;  
                    or_mcause = 0;
                    end                                
                12'h340:
                    begin
                    EN_1 = 0;
                    EN_2 = 0;     
                    EN_3 = OR_OP_1_2;     
                    or_mepc = 0;  
                    or_mcause = 0;
                    end 
                12'h341:
                    begin
                    EN_1 = 0;
                    EN_2 = 0;     
                    EN_3 = 0;     
                    or_mepc = OR_OP_1_2; 
                    or_mcause = 0;
                    end 
                12'h342:
                    begin
                    EN_1 = 0;
                    EN_2 = 0;     
                    EN_3 = 0;     
                    or_mepc = 0; 
                    or_mcause = OR_OP_1_2;
                    end 
                default:
                    begin
                    EN_1 = 0;
                    EN_2 = 0;
                    EN_3 = 0;
                    or_mepc = 0;
                    or_mcause = 0;
                    end
            endcase                
        end
   
    reg [31:0] MUX_WD;
    
    always @(*)
        begin
        case(OP[1:0])
            2'd0:
                MUX_WD = 32'b0;
            2'd1:
                MUX_WD = WD;
            2'd2:
                MUX_WD = RD | WD;
            2'd3:
                MUX_WD = RD & ~WD;
            /*default:
                MUX_WD = 32'b0;*/
        endcase
         
        case(A)
            12'h304:
                RD = buff_1;
            12'h305:
                RD = buff_2;                                
            12'h340:
                RD = buff_3;
            12'h341:
                RD = buff_4;
            12'h342:
                RD = buff_5;
            default:
                begin
                    RD = 32'b0;
                end
        endcase 
        mie = buff_1;              
        mtvec = buff_2;              
        mepc = buff_4; 
        
        MUX_WD_4 = OP[2] ? buff_pc : MUX_WD;             
        MUX_WD_5 = OP[2] ? mcause : MUX_WD;             
    end    
    
    always @(posedge clk)
        begin
            buff_pc <= PC;
            buff_1 <= EN_1 ? MUX_WD : buff_1;
            buff_2 <= EN_2 ? MUX_WD : buff_2;
            buff_3 <= EN_3 ? MUX_WD : buff_3;
            buff_4 <= EN_4 ? MUX_WD_4 : buff_4;
            buff_5 <= EN_5 ? MUX_WD_5 : buff_5;
        end
endmodule
