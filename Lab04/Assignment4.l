%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int total_tokens = 0;
int keyword_count = 0;
int identifier_count = 0;
int integer_count = 0;
int float_count = 0;
int hex_count = 0;
int string_count = 0;
int operator_count = 0;
int delimiter_count = 0;
int preprocessor_count = 0;
int comment_count = 0;
int error_count = 0;

void print_token(const char *type, const char *lexeme, int lineno) {
    printf("Line %d: %s (%s)\n", lineno, type, lexeme);
}
void print_stats(void) {
    printf("\n--- LEXER STATISTICS ---\n");
    printf("Total tokens: %d\n", total_tokens);
    printf("Keywords: %d\n", keyword_count);
    printf("Identifiers: %d\n", identifier_count);
    printf("Integers: %d\n", integer_count);
    printf("Floats: %d\n", float_count);
    printf("Hex Integers: %d\n", hex_count);
    printf("Strings: %d\n", string_count);
    printf("Operators: %d\n", operator_count);
    printf("Delimiters: %d\n", delimiter_count);
    printf("Preprocessors: %d\n", preprocessor_count);
    printf("Comments: %d\n", comment_count);
    printf("Errors: %d\n", error_count);
}

%}

%x STRING
%x COMMENT

DIGIT       [0-9]
HEX_DIGIT   [0-9a-fA-F]
ID_START    [A-Za-z]
ID_CONT     [A-Za-z0-9_]
WS          [ \t]+

%%

"//".*                              {
                                        comment_count++;
                                        total_tokens++;
                                        print_token("COMMENT_SINGLE", yytext, yylineno);
                                    }

"/*"                                { BEGIN(COMMENT); }
<COMMENT>[^*]+                      { /* consume */ }
<COMMENT>"*"+[^*/]*                 { /* consume */ }
<COMMENT>"*"+"/"                    {
                                        comment_count++;
                                        total_tokens++;
                                        print_token("COMMENT_MULTI", "/*...*/", yylineno);
                                        BEGIN(INITIAL);
                                    }
<COMMENT><<EOF>>                    {
                                        error_count++;
                                        fprintf(stderr, "Line %d: Unterminated comment\n", yylineno);
                                        BEGIN(INITIAL);
                                    }

^[ \t]*#include[^\n]*               {
                                        preprocessor_count++;
                                        total_tokens++;
                                        print_token("PREPROCESSOR", yytext, yylineno);
                                    }

"true"|"false"                      {
                                        keyword_count++;
                                        total_tokens++;
                                        print_token("KEYWORD", yytext, yylineno);
                                    }

"function"|"return"|"if"|"else"|"while"|"int"|"float"|"string" {
                                        keyword_count++;
                                        total_tokens++;
                                        print_token("KEYWORD", yytext, yylineno);
                                    }

0[xX]{HEX_DIGIT}+                   {
                                        hex_count++;
                                        total_tokens++;
                                        print_token("HEX_INTEGER", yytext, yylineno);
                                    }

{DIGIT}+([eE][+-]?{DIGIT}+)|{DIGIT}*"."{DIGIT}+([eE][+-]?{DIGIT}+)?    {
                                        float_count++;
                                        total_tokens++;
                                        print_token("FLOAT", yytext, yylineno);
                                    }

{DIGIT}+                            {
                                        integer_count++;
                                        total_tokens++;
                                        print_token("INTEGER", yytext, yylineno);
                                    }

\"                                   {
                                        BEGIN(STRING);
                                        yytext[0] = '\0';
                                        yyleng = 0;
                                    }

<STRING>\\n                          { /* keep escape */ }
<STRING>\\t                          { /* keep escape */ }
<STRING>\\\"                         { /* keep escape */ }
<STRING>\\\\                         { /* keep escape */ }
<STRING>[^"\\\n]+                    {
                                        /* accumulate via REJECT-less approach: print whole yytext on close */
                                    }
<STRING>\"                           {
                                        string_count++;
                                        total_tokens++;
                                        print_token("STRING", yytext, yylineno);
                                        BEGIN(INITIAL);
                                    }
<STRING><<EOF>>                      {
                                        error_count++;
                                        fprintf(stderr, "Line %d: Unterminated string literal\n", yylineno);
                                        BEGIN(INITIAL);
                                    }

"=="|"!="| "&&" | "||"               {
                                        operator_count++;
                                        total_tokens++;
                                        print_token("OPERATOR", yytext, yylineno);
                                    }
"="|"+"|"-"|"*"|"/"|"!"|"<"|">"       {
                                        operator_count++;
                                        total_tokens++;
                                        print_token("OPERATOR", yytext, yylineno);
                                    }

"(" | ")" | "{" | "}" | ";" | ","     {
                                        delimiter_count++;
                                        total_tokens++;
                                        print_token("DELIMITER", yytext, yylineno);
                                    }

{ID_START}{ID_CONT}*                 {
                                        identifier_count++;
                                        total_tokens++;
                                        print_token("IDENTIFIER", yytext, yylineno);
                                    }

{WS}                                 { /* ignore but track line */ }

\n                                   { /* incremented automatically by flex */ }

.                                     {
                                        error_count++;
                                        total_tokens++;
                                        fprintf(stderr, "Line %d: Unknown token '%s'\n", yylineno, yytext);
                                    }

%%

int yywrap(void) {
    return 1;
}