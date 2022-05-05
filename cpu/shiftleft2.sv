/*************************************************
this will help to calclute brance target address
*************************************************/


module shiftleft2(in32, out32);
	input wire [31:0] in32;
	output wire[31:0] out32;


	assign out32 = { in32[29:0], 2'b00 };
endmodule

/*
module tb_shiftleft2;
	reg [31:0] in;
	wire[31:0] out;

	shiftleft2 u0(
		.in32(in),
		.out32 (out)
	);

	initial begin
		in = {{20 {1'b0}}, {12 {1'b1}} };
		#10;
		$display("in %b, out %b", in, out);
	end
endmodule
*/
