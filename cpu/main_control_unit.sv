/******************************************************************
this module will set control signals
depending on the 11bit opcode field
******************************************************************/

module main_control_unit(
	input wire[10:0] ins, // 11 bit instruction
	output wire reg2loc, // if on means that location of second register is in 4:0 in case for store and load
	output wire alusrc, // should we take input from sign extended unit or from register file 1, 0
	output wire memtoreg, // should data to be going to register file comes from aly in case of r-type or from memory in case of store
	output wire regwrite, // should we enable register file to change data in specified address input to written in case of r-type or store
	output wire memread, // enabled when you want to read from memory in case of load (ldr)
	output wire memwrite, // enabled  whene you want to store data in memory in case of store
	output wire branch, // should be enabled in case of cbz instruction
	output wire[1:0] aluop // should be 00 in case of load and store 01 in case of  cbz 10 in case of R-type
);

	 reg in_reg_reg2loc;
	 reg in_reg_alusrc;	
	 reg in_reg_memtoreg;
	 reg in_reg_regwrite;
	 reg in_reg_memread;
	 reg in_reg_memwrite;
	 reg in_reg_branch;
	 reg[1:0] in_reg_aluop;

	 assign reg2loc = in_reg_reg2loc;
	 assign alusrc = in_reg_alusrc;	
	 assign memtoreg = in_reg_memtoreg;
	 assign regwrite = in_reg_regwrite;
	 assign memread = in_reg_memread;
	 assign memwrite = in_reg_memwrite;
	 assign branch = in_reg_branch;
	 assign aluop = in_reg_aluop;

	always @ (ins) begin
		if (ins[5] == 1'b1) begin
			// means cbz
			in_reg_aluop = 2'b01;
			in_reg_reg2loc = 1'b1;
			in_reg_alusrc = 1'b0;
			in_reg_regwrite = 1'b0;
			in_reg_memread = 1'b0;
			in_reg_memwrite = 1'b0;
			in_reg_branch  = 1'b1;

		end
		else if (ins[1] == 1'b1) begin
			// means ldr
			in_reg_aluop = 2'b00;
			in_reg_alusrc = 1'b1;
			in_reg_memtoreg = 1'b1;
			in_reg_regwrite = 1'b1;
			in_reg_memread = 1'b1;
			in_reg_memwrite = 1'b0;
			in_reg_branch = 1'b0;
		end
		else if (ins[4] == 1'b1) begin
			// means R-format
			in_reg_aluop = 2'b10;
			in_reg_regwrite = 1'b1;
			in_reg_reg2loc = 1'b0;
			in_reg_alusrc = 1'b0;
			in_reg_memtoreg = 1'b0;
			in_reg_memread = 1'b0;
			in_reg_memwrite = 1'b0;
			in_reg_branch = 1'b0;
		end
		else begin
			// means str
			in_reg_aluop = 2'b00;
			in_reg_reg2loc = 1'b1;
			in_reg_alusrc = 1'b1;
			in_reg_regwrite = 1'b0;
			in_reg_memread = 1'b0;
			in_reg_memwrite = 1'b1;
			in_reg_branch = 1'b0;
		end
	end

endmodule

/*
module displ(
	input wire reg2loc,
	input wire alusrc,
	input wire memtoreg,
	input wire regwrite,
	input wire memread,
	input wire memwrite,
	input wire branch,
	input wire[1:0] aluop
);

	always @ (*) begin
		$display("%b%b%b%b%b%b%b%b%b", reg2loc, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop[1], aluop[0]);
		$display("--------------------------------------------------- ");
		$display("++++++++++++++++++++++++++++= reg2loc");
		if (reg2loc)
			$display("means choose 4:0 (ldr, str, cbz)");
		else
			$display("means choose 20:16 R-type");
		$display("register as second input to register file");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= alusrc");
		if (alusrc)
			$display("choos  sign exetended value as input to alu");
		else
			$display("choose register as input to alu (R-type, str)");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= memtoreg");
		if (memtoreg)
			$display("data to be written to reg file comes from memory (ldr)");
		else
			$display("data to be written to reg file comes ALU R-type");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= regwrite");
		if (regwrite)
			$display("allow data to be written in register file (R-type, ldr)");
		else
			$display("NOT allow data to be written in register file (str, cbz)");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= memread");
		if (memread)
			$display("read from memory (ldr)");
		else
			$display("not read from memory");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= memwrite");
		if (memwrite)
			$display("write to memory from second register (str)");
		else
			$display("not write to memory");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= branch");
		if (branch)
			$display("branch cbz");
		else
			$display("not branch");
		$display("++++++++++++++++++++++++++++=");

		$display("++++++++++++++++++++++++++++= aluop");
		if (aluop == 2'b00)
			$display("load or store aluop");
		else if (aluop == 2'b01)
			$display("branch aluop");
		else
			$display("R-type aluop");
		$display("++++++++++++++++++++++++++++=");
		$display("---------------------------------------------------");
	end

endmodule

module tb_main_control_unit;
	
	reg [10:0] ins;
	wire reg2loc;
	wire alusrc;
	wire memtoreg;
	wire regwrite;
	wire memread;
	wire memwrite;
	wire branch;
	wire[1:0] aluop;

	displ du0(
		.reg2loc(reg2loc),
		.alusrc(alusrc),
		.memtoreg(memtoreg),
		.regwrite(regwrite),
		.memread(memread),
		.memwrite(memwrite),
		.branch(branch),
		.aluop(aluop)
	);

	main_control_unit u0(
		.ins(ins),
		.reg2loc(reg2loc),
		.alusrc(alusrc),
		.memtoreg(memtoreg),
		.regwrite(regwrite),
		.memread(memread),
		.memwrite(memwrite),
		.branch(branch),
		.aluop(aluop)
	);

	initial begin
		ins = 11'b10110100xxx;
		#10;
		ins = 11'b11111000000;
		#10;
		ins = 11'b1xx0101x000;
		#10;
		ins = 11'b11111000010;
		#10;
	end

endmodule
*/
