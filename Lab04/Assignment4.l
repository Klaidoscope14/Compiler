%{
/* Name: Shreyas Kumar Jaiswal
   Roll No: 2301CS52
   CS3104 Compiler Lab, Autumn 2025 - Assignment 4 */
#include <stdio.h>
#include <stdlib.h>

int line_num = 1;
int token_count = 0;
int last_printed_line = 0;  // To track if line number printed this line

void print_line_number_if_needed() {
    if (last_printed_line != line_num) {
		if (line_num != 1) printf("\n");
        printf("Line %d:", line_num);
        last_printed_line = line_num;
    }
}
%}

%%

[ \t]+                ; // Ignore whitespace

\n                    { line_num++; last_printed_line = 0; }  // Reset line print on newline

"//".*                { 
                        print_line_number_if_needed();
                        printf(" COMMENT_SINGLE(%s)", yytext); 
                        token_count++; 
                      }

"/*"([^*]|\*+[^*/])*\*+"/"?  { 
                        print_line_number_if_needed();
                        printf(" COMMENT_MULTI(%s)", yytext); 
                        token_count++; 
                      }

"#define"|"#include"  { 
                        print_line_number_if_needed();
                        printf(" PREPROCESSOR(%s)", yytext); 
                        token_count++; 
                      }

"int"|"float"|"string"|"if"|"else"|"while"|"function"|"return"|"true"|"false"  { 
                        print_line_number_if_needed();
                        printf(" KEYWORD(%s)", yytext); 
                        token_count++; 
                      }

"=="|"!="|"<"|">"|"="|"+"|"-"|"*"|"/"|"%"|"&&"|"||"|"!" { 
                        print_line_number_if_needed();
                        printf(" OPERATOR(%s)", yytext); 
                        token_count++; 
                      }

"("                  { print_line_number_if_needed(); printf(" DELIMITER(()"); token_count++; }
")"                  { print_line_number_if_needed(); printf(" DELIMITER())"); token_count++; }
"{"                  { print_line_number_if_needed(); printf(" DELIMITER({)"); token_count++; }
"}"                  { print_line_number_if_needed(); printf(" DELIMITER(})"); token_count++; }
";"                  { print_line_number_if_needed(); printf(" DELIMITER(;)"); token_count++; }
","                  { print_line_number_if_needed(); printf(" DELIMITER(,)"); token_count++; }

\"([^\\\"]|\\[nt\"\\])*\"   { 
                        print_line_number_if_needed();
                        printf(" STRING(%s)", yytext);
                        token_count++; 
                      }

0[xX][0-9a-fA-F]+     { print_line_number_if_needed(); printf(" HEX(%s)", yytext); token_count++; }
0[0-7]+               { print_line_number_if_needed(); printf(" OCTAL(%s)", yytext); token_count++; }

[+-]?[0-9]+\.[0-9]*([eE][+-]?[0-9]+)?  { print_line_number_if_needed(); printf(" FLOAT(%s)", yytext); token_count++; }

[+-]?[0-9]+([eE][+-]?[0-9]+)             { print_line_number_if_needed(); printf(" FLOAT(%s)", yytext); token_count++; }

[0-9]+                { print_line_number_if_needed(); printf(" INTEGER(%s)", yytext); token_count++; }

[a-zA-Z_][a-zA-Z0-9_]*  { print_line_number_if_needed(); printf(" IDENTIFIER(%s)", yytext); token_count++; }

.                     { 
                        print_line_number_if_needed();
                        printf(" ERROR: Invalid token '%s'", yytext); 
                        token_count++; 
                      }

%%

int yywrap() { return 1; }
