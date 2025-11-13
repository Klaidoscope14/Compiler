%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int line_num = 1;
int token_count = 0;

void print_token(const char *type, const char *lexeme) {
    printf("%s(%s)\n", type, lexeme);
    token_count++;
}
%}

%x COMMENT

%%

"quit"            { print_token("QUIT", yytext); }
"exit"            { print_token("EXIT", yytext); }

[a-zA-Z]          { print_token("IDENTIFIER", yytext); }

[0-9]+            { print_token("NUMBER", yytext); }

"="               { print_token("ASSIGN", yytext); }
"+"               { print_token("PLUS", yytext); }
"-"               { print_token("MINUS", yytext); }
"*"               { print_token("MULTIPLY", yytext); }
"/"               { print_token("DIVIDE", yytext); }
"%"               { print_token("MODULO", yytext); }

"("               { print_token("LPAREN", yytext); }
")"               { print_token("RPAREN", yytext); }

"//".*            { /* ignore single-line comment */ }

"/*"              { BEGIN(COMMENT); }
<COMMENT>"*/"     { BEGIN(INITIAL); }
<COMMENT>\n       { line_num++; }
<COMMENT>.        { /* ignore inside comment */ }

[ \t]+            { /* ignore whitespace */ }

\n                { line_num++; print_token("NEWLINE", "\\n"); }

.                 {
                    printf("ERROR(%s) at line %d\n", yytext, line_num);
                  }

%%

int yywrap() { return 1; }