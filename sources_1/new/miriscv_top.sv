module miriscv_top
#(
  parameter RAM_SIZE      = 4096, // bytes
  parameter RAM_INIT_FILE = "SeedData1.mem"
)
(
  // clock, reset
  input clk_i,
  input rst_n_i,
  input [15:0] sw_i,
  output logic [15:0] led_o
);
logic clk = 0;
always_ff @(posedge clk_i)
    clk <= ~clk;
///////////////////////////////////////////////////////////////////////   
    /*MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(5.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(0.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT1_DIVIDE(1),
      .CLKOUT2_DIVIDE(1),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT6_DIVIDE(1),
      .CLKOUT0_DIVIDE_F(1.0),    // Divide amount for CLKOUT0 (1.000-128.000).
      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),
      .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .DIVCLK_DIVIDE(1),         // Master division value (1-106)
      .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   MMCME2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0(CLKOUT0),     // 1-bit output: CLKOUT0
      .CLKOUT0B(CLKOUT0B),   // 1-bit output: Inverted CLKOUT0
      .CLKOUT1(CLKOUT1),     // 1-bit output: CLKOUT1
      .CLKOUT1B(CLKOUT1B),   // 1-bit output: Inverted CLKOUT1
      .CLKOUT2(CLKOUT2),     // 1-bit output: CLKOUT2
      .CLKOUT2B(CLKOUT2B),   // 1-bit output: Inverted CLKOUT2
      .CLKOUT3(CLKOUT3),     // 1-bit output: CLKOUT3
      .CLKOUT3B(CLKOUT3B),   // 1-bit output: Inverted CLKOUT3
      .CLKOUT4(CLKOUT4),     // 1-bit output: CLKOUT4
      .CLKOUT5(CLKOUT5),     // 1-bit output: CLKOUT5
      .CLKOUT6(CLKOUT6),     // 1-bit output: CLKOUT6
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(CLKFBOUT),   // 1-bit output: Feedback clock
      .CLKFBOUTB(CLKFBOUTB), // 1-bit output: Inverted CLKFBOUT
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED(LOCKED),       // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1(CLKIN1),       // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN(PWRDWN),       // 1-bit input: Power-down
      .RST(RST),             // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(CLKFBIN)      // 1-bit input: Feedback clock
   );*/
