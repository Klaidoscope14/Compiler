%{
    /*
        Name    : Sreyas Kotha
        Roll No : 2301CS53
    */

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    int line_num = 1;
    int token_count = 0;

    // Print token with type and current line number
    void print_token(const char* type, const char* text) {
        printf("[Line %3d] %-30s %s\n", line_num, type, text);
        token_count++;
    }
%}

%%

[ \t]+                          ; // Ignore spaces and tabs

\n                              { line_num++; }

"~"                             { print_token("ACTIVE_CHARACTER", yytext); }

\\%                             { print_token("ESCAPED_PERCENT", yytext); }

\\[a-zA-Z]+                     { print_token("ALPHABETIC_COMMAND", yytext); }

\\[\\&%$#_{}~^\"'`=.cvHut|!,:; ] { print_token("SINGLE_CHARACTER", yytext); }

\\begin\{[a-zA-Z*]+\}           { print_token("BEGIN_ENV", yytext); }

\\end\{[a-zA-Z*]+\}             { print_token("END_ENV", yytext); }

\$([^$\\\n]|\\.)+\$             { print_token("INLINE_MATH", yytext); }

\$\$([^$\\\n]|\\.)+\$\$         { print_token("DISPLAY_MATH_DOUBLE_DOLLAR", yytext); }

\\\[([^\\\n]|\\.)+\\\]          { print_token("DISPLAY_MATH_BRACKETS", yytext); }

[^\\]%[^\n]*                    { print_token("COMMENT", yytext); }

.                               ; // Ignore all other characters

%%

int yywrap() { return 1; }

void run_lexer() {
    yylex();
    printf("\n==== Lexing Complete ====\nTotal tokens: %d\n", token_count);
}
