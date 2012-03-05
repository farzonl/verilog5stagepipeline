module processor (CLOCK_50, KEY);
input CLOCK_50;
input [0:0] KEY;
wire [15:0] next_instr_addr, fe_instr_addr, id_instr_addr;
wire [15:0] next_pc_in     , fetch_instr  , id_instr;
wire PC_WR_EN, FE_LATCH_WR, instr_mem_en;
wire [1:0] ctr_sig; 
wire [0:0] wb_ctr_sig;
wire reset  =!KEY[0];
/*reg [15:0] PC;
initial PC <= 16;*/

//WB wires
wire [15:0] WB_val, wb_alu_src, wb_mem_src;


//
set(16,next_pc_in);
//FETCH
FE(CLOCK_50,reset,next_instr_addr,fe_instr_addr,id_instr_addr,next_pc_in,fetch_instr,id_instr,PC_WR_EN,FE_LATCH_WR,instr_mem_en,ctr_sig);
//Decode
//ID(CLK,IR,OP_EX,OP_MEM,DR_EX,DR_MEM,STALL,DR,OPERAND1,OPERAND2,SR1,SR2,ALUOP,AGEX_RESULT,MEM_RESULT,DR_WB,WB_RESULT,WB_ENABLE,PC_Offset,Mem_Offset,CC);
//EXE stage

//MEM stage
//MEM(CLOCK_50,reset, MEMINST, RW,ADDR, DATAIN, MEMDATAOUT, LATCHALUMEMSIG,LATCHDATAOUT, LATCHDATAIN, LATCHALUIN, LATCHALUOUT);
//WB  stage
WB(CLOCK_50, wb_ctr_sig, wb_mem_src, wb_alu_src, WB_val); 

endmodule

module set(IN,OUT);
input [15:0] IN;
output reg [15:0] OUT;
always@(*) begin
OUT <= IN;
end
endmodule
