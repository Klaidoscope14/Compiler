%{
/* Name: Shreyas Kumar Jaiswal
   Roll No: 2301CS52
   CS3104 Compiler Lab, Autumn 2025 - Assignment 3 */
#include <stdio.h>
#include <stdlib.h>
int line_num = 1;
int token_count = 0;
%}

%%
[ \t]+                ;        // Ignore whitespace
"//".*                ;        // Ignore single-line comments
"/*"([^*]|\*+[^*/])*\*+"/"\n?  // Ignore multi-line comments

\n                    { printf("NEWLINE\n"); line_num++; token_count++; }
"quit"|"exit"         { printf("QUIT\n"); token_count++; }
[a-zA-Z]              { printf("IDENTIFIER(%s) ", yytext); token_count++; }
[0-9]+                { printf("NUMBER(%s) ", yytext); token_count++; }
"="                   { printf("ASSIGN "); token_count++; }
"+"                   { printf("PLUS "); token_count++; }
"-"                   { printf("MINUS "); token_count++; }
"*"                   { printf("MULTIPLY "); token_count++; }
"/"                   { printf("DIVIDE "); token_count++; }
"%"                   { printf("MODULO "); token_count++; }
"("                   { printf("LPAREN "); token_count++; }
")"                   { printf("RPAREN "); token_count++; }
.                     { printf("ERROR: Invalid token '%s' at line %d\n", yytext, line_num); }
%%


int yywrap() { return 1; }
