/*********************************************************************
input:
	32  bit instruction
	2 bit op field
output:
	4 bit control lines
*********************************************************************/


module alu_control_unit(ins,aluop, out);
	input wire[31:0] ins;
	input wire[1:0] aluop;
	output wire [3:0] out;

	reg[3:0] tmpout;
	assign out = tmpout;

	always @ (*) begin
		if (aluop == 2'b00)
			tmpout = 4'b0010;
		else if (aluop == 2'b01)
			tmpout = 4'b0111;
		else if (aluop == 2'b10) begin
			if (ins[31:21] == 11'b10001011000)
				tmpout = 4'b0010;
			else if (ins[31:21] == 11'b11001011000)
				tmpout = 4'b0110;
			else if (ins[31:21] == 11'b10001010000)
				tmpout = 4'b0000;
			else if (ins[31:21] == 11'b10101010000)
				tmpout = 4'b0001;
		end
	end
endmodule


module tb_alu_control_unit;
	reg[31:0] ins;
	reg[1:0] op;
	wire[3:0] out;

	alu_control_unit u0(
		.ins(ins),
		.aluop(op),
		.out(out)
	);

	initial begin
		// test aluop 00 which means that instruction either ldr or str that should output 0010 which means add
		op = 2'b00;
		#10;
		$display("op = %b, out = %b", op, out);
		// test aluop 01 which means that instruction either ldr or str that should output 0111 which means pass b register value
		op = 2'b01;
		#10;
		$display("op = %b, out = %b", op, out);
		// test that op 10 which means that out is dependent on the opcode field of the instruction 
		op = 2'b10;
		ins[31:21] = 11'b10001011000;
		#10;
		$display("--------------------------------------------");
		$display ("op = %b, ins = %b, out should 0010", op, ins);
		$display ("out = %b", out);
		$display("--------------------------------------------");

		ins[31:21] = 11'b11001011000;
		#10;
		$display("--------------------------------------------");
		$display ("op = %b, ins = %b, out should 0110", op, ins);
		$display ("out = %b", out);
		$display("--------------------------------------------");

		ins[31:21] = 11'b10001010000;
		#10;
		$display("--------------------------------------------");
		$display ("op = %b, ins = %b, out should 0000", op, ins);
		$display ("out = %b", out);
		$display("--------------------------------------------");

		ins[31:21] = 11'b10101010000;
		#10;
		$display("--------------------------------------------");
		$display ("op = %b, ins = %b, out should 0001", op, ins);
		$display ("out = %b", out);
		$display("--------------------------------------------");
	end
endmodule
