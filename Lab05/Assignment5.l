%option case-insensitive

%{
    /*
        Name: Shreyas Kumar Jaiswal
        Roll No: 2301CS52
        CS3104 Compiler Lab, Autumn 2025 - Assignment 5
    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int line_num = 1;
int token_count = 0;
int last_printed_line = 0;

// Token type counters
int keyword_count = 0;
int identifier_count = 0;
int int_count = 0;
int float_count = 0;
int string_count = 0;
int dollar_string_count = 0;
int hex_string_count = 0;
int param_count = 0;
int comment_single_count = 0;
int comment_multi_count = 0;
int operator_count = 0;
int delimiter_count = 0;
int error_count = 0;

void print_line_number_if_needed() {
    if (last_printed_line != line_num) {
        if (line_num != 1) printf("\n");
        printf("Line %d:", line_num);
        last_printed_line = line_num;
    }
}
%}

%%

[ \t]+                                        ; // Ignore whitespace
\n                                            { line_num++; last_printed_line = 0; }
"--".*                                        { print_line_number_if_needed(); printf(" COMMENT_SINGLE(%s)", yytext); comment_single_count++; token_count++; }
"/*"([^*]|\*+[^*/])*\*+"/"?                   { print_line_number_if_needed(); printf(" COMMENT_BLOCK(%s)", yytext); comment_multi_count++; token_count++; }

"SELECT"|"INSERT"|"UPDATE"|"DELETE"|"CREATE"|"TABLE"|"INTO"|"VALUES"|"WHERE"|"AND"|"OR"|"NOT"|"LIKE"|"IN"|"BETWEEN"|"JOIN"|"ON"|"AS"|"GROUP"|"BY"|"ORDER"|"ASC"|"DESC"|"LIMIT"|"OFFSET"|"NULL"|"TRUE"|"FALSE" { print_line_number_if_needed(); printf(" KEYWORD(%s)", yytext); keyword_count++; token_count++; }

"="|"<>"|"!="|"<"|">"|"<="|">="|"+"|"-"|"*"|"/"|"%"|"&&"|"||"|"!" { print_line_number_if_needed(); printf(" OPERATOR(%s)", yytext); operator_count++; token_count++; }

"("                                            { print_line_number_if_needed(); printf(" DELIMITER(()"); delimiter_count++; token_count++; }
")"                                            { print_line_number_if_needed(); printf(" DELIMITER())"); delimiter_count++; token_count++; }
"{"                                            { print_line_number_if_needed(); printf(" DELIMITER({)"); delimiter_count++; token_count++; }
"}"                                            { print_line_number_if_needed(); printf(" DELIMITER(})"); delimiter_count++; token_count++; }
";"                                            { print_line_number_if_needed(); printf(" DELIMITER(;)"); delimiter_count++; token_count++; }
","                                            { print_line_number_if_needed(); printf(" DELIMITER(,)"); delimiter_count++; token_count++; }
"."                                            { print_line_number_if_needed(); printf(" DELIMITER(.)"); delimiter_count++; token_count++; }

[a-zA-Z_][_a-zA-Z0-9]*                         { print_line_number_if_needed(); printf(" IDENTIFIER(%s)", yytext); identifier_count++; token_count++; }
\"([^\"\n]|\"\")*\"                            { print_line_number_if_needed(); printf(" QUOTED_IDENTIFIER(%s)", yytext); identifier_count++; token_count++; }
\[[^]\n]*\]                                    { print_line_number_if_needed(); printf(" BRACKET_IDENTIFIER(%s)", yytext); identifier_count++; token_count++; }

[+-]?[0-9]+\.[0-9]*([eE][+-]?[0-9]+)?          { print_line_number_if_needed(); printf(" FLOAT(%s)", yytext); float_count++; token_count++; }
[+-]?[0-9]+([eE][+-]?[0-9]+)                   { print_line_number_if_needed(); printf(" FLOAT(%s)", yytext); float_count++; token_count++; }
[0-9]+                                         { print_line_number_if_needed(); printf(" INTEGER(%s)", yytext); int_count++; token_count++; }

\$\$([^$]|\$)*\$\$                             { print_line_number_if_needed(); printf(" DOLLAR_QUOTED_STRING(%s)", yytext); dollar_string_count++; token_count++; }
\'([^\'\\\n]|\'\'|\\[nt\'\\])*\'               { print_line_number_if_needed(); printf(" STRING_LITERAL(%s)", yytext); string_count++; token_count++; }
X'([A-F0-9]{2})+'                              { print_line_number_if_needed(); printf(" HEX_STRING(%s)", yytext); hex_string_count++; token_count++; }

[:@][a-zA-Z_][a-zA-Z0-9_]*                     { print_line_number_if_needed(); printf(" PARAMETER(%s)", yytext); param_count++; token_count++; }
\?                                             { print_line_number_if_needed(); printf(" PARAMETER(?)"); param_count++; token_count++; }

.                                              { print_line_number_if_needed(); printf(" ERROR: Invalid token '%s'", yytext); error_count++; token_count++; }

%%

int yywrap() { return 1; }

void run_lexer() {
    yylex();
    printf("\n\n--- Lexical Analysis Summary ---\n");
    printf("Total Tokens: %d\n", token_count);
    printf("Keywords: %d\n", keyword_count);
    printf("Identifiers: %d\n", identifier_count);
    printf("Integer Literals: %d\n", int_count);
    printf("Float Literals: %d\n", float_count);
    printf("String Literals: %d\n", string_count);
    printf("Dollar-Quoted Strings: %d\n", dollar_string_count);
    printf("Hex Byte Strings: %d\n", hex_string_count);
    printf("Parameters: %d\n", param_count);
    printf("Single-line Comments: %d\n", comment_single_count);
    printf("Block Comments: %d\n", comment_multi_count);
    printf("Operators: %d\n", operator_count);
    printf("Delimiters: %d\n", delimiter_count);
    printf("Errors: %d\n", error_count);
}
