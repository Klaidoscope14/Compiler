%{
    // Name: Shreyas Kumar Jaiswal
    // Roll: 2301CS52 
    #include <stdio.h>
    #include "y.tab.h"
%}

%%

"||"            { printf("Shifting: ||\n"); return OR; }
"^^"            { printf("Shifting: ^^\n"); return XOR; }
"&&"            { printf("Shifting: &&\n"); return AND; }
"!"             { printf("Shifting: !\n"); return NOT; }
"("             { printf("Shifting: (\n"); return LPAREN; }
")"             { printf("Shifting: )\n"); return RPAREN; }
"id"            { printf("Shifting: id\n"); return ID; }
[ \t\n]+        ;     /* ignore whitespace */
.               { printf("Invalid character: %s\n", yytext); return INVALID; }

%%

int yywrap() {
    return 1;
}