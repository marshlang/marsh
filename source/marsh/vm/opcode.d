module marsh.vm.opcode;

enum OpCode : ubyte
{
    LOAD_CONST,
    LOAD_LOCAL,
    STORE_LOCAL,
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
