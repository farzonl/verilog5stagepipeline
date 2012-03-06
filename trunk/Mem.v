module MEM(CLOCK_50, RESET, OP_IN, ADDR, DATAIN, MEM_RESULT, LATCHDATAOUT, OP_OUT,LATCHOPOUT,DESTREG_IN,DESTREG_OUT);
//for r/w = 0 it is read, for r/w = 1 it is write
input CLOCK_50, RESET;
input[1:0] OP_IN;
input[2:0] DESTREG_IN;
output[2:0] DESTREG_OUT;
output[1:0] OP_OUT,LATCHOPOUT;
input [15:0] DATAIN ,ADDR;
wire [15:0] LATCHDATAIN;

output [15:0] LATCHDATAOUT,MEM_RESULT;

reg [15:0] mem[0:65535];

mem_latch memlatch(CLOCK_50,RESET, LATCHDATAIN, LATCHDATAOUT,OP_IN,LATCHOPOUT,DESTREG_IN,DESTREG_OUT);
always @(posedge CLOCK_50) begin
	if(OP_IN[1] && OP_IN[0]) begin
			//if it is write
			mem[ADDR] <= DATAIN;
	end
end

assign LATCHDATAIN = (OP_IN[1] && !OP_IN[0]) ? mem[ADDR] : ADDR;
assign OP_OUT = OP_IN;
assign MEM_RESULT = DATAIN;
endmodule

module mem_latch(CLOCK_50, RESET, DATAIN, DATAOUT,OP,LATCHOPOUT,DESTREG_IN,DESTREG_OUT);//more control signals may have to be forwarded
input CLOCK_50, RESET;
input [15:0] DATAIN;
input [2:0] DESTREG_IN;
input [1:0] OP;
output reg [15:0] DATAOUT;
output reg[2:0] DESTREG_OUT;
output reg[1:0] LATCHOPOUT;
always @ (posedge CLOCK_50 or posedge RESET)
	if(RESET)
	begin
		DATAOUT <= 'd0;
	end
	else
	begin
		DATAOUT<=DATAIN;
		LATCHOPOUT <= OP;
		DESTREG_OUT<=DESTREG_IN;
	end
endmodule 