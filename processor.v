module processor (CLOCK_50, KEY, HEX0,HEX1,HEX2,HEX3,DR_out,WB_val_out,BRANCH_out,STALL_out,OP_out,IR_out);
input CLOCK_50;
input [0:0] KEY;
output [6:0] HEX0,HEX1,HEX2,HEX3;
output [2:0] DR_out;
output [15:0] WB_val_out;
output BRANCH_out,STALL_out;
output [1:0] OP_out;
output [15:0] IR_out;

wire [15:0] next_instr_addr, fe_instr_addr, id_instr_addr,branch_addr;
wire [15:0] fetch_instr  , id_instr;
wire PC_WR_EN, FE_LATCH_WR, instr_mem_en;
wire [0:0] wb_ctr_sig;
wire reset  =!KEY[0];
wire BRANCH_to_EX,BRANCH_from_EX,STALL;
/*reg [15:0] PC;
initial PC <= 16;*/

wire [15:0] OPERAND1, OPERAND2,EX_RESULT,MEM_RESULT,PC_to_EX,PC_Offset,MEM_Offset,DATA_to_MEM,MEM_to_WB;
wire [2:0] DR_to_EX,DR_from_EX,DR_to_MEM,DR_to_WB;
wire [1:0] ALUOP,OP_from_MEM,OP_from_EX,OP_to_MEM,WB_OP_in;
wire[2:0] CC;
wire WB_ENABLE;
//WB wires
wire [15:0] WB_val, wb_alu_src, wb_mem_src;

assign WB_val_out = WB_val;
assign DR_out = DR_to_WB;
assign BRANCH_out = BRANCH_from_EX;
assign STALL_out = STALL;
assign OP_out = ALUOP;
assign IR_out = id_instr;
//

//FETCH
FE fetch(CLOCK_50,reset,id_instr,id_instr_addr,BRANCH_from_EX,STALL,branch_addr);
//Decode
ID decode(CLOCK_50,id_instr,OP_from_EX,OP_to_MEM,DR_from_EX,DR_to_MEM,STALL,DR_to_EX,OPERAND1,OPERAND2,ALUOP,EX_RESULT,MEM_RESULT,DR_to_WB,WB_val,WB_ENABLE,PC_Offset,MEM_Offset,CC,BRANCH_to_EX,id_instr_addr,PC_to_EX,BRANCH_from_EX);
//EXE stage
EX execute(CLOCK_50,OPERAND1,OPERAND2,DR_to_EX,OP_from_EX,DR_from_EX,OP_to_MEM,DR_to_MEM,CC,ALUOP,EX_RESULT,PC_to_EX,PC_Offset,MEM_Offset,BRANCH_to_EX,BRANCH_from_EX,DATA_to_MEM,branch_addr);
//MEM stage
MEM memory(CLOCK_50,reset, OP_to_MEM, EX_RESULT, DATA_to_MEM, MEM_RESULT, MEM_to_WB, OP_from_MEM,WB_OP_in,DR_to_MEM,DR_to_WB);
//WB  stage
WB writeback(WB_OP_in, DR_to_WB, MEM_RESULT, WB_val, WB_ENABLE, HEX0,HEX1,HEX2,HEX3); 


endmodule