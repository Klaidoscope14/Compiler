%{
#include "y.tab.h"
#include <string.h>
#include <stdio.h>

extern int lineno;
extern int paren_depth;
void mark_paren_mismatch();
%}

DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*
WS      [ \t]+
CHARLIT \'([^\\\']|\\.)\'

%%

\n              { lineno++; }
{WS}            { }
"int"           { printf("Token: int\tType: KEYWORD\n"); return INT_T; }
"float"         { printf("Token: float\tType: KEYWORD\n"); return FLOAT_T; }
"char"          { printf("Token: char\tType: KEYWORD\n"); return CHAR_T; }

"="             { printf("Token: =\tType: ASSIGNMENT_OP\n"); return ASSIGN; }
";"             { printf("Token: ;\tType: SEMICOLON\n"); return SEMI; }
"+"             { printf("Token: +\tType: PLUS\n"); return PLUS; }
"*"             { printf("Token: *\tType: MUL\n"); return MUL; }
"("             { paren_depth++; printf("Token: (\tType: LPAREN\n"); return LPAREN; }
")"             { if(paren_depth>0) paren_depth--; printf("Token: )\tType: RPAREN\n"); return RPAREN; }

{CHARLIT}       { printf("Token: %s\tType: CHAR_LITERAL\n", yytext); yylval.str = strdup(yytext); return CHAR_LITERAL; }

{ID}            { printf("Token: %s\tType: IDENTIFIER\n", yytext); yylval.str = strdup(yytext); return IDENTIFIER; }

{DIGIT}+        { printf("Token: %s\tType: NUMBER\n", yytext); yylval.num = atoi(yytext); return NUMBER; }

.               { printf("Token: %s\tType: UNKNOWN\n", yytext); return yytext[0]; }

%%

void mark_paren_mismatch(){
    if(paren_depth > 0){}
}