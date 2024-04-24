`timescale 1ns / 1ps

`include "./defines_riscv.v"

module decoder_riscv(
  input       [31:0]  fetched_instr_i,
  output  reg [1:0]   ex_op_a_sel_o,      // выходы сделаны регистрами,
  output  reg [2:0]   ex_op_b_sel_o,      // потому что всё устройство 
  output  reg [4:0]   alu_op_o,           // будет комбинационной схемой
  output  reg         mem_req_o,          // описанной внутри блока 
  output  reg         mem_we_o,           // always, а слева от знака равно
  output  reg [2:0]   mem_size_o,         // внутри always должны стоять
  output  reg         gpr_we_a_o,         // всегда только регистры,
  output  reg         wb_src_sel_o,       // даже если в итоге схема
  output  reg         illegal_instr_o,    // превратится в
  output  reg         branch_o,           // комбинационно устройство
  output  reg         jal_o,              // без памяти
  output  reg  [1:0]  jalr_o,             // 
  
  input               stall,
  output  reg         en_pc,
  input               interrupt,
  output  reg         INT_RST,
  output  reg  [2:0]  CSRop,
  output  reg         csr
);

//0000 0000 0010 0000 0000 0000 0111 0011

always_comb begin   
if(interrupt)
    begin
        jalr_o <= 2'd3;
        CSRop <= 3'b100;
        csr <= 1;
        mem_we_o <= 1'b0;
        en_pc <= 0;
        
        wb_src_sel_o <= 0;
        ex_op_a_sel_o <= 2'b00;
        ex_op_b_sel_o <= 3'b000;
        mem_req_o <= 0;
        mem_size_o <= 0;
        gpr_we_a_o <= 0;
        illegal_instr_o <= 0;
        branch_o <= 0;
        jal_o <= 0;
        INT_RST <= 1'b0;
        alu_op_o <= 0;
    end
