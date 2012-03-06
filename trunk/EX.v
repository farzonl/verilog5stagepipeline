module EX(OPERAND1,OPERAND2,DR,OP_EX_RETURN,DR_EX_RETURN,CC,ALUOP,RESULT,PC,PC_OFFSET,MEM_OFFSET);
	input[15:0] OPERAND1,OPERAND2,PC,PC_OFFSET,MEM_OFFSET;
	input[2:0] DR;
	input[1:0] ALUOP;
	
	output[1:0] OP_EX_RETURN;
	output[2:0] DR_EX_RETURN,CC;
	output[15:0] RESULT;
	
	wire[15:0] ALU_result;
	
	assign ALU_result = (ALUOP == 2'b01) ? (OPERAND1 + OPERAND2) : //ADD
				(ALUOP == 2'b00) ? (PC + (PC_OFFSET << 1) + 2): //BR
				(OPERAND1 + (MEM_OFFSET << 1)); //STW or LDW
				
	assign CC = (ALU_result == 16'b0) ? 3'b010 : (ALU_result[15] == 1) ? 3'b100 : (ALU_result[15] == 0) ? 3'b001 : 3'b000;
	assign RESULT = ALU_result;
	assign OP_EX_RETURN = ALUOP;
	assign DR_EX_RETURN = DR;
endmodule