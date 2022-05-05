/*************************************
memory to hold data not instructions
with 4096 bytes
*************************************/


module mem(address, read_enable, write_enable, clk, data, out);
	input wire[31:0] address, data;
	input wire read_enable, write_enable, clk;
	output wire[31:0] out;


	reg[7:0] ram[0:4095];
	
	reg[31:0] tmpout;

	initial 
		$readmemh("data.txt", ram, 0, 7);
	assign out = tmpout;
	always @ (posedge clk) begin
		if (address < 4096) begin
			if (read_enable == 1'b1) begin
					tmpout[7:0] = ram[address + 3];
					tmpout[15:8] = ram[address + 2];
					tmpout[23:16] = ram[address + 1];
					tmpout[31:24] = ram[address];
			end
			else if (write_enable == 1'b1) begin
				ram[address] = data[31:24];
				ram[address + 1] = data[23:16];
				ram[address + 2] = data[15:8];
				ram[address + 3] = data[7:0];
			end
		end
	end
endmodule
/*

module tb_mem;
	reg[31:0] address, data;
	reg read_enable, write_enable, clk;
	wire [31:0] out;


	mem u0 (
		.address(address),
		.data(data),
		.read_enable(read_enable),
		.write_enable(write_enable),
		.clk(clk),
		.out (out)
	);


	initial 
		clk = 1'b0;
	always
		#5 clk = !clk;
	
	initial begin
		// write data when write_enable is false
		address = 0;
		data = 32'hffbb00aa;
		write_enable = 1'b0;
		read_enable = 1'b1;
		#10;
		// let's see if this has effect
		$display("at %d, value = %h", address, out);
		



		// write data when write_enable is true
		address = 0;
		data = 32'hffbb00aa;
		write_enable = 1'b1;
		read_enable = 1'b0;
		#10;
		// let's see if this has effect

		write_enable = 1'b0;
		read_enable = 1'b1;
		#10;
		$display("at %d, value = %h", address, out);

		$display();
		$finish;
	end
	

endmodule

*/
