/******************************************************************
4 bit op code 32bit inputs
0000 means and
0001 means or
0010 means add
0110 means or
otherwise value would not change
******************************************************************/


module alu(a, b, out, clk,  zero, op);
	input wire[31:0] a, b;
	input wire[3:0] op;
	output wire[31:0] out;
	output wire zero;

	input wire clk;

	reg[31:0] result;
	reg  tmp;
	assign out = result;
	assign zero = tmp;

	always @ (posedge clk) begin
		case(op)
		4'b0000:
			result = a & b;
		4'b0001:
			result = a | b;
		4'b0010:
			result = a + b;
		4'b0110:
			begin
				result = a - b;
				if (result == 0)
					tmp = 1'b1;
				else
					tmp = 1'b0;
			end
		endcase
	end
endmodule

module alu_test;

	reg [31:0] A, B;
	reg [3:0] OP;
	reg clk;
	wire [31:0] OUT;
	wire ZERO;

	alu u0(
	.a(A),
	.b(B),
	.out(OUT),
	.clk(clk),
	.zero(ZERO),
	.op(OP));


	initial begin
		clk = 1'b0;
	end

	always begin
		#5 clk = !clk;
	end



	initial begin
		// A = 00..11 B = 11..00 result should be 00..00 in case of AND should be 11.11 in case of OR
		OP = 4'b0000;  // opcode for and
		A = 32'h00000003;
		B = 32'hfffffffc;
		

		#7
		$display("and of");
		$display ("A = %B" , A);
		$display ("B = %B" , B);
		$display ("result = %B", OUT);




		OP = 4'b0001;  // opcode for and
		#7;
		$display("or of");
		$display ("A = %B" , A);
		$display ("B = %B" , B);
		$display ("result = %B", OUT);
		// A = 0xeeeeeeee B= 0x11111111 add should give 0xffffffff   sub should give 0xdddddddd
		OP = 4'b0010;  // opcode for and
		A = 32'heeeeeeee;
		B = 32'h11111111;
		#7;
		$display("add of");
		$display ("A = %h" , A);
		$display ("B = %h" , B);
		$display ("result = %h", OUT);

		OP = 4'b0110;  // opcode for and
		#7;
		$display("sub of");
		$display ("A = %h" , A);
		$display ("B = %h" , B);
		$display ("result = %h zero flag = %B", OUT, ZERO);

		OP = 4'b0110;  // opcode for and
		A = 32'heeeeeeee;
		B = 32'heeeeeeee;
		#7;
		$display("sub of");
		$display ("A = %h" , A);
		$display ("B = %h" , B);
		$display ("result = %h zero flag = %B", OUT, ZERO);

		$finish;
	end
endmodule
