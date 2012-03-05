module FE(CLOCK_50,reset,next_instr_addr,fe_instr_addr,id_instr_addr,next_pc_in,fetch_instr,id_instr,PC_WR_EN,FE_LATCH_WR,instr_mem_en,ctr_sig);
input CLOCK_50,reset, next_pc_in;
output  [15:0] next_instr_addr, fe_instr_addr, fetch_instr;
output  [15:0] id_instr_addr,id_instr;
input PC_WR_EN, FE_LATCH_WR, instr_mem_en;
input [1:0] ctr_sig;
//currently  everything is the same 
pc_mux(ctr_sig,next_pc_in,next_pc_in,next_pc_in,next_instr_addr);
pc(CLOCK_50,reset,next_instr_addr,fe_instr_addr,PC_WR_EN);
pc_adder_2(fe_instr_addr,next_pc_in);
Instr_Mem(CLOCK_50,reset,instr_mem_en,fe_instr_addr,fetch_instr);
Instr_FE_Latch(CLOCK_50,reset,FE_LATCH_WR,fetch_instr,next_pc_in, id_instr, id_instr_addr);

endmodule

module pc_mux(ctr_sig,in_1,in_2,in_3,out);
	
	input [1:0] ctr_sig;
	input [15:0] in_1,in_2,in_3;
	
	output reg [15:0] out;
	
	always@(*) begin
		if(ctr_sig == 'd1)
			out <= in_3;
		else if(ctr_sig == 'd0)
			out <= in_1;
		else
			out <= in_2;
	end

endmodule

module pc(clock,reset,in,out,write_en);
	input clock,reset,write_en;
	input [15:0] in;	
	output reg [15:0] out;
	always@(posedge clock) begin
		if(reset)
			out <= 0;
		else if(write_en)
			out <= in;
	end
endmodule

module pc_adder_2(in,out);
	input [15:0] in;
	output [15:0] out;
	assign out = in + 2;
endmodule

module Instr_Mem(CLOCK_50,reset,enable,addr,mdr);
	input CLOCK_50,reset, enable;
	input  [15:0] addr;
	//output reg[15:0] out;  //mdr will be the output register
	(* ram_init_file = "test1.mif" *)
	reg [15:0] mem[0:256]; 
	output reg [15:0] mdr; // 16-bit MDR register

	always @(posedge CLOCK_50 or posedge reset) begin
		if (reset) begin
		end
		else if (enable) begin
				mdr <= mem[addr]; // Read memory
		end
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
		else
		begin
			instr_out       <= instr_in;
			instr_addr_out  <= instr_addr_in;
		end
	end
endmodule