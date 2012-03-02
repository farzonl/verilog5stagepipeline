module ID(CLK,IR,OP_EX,OP_MEM,DR_EX,DR_MEM,STALL,DR,OPERAND1,OPERAND2,SR1,SR2,ALUOP,AGEX_RESULT,MEM_RESULT,DR_WB,WB_RESULT,WB_ENABLE,PC_Offset,Mem_Offset,CC);

input CLK,WB_ENABLE;
input[15:0] IR,AGEX_RESULT,MEM_RESULT,WB_RESULT;
input[1:0] OP_EX,OP_MEM;
input[2:0] DR_EX,DR_MEM,DR_WB,CC;

output STALL;
output[15:0] OPERAND1,OPERAND2;
output[2:0] DR,SR1,SR2;
output[1:0] ALUOP;
output[15:0] PC_Offset;
output[15:0] Mem_Offset;

wire[3:0] IR_operation = IR[15:12];
wire[1:0] ALU_operation;
wire[2:0] SR1_decoded = IR[8:6];
wire[15:0] SR1_val;
wire[15:0] SR2_val_from_regfile;
wire[15:0] SR2_imm;
wire[15:0] SR2_val;
wire[2:0] SR2_decoded = IR[2:0];

regfile registerfile(.CLK(CLK),.DR_NUM(DR_WB),.DR_VAL(WB_RESULT),.SRC1_NUM(SR1_decoded),.SRC1_VAL(SR1_val),.SRC2_NUM(SR2_decoded),.SRC2_VAL(SR2_val_from_regfile),.WENABLE(WB_ENABLE));

sign_extend #(.INBITS(5),.OUTBITS(16)) Imm_sext(.IN(IR[4:0]),.OUT(SR2_imm));
sign_extend #(.INBITS(9),.OUTBITS(16)) PC_sext(.IN(IR[8:0]),.OUT(PC_Offset));
sign_extend #(.INBITS(6),.OUTBITS(16)) Mem_sext(.IN(IR[5:0]),.OUT(Mem_Offset));

assign SR2_val = (IR[5] == 0) ? SR2_val_from_regfile : SR2_imm;

assign OPERAND1 = 
	//If we have an add operation
	(OP_EX==2'b01 && DR_EX==SR1_decoded) ? AGEX_RESULT:
	//Only check MEM if EX doesn't have one of our source registers
	(OP_MEM==2'b10 && DR_MEM==SR1_decoded) ? MEM_RESULT:
	SR1_val;

assign OPERAND2 = 
	(OP_EX==2'b01 && DR_EX==SR2_decoded) ? AGEX_RESULT:
	(OP_MEM==2'b10 && DR_MEM==SR2_decoded)? MEM_RESULT:
	SR2_val;

assign ALU_operation =
	(IR_operation == 4'b0000) ? 2'b00: //BR
	(IR_operation == 4'b0001) ? 2'b01: //ADD
	(IR_operation == 4'b0110) ? 2'b10: //LDW
	(IR_operation == 4'b0111) ? 2'b11: //STW
	2'bxx;

//CC[2] = N, CC[1] == Z, CC[0] == P
assign STALL = (ALU_operation == 2'b00 && ((IR[11] && CC[2]) || (IR[10] && CC[1]) || (IR[9] && CC[0]))) ? 1'b1 : 1'b0;
assign DR = IR[11:9];
assign SR1 = SR1_decoded;
assign SR2 = SR2_decoded;
assign ALUOP = ALU_operation;
	
endmodule

module sign_extend(IN,OUT);
	parameter INBITS;
	parameter OUTBITS;
	input[(INBITS-1):0] IN;
	output[(OUTBITS-1):0] OUT;
	assign OUT = { {(OUTBITS-INBITS){IN[INBITS-1]}},IN};
endmodule

module regfile(DR_NUM,DR_VAL,SRC1_NUM,SRC1_VAL,SRC2_NUM,SRC2_VAL,CLK,WENABLE);
	input[2:0] DR_NUM,SRC1_NUM,SRC2_NUM;
	input[15:0] DR_VAL;
	input CLK,WENABLE;
	output[15:0] SRC1_VAL,SRC2_VAL;
	reg[15:0] register_file[7:0];
	
	assign SRC1_VAL = register_file[SRC1_NUM];
	assign SRC2_VAL = register_file[SRC2_NUM];
	
	always @(posedge CLK) begin
		if(WENABLE) register_file[DR_NUM] <= DR_VAL;
	end
endmodule