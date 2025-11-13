%{
#include "y.tab.h"
#include <stdio.h>
void printShift(const char* s){ printf("Shifting: %s\n", s); }
%}

%%

"if"            { printShift("if"); return IF; }
"else"          { printShift("else"); return ELSE; }
"while"         { printShift("while"); return WHILE; }

"=="            { printShift("=="); return RELOP; }
"!="            { printShift("!="); return RELOP; }
"<="            { printShift("<="); return RELOP; }
">="            { printShift(">="); return RELOP; }
"<"             { printShift("<"); return RELOP; }
">"             { printShift(">"); return RELOP; }

[0-9]+          { printShift("num"); yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { printShift("id"); yylval.str = strdup(yytext); return ID; }

"("             { printShift("("); return '('; }
")"             { printShift(")"); return ')'; }
"{"             { printShift("{"); return '{'; }
"}"             { printShift("}"); return '}'; }
";"             { printShift(";"); return ';'; }
"="             { printShift("="); return '='; }
"+"             { printShift("+"); return '+'; }
"-"             { printShift("-"); return '-'; }
"*"             { printShift("*"); return '*'; }
"/"             { printShift("/"); return '/'; }

[ \t\n]+        ;
.               { printf("Invalid token: %s\n", yytext); }

%%

int yywrap(){ return 1; }