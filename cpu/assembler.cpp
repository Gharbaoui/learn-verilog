#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>
#include <bitset>


// this assembler has zero checks
/*
	rules
	for R-type
		ins register register register
	for D-type (load, store)
		ins register register address
	for CB-type
		ins register offset
	else
		no promise
*/


template <size_t N1, size_t N2>
std::bitset<N1 + N2> concatnate(const std::bitset<N1> &first, const std::bitset<N2> &second)
{
	return std::bitset<N1 + N2>(first.to_string() + second.to_string());
}

std::string convertbitset(const std::bitset<32> &ins)
{
	std::string str, done;
	char line[12];
	unsigned int val = ins.to_ulong();
	std::stringstream s;
	s <<  (void*)val;
	s >> str;

	line[0] = str[2];
	line[1] = str[3];
	line[2] = ' ';
	line[3] = str[4];
	line[4] = str[5];
	line[5] = ' ';
	line[6] = str[6];
	line[7] = str[7];
	line[8] = ' ';
	line[9] = str[8];
	line[10] = str[9];
	line[11] = 0;
	return std::string(line) + "\n";
}

int register_number(const std::string &r) {
	std::bitset<5> regnum;
	std::string s(r.c_str() + 1);
	return  stoi(s);
}

int getInstructionFormat(std::string &ins){
	for (auto &val : ins)
		val = std::tolower(val);
	std::cout << ins << "\n";
	if (ins == "ldr" || ins == "str")
		return 0; // which means D-type
	else if (ins == "cbz")
		return 1; // CB-type
	return 2; // R-type
}


std::vector<std::string> getTokens(char *line)
{
	std::vector<std::string> tokens;
	char *cur;
	cur = line;
	for (int i = 0; line[i] != 0; ++i)
	{
		if (line[i] == ' ' || line[i + 1] == 0)
		{
			if (line[i] == ' ')
				line[i] = 0;
			else
				line[i + 1] = 0;
			tokens.push_back(cur);
			cur = line + 1 + i;
		}
	}
	return tokens;
}

std::bitset<11> opfields[7] = {
	0b11111000010,
	0b11111000000,
	0b10001011000,
	0b11001010000,
	0b10001010000,
	0b10101010000,

};


std::bitset<11>  lookup(const std::string &ins) {
	if (ins == "ldr")
		return opfields[0];
	else if (ins == "str")
		return opfields[1];
	else if (ins == "add")
		return opfields[2];
	else if (ins == "sub")
		return opfields[3];
	else if (ins == "and")
		return opfields[4];
	else if (ins == "or")
		return opfields[5];
	std::cout << "not valid instruction :" << ins << "\n";
	exit(1);
}

std::bitset<32>	handelDType(const std::vector<std::string> &tokens){
	std::bitset<11> opfield = lookup(tokens[0]);
	std::bitset<2> op2 = 0b00;
	std::bitset<5> rt = register_number(tokens[1]);
	std::bitset<5> rn = register_number(tokens[2]);
	std::bitset<9> offset;
	unsigned int num;
	if (tokens[3][0] == '0' && tokens[3][1] == 'x')
	{
		std::stringstream ss;
		ss << std::hex << tokens[3];
		ss >> num;
	}
	else
		num = std::stoi(tokens[3]);
	
	offset = num;
	
	auto a = concatnate (opfield, offset);
	auto b = concatnate(a, op2);
	auto c = concatnate(b, rn);
	return  concatnate (c, rt);
}



std::bitset<32>	handelCBType(const std::vector<std::string> &tokens){
	unsigned int num;
	std::bitset<8> opfield = 0b10110100; // means cbz
	std::bitset<19> offset;
	std::bitset<5> rt = register_number(tokens[1]);
	if (tokens[2][0] == '0' && tokens[2][1] == 'x')
	{
		std::stringstream ss;
		ss << std::hex << tokens[2];
		ss >> num;
	}
	else
		num = std::stoi(tokens[2]);
	
	offset = num;
	auto a = concatnate(opfield, offset);
	return concatnate(a, rt);
}

std::bitset<32>	handelRType(const std::vector<std::string> &tokens){
	std::bitset<11> opfield = lookup(tokens[0]);
	std::bitset<5> rd = register_number(tokens[1]);
	std::bitset<5> rm = register_number(tokens[2]);
	std::bitset<5> rn = register_number(tokens[3]);
	std::bitset<6> shamt = 0b000000;

	auto a = concatnate(opfield, rm);
	auto b = concatnate(shamt, rn);
	auto c = concatnate(a, b);
	return concatnate(c, rd);
}


int main(int argc, char **argv)
{
	if (argc > 1)
	{
		std::vector<std::string> tokens;
		std::bitset<32> ins;
		short type;
		char line[100];
		std::fstream program(argv[1]);
		if (!program.is_open()) return 1;
		char *filename = "out.txt";
		std::fstream file;
		file.open(filename, std::fstream::out);
		file.close();
		file.open(filename, std::fstream::out);

		do {
			program.getline(line, 100);
			if (!program.gcount() || line[0] == 0) break;
			tokens = getTokens(line);
			type = getInstructionFormat(tokens[0]);
			if (type == 0)
			{
				// means D-type
				ins = handelDType(tokens);
			}
			else if (type == 1)
			{
				// means CB type
				ins = handelCBType(tokens);
			}
			else
			{
				// means R-type
				ins = handelRType(tokens);
			}
			file << convertbitset(ins);
		} while (1);
		file.close();
		


	}
	else
		std::cout << "please enter file\n";
}
