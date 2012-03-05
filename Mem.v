module MEM(CLOCK_50, RESET, MEMINST, RW,ADDR, DATAIN, MEMDATAOUT, LATCHALUMEMSIG,LATCHDATAOUT, LATCHDATAIN, LATCHALUIN, LATCHALUOUT);
//for r/w = 0 it is read, for r/w = 1 it is write
input CLOCK_50, MEMINST,RW, RESET;
input [15:0] DATAIN ,ADDR;
output reg [15:0] MEMDATAOUT;
output [15:0] NONMEMDATAOUT;
output LATCHALUMEMSIG;
reg [7:0] mem[0:65535];
assign NONMEMDATAOUT = DATAIN;
mem_latch(CLOCK_50,RESET, MEMDATAOUT, DATAIN, LATCHDATAOUT,LATCHALUOUT,MEMINST,LATCHALUMEMSIG);
always @(posedge CLOCK_50) begin
	if(MIOEN)
		if(RW)
			//if it is write
			mem[ADDR] <= DATAIN;
		else
			MEMDATAOUT <= mem[ADDR];
	end
	
endmodule

module mem_latch(CLOCK_50, RESET, DATAIN, ALUIN, DATAOUT, ALUOUT,ALUMEMSIGIN, ALUMEMSIGOUT);//more control signals may have to be forwarded
input ALUMEMSIGIN, CLOCK_50, RESET;
input [15:0] ALUDATAIN, DATAIN;
output [15:0] ALUDATAOUT, DATAOUT;
always @ (CLOCK_50)
	if(reset)
	begin
		DATAOUT = 'd0;
		ALUMEMSIGOUT = 'd0;
		ALUOUT = 'd0;
	end
	else
	begin
		DATAOUT<=DATAIN;
		ALUMEMSIGOUT <= ALUMEMSIGIN;
		ALUOUT <= ALUIN;
	end
endmodule 