/***************************************************************************************************
will sign extended 9 bits to 32 bit values
***************************************************************************************************/


module sign_extended(in9, out32);
	input wire [8:0] in9;
	output wire[31:0] out32;

	assign out32[8:0] = in9;
	assign out32 [31:9] = {23{in9[8]}};
endmodule


module tb_sign_extended;

	reg[8:0] in9;
	wire [31:0] out;

	sign_extended u0(
		.in9(in9),
		.out32(out)
	);

	initial begin
		in9 = 9'b100000001;
		#10;

		$display("in %b ,out %b", in9, out);

		in9 = 9'b011111111;
		#10;

		$display("in %b ,out %b", in9, out);
	end

endmodule
