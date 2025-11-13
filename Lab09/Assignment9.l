%{
#include "y.tab.h"
#include <stdio.h>

void print_shift(const char* s) { printf("Shifting: %s\n", s); }
%}

%%

[ \t\n]+          ;
"("               { print_shift("("); return '('; }
")"               { print_shift(")"); return ')'; }
"+"               { print_shift("+"); return '+'; }
"-"               { print_shift("-"); return '-'; }
"*"               { print_shift("*"); return '*'; }
"/"               { print_shift("/"); return '/'; }
[a-zA-Z][a-zA-Z0-9]* { print_shift("id"); yylval.str = strdup(yytext); return ID; }

.                 { return yytext[0]; }

%%

int yywrap() { return 1; }