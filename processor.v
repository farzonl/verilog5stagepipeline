module processor (CLOCK_50);
input CLOCK_50;
//input [0:0] KEY;
wire [15:0] next_instr_addr, fe_instr_addr, id_instr_addr;
wire [15:0] next_pc_in     , fetch_instr  , id_instr;
wire PC_WR_EN, FE_LATCH_WR, instr_mem_en, reset;
wire [1:0] ctr_sig;
//wire reset  =!KEY[0];
FE(CLOCK_50,reset,next_instr_addr,fe_instr_addr,id_instr_addr,next_pc_in,fetch_instr,id_instr,PC_WR_EN,FE_LATCH_WR,instr_mem_en,ctr_sig);
endmodule
