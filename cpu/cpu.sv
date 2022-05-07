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

/*
	not supporting negative that means you can not make loop
	by branching backwards
*/

module cpu;
	// general (PC, instruction, clk ,...)
	integer i;
	wire [31:0] instruction;
	reg  [31:0] PC;
	reg clk, main_unit_clk;
	// end


	// start of main control unit
	wire reg2loc;
	wire alusrc;
	wire memtoreg;
	wire regwrite;
	wire memread;
	wire memwrite;
	wire branch;
	wire[1:0] aluop;
	
	main_control_unit main_control_unit_u0(
		.ins(instruction[31:21]),
		.clk(main_unit_clk),
		.turonofclk(clk),
		.reg2loc(reg2loc),
		.alusrc(alusrc),
		.memtoreg(memtoreg),
		.regwrite(regwrite),
		.memread(memread),
		.memwrite(memwrite),
		.branch(branch),
		.aluop(aluop)
	);

	// end of main control unit

	// start of instruction memory

	insmem insmem_u0(
		.clk(clk),
		.we(1'b0),
		.data_addr(PC),
		.output_data(instruction)
	);

	// end of instruction memory
	
	// adder that moves pc to next instruction
	wire[31:0] nextIns;

	adder adder_u0(
		.a(PC),
		.b(32'h00000004),
		.out(nextIns)
	);
	
	// end of adder

	
	// start of multiploxer
	wire [4:0] sReg;

	reg2locmux reg2locmux_u0(
		.r_type_pos (instruction[20:16]),
		.str_load_cbz(instruction[4:0]),
		.sel(reg2loc),
		.out(sReg)
	);

	// end of multiplexor

	// start of register file
	wire [31:0] regd1, regd2;


	regfile regfile_u0(
		.r1(instruction[9:5]),
		.r2(sReg),
		.wrn(instruction[4:0]),
		.we(regwrite),
		.wrd(regdatasrc), // still empty data either will come from alu pr memory (add, load)
		.out1(regd1),
		.out2(regd2)
	);


	// end regfile



	// start of alu source multiploxer

	wire[31:0] alub;

	mux32 alu_mux_u0(
		.a(regd2),
		.b(immextended),
		.sel(alusrc),
		.out(alub)
	);
	// end of alu multiploxer

	// start of sign extended module
	wire[31:0] immextended;

	sign_extended sign_extended_u0(
		.in32(instruction),
		.out32(immextended)
	);
	// end of sign extended

	// start of alu control unit
	wire[3:0] alu_control_lines;

	alu_control_unit alu_control_unit_u0(
		.ins(instruction),
		.aluop(aluop),
		.out(alu_control_lines)
	);
	
	// end of alu control unit


	// start of alu module
	wire [31:0] aluout;
	wire ZERO;

	alu alu_u0(
		.a(regd1),
		.b(alub),
		.out(aluout),
		.zero(ZERO),
		.op(alu_control_lines)
	);

	// end of alu module

	// start of memory 
	wire [31:0] memout;


	mem mem_u0 (
		.address(aluout),
		.data(regd2),
		.read_enable(memread),
		.write_enable(memwrite),
		.out (memout)
	);

	// end of memory

	// start of multiploxer that is used to choose what data to be written in regfile is it from alu or from memory

	wire[31:0] regdatasrc;

	mux32 alu_mux_u1(
		.a(aluout),
		.b(memout),
		.sel(memtoreg),
		.out(regdatasrc)
	);
	// end of regfile  multiploxer

	// start of shifter  (shift  left 2)
	wire[31:0] branchoffset;

	shiftleft2 shiftleft2_u0(
		.in32(immextended),
		.out32 (branchoffset)
	);

	// end of shifter

	// adder that calcluate target branch address
	wire[31:0] targetIns;

	adder adder_u1(
		.a(PC),
		.b(branchoffset),
		.out(targetIns)
	);
	
	// end of adder


	// start of and gate
	wire pcsrc;
	and(pcsrc, ZERO, branch);
	// end of and gate

	// start of pc source multiploxer

	wire[31:0] finalPc;

	mux32 alu_mux_u2(
		.a(nextIns),
		.b(targetIns),
		.sel(pcsrc),
		.out(finalPc)
	);
	// end of pc source multiploxer


	initial begin
		PC = 32'h00000000;
		clk = 1'b0;
	end

	always #10 clk = !clk;


	always @ (posedge clk) begin
		#16;
		main_unit_clk = 0;
		main_unit_clk = 1; // force main unit clock to alternate
		PC = finalPc;
		$display("instruction %h, reg1 = %d, reg2 = %d", instruction ,regd1, regd2);
	end

	initial #200 $finish;

endmodule
