module FE(CLOCK_50,reset,id_instr,id_instr_addr,BRANCH,STALL,branch_instr_addr);
input CLOCK_50,reset, BRANCH,STALL;
input [15:0] branch_instr_addr;
//wire [15:0] next_instr_addr, fe_instr_addr, id_instr_addr,fetch_instr;
output reg [15:0] id_instr_addr,id_instr;
//wire [15:0] next_pc_in;

wire WR_EN = !BRANCH && !STALL;

//currently  everything is the same 
/*pc_mux pcmux(BRANCH,next_pc_in,branch_instr_addr,next_instr_addr);
pc programcounter(CLOCK_50,reset,next_instr_addr,fe_instr_addr,WR_EN);
pc_adder_2 adder2(fe_instr_addr,next_pc_in);
Instr_Mem instrmem(CLOCK_50,reset,fe_instr_addr,fetch_instr);

Instr_FE_Latch pipelineregs(CLOCK_50,reset,WR_EN,fetch_instr,next_pc_in, id_instr, id_instr_addr);*/
(* ram_init_file = "test1.mif" *)
reg[15:0] mem[0:127];
reg[15:0] mdr;
reg[15:0] pc;
initial begin
	pc <= 8;
end

always @(posedge CLOCK_50 or posedge reset) begin
	if(reset) pc <= 8;
	else if(WR_EN) begin
		if(BRANCH) pc <= branch_instr_addr;
		else pc <= pc + 1;
		mdr <= mem[pc];
		id_instr <= mdr;
		id_instr_addr <= pc;
	end
end


endmodule

/*module pc_mux(ctr_sig,in_1,in_2,out);
	
	input [0:0] ctr_sig;
	input [15:0] in_1,in_2;
	
	output [15:0] out;
	assign out = (ctr_sig == 'd1) ? in_2 : in_1;

endmodule

module pc(clock,reset,in,out,write_en);
	input clock,reset,write_en;
	input [15:0] in;	
	output reg [15:0] out;
	initial begin
		out <= 8;
	end
	always@(posedge clock) begin
		if(reset)
			out <= 8;
		else if(write_en)
			out <= in;
	end
endmodule

module pc_adder_2(in,out);
	input [15:0] in;
	output [15:0] out;
	assign out = in + 16'd2;
endmodule

module Instr_Mem(CLOCK_50,reset,addr,mdr);
	input CLOCK_50,reset;
	input  [15:0] addr;
	//output reg[15:0] out;  //mdr will be the output register
	(* ram_init_file = "test1.mif" *)
	reg [15:0] mem[0:256]; 
	output reg [15:0] mdr; // 16-bit MDR register

	always @(posedge CLOCK_50) begin
		mdr <= mem[addr]; // Read memory
	end
endmodule

module Instr_FE_Latch(clock,reset,fe_id_wr_en,instr_in,instr_addr_in,instr_out, instr_addr_out);
	input clock,reset;
	input fe_id_wr_en;
	input [15:0] instr_addr_in;
	input [15:0] instr_in;
	output reg [15:0] instr_addr_out;
	output reg [15:0] instr_out;
	always@(posedge clock) begin
		if(reset)
		begin
			instr_out       <= 'd0;
			instr_addr_out  <= 'd0;
		end
		else if(fe_id_wr_en == 'd0)
		begin
			instr_out       <= instr_out;
			instr_addr_out  <= instr_addr_out;
		end
		else if(fe_id_wr_en)
		begin
			instr_out       <= instr_in;
			instr_addr_out  <= instr_addr_in;
		end
	end
endmodule*/