module dff(d, rst, clk, q);
	input wire d, rst, clk;
	output reg q;

	always @ (posedge clk)
	begin
		if (rst)
		  q <= 0;
		 else
		   q <= d;
	end
endmodule


module tb_top();

	wire [2:0] ins;
	wire out;
	dff d0 (ins[0], ins[1], ins[2], out);
	dff d1(
	.d(ins[0]),
	.clk(ins[2]),
	.rst(ins[1]),
	.q(out)
	);
endmodule
