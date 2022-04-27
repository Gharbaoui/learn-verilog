module half_adder(a, b, sum, cout);
	input wire a, b;
	output wire sum, cout;

	assign sum = a ^ b;
	assign cout = a & b;
endmodule


module full_adder(input a, b, cin, output sum, cout);
	assign sum = (a ^ b) ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module mux2_1(input i1, i2, sel, output z);
	assign z = sel ? i2 : i1;
endmodule

module tb_half_adder;
	reg a, b;
	wire sum, cout;
	integer i;

	half_adder u0 (a, b, sum, cout);
	initial begin
	a <= 0;
	b <= 0;
	$monitor("a = %0b, b = %0b, sum = %0b, cout = %0b", a, b, sum, cout);

	for (i = 0; i < 4; ++i) begin
	  {a, b} = i;
	  #10;
	  end
	end
endmodule

module tb_full_adder;

	reg a, b, cin;
	wire sum, cout;
	integer i;
	full_adder u1(a, b, cin, sum, cout);
	initial begin
		a <= 0;
		b <= 0;
		cin <= 0;

		$monitor("a = %0b, b = %0b, cin = %0b, sum = %0b, cout = %0b",
			a, b, cin, sum, cout
		);

		for (i = 0; i < 8; ++i) begin
			{a, b, cin} = i;
			#10;
		end
	end

endmodule

module tb_mux_2_1;
	reg i1, i2, sel;
	wire out;
	integer i;
	mux2_1 u0(i1, i2, sel, out);
	initial begin
	i1 <= 0;
	i2 <= 0;
	sel <= 0;

	$monitor("i1 = %0b, i2 = %0b, sel = %b, out = %0b", 
		i1, i2, sel, out
	);

	for (i = 0; i < 8; ++i) begin
		{i1, i2, sel} = i;
		#10;
	end
	end
endmodule
