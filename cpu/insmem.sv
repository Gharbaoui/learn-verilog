/************************************************************
memory with 1024 byte or 256 word (littel indian)
if address is not valid output_data data will not change
inputs:
	1 bit write enable wire 
	32 bit data address 
	32 bit data words
output:
	32bit data output
************************************************************/


module insmem(clk, we, data_addr, write_data, output_data);
	input wire we, clk;
	input wire[31:0] data_addr, write_data;
	output wire[31:0] output_data;

	reg[7:0] mem[0:1023];
	reg [31:0] tmpout;


	initial 
	$readmemh("program.txt", mem, 0, 7); // look at  start and end address

	assign output_data = tmpout;
	always @ (posedge clk) begin
		if (data_addr + 3 < 1024) begin
			if (we) begin
				mem[data_addr] = write_data[31:24];
				mem[data_addr + 1] = write_data[23:16];
				mem[data_addr + 2] = write_data[15:8];
				mem[data_addr + 3] = write_data[7:0];
			end
			tmpout[7:0] = mem[data_addr + 3];
			tmpout[15:8] = mem[data_addr + 2];
			tmpout[23:16] = mem[data_addr + 1];
			tmpout[31:24] = mem[data_addr];
		end
	end

endmodule


module tb_insmem;
	reg clk, we;
	reg[31:0] address;
	reg[31:0] data;

	wire[31:0] out;

	insmem u0(
		.clk(clk),
		.we(we),
		.data_addr(address),
		.write_data(data),
		.output_data(out)
	);
	

	initial begin
		clk = 1'b0;
	end

	always begin
		#5 clk = !clk;
	end

	initial begin
		// let's read data in valid range
		we = 1'b0;
		address = 1;
		#10;
		$display("at %d value = %h", address, out);
		// let's read data in invalid range should keep old data
		address = 1;
		#10;
		$display("at %d value = %h", address, out);

		// change at valid range with write enable on
		we = 1'b1;
		address = 0;
		data = 32'hffff4455;
		#10;
		$display("at %d value = %h", address, out);
		// change at valid range with write enable off
		we = 1'b0;
		address = 0;
		data = 32'h00000000;
		#10;
		$display("at %d value = %h", address, out);
		// change at invalid range
		we = 1'b1;
		address = 2000;
		data = 32'h00000000;
		#10;
		$display("at %d value = %h", address, out);


		$display();
		$finish;
	end

endmodule
