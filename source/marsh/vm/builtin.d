module marsh.vm.builtin;

import std.stdio;
import marsh.vm.value;

alias BuiltFn = Value delegate(Value[] args);

struct Builtin
{
    string name;
    uint arity; //args count
    BuiltFn callback;
}

struct BuiltinRegistry
{
    private Builtin[] functions;

    uint registerBuiltin(Builtin builtin)
    {
        uint id = cast(uint) functions.length;
        functions ~= builtin;
        return id;
    }

    Builtin get(uint id)
    {
        if (id >= functions.length)
            throw new Exception("Unknown builtin function");

        return functions[id];
    }
}

BuiltinRegistry createBuiltins()
{
    BuiltinRegistry registry;

    registry.registerBuiltin(Builtin("__builtin_println", 1, (Value[] args) {
            writeln(args[0]);
            return Value(null);
        }));

    return registry;
}
