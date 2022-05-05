/***************************************************************************************************
will sign extended 9 bits to 32 bit values
***************************************************************************************************/


module sign_extended(in32, out32);
	input wire [31:0] in32;
	output wire[31:0] out32;

	reg[31:0]  out;
	assign out32 = out;

	always @ (in32) begin
		if (in32[26] == 1'b1) // means branch
			out = {{13 {in32[23]}}, in32[23:5]};
		else // means store or load
			out = {{23 {in32[20]}}, in32[20:12]};
	end
endmodule


module tb_sign_extended;
	reg[31:0] in32;
	wire[31:0] out;

	sign_extended u0(
		.in32(in32),
		.out32(out)
	);


	initial begin
		in32[26] = 1'b0;
		in32[20:12] = 9'b101001011;
		#10;
		$display("input %b, output %b", in32, out);

		in32[26] = 1'b0;
		in32[20:12] = 9'b001001011;
		#10;
		$display("input %b, output %b", in32, out);

		$display("----");
		
		in32[26] = 1'b1;
		in32[23:5] = 19'b1010010111011010000;
		#10;
		$display("input %b, output %b", in32, out);

		in32[26] = 1'b1;
		in32[23:5] = 19'b0010010111011010000;
		#10;
		$display("input %b, output %b", in32, out);


	end

endmodule
