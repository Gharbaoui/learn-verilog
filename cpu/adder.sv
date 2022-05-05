/***************
// adder add a b inputs
***************/

module adder(a, b, out);
	input wire[31:0] a, b;
	output wire [31:0] out;

	assign out = a + b;
endmodule


module tb_adder;
	reg[31:0] a, b;
	wire[31:0] out;

	adder u0(
		.a(a),
		.b(b),
		.out(out)
	);

	initial begin
		a = 32'heeeeeeee;
		b = 32'h11111111;
		#10;
		$display("a = %h, b = %h, out = %h", a, b, out);
	end
endmodule