//////////////////////////////////////////////////////////////////////    
    
    
    
  logic  [31:0]  instr_rdata_core;
  logic  [31:0]  instr_addr_core;

  logic  [31:0]  data_rdata_core;
  logic          data_req_core;
  logic          data_we_core;
  logic  [3:0]   data_be_core;
  logic  [31:0]  data_addr_core;
  logic  [31:0]  data_wdata_core;

  logic  [31:0]  data_rdata_ram;
  logic          data_req_ram;
  logic          data_we_ram;
  logic  [3:0]   data_be_ram;
  logic  [31:0]  data_addr_ram;
  logic  [31:0]  data_wdata_ram;

  //
  logic INT_RST_ic;
  logic INT_RST_core;
  assign INT_RST_ic = INT_RST_core;
  
  logic INT_core;
  logic INT_ic;
  assign INT_core = INT_ic;
  
  logic [31:0] mie_core;
  logic [31:0] mie_ic;
  assign mie_ic = mie_core;
  
  logic [31:0] mcause_core;
  logic [31:0] mcause_ic;
  assign mcause_core = mcause_ic;
  //
  logic  data_mem_valid;
  assign data_mem_valid = (data_addr_core >= RAM_SIZE) ?  1'b0 : 1'b1;

  //assign data_rdata_core  = (data_mem_valid) ? data_rdata_ram : 1'b0;
  assign data_req_ram     = (data_mem_valid) ? data_req_core : 1'b0;
  assign data_we_ram      =  data_we_core;
  assign data_be_ram      =  data_be_core;
  assign data_addr_ram    =  data_addr_core;
  assign data_wdata_ram   =  data_wdata_core;
    
  
  logic [31:0] int_req_ic;
  logic [31:0] int_req_swc_o;

  assign int_req_ic = int_req_swc_o;
  
  logic [31:0] int_fin_ic;
  logic [31:0] int_fin_o;
  assign int_fin_o = int_fin_ic;

  logic d0_i;
  logic d1_i;
  logic d0_o;
  logic d1_o;
  assign d0_i = d0_o;
  assign d1_i = d1_o;

  logic we_m_i;
  logic req_m_i;
  logic we_m_o;
  logic req_m_o;
  assign we_m_i = we_m_o;
  assign req_m_i = req_m_o;
  
  logic [1:0] RDsel_;
  logic [31:0] data_swc_o;
  logic [31:0] data_lc_o;
  always_comb
     case(RDsel_)
        2'b00:
            data_rdata_core  = (data_mem_valid) ? data_rdata_ram : 1'b0;
        2'b01:
            data_rdata_core = data_lc_o;
        2'b10:
            data_rdata_core = data_swc_o;
        default:
            data_rdata_core = 0;
     endcase
  
  logic [15:0] sw_controller_i;
  assign sw_controller_i = sw_i;
  
  assign led_o = data_lc_o[15:0];
  
  miriscv_core core (
    .clk   ( clk   ),
    .rst_n_i ( rst_n_i ),
    
    .INTERR_RST (INT_RST_core),
    .interr     (INT_core),
    .mie        (mie_core),
    .mcause     (mcause_core),
    
    .instr_rdata_i ( instr_rdata_core ),
    .instr_addr_o  ( instr_addr_core  ),

    .data_rdata_i  ( data_rdata_core  ),
    .data_req_o    ( data_req_core    ),
    .data_we_o     ( data_we_core     ),
    .data_be_o     ( data_be_core     ),
    .data_addr_o   ( data_addr_core   ),
    .data_wdata_o  ( data_wdata_core  )
  );

  miriscv_ram
  #(
    .RAM_SIZE      (RAM_SIZE),
    .RAM_INIT_FILE (RAM_INIT_FILE)
  ) ram (
    .clk   ( clk   ),
    .rst_n_i ( rst_n_i ),

    .instr_rdata_o ( instr_rdata_core ),
    .instr_addr_i  ( instr_addr_core  ),

    .data_rdata_o  ( data_rdata_ram  ),
    .data_req_i    ( req_m_i    ),
    .data_we_i     ( we_m_i     ),
    .data_be_i     ( data_be_ram     ),
    .data_addr_i   ( data_addr_ram   ),
    .data_wdata_i  ( data_wdata_ram  )
  );

Interrupt_Controller IC_ADD (
    .clk           (clk),
    .INT_RST       (INT_RST_ic),
    .mie           (mie_ic),
    .int_req       (int_req_ic),
    .mcause        (mcause_ic),
    .int_fin       (int_fin_ic),
    .INT_          (INT_ic)
);

Adress_Decoder AD_ADD(
    .addr   (data_addr_ram),
    .we     (data_we_core),
    .req    (data_req_core),
    .we_m   (we_m_o),
    .req_m  (req_m_o),
    .we_d0  (d0_o),
    .we_d1  (d1_o),
    .RDsel  (RDsel_)
);

Led_Controller LC_ADD(
    .clk            (clk),     
    .led_addres     (data_addr_ram),
    .led_wdata      (data_wdata_ram),
    //.int_req_led_i  (int_req_lc_i),
    //.int_fin_led_i  (int_fin_o),
    //.int_req_led_o  (int_req_lc_o),
    .we_d0          (d0_i),
    .be_d0          (data_be_ram),
    .out_reg_led    (data_lc_o)
);

Switch_Controller SWC_ADD(
    .clk           (clk),
    .sw_addres     (data_addr_ram),
    .sw_wdata      (data_wdata_ram),
    //.int_req_sw_i  (int_req_swc_i),
    .sw_16         (sw_controller_i),
    .int_fin_sw_i  (int_fin_o),
    .int_req_sw_o  (int_req_swc_o),
    .we_d1         (d1_i),
    .out_reg_sw    (data_swc_o)
);

initial
begin
    led_o = 0;
end

endmodule