else 
    begin
    alu_op_o <=0 ;
    en_pc <= stall;
    jalr_o <= 2'd3;
    CSRop <= 3'b100;
    csr <= 0;
    mem_we_o <= 1'b0;
    wb_src_sel_o <= 0;
    ex_op_a_sel_o <= 2'b00;
    ex_op_b_sel_o <= 3'b000;
    mem_req_o <= 0;
    mem_size_o <= 0;
    gpr_we_a_o <= 0;
    illegal_instr_o <= 0;
    branch_o <= 0;
    jal_o <= 0;
    INT_RST <= 1'b0;
    if (fetched_instr_i[1:0] == 2'b11)                   
        case(fetched_instr_i[6:2])
            5'b01100:   // R
            begin
                wb_src_sel_o <= 0;
                ex_op_a_sel_o <= 2'b00;
                ex_op_b_sel_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 1;
                illegal_instr_o <= 0;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 2'b00;
                INT_RST <= 1'b0;
                csr <= 0;
                CSRop <= 0;
                INT_RST <= 0;
                case(fetched_instr_i[14:12])
                    3'b000:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_ADD;
                            7'b0100000:
                                alu_op_o <= `ALU_SUB;
                            default:
                                begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                                end
                         endcase
                    3'b001:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_SLL;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    3'b010:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_SLTS;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    3'b011:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_SLTU;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    3'b100:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_XOR;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    3'b101:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_SRL;
                            7'b0100000:
                                alu_op_o <= `ALU_SRA;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end                            
                        endcase
                    3'b110:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_OR;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    3'b111:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_AND;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                            end
                         endcase
                    /*default:
                    begin
                        alu_op_o <= 0;
                        illegal_instr_o <= 1;
                        gpr_we_a_o <= 0;
                        INT_RST <= 1'b0;
                    end */
                endcase
            end
            
            5'b00100:   // I
            begin
            wb_src_sel_o <= 0;
            ex_op_a_sel_o <= 2'b00;
            ex_op_b_sel_o <= 1;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 0;
            gpr_we_a_o <= 1;
            illegal_instr_o <= 0;
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 2'b00;
            csr <= 0;    
            CSRop <= 0;  
            INT_RST <= 0;
                case(fetched_instr_i[14:12])
                    3'b000:
                        alu_op_o <= `ALU_ADD;
                    3'b010:
                        alu_op_o <= `ALU_SLTS;
                    3'b011:
                        alu_op_o <= `ALU_SLTU;
                    3'b100:
                        alu_op_o <= `ALU_XOR;
                    3'b110:
                        alu_op_o <= `ALU_OR;
                    3'b111:
                        alu_op_o <= `ALU_AND;
                    3'b001:
                        case(fetched_instr_i[31:25])
                        7'b0000000:
                            alu_op_o <= `ALU_SLL;
                        default:
                        begin
                            ex_op_b_sel_o <= 0;
                            alu_op_o <= 0;
                            illegal_instr_o <= 1;
                            gpr_we_a_o <= 0;
                        end                    
                        endcase
                    3'b101:
                        case(fetched_instr_i[31:25])
                            7'b0000000:
                                alu_op_o <= `ALU_SRL;
                            7'b0100000:
                                alu_op_o <= `ALU_SRA;
                            default:
                            begin
                                alu_op_o <= 0;
                                illegal_instr_o <= 1;
                                gpr_we_a_o <= 0;
                                ex_op_b_sel_o <= 0;
                            end
                        endcase
                 /*default:
                 begin
                     alu_op_o <= 0;
                     illegal_instr_o <= 1;
                     gpr_we_a_o <= 0;
                     ex_op_b_sel_o <= 0;
                     INT_RST <= 1'b0;
                 end*/
                 endcase
            end   
                        
            5'b00000:   // I
            begin
            wb_src_sel_o <= 1;
            ex_op_a_sel_o <= 2'b00;
            ex_op_b_sel_o <= 3'b001;
            alu_op_o <= `ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 0;
            gpr_we_a_o <= 1;
            illegal_instr_o <= 0;
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 2'b00;    
            csr <= 0;    
            CSRop <= 0;  
            INT_RST <= 0;
                case(fetched_instr_i[14:12])
                    3'b000:
                        mem_size_o <= 3'd0;
                    3'b001:
                        mem_size_o <= 3'd1;
                    3'b010:
                        mem_size_o <= 3'd2;
                    3'b100:
                        mem_size_o <= 3'd4;
                    3'b101:
                        mem_size_o <= 3'd5;
                    default:
                    begin
                        mem_size_o <= 0;
                        alu_op_o <= 0;
                        illegal_instr_o <= 1;
                        ex_op_b_sel_o <= 0;
                        gpr_we_a_o <= 0;
                        mem_req_o <= 0;
                        wb_src_sel_o <= 0;
                        INT_RST <= 1'b0;
                    end
                endcase
            end 
               
            5'b01000:   // S
            begin
            wb_src_sel_o <= 1;
            ex_op_a_sel_o <= 2'b00;
            ex_op_b_sel_o <= 3'b011;
            alu_op_o <= `ALU_ADD;
            mem_req_o <= 1;
            mem_we_o <= 1;
            gpr_we_a_o <= 0;
            illegal_instr_o <= 0;
            branch_o <= 0;
            jal_o <= 0;
            jalr_o <= 2'b00;
            csr <= 0;    
            CSRop <= 0;  
            INT_RST <= 0;
                case(fetched_instr_i[14:12])
                    3'b000:
                        mem_size_o <= 3'd0;
                    3'b001:
                        mem_size_o <= 3'd1;
                    3'b010:
                        mem_size_o <= 3'd2;
                    default:
                    begin
                        wb_src_sel_o <= 0;
                        mem_size_o <= 0;
                        alu_op_o <= 0;
                        ex_op_b_sel_o <= 0;
                        mem_req_o <= 0;
                        mem_we_o <= 0;
                        gpr_we_a_o <= 0;
                        illegal_instr_o <= 1;
                        INT_RST <= 1'b0;
                    end
                endcase    
            end
            
            5'b11000:   // B 
            begin
            illegal_instr_o <= 0;
            ex_op_a_sel_o <= 2'b00;
            ex_op_b_sel_o <= 0;
            wb_src_sel_o <= 0;
            mem_req_o <= 0;
            mem_we_o <= 0;
            mem_size_o <= 0;
            gpr_we_a_o <= 0;
            branch_o <= 1;
            jal_o <= 0;
            jalr_o <= 2'b00;
            csr <= 0;    
            CSRop <= 0;  
            INT_RST <= 0;
                case(fetched_instr_i[14:12])
                    3'b000:
                        alu_op_o <= `ALU_EQ;
                    3'b001:
                        alu_op_o <= `ALU_NE;
                    3'b100:
                        alu_op_o <= `ALU_LTS;
                    3'b101:
                        alu_op_o <= `ALU_GES;
                    3'b110:
                        alu_op_o <= `ALU_LTU;
                    3'b111:
                        alu_op_o <= `ALU_GEU;
                    default:
                    begin
                        alu_op_o <= 0;
                        branch_o <= 0;
                        illegal_instr_o <= 1;
                        INT_RST <= 1'b0;
                    end
                endcase
            end     
            
            5'b11011:   // J    
            begin
                illegal_instr_o <= 0;
                ex_op_a_sel_o <= 2'b01;
                ex_op_b_sel_o <= 3'd4;
                wb_src_sel_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 1;
                branch_o <= 0;
                jal_o <= 1;
                jalr_o <= 2'b00;
                alu_op_o <= `ALU_ADD;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
            end   
            
            5'b11001:   // I
            if (fetched_instr_i[14:12] == 3'b000)  
                begin  
                    illegal_instr_o <= 0;
                    ex_op_a_sel_o <= 2'b01;
                    ex_op_b_sel_o <= 4;
                    wb_src_sel_o <= 0;
                    mem_req_o <= 0;
                    mem_we_o <= 0;
                    mem_size_o <= 0;
                    gpr_we_a_o <= 1;
                    branch_o <= 0;
                    jal_o <= 0;
                    jalr_o <= 2'b01;
                    alu_op_o <= `ALU_ADD;
                    csr <= 0;    
                    CSRop <= 0;  
                    INT_RST <= 0;
                end
            else
                begin
                    illegal_instr_o <= 1;
                    ex_op_a_sel_o <= 2'b00;
                    ex_op_b_sel_o <= 0;
                    wb_src_sel_o <= 0;
                    mem_req_o <= 0;
                    mem_we_o <= 0;
                    mem_size_o <= 0;
                    gpr_we_a_o <= 0;
                    branch_o <= 0;
                    jal_o <= 0;
                    jalr_o <= 2'b00;
                    alu_op_o <= 0;
                    INT_RST <= 1'b0;
                end
            
            5'b01101:   // U    
                begin
                illegal_instr_o <= 0;
                ex_op_a_sel_o <= 2'b10;
                ex_op_b_sel_o <= 2;
                wb_src_sel_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 1;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 2'b00;
                alu_op_o <= `ALU_ADD;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
                end
                
            5'b00101:   // U    
                begin
                illegal_instr_o <= 0;
                ex_op_a_sel_o <= 2'b01;
                ex_op_b_sel_o <= 2;
                wb_src_sel_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 1;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 2'b00;
                alu_op_o <= `ALU_ADD;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
                end    
            5'b11100:   // ECALL   EBREAK
            begin
                wb_src_sel_o <= 0;      
                mem_req_o <= 0;     
                mem_we_o <= 0;      
                mem_size_o <= 0;    
                branch_o <= 0;
                illegal_instr_o <= 0;
                alu_op_o <= 0;
                ex_op_a_sel_o <= 2'b00;
                ex_op_b_sel_o <= 0;
                CSRop <= fetched_instr_i[14:12];
               
                case(fetched_instr_i[14:12])
                    3'b000: //MRET
                        begin
                        gpr_we_a_o <= 0;
                        csr <= 0;
                        jalr_o <= 2'd2;
                        INT_RST <= 1'b1;
                        end
                    3'b001:
                        begin
                        jalr_o <= 2'd0;
                        gpr_we_a_o <= 1;
                        csr <= 1;
                        INT_RST <= 1'b0;
                        end
                    3'b010:
                        begin
                        jalr_o <= 2'd0;
                        gpr_we_a_o <= 1;
                        csr <= 1;
                        INT_RST <= 1'b0;
                        end
                    3'b011:
                        begin
                        jalr_o <= 2'd0;
                        gpr_we_a_o <= 1;
                        csr <= 1;
                        INT_RST <= 1'b0;
                        end
                    default:
                    begin
                        jalr_o <= 0;
                        csr <= 0;
                        illegal_instr_o <= 1;
                        wb_src_sel_o <= 0;
                        ex_op_a_sel_o <= 2'b00;
                        ex_op_b_sel_o <= 0;
                        alu_op_o <= 0;
                        mem_req_o <= 0;
                        mem_we_o <= 0;
                        mem_size_o <= 0;
                        gpr_we_a_o <= 0;
                        branch_o <= 0;
                        jal_o <= 0;
                        csr <= 0;    
                        CSRop <= 0;  
                        INT_RST <= 0;
                    end
                endcase
            end
            5'b00011:   // FENCE    
            begin
                illegal_instr_o <= 0;
                wb_src_sel_o <= 0;
                ex_op_a_sel_o <= 2'b00;
                ex_op_b_sel_o <= 0;
                alu_op_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 0;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 0;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
            end    
            default:
            begin
                illegal_instr_o <= 1;
                wb_src_sel_o <= 0;
                ex_op_a_sel_o <= 2'b00;
                ex_op_b_sel_o <= 0;
                alu_op_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 0;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 0;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
            end
        endcase
        else
            begin
                illegal_instr_o <= 1;
                wb_src_sel_o <= 0;
                ex_op_a_sel_o <= 2'b00;
                ex_op_b_sel_o <= 0;
                alu_op_o <= 0;
                mem_req_o <= 0;
                mem_we_o <= 0;
                mem_size_o <= 0;
                gpr_we_a_o <= 0;
                branch_o <= 0;
                jal_o <= 0;
                jalr_o <= 0;
                csr <= 0;    
                CSRop <= 0;  
                INT_RST <= 0;
            end
    end
end
endmodule
