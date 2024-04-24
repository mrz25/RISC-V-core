`timescale 1ns / 1ps

module miriscv_core(
    input clk,
    input rst_n_i,

    input [31:0] instr_rdata_i,
    output [31:0] instr_addr_o,
    
    input interr,
    output INTERR_RST,
    input [31:0] mcause,
    output [31:0] mie,
    input [31:0] data_rdata_i,
    output data_req_o,
    output data_we_o,
    output [3:0] data_be_o,
    output [31:0] data_addr_o,
    output [31:0] data_wdata_o
    );
logic [11:0] adress_CSR;
logic [31:0] mcause_;
logic [31:0] mie_;
logic [31:0] RD_csr;
logic [31:0] mepc_;
logic [31:0] mtvec_;

assign mcause_ = mcause;
assign adress_CSR = instr_rdata_i[31:20];
assign mie = mie_;


//output from register file
wire [31:0] RD1;
wire [31:0] RD2;

//output from decoder_RISCV
logic [1:0] ex_op_a_sel_o;
logic [2:0] ex_op_b_sel_o;
wire [4:0] alu_op_o;
wire mem_req_o;
wire mem_we_o;
wire [2:0] mem_size_o;
wire gpr_we_a_o;
wire wb_src_sel_o;
wire illegal_instr_o;
wire branch_o;
wire jal_o;
wire [1:0] jalr_o;
wire en_pc;
wire en_pc_;
assign en_pc_ = en_pc;
logic csr_;
logic [2:0] CSRop_decoder;
logic [2:0] CSRop_csr;
assign CSRop_csr = CSRop_decoder;
wire INT_RST_;

wire interrupt_;
assign interrupt_ = interr;

//output from ALU
wire [31:0] Result_;
wire Comp_;

//output from LSU
wire data_req_o_;
wire data_we_o_;
reg stall_o;
wire [3:0] data_be_o_;
wire [31:0] data_addr_o_;
wire [31:0] data_wdata_o_;
wire [31:0] RD;

//start connection

assign INTERR_RST = INT_RST_;

wire [31:0] in_command;
assign in_command = instr_rdata_i ;

assign data_be_o = data_be_o_;
assign data_addr_o = data_addr_o_;
assign data_wdata_o = data_wdata_o_;
assign data_we_o = data_we_o_;
assign data_req_o = data_req_o_;

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
wire [31:0] imm_I;
wire [31:0] imm_S;
wire [31:0] imm_J;
wire [31:0] imm_B;
assign imm_I = {{21 {in_command[31]}}, {in_command[31:20]}};
assign imm_S = {{21 {in_command[31]}}, {in_command[31:25]}, {in_command[11:7]}};
assign imm_J = {{12 {in_command[31]}}, {in_command[19:12]}, {in_command[20]}, {in_command[30:21]}, 1'b0};
assign imm_B = {{20 {in_command[31]}}, {in_command[7]}, {in_command[30:25]}, {in_command[11:8]}, 1'b0};

//MUX for WD on Register file
wire [31:0] WD3_;    
assign WD3_ = csr_ ? RD_csr : (wb_src_sel_o ? RD : Result_);

//initialization Programm Counter
reg signed [31:0] prog_sum;
reg [31:0] PC = 0;
assign prog_sum = (jal_o | (branch_o & Comp_)) ? (branch_o ? imm_B : imm_J) : 4;

always @(posedge clk)
    if(!rst_n_i)
        PC <= 0;
    else
        if(en_pc_ == 1'b0)
            case(jalr_o)
                2'b00:
                    PC <= PC + prog_sum;
                2'b01:
                    PC <= RD1 + imm_I;
                2'b10:
                    PC <= mepc_;
                2'b11:
                    PC <= mtvec_;
            
            endcase
        else
            begin
                PC = PC + 0;
            end
            
assign instr_addr_o = PC;

//input on ALU
logic [31:0] A_;
logic [31:0] B_;

always_comb
    begin
    case(ex_op_a_sel_o[1:0])
        2'b00:
            A_ <= RD1;
        2'b01:
            A_ <= PC;
        /*2'b10:
            A_ <= 32'b0;*/
        default:
            A_ <= 32'b0;
    endcase
    case(ex_op_b_sel_o[2:0])
        3'b000:
            B_ <= RD2;
        3'b001:
            B_ <= imm_I;
        3'b010:
            B_ <= {in_command[31:12], {12 {1'b0}}};
        3'b011:
            B_ <= imm_S;
        //3'b100:
        //    B_ <= 4;
        default:
            B_ <= 4;
    endcase
    
    end
    
        
//add modules
decoder_riscv DECODER_RISCV_ADD(
        .fetched_instr_i    (in_command),
        .ex_op_a_sel_o      (ex_op_a_sel_o), 
        .ex_op_b_sel_o      (ex_op_b_sel_o),
        .alu_op_o           (alu_op_o),
        .mem_req_o          (mem_req_o),
        .mem_we_o           (mem_we_o),
        .mem_size_o         (mem_size_o),
        .gpr_we_a_o         (gpr_we_a_o),
        .wb_src_sel_o       (wb_src_sel_o),
        .illegal_instr_o    (illegal_instr_o),
        .branch_o           (branch_o),
        .jal_o              (jal_o), 
        .jalr_o             (jalr_o),
        .interrupt          (interrupt_),
        .INT_RST            (INT_RST_),
        .CSRop              (CSRop_decoder),
        .csr                (csr_),
        .stall              (stall_o),
        .en_pc               (en_pc));   

Register_file REGISTER_ADD(
        .clk            (clk), 
        .WE3            (WE3_), 
        .A1             (A1_), 
        .A2             (A2_),
        .A3             (A3_), 
        .WD3            (WD3_), 
        .RD1            (RD1), 
        .RD2            (RD2));
 
lab1_ALU ALU_ADD(
        .ALU0p          (ALU0p_), 
        .A              (A_), 
        .B              (B_), 
        .Result         (Result_), 
        .Flag           (Comp_));

miriscv_lsu LSU_ADD(
        .clk          (clk), // синхронизация
        .rst_n_i        (rst_n_i), // сброс внутренних регистров
    
        // core protocol
        .lsu_addr_i     (Result_), // адрес, по которому хотим обратиться
        .lsu_we_i       (mem_we_o), // 1 - если нужно записать в память
        .lsu_size_i     (mem_size_o), // размер обрабатываемых данных                memi
        .lsu_data_i     (RD2), // данные для записи в память
        .lsu_req_i      (mem_req_o), // 1 - обратиться к памяти                     
        .lsu_stall_req_o(stall_o), // используется как !enable pc
        .lsu_data_o     (RD), // данные считанные из памяти
        
         // memory protocol
        .data_rdata_i   (data_rdata_i), // запрошенные данные
        .data_req_o     (data_req_o_), // 1 - обратиться к памяти
        .data_we_o      (data_we_o_), // 1 - это запрос на запись
        .data_be_o      (data_be_o_), // к каким байтам слова идет обращение
        .data_addr_o    (data_addr_o_), // адрес, по которому идет обращение
        .data_wdata_o   (data_wdata_o_));

Control_Status_Reg CSR_ADD(
        .clk            (clk),
        .OP             (CSRop_csr),
        .mcause         (mcause_),
        .PC             (PC),
        .A              (adress_CSR),
        .WD             (RD1),
        .RD             (RD_csr),
        .mepc           (mepc_),
        .mtvec          (mtvec_),
        .mie            (mie_)
);

endmodule