/**********************************************************************
register file has 32 bit registers wide and 32 register total
has 3 inputs 2 of them reprsent what register i need to read
and last one represnt wich register should we write to
for example
add r0, r1, r2
we need to read r1 r2 data and write back to r0
**********************************************************************/


module regfile(r1, r2, wrn, wrd, we, clk, out1, out2);
	input [4:0] r1, r2, wrn;
	input [31:0] wrd;
	input clk;
	input we;

	output wire [31:0] out1, out2;
	reg [31:0] o1, o2;

	assign out1 = o1;
	assign out2 = o2;


	reg[31:0] file[31:0];

	always @ (posedge clk) begin
		o1 = file[r1];
		o2 = file[r2];
		if (we) begin
			file[wrn] = wrd;
		end
	end
	
endmodule

/*
module tb_regfile;

	reg[4:0] R1, R2, WRN;
	reg clk;
	reg [31:0] data;
	wire [31:0] OUT1, OUT2;
	reg WE;
	integer i;


	regfile u0(
		.r1(R1),
		.r2(R2),
		.wrn(WRN),
		.we(WE),
		.wrd(data),
		.clk(clk),
		.out1(OUT1),
		.out2(OUT2)
	);
	initial begin
		clk = 1'b0;
	end

	always 
		#10 clk = !clk;

	initial begin
		// file register file
		WE = 1'b1;
		for (i = 0; i < 32; ++i) begin
			WRN = i;
			data = i;
			#25;
		end

		WE = 0;
		$display("after store");
		// reading from file register
		for (i = 0; i < 32; i = i + 2) begin
			R1 = i;
			R2 = i + 1;
			#25;
			$display("R1 = %d, value = %d", i, OUT1);
			$display("R2 = %d, value = %d", i + 1, OUT2);
		end
		$finish;
	end
endmodule

*/
