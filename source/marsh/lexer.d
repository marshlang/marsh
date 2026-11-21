module marsh.lexer;

import std.format : format;
import marsh.token;

struct Lexer
{
    private string source;
    private string filename;
    private size_t offset = 0;
    private size_t line = 1;
    private size_t column = 1;

    this(string source, string filename)
    {
        this.source = source;
        this.filename = filename;
    }

    bool isAtEnd()
    {
        return offset >= source.length;
    }

    private char peek()
    {
        return isAtEnd() ? '\0' : source[offset];
    }

    private char advance()
    {
        char c = source[offset++];
        if (c == '\n')
        {
            line++;
            column = 1;
        }
        else
        {
            column++;
        }
        return c;
    }

    private static bool isAlpha(char c)
    {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
    }

    private static bool isDigit(char c)
    {
        return c >= '0' && c <= '9';
    }

    private static TokenKind getKeyword(string value) {
        switch (value) {
            case "fun":    return TokenKind.KFun;
            case "import": return TokenKind.KImport;
            default:
                return TokenKind.ConstID;
    }
}


    Token nextToken()
    {
        while (peek() == ' ' || peek() == '\t' || peek() == '\r')
            advance();

        Span span = Span(line, column, offset, 0, filename);
        if (isAtEnd())
            return Token(TokenKind.Eof, "", span);

        TokenKind kind;
        char c = advance();
        if (isAlpha(c))
        {
            while (isAlpha(peek()) || isDigit(peek()))
                advance();

            kind = getKeyword(source[span.offset .. offset]);
        }
        else if (isDigit(c))
        {
            while (isDigit(peek()))
                advance();
            kind = TokenKind.ConstNumber;
        }
        else if (c == '"')
        {
            while (!isAtEnd() && peek() != '"')
                advance();
            if (isAtEnd())
                throw new Exception(format("%s:%s:%s: unterminated string",
                    filename, span.line, span.column));

            advance();
            kind = TokenKind.ConstString;
        }
        else
        {
            switch (c)
            {
                case '(': kind = TokenKind.LParen; break;
                case ')': kind = TokenKind.RParen; break;
                case '{': kind = TokenKind.LBrace; break;
                case '}': kind = TokenKind.RBrace; break;
                case ',': kind = TokenKind.Comma; break;
                case '.': kind = TokenKind.Dot; break;
                case '\n': kind = TokenKind.NEWLINE; break;
                default:
                    throw new Exception(format("%s:%s:%s: unexpected byte 0x%02X",
                        filename, span.line, span.column, cast(ubyte) c));
            }
        }

        span.length = offset - span.offset;
        return Token(kind, source[span.offset .. offset], span);
    }
}
