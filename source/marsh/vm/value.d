module marsh.vm.value;

import std.variant : Algebraic;

alias Value = Algebraic!(
    typeof(null),
    bool,
    int,
    double,
    string
);
