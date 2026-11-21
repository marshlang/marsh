module marsh.vm.chunk;

import marsh.vm.opcode;
import marsh.vm.value;

struct Chunk{
    Instruction[] code;
    Value[] constants;

    uint addConstant(Value value){
        uint index = cast(uint) constants.length;
        constants ~= value;
        return index;
    }

    void emit(OpCode op, uint operand = 0){
        code ~= Instruction(op, operand);
    }
}