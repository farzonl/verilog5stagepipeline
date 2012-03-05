module WB(CLOCK_50, wb_ctr_sig, wb_mem_src, wb_alu_src, WB_val); 
input CLOCK_50;
input  [0 :0] wb_ctr_sig;
input  [15:0] wb_mem_src,wb_alu_src;
output [15:0] WB_val;
wb_mux (CLOCK_50,wb_ctr_sig, wb_alu_src,wb_mem_src,WB_val);
SevenSeg sseg0(.IN(WB_val[ 3: 0]),.OUT(HEX0));
SevenSeg sseg1(.IN(WB_val[ 7: 4]),.OUT(HEX1));
SevenSeg sseg2(.IN(WB_val[11: 8]),.OUT(HEX2));
SevenSeg sseg3(.IN(WB_val[15:12]),.OUT(HEX3));
endmodule

module wb_mux(clock,ctr_sig,in_1,in_2,out);
   input clock;
	input [0:0] ctr_sig;
	input [15:0] in_1,in_2;
	
	output reg [15:0] out;
	
	always@(posedge clock) begin
		if(ctr_sig == 'd1)
			out <= in_1;
		else if(ctr_sig == 'd0)
			out <= in_2;
	end

endmodule

module SevenSeg(OUT,IN);
	input  [3:0] IN;
	output [6:0] OUT;
	assign OUT =
  (IN == 4'h0) ? 7'b1000000 :
  (IN == 4'h1) ? 7'b1111001 :
  (IN == 4'h2) ? 7'b0100100 :
  (IN == 4'h3) ? 7'b0110000 :
  (IN == 4'h4) ? 7'b0011001 :
  (IN == 4'h5) ? 7'b0010010 :
  (IN == 4'h6) ? 7'b0000010 :
  (IN == 4'h7) ? 7'b1111000 :
  (IN == 4'h8) ? 7'b0000000 :
  (IN == 4'h9) ? 7'b0010000 :
  (IN == 4'hA) ? 7'b0001000 :
  (IN == 4'hb) ? 7'b0000011 :
  (IN == 4'hc) ? 7'b1000110 :
  (IN == 4'hd) ? 7'b0100001 :
  (IN == 4'he) ? 7'b0000110 :
  /*IN == 4'hf*/ 7'b0001110 ;
endmodule