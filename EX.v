module EX(CLK,OPERAND1,OPERAND2,DR,OP_EX_RETURN,DR_EX_RETURN,OP_to_MEM,DR_to_MEM,CC,ALUOP,RESULT,PC,PC_OFFSET,MEM_OFFSET,BRANCH_IN,BRANCH_OUT,MEMDATA,BRANCH_ADDR);
	input[15:0] OPERAND1,OPERAND2,PC,PC_OFFSET,MEM_OFFSET;
	input[2:0] DR;
	input[1:0] ALUOP;
	input CLK,BRANCH_IN;
	
	output[1:0] OP_EX_RETURN;
	output[2:0] DR_EX_RETURN;
	output[15:0] BRANCH_ADDR;
	output reg[1:0] OP_to_MEM;
	output reg[2:0] DR_to_MEM;
	output reg[15:0] RESULT,MEMDATA;
	output BRANCH_OUT;
	output[2:0] CC;
	
	wire[15:0] RESULT_wire,MEMDATA_wire;
	
	wire[15:0] ALU_result;
	
	assign ALU_result = (ALUOP == 2'b01) ? (OPERAND1 + OPERAND2) : //ADD
				(ALUOP == 2'b00) ? (PC + (PC_OFFSET << 1)): //BR
				(OPERAND1 + (MEM_OFFSET << 1)); //STW or LDW
	assign MEMDATA_wire = OPERAND2;
	assign CC = (ALU_result == 16'b0) ? 3'b010 : (ALU_result[15] == 1) ? 3'b100 : (ALU_result[15] == 0) ? 3'b001 : 3'b000;
	assign RESULT_wire = ALU_result;
	assign OP_EX_RETURN = ALUOP;
	assign DR_EX_RETURN = DR;
	assign BRANCH_OUT = BRANCH_IN;
	assign BRANCH_ADDR = ALU_result;
	always @(posedge CLK) begin
		RESULT <= RESULT_wire;
		OP_to_MEM <= ALUOP;
		DR_to_MEM <= DR;
		MEMDATA <= MEMDATA_wire;
	end
endmodule