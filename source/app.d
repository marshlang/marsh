import marsh.vm.chunk;
import marsh.vm.value;
import marsh.vm.opcode;
import marsh.vm.vm;
import marsh.vm.builtin;

void main()
{

    Chunk chunk;

    uint x = chunk.addConstant(Value(10));
    uint ten = chunk.addConstant(Value(10));
    uint hundred = chunk.addConstant(Value(100));
    uint eleven = chunk.addConstant(Value(11));

    // let x = 11
    chunk.emit(OpCode.LOAD_CONST, x);
    chunk.emit(OpCode.STORE_LOCAL, 0);

    // if (x == 10)
    chunk.emit(OpCode.LOAD_LOCAL, 0);
    chunk.emit(OpCode.LOAD_CONST, ten);
    chunk.emit(OpCode.IEQ);

    // Jump to else, if false
    chunk.emit(OpCode.JMP_IF_FALSE, 9);

    // if body
    chunk.emit(OpCode.LOAD_CONST, hundred);
    chunk.emit(OpCode.CALL, 0);

    // Skip else
    chunk.emit(OpCode.JMP, 11);

    // else body
    chunk.emit(OpCode.LOAD_CONST, eleven);
    chunk.emit(OpCode.CALL, 0);

    chunk.emit(OpCode.HALT);

    auto vm = VM(chunk, createBuiltins());
    vm.run();

}
