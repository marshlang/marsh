import std.stdio;
import marsh.lexer;
import marsh.token;
import marsh.vm.chunk;
import marsh.vm.value;
import marsh.vm.opcode;


void main()
{
	Chunk chunk;

	uint a = chunk.addConstant(Value(10));
	uint b = chunk.addConstant(Value(20));

	chunk.emit(OpCode.LOAD_CONST, a);
	chunk.emit(OpCode.LOAD_CONST, b);
	chunk.emit(OpCode.IADD);
	chunk.emit(OpCode.HALT);

	writeln("inst: ", chunk.code.length);
	writeln("consts: ", chunk.constants.length);
}
