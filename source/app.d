import std.stdio;
import marsh.lexer;
import marsh.token;

void main()
{
	string source = q{
		fun main() {
			println("hello world")
		}
	};

	Lexer lexer = Lexer(source, "main.marsh");

    while (true) {
        Token token = lexer.nextToken();

        writefln("%s: '%s'", token.kind, token.value);

        if (token.kind == TokenKind.Eof) {
            break;
        }
    }
}
