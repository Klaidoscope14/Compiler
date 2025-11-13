%{
#include "y.tab.h"
%}

%%
"&&"    { return AND; }
"||"    { return OR; }
"\^\^"  { return XOR; }
"!"     { return NOT; }
"("     { return '('; }
")"     { return ')'; }
id      { yylval.str = strdup(yytext); return ID; }
[ \t\n]+ ;
.       { return yytext[0]; }
%%

int yywrap() { return 1; }