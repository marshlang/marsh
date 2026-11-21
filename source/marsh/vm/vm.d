module marsh.vm.vm;
import marsh.vm.chunk;
import marsh.vm.value;
import marsh.vm.opcode;
import marsh.vm.builtin;

struct VM
{
    private Chunk chunk;
    private Value[] stack;
    private size_t ip; //instruction pointer!!!
    private BuiltinRegistry builtins;
    private Value[] locals;

    this(Chunk chunk, BuiltinRegistry builtins)
    {
        this.chunk = chunk;
        this.builtins = builtins;
    }

    private void push(Value value)
    {
        this.stack ~= value;
    }

    private Value pop()
    {
        if (stack.length == 0)
        {
            throw new Exception("stack underflow!");
        }

        Value value = stack[$ - 1];
        stack.length--;
        return value;
    }

    private void callBuiltin(uint id)
    {
        Builtin builtin = builtins.get(id);

        if (stack.length < builtin.arity)
            throw new Exception("Not enough arguments");

        Value[] args;

        foreach (i; 0 .. builtin.arity)
        {
            args ~= pop();
        }

        Value result = builtin.callback(args);
        push(result);
    }

    void run()
    {
        while (ip < chunk.code.length)
        {
            Instruction inst = chunk.code[ip++];

            switch (inst.op)
            {
            case OpCode.LOAD_CONST:
                if (inst.operand >= chunk.constants.length)
                {
                    throw new Exception("Invalid constant index!");
                }

                push(chunk.constants[inst.operand]);
                break;
            case OpCode.IADD:
                Value right = pop();
                Value left = pop();

                if (!left.peek!int || !right.peek!int)
                {
                    throw new Exception("IADD: expected integers");
                }

                push(Value(left.get!int + right.get!int));
                break;

            case OpCode.ISUB:
                Value right = pop();
                Value left = pop();

                if (!left.peek!int || !right.peek!int)
                {
                    throw new Exception("ISUB: expected Integers");
                }

                push(Value(left.get!int - right.get!int));
                break;

            case OpCode.IMUL:
                Value right = pop();
                Value left = pop();

                if (!left.peek!int || !right.peek!int)
                {
                    throw new Exception("IMUL: expected Integers");
                }

                push(Value(left.get!int * right.get!int));
                break;

            case OpCode.IDIV:
                Value right = pop();
                Value left = pop();

                if (!left.peek!int || !right.peek!int)
                {
                    throw new Exception("IDIV: expected Integers");
                }

                push(Value(left.get!int / right.get!int));
                break;

            case OpCode.CALL:
                callBuiltin(inst.operand);
                break;

            case OpCode.STORE_LOCAL:
                size_t slot = inst.operand;

                if (slot >= locals.length)
                {
                    locals.length = slot + 1;
                }

                locals[slot] = pop();

                break;

            case OpCode.LOAD_LOCAL:
                size_t slot = inst.operand;

                if (slot >= locals.length)
                {
                    throw new Exception("LOAD_LOCAL: invalid local variable index!");
                }

                push(Value(locals[slot]));
                break;

            case OpCode.HALT:
                return;

            default:
                throw new Exception("Unexpceted opcode");
                break;
            }
        }
    }

    Value top()
    {
        if (stack.length == 0)
        {
            throw new Exception("stack is empty");
        }

        return stack[$ - 1];
    }
}
