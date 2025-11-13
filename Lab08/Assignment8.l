%{
    /*
    Name: Shreyas Kumar Jaiswal
    Roll: 2301CS52
    Date: 10/10/2025
    */

#include "y.tab.h"
#include <stdio.h>
extern int yylineno;

// Helper to print tokens
void print_token(const char* text, const char* type) {
    printf("Token: %-10s Type: %s\n", text, type);
}
%}

%%
int|float|char              { print_token(yytext, "KEYWORD"); return TYPE; }
[0-9]+(\.[0-9]+)?           { print_token(yytext, "NUMBER"); yylval.fval = atof(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*      { print_token(yytext, "IDENTIFIER"); yylval.sval = strdup(yytext); return ID; }
"="                         { print_token(yytext, "ASSIGNMENT_OP"); return ASSIGN; }
"+"                         { print_token(yytext, "PLUS"); return PLUS; }
"-"                         { print_token(yytext, "MINUS"); return MINUS; }
"*"                         { print_token(yytext, "MUL"); return MUL; }
"/"                         { print_token(yytext, "DIV"); return DIV; }
"("                         { print_token(yytext, "LPAREN"); return LPAREN; }
")"                         { print_token(yytext, "RPAREN"); return RPAREN; }
";"                         { print_token(yytext, "SEMICOLON"); return SEMICOLON; }
\'[^\']\'                   { print_token(yytext, "CHAR_LITERAL"); yylval.sval = strdup(yytext); return CHAR_LITERAL; }
[ \t]+                      { /* skip whitespace */ }
\n                          { return NEWLINE; }
.                           { print_token(yytext, "UNKNOWN"); return yytext[0]; }
%%

int yywrap() { return 1; }