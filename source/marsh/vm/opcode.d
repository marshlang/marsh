module marsh.vm.opcode;

enum OpCode : ubyte
{
    LOAD_CONST,
    IADD,
    ISUB,
    IDIV,
    IMUL,
    HALT,
    CALL,
    RET
}

struct Instruction
{
    OpCode op;
    uint operand = 0;
}
