%{
// Name: Shreyas Kumar Jaiswal
// Roll: 2301CS52
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_no = 1;
%}

/* Regular expressions */
ID          [a-zA-Z_][a-zA-Z0-9_]*
NUM         [0-9]+
RELOP       (==|!=|<=|>=|<|>)
%%
"if"            { printf("Shifting: if\n"); return IF; }
"else"          { printf("Shifting: else\n"); return ELSE; }
"while"         { printf("Shifting: while\n"); return WHILE; }

"("             { printf("Shifting: (\n"); return LPAREN; }
")"             { printf("Shifting: )\n"); return RPAREN; }
"{"             { printf("Shifting: {\n"); return LBRACE; }
"}"             { printf("Shifting: }\n"); return RBRACE; }
";"             { printf("Shifting: ;\n"); return SEMI; }
"="             { printf("Shifting: =\n"); return ASSIGNOP; }

"+"             { printf("Shifting: +\n"); return PLUS; }
"-"             { printf("Shifting: -\n"); return MINUS; }
"*"             { printf("Shifting: *\n"); return MUL; }
"/"             { printf("Shifting: /\n"); return DIV; }

{RELOP}         { printf("Shifting: %s\n", yytext); yylval.str = strdup(yytext); return RELOP; }
{ID}            { printf("Shifting: id (%s)\n", yytext); yylval.str = strdup(yytext); return ID; }
{NUM}           { printf("Shifting: num (%s)\n", yytext); yylval.str = strdup(yytext); return NUM; }

[ \t\r]+        ;   /* ignore whitespace */
\n              { line_no++; }

.               { printf("Unknown symbol '%s' at line %d\n", yytext, line_no); }

%%
int yywrap() {
    return 1;
}
