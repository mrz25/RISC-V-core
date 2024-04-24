`timescale 1ns / 1ps

module miriscv_lsu(
    input clk, // синхронизация
     input rst_n_i, // сброс внутренних регистров
    
     // core protocol
     input [31:0] lsu_addr_i, // адрес, по которому хотим обратиться
     input lsu_we_i, // 1 - если нужно записать в память
     input [2:0] lsu_size_i, // размер обрабатываемых данных                memi
     input [31:0] lsu_data_i, // данные для записи в память
     input lsu_req_i, // 1 - обратиться к памяти                     
     output reg lsu_stall_req_o, // используется как !enable pc
     output reg [31:0] lsu_data_o, // данные считанные из памяти
    
     // memory protocol
     input [31:0] data_rdata_i, // запрошенные данные
     output reg data_req_o, // 1 - обратиться к памяти
     output reg data_we_o, // 1 - это запрос на запись
     output reg [3:0] data_be_o, // к каким байтам слова идет обращение
     output reg [31:0] data_addr_o, // адрес, по которому идет обращение
     output reg [31:0] data_wdata_o // данные, которые требуется записать
    );
    reg stall_buff = 1;
    always @(posedge clk or posedge rst_n_i)
        begin
        if (!rst_n_i || !stall_buff)
            stall_buff <= 1;
        else
            stall_buff <= !lsu_req_i;
        end 
        
    always @(*)
            lsu_stall_req_o <= stall_buff & lsu_req_i;     

    always @(*)
    begin
        if (lsu_we_i == 1'b0 && lsu_req_i == 1'b1)
            begin
                data_we_o <= lsu_we_i;    
                data_req_o <= lsu_req_i;  
                data_addr_o <= lsu_addr_i;
                data_wdata_o <= 0;
                data_be_o <= 0;
                case(lsu_size_i)
                    3'd0:
                        lsu_data_o <= {{24{data_rdata_i[7]}} ,data_rdata_i[7:0]};
                    3'd1:
                        lsu_data_o <= {{16{data_rdata_i[15]}} ,data_rdata_i[15:0]};
                    3'd2:
                        lsu_data_o <= data_rdata_i;
                    3'd4:
                        lsu_data_o <= {24'b0 ,data_rdata_i[7:0]};
                    3'd5:
                        lsu_data_o <= {16'b0 ,data_rdata_i[15:0]};
                    default:
                        lsu_data_o <= 32'b0;
                endcase
            end
        else
            if (lsu_we_i == 1'b1 && lsu_req_i == 1'b1)
                begin    
                    lsu_data_o <= 0;
                    data_we_o <= lsu_we_i;    
                    data_req_o <= lsu_req_i;  
                    data_addr_o <= lsu_addr_i;
                    case(lsu_size_i)
                        3'd0:
                            begin
                                data_wdata_o <= {4 {lsu_data_i[7:0]}};
                                case(lsu_addr_i[1:0])
                                    2'b11:
                                            data_be_o <= 4'b1000;                        
                                    2'b10:
                                            data_be_o <= 4'b0100;                        
                                    2'b01:
                                            data_be_o <= 4'b0010;                        
                                    2'b00:
                                            data_be_o <= 4'b0001;                        
                                    /*default:
                                            data_be_o <= 4'b0000;*/                       
                                endcase
                            end
                        3'd1:
                            begin
                                data_wdata_o <= {2 {lsu_data_i[15:0]}};
                                case(lsu_addr_i[1:0])
                                    2'b00:
                                        data_be_o <= 4'b0011;
                                    2'b10:
                                        data_be_o <= 4'b1100;
                                    default:
                                        data_be_o <= 4'b0000;
                                endcase
                            end
                        3'd2:         
                            begin                           
                                data_wdata_o <= lsu_data_i;
                                if(lsu_addr_i[1:0] == 2'b00)
                                    data_be_o <= 4'b1111;
                                else    
                                    data_be_o <= 4'b0000;
                            end
                        default:
                            begin
                            data_wdata_o <= 0;
                            data_be_o <= 4'b0000;    
                            end
                    endcase
                end
            else
                begin 
                    data_addr_o <= 0;
                    data_wdata_o <= 0;
                    data_we_o <= 0;    
                    data_req_o <= 0;  
                    data_be_o <= 0;
                    lsu_data_o <= 0;
                end
    end

    
endmodule
