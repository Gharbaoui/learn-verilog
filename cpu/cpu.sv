`include "./adder.sv"
`include "./alu.sv"
`include "./alu_control_unit.sv"
`include "./insmem.sv"
`include "./main_control_unit.sv"
`include "./reg2locmux.sv"
`include "./regfile.sv"
`include "./signextended.sv"
`include "./memory.sv"
`include "./shiftleft2.sv"
`include "./mux32.sv"

module cpu;
	integer i;
	reg [31:0] PC;
	wire [31:0] newPc;
	wire [31:0] instruction;
	reg clk;


	insmem insmem(
		.clk(clk),
		.we(1'b0),
		.write_data(32'h00000000),
		.data_addr(PC),
		.output_data(instruction)
	);
	adder pcaddu0 (
		.a(4),
		.b(PC),
		.out(newPc)
	);

	initial begin
		PC = 32'h00000000;
		clk = 1'b0;
	end

	always
		#5 clk = !clk;

	initial begin
		// let's run this in 10 cycles
		for (i = 0; i < 2; ++i) begin
			#10;
			PC  =  newPc;
			$display("instruction is %h", instruction);
		end

		#10000 $finish;
	end
endmodule
