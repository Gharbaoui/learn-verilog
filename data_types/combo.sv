module comb(a, b, c, d, e, z);
	input wire a, b, c, d, e;
	output wire z;

	assign z = ~((a & b) | (c ^ d) & ~e);

endmodule



module tb;
	reg a, b, c, d, e;
	wire z;
	integer i;

	comb u0 (
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.e(e),
		.z(z)
	);

	initial begin
		a <= 0;
		b <= 0;
		c <= 0;
		d <= 0;
		e <= 0;

		$monitor("a = %0b, b = %0b, c = %0b, d = %0b, e = %0b, z = %0b",
			a, b, c, d, e, z
		);


		for (i = 0; i < 32; ++i) begin
			{a, b, c, d, e} = i;
			#10;
		end
	end
endmodule
