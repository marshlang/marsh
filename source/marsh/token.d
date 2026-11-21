module marsh.token;

enum TokenKind
{
    //keywords
    KImport,
    KFun,
    //symbols
    LParen,
    RParen,
    LBrace,
    RBrace,
    Comma,
    Dot,
    //literals
    ConstID,
    ConstString,
    ConstNumber,
    NEWLINE,
    Eof
}

struct Span
{
    size_t line;
    size_t column;
    size_t offset;
    size_t length;
    string fileName; //later this should be a fileName id or something like that
}

struct Token
{
    TokenKind kind;
    string value;
    Span span;
}
