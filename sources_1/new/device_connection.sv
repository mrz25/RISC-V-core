`timescale 1ns / 1ps

module device_connection(
    input [31:0] SW_in,
    input clk,
    input reset,
    output reg [31:0] out_command
    );
    
//output from register file
wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] RD;
// output from instruction memory
wire [31:0] rd;

//output from decoder_RISCV
wire [1:0] ex_op_a_sel_o;
wire [2:0] ex_op_b_sel_o;
wire [4:0] alu_op_o;
wire mem_req_o;
wire mem_we_o;
wire [2:0] mem_size_o;
wire gpr_we_a_o;
wire wb_src_sel_o;
wire illegal_instr_o;
wire branch_o;
wire jal_o;
wire jalr_o;

//output from ALU
wire [31:0] Result_;
wire Comp_;

//start connection
wire [31:0] in_command;
assign in_command = rd ;

wire [4:0] ALU0p_;
assign ALU0p_ = alu_op_o;

//addresses for register file
wire [4:0] A1_;
wire [4:0] A2_;
wire [4:0] A3_;
assign A1_ = in_command[19:15];
assign A2_ = in_command[24:20];
assign A3_ = in_command[11:7];

wire WE3_;
assign WE3_ = gpr_we_a_o;


//constants
wire signed [31:0] imm_I;
wire signed [31:0] imm_S;
wire signed [31:0] imm_J;
wire signed [31:0] imm_B;
assign imm_I = {{21 {in_command[31]}}, {in_command[31:20]}};
assign imm_S = {{21 {in_command[31]}}, {in_command[31:25]}, {in_command[11:7]}};
assign imm_J = {{12 {in_command[31]}}, {in_command[19:12]}, {in_command[20]}, {in_command[30:21]}, 1'b0};
assign imm_B = {{12 {in_command[31]}}, {in_command[7]}, {in_command[30:25]}, {in_command[11:8]}, 1'b0};
    
//MUX for WD on Register file
wire [31:0] WD3_;    
assign WD3_ = wb_src_sel_o ? RD : Result_;

//initialization Programm Counter
reg signed [31:0] prog_sum;
reg [31:0] PC;
assign prog_sum = (jal_o | (branch_o & Comp_)) ? (branch_o ? imm_B : imm_J) : 4;
always @(posedge clk or posedge reset)
    if(reset)
        PC <= 1'b0;
    else
        case(jalr_o)
            1'b0:
                PC <= PC + prog_sum;
            1'b1:
                PC <= RD1 + imm_I;
        endcase

wire [31:0] adr_;
assign adr_ = PC;

//input on ALU
reg [31:0] A_;
reg [31:0] B_;

always @*
    case(ex_op_a_sel_o)
        2'b00:
            A_ <= RD1;
        2'b01:
            A_ <= PC;
        2'b10:
            A_ <= 0;    
    endcase
    
always @*
    case(ex_op_b_sel_o)
        3'b000:
            B_ <= RD2;
        3'b001:
            B_ <= imm_I;
        3'b010:
            B_ <= {in_command[31:12], {12 {1'b0}}};
        3'b011:
            B_ <= imm_S;
        3'b100:
            B_ <= 4;
    endcase
        
//add modules
decoder_riscv DECODER_RISCV_ADD(
        .fetched_instr_i(in_command),
        .ex_op_a_sel_o(ex_op_a_sel_o), 
        .ex_op_b_sel_o(ex_op_b_sel_o),
        .alu_op_o(alu_op_o),
        .mem_req_o(mem_req_o),
        .mem_we_o(mem_we_o),
        .mem_size_o(mem_size_o),
        .gpr_we_a_o(gpr_we_a_o),
        .wb_src_sel_o(wb_src_sel_o),
        .illegal_instr_o(illegal_instr_o),
        .branch_o(branch_o),
        .jal_o(jal_o), 
        .jalr_o(jalr_o));   

DataMemory DATAMEMORY_ADD(
        .reset(reset),
        .clk(clk),
        .WD(RD2),
        .A(Result_),
        .WE(mem_we_o),
        .RD(RD));

mem64_32 MEMORY_ADD(
        .adr(adr_),
        .rd(rd));

Register_file REGISTER_ADD(
        .clk(clk), 
        .reset(reset), 
        .WE3(WE3_), 
        .A1(A1_), 
        .A2(A2_),
        .A3(A3_), 
        .WD3(WD3_), 
        .RD1(RD1), 
        .RD2(RD2));
 
lab1_ALU ALU_ADD(
        .ALU0p(ALU0p_), 
        .A(A_), 
        .B(B_), 
        .Result(Result_), 
        .Flag(Comp_));
endmodule
