import marsh.vm.chunk;
import marsh.vm.value;
import marsh.vm.opcode;
import marsh.vm.vm;
import marsh.vm.builtin;

void main()
{

    Chunk chunk;

    uint a = chunk.addConstant(Value(10));
    uint b = chunk.addConstant(Value(20));

    chunk.emit(OpCode.LOAD_CONST, a);
    chunk.emit(OpCode.STORE_LOCAL, 0);

    chunk.emit(OpCode.LOAD_CONST, b);
    chunk.emit(OpCode.STORE_LOCAL, 1);

    chunk.emit(OpCode.LOAD_LOCAL, 0);
    chunk.emit(OpCode.LOAD_LOCAL, 1);
    chunk.emit(OpCode.IADD);

    chunk.emit(OpCode.CALL, 0); //0 -> __builtin_print
    chunk.emit(OpCode.HALT);

    auto vm = VM(chunk, createBuiltins());
    vm.run();
}
